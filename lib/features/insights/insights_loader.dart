import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/session.dart';
import '../businesses/data/business_repository.dart';
import '../entries/data/ledger_api.dart';
import '../entries/data/ledger_repository.dart';
import 'bloc/insights_cubit.dart';

/// Silent widget that keeps live insights + business list flowing into the
/// shared [AppSession] so existing screens (Home / Forecast / Alerts /
/// Settings) get real backend data without being rewritten.
///
/// - On first mount fetches `GET /api/v1/businesses` and populates
///   `AppSession.businesses` + `backendBusinessIds` (needed after cold
///   restarts, where the app boots with an empty session).
/// - Subscribes to [AppSession] and re-fetches insights when the active
///   backend business id changes.
/// - Mirrors [InsightsCubit] state into the session.
class InsightsLoader extends StatefulWidget {
  const InsightsLoader({super.key, required this.child});
  final Widget child;

  @override
  State<InsightsLoader> createState() => _InsightsLoaderState();
}

class _InsightsLoaderState extends State<InsightsLoader> {
  int? _lastFetchedBusinessId;
  bool _businessesFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBusinessesOnce());
  }

  Future<void> _fetchBusinessesOnce() async {
    if (_businessesFetched || !mounted) return;
    _businessesFetched = true;
    BusinessRepository? repo;
    try {
      repo = context.read<BusinessRepository>();
    } catch (_) {
      return;
    }
    try {
      final rows = await repo.list();
      if (!mounted) return;
      final session = SessionScope.of(context);
      // Only seed if the session is genuinely empty — a mid-session Add
      // Business from Settings already pushed rows into the session, and
      // we don't want to overwrite them.
      if (session.businesses.isEmpty) {
        session.applyBusinessList(
          rows.map((r) => r.toDomain()).toList(growable: false),
          rows.map((r) => r.id).cast<int?>().toList(growable: false),
        );
      }
    } catch (_) {
      // Silent: no businesses to show is a valid empty state.
    }
  }

  void _maybeFetchInsights(BuildContext context, int? businessId) {
    if (businessId == null || businessId == _lastFetchedBusinessId) return;
    _lastFetchedBusinessId = businessId;
    context.read<InsightsCubit>().load(businessId);
    _fetchHistoryFor(context, businessId);
  }

  Future<void> _fetchHistoryFor(BuildContext context, int businessId) async {
    LedgerRepository? repo;
    AppSession? session;
    try {
      repo = context.read<LedgerRepository>();
      session = SessionScope.of(context);
    } catch (_) {
      return;
    }
    try {
      final rows = await repo.history(businessId, limit: 100);
      if (!mounted) return;
      final entries = rows.map((r) => r.toLedgerEntry()).toList(growable: false);
      session.applyLiveEntries(entries);
    } catch (_) {/* silent — empty history is fine */}
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InsightsCubit, InsightsState>(
      listenWhen: (a, b) => a.status != b.status || a.businessId != b.businessId,
      listener: (context, state) {
        final session = SessionScope.of(context);
        session.applyLiveHealth(state.health?.toDomain());
        session.applyLiveForecast(state.forecast?.toDomain());
        session.applyLiveAlerts(
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
