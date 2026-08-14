/// Decides whether the backend is actually reachable.
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/env.dart';

/// Watches the radio and confirms it with a cheap request to the backend.
///
/// `connectivity_plus` alone is not enough: it reports the *interface* state,
/// so a phone attached to a wifi access point with no upstream, or a captive
/// portal in a village hall, both look online to it. Rural connections fail
/// this way often enough that the chip would lie. So a positive radio result is
/// confirmed against `GET /health`, which is unauthenticated and returns a
/// two-key JSON body.
///
/// The probe deliberately uses its own bare [Dio] rather than the app's
/// `ApiClient`: `ApiClient` asks *this* class whether it should even attempt a
/// request, and routing the probe through it would be circular. The probe also
/// skips the Firebase auth interceptor, which is the slowest part of a request
/// on a bad connection.
class ConnectivityMonitor {
  ConnectivityMonitor({
    Connectivity? connectivity,
    Dio? probeClient,
    String? baseUrl,
    this.probeTimeout = const Duration(seconds: 4),
  }) : _connectivity = connectivity ?? Connectivity(),
       _probe =
           probeClient ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl ?? AppEnv.apiBaseUrl,
               connectTimeout: const Duration(seconds: 4),
               receiveTimeout: const Duration(seconds: 4),
               // A health check that returns 503 still proves we reached the
               // server, which is what this class is asking about.
               validateStatus: (_) => true,
             ),
           );

  final Connectivity _connectivity;
  final Dio _probe;

  /// How long to wait for `/health` before calling the connection unusable.
  final Duration probeTimeout;

  final ValueNotifier<bool> _isOnline = ValueNotifier<bool>(true);
  final StreamController<void> _reconnected =
      StreamController<void>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _debounce;
  bool _disposed = false;

  /// Current reachability. Starts optimistic so the very first launch does not
  /// paint an offline chip before the probe has had a chance to run.
  ValueListenable<bool> get isOnline => _isOnline;

  /// Fires each time the connection comes back after being down. The sync
  /// engine listens here to drain the outbox automatically.
  Stream<void> get onReconnected => _reconnected.stream;

  /// Starts listening. Safe to call once.
  Future<void> start() async {
    _sub = _connectivity.onConnectivityChanged.listen(_onRadioChanged);
    await refresh();
  }

  void _onRadioChanged(List<ConnectivityResult> results) {
    final bool radioUp =
        results.isNotEmpty &&
        results.any((r) => r != ConnectivityResult.none);

    if (!radioUp) {
      _publish(false);
      return;
    }

    // Android in particular emits several transitions while a network settles.
    // Probing on each one would mean three or four requests for a single real
    // reconnect, so collapse them.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), refresh);
  }

  /// Probes the backend and republishes reachability. Returns the new value.
  Future<bool> refresh() async {
    if (_disposed) return _isOnline.value;

    final List<ConnectivityResult> results = await _connectivity
        .checkConnectivity();
    final bool radioUp =
        results.isNotEmpty &&
        results.any((r) => r != ConnectivityResult.none);
    if (!radioUp) {
      _publish(false);
      return false;
    }

    bool reachable;
    try {
      final Response<dynamic> r = await _probe
          .get<dynamic>('/health')
          .timeout(probeTimeout);
      reachable = r.statusCode != null;
    } on Object {
      // DioException, TimeoutException, or a platform socket error — from here
      // they all mean the same thing.
      reachable = false;
    }

    _publish(reachable);
    return reachable;
  }

  void _publish(bool online) {
    if (_disposed) return;
    final bool was = _isOnline.value;
    if (was == online) return;
    _isOnline.value = online;
    if (online && !was) _reconnected.add(null);
  }

  /// Test seam: forces a value without touching the radio or the network.
  @visibleForTesting
  void setOnlineForTesting(bool online) => _publish(online);

  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _sub?.cancel();
    _reconnected.close();
    _isOnline.dispose();
  }
}
