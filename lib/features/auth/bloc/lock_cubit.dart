import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/mpin_repository.dart';
import '../data/profile_repository.dart';

enum LockStatus {
  unknown,      // still checking if mPIN is set
  requiresSetup, // signed in but no mPIN yet — force setup
  requiresUnlock, // mPIN set — prompt on cold start
  unlocked,     // free to reach the home shell
  lockedOut,    // too many wrong attempts — force sign-out
}

class AppLockState extends Equatable {
  const AppLockState({this.status = LockStatus.unknown, this.attempts = 0, this.error});

  final LockStatus status;
  final int attempts;
  final String? error;

  AppLockState copyWith({LockStatus? status, int? attempts, String? error, bool clearError = false}) {
    return AppLockState(
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, attempts, error];
}

/// Owns the app-lock state after a successful sign-in.
///
/// Sequence:
///   sign-in complete → [check] → requiresSetup OR requiresUnlock
///   set mPIN → [confirmSetup] → unlocked
///   unlock → [unlock] → unlocked (or lockedOut after N wrong tries)
///   sign-out → [reset]
class LockCubit extends Cubit<AppLockState> {
  LockCubit(this._repo, {ProfileRepository? profile})
    : _profile = profile,
      super(const AppLockState()) {
    // Eagerly check on construction so the gate never sits at `unknown`
    // longer than the Keychain round-trip.
    check();
  }

  final MpinRepository _repo;

  /// Consulted only when the keychain read fails — see [check].
  final ProfileRepository? _profile;

  static const Duration _checkTimeout = Duration(seconds: 3);

  /// Reads the mPIN + attempt count and moves to requiresSetup / requiresUnlock.
  ///
  /// The failure branch matters more than it looks. A keychain read can fail
  /// for reasons that have nothing to do with whether a PIN exists — missing
  /// iOS entitlements, a cold keychain on first unlock after boot. Treating
  /// that as "no PIN" used to route an existing user to *setup*, which
  /// silently replaced the PIN they already had and, before the profile was
  /// stored locally, sent them back through name capture as if they were new.
  ///
  /// So a failure now checks the local user row: if this device has a
  /// completed profile, someone has onboarded here and the right answer is to
  /// ask them to unlock, not to re-enrol them. Only a device with neither a
  /// readable PIN nor a local profile is genuinely new.
  Future<void> check() async {
    try {
      final has = await _repo.isSet().timeout(_checkTimeout);
      final attempts = await _repo.attemptCount().timeout(_checkTimeout);
      emit(state.copyWith(
        status: has ? LockStatus.requiresUnlock : LockStatus.requiresSetup,
        attempts: attempts,
        clearError: true,
      ));
    } catch (_) {
      final bool known = await _hasLocalProfile();
      emit(state.copyWith(
        status: known ? LockStatus.requiresUnlock : LockStatus.requiresSetup,
        attempts: 0,
        clearError: true,
      ));
    }
  }

  Future<bool> _hasLocalProfile() async {
    final ProfileRepository? profile = _profile;
    if (profile == null) return false;
    try {
      return await profile.hasLocalProfile().timeout(_checkTimeout);
    } catch (_) {
      return false;
    }
  }

  /// New user path — set the mPIN and immediately unlock.
  Future<void> confirmSetup(String pin) async {
    try {
      await _repo.set(pin);
      emit(state.copyWith(status: LockStatus.unlocked, attempts: 0, clearError: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> unlock(String pin) async {
    final ok = await _repo.verify(pin);
    if (ok) {
      emit(state.copyWith(status: LockStatus.unlocked, attempts: 0, clearError: true));
      return;
    }
    final attempts = await _repo.attemptCount();
    if (attempts >= MpinRepository.maxAttempts) {
      // Wipe stored mPIN — the auth gate will detect the sign-out and route
      // the user back to the phone screen.
      await _repo.clear();
      emit(state.copyWith(status: LockStatus.lockedOut, attempts: attempts));
      return;
    }
    emit(state.copyWith(
      attempts: attempts,
      error: 'Wrong mPIN. ${MpinRepository.maxAttempts - attempts} attempts left.',
    ));
  }

  /// Called from Settings → Sign out.
  Future<void> reset() async {
    await _repo.clear();
    emit(const AppLockState());
  }

  /// Locks the app back down to the PIN prompt without touching the stored
  /// PIN, cached profile, or Firebase session — used by Settings → Log out
  /// so the user can hand the phone off and the next person is greeted by
  /// the unlock screen instead of dropping straight into Home. To actually
  /// switch accounts, the user chooses "Forgot PIN? Login with OTP" from
  /// the unlock screen.
  void lock() {
    emit(state.copyWith(
      status: LockStatus.requiresUnlock,
      attempts: 0,
      clearError: true,
    ));
  }
}
