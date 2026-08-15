/// An enterprise's officer-writable action plan and contact history,
/// backed by `Khushhal-Backend`'s `/api/officer/v1/enterprises/{id}/
/// action-steps` and `.../contact-log` endpoints.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/action_step.dart';
import '../domain/contact_log.dart';
import 'officer_api_client.dart';

/// Abstract so widget tests can inject a fake instead of talking to real
/// Firebase/network.
abstract class ActionPlanRepository {
  Future<List<ActionStep>> fetchActionSteps(String enterpriseId);

  Future<ActionStep> addActionStep(
    String enterpriseId, {
    required String title,
    required String detail,
    required ActionStepImpact impact,
  });

  Future<ActionStep> updateActionStep(
    String enterpriseId,
    int stepId, {
    required String title,
    required String detail,
    required ActionStepImpact impact,
  });

  Future<void> deleteActionStep(String enterpriseId, int stepId);

  Future<List<ContactLogEntry>> fetchContactLog(String enterpriseId);

  Future<ContactLogEntry> addContactNote(
    String enterpriseId, {
    required DateTime date,
    required ContactKind kind,
    required String note,
  });
}

class ApiActionPlanRepository implements ActionPlanRepository {
  ApiActionPlanRepository({FirebaseAuth? firebaseAuth, OfficerApiClient? apiClient})
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
  Future<List<ActionStep>> fetchActionSteps(String enterpriseId) async {
    final String token = await _idToken();
    final List<Map<String, dynamic>> rows = await _apiClient.fetchActionSteps(token, enterpriseId);
    return rows.map(_actionStepFromJson).toList();
  }

  @override
  Future<ActionStep> addActionStep(
    String enterpriseId, {
    required String title,
    required String detail,
    required ActionStepImpact impact,
  }) async {
    final String token = await _idToken();
    final Map<String, dynamic> json = await _apiClient.createActionStep(
      token, enterpriseId, <String, dynamic>{'title': title, 'detail': detail, 'impact': impact.name},
    );
    return _actionStepFromJson(json);
  }

  @override
  Future<ActionStep> updateActionStep(
    String enterpriseId,
    int stepId, {
    required String title,
    required String detail,
    required ActionStepImpact impact,
  }) async {
    final String token = await _idToken();
    final Map<String, dynamic> json = await _apiClient.updateActionStep(
      token, enterpriseId, stepId,
      <String, dynamic>{'title': title, 'detail': detail, 'impact': impact.name},
    );
    return _actionStepFromJson(json);
  }

  @override
  Future<void> deleteActionStep(String enterpriseId, int stepId) async {
    final String token = await _idToken();
    await _apiClient.deleteActionStep(token, enterpriseId, stepId);
  }

  @override
  Future<List<ContactLogEntry>> fetchContactLog(String enterpriseId) async {
    final String token = await _idToken();
    final List<Map<String, dynamic>> rows = await _apiClient.fetchContactLog(token, enterpriseId);
    return rows.map(_contactLogEntryFromJson).toList();
  }

  @override
  Future<ContactLogEntry> addContactNote(
    String enterpriseId, {
    required DateTime date,
    required ContactKind kind,
    required String note,
  }) async {
    final String token = await _idToken();
    final Map<String, dynamic> json = await _apiClient.createContactLogEntry(
      token, enterpriseId,
      <String, dynamic>{'occurred_at': date.toUtc().toIso8601String(), 'kind': kind.name, 'note': note},
    );
    return _contactLogEntryFromJson(json);
  }
}

ActionStep _actionStepFromJson(Map<String, dynamic> json) {
  return ActionStep(
    id: json['id'] as int,
    order: json['ordinal'] as int,
    title: json['title'] as String,
    detail: json['detail'] as String,
    impact: ActionStepImpact.values.byName(json['impact'] as String),
  );
}

ContactLogEntry _contactLogEntryFromJson(Map<String, dynamic> json) {
  return ContactLogEntry(
    date: DateTime.parse(json['occurred_at'] as String).toLocal(),
    kind: ContactKind.values.byName(json['kind'] as String),
    note: json['note'] as String,
  );
}
