/// Where the officer backend lives.
///
/// Override at build/run time with
/// `--dart-define=OFFICER_API_BASE_URL=https://your-host`; defaults to the
/// local dev server from the backend README.
library;

abstract final class OfficerApiConfig {
  /// Base URL for `/api/officer/v1/...` requests.
  static const String baseUrl = String.fromEnvironment(
    'OFFICER_API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}
