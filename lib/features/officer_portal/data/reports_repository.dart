/// Month-in-review report, backed by
/// `Khushhal-Backend`'s `/api/officer/v1/reports` endpoint.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/report_summary.dart';
import 'officer_api_client.dart';

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network.
abstract class ReportsRepository {
  Future<ReportSummary> fetchReports();
}

class ApiReportsRepository implements ReportsRepository {
  ApiReportsRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  // Lazy for the same reason as FirebaseOfficerAuthRepository — see that
  // file for why eager FirebaseAuth.instance access is unsafe here.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<ReportSummary> fetchReports() async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }
    final Map<String, dynamic> json = await _apiClient.fetchReports(token);
    return _reportSummaryFromJson(json);
  }
}

ReportSummary _reportSummaryFromJson(Map<String, dynamic> json) {
  final List<Map<String, dynamic>> sectorRows =
      (json['sector_scores'] as List<dynamic>).cast<Map<String, dynamic>>();
  final Map<String, dynamic> accuracy = json['forecast_accuracy'] as Map<String, dynamic>;
  final Map<String, dynamic> adoption = json['app_adoption'] as Map<String, dynamic>;

  return ReportSummary(
    monthLabel: json['month_label'] as String,
    comparedToLabel: json['compared_to_label'] as String,
    averageHealthScore: json['average_health_score'] as int,
    averageHealthScoreDelta: json['average_health_score_delta'] as int,
    flagsResolved: json['flags_resolved'] as int,
    flagsOpened: json['flags_opened'] as int,
    averageResolutionDays: json['average_resolution_days'] as int,
    visitsDone: json['visits_done'] as int,
    riskLedVisits: json['risk_led_visits'] as int,
    sectorScores: sectorRows
        .map(
          (Map<String, dynamic> row) => SectorScore(
            icon: row['icon'] as String,
            label: row['label'] as String,
            enterpriseCount: row['enterprise_count'] as int,
            averageScore: row['average_score'] as int,
          ),
        )
        .toList(),
    insight: json['insight'] as String,
    forecastAccuracy: ForecastAccuracy(
      predictedVsActualLabel: accuracy['predicted_vs_actual_label'] as String,
      flagsThatCameTrue: accuracy['flags_that_came_true'] as int,
      flagsRaised: accuracy['flags_raised'] as int,
      falseAlarms: accuracy['false_alarms'] as int,
    ),
    appAdoption: AppAdoption(
      enterprisesWithStreak: adoption['enterprises_with_streak'] as int,
      totalEnterprises: adoption['total_enterprises'] as int,
      voiceEntryUsers: adoption['voice_entry_users'] as int,
      activeSavingsPlans: adoption['active_savings_plans'] as int,
    ),
  );
}
