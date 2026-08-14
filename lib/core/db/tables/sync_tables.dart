/// The outbox and its bookkeeping. Both tables are local-only — nothing here
/// has a backend counterpart.
library;

import 'package:drift/drift.dart';

import '../../sync/sync_op.dart';

/// The queue of writes waiting to reach the server.
///
/// Ordering is by [id], which is autoincrementing, so a drain is strictly FIFO.
/// That matters: a ledger entry's create must be pushed before the update that
/// amends it, and an update must not overtake the create that gave the row its
/// server id.
/// Named `SyncOpRow` rather than Drift's default `SyncOp` so it does not
/// collide with the in-memory [SyncOp] model this table is persisted from.
@DataClassName('SyncOpRow')
@TableIndex(name: 'idx_sync_ops_dedupe', columns: {#dedupeKey})
@TableIndex(name: 'idx_sync_ops_ready', columns: {#deadLettered, #nextAttemptAt})
@TableIndex(name: 'idx_sync_ops_row', columns: {#entity, #localRowId})
class SyncOps extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Which record type this op targets.
  TextColumn get entity => textEnum<SyncEntity>()();

  /// Create, update or delete.
  TextColumn get op => textEnum<SyncOpKind>()();

  /// The [SyncableRow.clientId] of the row this op will send. The push handler
  /// re-reads the row at drain time rather than trusting [payload] alone, so a
  /// coalesced op always sends current values.
  TextColumn get localRowId => text()();

  /// Backend id, when known at enqueue time. Ledger creates leave this null and
  /// have it filled in by the id-resolution pass after the batch lands.
  IntColumn get serverId => integer().nullable()();

  /// Scoping id for endpoints nested under a business.
  IntColumn get businessServerId => integer().nullable()();

  /// JSON request body. Merged in place when an op is coalesced.
  TextColumn get payload => text().withDefault(const Constant('{}'))();

  /// `entity:op:localRowId`. Two ops sharing a key collapse into one instead of
  /// queueing a redundant round trip.
  TextColumn get dedupeKey => text()();

  /// Bumped every time this op is coalesced with a newer write.
  ///
  /// Guards against losing an edit made while the op is mid-flight: the engine
  /// captures the revision when it claims the op and deletes on success only if
  /// it still matches. If the user edited the row while the request was in the
  /// air, the delete matches nothing and the newer payload survives for the
  /// next cycle instead of being acknowledged away.
  IntColumn get revision => integer().withDefault(const Constant(0))();

  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Last failure message, kept for the Sync screen's failed section.
  TextColumn get lastError => text().nullable()();

  /// Backoff gate — the engine skips ops scheduled for the future.
  DateTimeColumn get nextAttemptAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Set once the op has exhausted its retries. Dead ops stay on disk so the
  /// user can see what failed, but the engine stops trying.
  BoolColumn get deadLettered =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Small key/value scratchpad for sync bookkeeping: last successful pull per
/// entity, the seeded reference-data version, the last full-sync timestamp
/// shown on the Sync screen.
class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
