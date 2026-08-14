/// Local mirror of the backend insights tables: `health_scores`, `forecasts`,
/// `risk_alerts` and `plan_actions`.
library;

import 'package:drift/drift.dart';

import '../sync_columns.dart';

/// Monthly health score. Produced by the backend ML pipeline, so it is a pure
/// read-through cache — the device never authors one.
@TableIndex(name: 'idx_health_business', columns: {#businessServerId, #asOn})
class LocalHealthScores extends Table with CachedRow {
  IntColumn get serverId => integer()();
  IntColumn get businessServerId => integer()();

  DateTimeColumn get asOn => dateTime()();
  DateTimeColumn get nextUpdate => dateTime()();

  IntColumn get score => integer()();

  /// `low` | `medium` | `high`.
  TextColumn get risk => text()();

  /// Score change against the previous month; null when this is the first.
  IntColumn get delta => integer().nullable()();

  IntColumn get daysWritten => integer().withDefault(const Constant(0))();
  IntColumn get daysInMonth => integer().withDefault(const Constant(30))();

  /// `green` | `amber` | `red`.
  TextColumn get band => text()();

  RealColumn get pGreen => real().withDefault(const Constant(0))();
  RealColumn get pAmber => real().withDefault(const Constant(0))();
  RealColumn get pRed => real().withDefault(const Constant(0))();

  TextColumn get modelVersion => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {serverId};
}

/// One horizon of the six-month forecast. Read-only cache.
class LocalForecasts extends Table with CachedRow {
  IntColumn get businessServerId => integer()();

  /// The date the forecast window was stamped.
  DateTimeColumn get asOn => dateTime()();

  /// Months ahead of [asOn], 1..6.
  IntColumn get horizon => integer()();

  RealColumn get cfPred => real().withDefault(const Constant(0))();
  RealColumn get inLevel => real().withDefault(const Constant(0))();
  RealColumn get outLevel => real().withDefault(const Constant(0))();

  BoolColumn get isRiskMonth => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {businessServerId, asOn, horizon};
}

/// A raised risk alert. Read-only cache; only its plan actions are writable.
@TableIndex(name: 'idx_alert_business', columns: {#businessServerId, #raisedOn})
class LocalRiskAlerts extends Table with CachedRow {
  IntColumn get serverId => integer()();
  IntColumn get businessServerId => integer()();

  DateTimeColumn get asOn => dateTime()();

  /// One of six backend kinds: `savings_low`, `liquidity_debt_stress`,
  /// `climate_deficit`, `climate_excess`, `market_stress`, `new_business`.
  /// Stored raw because the frontend's `toDomainKind()` collapses these six
  /// into three and the distinction is worth keeping on disk.
  TextColumn get kind => text()();

  /// `urgent` | `info`.
  TextColumn get severity => text()();

  TextColumn get driver => text().nullable()();

  BoolColumn get hasPlan => boolean().withDefault(const Constant(false))();

  DateTimeColumn get raisedOn => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  /// True once `GET /alerts/{id}` has filled in this alert's plan actions, so
  /// the detail screen can tell "no actions" from "not fetched yet" offline.
  BoolColumn get detailFetched =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {serverId};
}

/// A single checkbox on an alert's action plan. Toggleable offline, so unlike
/// the rest of the insights tables this one carries the sync columns.
@TableIndex(name: 'idx_plan_action_alert', columns: {#alertServerId, #ordinal})
@TableIndex(name: 'idx_plan_action_server_id', columns: {#serverId})
class LocalPlanActions extends Table with SyncableRow {
  IntColumn get alertServerId => integer()();

  /// Denormalised so the push handler can build
  /// `/businesses/{bid}/alerts/{aid}/actions/{id}` without a join.
  IntColumn get businessServerId => integer()();

  /// `owner` | `field_officer`.
  TextColumn get role => text().withDefault(const Constant('owner'))();

  IntColumn get ordinal => integer().withDefault(const Constant(0))();

  TextColumn get labelEn => text()();
  TextColumn get labelHi => text().nullable()();

  BoolColumn get done => boolean().withDefault(const Constant(false))();
}
