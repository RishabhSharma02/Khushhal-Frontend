/// Runtime configuration read from `--dart-define` flags.
///
/// Launch with:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
///
/// (10.0.2.2 hits the host machine from the Android emulator.
///  Use http://localhost:8000 for iOS simulator / desktop.)
class AppEnv {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Backend dev-shim uid. Only used when Firebase is not configured yet,
  /// so the app can still talk to the backend against `X-Debug-Firebase-Uid`.
  static const String debugFirebaseUid = String.fromEnvironment(
    'DEBUG_FIREBASE_UID',
    defaultValue: '',
  );
}
