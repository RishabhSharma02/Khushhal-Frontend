/// Drift-backed cache for the ML outputs: health, forecast, alerts and the
/// plan-action checkboxes.
///
/// Health, forecast and alerts are read-only projections of what the backend
/// pipeline computed, so they are cached wholesale and never authored on the
/// device. Plan actions are the exception: their checkboxes are toggleable
/// offline, so they carry sync state and go through the outbox.
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../app/model/insights.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/sync_columns.dart';
import 'insights_api.dart';

/// An alert plus the actions belonging to it.
class LocalAlertRecord {
  const LocalAlertRecord({
    required this.serverId,
    required this.businessServerId,
    required this.alert,
    required this.actions,
    required this.detailFetched,
  });

  final int serverId;
  final int businessServerId;
  final RiskAlert alert;
  final List<LocalPlanAction> actions;

  /// False when only the list endpoint has been seen, so the detail screen can
  /// distinguish "this alert has no plan" from "we have not fetched it yet".
  final bool detailFetched;
}

/// Local reads and writes for the insights tables.
class InsightsLocalDataSource {
  InsightsLocalDataSource(this._db);

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  // ── Health ─────────────────────────────────────────────────────────────

  /// Newest cached health score for a business.
  Future<HealthSnapshot?> health(int businessServerId) async {
    final LocalHealthScore? row = await _latestHealthRow(businessServerId);
    return row == null ? null : _healthToDomain(row);
  }

  /// Live view of the same.
  Stream<HealthSnapshot?> watchHealth(int businessServerId) {
    return (_db.select(_db.localHealthScores)
          ..where((t) => t.businessServerId.equals(businessServerId))
          ..orderBy([(t) => OrderingTerm.desc(t.asOn)])
          ..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : _healthToDomain(rows.first));
  }

  /// When the cached health score was last refreshed, for the offline banner.
  Future<DateTime?> healthFetchedAt(int businessServerId) async {
    final LocalHealthScore? row = await _latestHealthRow(businessServerId);
    return row?.fetchedAt;
  }

  Future<LocalHealthScore?> _latestHealthRow(int businessServerId) {
    return (_db.select(_db.localHealthScores)
          ..where((t) => t.businessServerId.equals(businessServerId))
          ..orderBy([(t) => OrderingTerm.desc(t.asOn)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsertHealth(RemoteHealth h) async {
    await _db
        .into(_db.localHealthScores)
        .insert(
          LocalHealthScoresCompanion.insert(
            serverId: Value(h.id),
            businessServerId: h.businessId,
            asOn: h.asOn,
            nextUpdate: h.nextUpdate,
            score: h.score,
            risk: h.risk,
            delta: Value(h.delta),
            daysWritten: Value(h.daysWritten),
            daysInMonth: Value(h.daysInMonth),
            band: h.band,
            pGreen: Value(h.pGreen),
            pAmber: Value(h.pAmber),
            pRed: Value(h.pRed),
            modelVersion: Value(h.modelVersion),
            fetchedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  // ── Forecast ───────────────────────────────────────────────────────────

  /// Cached six-month forecast, oldest horizon first.
  Future<List<ForecastMonth>> forecast(int businessServerId) async {
    final rows =
        await (_db.select(_db.localForecasts)
              ..where((t) => t.businessServerId.equals(businessServerId))
              ..orderBy([
                (t) => OrderingTerm.desc(t.asOn),
                (t) => OrderingTerm.asc(t.horizon),
              ]))
            .get();
    if (rows.isEmpty) return const <ForecastMonth>[];

    // Keep only the newest stamped window; older ones linger until replaced.
    final DateTime newest = rows.first.asOn;
    return rows
        .where((r) => r.asOn == newest)
        .map(
          (r) => ForecastMonth(
            month: DateTime(newest.year, newest.month + r.horizon),
            cfPred: r.cfPred,
            inLevel: r.inLevel,
            outLevel: r.outLevel,
            isRiskMonth: r.isRiskMonth,
          ),
        )
        .toList(growable: false);
  }

  Future<void> upsertForecast(RemoteForecast f) async {
    await _db.batch((batch) {
      for (final RemoteForecastMonth m in f.months) {
        batch.insert(
          _db.localForecasts,
          LocalForecastsCompanion.insert(
            businessServerId: f.businessId,
            asOn: f.asOn,
            horizon: m.horizon,
            cfPred: Value(m.cfPred),
            inLevel: Value(m.inLevel),
            outLevel: Value(m.outLevel),
            isRiskMonth: Value(m.isRiskMonth),
            fetchedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  // ── Alerts ─────────────────────────────────────────────────────────────

  /// Cached alerts for a business, urgent first then newest.
  Future<List<LocalAlertRecord>> alerts(int businessServerId) async {
    final rows =
        await (_db.select(_db.localRiskAlerts)
              ..where((t) => t.businessServerId.equals(businessServerId))
              ..orderBy([(t) => OrderingTerm.desc(t.raisedOn)]))
            .get();
    if (rows.isEmpty) return const <LocalAlertRecord>[];

    final actions = await (_db.select(_db.localPlanActions)
          ..where((t) => t.businessServerId.equals(businessServerId))
          ..orderBy([(t) => OrderingTerm.asc(t.ordinal)]))
        .get();

    final Map<int, List<LocalPlanAction>> byAlert =
        <int, List<LocalPlanAction>>{};
    for (final LocalPlanAction a in actions) {
      byAlert.putIfAbsent(a.alertServerId, () => <LocalPlanAction>[]).add(a);
    }

    final List<LocalAlertRecord> records = rows
        .map(
          (r) => LocalAlertRecord(
            serverId: r.serverId,
            businessServerId: r.businessServerId,
            detailFetched: r.detailFetched,
            actions: byAlert[r.serverId] ?? const <LocalPlanAction>[],
            alert: _alertToDomain(r),
          ),
        )
        .toList();

    records.sort((a, b) {
      final int severity =
          (a.alert.severity == AlertSeverity.urgent ? 0 : 1) -
          (b.alert.severity == AlertSeverity.urgent ? 0 : 1);
      if (severity != 0) return severity;
      final DateTime? ar = a.alert.raisedOn;
      final DateTime? br = b.alert.raisedOn;
      if (ar == null || br == null) return 0;
      return br.compareTo(ar);
    });
    return records;
  }

  /// One cached alert with its actions.
  Future<LocalAlertRecord?> alertById(int alertServerId) async {
    final LocalRiskAlert? row = await (_db.select(
      _db.localRiskAlerts,
    )..where((t) => t.serverId.equals(alertServerId))).getSingleOrNull();
    if (row == null) return null;

    final actions =
        await (_db.select(_db.localPlanActions)
              ..where((t) => t.alertServerId.equals(alertServerId))
              ..orderBy([(t) => OrderingTerm.asc(t.ordinal)]))
            .get();

    return LocalAlertRecord(
      serverId: row.serverId,
      businessServerId: row.businessServerId,
      detailFetched: row.detailFetched,
      actions: actions,
      alert: _alertToDomain(row),
    );
  }

  /// Replaces the cached alerts for a business.
  Future<void> replaceAlerts(
    int businessServerId,
    List<RemoteAlert> remote,
  ) async {
    await _db.transaction(() async {
      final Set<int> keep = remote.map((a) => a.id).toSet();
      final stale = await (_db.select(
        _db.localRiskAlerts,
      )..where((t) => t.businessServerId.equals(businessServerId))).get();

      for (final LocalRiskAlert row in stale) {
        if (keep.contains(row.serverId)) continue;
        await (_db.delete(_db.localRiskAlerts)
              ..where((t) => t.serverId.equals(row.serverId)))
            .go();
        await (_db.delete(_db.localPlanActions)
              ..where((t) => t.alertServerId.equals(row.serverId)))
            .go();
      }

      for (final RemoteAlert a in remote) {
        await _insertAlert(a, detailFetched: a.planActions.isNotEmpty);
      }
    });
  }

  /// Stores one alert's detail payload, including its plan actions.
  Future<void> upsertAlertDetail(
    RemoteAlert alert, {
    Set<String> protectedClientIds = const <String>{},
  }) async {
    await _db.transaction(() async {
      await _insertAlert(alert, detailFetched: true);
      for (final RemotePlanAction a in alert.planActions) {
        final LocalPlanAction? prior = await (_db.select(
          _db.localPlanActions,
        )..where((t) => t.serverId.equals(a.id))).getSingleOrNull();

        // An unsent toggle keeps its local value — the push either has not run
        // or has just failed, and the server's stale `done` would silently
        // untick a box the user ticked.
        if (prior != null && protectedClientIds.contains(prior.clientId)) {
          continue;
        }

        await _db
            .into(_db.localPlanActions)
            .insert(
              LocalPlanActionsCompanion.insert(
                clientId: prior?.clientId ?? _uuid.v4(),
                serverId: Value(a.id),
                alertServerId: alert.id,
                businessServerId: alert.businessId,
                role: Value(a.role),
                ordinal: Value(a.ordinal),
                labelEn: a.labelEn,
                labelHi: Value(a.labelHi),
                done: Value(a.done),
                syncState: const Value(RowSyncState.synced),
                localUpdatedAt: Value(DateTime.now()),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  Future<void> _insertAlert(
    RemoteAlert a, {
    required bool detailFetched,
  }) async {
    await _db
        .into(_db.localRiskAlerts)
        .insert(
          LocalRiskAlertsCompanion.insert(
            serverId: Value(a.id),
            businessServerId: a.businessId,
            asOn: a.asOn,
            kind: a.kind,
            severity: a.severity,
            driver: Value(a.driver),
            hasPlan: Value(a.hasPlan),
            raisedOn: a.raisedOn,
            detailFetched: Value(detailFetched),
            fetchedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  // ── Plan actions ───────────────────────────────────────────────────────

  Future<LocalPlanAction?> planActionByClientId(String clientId) {
    return (_db.select(
      _db.localPlanActions,
    )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();
  }

  /// Ticks or unticks a checkbox locally, flagged for push.
  Future<void> setPlanActionDone(String clientId, bool done) async {
    await (_db.update(
      _db.localPlanActions,
    )..where((t) => t.clientId.equals(clientId))).write(
      LocalPlanActionsCompanion(
        done: Value(done),
        syncState: const Value(RowSyncState.pendingUpdate),
        localUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markPlanActionSynced(String clientId) async {
    await (_db.update(
      _db.localPlanActions,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalPlanActionsCompanion(syncState: Value(RowSyncState.synced)),
    );
  }

  Future<void> markPlanActionFailed(String clientId) async {
    await (_db.update(
      _db.localPlanActions,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalPlanActionsCompanion(syncState: Value(RowSyncState.failed)),
    );
  }

  // ── Cache reads in wire shape ──────────────────────────────────────────
  //
  // These rebuild the `Remote*` DTOs from cached rows so the repository can
  // return the same types whether the data came from the network or from disk.
  // Keeping one shape means the cubit and every screen below it stay unaware
  // that an offline path exists.

  /// Cached health score as the API would have returned it.
  Future<RemoteHealth?> cachedHealth(int businessServerId) async {
    final LocalHealthScore? row = await _latestHealthRow(businessServerId);
    if (row == null) return null;
    return RemoteHealth(
      id: row.serverId,
      businessId: row.businessServerId,
      asOn: row.asOn,
      nextUpdate: row.nextUpdate,
      score: row.score,
      risk: row.risk,
      delta: row.delta,
      daysWritten: row.daysWritten,
      daysInMonth: row.daysInMonth,
      band: row.band,
      pGreen: row.pGreen,
      pAmber: row.pAmber,
      pRed: row.pRed,
      modelVersion: row.modelVersion ?? '',
    );
  }

  /// Cached forecast as the API would have returned it.
  Future<RemoteForecast?> cachedForecast(int businessServerId) async {
    final rows =
        await (_db.select(_db.localForecasts)
              ..where((t) => t.businessServerId.equals(businessServerId))
              ..orderBy([
                (t) => OrderingTerm.desc(t.asOn),
                (t) => OrderingTerm.asc(t.horizon),
              ]))
            .get();
    if (rows.isEmpty) return null;

    final DateTime newest = rows.first.asOn;
    return RemoteForecast(
      businessId: businessServerId,
      asOn: newest,
      months: rows
          .where((r) => r.asOn == newest)
          .map(
            (r) => RemoteForecastMonth(
              horizon: r.horizon,
              cfPred: r.cfPred,
              inLevel: r.inLevel,
              outLevel: r.outLevel,
              isRiskMonth: r.isRiskMonth,
            ),
          )
          .toList(growable: false),
    );
  }

  /// Cached alerts, with their plan actions attached.
  Future<List<RemoteAlert>> cachedAlerts(int businessServerId) async {
    final records = await alerts(businessServerId);
    return records
        .map(
          (r) => RemoteAlert(
            id: r.serverId,
            businessId: r.businessServerId,
            asOn: r.alert.raisedOn ?? DateTime.now(),
            kind: _rawKind(r),
            severity: r.alert.severity == AlertSeverity.urgent
                ? 'urgent'
                : 'info',
            driver: '',
            hasPlan: r.alert.hasPlan,
            raisedOn: r.alert.raisedOn ?? DateTime.now(),
            planActions: r.actions
                .map(
                  (a) => RemotePlanAction(
                    id: a.serverId ?? 0,
                    role: a.role,
                    ordinal: a.ordinal,
                    labelEn: a.labelEn,
                    labelHi: a.labelHi,
                    done: a.done,
                  ),
                )
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
  }

  String _rawKind(LocalAlertRecord record) => switch (record.alert.kind) {
    AlertKind.fodderPriceUp => 'market_stress',
    AlertKind.heavyRain => 'climate_deficit',
    AlertKind.savingsRunningLow => 'savings_low',
  };

  /// Cached alert detail, or null when it has never been fetched.
  Future<RemoteAlert?> cachedAlertDetail(int alertServerId) async {
    final LocalAlertRecord? record = await alertById(alertServerId);
    if (record == null || !record.detailFetched) return null;
    final List<RemoteAlert> all = await cachedAlerts(record.businessServerId);
    for (final RemoteAlert a in all) {
      if (a.id == alertServerId) return a;
    }
    return null;
  }

  // ── Mapping ────────────────────────────────────────────────────────────

  HealthSnapshot _healthToDomain(LocalHealthScore row) {
    return HealthSnapshot(
      score: row.score,
      asOn: row.asOn,
      nextUpdate: row.nextUpdate,
      risk: switch (row.risk) {
        'low' => RiskLevel.low,
        'medium' => RiskLevel.medium,
        _ => RiskLevel.high,
      },
      daysWritten: row.daysWritten,
      daysInMonth: row.daysInMonth,
      delta: row.delta,
    );
  }

  RiskAlert _alertToDomain(LocalRiskAlert row) {
    // Reuses the API mapper so the six-kinds-to-three collapse lives in exactly
    // one place, and the raw backend kind stays on disk.
    return RemoteAlert(
      id: row.serverId,
      businessId: row.businessServerId,
      asOn: row.asOn,
      kind: row.kind,
      severity: row.severity,
      driver: row.driver ?? '',
      hasPlan: row.hasPlan,
      raisedOn: row.raisedOn,
    ).toDomain();
  }
}
