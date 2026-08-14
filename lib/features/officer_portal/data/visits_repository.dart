/// The officer's logged visits, backed by
/// `Khushhal-Backend`'s `/api/officer/v1/visits` endpoints.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/enterprise.dart';
import '../domain/visit.dart';
import 'officer_api_client.dart';

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network.
abstract class VisitsRepository {
  Future<List<Visit>> fetchVisits();

  Future<Visit> addVisit({
    required String businessId,
    required DateTime date,
    required String agenda,
    RiskLevel? riskLevel,
  });
}

class ApiVisitsRepository implements VisitsRepository {
  ApiVisitsRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  // Lazy for the same reason as FirebaseOfficerAuthRepository — see that
  // file for why eager FirebaseAuth.instance access is unsafe here.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  Future<String> _idToken() async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }
    return token;
  }

  @override
  Future<List<Visit>> fetchVisits() async {
    final String token = await _idToken();
    final List<Map<String, dynamic>> rows = await _apiClient.fetchVisits(token);
    return rows.map(_visitFromJson).toList();
  }

  @override
  Future<Visit> addVisit({
    required String businessId,
    required DateTime date,
    required String agenda,
    RiskLevel? riskLevel,
  }) async {
    final String token = await _idToken();
    final Map<String, dynamic> json = await _apiClient.createVisit(token, <String, dynamic>{
      'business_id': int.parse(businessId),
      'date': date.toUtc().toIso8601String(),
      'agenda': agenda,
      if (riskLevel != null) 'risk_level': riskLevel.name,
    });
    return _visitFromJson(json);
  }
}

Visit _visitFromJson(Map<String, dynamic> json) {
  return Visit(
    id: json['id'].toString(),
    enterpriseId: json['enterprise_id'] as String,
    enterpriseName: json['enterprise_name'] as String,
    village: json['village'] as String,
    date: DateTime.parse(json['date'] as String).toLocal(),
    agenda: json['agenda'] as String,
    status: VisitStatus.values.byName(json['status'] as String),
    riskLevel: json['risk_level'] == null
        ? null
        : RiskLevel.values.byName(json['risk_level'] as String),
    distanceKm: (json['distance_km'] as num?)?.toDouble(),
  );
}
