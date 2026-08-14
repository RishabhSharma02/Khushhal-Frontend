/// Device sync/entry freshness triage, backed by
/// `Khushhal-Backend`'s `/api/officer/v1/sync-status` endpoint.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/sync_status.dart';
import 'officer_api_client.dart';

/// The Data sync screen's KPI row plus the stale-device table.
typedef SyncStatusSummary = ({
  int syncedUnder24h,
  int synced1To7Days,
  int stale7Plus,
  int entryGap5Plus,
  List<DeviceSyncStatus> rows,
});

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network.
abstract class SyncStatusRepository {
  Future<SyncStatusSummary> fetchSyncStatus();
}

class ApiSyncStatusRepository implements SyncStatusRepository {
  ApiSyncStatusRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
    : _injectedFirebaseAuth = firebaseAuth,
      _apiClient = apiClient ?? OfficerApiClient();

  final FirebaseAuth? _injectedFirebaseAuth;
  final OfficerApiClient _apiClient;

  // Lazy for the same reason as FirebaseOfficerAuthRepository — see that
  // file for why eager FirebaseAuth.instance access is unsafe here.
  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<SyncStatusSummary> fetchSyncStatus() async {
    final String? token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) {
      throw const OfficerApiException('Not signed in');
    }
    final Map<String, dynamic> json = await _apiClient.fetchSyncStatus(token);
    return (
      syncedUnder24h: json['synced_under_24h_count'] as int,
      synced1To7Days: json['synced_1_to_7_days_count'] as int,
      stale7Plus: json['synced_stale_7_plus_count'] as int,
      entryGap5Plus: json['entry_gap_5_plus_count'] as int,
      rows: (json['rows'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_deviceSyncStatusFromJson)
          .toList(),
    );
  }
}

DeviceSyncStatus _deviceSyncStatusFromJson(Map<String, dynamic> json) {
  return DeviceSyncStatus(
    enterpriseId: json['enterprise_id'] as String,
    enterpriseName: json['enterprise_name'] as String,
    village: json['village'] as String,
    lastSyncDays: json['last_sync_days'] as int,
    lastEntryDays: json['last_entry_days'] as int,
    pendingEstimateLabel: json['pending_estimate_label'] as String,
    likelyCause: json['likely_cause'] as String,
    actionKind: SyncActionKind.values.byName(json['action_kind'] as String),
    actionLabel: json['action_label'] as String,
  );
}
