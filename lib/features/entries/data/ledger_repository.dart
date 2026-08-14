/// Local-first access to ledger entries.
library;

import 'dart:async';

import '../../../app/model/ledger.dart';
import '../../../core/db/app_database.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_op.dart';
import 'ledger_api.dart';
import 'ledger_local_datasource.dart';

/// What a sync attempt achieved. Kept for the Sync screen's summary line.
class SyncOutcome {
  const SyncOutcome({
    required this.accepted,
    required this.duplicates,
    required this.stillPending,
  });

  final int accepted;
  final int duplicates;
  final int stillPending;

  bool get isClean => stillPending == 0;
}

/// The contract the UI codes against.
///
/// An interface here rather than a bare class because the ledger is the one
/// feature with a genuinely swappable implementation: widget tests want a fake
/// that never touches SQLite, and the offline behaviour is worth being able to
/// stub precisely.
abstract class LedgerRepositoryContract {
  /// Live history for a business, newest first, straight from SQLite.
  Stream<List<LedgerEntry>> watchHistory(int businessId);

  /// One-shot history read.
  Future<List<LedgerEntry>> history(int businessId, {int limit = 200});

  /// Saves a new entry. Always succeeds — the row lands locally first.
  Future<String> submit({required int businessId, required LedgerEntry entry});

  /// Amends an entry, addressed by its client id so it works before the entry
  /// has a server id.
  Future<void> updateEntry({
    required String clientId,
    int? amountInr,
    String? categoryWire,
    DateTime? recordedAt,
  });
}

/// SQLite-backed implementation.
///
/// Every write lands in the local table and an outbox op, then returns. The
/// network is the sync engine's problem, not the save button's — which is the
/// whole point: on a rural connection the old flow made the user wait out a
/// 10-second timeout to be told their entry was queued anyway.
class LedgerRepository implements LedgerRepositoryContract {
  LedgerRepository({
    required LedgerLocalDataSource local,
    required OutboxDao outbox,
  }) : _local = local,
       _outbox = outbox;

  final LedgerLocalDataSource _local;
  final OutboxDao _outbox;

  @override
  Stream<List<LedgerEntry>> watchHistory(int businessId) =>
      _local.watchForBusiness(businessId);

  @override
  Future<List<LedgerEntry>> history(int businessId, {int limit = 200}) =>
      _local.forBusiness(businessId, limit: limit);

  @override
  Future<String> submit({
    required int businessId,
    required LedgerEntry entry,
  }) async {
    final String clientId = await _local.insertLocal(
      businessServerId: businessId,
      entry: entry,
    );

    await _outbox.enqueue(
      entity: SyncEntity.ledgerEntry,
      op: SyncOpKind.create,
      localRowId: clientId,
      businessServerId: businessId,
      payload: <String, dynamic>{
        'client_entry_id': clientId,
        'kind': LedgerApiMapper.kind(entry.kind),
        'amount_inr': entry.amountInr,
        'category': LedgerApiMapper.category(entry.category),
        'recorded_at': entry.recordedAt.toUtc().toIso8601String(),
        'source': LedgerApiMapper.source(entry.source),
      },
    );
    return clientId;
  }

  @override
  Future<void> updateEntry({
    required String clientId,
    int? amountInr,
    String? categoryWire,
    DateTime? recordedAt,
  }) async {
    await _local.updateLocal(
      clientId: clientId,
      amountInr: amountInr,
      categoryWire: categoryWire,
      recordedAt: recordedAt,
    );

    final LocalLedgerEntry? row = await _local.byClientId(clientId);
    if (row == null) return;

    // Editing an entry that has never been sent folds into its queued create
    // rather than queueing a PATCH — the outbox handles that collapse, this
    // just has to enqueue the right kind of op.
    await _outbox.enqueue(
      entity: SyncEntity.ledgerEntry,
      op: SyncOpKind.update,
      localRowId: clientId,
      serverId: row.serverId,
      businessServerId: row.businessServerId,
      payload: <String, dynamic>{
        'amount_inr': ?amountInr,
        'category': ?categoryWire,
        'recorded_at': ?recordedAt?.toUtc().toIso8601String(),
      },
    );
  }

  /// How many entries are waiting to reach the server.
  Future<int> pendingCount() async => (await _local.pendingRows()).length;
}
