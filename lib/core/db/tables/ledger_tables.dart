/// Local mirror of the backend `ledger_entries` table.
library;

import 'package:drift/drift.dart';

import '../sync_columns.dart';

/// Money IN / OUT entries — the only record type that can be *created*
/// offline, and therefore the only one where [SyncableRow.serverId] is
/// legitimately null for a while.
///
/// [SyncableRow.clientId] is the backend's `client_entry_id`. The backend has a
/// unique constraint on `(business_id, client_entry_id)` and inserts with
/// `ON CONFLICT DO NOTHING`, so replaying a batch after a half-failed push is
/// free of duplicates.
///
/// [kind], [category] and [source] hold wire strings (`in`/`out`, `milk_sale`,
/// `manual`) rather than domain enum names, so a pull-then-push round trip
/// cannot rewrite a category the app does not recognise into `other`.
@TableIndex(
  name: 'idx_ledger_business_recorded',
  columns: {#businessServerId, #recordedAt},
)
@TableIndex(name: 'idx_ledger_server_id', columns: {#serverId})
@TableIndex(name: 'idx_ledger_sync_state', columns: {#syncState})
class LocalLedgerEntries extends Table with SyncableRow {
  /// Always a real backend id: businesses cannot be created offline, so an
  /// entry can never be attached to an unsynced business.
  IntColumn get businessServerId => integer()();

  IntColumn get ownerUserId => integer().nullable()();

  /// `in` | `out`.
  TextColumn get kind => text()();

  /// Whole rupees, always positive; [kind] carries the sign.
  IntColumn get amountInr => integer()();

  /// `milk_sale` | `fodder` | `vet` | `emi` | `other`.
  TextColumn get category => text()();

  DateTimeColumn get recordedAt => dateTime()();

  /// `manual` | `voice`.
  TextColumn get source => text().withDefault(const Constant('manual'))();

  /// Server-side acknowledgement time, echoed by `GET /entries`. Null while the
  /// row is still local-only.
  DateTimeColumn get syncedAt => dateTime().nullable()();
}
