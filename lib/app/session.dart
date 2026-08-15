/// App-wide state shared by every screen after onboarding.
library;

import 'package:flutter/widgets.dart';

import '../core/sync/sync_status.dart';
import 'model/assigned_officer.dart';
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

  /// Field officer linked to the active business, or null when the business
  /// has none. Home hides the officer card and the "Talk to officer" button
  /// hides its CTA in that case.
  AssignedOfficer? get activeAssignedOfficer => activeBusiness?.assignedOfficer;

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

  /// Mirrors an edit saved on Settings' edit sheet back into the session, so
  /// Home's name pill and health-card headline update without a restart.
  void updateBusiness(int index, Business business) {
    if (index >= 0 && index < _businesses.length) {
      _businesses[index] = business;
      notifyListeners();
    }
  }

  bool _businessesFetched = false;

  /// True once this session knows how many businesses the account really has.
  /// Consumers use this to distinguish "still loading" from "there are zero
  /// businesses" (which forces the setup flow).
  ///
  /// An empty list only counts once the server has been heard from. The list
  /// arrives from the local cache, which is also empty on a phone that has
  /// just been signed in to and has not synced yet — treating that as
  /// authoritative sent existing users back through onboarding.
  bool get businessesFetched => _businessesFetched;

  /// Wholesale replace — used by [InsightsLoader] as the cached business list
  /// changes. Preserves the active index when possible.
  ///
  /// [serverConfirmed] says whether a `GET /businesses` has landed on this
  /// device; an empty list without it is "we don't know yet", not "none".
  void applyBusinessList(
    List<Business> businesses,
    List<int?> backendIds, {
    bool serverConfirmed = true,
  }) {
    final int? activeId = activeBackendBusinessId;

    _businesses
      ..clear()
      ..addAll(businesses);
    _backendBusinessIds
      ..clear()
      ..addAll(backendIds);

    // Follow the business the user was looking at rather than its old index —
    // a refresh that reorders the list should not silently switch businesses.
    final int moved = activeId == null
        ? -1
        : _backendBusinessIds.indexOf(activeId);
    if (moved >= 0) {
      _activeBusinessIndex = moved;
    } else if (_activeBusinessIndex >= _businesses.length) {
      _activeBusinessIndex = _businesses.isEmpty ? 0 : _businesses.length - 1;
    }
    if (businesses.isNotEmpty || serverConfirmed) _businessesFetched = true;
    // Drop state for businesses the server no longer lists, so a deleted
    // business cannot leave its entries or score behind for a later id to
    // pick up.
    final Set<int> live = backendIds.whereType<int>().toSet();
    _byBusiness.removeWhere((int id, _) => !live.contains(id));
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

  /// True while a business sits in the session without a backend id — the
  /// window between the setup wizard adding it and `POST /businesses`
  /// returning. A cache refresh landing inside that window would drop the
  /// half-created business, so the loader waits it out.
  bool get hasUnsavedBusiness =>
      _businesses.length > _backendBusinessIds.whereType<int>().length;

  /// Wipes the business list and per-business state without touching the
  /// signed-in profile. Called by [InsightsLoader] on mount so a fresh
  /// sign-in never sees leftover state from the previous user while its own
  /// `GET /businesses` is still in flight.
  void resetBusinessList() {
    if (hasUnsavedBusiness) return;
    if (_businesses.isEmpty
        && _backendBusinessIds.isEmpty
        && !_businessesFetched
        && _byBusiness.isEmpty) {
      return;
    }
    _businesses.clear();
    _backendBusinessIds.clear();
    _byBusiness.clear();
    _activeBusinessIndex = 0;
    _businessesFetched = false;
    notifyListeners();
  }

  /// Fills in the officer contact card for one business after
  /// `GET /officers/{id}` returns. Home reads the result via
  /// [activeAssignedOfficer] and rebuilds when this notifies.
  void applyAssignedOfficer(int businessBackendId, AssignedOfficer? officer) {
    final int idx = _backendBusinessIds.indexOf(businessBackendId);
    if (idx < 0 || idx >= _businesses.length) return;
    if (_businesses[idx].assignedOfficer == officer) return;
    _businesses[idx] = _businesses[idx].copyWith(assignedOfficer: officer);
    notifyListeners();
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

  // ── Per-business state ─────────────────────────────────────────────────

  /// Ledger and insights for one business, keyed by backend id.
  ///
  /// Everything in here used to be a single global value, which meant the
  /// first business you opened decided what every other one displayed.
  final Map<int, _BusinessState> _byBusiness = <int, _BusinessState>{};

  _BusinessState? _activeState() {
    final int? id = activeBackendBusinessId;
    return id == null ? null : _byBusiness[id];
  }

  _BusinessState _stateFor(int businessId) =>
      _byBusiness.putIfAbsent(businessId, _BusinessState.new);

  // ── Money ──────────────────────────────────────────────────────────────

  /// Savings held for the active business.
  int get savingsInr => activeBusiness?.savingsInr ?? 0;

  set savingsInr(int value) => _replaceActive(
    (Business b) => b.copyWith(savingsInr: value),
  );

  /// Loan outstanding for the active business.
  int get loanInr => activeBusiness?.loanInr ?? 0;

  set loanInr(int value) => _replaceActive(
    (Business b) => b.copyWith(loanInr: value),
  );

  void _replaceActive(Business Function(Business) change) {
    final Business? biz = activeBusiness;
    if (biz == null) return;
    _businesses[_activeBusinessIndex] = change(biz);
    notifyListeners();
  }

  /// Money in for the running month: the active business's own ledger total
  /// once it has entries this month, and the figure typed on setup until then.
  int get monthMoneyIn => _money().moneyIn;

  /// Money out for the running month, on the same basis as [monthMoneyIn].
  int get monthMoneyOut => _money().moneyOut;

  /// True when the month's figures come from ledger entries rather than the
  /// setup baseline. The money tiles use it to decide whether there is a
  /// "moved from" figure worth showing.
  bool get moneyIsFromLedger => _money().fromLedger;

  /// The setup baseline this business started from, whatever the tiles are
  /// currently showing.
  MonthlyMoney? get baseline {
    final MonthlyMoney? snap = activeBusiness?.monthly;
    if (snap == null || !snap.hasBaseline) return null;
    return snap;
  }

  ({int moneyIn, int moneyOut, bool fromLedger}) _money() {
    final List<LedgerEntry> rows = _activeState()?.entries ?? const [];
    final DateTime now = DateTime.now();
    int liveIn = 0;
    int liveOut = 0;
    bool sawCurrentMonth = false;

    for (final LedgerEntry e in rows) {
      if (e.recordedAt.year != now.year || e.recordedAt.month != now.month) {
        continue;
      }
      sawCurrentMonth = true;
      if (e.kind == EntryKind.moneyIn) {
        liveIn += e.amountInr;
      } else {
        liveOut += e.amountInr;
      }
    }

    if (sawCurrentMonth) {
      return (moneyIn: liveIn, moneyOut: liveOut, fromLedger: true);
    }

    final MonthlyMoney? snap = activeBusiness?.monthly;
    return (
      moneyIn: snap?.moneyIn ?? 0,
      moneyOut: snap?.moneyOut ?? 0,
      fromLedger: false,
    );
  }

  // ── Ledger ─────────────────────────────────────────────────────────────

  /// The active business's entries, newest first.
  List<LedgerEntry> get entries =>
      List<LedgerEntry>.unmodifiable(_activeState()?.entries ?? const []);

  /// Entries saved on this phone but not on the server yet, across every
  /// business — the offline banner is about the device, not one business.
  int get pendingEntryCount => _byBusiness.values
      .expand((_BusinessState s) => s.entries)
      .where((LedgerEntry e) => e.syncState != EntrySyncState.synced)
      .length;

  /// Replaces one business's entries from its Drift history stream.
  void applyLiveEntries(int businessId, List<LedgerEntry> entries) {
    _stateFor(businessId).entries = List<LedgerEntry>.of(entries);
    notifyListeners();
  }

  /// Saves an entry from design 1p against the business it belongs to.
  ///
  /// Always pending on arrival. Every entry goes to SQLite first and reaches
  /// the server only through a sync cycle, so "am I online?" has no bearing on
  /// the state of a just-written row — the outbox decides when it flips to
  /// synced, and the Drift stream reports it.
  void addEntry(int businessId, LedgerEntry entry) {
    final _BusinessState state = _stateFor(businessId);
    state.entries = <LedgerEntry>[
      entry.withSyncState(EntrySyncState.pending),
      ...state.entries,
    ];
    notifyListeners();
  }

  // ── Score, forecast, alerts ────────────────────────────────────────────
  //
  // All three are stamped per business on the backend, so all three are held
  // per business here.

  /// The stamped score the month runs on — null until the ML pipeline
  /// stamps one for the active business.
  HealthSnapshot? get health => _activeState()?.health;

  /// The fresh month-end score, until the user opens it (1o2 → 1q2).
  HealthSnapshot? get pendingHealth => _activeState()?.pendingHealth;

  /// True while the "month closed" banner should show (1o2).
  bool get updateReady => pendingHealth != null;

  /// Promotes the pending score once its reveal (1q2) has been seen.
  void acceptMonthlyUpdate() {
    final _BusinessState? state = _activeState();
    final HealthSnapshot? pending = state?.pendingHealth;

    if (state != null && pending != null) {
      state.health = pending;
      state.pendingHealth = null;
      notifyListeners();
    }
  }

  /// The six-month forecast — empty until the backend delivers one.
  List<ForecastMonth> get forecast =>
      _activeState()?.forecast ?? const <ForecastMonth>[];

  /// Called by the insights loader whenever a fresh forecast arrives from
  /// `GET /api/v1/businesses/{id}/forecast`.
  void applyLiveForecast(int businessId, List<ForecastMonth>? months) {
    _stateFor(businessId).forecast = months ?? const <ForecastMonth>[];
    notifyListeners();
  }

  /// Replaces one business's stamped health snapshot with a live one.
  void applyLiveHealth(int businessId, HealthSnapshot? snapshot) {
    _stateFor(businessId).health = snapshot;
    notifyListeners();
  }

  /// Replaces one business's alerts with the live ones from the backend.
  ///
  /// External-signal alerts (mandi price movement, weather) are dropped here
  /// so neither Home's watch card nor the alerts list surfaces them — the
  /// app currently has no way to act on them and their presence adds noise
  /// to the ones that actually carry a plan.
  void applyLiveAlerts(int businessId, List<RiskAlert>? alerts) {
    final List<RiskAlert> filtered = (alerts ?? const <RiskAlert>[])
        .where(
          (RiskAlert a) =>
              a.kind != AlertKind.heavyRain
              && a.kind != AlertKind.fodderPriceUp,
        )
        .toList(growable: false);
    _stateFor(businessId).alerts = filtered;
    notifyListeners();
  }

  /// Active alerts for the active business, urgent first.
  List<RiskAlert> get alerts =>
      List<RiskAlert>.unmodifiable(_activeState()?.alerts ?? const []);

  // ── Connectivity ───────────────────────────────────────────────────────

  ConnectivityStatus _connectivity = ConnectivityStatus.synced;
  SyncStatusController? _syncStatus;

  /// Current network state, projected from the real sync layer.
  ConnectivityStatus get connectivity => _connectivity;

  /// Overrides the state directly. Only used by demo mode and widget tests;
  /// when [bindSync] is active the next real update wins.
  set connectivity(ConnectivityStatus value) {
    if (_connectivity != value) {
      _connectivity = value;
      notifyListeners();
    }
  }

  /// The live sync status, once bound. Null in demo mode and bare tests.
  SyncStatus? get syncStatus => _syncStatus?.value;

  /// How many writes have not reached the server.
  int get pendingSyncCount => _syncStatus?.value.pendingCount ?? 0;

  /// Mirrors the sync layer's status onto this session.
  ///
  /// The session predates the sync layer and a dozen screens read
  /// `session.connectivity`, so rather than rewrite them all it becomes a
  /// projection of the real thing. [SyncState] is the finer-grained truth;
  /// this collapses it onto the three states the existing chips understand.
  void bindSync(SyncStatusController controller) {
    _syncStatus?.removeListener(_onSyncStatus);
    _syncStatus = controller;
    controller.addListener(_onSyncStatus);
    _onSyncStatus();
  }

  void _onSyncStatus() {
    final SyncStatus? status = _syncStatus?.value;
    if (status == null) return;

    final ConnectivityStatus next = switch (status.state) {
      SyncState.offline => ConnectivityStatus.offline,
      SyncState.syncing => ConnectivityStatus.syncing,
      // Online with a queue is not "offline", but it is not settled either.
      // The chip reads this as work-in-progress, which is what it is: the
      // engine will drain it on the next cycle without the user doing
      // anything.
      SyncState.pendingChanges => ConnectivityStatus.syncing,
      SyncState.synced => ConnectivityStatus.synced,
    };

    if (_connectivity != next) {
      _connectivity = next;
      notifyListeners();
    } else {
      // Counts changed even though the coarse state did not; the chip shows
      // them, so it still needs to rebuild.
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _syncStatus?.removeListener(_onSyncStatus);
    _syncStatus = null;
    super.dispose();
  }
}

/// Everything Home, History and Forecast show for one business.
class _BusinessState {
  List<LedgerEntry> entries = const <LedgerEntry>[];
  HealthSnapshot? health;
  HealthSnapshot? pendingHealth;
  List<ForecastMonth> forecast = const <ForecastMonth>[];
  List<RiskAlert> alerts = const <RiskAlert>[];
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
