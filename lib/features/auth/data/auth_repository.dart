import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/network/api_client.dart';
import 'session_user.dart';

class SessionResult {
  const SessionResult({required this.me, required this.isNew});
  final SessionUser me;
  final bool isNew;
}

class CodeSent {
  const CodeSent({required this.verificationId, this.resendToken});
  final String verificationId;
  final int? resendToken;
}

/// Wraps Firebase Phone Auth and exchanges the resulting Firebase ID token
/// for an app session against `POST /api/v1/auth/session`.
class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    FirebaseAuth? firebaseAuth,
  })  : _api = apiClient,
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  final ApiClient _api;
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  bool get isSignedIn => _auth.currentUser != null;

  /// Starts phone verification. Resolves with a [CodeSent] when the SMS has
  /// been dispatched, or throws if verification fails or auto-retrieval
  /// completes sign-in immediately (in which case [autoSignedIn] fires too).
  Future<CodeSent> sendCode(
    String phoneE164, {
    int? resendToken,
    void Function()? onAutoSignedIn,
  }) async {
    final completer = Completer<CodeSent>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential cred) async {
        try {
          await _auth.signInWithCredential(cred);
          if (onAutoSignedIn != null) onAutoSignedIn();
        } catch (_) {/* surfaced via authStateChanges */}
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? token) {
        if (!completer.isCompleted) {
          completer.complete(CodeSent(verificationId: verificationId, resendToken: token));
        }
      },
      codeAutoRetrievalTimeout: (String _) {},
    );
    return completer.future;
  }

  /// Verifies the SMS code against the pending verificationId and, on
  /// success, upserts the app user via the backend.
  Future<SessionResult> verifyCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
    return exchangeSessionWithBackend();
  }

  /// Called after firebase_auth already has a signed-in user (either from
  /// [verifyCode] or restored across restarts). Ensures the app-side row
  /// exists and returns it.
  Future<SessionResult> exchangeSessionWithBackend() async {
    final json = await _api.postJson('/api/v1/auth/session');
    final me = SessionUser.fromJson(json['me'] as Map<String, dynamic>);
    return SessionResult(me: me, isNew: json['is_new'] as bool);
  }

  Future<void> signOut() => _auth.signOut();
}
