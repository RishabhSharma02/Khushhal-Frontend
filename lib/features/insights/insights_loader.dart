import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/model/ledger.dart';
import '../../app/session.dart';
import '../../core/sync/sync_engine.dart';
import '../businesses/data/business_local_datasource.dart';
import '../businesses/data/business_repository.dart';
import '../entries/data/ledger_repository.dart';
import 'bloc/insights_cubit.dart';

/// Silent widget that keeps live insights + business list flowing into the
/// shared [AppSession] so existing screens (Home / Forecast / Alerts /
/// Settings) get real backend data without being rewritten.
///
/// - Follows the cached business list from SQLite, so the switcher, the money
///   baselines and each business's savings stay current after a business is
///   added or a sync pulls fresh server values — online or off.
/// - Follows the active business's ledger history, so a new entry moves Home's
///   money tiles the moment it is written.
/// - Subscribes to [AppSession] and re-fetches insights when the active
///   backend business id changes.
/// - Mirrors [InsightsCubit] state into the session, keyed by business.
class InsightsLoader extends StatefulWidget {
  const InsightsLoader({super.key, required this.child});
  final Widget child;

  @override
  State<InsightsLoader> createState() => _InsightsLoaderState();
}

class _InsightsLoaderState extends State<InsightsLoader> {
  int? _lastFetchedBusinessId;
  StreamSubscription<List<LocalBusinessRecord>>? _businessSub;
  StreamSubscription<DateTime?>? _pullSub;
  StreamSubscription<List<LedgerEntry>>? _historySub;
  int? _watchedHistoryId;

  List<LocalBusinessRecord> _rows = const <LocalBusinessRecord>[];

  /// Whether `GET /businesses` has landed on this device for the account
  /// this loader was mounted for. A pull stamp older than [_mountedAt] is
  /// left over from a previous user's session and must not count — otherwise
  /// switching to a new account (login-with-mobile) reads the previous
  /// user's stamp on first frame, sees an empty business list (owner filter
  /// hides the previous user's rows), and detours the new user through the
  /// setup wizard before their own pull has had a chance to run.
  bool _serverConfirmed = false;
  late final DateTime _mountedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Blow away any leftover business-list state from a previous account
      // so `_PhaseFlow` cannot briefly react to it before this loader's own
      // pull has landed.
      SessionScope.of(context).resetBusinessList();
      _watchBusinesses();
    });
  }

  @override
  void dispose() {
    // ignore: discarded_futures
    _businessSub?.cancel();
    // ignore: discarded_futures
    _pullSub?.cancel();
    // ignore: discarded_futures
    _historySub?.cancel();
    super.dispose();
  }

  void _watchBusinesses() {
    if (!mounted) return;
    BusinessRepository? repo;
    try {
      repo = context.read<BusinessRepository>();
    } catch (_) {
      return;
    }
    _businessSub = repo.watchAll().listen((List<LocalBusinessRecord> rows) {
      _rows = rows;
      _applyBusinesses();
    });
    // A pull that finds no businesses writes nothing to SQLite, so the list
    // stream never fires for it. Following the pull stamp as well is what
    // turns "the cache is empty" into "the account really has none".
    _pullSub = repo.watchServerPullTime().listen((DateTime? at) {
      // Ignore the stamp until we see one written after this loader mounted
      // — a stamp from a previous user's session must not stand in for the
      // current user's pull.
      _serverConfirmed = at != null && !at.isBefore(_mountedAt);
      _applyBusinesses();
    });
    _pullNow();
  }

  /// Asks for one sync cycle as the home shell appears.
  ///
  /// The engine otherwise polls every five minutes and starts before sign-in,
  /// so a user opening the app on a freshly installed phone could sit in front
  /// of an empty Home — and, until the empty cache stopped counting as an
  /// answer, be sent through onboarding — for minutes before their businesses
  /// arrived.
  void _pullNow() {
    try {
      // ignore: discarded_futures
      context.read<SyncEngine>().syncNow();
    } catch (_) {
      // No engine in this tree (widget tests, demo mode): the cache is all
      // there is, which is what the streams above already serve.
    }
  }

  void _applyBusinesses() {
    if (!mounted) return;
    final AppSession session = SessionScope.of(context);

    // A business the setup wizard has added but not yet POSTed is not in
    // SQLite, and replacing the list now would lose it.
    if (session.hasUnsavedBusiness) return;

    // Include locally-created businesses that have not been POSTed yet —
    // otherwise a user who added a business while sync was failing gets
    // sent back through the setup wizard on next launch because their only
    // business is filtered out here and _PhaseFlow treats them as if they
    // had none. `applyBusinessList` accepts a null serverId per row.
    session.applyBusinessList(
      _rows.map((LocalBusinessRecord r) => r.business).toList(growable: false),
      _rows.map((LocalBusinessRecord r) => r.serverId).toList(growable: false),
      serverConfirmed: _serverConfirmed,
    );
  }

  void _maybeFetchInsights(BuildContext context, int? businessId) {
    if (businessId == null || businessId == _lastFetchedBusinessId) return;
    _lastFetchedBusinessId = businessId;
    context.read<InsightsCubit>().load(businessId);
    _watchHistoryFor(context, businessId);
  }

  void _watchHistoryFor(BuildContext context, int businessId) {
    if (_watchedHistoryId == businessId) return;
    _watchedHistoryId = businessId;

    final LedgerRepository repo;
    final AppSession session;
    try {
      repo = context.read<LedgerRepository>();
      session = SessionScope.of(context);
    } catch (_) {
      return;
    }

    // ignore: discarded_futures
    _historySub?.cancel();
    // Streams from SQLite, so it resolves instantly, works offline, and moves
    // Home's money tiles as soon as an entry is written or a pull lands.
    _historySub = repo.watchHistory(businessId).listen((
      List<LedgerEntry> entries,
    ) {
      if (!mounted) return;
      session.applyLiveEntries(businessId, entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InsightsCubit, InsightsState>(
      listenWhen: (a, b) => a.status != b.status || a.businessId != b.businessId,
      listener: (context, state) {
        // Insights arrive stamped with the business they were loaded for, so a
        // late response from a business the user has already switched away
        // from lands on that business rather than the one on screen.
        final int? businessId = state.businessId;
        if (businessId == null) return;
        final session = SessionScope.of(context);
        session.applyLiveHealth(businessId, state.health?.toDomain());
        session.applyLiveForecast(businessId, state.forecast?.toDomain());
        session.applyLiveAlerts(
          businessId,
          state.alerts.map((a) => a.toDomain()).toList(growable: false),
        );
      },
      child: Builder(builder: (context) {
        // Depend on session changes so we notice active-business swaps.
        final session = SessionScope.of(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _maybeFetchInsights(context, session.activeBackendBusinessId);
        });
        return widget.child;
      }),
    );
  }
}
