import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
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
  AuthBloc({required AuthRepository repository})
      : _repo = repository,
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
  late final StreamSubscription<User?> _sub;

  Future<void> _onStarted(AuthStarted _, Emitter<AuthState> emit) async {
    if (_repo.isSignedIn) {
      try {
        final result = await _repo.exchangeSessionWithBackend();
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          me: result.me,
          isNew: result.isNew,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString()));
      }
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
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
    if (e.user != null && state.status != AuthStatus.authenticated) {
      try {
        final result = await _repo.exchangeSessionWithBackend();
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          me: result.me,
          isNew: result.isNew,
        ));
      } catch (err) {
        emit(state.copyWith(status: AuthStatus.error, errorMessage: err.toString()));
      }
    } else if (e.user == null && state.status == AuthStatus.authenticated) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
