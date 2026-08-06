/// App-wide state shared by every screen after onboarding.
library;

import 'package:flutter/widgets.dart';

import 'demo_data.dart';
import 'model/business.dart';
import 'model/insights.dart';
import 'model/ledger.dart';

/// Network state, driving the sync chip and the offline home (1u).
enum ConnectivityStatus {
  /// Everything on the server.
  synced,

  /// Upload in progress.
  syncing,

  /// No network — a first-class state, not an error.
  offline,
}

/// The running state of the app: businesses, ledger, score, alerts, sync.
///
/// One instance lives above `MaterialApp`; screens reach it through
/// [SessionScope]. Model output (score, forecast, alerts) is demo content
/// from [DemoData] until there is a backend; everything the user edits
/// (businesses, entries, savings, loan, plan actions) is live state.
class AppSession extends ChangeNotifier {
  /// A session for a fresh install: no businesses yet, demo model output.
  AppSession()
    : _entries = List<LedgerEntry>.of(DemoData.entries),
      _current = DemoData.currentHealth,
      _pending = DemoData.pendingHealth,
      _alerts = List<RiskAlert>.of(DemoData.alerts),
      _actions = List<PlanAction>.of(DemoData.planActions);

  /// A session that starts fully set up — for tests and previews.
  factory AppSession.demo() {
    return AppSession().._businesses.add(DemoData.business);
  }

  // ── Profile ────────────────────────────────────────────────────────────

  /// Owner's display name.
  String get ownerName => DemoData.ownerName;

  /// Owner's phone number.
  String get ownerPhone => DemoData.ownerPhone;

  // ── Guided setup ───────────────────────────────────────────────────────

  final List<Business> _businesses = <Business>[];

  /// Businesses set up so far, in creation order.
  List<Business> get businesses => List<Business>.unmodifiable(_businesses);

  int _plannedBusinessCount = 1;

  /// The count chosen on design 1i — how many the hub (1j) offers to set up.
  int get plannedBusinessCount => _plannedBusinessCount;

  set plannedBusinessCount(int value) {
    _plannedBusinessCount = value;
    notifyListeners();
  }

  bool _locationConfirmed = false;

  /// Whether design 1h has been confirmed.
  bool get locationConfirmed => _locationConfirmed;

  /// Confirms the (demo-detected) location.
  void confirmLocation() {
    _locationConfirmed = true;
    notifyListeners();
  }

  int _activeBusinessIndex = 0;

  /// The business every screen currently shows.
  Business? get activeBusiness =>
      _businesses.isEmpty ? null : _businesses[_activeBusinessIndex];

  /// Switches the active business (the name pill on home).
  void selectBusiness(int index) {
    if (index >= 0 && index < _businesses.length) {
      _activeBusinessIndex = index;
      notifyListeners();
    }
  }

  /// Records a finished business setup (end of 1k → 1m for one business).
  void addBusiness(Business business) {
    _businesses.add(business);
    notifyListeners();
  }

  // ── Money ──────────────────────────────────────────────────────────────

  int _savingsInr = DemoData.savings;

  /// Savings balance — editable on 1t.
  int get savingsInr => _savingsInr;

  set savingsInr(int value) {
    _savingsInr = value;
    notifyListeners();
  }

  int _loanInr = DemoData.loan;

  /// Outstanding loan — editable on 1t.
  int get loanInr => _loanInr;

  set loanInr(int value) {
    _loanInr = value;
    notifyListeners();
  }

  int _monthMoneyIn = DemoData.monthMoneyIn;

  /// Money IN so far this month.
  int get monthMoneyIn => _monthMoneyIn;

  int _monthMoneyOut = DemoData.monthMoneyOut;

  /// Money OUT so far this month.
  int get monthMoneyOut => _monthMoneyOut;

  /// Loan repaid so far this month.
  int get monthLoanPaid => DemoData.monthLoanPaid;

  // ── Ledger ─────────────────────────────────────────────────────────────

  final List<LedgerEntry> _entries;

  /// All entries, newest first.
  List<LedgerEntry> get entries => List<LedgerEntry>.unmodifiable(_entries);

  /// Entries saved on the phone but not on the server yet.
  int get pendingEntryCount => _entries
      .where((LedgerEntry e) => e.syncState != EntrySyncState.synced)
      .length;

  /// Saves an entry from design 1p and rolls it into the month's totals.
  ///
  /// Offline entries queue as pending — saving never fails.
  void addEntry(LedgerEntry entry) {
    final LedgerEntry stored = _connectivity == ConnectivityStatus.offline
        ? entry.withSyncState(EntrySyncState.pending)
        : entry;

    _entries.insert(0, stored);

    if (stored.kind == EntryKind.moneyIn) {
      _monthMoneyIn += stored.amountInr;
    } else {
      _monthMoneyOut += stored.amountInr;
    }

    notifyListeners();
  }

  // ── Score, forecast, alerts ────────────────────────────────────────────

  HealthSnapshot _current;

  /// The stamped score the month runs on.
  HealthSnapshot get health => _current;

  HealthSnapshot? _pending;

  /// The fresh month-end score, until the user opens it (1o2 → 1q2).
  HealthSnapshot? get pendingHealth => _pending;

  /// True while the "month closed" banner should show (1o2).
  bool get updateReady => _pending != null;

  /// Promotes the pending score once its reveal (1q2) has been seen.
  void acceptMonthlyUpdate() {
    final HealthSnapshot? pending = _pending;

    if (pending != null) {
      _current = pending;
      _pending = null;
      notifyListeners();
    }
  }

  /// The six-month forecast.
  List<ForecastMonth> get forecast => DemoData.forecast;

  final List<RiskAlert> _alerts;

  /// Active alerts, urgent first.
  List<RiskAlert> get alerts => List<RiskAlert>.unmodifiable(_alerts);

  final List<PlanAction> _actions;

  /// The current plan's actions (1s).
  List<PlanAction> get planActions => List<PlanAction>.unmodifiable(_actions);

  /// Marks a plan action done or not done.
  void setActionDone(PlanActionKind kind, bool done) {
    final int index = _actions.indexWhere((PlanAction a) => a.kind == kind);

    if (index >= 0 && _actions[index].done != done) {
      _actions[index] = _actions[index].withDone(done);
      notifyListeners();
    }
  }

  // ── Connectivity ───────────────────────────────────────────────────────

  ConnectivityStatus _connectivity = ConnectivityStatus.synced;

  /// Current network state.
  ConnectivityStatus get connectivity => _connectivity;

  set connectivity(ConnectivityStatus value) {
    if (_connectivity != value) {
      _connectivity = value;
      notifyListeners();
    }
  }

  /// Pushes every queued entry to the server (1w's "Sync now").
  void syncNow() {
    for (int i = 0; i < _entries.length; i++) {
      if (_entries[i].syncState != EntrySyncState.synced) {
        _entries[i] = _entries[i].withSyncState(EntrySyncState.synced);
      }
    }

    _connectivity = ConnectivityStatus.synced;
    notifyListeners();
  }
}

/// Hosts the [AppSession] for the widget tree.
///
/// ```dart
/// final AppSession session = SessionScope.of(context);
/// ```
class SessionScope extends InheritedNotifier<AppSession> {
  /// Exposes [session] to descendants.
  const SessionScope({
    super.key,
    required AppSession session,
    required super.child,
  }) : super(notifier: session);

  /// The nearest session, registering for rebuilds on change.
  static AppSession of(BuildContext context) {
    final SessionScope? scope = context
        .dependOnInheritedWidgetOfExactType<SessionScope>();

    assert(scope != null, 'No SessionScope above this context');
    return scope!.notifier!;
  }
}
