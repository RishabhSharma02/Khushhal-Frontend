/// Cache-backed access to health, forecast and alerts.
library;

import '../../../core/db/app_database.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_op.dart';
import 'insights_api.dart';
import 'insights_local_datasource.dart';
import 'insights_remote_datasource.dart';

/// Everything Home and Forecast need for one business.
class InsightsBundle {
  const InsightsBundle({
    required this.health,
    required this.forecast,
    required this.alerts,
    this.fromCache = false,
  });

  final RemoteHealth? health;
  final RemoteForecast? forecast;
  final List<RemoteAlert> alerts;

  /// True when the network was unavailable and this came off disk. Lets the UI
  /// say "showing saved data" instead of implying the numbers are live.
  final bool fromCache;

  bool get isEmpty => health == null && forecast == null && alerts.isEmpty;
}

/// Read-through cache over the insights endpoints.
///
/// These are ML outputs — the device never authors them, so there is no
/// conflict to resolve and the rule is simply "use the network when it is
/// there, use the last known values when it is not". The one exception is the
/// plan-action checkboxes, which the user can tick offline and which therefore
/// go through the outbox like any other write.
class InsightsRepository {
  InsightsRepository({
    required InsightsLocalDataSource local,
    required InsightsRemoteDataSource remote,
    required OutboxDao outbox,
  }) : _local = local,
       _remote = remote,
       _outbox = outbox;

  final InsightsLocalDataSource _local;
  final InsightsRemoteDataSource _remote;
  final OutboxDao _outbox;

  Future<RemoteHealth?> getHealth(int businessId) async {
    try {
      final RemoteHealth? fresh = await _remote.getHealth(businessId);
      if (fresh != null) await _local.upsertHealth(fresh);
      return fresh ?? await _local.cachedHealth(businessId);
    } on ApiException {
      return _local.cachedHealth(businessId);
    }
  }

  Future<RemoteForecast?> getForecast(int businessId) async {
    try {
      final RemoteForecast? fresh = await _remote.getForecast(businessId);
      if (fresh != null) await _local.upsertForecast(fresh);
      return fresh ?? await _local.cachedForecast(businessId);
    } on ApiException {
      return _local.cachedForecast(businessId);
    }
  }

  Future<List<RemoteAlert>> getAlerts(int businessId) async {
    try {
      final List<RemoteAlert> fresh = await _remote.getAlerts(businessId);
      await _local.replaceAlerts(businessId, fresh);
      return fresh;
    } on ApiException {
      return _local.cachedAlerts(businessId);
    }
  }

  Future<RemoteAlert> getAlertDetail(int businessId, int alertId) async {
    try {
      final RemoteAlert fresh = await _remote.getAlertDetail(
        businessId,
        alertId,
      );
      final Set<String> protected = await _outbox.pendingRowIds(
        SyncEntity.planAction,
      );
      await _local.upsertAlertDetail(fresh, protectedClientIds: protected);
      // Re-read so any locally-toggled checkbox the pull just protected is the
      // version the screen renders.
      return await _local.cachedAlertDetail(alertId) ?? fresh;
    } on ApiException {
      final RemoteAlert? cached = await _local.cachedAlertDetail(alertId);
      if (cached != null) return cached;
      rethrow;
    }
  }

  /// Ticks a checkbox locally and queues the PATCH.
  ///
  /// The action plan is the part of an alert a user acts on in the field, which
  /// is exactly where the connection is worst — so this cannot require one.
  Future<void> togglePlanAction({
    required int businessId,
    required int alertId,
    required int actionId,
    required bool done,
  }) async {
    final LocalAlertRecord? record = await _local.alertById(alertId);
    LocalPlanAction? action;
    for (final LocalPlanAction a in record?.actions ?? const []) {
      if (a.serverId == actionId) {
        action = a;
        break;
      }
    }
    if (action == null) {
      // Not cached — fall back to a direct call so the tap is not simply lost.
      await _remote.togglePlanAction(
        businessId: businessId,
        alertId: alertId,
        actionId: actionId,
        done: done,
      );
      return;
    }

    await _local.setPlanActionDone(action.clientId, done);
    await _outbox.enqueue(
      entity: SyncEntity.planAction,
      op: SyncOpKind.update,
      localRowId: action.clientId,
      serverId: actionId,
      businessServerId: businessId,
      payload: <String, dynamic>{'done': done},
    );
  }

  /// Dev-gated on the backend; only useful when `DEV_TOOLS_ENABLED=true`.
  Future<RemoteHealth> refresh(int businessId) async {
    final RemoteHealth fresh = await _remote.refresh(businessId);
    await _local.upsertHealth(fresh);
    return fresh;
  }

  /// Everything for one business, falling back to the cache as a unit.
  ///
  /// The three calls run in parallel when online. When they cannot, the cached
  /// bundle is returned with [InsightsBundle.fromCache] set so the UI can be
  /// honest about the numbers being stale.
  Future<InsightsBundle> fetchAll(int businessId) async {
    try {
      final results = await Future.wait(<Future<Object?>>[
        _remote.getHealth(businessId),
        _remote.getForecast(businessId),
        _remote.getAlerts(businessId),
      ]);

      final RemoteHealth? health = results[0] as RemoteHealth?;
      final RemoteForecast? forecast = results[1] as RemoteForecast?;
      final List<RemoteAlert> alerts = results[2] as List<RemoteAlert>;

      if (health != null) await _local.upsertHealth(health);
      if (forecast != null) await _local.upsertForecast(forecast);
      await _local.replaceAlerts(businessId, alerts);

      return InsightsBundle(
        health: health,
        forecast: forecast,
        alerts: alerts,
      );
    } on ApiException {
      return InsightsBundle(
        health: await _local.cachedHealth(businessId),
        forecast: await _local.cachedForecast(businessId),
        alerts: await _local.cachedAlerts(businessId),
        fromCache: true,
      );
    }
  }

  /// When the cached health score was last refreshed.
  Future<DateTime?> cachedAt(int businessId) =>
      _local.healthFetchedAt(businessId);
}
