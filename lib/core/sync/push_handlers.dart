/// Turns queued outbox ops into HTTP calls.
///
/// Every handler reads the *current* local row and builds the request body from
/// it, rather than trusting the payload captured at enqueue time. Coalescing
/// merges payloads, but a row can also be edited between the merge and the
/// drain; reading at send time means the server always receives what the
/// database currently says, never a stale intermediate value.
library;

import '../../features/auth/data/profile_local_datasource.dart';
import '../../features/auth/data/profile_remote_datasource.dart';
import '../../features/businesses/data/business_local_datasource.dart';
import '../../features/businesses/data/business_remote_datasource.dart';
import '../../features/entries/data/ledger_local_datasource.dart';
import '../../features/entries/data/ledger_remote_datasource.dart';
import '../../features/insights/data/insights_local_datasource.dart';
import '../../features/insights/data/insights_remote_datasource.dart';
import '../db/app_database.dart';
import '../network/api_exception.dart';
import 'sync_op.dart';

/// How a single push attempt ended.
enum PushOutcome {
  /// The server accepted it. The op can be removed.
  success,

  /// Not sendable yet through no fault of its own — typically an update whose
  /// row has no server id because its create has not landed. Stays queued
  /// without counting as a failure.
  deferred,

  /// Worth trying again later: offline, timeout, 5xx.
  retryable,

  /// The server refused and will refuse again. Dead-letter it.
  permanent,
}

/// The result of pushing one op.
class PushResult {
  const PushResult(this.outcome, {this.error});

  const PushResult.success() : outcome = PushOutcome.success, error = null;
  const PushResult.deferred(String reason)
    : outcome = PushOutcome.deferred,
      error = reason;

  final PushOutcome outcome;
  final String? error;
}

/// Routes an op to the endpoint that serves it.
class PushDispatcher {
  PushDispatcher({
    required LedgerLocalDataSource ledgerLocal,
    required LedgerRemoteDataSource ledgerRemote,
    required BusinessLocalDataSource businessLocal,
    required BusinessRemoteDataSource businessRemote,
    required ProfileLocalDataSource profileLocal,
    required ProfileRemoteDataSource profileRemote,
    required InsightsLocalDataSource insightsLocal,
    required InsightsRemoteDataSource insightsRemote,
  }) : _ledgerLocal = ledgerLocal,
       _ledgerRemote = ledgerRemote,
       _businessLocal = businessLocal,
       _businessRemote = businessRemote,
       _profileLocal = profileLocal,
       _profileRemote = profileRemote,
       _insightsLocal = insightsLocal,
       _insightsRemote = insightsRemote;

  final LedgerLocalDataSource _ledgerLocal;
  final LedgerRemoteDataSource _ledgerRemote;
  final BusinessLocalDataSource _businessLocal;
  final BusinessRemoteDataSource _businessRemote;
  final ProfileLocalDataSource _profileLocal;
  final ProfileRemoteDataSource _profileRemote;
  final InsightsLocalDataSource _insightsLocal;
  final InsightsRemoteDataSource _insightsRemote;

  /// Sends one op and reports how it went. Never throws.
  Future<PushResult> push(SyncOpRow op) async {
    try {
      return await _dispatch(op);
    } on ApiException catch (e) {
      return PushResult(
        e.isRetryable ? PushOutcome.retryable : PushOutcome.permanent,
        error: e.message,
      );
    } on Object catch (e) {
      // An unexpected error is not evidence the server would refuse again, so
      // treat it as retryable and let the attempt counter bound it.
      return PushResult(PushOutcome.retryable, error: e.toString());
    }
  }

  Future<PushResult> _dispatch(SyncOpRow op) {
    return switch (op.entity) {
      SyncEntity.ledgerEntry => _pushLedger(op),
      SyncEntity.business => _pushBusiness(op),
      SyncEntity.userProfile => _pushProfile(op),
      SyncEntity.savingsLoan => _pushSavingsLoan(op),
      SyncEntity.planAction => _pushPlanAction(op),
    };
  }

  // ── Ledger ─────────────────────────────────────────────────────────────

  Future<PushResult> _pushLedger(SyncOpRow op) async {
    final LocalLedgerEntry? row = await _ledgerLocal.byClientId(op.localRowId);
    if (row == null) {
      // The row is gone but the op survived — nothing left to send.
      return const PushResult.success();
    }

    switch (op.op) {
      case SyncOpKind.create:
        // Creates are batched per business by the engine, not sent one at a
        // time, so reaching here means the batch pass skipped it.
        return const PushResult.deferred('handled by batch pass');

      case SyncOpKind.update:
        final int? serverId = row.serverId;
        if (serverId == null) {
          // The create has not landed yet, so there is no URL to PATCH. Wait
          // for the id-resolution pass rather than failing.
          return const PushResult.deferred('awaiting server id');
        }
        await _ledgerRemote.updateEntry(
          businessId: row.businessServerId,
          entryId: serverId,
          amountInr: row.amountInr,
          categoryWire: row.category,
          recordedAt: row.recordedAt,
        );
        await _ledgerLocal.markSynced(row.clientId, serverId: serverId);
        return const PushResult.success();

      case SyncOpKind.delete:
        // The backend exposes no ledger delete; the UI offers none either.
        return const PushResult(
          PushOutcome.permanent,
          error: 'Deleting entries is not supported',
        );
    }
  }

  // ── Business ───────────────────────────────────────────────────────────

  Future<PushResult> _pushBusiness(SyncOpRow op) async {
    final LocalBusiness? row = await _businessLocal.byClientId(op.localRowId);
    if (row == null) return const PushResult.success();

    final int? serverId = row.serverId;
    if (serverId == null) {
      // Businesses are created online only, so this should be unreachable; if
      // it happens the row is unsendable and looping would not help.
      return const PushResult(
        PushOutcome.permanent,
        error: 'Business has no server id',
      );
    }

    switch (op.op) {
      case SyncOpKind.update:
        await _businessRemote.update(
          serverId,
          name: row.name,
          staffCount: row.staffCount,
          tenure: row.tenure,
          savingsInr: row.savingsInr,
          loanInr: row.loanInr,
        );
        await _businessLocal.markSynced(row.clientId);
        return const PushResult.success();

      case SyncOpKind.delete:
        await _businessRemote.softDelete(serverId);
        return const PushResult.success();

      case SyncOpKind.create:
        return const PushResult(
          PushOutcome.permanent,
          error: 'Creating a business requires a connection',
        );
    }
  }

  // ── Profile ────────────────────────────────────────────────────────────

  Future<PushResult> _pushProfile(SyncOpRow op) async {
    final LocalUser? user = await _profileLocal.activeUser();
    if (user == null) return const PushResult.success();

    if (op.op != SyncOpKind.update) {
      return const PushResult(
        PushOutcome.permanent,
        error: 'Only profile updates are supported',
      );
    }

    await _profileRemote.patchMe(
      name: user.name,
      language: user.language,
      state: user.state,
      district: user.district,
      village: user.village,
      notificationsEnabled: user.notificationsEnabled,
    );
    await _profileLocal.markSynced(user.clientId);
    return const PushResult.success();
  }

  Future<PushResult> _pushSavingsLoan(SyncOpRow op) async {
    final LocalUser? user = await _profileLocal.activeUser();
    if (user == null) return const PushResult.success();

    if (op.op != SyncOpKind.update) {
      return const PushResult(
        PushOutcome.permanent,
        error: 'Only savings and loan updates are supported',
      );
    }

    await _profileRemote.patchSavingsLoan(
      savingsInr: user.savingsInr,
      loanInr: user.loanInr,
    );
    await _profileLocal.markSynced(user.clientId);
    return const PushResult.success();
  }

  // ── Plan actions ───────────────────────────────────────────────────────

  Future<PushResult> _pushPlanAction(SyncOpRow op) async {
    final LocalPlanAction? row = await _insightsLocal.planActionByClientId(
      op.localRowId,
    );
    if (row == null) return const PushResult.success();

    final int? serverId = row.serverId;
    if (serverId == null) {
      return const PushResult(
        PushOutcome.permanent,
        error: 'Plan action has no server id',
      );
    }

    if (op.op != SyncOpKind.update) {
      return const PushResult(
        PushOutcome.permanent,
        error: 'Only plan action updates are supported',
      );
    }

    await _insightsRemote.togglePlanAction(
      businessId: row.businessServerId,
      alertId: row.alertServerId,
      actionId: serverId,
      done: row.done,
    );
    await _insightsLocal.markPlanActionSynced(row.clientId);
    return const PushResult.success();
  }

  // ── Batched ledger creates ─────────────────────────────────────────────

  /// Pushes every pending ledger create for one business in a single request.
  ///
  /// Batching matters on a rural connection: a week of offline entries is one
  /// round trip instead of thirty, and the endpoint's `ON CONFLICT DO NOTHING`
  /// on `(business_id, client_entry_id)` makes replaying a half-failed batch
  /// harmless.
  Future<PushResult> pushLedgerBatch({
    required int businessServerId,
    required List<LocalLedgerEntry> rows,
  }) async {
    if (rows.isEmpty) return const PushResult.success();
    try {
      await _ledgerRemote.syncBatch(
        businessId: businessServerId,
        entries: rows
            .map(LedgerLocalDataSource.toSyncPayload)
            .toList(growable: false),
      );
      return const PushResult.success();
    } on ApiException catch (e) {
      return PushResult(
        e.isRetryable ? PushOutcome.retryable : PushOutcome.permanent,
        error: e.message,
      );
    } on Object catch (e) {
      return PushResult(PushOutcome.retryable, error: e.toString());
    }
  }

  /// Reads back the entries for a business so locally-created rows can learn
  /// their server ids, matched on `client_entry_id`.
  ///
  /// The batch endpoint returns `accepted_ids` without saying which client id
  /// each belongs to, so this extra read is the only way to build the mapping.
  /// Without it an entry created offline could never be edited afterwards.
  Future<int> resolveServerIds(int businessServerId) async {
    final page = await _ledgerRemote.list(
      businessId: businessServerId,
      limit: 200,
    );
    final Map<String, int> mapping = <String, int>{};
    for (final Map<String, dynamic> row in page.items) {
      final String? clientId = row['client_entry_id'] as String?;
      final int? id = row['id'] as int?;
      if (clientId != null && id != null) mapping[clientId] = id;
    }
    return _ledgerLocal.attachServerIds(mapping);
  }
}
