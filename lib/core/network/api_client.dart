import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'api_exception.dart';
import 'env.dart';

/// Answers "is the backend reachable right now?" without performing IO.
///
/// Supplied by `ConnectivityMonitor`; kept as a bare callback so the network
/// layer does not depend on the sync layer.
typedef OnlineProbe = bool Function();

/// Thin async wrapper around Dio with a Firebase-token interceptor and
/// the backend's error envelope decoded into [ApiException].
///
/// Firebase ID tokens auto-refresh (Firebase SDK handles the exchange), so
/// the interceptor grabs a fresh one per request.
class ApiClient {
  ApiClient({Dio? dio, FirebaseAuth? auth, OnlineProbe? isOnline})
    : _dio = dio ?? Dio(),
      _auth = auth {
    // `isOnline` used to short-circuit requests when the connectivity
    // monitor said we were offline; kept in the constructor signature so
    // existing callers compile, but no longer consulted — see `_run`.
    _dio.options.baseUrl = AppEnv.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers['Content-Type'] = 'application/json';
    // Follow HTTP→HTTPS redirects that hosting providers (Railway, Cloud
    // Run, etc.) inject on the public domain. Without this the release
    // build hitting a plain `http://` URL surfaces the 301 straight to
    // the app instead of retrying against the https target.
    _dio.options.followRedirects = true;
    _dio.options.maxRedirects = 5;
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
    // The offline short-circuit used to live here as a fast-fail, but the
    // `ConnectivityMonitor` probe misfires (Railway cold-starts, emulator
    // radio mis-reporting, captive portals) can flip `isOnline` to false
    // while the phone genuinely has network — turning every request into
    // a spurious "no internet" error. Trust Dio to fail natively when the
    // socket really is dead; the 10 s connect timeout is fast enough.
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

  static const Duration _tokenTimeout = Duration(seconds: 5);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final user = _auth?.currentUser;
    if (user != null) {
      try {
        // A cached, unexpired token returns instantly. An expired one makes the
        // SDK go to the network to refresh, which on a dead connection can sit
        // far longer than the request it is supposed to be authorising — so cap
        // it and let the request go out unauthenticated rather than hang.
        final token = await user.getIdToken().timeout(_tokenTimeout);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {
        // Fall through: no token; shim below still identifies the user.
      }
      // Also send the shim uid so a backend that cannot verify the Bearer
      // (Firebase Admin not configured for this project on the current
      // deployment) can still identify the user. Backends that DO verify
      // the Bearer ignore this header.
      options.headers['X-Debug-Firebase-Uid'] = user.uid;
    } else if (AppEnv.debugFirebaseUid.isNotEmpty) {
      options.headers['X-Debug-Firebase-Uid'] = AppEnv.debugFirebaseUid;
    }
    handler.next(options);
  }
}
