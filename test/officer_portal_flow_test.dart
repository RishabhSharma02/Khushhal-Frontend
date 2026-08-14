import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/features/officer_portal/data/action_plan_repository.dart';
import 'package:khushhal/features/officer_portal/data/dashboard_repository.dart';
import 'package:khushhal/features/officer_portal/data/enterprises_repository.dart';
import 'package:khushhal/features/officer_portal/data/officer_auth_repository.dart';
import 'package:khushhal/features/officer_portal/data/officer_demo_data.dart';
import 'package:khushhal/features/officer_portal/data/profile_repository.dart';
import 'package:khushhal/features/officer_portal/data/reports_repository.dart';
import 'package:khushhal/features/officer_portal/data/sync_status_repository.dart';
import 'package:khushhal/features/officer_portal/data/visits_repository.dart';
import 'package:khushhal/features/officer_portal/domain/action_step.dart';
import 'package:khushhal/features/officer_portal/domain/contact_log.dart';
import 'package:khushhal/features/officer_portal/domain/enterprise.dart';
import 'package:khushhal/features/officer_portal/domain/forecast_month.dart';
import 'package:khushhal/features/officer_portal/domain/officer_profile.dart';
import 'package:khushhal/features/officer_portal/domain/report_summary.dart';
import 'package:khushhal/features/officer_portal/domain/visit.dart';
import 'package:khushhal/features/officer_portal/presentation/officer_portal_root.dart';

/// Stands in for [FirebaseOfficerAuthRepository] so widget tests never touch
/// real Firebase/network — any email/password combination signs in as the
/// demo officer.
class _FakeOfficerAuthRepository implements OfficerAuthRepository {
  @override
  Future<OfficerProfile> signIn({required String email, required String password}) async =>
      OfficerDemoData.officer;

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
  }) async => OfficerDemoData.officer;
}

/// Stands in for [ApiProfileRepository] so widget tests never hit the real
/// backend — updates the in-memory demo officer and returns it.
class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<OfficerProfile> updateProfile({String? fullName, String? mobile}) async {
    return OfficerProfile(
      fullName: fullName ?? OfficerDemoData.officer.fullName,
      employeeId: OfficerDemoData.officer.employeeId,
      employeeIdVerified: OfficerDemoData.officer.employeeIdVerified,
      pincode: OfficerDemoData.officer.pincode,
      block: OfficerDemoData.officer.block,
      state: OfficerDemoData.officer.state,
      email: OfficerDemoData.officer.email,
      mobile: mobile,
      coverage: OfficerDemoData.officer.coverage,
      signedInSince: OfficerDemoData.officer.signedInSince,
      deviceLabel: OfficerDemoData.officer.deviceLabel,
    );
  }
}

/// Stands in for [ApiEnterprisesRepository] so widget tests never hit the
/// real backend — serves the same demo dataset the UI was built against.
class _FakeEnterprisesRepository implements EnterprisesRepository {
  @override
  Future<List<Enterprise>> fetchEnterprises() async => OfficerDemoData.enterprises;

  @override
  Future<List<CashFlowMonth>> fetchCashFlow(String enterpriseId) async =>
      OfficerDemoData.cashFlowFor(OfficerDemoData.enterpriseById(enterpriseId));

  @override
  Future<DataQuality> fetchDataQuality(String enterpriseId) async =>
      OfficerDemoData.dataQualityFor(OfficerDemoData.enterpriseById(enterpriseId));
}

/// Stands in for [ApiActionPlanRepository] so widget tests never hit the
/// real backend — in-memory, seeded from the same demo dataset the UI was
/// built against.
class _FakeActionPlanRepository implements ActionPlanRepository {
  final Map<String, List<ActionStep>> _steps = <String, List<ActionStep>>{};
  final Map<String, List<ContactLogEntry>> _history = <String, List<ContactLogEntry>>{};
  int _nextStepId = 1;

  List<ActionStep> _stepsFor(String enterpriseId) => _steps.putIfAbsent(
    enterpriseId,
    () => List<ActionStep>.of(
      OfficerDemoData.actionPlanFor(OfficerDemoData.enterpriseById(enterpriseId)),
    ),
  );

  List<ContactLogEntry> _historyFor(String enterpriseId) => _history.putIfAbsent(
    enterpriseId,
    () => List<ContactLogEntry>.of(
      OfficerDemoData.contactHistoryFor(OfficerDemoData.enterpriseById(enterpriseId)),
    ),
  );

  @override
  Future<List<ActionStep>> fetchActionSteps(String enterpriseId) async => _stepsFor(enterpriseId);

  @override
  Future<ActionStep> addActionStep(
    String enterpriseId, {
    required String title,
    required String detail,
    required ActionStepImpact impact,
  }) async {
    final List<ActionStep> steps = _stepsFor(enterpriseId);
    final ActionStep step = ActionStep(
      id: _nextStepId++,
      order: steps.length + 1,
      title: title,
      detail: detail,
      impact: impact,
    );
    steps.add(step);
    return step;
  }

  @override
  Future<ActionStep> updateActionStep(
    String enterpriseId,
    int stepId, {
    required String title,
    required String detail,
    required ActionStepImpact impact,
  }) async {
    final List<ActionStep> steps = _stepsFor(enterpriseId);
    final int index = steps.indexWhere((ActionStep s) => s.id == stepId);
    final ActionStep updated = ActionStep(
      id: stepId,
      order: steps[index].order,
      title: title,
      detail: detail,
      impact: impact,
    );
    steps[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteActionStep(String enterpriseId, int stepId) async {
    final List<ActionStep> steps = _stepsFor(enterpriseId);
    steps.removeWhere((ActionStep s) => s.id == stepId);
    for (int i = 0; i < steps.length; i++) {
      final ActionStep s = steps[i];
      steps[i] = ActionStep(id: s.id, order: i + 1, title: s.title, detail: s.detail, impact: s.impact);
    }
  }

  @override
  Future<List<ContactLogEntry>> fetchContactLog(String enterpriseId) async {
    final List<ContactLogEntry> entries = List<ContactLogEntry>.of(_historyFor(enterpriseId))
      ..sort((ContactLogEntry a, ContactLogEntry b) => b.date.compareTo(a.date));
    return entries;
  }

  @override
  Future<ContactLogEntry> addContactNote(
    String enterpriseId, {
    required DateTime date,
    required ContactKind kind,
    required String note,
  }) async {
    final ContactLogEntry entry = ContactLogEntry(date: date, kind: kind, note: note);
    _historyFor(enterpriseId).add(entry);
    return entry;
  }
}

/// Stands in for [ApiVisitsRepository] so widget tests never hit the real
/// backend — in-memory, seeded from the same demo dataset the UI was built
/// against.
class _FakeVisitsRepository implements VisitsRepository {
  final List<Visit> _visits = List<Visit>.of(OfficerDemoData.visits);

  @override
  Future<List<Visit>> fetchVisits() async =>
      _visits.where((Visit v) => v.status == VisitStatus.done).toList();

  @override
  Future<Visit> addVisit({
    required String businessId,
    required DateTime date,
    required String agenda,
    RiskLevel? riskLevel,
  }) async {
    final Enterprise enterprise = OfficerDemoData.enterpriseById(businessId);
    final Visit visit = Visit(
      id: 'visit-$businessId-${date.millisecondsSinceEpoch}',
      enterpriseId: businessId,
      enterpriseName: enterprise.name,
      village: enterprise.village,
      date: date,
      agenda: agenda,
      status: VisitStatus.done,
      riskLevel: riskLevel,
    );
    _visits.add(visit);
    return visit;
  }
}

/// Stands in for [ApiSyncStatusRepository] so widget tests never hit the
/// real backend — serves the same demo dataset the UI was built against.
class _FakeSyncStatusRepository implements SyncStatusRepository {
  @override
  Future<SyncStatusSummary> fetchSyncStatus() async => (
    syncedUnder24h: OfficerDemoData.syncedUnder24hCount,
    synced1To7Days: OfficerDemoData.synced1To7DaysCount,
    stale7Plus: OfficerDemoData.syncedStale7PlusCount,
    entryGap5Plus: OfficerDemoData.entryGap5PlusCount,
    rows: OfficerDemoData.syncStatuses,
  );
}

/// Stands in for [ApiDashboardRepository] so widget tests never hit the
/// real backend — serves the same demo dataset the UI was built against.
class _FakeDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardTrends> fetchDashboard() async => (
    averageScoreHistory: OfficerDemoData.averageScoreHistory,
    averageScoreDelta: OfficerDemoData.averageScoreDelta,
    emisOnTimePercent: OfficerDemoData.emisOnTimePercent,
    emisOnTimeDelta: OfficerDemoData.emisOnTimeDelta,
    openFlagCount: OfficerDemoData.openFlagCount,
    openFlagDelta: OfficerDemoData.openFlagDelta,
    visitsDoneThisWeek: OfficerDemoData.visitsDoneThisWeek,
    visitsPlannedThisWeek: OfficerDemoData.visitsPlannedThisWeek,
  );
}

/// Stands in for [ApiReportsRepository] so widget tests never hit the real
/// backend — serves the same demo dataset the UI was built against.
class _FakeReportsRepository implements ReportsRepository {
  @override
  Future<ReportSummary> fetchReports() async => OfficerDemoData.reportSummary;
}

void main() {
  Future<void> setSurface(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> signIn(WidgetTester tester) async {
    await tester.pumpWidget(
      OfficerPortalRoot(
        authRepository: _FakeOfficerAuthRepository(),
        enterprisesRepository: _FakeEnterprisesRepository(),
        actionPlanRepository: _FakeActionPlanRepository(),
        visitsRepository: _FakeVisitsRepository(),
        syncStatusRepository: _FakeSyncStatusRepository(),
        dashboardRepository: _FakeDashboardRepository(),
        reportsRepository: _FakeReportsRepository(),
        profileRepository: _FakeProfileRepository(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'ramesh@khush-hal.in');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign in →'));
    await tester.pumpAndSettle();
  }

  for (final Size size in <Size>[const Size(1400, 900), const Size(390, 844)]) {
    final String sizeLabel = size.width > 1000 ? 'wide' : 'narrow';

    testWidgets('$sizeLabel: dashboard renders without overflow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      expect(find.text('Hello, Ramesh!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: enterprises list opens a detail screen', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.storefront_rounded));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Shanti Dairy').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('AI flag'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: visits screen renders without overflow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.event_note_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('logged'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: reports screen renders without overflow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.bar_chart_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('Reports —'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: profile and logout flow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();
      expect(find.text('My profile'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Log out ▸').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out ▸').first);
      await tester.pumpAndSettle();
      expect(find.text('Log out of KHUSH-HAL?'), findsOneWidget);

      await tester.tap(find.text('Log out ▸').last);
      await tester.pumpAndSettle();
      expect(find.text("You're signed out"), findsOneWidget);

      await tester.tap(find.text('Sign in again →'));
      await tester.pumpAndSettle();
      expect(find.text("KHUSH-HAL Officers' Portal"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('add-visit dialog records a new visit', (
    WidgetTester tester,
  ) async {
    await setSurface(tester, const Size(1400, 900));
    await signIn(tester);

    await tester.tap(find.text('+ Log visit'));
    await tester.pumpAndSettle();
    expect(find.text('Log visit'), findsOneWidget);

    await tester.tap(find.text('🔍 Search enterprise…'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lakshmi Foods'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log visit ✓'));
    await tester.pumpAndSettle();
    expect(find.text('Visit logged'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Back to visits'));
    await tester.pumpAndSettle();
  });
}
