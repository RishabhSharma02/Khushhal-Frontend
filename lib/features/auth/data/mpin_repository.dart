import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small secure-storage wrapper for the 4-digit mPIN app-lock.
///
/// Keys live in the platform keychain / keystore. `attemptCount` gates a
/// hard sign-out after too many wrong tries.
class MpinRepository {
  MpinRepository({FlutterSecureStorage? storage})
      : _s = storage ?? const FlutterSecureStorage(
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _s;

  static const _kPin = 'khushhal.mpin';
  static const _kAttempts = 'khushhal.mpin.attempts';
  static const int maxAttempts = 5;

  Future<bool> isSet() async => (await _s.read(key: _kPin)) != null;

  Future<void> set(String pin) async {
    _validateFormat(pin);
    await _s.write(key: _kPin, value: pin);
    await _s.delete(key: _kAttempts);
  }

  /// Returns true on match. Consumes an attempt on failure; caller checks
  /// [attemptCount] and force-logs-out when it hits [maxAttempts].
  Future<bool> verify(String pin) async {
    final stored = await _s.read(key: _kPin);
    if (stored == null) return false;
    if (stored == pin) {
      await _s.delete(key: _kAttempts);
      return true;
    }
    final n = await attemptCount();
    await _s.write(key: _kAttempts, value: '${n + 1}');
    return false;
  }

  Future<int> attemptCount() async {
    final v = await _s.read(key: _kAttempts);
    return int.tryParse(v ?? '') ?? 0;
  }

  Future<void> clear() async {
    await _s.delete(key: _kPin);
    await _s.delete(key: _kAttempts);
  }

  void _validateFormat(String pin) {
    if (pin.length != 4 || int.tryParse(pin) == null) {
      throw ArgumentError('mPIN must be exactly 4 digits');
    }
  }
}
