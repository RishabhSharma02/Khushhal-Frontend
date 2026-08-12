import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/mpin_repository.dart';

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
  LockCubit(this._repo) : super(const AppLockState()) {
    // Eagerly check on construction so the gate never sits at `unknown`
    // longer than the Keychain round-trip.
    check();
  }
  final MpinRepository _repo;

  static const Duration _checkTimeout = Duration(seconds: 3);

  /// Reads the mPIN + attempt count and moves to requiresSetup / requiresUnlock.
  ///
  /// If the Keychain read hangs or errors (iOS entitlements missing, cold
  /// Keychain, etc.) we assume no PIN exists and route to setup — the user
  /// will be prompted to (re-)create their PIN rather than seeing a stuck
  /// loader forever.
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
      emit(state.copyWith(status: LockStatus.requiresSetup, attempts: 0, clearError: true));
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
}
