/// The officer's assigned enterprises, backed by
/// `Khushhal-Backend`'s `/api/officer/v1/enterprises` endpoints.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/enterprise.dart';
import '../domain/forecast_month.dart';
import 'officer_api_client.dart';

/// Data quality stats for one enterprise's detail page.
typedef DataQuality = ({int entryStreakDaysPerWeek, int forecastConfidencePercent});

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network — see `test/officer_portal_flow_test.dart`.
abstract class EnterprisesRepository {
  Future<List<Enterprise>> fetchEnterprises();
  Future<List<CashFlowMonth>> fetchCashFlow(String enterpriseId);
  Future<DataQuality> fetchDataQuality(String enterpriseId);
}

class ApiEnterprisesRepository implements EnterprisesRepository {
  ApiEnterprisesRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  // Lazy for the same reason as FirebaseOfficerAuthRepository — this
  // repository is constructed once at app start; resolving FirebaseAuth
  // eagerly would throw if Firebase isn't configured, even though it will
  // always be signed in for real by the time these methods are called.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  Future<String> _idToken() async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }
    return token;
  }

  @override
  Future<List<Enterprise>> fetchEnterprises() async {
    final String token = await _idToken();
    final List<Map<String, dynamic>> rows = await _apiClient.fetchEnterprises(token);
    return rows.map(_enterpriseFromJson).toList();
  }

  @override
  Future<List<CashFlowMonth>> fetchCashFlow(String enterpriseId) async {
    final String token = await _idToken();
    final List<Map<String, dynamic>> rows = await _apiClient.fetchCashFlow(token, enterpriseId);
    return rows.map(_cashFlowMonthFromJson).toList();
  }

  @override
  Future<DataQuality> fetchDataQuality(String enterpriseId) async {
    final String token = await _idToken();
    final Map<String, dynamic> json = await _apiClient.fetchDataQuality(token, enterpriseId);
    return (
      entryStreakDaysPerWeek: json['entry_streak_days_per_week'] as int,
      forecastConfidencePercent: json['forecast_confidence_percent'] as int,
    );
  }
}

Enterprise _enterpriseFromJson(Map<String, dynamic> json) {
  final Map<String, dynamic> contact = json['contact'] as Map<String, dynamic>;
  final Map<String, dynamic> financials = json['financials'] as Map<String, dynamic>;

  return Enterprise(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String,
    segment: EnterpriseSegment.values.byName(json['segment'] as String),
    sector: EnterpriseSector.values.byName(json['sector'] as String),
    village: json['village'] as String,
    establishedYear: json['established_year'] as int,
    staffCount: json['staff_count'] as int,
    memberSince: DateTime.parse(json['member_since'] as String),
    contact: EnterpriseContact(
      name: contact['name'] as String,
      role: contact['role'] as String,
      phone: contact['phone'] as String,
      language: contact['language'] as String,
      bestTime: contact['best_time'] as String,
    ),
    healthScore: json['health_score'] as int,
    scoreRising: json['score_rising'] as bool,
    riskLevel: RiskLevel.values.byName(json['risk_level'] as String),
    flagSummary: json['flag_summary'] as String?,
    financials: EnterpriseFinancials(
      cashOnHandInr: financials['cash_on_hand_inr'] as int,
      monthNetInr: financials['month_net_inr'] as int,
      savingsInr: financials['savings_inr'] as int,
      loanLeftInr: financials['loan_left_inr'] as int,
      emiInr: financials['emi_inr'] as int,
      emiOnTime: financials['emi_on_time'] as bool,
    ),
    lastSyncHoursAgo: json['last_sync_hours_ago'] as int?,
    staleDays: json['stale_days'] as int?,
  );
}

CashFlowMonth _cashFlowMonthFromJson(Map<String, dynamic> json) {
  return CashFlowMonth(
    label: json['label'] as String,
    moneyInInr: json['money_in_inr'] as int,
    moneyOutInr: json['money_out_inr'] as int,
    isForecast: json['is_forecast'] as bool,
    isFlagged: json['is_flagged'] as bool,
  );
}
