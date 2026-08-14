/// Read and write access to the outbox.
library;

import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'sync_op.dart';

/// How many failures an op gets before it stops being retried automatically.
const int kMaxSyncAttempts = 6;

/// The queue of writes waiting to reach the server.
///
/// Two properties matter and are enforced here rather than by callers:
///
/// 1. **FIFO.** Ops drain in insertion order so a ledger entry's create is
///    always pushed before the update that amends it.
/// 2. **Coalescing.** Editing the same field five times offline must not
///    produce five round trips when the connection returns. Repeat writes to a
///    row collapse into the op already queued for it.
class OutboxDao {
  OutboxDao(this._db);

  final AppDatabase _db;

  // ── Writing ────────────────────────────────────────────────────────────

  /// Queues a write, collapsing it into an existing op where that is
  /// equivalent. Returns the id of the op that now represents this write.
  ///
  /// The three collapse cases:
  ///
  /// - **update onto a pending create** — the create has not been sent, so the
  ///   edit is folded into its body and no PATCH is queued. This is the case
  ///   that makes "add an entry offline, then correct the amount" work: there
  ///   is no server id yet to PATCH against, so a separate update op would be
  ///   unsendable.
  /// - **update onto a pending update** — payloads merge field-by-field, newest
  ///   value winning.
  /// - **delete onto a pending create** — the row never reached the server, so
  ///   both ops disappear and nothing is sent.
  Future<int> enqueue({
    required SyncEntity entity,
    required SyncOpKind op,
    required String localRowId,
    Map<String, dynamic> payload = const <String, dynamic>{},
    int? serverId,
    int? businessServerId,
  }) async {
    return _db.transaction(() async {
      final SyncOpRow? pendingCreate = await _findOp(
        entity: entity,
        op: SyncOpKind.create,
        localRowId: localRowId,
      );

      switch (op) {
        case SyncOpKind.delete:
          if (pendingCreate != null) {
            await _deleteOpsForRow(entity: entity, localRowId: localRowId);
            return pendingCreate.id;
          }

        case SyncOpKind.update:
          if (pendingCreate != null) {
            return _mergeInto(pendingCreate, payload, serverId: serverId);
          }
          final SyncOpRow? pendingUpdate = await _findOp(
            entity: entity,
            op: SyncOpKind.update,
            localRowId: localRowId,
          );
          if (pendingUpdate != null) {
            return _mergeInto(pendingUpdate, payload, serverId: serverId);
          }

        case SyncOpKind.create:
          if (pendingCreate != null) {
            return _mergeInto(pendingCreate, payload, serverId: serverId);
          }
      }

      return _db
          .into(_db.syncOps)
          .insert(
            SyncOpsCompanion.insert(
              entity: entity,
              op: op,
              localRowId: localRowId,
              dedupeKey: SyncOp.keyFor(
                entity: entity,
                op: op,
                localRowId: localRowId,
              ),
              payload: Value(encodeSyncPayload(payload)),
              serverId: Value(serverId),
              businessServerId: Value(businessServerId),
            ),
          );
    });
  }

  Future<SyncOpRow?> _findOp({
    required SyncEntity entity,
    required SyncOpKind op,
    required String localRowId,
  }) {
    return (_db.select(_db.syncOps)..where(
          (t) =>
              t.dedupeKey.equals(
                SyncOp.keyFor(entity: entity, op: op, localRowId: localRowId),
              ) &
              t.deadLettered.equals(false),
        ))
        .getSingleOrNull();
  }

  /// Folds [patch] into an existing op's payload and bumps its revision.
  ///
  /// Keeps the original row id, and therefore the original queue position, so
  /// coalescing never reorders an op relative to other entities' ops.
  Future<int> _mergeInto(
    SyncOpRow existing,
    Map<String, dynamic> patch, {
    int? serverId,
  }) async {
    final Map<String, dynamic> merged = <String, dynamic>{
      ...decodeSyncPayload(existing.payload),
      ...patch,
    };

    await (_db.update(_db.syncOps)..where((t) => t.id.equals(existing.id)))
        .write(
          SyncOpsCompanion(
            payload: Value(encodeSyncPayload(merged)),
            revision: Value(existing.revision + 1),
            serverId: Value(serverId ?? existing.serverId),
            // A fresh edit deserves a fresh attempt: clear the backoff so the
            // user's newest change is not stuck behind a penalty earned by the
            // value they have since replaced.
            attempts: const Value(0),
            nextAttemptAt: Value(DateTime.now()),
            lastError: const Value(null),
          ),
        );
    return existing.id;
  }

  Future<void> _deleteOpsForRow({
    required SyncEntity entity,
    required String localRowId,
  }) async {
    await (_db.delete(_db.syncOps)..where(
          (t) => t.entity.equalsValue(entity) & t.localRowId.equals(localRowId),
        ))
        .go();
  }

  // ── Draining ───────────────────────────────────────────────────────────

  /// Ops that are due right now, oldest first.
  ///
  /// Excludes dead-lettered ops and anything still inside its backoff window.
  Future<List<SyncOpRow>> claimReady({int limit = 100}) {
    final DateTime now = DateTime.now();
    return (_db.select(_db.syncOps)
          ..where(
            (t) =>
                t.deadLettered.equals(false) &
                t.nextAttemptAt.isSmallerOrEqualValue(now),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(limit))
        .get();
  }

  /// Removes an op after the server accepted it.
  ///
  /// The revision guard is the important part: if the user edited the same row
  /// while this request was in flight, [_mergeInto] bumped the revision, this
  /// delete matches nothing, and the newer payload stays queued. Without it the
  /// acknowledgement of the old value would silently discard the new one.
  Future<bool> completeIfUnchanged(SyncOpRow claimed) async {
    final int deleted =
        await (_db.delete(_db.syncOps)..where(
              (t) =>
                  t.id.equals(claimed.id) &
                  t.revision.equals(claimed.revision),
            ))
            .go();
    return deleted > 0;
  }

  /// Records a failed attempt, scheduling a retry or giving up.
  ///
  /// [retryable] comes from `ApiException.isRetryable`: a 4xx means the server
  /// understood the request and refused it, so replaying the identical body
  /// would be refused identically. Those dead-letter immediately rather than
  /// burning six attempts to reach the same conclusion.
  Future<void> recordFailure(
    SyncOpRow claimed, {
    required String error,
    required bool retryable,
  }) async {
    final int attempts = claimed.attempts + 1;
    final bool giveUp = !retryable || attempts >= kMaxSyncAttempts;

    await (_db.update(_db.syncOps)..where((t) => t.id.equals(claimed.id)))
        .write(
          SyncOpsCompanion(
            attempts: Value(attempts),
            lastError: Value(error),
            deadLettered: Value(giveUp),
            nextAttemptAt: Value(DateTime.now().add(backoffFor(attempts))),
          ),
        );
  }

  /// Exponential backoff, capped so a long offline stretch does not push the
  /// next attempt hours out and leave the user staring at a stale queue.
  static Duration backoffFor(int attempts) {
    const Duration base = Duration(seconds: 5);
    const Duration cap = Duration(minutes: 10);
    final int factor = 1 << (attempts.clamp(1, 8) - 1);
    final Duration delay = base * factor;
    return delay > cap ? cap : delay;
  }

  /// Clears the dead-letter flag and backoff on every failed op, so the Sync
  /// screen's retry button gets a genuine fresh start.
  Future<void> retryFailed() async {
    await (_db.update(_db.syncOps)..where((t) => t.deadLettered.equals(true)))
        .write(
          SyncOpsCompanion(
            deadLettered: const Value(false),
            attempts: const Value(0),
            lastError: const Value(null),
            nextAttemptAt: Value(DateTime.now()),
          ),
        );
  }

  /// Drops an op the user chose to abandon. The next pull overwrites the local
  /// row with the server's version.
  Future<void> discard(int opId) async {
    await (_db.delete(_db.syncOps)..where((t) => t.id.equals(opId))).go();
  }

  /// Removes every queued op. Used on logout, after the user has been warned.
  Future<void> clear() async {
    await _db.delete(_db.syncOps).go();
  }

  // ── Reading ────────────────────────────────────────────────────────────

  /// Ops still expected to succeed on their own.
  Future<int> pendingCount() async => _countWhere(deadLettered: false);

  /// Ops that have given up and need the user.
  Future<int> failedCount() async => _countWhere(deadLettered: true);

  Future<int> _countWhere({required bool deadLettered}) async {
    final Expression<int> count = _db.syncOps.id.count();
    final query = _db.selectOnly(_db.syncOps)
      ..addColumns([count])
      ..where(_db.syncOps.deadLettered.equals(deadLettered));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Everything in the queue, oldest first — the Sync screen's list.
  Stream<List<SyncOpRow>> watchAll() {
    return (_db.select(_db.syncOps)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  /// Whether a specific row has an op waiting.
  ///
  /// The pull path uses this to honour server-wins without clobbering an edit
  /// that has not been pushed yet.
  Future<Set<String>> pendingRowIds(SyncEntity entity) async {
    final rows = await (_db.select(
      _db.syncOps,
    )..where((t) => t.entity.equalsValue(entity))).get();
    return rows.map((r) => r.localRowId).toSet();
  }

  /// Hydrates a database row into the in-memory op model.
  static SyncOp toModel(SyncOpRow row) {
    return SyncOp(
      id: row.id,
      entity: row.entity,
      op: row.op,
      localRowId: row.localRowId,
      dedupeKey: row.dedupeKey,
      payload: decodeSyncPayload(row.payload),
      attempts: row.attempts,
      createdAt: row.createdAt,
      nextAttemptAt: row.nextAttemptAt,
      serverId: row.serverId,
      businessServerId: row.businessServerId,
      lastError: row.lastError,
      deadLettered: row.deadLettered,
    );
  }
}
