import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'api_exception.dart';
import 'env.dart';

/// Thin async wrapper around Dio with a Firebase-token interceptor and
/// the backend's error envelope decoded into [ApiException].
///
/// Firebase ID tokens auto-refresh (Firebase SDK handles the exchange), so
/// the interceptor grabs a fresh one per request.
class ApiClient {
  ApiClient({Dio? dio, FirebaseAuth? auth}) : _dio = dio ?? Dio(), _auth = auth {
    _dio.options.baseUrl = AppEnv.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.interceptors.add(_AuthInterceptor(_auth));
  }

  final Dio _dio;
  final FirebaseAuth? _auth;

  Future<Map<String, dynamic>> getJson(String path, {Map<String, dynamic>? query}) async {
    return _unwrap(await _run(() => _dio.get<dynamic>(path, queryParameters: query)));
  }

  Future<List<dynamic>> getList(String path, {Map<String, dynamic>? query}) async {
    final r = await _run(() => _dio.get<dynamic>(path, queryParameters: query));
    return (r.data as List<dynamic>?) ?? const [];
  }

  Future<Map<String, dynamic>> postJson(String path, {Object? body}) async {
    return _unwrap(await _run(() => _dio.post<dynamic>(path, data: body)));
  }

  Future<Map<String, dynamic>> patchJson(String path, {Object? body}) async {
    return _unwrap(await _run(() => _dio.patch<dynamic>(path, data: body)));
  }

  Future<void> delete(String path) async {
    await _run(() => _dio.delete<dynamic>(path));
  }

  Map<String, dynamic> _unwrap(Response<dynamic> r) {
    if (r.data is Map<String, dynamic>) return r.data as Map<String, dynamic>;
    return <String, dynamic>{};
  }

  Future<Response<dynamic>> _run(Future<Response<dynamic>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
    final resp = e.response;
    if (resp == null) {
      return ApiException(statusCode: 0, code: 'network', message: e.message ?? 'Network error');
    }
    final data = resp.data;
    if (data is Map<String, dynamic> && data['error'] is Map) {
      final err = data['error'] as Map<String, dynamic>;
      return ApiException(
        statusCode: resp.statusCode ?? 500,
        code: (err['code'] as String?) ?? 'unknown',
        message: (err['message'] as String?) ?? 'Request failed',
        details: err['details'] as Map<String, dynamic>?,
      );
    }
    return ApiException(
      statusCode: resp.statusCode ?? 500,
      code: 'http_${resp.statusCode ?? 0}',
      message: resp.statusMessage ?? 'Request failed',
    );
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._auth);
  final FirebaseAuth? _auth;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final user = _auth?.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {
        // Fall through: no token; backend will 401.
      }
    } else if (AppEnv.debugFirebaseUid.isNotEmpty) {
      // Dev-only fallback so the app can hit the backend before Firebase is
      // configured. The backend accepts this header only when
      // DEV_TOOLS_ENABLED=true.
      options.headers['X-Debug-Firebase-Uid'] = AppEnv.debugFirebaseUid;
    }
    handler.next(options);
  }
}
