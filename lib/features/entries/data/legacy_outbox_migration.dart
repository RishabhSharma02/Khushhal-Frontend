/// One-time move of the old Hive ledger outbox into Drift.
library;

import '../../../app/model/ledger.dart';
import '../../../core/db/app_database.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_op.dart';
import 'ledger_api.dart';
import 'ledger_local_datasource.dart';
import 'ledger_outbox.dart';

/// Drains `ledger_outbox_v1` into the Drift tables, once, on first launch after
/// the upgrade.
///
/// Users who were offline when they updated the app have real entries sitting
/// in that Hive box. Dropping the box without draining it would lose money the
/// user believes they recorded, so this runs before the sync engine starts and
/// is guarded by a flag in `sync_meta` so it cannot double-insert.
///
/// The entries keep their original `client_entry_id`, which means an entry that
/// actually did reach the server before the upgrade is recognised as a
/// duplicate rather than being written twice.
class LegacyOutboxMigration {
  LegacyOutboxMigration({
    required AppDatabase db,
    required LedgerLocalDataSource local,
    required OutboxDao outbox,
  }) : _db = db,
       _local = local,
       _outbox = outbox;

  final AppDatabase _db;
  final LedgerLocalDataSource _local;
  final OutboxDao _outbox;

  /// Returns how many entries were carried over.
  Future<int> run(LedgerOutbox legacy) async {
    final String? done = await _db.readMeta(SyncMetaKeys.hiveOutboxDrained);
    if (done == 'true') return 0;

    int migrated = 0;
    final Map<int, List<Map<String, dynamic>>> grouped = legacy
        .pendingByBusiness();

    for (final MapEntry<int, List<Map<String, dynamic>>> group
        in grouped.entries) {
      for (final Map<String, dynamic> payload in group.value) {
        final String? clientId = payload['client_entry_id'] as String?;
        if (clientId == null) continue;

        // Already carried over by an interrupted run.
        if (await _local.byClientId(clientId) != null) continue;

        final LedgerEntry entry = LedgerEntry(
          kind: LedgerApiMapper.kindFromWire(payload['kind'] as String),
          amountInr: payload['amount_inr'] as int,
          category: LedgerApiMapper.categoryFromWire(
            payload['category'] as String,
          ),
          recordedAt: DateTime.parse(payload['recorded_at'] as String),
          source: LedgerApiMapper.sourceFromWire(
            (payload['source'] as String?) ?? 'manual',
          ),
        );

        await _local.insertLocal(
          businessServerId: group.key,
          entry: entry,
          clientId: clientId,
        );
        await _outbox.enqueue(
          entity: SyncEntity.ledgerEntry,
          op: SyncOpKind.create,
          localRowId: clientId,
          businessServerId: group.key,
          payload: payload,
        );
        migrated++;
      }
    }

    await _db.writeMeta(SyncMetaKeys.hiveOutboxDrained, 'true');
    // Only clear once the flag is committed: a crash between the two would
    // otherwise drop entries that were never recorded as migrated.
    await legacy.clear();
    return migrated;
  }
}
