/// Dashboard trend data, backed by
/// `Khushhal-Backend`'s `/api/officer/v1/dashboard` endpoint.
///
/// Per-enterprise current state (counts by risk level, risk queue, next
/// visit) is already loaded from [EnterprisesRepository]/[VisitsRepository]
/// — this only covers what needs server-side aggregation across time.
library;

import 'package:firebase_auth/firebase_auth.dart';

import 'officer_api_client.dart';

typedef DashboardTrends = ({
  List<int> averageScoreHistory,
  int averageScoreDelta,
  int emisOnTimePercent,
  int emisOnTimeDelta,
  int openFlagCount,
  int openFlagDelta,
  int visitsDoneThisWeek,
  int visitsPlannedThisWeek,
});

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network.
abstract class DashboardRepository {
  Future<DashboardTrends> fetchDashboard();
}

class ApiDashboardRepository implements DashboardRepository {
  ApiDashboardRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  // Lazy for the same reason as FirebaseOfficerAuthRepository — see that
  // file for why eager FirebaseAuth.instance access is unsafe here.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<DashboardTrends> fetchDashboard() async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }
    final Map<String, dynamic> json = await _apiClient.fetchDashboard(token);
    return (
      averageScoreHistory: (json['average_score_history'] as List<dynamic>).cast<int>(),
      averageScoreDelta: json['average_score_delta'] as int,
      emisOnTimePercent: json['emis_on_time_percent'] as int,
      emisOnTimeDelta: json['emis_on_time_delta'] as int,
      openFlagCount: json['open_flag_count'] as int,
      openFlagDelta: json['open_flag_delta'] as int,
      visitsDoneThisWeek: json['visits_done_this_week'] as int,
      visitsPlannedThisWeek: json['visits_planned_this_week'] as int,
    );
  }
}
