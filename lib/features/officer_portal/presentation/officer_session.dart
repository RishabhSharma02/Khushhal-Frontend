/// App-wide state shared by every Officer Portal screen after login.
library;

import 'package:flutter/widgets.dart';

import '../data/officer_demo_data.dart';
import '../domain/action_step.dart';
import '../domain/contact_log.dart';
import '../domain/enterprise.dart';
import '../domain/officer_profile.dart';
import '../domain/visit.dart';

/// The running state of the Officer Portal: officer, enterprises, visits.
///
/// One instance lives above the shell; screens reach it through
/// [OfficerSessionScope]. Enterprise/report/sync content is demo data from
/// [OfficerDemoData] until there is a backend; visits the officer adds are
/// live state.
class OfficerSession extends ChangeNotifier {
  /// Starts a fresh session over the demo dataset.
  OfficerSession()
    : _profile = OfficerDemoData.officer,
      _visits = List<Visit>.of(OfficerDemoData.visits);

  OfficerProfile _profile;

  /// The signed-in officer.
  OfficerProfile get profile => _profile;

  /// Stamps the session start time — called right after login succeeds.
  void markSignedIn(DateTime time) {
    _profile = _profile.withSignedInSince(time);
    notifyListeners();
  }

  /// Applies edits from the Profile screen's "Edit" dialog.
  void updateProfile({String? fullName, String? mobile}) {
    _profile = _profile.withDetails(fullName: fullName, mobile: mobile);
    notifyListeners();
  }

  /// Every enterprise on the officer's beat.
  List<Enterprise> get enterprises =>
      List<Enterprise>.unmodifiable(OfficerDemoData.enterprises);

  /// Looks up one enterprise by id.
  Enterprise enterpriseById(String id) => OfficerDemoData.enterpriseById(id);

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

  final List<Visit> _visits;

  /// The officer's visit plan, in mock order (done, then next, then
  /// upcoming).
  List<Visit> get visits => List<Visit>.unmodifiable(_visits);

  /// The next visit still to happen, if any.
  Visit? get nextVisit {
    for (final Visit visit in _visits) {
      if (visit.status == VisitStatus.next) {
        return visit;
      }
    }
    return null;
  }

  /// Records a new visit from the Add-visit dialog (5n).
  void addVisit(Visit visit) {
    _visits.add(visit);
    notifyListeners();
  }

  final Map<String, List<ActionStep>> _actionSteps = <String, List<ActionStep>>{};

  List<ActionStep> _stepsFor(Enterprise enterprise) => _actionSteps
      .putIfAbsent(enterprise.id, () => List<ActionStep>.of(OfficerDemoData.actionPlanFor(enterprise)));

  /// The enterprise's action plan, including any manually-added or
  /// since-deleted edits made this session.
  List<ActionStep> actionStepsFor(Enterprise enterprise) =>
      List<ActionStep>.unmodifiable(_stepsFor(enterprise));

  /// Appends a manually-authored step to an enterprise's action plan.
  void addActionStep({
    required String enterpriseId,
    required String title,
    required String detail,
    required ActionStepImpact impact,
  }) {
    final List<ActionStep> steps = _stepsFor(enterpriseById(enterpriseId));
    steps.add(
      ActionStep(
        order: steps.length + 1,
        title: title,
        detail: detail,
        impact: impact,
      ),
    );
    notifyListeners();
  }

  /// Replaces an existing step's content in place (its order is kept).
  void updateActionStep({
    required String enterpriseId,
    required ActionStep original,
    required String title,
    required String detail,
    required ActionStepImpact impact,
  }) {
    final List<ActionStep> steps = _stepsFor(enterpriseById(enterpriseId));
    final int index = steps.indexOf(original);
    if (index == -1) return;
    steps[index] = ActionStep(
      order: original.order,
      title: title,
      detail: detail,
      impact: impact,
    );
    notifyListeners();
  }

  /// Removes a step from an enterprise's action plan and renumbers the rest.
  void removeActionStep({
    required String enterpriseId,
    required ActionStep step,
  }) {
    final List<ActionStep> steps = _stepsFor(enterpriseById(enterpriseId));
    steps.remove(step);
    for (int i = 0; i < steps.length; i++) {
      final ActionStep current = steps[i];
      steps[i] = ActionStep(
        order: i + 1,
        title: current.title,
        detail: current.detail,
        impact: current.impact,
      );
    }
    notifyListeners();
  }

  final Map<String, List<ContactLogEntry>> _contactHistory =
      <String, List<ContactLogEntry>>{};

  List<ContactLogEntry> _historyFor(Enterprise enterprise) => _contactHistory
      .putIfAbsent(
        enterprise.id,
        () => List<ContactLogEntry>.of(OfficerDemoData.contactHistoryFor(enterprise)),
      );

  /// The enterprise's visit/call history, newest first, including any notes
  /// added this session.
  List<ContactLogEntry> contactHistoryFor(Enterprise enterprise) {
    final List<ContactLogEntry> entries = List<ContactLogEntry>.of(
      _historyFor(enterprise),
    )..sort((ContactLogEntry a, ContactLogEntry b) => b.date.compareTo(a.date));
    return List<ContactLogEntry>.unmodifiable(entries);
  }

  /// Appends a manually-authored note to an enterprise's contact history.
  void addContactNote({
    required String enterpriseId,
    required DateTime date,
    required ContactKind kind,
    required String note,
  }) {
    _historyFor(
      enterpriseById(enterpriseId),
    ).add(ContactLogEntry(date: date, kind: kind, note: note));
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
