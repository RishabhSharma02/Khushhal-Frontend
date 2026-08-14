/// Root widget for the Officer Portal.
library;

import 'package:flutter/material.dart';

import '../data/action_plan_repository.dart';
import '../data/dashboard_repository.dart';
import '../data/enterprises_repository.dart';
import '../data/officer_auth_repository.dart';
import '../data/profile_repository.dart';
import '../data/reports_repository.dart';
import '../data/sync_status_repository.dart';
import '../data/visits_repository.dart';
import '../domain/officer_profile.dart';
import 'auth/officer_auth_flow.dart';
import 'officer_session.dart';
import 'officer_shell.dart';
import 'theme/officer_palette.dart';
import 'theme/officer_theme.dart';

/// The top-level stretches of the officer's journey.
enum _OfficerPhase {
  /// Sign in, or create a new account (5h–5k).
  auth,

  /// Fetching the officer's enterprises right after sign-in, before the
  /// shell can render (every shell screen assumes the list is ready).
  loading,

  /// The rail-navigated portal proper (5a onwards).
  shell,
}

/// Owns the [OfficerSession] and the [MaterialApp] — the Officer Portal's
/// equivalent of the consumer app's `MyApp`.
///
/// [OfficerSessionScope] is applied via [MaterialApp.builder], above the
/// `Navigator` rather than around `home`, so pushed routes and dialogs (add
/// visit, enterprise detail, logout) can still find the session.
class OfficerPortalRoot extends StatefulWidget {
  /// Creates the root widget. [authRepository] and [enterprisesRepository]
  /// default to the real backend-facing implementations; tests inject fakes
  /// so they never hit live Firebase/network.
  const OfficerPortalRoot({
    super.key,
    this.authRepository,
    this.enterprisesRepository,
    this.actionPlanRepository,
    this.visitsRepository,
    this.syncStatusRepository,
    this.dashboardRepository,
    this.reportsRepository,
    this.profileRepository,
  });

  /// Overridable for tests; production always uses the default.
  final OfficerAuthRepository? authRepository;

  /// Overridable for tests; production always uses the default.
  final EnterprisesRepository? enterprisesRepository;

  /// Overridable for tests; production always uses the default.
  final ActionPlanRepository? actionPlanRepository;

  /// Overridable for tests; production always uses the default.
  final VisitsRepository? visitsRepository;

  /// Overridable for tests; production always uses the default.
  final SyncStatusRepository? syncStatusRepository;

  /// Overridable for tests; production always uses the default.
  final DashboardRepository? dashboardRepository;

  /// Overridable for tests; production always uses the default.
  final ReportsRepository? reportsRepository;

  /// Overridable for tests; production always uses the default.
  final ProfileRepository? profileRepository;

  @override
  State<OfficerPortalRoot> createState() => _OfficerPortalRootState();
}

class _OfficerPortalRootState extends State<OfficerPortalRoot> {
  _OfficerPhase _phase = _OfficerPhase.auth;
  OfficerSession _session = OfficerSession();
  late final OfficerAuthRepository _authRepository =
      widget.authRepository ?? FirebaseOfficerAuthRepository();
  late final EnterprisesRepository _enterprisesRepository =
      widget.enterprisesRepository ?? ApiEnterprisesRepository();
  late final ActionPlanRepository _actionPlanRepository =
      widget.actionPlanRepository ?? ApiActionPlanRepository();
  late final VisitsRepository _visitsRepository =
      widget.visitsRepository ?? ApiVisitsRepository();
  late final SyncStatusRepository _syncStatusRepository =
      widget.syncStatusRepository ?? ApiSyncStatusRepository();
  late final DashboardRepository _dashboardRepository =
      widget.dashboardRepository ?? ApiDashboardRepository();
  late final ReportsRepository _reportsRepository =
      widget.reportsRepository ?? ApiReportsRepository();
  late final ProfileRepository _profileRepository =
      widget.profileRepository ?? ApiProfileRepository();

  void _handleAuthenticated(OfficerProfile profile) {
    final OfficerSession session = OfficerSession.authenticated(
      profile,
      enterprisesRepository: _enterprisesRepository,
      actionPlanRepository: _actionPlanRepository,
      visitsRepository: _visitsRepository,
      syncStatusRepository: _syncStatusRepository,
      dashboardRepository: _dashboardRepository,
      reportsRepository: _reportsRepository,
      profileRepository: _profileRepository,
    );
    session.markSignedIn(DateTime.now());
    setState(() {
      _session = session;
      _phase = _OfficerPhase.loading;
    });
    _loadInitialDataThenEnterShell(session);
  }

  Future<void> _loadInitialDataThenEnterShell(OfficerSession session) async {
    await Future.wait(<Future<void>>[session.loadEnterprises(), session.loadVisits()]);
    if (!mounted || _session != session) return;
    setState(() {
      if (session.enterprisesError == null && session.visitsError == null) {
        _phase = _OfficerPhase.shell;
      }
      // On error, stay on _OfficerPhase.loading — it re-renders showing the
      // error + a retry button (session already notified its listeners).
    });
  }

  void _handleLoggedOut() {
    setState(() {
      _phase = _OfficerPhase.auth;
      _session = OfficerSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KHUSH-HAL Officers' Portal",
      theme: OfficerTheme.light,
      themeMode: ThemeMode.light,
      builder: (BuildContext context, Widget? child) {
        return OfficerSessionScope(session: _session, child: child!);
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: switch (_phase) {
          _OfficerPhase.auth => OfficerAuthFlow(
            key: const ValueKey<_OfficerPhase>(_OfficerPhase.auth),
            authRepository: _authRepository,
            onAuthenticated: _handleAuthenticated,
          ),
          _OfficerPhase.loading => _InitialDataLoadingScreen(
            key: const ValueKey<_OfficerPhase>(_OfficerPhase.loading),
            onRetry: () => _loadInitialDataThenEnterShell(_session),
          ),
          _OfficerPhase.shell => OfficerShell(
            key: const ValueKey<_OfficerPhase>(_OfficerPhase.shell),
            onLoggedOut: _handleLoggedOut,
          ),
        },
      ),
    );
  }
}

/// Shown between sign-in and the shell while the officer's enterprises and
/// visits load; rebuilds automatically as [OfficerSession] notifies (it's
/// read via [OfficerSessionScope], an `InheritedNotifier`).
class _InitialDataLoadingScreen extends StatelessWidget {
  const _InitialDataLoadingScreen({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final OfficerSession session = OfficerSessionScope.of(context);
    final String? error = session.enterprisesError ?? session.visitsError;

    return Scaffold(
      backgroundColor: OfficerPalette.background,
      body: Center(
        child: error == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Could not load your data',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: OfficerPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12.5, color: OfficerPalette.muted),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
                ],
              ),
      ),
    );
  }
}
