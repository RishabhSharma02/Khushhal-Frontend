/// HTTP access to the insights endpoints.
library;

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'insights_api.dart';

/// Thin wrapper over health, forecast and alerts.
class InsightsRemoteDataSource {
  InsightsRemoteDataSource(this._api);

  final ApiClient _api;

  /// Null when the pipeline has not stamped a score for this business yet,
  /// which is the normal state for a business created this month.
  Future<RemoteHealth?> getHealth(int businessId) async {
    try {
      final json = await _api.getJson('/api/v1/businesses/$businessId/health');
      return RemoteHealth.fromJson(json);
    } on ApiException catch (e) {
      if (e.isNotFound) return null;
      rethrow;
    }
  }

  Future<RemoteForecast?> getForecast(int businessId) async {
    try {
      final json = await _api.getJson(
        '/api/v1/businesses/$businessId/forecast',
      );
      return RemoteForecast.fromJson(json);
    } on ApiException catch (e) {
      if (e.isNotFound) return null;
      rethrow;
    }
  }

  Future<List<RemoteAlert>> getAlerts(int businessId) async {
    final rows = await _api.getList('/api/v1/businesses/$businessId/alerts');
    return rows
        .cast<Map<String, dynamic>>()
        .map(RemoteAlert.fromJson)
        .toList(growable: false);
  }

  Future<RemoteAlert> getAlertDetail(int businessId, int alertId) async {
    final json = await _api.getJson(
      '/api/v1/businesses/$businessId/alerts/$alertId',
    );
    return RemoteAlert.fromJson(json);
  }

  Future<RemotePlanAction> togglePlanAction({
    required int businessId,
    required int alertId,
    required int actionId,
    required bool done,
  }) async {
    final json = await _api.patchJson(
      '/api/v1/businesses/$businessId/alerts/$alertId/actions/$actionId',
      body: <String, dynamic>{'done': done},
    );
    return RemotePlanAction.fromJson(json);
  }

  /// Dev-gated on the backend; only useful when `DEV_TOOLS_ENABLED=true`.
  Future<RemoteHealth> refresh(int businessId) async {
    final json = await _api.postJson(
      '/api/v1/businesses/$businessId/insights/refresh',
    );
    return RemoteHealth.fromJson(json);
  }
}
