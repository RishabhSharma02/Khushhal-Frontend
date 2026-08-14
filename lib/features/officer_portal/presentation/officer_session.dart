/// App-wide state shared by every Officer Portal screen after login.
library;

import 'package:flutter/widgets.dart';

import '../data/action_plan_repository.dart';
import '../data/dashboard_repository.dart';
import '../data/enterprises_repository.dart';
import '../data/officer_demo_data.dart';
import '../data/profile_repository.dart';
import '../data/reports_repository.dart';
import '../data/sync_status_repository.dart';
import '../data/visits_repository.dart';
import '../domain/enterprise.dart';
import '../domain/officer_profile.dart';
import '../domain/visit.dart';

/// The running state of the Officer Portal: officer, enterprises, visits.
///
/// One instance lives above the shell; screens reach it through
/// [OfficerSessionScope]. Action plan / contact history are backend-owned
/// (see [actionPlanRepository]) and fetched/mutated directly by
/// `EnterpriseDetailScreen`, not cached here — they're only ever needed for
/// whichever one enterprise is currently open. Dashboard trends, reports,
/// and sync status work the same way via their own repository getters.
class OfficerSession extends ChangeNotifier {
  /// Starts a fresh session over the demo dataset — used only before
  /// sign-in / right after logout, so it never actually renders the shell.
  OfficerSession()
    : _profile = OfficerDemoData.officer,
      _enterprisesRepository = null,
      _actionPlanRepository = null,
      _visitsRepository = null,
      _syncStatusRepository = null,
      _dashboardRepository = null,
      _reportsRepository = null,
      _profileRepository = null,
      _enterprises = List<Enterprise>.of(OfficerDemoData.enterprises),
      _visits = List<Visit>.of(OfficerDemoData.visits);

  /// Starts a session for an officer who just signed in via the real
  /// backend (see `officer_auth_repository.dart`). Call [loadEnterprises]
  /// and [loadVisits] right after construction — see
  /// `officer_portal_root.dart`'s loading phase.
  OfficerSession.authenticated(
    OfficerProfile profile, {
    required EnterprisesRepository enterprisesRepository,
    required ActionPlanRepository actionPlanRepository,
    required VisitsRepository visitsRepository,
    required SyncStatusRepository syncStatusRepository,
    required DashboardRepository dashboardRepository,
    required ReportsRepository reportsRepository,
    required ProfileRepository profileRepository,
  }) : _profile = profile,
       _enterprisesRepository = enterprisesRepository,
       _actionPlanRepository = actionPlanRepository,
       _visitsRepository = visitsRepository,
       _syncStatusRepository = syncStatusRepository,
       _dashboardRepository = dashboardRepository,
       _reportsRepository = reportsRepository,
       _profileRepository = profileRepository,
       _enterprises = <Enterprise>[],
       _visits = <Visit>[];

  OfficerProfile _profile;

  /// The signed-in officer.
  OfficerProfile get profile => _profile;

  /// Stamps the session start time — called right after login succeeds.
  void markSignedIn(DateTime time) {
    _profile = _profile.withSignedInSince(time);
    notifyListeners();
  }

  /// Persists edits from the Profile screen's "Edit" dialog to the backend,
  /// then adopts whatever it returns as the new profile.
  Future<void> updateProfile({String? fullName, String? mobile}) async {
    final ProfileRepository? repository = _profileRepository;
    if (repository == null) return;

    _profile = await repository.updateProfile(fullName: fullName, mobile: mobile);
    notifyListeners();
  }

  final EnterprisesRepository? _enterprisesRepository;

  /// Exposed so the enterprise detail screen can fetch cash-flow/data
  /// quality directly — those aren't preloaded with the list.
  EnterprisesRepository? get enterprisesRepository => _enterprisesRepository;

  final ActionPlanRepository? _actionPlanRepository;

  /// Exposed so the enterprise detail screen can fetch/mutate the action
  /// plan and contact history directly.
  ActionPlanRepository? get actionPlanRepository => _actionPlanRepository;

  final SyncStatusRepository? _syncStatusRepository;

  /// Exposed so the Data sync screen can fetch its triage table directly —
  /// it's only ever needed there, not preloaded like enterprises/visits.
  SyncStatusRepository? get syncStatusRepository => _syncStatusRepository;

  final DashboardRepository? _dashboardRepository;

  /// Exposed so the Dashboard screen can fetch its trend data directly.
  DashboardRepository? get dashboardRepository => _dashboardRepository;

  final ReportsRepository? _reportsRepository;

  /// Exposed so the Reports screen can fetch its month-in-review directly.
  ReportsRepository? get reportsRepository => _reportsRepository;

  final ProfileRepository? _profileRepository;

  List<Enterprise> _enterprises;
  bool _enterprisesLoading = false;
  String? _enterprisesError;

  /// Every enterprise on the officer's beat.
  List<Enterprise> get enterprises => List<Enterprise>.unmodifiable(_enterprises);

  /// Whether [loadEnterprises] is in flight.
  bool get enterprisesLoading => _enterprisesLoading;

  /// The last [loadEnterprises] failure, if any.
  String? get enterprisesError => _enterprisesError;

  /// Fetches the officer's enterprises from the backend. Called once, right
  /// after sign-in, by `officer_portal_root.dart`'s loading phase.
  Future<void> loadEnterprises() async {
    final EnterprisesRepository? repository = _enterprisesRepository;
    if (repository == null) return;

    _enterprisesLoading = true;
    notifyListeners();
    try {
      _enterprises = await repository.fetchEnterprises();
      _enterprisesError = null;
    } catch (e) {
      _enterprisesError = e.toString();
    } finally {
      _enterprisesLoading = false;
      notifyListeners();
    }
  }

  /// Looks up one enterprise by id.
  Enterprise enterpriseById(String id) {
    return _enterprises.firstWhere(
      (Enterprise e) => e.id == id,
      orElse: () => _enterprises.first,
    );
  }

  /// Enterprises with an open flag, highest severity first — the dashboard's
  /// risk queue and the enterprise list's default sort both read this.
  List<Enterprise> get riskQueue {
    final List<Enterprise> atRisk = enterprises
        .where((Enterprise e) => e.riskLevel == RiskLevel.atRisk)
        .toList();
    final List<Enterprise> watch = enterprises
        .where((Enterprise e) => e.riskLevel == RiskLevel.watch)
        .toList();
    return <Enterprise>[...atRisk, ...watch];
  }

  final VisitsRepository? _visitsRepository;
  List<Visit> _visits;
  bool _visitsLoading = false;
  String? _visitsError;

  /// The officer's logged visits, newest first.
  List<Visit> get visits => List<Visit>.unmodifiable(_visits);

  /// Whether [loadVisits] is in flight.
  bool get visitsLoading => _visitsLoading;

  /// The last [loadVisits] failure, if any.
  String? get visitsError => _visitsError;

  /// The next visit still to happen, if any. Always `null` against real
  /// data today — logging a visit always creates a "done" row (see
  /// add_visit_dialog.dart's docstring: this app logs visits after the
  /// fact, it doesn't schedule them) — kept for when scheduling exists.
  Visit? get nextVisit {
    for (final Visit visit in _visits) {
      if (visit.status == VisitStatus.next) {
        return visit;
      }
    }
    return null;
  }

  /// Fetches the officer's visits from the backend. Called once, right
  /// after sign-in, by `officer_portal_root.dart`'s loading phase.
  Future<void> loadVisits() async {
    final VisitsRepository? repository = _visitsRepository;
    if (repository == null) return;

    _visitsLoading = true;
    notifyListeners();
    try {
      _visits = await repository.fetchVisits();
      _visitsError = null;
    } catch (e) {
      _visitsError = e.toString();
    } finally {
      _visitsLoading = false;
      notifyListeners();
    }
  }

  /// Records a new visit from the Add-visit dialog (5n).
  Future<void> addVisit({
    required String businessId,
    required DateTime date,
    required String agenda,
    RiskLevel? riskLevel,
  }) async {
    final VisitsRepository? repository = _visitsRepository;
    if (repository == null) return;

    final Visit visit = await repository.addVisit(
      businessId: businessId,
      date: date,
      agenda: agenda,
      riskLevel: riskLevel,
    );
    _visits.insert(0, visit);
    notifyListeners();
  }
}

/// Hosts the [OfficerSession] for the widget tree.
///
/// ```dart
/// final OfficerSession session = OfficerSessionScope.of(context);
/// ```
class OfficerSessionScope extends InheritedNotifier<OfficerSession> {
  /// Exposes [session] to descendants.
  const OfficerSessionScope({
    super.key,
    required OfficerSession session,
    required super.child,
  }) : super(notifier: session);

  /// The nearest session, registering for rebuilds on change.
  static OfficerSession of(BuildContext context) {
    final OfficerSessionScope? scope = context
        .dependOnInheritedWidgetOfExactType<OfficerSessionScope>();

    assert(scope != null, 'No OfficerSessionScope above this context');
    return scope!.notifier!;
  }
}
