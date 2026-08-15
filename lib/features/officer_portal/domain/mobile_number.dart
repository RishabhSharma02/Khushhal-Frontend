/// Shared mobile-number format validation (signup, profile edit).
library;

final RegExp _indianMobile = RegExp(r'^\+91[0-9]{10}$');

/// Validates an officer's mobile number. Returns an error message, or
/// `null` if valid. An empty [value] is always valid — mobile is optional
/// (see `OfficerProfile.mobile`); callers should check for "required but
/// empty" separately where that applies. Spaces are ignored (people type
/// and display these as "+91 98765 43210"), so only the digit count/prefix
/// is actually enforced.
String? mobileValidationError(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final String normalized = trimmed.replaceAll(' ', '');
  if (!_indianMobile.hasMatch(normalized)) {
    return 'Enter a valid mobile number, e.g. +919876543210';
  }
  return null;
}
