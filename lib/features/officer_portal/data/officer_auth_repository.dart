/// Email/password sign-in for the officer portal, backed by Firebase Auth +
/// `Khushhal-Backend`'s `/api/officer/v1` endpoints.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../data/officer_api_client.dart';
import '../domain/officer_profile.dart';

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network — see `test/officer_portal_flow_test.dart`.
abstract class OfficerAuthRepository {
  /// Signs in an existing officer and exchanges the resulting Firebase ID
  /// token for their profile. Throws [OfficerNotRegisteredException] if the
  /// Firebase account exists but has no matching `officers` row.
  Future<OfficerProfile> signIn({required String email, required String password});

  /// Creates a new Firebase account for a first-time officer, then
  /// registers the matching `officers` row on the backend with the
  /// supplied details.
  Future<OfficerProfile> register({
    required String email,
    required String password,
    required String employeeId,
    required String fullName,
    String? mobile,
    String? pincode,
    String? block,
    String? state,
  });

  /// Resumes an already-signed-in officer's session (Firebase persists auth
  /// across page reloads by default) — returns `null` if there's no
  /// current Firebase user, or if the backend no longer recognizes them
  /// (e.g. the token expired), so the caller falls back to the login screen
  /// either way instead of erroring.
  Future<OfficerProfile?> currentSession();

  /// Signs out of Firebase — without this, [currentSession] would just sign
  /// the officer straight back in on their next page load.
  Future<void> signOut();

  /// Sends a password-reset email via Firebase. No backend call — Firebase
  /// owns the officer's password entirely (see `change_password_dialog`'s
  /// docstring), so it emails and validates the reset link itself.
  Future<void> sendPasswordResetEmail(String email);
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
  /// first actual use means the login/signup screens still render — only
  /// tapping the submit button fails, with a catchable, on-screen error
  /// instead of a blank app.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<OfficerProfile> signIn({required String email, required String password}) async {
    final UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw OfficerApiException(e.message ?? 'Could not sign in');
    }

    final String idToken = await _requireIdToken(userCredential);
    final Map<String, dynamic> json = await _apiClient.createSession(idToken);
    return officerProfileFromJson(json);
  }

  @override
  Future<OfficerProfile> register({
    required String email,
    required String password,
    required String employeeId,
    required String fullName,
    String? mobile,
    String? pincode,
    String? block,
    String? state,
  }) async {
    final UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw OfficerApiException(e.message ?? 'Could not create the account');
    }

    final String idToken = await _requireIdToken(userCredential);
    final Map<String, dynamic> json = await _apiClient.registerOfficer(idToken, <String, dynamic>{
      'employee_id': employeeId,
      'full_name': fullName,
      'mobile_e164': ?mobile,
      'pincode': ?pincode,
      'block': ?block,
      'state': ?state,
    });
    return officerProfileFromJson(json);
  }

  @override
  Future<OfficerProfile?> currentSession() async {
    final String? idToken = await _firebaseAuth.currentUser?.getIdToken();
    if (idToken == null) return null;

    try {
      final Map<String, dynamic> json = await _apiClient.fetchProfile(idToken);
      return officerProfileFromJson(json);
    } on Exception {
      // Expired/revoked token, or the officer row is gone — either way,
      // there's no session to resume, so fall back to the login screen
      // rather than surfacing an error the officer can't act on here.
      return null;
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw OfficerApiException(e.message ?? 'Could not send the reset email');
    }
  }

  Future<String> _requireIdToken(UserCredential credential) async {
    final String? idToken = await credential.user?.getIdToken();
    if (idToken == null) {
      throw const OfficerApiException('Sign-in did not return a token');
    }
    return idToken;
  }
}

/// Maps the backend's `OfficerRead` shape onto the domain [OfficerProfile].
/// Shared with `profile_repository.dart` so a profile edit's response maps
/// the same way a fresh sign-in's does.
OfficerProfile officerProfileFromJson(Map<String, dynamic> json) {
  return OfficerProfile(
    fullName: json['full_name'] as String,
    employeeId: json['employee_id'] as String,
    employeeIdVerified: json['employee_id_verified'] as bool,
    pincode: json['pincode'] as String? ?? '',
    block: json['block'] as String? ?? '',
    state: json['state'] as String? ?? '',
    email: json['email'] as String? ?? '',
    mobile: json['mobile_e164'] as String?,
    deviceLabel: json['device_label'] as String? ?? 'this device',
  );
}
