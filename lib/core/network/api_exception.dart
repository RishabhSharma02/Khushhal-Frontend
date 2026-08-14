/// Backend-shaped error, decoded from the `{error:{code,message,details?}}`
/// envelope the FastAPI service always returns.
class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  /// Raised before a request is even attempted, when the connectivity monitor
  /// already knows the backend is unreachable.
  ///
  /// Without this the caller waits out the full 10s connect timeout to learn
  /// something we knew immediately, which on the write path means every offline
  /// tap on "Save" appears to hang.
  ApiException.offline()
    : statusCode = 0,
      code = 'offline',
      message = 'No connection',
      details = null;

  final int statusCode;
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isNetwork => statusCode == 0;

  /// True when this failure was a connectivity problem rather than the server
  /// rejecting the request. These are always worth retrying; a 4xx is not.
  bool get isOffline => statusCode == 0;

  /// True when retrying unchanged could plausibly succeed.
  ///
  /// 4xx means the server understood and refused, so replaying the identical
  /// body will be refused identically — those get dead-lettered instead of
  /// looping. 408 and 429 are the exceptions: both explicitly invite a retry.
  bool get isRetryable {
    if (isOffline) return true;
    if (statusCode == 408 || statusCode == 429) return true;
    return statusCode >= 500;
  }

  @override
  String toString() => 'ApiException($statusCode $code: $message)';
}
