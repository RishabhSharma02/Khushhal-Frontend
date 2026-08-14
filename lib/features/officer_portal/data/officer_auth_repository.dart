/// Email/password sign-in for the officer portal, backed by Firebase Auth +
/// `Khushhal-Backend`'s `/api/officer/v1` endpoints.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../data/officer_api_client.dart';
import '../data/officer_demo_data.dart';
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
///
/// `coverage` isn't part of the auth/profile API (it's derived from
/// enterprises/visits data), so it's filled in from [OfficerDemoData] as a
/// placeholder until a real endpoint exists for it.
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
    coverage: OfficerDemoData.officer.coverage,
    deviceLabel: json['device_label'] as String? ?? 'this device',
  );
}
