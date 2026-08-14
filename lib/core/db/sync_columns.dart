/// Columns every locally-writable table shares, plus the local-only row
/// state that drives the sync chip and the Sync screen.
library;

import 'package:drift/drift.dart';

/// Where a local row stands relative to the server.
///
/// This is a purely local concept — the backend has no matching column. It is
/// derived from, and kept consistent with, the presence of a `sync_ops` row for
/// the same record.
enum RowSyncState {
  /// The server has this exact version. Safe for a pull to overwrite.
  synced,

  /// Written on the device and never sent. Only reachable for ledger entries,
  /// the one record type that can be created offline.
  pendingCreate,

  /// Exists on the server, but the device holds a newer edit.
  pendingUpdate,

  /// Exists on the server and the device wants it gone.
  pendingDelete,

  /// The push was rejected with a non-retryable error. The row keeps the local
  /// values until the next pull overwrites it, so the Sync screen can show the
  /// user what was dropped instead of silently losing it.
  failed,
}

/// True when a row is waiting on the network, in either direction.
extension RowSyncStatePending on RowSyncState {
  /// Whether this state means "the server does not have our version yet".
  bool get isPending => switch (this) {
    RowSyncState.pendingCreate => true,
    RowSyncState.pendingUpdate => true,
    RowSyncState.pendingDelete => true,
    RowSyncState.synced => false,
    RowSyncState.failed => false,
  };
}

/// The four columns the plan mandates on every syncable table.
///
/// [clientId] is the primary key everywhere rather than [serverId], because a
/// row can exist before the backend has assigned it a BIGINT. Ledger entries
/// reuse their existing `client_entry_id` UUID here so the backend's
/// idempotency key and our local key are the same value.
mixin SyncableRow on Table {
  /// The backend BIGINT, once known. Null only for a create that has never
  /// reached the server.
  IntColumn get serverId => integer().nullable()();

  /// Client-generated UUID. Stable for the lifetime of the row.
  TextColumn get clientId => text()();

  /// Local sync state — see [RowSyncState].
  TextColumn get syncState => textEnum<RowSyncState>()
      .withDefault(Constant(RowSyncState.synced.name))();

  /// When the device last touched this row. Used for ordering and for showing
  /// "saved at" on pending items.
  DateTimeColumn get localUpdatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Marks a read-only server projection: health scores, forecasts, alerts and
/// the reference tables. These are never edited on the device, so they carry a
/// fetch timestamp for staleness display instead of the sync columns.
mixin CachedRow on Table {
  /// When this row was last pulled from the backend. Drives the "showing saved
  /// data from X" line on the offline home.
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
}
