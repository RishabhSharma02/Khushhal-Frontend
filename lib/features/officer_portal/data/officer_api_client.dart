/// Thin REST client for `/api/officer/v1/...` — the officer portal's first
/// networking code (see officer_auth_repository.dart for how it's used).
library;

import 'package:dio/dio.dart';

import 'officer_api_config.dart';

/// Raised when the backend has no officer account for the signed-in
/// Firebase identity — matches `get_current_officer`'s 403 in
/// `app/core/officer_security.py`. Distinct from other failures so the UI
/// can show "contact your admin" instead of a generic error.
class OfficerNotRegisteredException implements Exception {
  const OfficerNotRegisteredException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Any other officer-API failure (network, 401, 5xx, ...).
class OfficerApiException implements Exception {
  const OfficerApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OfficerApiClient {
  OfficerApiClient({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: OfficerApiConfig.baseUrl));

  final Dio _dio;

  Future<Map<String, dynamic>> createSession(String idToken) {
    return _post('/api/officer/v1/auth/session', idToken).then(
      (Map<String, dynamic> body) => body['officer'] as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> fetchProfile(String idToken) {
    return _get('/api/officer/v1/profile', idToken);
  }

  Future<Map<String, dynamic>> updateProfile(
    String idToken,
    Map<String, dynamic> changes,
  ) {
    return _patch('/api/officer/v1/profile', idToken, changes);
  }

  Future<List<Map<String, dynamic>>> fetchEnterprises(String idToken) {
    return _getList('/api/officer/v1/enterprises', idToken);
  }

  Future<Map<String, dynamic>> fetchEnterprise(String idToken, String enterpriseId) {
    return _get('/api/officer/v1/enterprises/$enterpriseId', idToken);
  }

  Future<List<Map<String, dynamic>>> fetchCashFlow(String idToken, String enterpriseId) {
    return _getList('/api/officer/v1/enterprises/$enterpriseId/cash-flow', idToken);
  }

  Future<Map<String, dynamic>> fetchDataQuality(String idToken, String enterpriseId) {
    return _get('/api/officer/v1/enterprises/$enterpriseId/data-quality', idToken);
  }

  Future<List<Map<String, dynamic>>> fetchActionSteps(String idToken, String enterpriseId) {
    return _getList('/api/officer/v1/enterprises/$enterpriseId/action-steps', idToken);
  }

  Future<Map<String, dynamic>> createActionStep(
    String idToken,
    String enterpriseId,
    Map<String, dynamic> body,
  ) {
    return _post('/api/officer/v1/enterprises/$enterpriseId/action-steps', idToken, body: body);
  }

  Future<Map<String, dynamic>> updateActionStep(
    String idToken,
    String enterpriseId,
    int stepId,
    Map<String, dynamic> body,
  ) {
    return _patch('/api/officer/v1/enterprises/$enterpriseId/action-steps/$stepId', idToken, body);
  }

  Future<void> deleteActionStep(String idToken, String enterpriseId, int stepId) {
    return _delete('/api/officer/v1/enterprises/$enterpriseId/action-steps/$stepId', idToken);
  }

  Future<List<Map<String, dynamic>>> fetchContactLog(String idToken, String enterpriseId) {
    return _getList('/api/officer/v1/enterprises/$enterpriseId/contact-log', idToken);
  }

  Future<Map<String, dynamic>> createContactLogEntry(
    String idToken,
    String enterpriseId,
    Map<String, dynamic> body,
  ) {
    return _post('/api/officer/v1/enterprises/$enterpriseId/contact-log', idToken, body: body);
  }

  Future<List<Map<String, dynamic>>> fetchVisits(String idToken) {
    return _getList('/api/officer/v1/visits', idToken);
  }

  Future<Map<String, dynamic>> createVisit(String idToken, Map<String, dynamic> body) {
    return _post('/api/officer/v1/visits', idToken, body: body);
  }

  Future<Map<String, dynamic>> fetchSyncStatus(String idToken) {
    return _get('/api/officer/v1/sync-status', idToken);
  }

  Future<Map<String, dynamic>> fetchDashboard(String idToken) {
    return _get('/api/officer/v1/dashboard', idToken);
  }

  Future<Map<String, dynamic>> fetchReports(String idToken) {
    return _get('/api/officer/v1/reports', idToken);
  }

  Future<Map<String, dynamic>> _get(String path, String idToken) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.get(
        path,
        options: Options(headers: _authHeaders(idToken)),
      );
      return response.data!;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    String idToken, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        path,
        data: body,
        options: Options(headers: _authHeaders(idToken)),
      );
      return response.data!;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> _delete(String path, String idToken) async {
    try {
      await _dio.delete(path, options: Options(headers: _authHeaders(idToken)));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<Map<String, dynamic>>> _getList(String path, String idToken) async {
    try {
      final Response<List<dynamic>> response = await _dio.get(
        path,
        options: Options(headers: _authHeaders(idToken)),
      );
      return response.data!.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> _patch(
    String path,
    String idToken,
    Map<String, dynamic> body,
  ) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.patch(
        path,
        data: body,
        options: Options(headers: _authHeaders(idToken)),
      );
      return response.data!;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Map<String, String> _authHeaders(String idToken) => <String, String>{
    'Authorization': 'Bearer $idToken',
  };

  Exception _mapError(DioException e) {
    final int? status = e.response?.statusCode;
    final Object? data = e.response?.data;
    final String message = data is Map && data['error'] is Map
        ? (data['error']['message'] as String? ?? e.message ?? 'Request failed')
        : e.message ?? 'Request failed';

    if (status == 403) {
      return OfficerNotRegisteredException(message);
    }
    return OfficerApiException(message);
  }
}
