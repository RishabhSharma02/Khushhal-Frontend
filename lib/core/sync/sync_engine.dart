/// Orchestrates the push-then-pull cycle.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../features/entries/data/ledger_local_datasource.dart';
import '../db/app_database.dart';
import 'connectivity_monitor.dart';
import 'outbox_dao.dart';
import 'pull_handlers.dart';
import 'push_handlers.dart';
import 'sync_op.dart';
import 'sync_status.dart';

/// What one cycle achieved.
@immutable
class SyncCycleResult {
  const SyncCycleResult({
    this.pushed = 0,
    this.deferred = 0,
    this.failed = 0,
    this.stillPending = 0,
    this.skippedOffline = false,
  });

  final int pushed;
  final int deferred;
  final int failed;
  final int stillPending;

  /// True when the cycle did not run because there was no connection.
  final bool skippedOffline;

  /// True when nothing is left waiting.
  bool get isClean => stillPending == 0 && failed == 0 && !skippedOffline;

  @override
  String toString() =>
      'SyncCycleResult(pushed: $pushed, deferred: $deferred, '
      'failed: $failed, pending: $stillPending)';
}

/// Drains the outbox, then refreshes the cache.
///
/// This class is deliberately cross-feature. Sync is not something any one
/// feature owns: the ordering guarantees only mean anything if a single
/// component decides when everything moves.
///
/// Triggers, all funnelling into the same single-flight [syncNow]:
///
/// - the connection coming back
/// - the app returning to the foreground
/// - a periodic timer while the app is open
/// - the user tapping "Sync now"
/// - logging out, before any local data is wiped
class SyncEngine with WidgetsBindingObserver {
  SyncEngine({
    required AppDatabase db,
    required OutboxDao outbox,
    required PushDispatcher push,
    required PullService pull,
    required ConnectivityMonitor connectivity,
    required SyncStatusController status,
    required LedgerLocalDataSource ledgerLocal,
    this.pollInterval = const Duration(minutes: 5),
  }) : _db = db,
       _outbox = outbox,
       _push = push,
       _pull = pull,
       _connectivity = connectivity,
       _status = status,
       _ledgerLocal = ledgerLocal;

  final AppDatabase _db;
  final OutboxDao _outbox;
  final PushDispatcher _push;
  final PullService _pull;
  final ConnectivityMonitor _connectivity;
  final SyncStatusController _status;
  final LedgerLocalDataSource _ledgerLocal;

  /// How often to attempt a cycle while the app is open and online.
  final Duration pollInterval;

  StreamSubscription<void>? _reconnectSub;
  StreamSubscription<List<SyncOpRow>>? _outboxSub;
  Timer? _poll;

  /// Guards the cycle. Two concurrent drains would double-send ops and race on
  /// the revision guard, so a second caller waits for the first instead.
  Future<SyncCycleResult>? _inFlight;

  bool _started = false;

  /// Begins listening for triggers and publishing status.
  Future<void> start({String? firebaseUid}) async {
    if (_started) return;
    _started = true;
    _firebaseUid = firebaseUid;

    _status.setOnline(_connectivity.isOnline.value);
    _connectivity.isOnline.addListener(_onConnectivityValue);
    _reconnectSub = _connectivity.onReconnected.listen((_) {
      unawaited(syncNow());
    });

    // Keep the chip's counts honest without anyone having to remember to
    // refresh them: the outbox is a table, so watching it is free.
    _outboxSub = _outbox.watchAll().listen(_publishCounts);

    _poll = Timer.periodic(pollInterval, (_) => unawaited(syncNow()));
    WidgetsBinding.instance.addObserver(this);

    _status.setLastFullSync(
      await _db.readMetaTime(SyncMetaKeys.lastFullSync),
    );
  }

  String? _firebaseUid;

  /// Updates the identity used when mirroring `/me`, after a sign-in.
  set firebaseUid(String? value) => _firebaseUid = value;

  void _onConnectivityValue() {
    _status.setOnline(_connectivity.isOnline.value);
  }

  void _publishCounts(List<SyncOpRow> ops) {
    int pending = 0;
    int failed = 0;
    for (final SyncOpRow op in ops) {
      if (op.deadLettered) {
        failed++;
      } else {
        pending++;
      }
    }
    _status.setCounts(pending: pending, failed: failed);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Coming back from the background is the most likely moment for the
      // connection to have changed underneath us, so re-probe before deciding.
      unawaited(_connectivity.refresh().then((_) => syncNow()));
    }
  }

  // ── The cycle ──────────────────────────────────────────────────────────

  /// Runs a full cycle, or joins the one already running.
  Future<SyncCycleResult> syncNow() {
    final Future<SyncCycleResult>? running = _inFlight;
    if (running != null) return running;

    final Future<SyncCycleResult> cycle = _runCycle();
    _inFlight = cycle;
    return cycle.whenComplete(() => _inFlight = null);
  }

  Future<SyncCycleResult> _runCycle() async {
    final bool online = await _connectivity.refresh();
    if (!online) {
      _status.setOnline(false);
      return const SyncCycleResult(skippedOffline: true);
    }

    _status.setBusy(true);
    try {
      final SyncCycleResult pushResult = await _drainOutbox();
      await _pull.pullAll(firebaseUid: _firebaseUid);

      final int pending = await _outbox.pendingCount();
      final int failed = await _outbox.failedCount();
      _status.setCounts(pending: pending, failed: failed);

      if (pending == 0 && failed == 0) {
        final DateTime now = DateTime.now();
        await _db.writeMetaTime(SyncMetaKeys.lastFullSync, now);
        _status.setLastFullSync(now);
      }

      return SyncCycleResult(
        pushed: pushResult.pushed,
        deferred: pushResult.deferred,
        failed: failed,
        stillPending: pending,
      );
    } finally {
      _status.setBusy(false);
    }
  }

  /// Phase one: get everything local onto the server.
  ///
  /// Ledger creates go first, as one batch per business, then their server ids
  /// are resolved, and only then does the FIFO drain run. That ordering is a
  /// dependency, not an optimisation: an entry created and then edited offline
  /// produces an update whose PATCH URL needs the id the create hands back.
  /// Ops for different entities are independent resources, so batching creates
  /// ahead of them costs no correctness.
  Future<SyncCycleResult> _drainOutbox() async {
    final List<SyncOpRow> ready = await _outbox.claimReady();
    if (ready.isEmpty) return const SyncCycleResult();

    int pushed = 0;
    int deferred = 0;

    final List<SyncOpRow> creates = ready
        .where(
          (o) =>
              o.entity == SyncEntity.ledgerEntry && o.op == SyncOpKind.create,
        )
        .toList(growable: false);

    pushed += await _drainLedgerCreates(creates);

    for (final SyncOpRow op in ready) {
      if (creates.contains(op)) continue;

      final PushResult result = await _push.push(op);
      switch (result.outcome) {
        case PushOutcome.success:
          await _outbox.completeIfUnchanged(op);
          pushed++;
        case PushOutcome.deferred:
          deferred++;
        case PushOutcome.retryable:
          await _outbox.recordFailure(
            op,
            error: result.error ?? 'Sync failed',
            retryable: true,
          );
        case PushOutcome.permanent:
          await _outbox.recordFailure(
            op,
            error: result.error ?? 'Rejected by server',
            retryable: false,
          );
          await _markRowFailed(op);
      }
    }

    return SyncCycleResult(pushed: pushed, deferred: deferred);
  }

  Future<int> _drainLedgerCreates(List<SyncOpRow> creates) async {
    if (creates.isEmpty) return 0;

    // Group by business so each request hits one endpoint with a homogeneous
    // batch, which is what `/entries/sync` expects.
    final Map<int, List<SyncOpRow>> byBusiness = <int, List<SyncOpRow>>{};
    final Map<String, LocalLedgerEntry> rowByClientId =
        <String, LocalLedgerEntry>{};

    for (final SyncOpRow op in creates) {
      final LocalLedgerEntry? row = await _ledgerLocal.byClientId(
        op.localRowId,
      );
      if (row == null) {
        await _outbox.completeIfUnchanged(op);
        continue;
      }
      rowByClientId[op.localRowId] = row;
      byBusiness.putIfAbsent(row.businessServerId, () => <SyncOpRow>[]).add(op);
    }

    int pushed = 0;
    for (final MapEntry<int, List<SyncOpRow>> entry in byBusiness.entries) {
      final List<LocalLedgerEntry> rows = entry.value
          .map((o) => rowByClientId[o.localRowId]!)
          .toList(growable: false);

      final PushResult result = await _push.pushLedgerBatch(
        businessServerId: entry.key,
        rows: rows,
      );

      switch (result.outcome) {
        case PushOutcome.success:
          for (final SyncOpRow op in entry.value) {
            await _outbox.completeIfUnchanged(op);
            await _ledgerLocal.markSynced(op.localRowId);
            pushed++;
          }
          // Learn the ids the backend assigned, so these rows become editable.
          await _push.resolveServerIds(entry.key);

        case PushOutcome.deferred:
          break;

        case PushOutcome.retryable:
          for (final SyncOpRow op in entry.value) {
            await _outbox.recordFailure(
              op,
              error: result.error ?? 'Sync failed',
              retryable: true,
            );
          }

        case PushOutcome.permanent:
          for (final SyncOpRow op in entry.value) {
            await _outbox.recordFailure(
              op,
              error: result.error ?? 'Rejected by server',
              retryable: false,
            );
            await _ledgerLocal.markFailed(op.localRowId);
          }
      }
    }
    return pushed;
  }

  Future<void> _markRowFailed(SyncOpRow op) async {
    // Mirrors the dead-letter onto the row itself so the list the user is
    // looking at can show which item did not save, not just a count.
    switch (op.entity) {
      case SyncEntity.ledgerEntry:
        await _ledgerLocal.markFailed(op.localRowId);
      case SyncEntity.business:
      case SyncEntity.userProfile:
      case SyncEntity.savingsLoan:
      case SyncEntity.planAction:
        // These surface through the Sync screen's failed section; their rows
        // keep the local value until the next pull replaces it.
        break;
    }
  }

  // ── Manual controls ────────────────────────────────────────────────────

  /// Clears every dead-letter and runs a cycle. Backs the Sync screen's retry.
  Future<SyncCycleResult> retryFailed() async {
    await _outbox.retryFailed();
    return syncNow();
  }

  /// Runs a final cycle before signing out, so nothing is lost silently.
  ///
  /// Returns how many ops are still unsent. The caller uses that to decide
  /// whether to warn the user before wiping the database.
  Future<int> flushBeforeLogout() async {
    final int before = await _outbox.pendingCount();
    if (before == 0 && await _outbox.failedCount() == 0) return 0;

    await syncNow();
    return (await _outbox.pendingCount()) + (await _outbox.failedCount());
  }

  void dispose() {
    _poll?.cancel();
    _reconnectSub?.cancel();
    _outboxSub?.cancel();
    _connectivity.isOnline.removeListener(_onConnectivityValue);
    if (_started) WidgetsBinding.instance.removeObserver(this);
    _started = false;
  }
}
