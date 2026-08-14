/// Local mirror of the backend `businesses` and `monthly_snapshots` tables.
library;

import 'package:drift/drift.dart';

import '../sync_columns.dart';

/// Businesses belonging to the signed-in user.
///
/// Creation is online-only, so [serverId] is populated the moment a row is
/// inserted and [RowSyncState.pendingCreate] never occurs here. Edits from the
/// Settings sheet do go through the outbox as `pendingUpdate`.
///
/// [segment], [sector] and [tenure] hold backend wire strings (`handicrafts`,
/// `rural_retail`, `under_1`, ...), not the frontend's domain enum names — see
/// the note on `LocalUsers` for why.
@DataClassName('LocalBusiness')
@TableIndex(name: 'idx_business_owner', columns: {#ownerUserId, #sortOrder})
@TableIndex(name: 'idx_business_server_id', columns: {#serverId})
class LocalBusinesses extends Table with SyncableRow {
  /// Owning user's backend id, so a second account on the device cannot read
  /// the first one's businesses.
  IntColumn get ownerUserId => integer().nullable()();

  TextColumn get name => text()();

  /// `shg` | `fpo` | `own`.
  TextColumn get segment => text()();

  /// `dairy` | `poultry` | `food_processing` | `handicrafts` | `rural_retail` |
  /// `other`.
  TextColumn get sector => text()();

  /// `under_1` | `1_to_3` | `3_to_10` | `10_plus`.
  TextColumn get tenure => text()();

  IntColumn get staffCount => integer().withDefault(const Constant(1))();

  BoolColumn get isNewBusiness =>
      boolean().withDefault(const Constant(false))();

  IntColumn get yearsInOperation => integer().withDefault(const Constant(0))();

  /// Savings held and loan outstanding for this business. Both are per
  /// business on the backend too, and both are editable offline from the
  /// savings & loan screen, so they ride the same `pendingUpdate` path as a
  /// name change.
  IntColumn get savingsInr => integer().withDefault(const Constant(0))();

  IntColumn get loanInr => integer().withDefault(const Constant(0))();

  /// Preserves the server's list order so the business switcher pill does not
  /// reshuffle between a cached read and a fresh pull.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// The latest monthly baseline per business, echoed by `GET /businesses` as
/// `latest_snapshot`. Read-only on the device: the setup wizard writes it via
/// the business-create payload and nothing else edits it.
class LocalMonthlySnapshots extends Table with CachedRow {
  IntColumn get businessServerId => integer()();

  /// First day of the month this snapshot describes.
  DateTimeColumn get month => dateTime()();

  IntColumn get moneyIn => integer().withDefault(const Constant(0))();
  IntColumn get moneyOut => integer().withDefault(const Constant(0))();
  IntColumn get loanEmi => integer().withDefault(const Constant(0))();
  IntColumn get savings => integer().withDefault(const Constant(0))();

  /// `rough` | `records`.
  TextColumn get basis => text().withDefault(const Constant('rough'))();

  @override
  Set<Column<Object>> get primaryKey => {businessServerId, month};
}
