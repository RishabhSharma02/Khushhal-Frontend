/// Officer profile edits, backed by
/// `Khushhal-Backend`'s `PATCH /api/officer/v1/profile` endpoint.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/officer_profile.dart';
import 'officer_api_client.dart';
import 'officer_auth_repository.dart' show officerProfileFromJson;

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network.
abstract class ProfileRepository {
  /// Updates the signed-in officer's profile. [mobile] follows tri-state
  /// semantics: omit the parameter to leave it unchanged, or pass `null`
  /// explicitly to clear it (the officer never had one / wants it removed).
  Future<OfficerProfile> updateProfile({String? fullName, String? mobile});

  /// The "My coverage" tile's stats — aggregated server-side from the
  /// officer's assigned enterprises/visits/resolved flags. Fetched
  /// separately from the profile itself since it's only needed while the
  /// Profile screen is actually open.
  Future<OfficerCoverage> fetchCoverage();

  /// Changes the signed-in officer's password. Firebase requires a recent
  /// sign-in for this, so [currentPassword] is used to re-authenticate
  /// first — there's no backend involvement at all here, the officer's
  /// password lives entirely in Firebase, never in our own database.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  // Lazy for the same reason as FirebaseOfficerAuthRepository — see that
  // file for why eager FirebaseAuth.instance access is unsafe here.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<OfficerProfile> updateProfile({String? fullName, String? mobile}) async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }

    final Map<String, dynamic> json = await _apiClient.updateProfile(token, <String, dynamic>{
      'full_name': ?fullName,
      // Always sent (even when null, to clear it) — the edit-profile
      // dialog's mobile field is always present, unlike pincode/block/state
      // which nothing in the UI edits yet.
      'mobile_e164': mobile,
    });
    return officerProfileFromJson(json);
  }

  @override
  Future<OfficerCoverage> fetchCoverage() async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }

    final Map<String, dynamic> json = await _apiClient.fetchCoverage(token);
    return OfficerCoverage(
      enterpriseCount: json['enterprise_count'] as int,
      villageCount: json['village_count'] as int,
      visitsThisMonth: json['visits_this_month'] as int,
      flagsResolvedLast30Days: json['flags_resolved_last_30_days'] as int,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    final String? email = user?.email;
    if (user == null || email == null) {
      throw const OfficerApiException('Not signed in');
    }

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw OfficerApiException(_messageForAuthError(e));
    }
  }

  static String _messageForAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Current password is incorrect.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'requires-recent-login':
        return 'Please sign out and sign in again before changing your password.';
      default:
        return e.message ?? 'Could not change password.';
    }
  }
}
