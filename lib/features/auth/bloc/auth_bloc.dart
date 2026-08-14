import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import '../data/mpin_repository.dart';
import '../data/profile_repository.dart';
import '../data/session_user.dart';

// ---------------- events ----------------

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => const [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthPhoneSubmitted extends AuthEvent {
  const AuthPhoneSubmitted(this.phoneE164);
  final String phoneE164;
  @override
  List<Object?> get props => [phoneE164];
}

class AuthResendRequested extends AuthEvent {
  const AuthResendRequested();
}

class AuthOtpSubmitted extends AuthEvent {
  const AuthOtpSubmitted(this.code);
  final String code;
  @override
  List<Object?> get props => [code];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class _FirebaseUserChanged extends AuthEvent {
  const _FirebaseUserChanged(this.user);
  final User? user;
  @override
  List<Object?> get props => [user?.uid];
}

// ---------------- states ----------------

enum AuthStatus {
  unknown,
  unauthenticated,
  sendingCode,
  codeSent,
  verifying,
  authenticated,
  error,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.phoneE164,
    this.verificationId,
    this.resendToken,
    this.me,
    this.isNew = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? phoneE164;
  final String? verificationId;
  final int? resendToken;
  final SessionUser? me;
  final bool isNew;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? phoneE164,
    String? verificationId,
    int? resendToken,
    SessionUser? me,
    bool? isNew,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      phoneE164: phoneE164 ?? this.phoneE164,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
      me: me ?? this.me,
      isNew: isNew ?? this.isNew,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [status, phoneE164, verificationId, resendToken, me?.id, isNew, errorMessage];
}

// ---------------- bloc ----------------

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository repository,
    ProfileRepository? profile,
    MpinRepository? mpin,
  })  : _repo = repository,
        _profile = profile,
        _mpin = mpin,
        super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthResendRequested>(_onResend);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthSignOutRequested>(_onSignOut);
    on<_FirebaseUserChanged>(_onFirebaseUserChanged);

    _sub = _repo.authStateChanges().listen((u) => add(_FirebaseUserChanged(u)));
  }

  final AuthRepository _repo;

  /// Source of the offline fallback session. See [_cachedSession].
  final ProfileRepository? _profile;

  /// Used to keep a device with a saved PIN on the mPIN unlock screen even
  /// when the Firebase session has been torn down (token revoked, cleared
  /// keychain, etc.). Without this the user would be sent through phone/OTP
  /// again just to reach a PIN they still have.
  final MpinRepository? _mpin;

  late final StreamSubscription<User?> _sub;

  Future<void> _onStarted(AuthStarted _, Emitter<AuthState> emit) async {
    if (!_repo.isSignedIn) {
      // Even without an active Firebase session, if this device has a PIN
      // enrolled and a cached user, treat that as authenticated so the
      // shell shows mPIN unlock instead of the phone screen. The user can
      // still switch numbers via "Forgot PIN? Login with OTP" on the
      // unlock screen, which wipes both the PIN and the cached row.
      final SessionUser? cached = await _cachedSession();
      final bool hasPin = await _hasSavedPin();
      if (cached != null && hasPin) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          me: cached,
          isNew: false,
          clearError: true,
        ));
        return;
      }
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
      return;
    }
    try {
      final result = await _repo.exchangeSessionWithBackend();
      await _seedLocalRow(result.me);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        me: result.me,
        isNew: result.isNew,
        clearError: true,
      ));
    } catch (e) {
      final SessionUser? cached = await _cachedSession();
      if (cached != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          me: cached,
          isNew: false,
          clearError: true,
        ));
        return;
      }
      emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString()));
    }
  }

  /// Mirrors `/auth/session`'s `me` into SQLite so subsequent local writes
  /// (name capture, profile edits, …) find an active row and enqueue their
  /// PATCH to the outbox. Without this, the very first setName after a
  /// fresh sign-in falls through with no local user and never syncs.
  Future<void> _seedLocalRow(SessionUser me) async {
    try {
      await _profile?.captureSession(me);
    } catch (_) {/* best effort — sync pull will still upsert later */}
  }

  Future<bool> _hasSavedPin() async {
    try {
      return await _mpin?.isSet() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// The profile from the last successful sign-in, if this device has one.
  ///
  /// Firebase keeps the refresh token across restarts, so `isSignedIn` stays
  /// true offline; only the `/auth/session` exchange fails. Falling back to the
  /// cached row keeps that user signed in instead of bouncing them to the phone
  /// screen, where they would be stuck — sending an SMS needs the network they
  /// do not have. A device with no cached row has never completed onboarding,
  /// so the sign-out is correct there.
  Future<SessionUser?> _cachedSession() async {
    try {
      return await _profile?.cachedSessionUser();
    } catch (_) {
      return null;
    }
  }

  Future<void> _onPhoneSubmitted(AuthPhoneSubmitted e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.sendingCode, phoneE164: e.phoneE164, clearError: true));
    try {
      final sent = await _repo.sendCode(e.phoneE164);
      emit(state.copyWith(
        status: AuthStatus.codeSent,
        verificationId: sent.verificationId,
        resendToken: sent.resendToken,
      ));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: err.toString()));
    }
  }

  Future<void> _onResend(AuthResendRequested _, Emitter<AuthState> emit) async {
    final phone = state.phoneE164;
    if (phone == null) return;
    emit(state.copyWith(status: AuthStatus.sendingCode, clearError: true));
    try {
      final sent = await _repo.sendCode(phone, resendToken: state.resendToken);
      emit(state.copyWith(
        status: AuthStatus.codeSent,
        verificationId: sent.verificationId,
        resendToken: sent.resendToken,
      ));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: err.toString()));
    }
  }

  Future<void> _onOtpSubmitted(AuthOtpSubmitted e, Emitter<AuthState> emit) async {
    final vid = state.verificationId;
    if (vid == null) return;
    emit(state.copyWith(status: AuthStatus.verifying, clearError: true));
    try {
      final result = await _repo.verifyCode(verificationId: vid, smsCode: e.code);
      await _seedLocalRow(result.me);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        me: result.me,
        isNew: result.isNew,
      ));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: err.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested _, Emitter<AuthState> emit) async {
    await _repo.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onFirebaseUserChanged(_FirebaseUserChanged e, Emitter<AuthState> emit) async {
    // If firebase_auth reports a user (e.g., auto-verified from SMS retrieval)
    // and we haven't yet exchanged with the backend, do so now.
    //
    // Skip when a verify/start flow is already exchanging — otherwise two
    // concurrent `/auth/session` calls race the user-insert and one loses on
    // the firebase_uid UNIQUE constraint.
    final busy = state.status == AuthStatus.verifying
        || state.status == AuthStatus.sendingCode
        || state.status == AuthStatus.codeSent;
    if (e.user != null && state.status != AuthStatus.authenticated && !busy) {
      try {
        final result = await _repo.exchangeSessionWithBackend();
        await _seedLocalRow(result.me);
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          me: result.me,
          isNew: result.isNew,
        ));
      } catch (err) {
        final SessionUser? cached = await _cachedSession();
        if (cached != null) {
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            me: cached,
            isNew: false,
            clearError: true,
          ));
          return;
        }
        emit(state.copyWith(status: AuthStatus.error, errorMessage: err.toString()));
      }
    } else if (e.user == null && state.status == AuthStatus.authenticated) {
      // Firebase reports "no user" — either an explicit signOut or a
      // revoked/expired session. If this device still has a PIN and a
      // cached row, keep the user signed in via the offline identity so
      // they land on mPIN unlock instead of the phone screen; only the
      // explicit "Forgot PIN? Login with OTP" path (which clears both
      // the PIN and the cached row) should bounce them to phone login.
      final SessionUser? cached = await _cachedSession();
      final bool hasPin = await _hasSavedPin();
      if (cached != null && hasPin) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          me: cached,
          isNew: false,
          clearError: true,
        ));
        return;
      }
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
