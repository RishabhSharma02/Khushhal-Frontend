/// Backend-shaped error, decoded from the `{error:{code,message,details?}}`
/// envelope the FastAPI service always returns.
class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  final int statusCode;
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isNetwork => statusCode == 0;

  @override
  String toString() => 'ApiException($statusCode $code: $message)';
}
