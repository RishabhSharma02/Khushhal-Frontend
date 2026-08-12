/// App-wide state shared by every screen after onboarding.
library;

import 'package:flutter/widgets.dart';

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
/// [SessionScope]. Nothing is seeded from demo data anymore — every field
/// starts empty/null and is filled by the backend (or by the user).
class AppSession extends ChangeNotifier {
  AppSession();

  /// Test-only convenience — kept as a no-op so pre-existing widget tests
  /// that call `AppSession.demo()` still compile.
  factory AppSession.demo() => AppSession();

  // ── Profile ────────────────────────────────────────────────────────────

  String? _ownerName;
  String? _ownerPhone;

  String? get ownerName => _ownerName;
  String? get ownerPhone => _ownerPhone;

  /// Called by the auth flow when a user's session is exchanged with the
  /// backend so Settings / mPIN unlock can display their name + phone.
  void applyProfile({String? name, String? phone}) {
    _ownerName = name;
    _ownerPhone = phone;
    notifyListeners();
  }

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

  /// Confirms the location.
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

  /// Wholesale replace — used by the Home-side BusinessListLoader when it
  /// fetches `GET /api/v1/businesses` on cold restart. Preserves the active
  /// index when possible.
  void applyBusinessList(List<Business> businesses, List<int?> backendIds) {
    _businesses
      ..clear()
      ..addAll(businesses);
    _backendBusinessIds
      ..clear()
      ..addAll(backendIds);
    if (_activeBusinessIndex >= _businesses.length) {
      _activeBusinessIndex = _businesses.isEmpty ? 0 : _businesses.length - 1;
    }
    notifyListeners();
  }

  // Backend id per business (populated after a successful POST /businesses).
  // Parallel to [_businesses] by index; missing entries fall back to null.
  final List<int?> _backendBusinessIds = <int?>[];

  /// Read-only view of backend ids in the same order as [businesses].
  List<int?> get backendBusinessIds => List<int?>.unmodifiable(_backendBusinessIds);

  /// The backend id assigned to the currently-active business, if any.
  int? get activeBackendBusinessId {
    if (_activeBusinessIndex >= _backendBusinessIds.length) return null;
    return _backendBusinessIds[_activeBusinessIndex];
  }

  /// Records the backend-assigned id for the most recently added business.
  /// Called by SetupFlow after `POST /api/v1/businesses` returns.
  void registerBackendBusinessId(int id) {
    while (_backendBusinessIds.length < _businesses.length - 1) {
      _backendBusinessIds.add(null);
    }
    _backendBusinessIds.add(id);
    notifyListeners();
  }

  // ── Money ──────────────────────────────────────────────────────────────

  int _savingsInr = 0;
  int _loanInr = 0;
  int _monthMoneyIn = 0;
  int _monthMoneyOut = 0;
  final int _monthLoanPaid = 0;

  int get savingsInr => _savingsInr;

  set savingsInr(int value) {
    _savingsInr = value;
    notifyListeners();
  }

  int get loanInr => _loanInr;

  set loanInr(int value) {
    _loanInr = value;
    notifyListeners();
  }

  int get monthMoneyIn => _monthMoneyIn;
  int get monthMoneyOut => _monthMoneyOut;
  int get monthLoanPaid => _monthLoanPaid;

  /// True when any money-related field has a non-zero value — Home uses
  /// this to decide between real numbers and a "—" placeholder on tiles.
  bool get hasAnyMoneyData =>
      _savingsInr > 0 || _loanInr > 0 || _monthMoneyIn > 0 || _monthMoneyOut > 0 || _monthLoanPaid > 0;

  // ── Ledger ─────────────────────────────────────────────────────────────

  final List<LedgerEntry> _entries = <LedgerEntry>[];

  /// All entries, newest first.
  List<LedgerEntry> get entries => List<LedgerEntry>.unmodifiable(_entries);

  /// Entries saved on the phone but not on the server yet.
  int get pendingEntryCount => _entries
      .where((LedgerEntry e) => e.syncState != EntrySyncState.synced)
      .length;

  /// Bulk-populate from `GET /entries` after cold restart. Replaces the
  /// current entry list and recomputes month-to-date IN / OUT totals.
  void applyLiveEntries(List<LedgerEntry> entries) {
    _entries
      ..clear()
      ..addAll(entries);
    _monthMoneyIn = 0;
    _monthMoneyOut = 0;
    final now = DateTime.now();
    for (final e in entries) {
      final sameMonth = e.recordedAt.year == now.year && e.recordedAt.month == now.month;
      if (!sameMonth) continue;
      if (e.kind == EntryKind.moneyIn) {
        _monthMoneyIn += e.amountInr;
      } else {
        _monthMoneyOut += e.amountInr;
      }
    }
    notifyListeners();
  }

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

  HealthSnapshot? _current;

  /// The stamped score the month runs on — null until the ML pipeline
  /// stamps one for the active business.
  HealthSnapshot? get health => _current;

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

  List<ForecastMonth>? _liveForecast;

  /// The six-month forecast — empty until the backend delivers one.
  List<ForecastMonth> get forecast => _liveForecast ?? const <ForecastMonth>[];

  /// Called by the insights loader whenever a fresh forecast arrives from
  /// `GET /api/v1/businesses/{id}/forecast`.
  void applyLiveForecast(List<ForecastMonth>? months) {
    _liveForecast = months;
    notifyListeners();
  }

  /// Replaces the stamped health snapshot with a live one from the backend.
  void applyLiveHealth(HealthSnapshot? snapshot) {
    _current = snapshot;
    notifyListeners();
  }

  /// Replaces the active alerts list with the live one from the backend.
  void applyLiveAlerts(List<RiskAlert>? alerts) {
    _alerts
      ..clear()
      ..addAll(alerts ?? const <RiskAlert>[]);
    notifyListeners();
  }

  final List<RiskAlert> _alerts = <RiskAlert>[];

  /// Active alerts, urgent first.
  List<RiskAlert> get alerts => List<RiskAlert>.unmodifiable(_alerts);

  final List<PlanAction> _actions = <PlanAction>[];

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
