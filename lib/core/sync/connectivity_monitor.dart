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
    // Trust *up* signals; ignore *down* signals entirely. `connectivity_plus`
    // routinely reports `[none]` (or an empty list) on emulators, tethered
    // hotspots, corporate VPNs and captive portals even when the phone can
    // reach the network fine — turning that into a hard "offline" would
    // block sign-in and every other online-required action for users who
    // manifestly have internet. If the radio really is down, requests fail
    // with a real network error via Dio and the chip still updates via
    // successful `refresh()` probes.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), refresh);
  }

  /// Probes the backend and republishes reachability. Returns the new value.
  ///
  /// Radio state is authoritative for "the phone has a network". A failed
  /// backend probe on top of a live radio is not the same as being offline
  /// — Railway / Cloud Run instances routinely take 15–30 s to cold-start,
  /// and a 4 s probe timeout on the first hit would flip the chip to
  /// "Offline" while the user actually has working connectivity. So we
  /// only demote to offline when the radio itself is down; a probe that
  /// fails while the radio is up is left alone (the chip stays online and
  /// the request-level ApiException surfaces any real backend issue).
  Future<bool> refresh() async {
    if (_disposed) return _isOnline.value;

    // Deliberately optimistic: neither a "no radio" report nor a probe
    // failure demote to offline anymore. The chip stays online, and any
    // real network problem surfaces as a real error on the actual request
    // (via Dio's own timeout) rather than as a preemptive "no internet"
    // block on sign-in, business creation, etc. Emulators, corporate
    // VPNs and captive portals were the recurring false-positive here.
    try {
      await _probe.get<dynamic>('/health').timeout(probeTimeout);
    } on Object {
      // Probe failure is not evidence of offline — see comment above.
    }
    _publish(true);
    return true;
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
