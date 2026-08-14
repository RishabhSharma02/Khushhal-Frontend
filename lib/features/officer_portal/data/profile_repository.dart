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
}
