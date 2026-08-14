/// Phone-OTP sign-in for the officer portal, backed by Firebase Auth +
/// `Khushhal-Backend`'s `/api/officer/v1` endpoints.
library;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../data/officer_api_client.dart';
import '../data/officer_demo_data.dart';
import '../domain/officer_profile.dart';

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network — see `test/officer_portal_flow_test.dart`.
abstract class OfficerAuthRepository {
  /// Sends an OTP to [phoneE164] (e.g. "+919876543210"). Returns a
  /// verification handle to pass into [verifyOtp].
  Future<String> sendOtp(String phoneE164);

  /// Confirms [smsCode] against [verificationId], signs in, and exchanges
  /// the resulting Firebase ID token for the officer's profile. Throws
  /// [OfficerNotRegisteredException] if no officer account matches.
  Future<OfficerProfile> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
}

class FirebaseOfficerAuthRepository implements OfficerAuthRepository {
  FirebaseOfficerAuthRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  /// Resolved lazily, not in the constructor: this repository is built the
  /// moment the auth screen renders (see `officer_portal_root.dart`), and
  /// `FirebaseAuth.instance` throws if `Firebase.initializeApp()` hasn't
  /// succeeded (e.g. no project configured yet). Deferring the lookup to
  /// first actual use means the phone/OTP screens still render — only
  /// tapping "Send OTP" fails, with a catchable, on-screen error instead of
  /// a blank app.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<String> sendOtp(String phoneE164) {
    final Completer<String> verificationIdCompleter = Completer<String>();

    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {
        // Android auto-retrieval can complete without codeSent firing; the
        // OTP screen still lets the officer type the code manually, so we
        // don't need to special-case this beyond not leaving the completer
        // hanging.
        if (!verificationIdCompleter.isCompleted) {
          verificationIdCompleter.complete('');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!verificationIdCompleter.isCompleted) {
          verificationIdCompleter.completeError(
            OfficerApiException(e.message ?? 'Could not send the OTP'),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!verificationIdCompleter.isCompleted) {
          verificationIdCompleter.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return verificationIdCompleter.future;
  }

  @override
  Future<OfficerProfile> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw OfficerApiException(e.message ?? 'That code was not accepted');
    }

    final String? idToken = await userCredential.user?.getIdToken();
    if (idToken == null) {
      throw const OfficerApiException('Sign-in did not return a token');
    }

    final Map<String, dynamic> json = await _apiClient.createSession(idToken);
    return _profileFromJson(json);
  }
}

/// Maps the backend's `OfficerRead` shape onto the domain [OfficerProfile].
///
/// `coverage` isn't part of the Phase 0 auth/profile API yet (it's derived
/// from enterprises/visits data that ships in later phases), so it's
/// filled in from [OfficerDemoData] as a placeholder until then.
OfficerProfile _profileFromJson(Map<String, dynamic> json) {
  return OfficerProfile(
    fullName: json['full_name'] as String,
    employeeId: json['employee_id'] as String,
    employeeIdVerified: json['employee_id_verified'] as bool,
    pincode: json['pincode'] as String? ?? '',
    block: json['block'] as String? ?? '',
    state: json['state'] as String? ?? '',
    email: json['email'] as String? ?? '',
    mobile: json['mobile_e164'] as String,
    coverage: OfficerDemoData.officer.coverage,
    deviceLabel: json['device_label'] as String? ?? 'this device',
  );
}
