import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/single_child_widget.dart';

import 'app/session.dart';
import 'core/network/api_client.dart';
import 'core/network/env.dart';
import 'core/theme/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/lock_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/mpin_repository.dart';
import 'features/auth/presentation/mpin_setup_screen.dart';
import 'features/auth/presentation/mpin_unlock_screen.dart';
import 'features/auth/presentation/name_capture_screen.dart';
import 'features/auth/presentation/phone_login_screen.dart';
import 'features/businesses/data/business_repository.dart';
import 'features/entries/data/ledger_outbox.dart';
import 'features/entries/data/ledger_repository.dart';
import 'features/home/presentation/app_shell.dart';
import 'features/insights/bloc/insights_cubit.dart';
import 'features/insights/data/insights_repository.dart';
import 'features/insights/insights_loader.dart';
import 'features/locations/data/location_repository.dart';
import 'features/onboarding/domain/app_language.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/settings/data/language_prefs.dart';
import 'features/setup/presentation/setup_flow.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase — placeholder options will throw until `flutterfire configure`
  // has been run. In that case we still boot the app and use the backend
  // dev-shim (X-Debug-Firebase-Uid) when DEBUG_FIREBASE_UID is defined.
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    firebaseReady = true;
  } catch (e) {
    // `[core/duplicate-app]` happens on iOS when a bundled
    // GoogleService-Info.plist causes the native side to register the
    // default app before Dart runs. In that case Firebase IS ready — just
    // not by our call. Only treat other errors as a hard failure.
    if (e.toString().contains('duplicate-app')) {
      firebaseReady = true;
    }
    debugPrint('Firebase init: $e (firebaseReady=$firebaseReady)');
  }

  await Hive.initFlutter();
  final outbox = await LedgerOutbox.open();

  final apiClient = ApiClient(auth: firebaseReady ? FirebaseAuth.instance : null);
  final businessRepo = BusinessRepository(apiClient);
  final ledgerRepo = LedgerRepository(apiClient: apiClient, outbox: outbox);
  final insightsRepo = InsightsRepository(apiClient);
  final locationRepo = LocationRepository(apiClient);
  final mpinRepo = MpinRepository();
  final languagePrefs = await LanguagePrefs.open();

  runApp(MyApp(
    firebaseReady: firebaseReady,
    apiClient: apiClient,
    businessRepository: businessRepo,
    ledgerRepository: ledgerRepo,
    insightsRepository: insightsRepo,
    locationRepository: locationRepo,
    mpinRepository: mpinRepo,
    ledgerOutbox: outbox,
    languagePrefs: languagePrefs,
  ));
}

/// Root widget for the Khushhal application.
///
/// All deps are optional so existing widget tests (which pump `MyApp()`
/// bare) still compile. In production `main()` always supplies them.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.firebaseReady = false,
    this.apiClient,
    this.businessRepository,
    this.ledgerRepository,
    this.insightsRepository,
    this.locationRepository,
    this.mpinRepository,
    this.ledgerOutbox,
    this.languagePrefs,
  });

  final bool firebaseReady;
  final ApiClient? apiClient;
  final BusinessRepository? businessRepository;
  final LedgerRepository? ledgerRepository;
  final InsightsRepository? insightsRepository;
  final LocationRepository? locationRepository;
  final MpinRepository? mpinRepository;
  final LedgerOutbox? ledgerOutbox;
  final LanguagePrefs? languagePrefs;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLanguage _language = widget.languagePrefs?.saved
      ?? AppLanguage.fromLocale(WidgetsBinding.instance.platformDispatcher.locale);

  AppSession _session = AppSession();

  void _setLanguage(AppLanguage language) {
    setState(() => _language = language);
    // Persist so subsequent launches skip the language screen.
    widget.languagePrefs?.save(language);
  }

  void _logout() {
    setState(() => _session = AppSession());
    // Wipe every trace of the previous account: mPIN, secure-storage
    // attempts, and any ledger entries still queued in the Hive outbox.
    widget.mpinRepository?.clear();
    widget.ledgerOutbox?.clear();
    if (widget.firebaseReady) FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Each RepositoryProvider must carry an explicit type argument so it
    // registers under the concrete type, not `dynamic`. A raw list type of
    // `<RepositoryProvider>` collapses each element to
    // `RepositoryProvider<dynamic>` and `context.read<T>()` will fail.
    final providers = <SingleChildWidget>[
      if (widget.apiClient != null)
        RepositoryProvider<ApiClient>.value(value: widget.apiClient!),
      if (widget.businessRepository != null)
        RepositoryProvider<BusinessRepository>.value(value: widget.businessRepository!),
      if (widget.ledgerRepository != null)
        RepositoryProvider<LedgerRepository>.value(value: widget.ledgerRepository!),
      if (widget.insightsRepository != null)
        RepositoryProvider<InsightsRepository>.value(value: widget.insightsRepository!),
      if (widget.locationRepository != null)
        RepositoryProvider<LocationRepository>.value(value: widget.locationRepository!),
    ];

    // When DEBUG_FIREBASE_UID is set (dev / iOS simulator), always use the
    // shim path even if Firebase initialised — the SMS OTP flow needs APNs
    // and a per-platform Firebase app registration we don't have on the
    // simulator, and the backend already accepts the shim header behind
    // DEV_TOOLS_ENABLED=true.
    final useAuthGate = widget.firebaseReady
        && widget.apiClient != null
        && AppEnv.debugFirebaseUid.isEmpty;

    Widget app = _buildApp(withAuthGate: useAuthGate);

    if (useAuthGate) {
      app = BlocProvider(
        create: (_) => AuthBloc(
          repository: AuthRepository(apiClient: widget.apiClient!),
        )..add(const AuthStarted()),
        child: app,
      );
    }

    if (widget.insightsRepository != null) {
      app = BlocProvider(
        create: (_) => InsightsCubit(widget.insightsRepository!),
        child: app,
      );
    }

    if (widget.mpinRepository != null) {
      app = MultiBlocProvider(
        providers: [
          BlocProvider<LockCubit>(create: (_) => LockCubit(widget.mpinRepository!)),
        ],
        child: app,
      );
    }

    if (providers.isEmpty) return app;
    return MultiRepositoryProvider(providers: providers, child: app);
  }

  Widget _buildApp({required bool withAuthGate}) {
    return MaterialApp(
      title: 'Khushhal',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      locale: _language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (BuildContext context, Widget? child) {
        return SessionScope(session: _session, child: child!);
      },
      home: withAuthGate
          ? const _AuthGate()
          : _LockGate(child: _phaseFlow(startAtHomeIfExisting: false)),
    );
  }

  Widget _phaseFlow({bool startAtHomeIfExisting = false}) {
    return _PhaseFlow(
      language: _language,
      onLanguageSelected: _setLanguage,
      onLogout: _logout,
      startAtHomeIfExisting: startAtHomeIfExisting,
      skipLanguageScreen: widget.languagePrefs?.hasSelected ?? false,
    );
  }
}

/// Gates the whole app on the current auth state so a signed-out user only
/// ever sees the login screen. New users are routed through Onboarding →
/// Setup; returning users land on the home shell directly.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.unknown:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          case AuthStatus.unauthenticated:
          case AuthStatus.sendingCode:
          case AuthStatus.codeSent:
          case AuthStatus.verifying:
          case AuthStatus.error:
            return const PhoneLoginScreen();
          case AuthStatus.authenticated:
            final root = context.findAncestorStateOfType<_MyAppState>();
            // Mirror the signed-in user's name + phone into AppSession so
            // Settings + mPIN unlock stop showing '—' placeholders.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final me = state.me;
              if (me == null) return;
              root!._session.applyProfile(name: me.name, phone: me.phoneE164);
              root._session.savingsInr = me.savingsInr;
              root._session.loanInr = me.loanInr;
            });
            return _LockGate(
              // Keying by user id forces a fresh _PhaseFlowState (and a
              // fresh _LockGateState) when a *different* user signs in —
              // otherwise a returning new-user session would inherit the
              // prior user's `_phase = home` and skip onboarding.
              key: ValueKey<int?>(state.me?.id),
              child: _PhaseFlow(
                key: ValueKey<(int?, bool)>((state.me?.id, state.isNew)),
                language: root!._language,
                onLanguageSelected: root._setLanguage,
                onLogout: root._logout,
                startAtHomeIfExisting: !state.isNew,
                skipLanguageScreen: root.widget.languagePrefs?.hasSelected ?? false,
              ),
            );
        }
      },
    );
  }
}

/// mPIN app-lock — sits between auth and the phase flow. On mount it
/// asks LockCubit which state to render; the two mPIN screens dispatch
/// events that flip the cubit to `unlocked` and reveal [child].
///
/// If no LockCubit is provided (e.g. in a test that pumps the app without
/// mpinRepository), we let the child through untouched.
class _LockGate extends StatefulWidget {
  const _LockGate({super.key, required this.child});
  final Widget child;

  @override
  State<_LockGate> createState() => _LockGateState();
}

class _LockGateState extends State<_LockGate> {
  bool _hasCubit = false;
  // Set to true after the user finishes NameCaptureScreen (or on unlock
  // when their profile already has a name). Prevents re-prompting on
  // every widget rebuild inside the session.
  bool _nameCaptured = false;
  // The LockCubit is provided app-wide and its state persists across sign-
  // outs (the `unlocked` from the previous session can linger until the
  // fresh check() emits). We block rendering the mPIN/Name flows until we
  // observe a state emission after this gate's own mount — otherwise a
  // newly signed-in user briefly sees the previous user's
  // NameCaptureScreen or Home before mPIN setup takes over.
  bool _settled = false;

  @override
  void initState() {
    super.initState();
    try {
      // Force a fresh mPIN check for the newly signed-in identity, then
      // flip `_settled` so the builder starts trusting cubit state.
      context.read<LockCubit>().check().whenComplete(() {
        if (mounted) setState(() => _settled = true);
      });
      _hasCubit = true;
    } catch (_) {
      _hasCubit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCubit) return widget.child;
    return BlocConsumer<LockCubit, AppLockState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == LockStatus.lockedOut) {
          final root = context.findAncestorStateOfType<_MyAppState>();
          root?._logout();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Too many wrong tries — please sign in again.')),
          );
        }
      },
      builder: (context, state) {
        if (!_settled) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        switch (state.status) {
          case LockStatus.unknown:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          case LockStatus.requiresSetup:
            return const MpinSetupScreen();
          case LockStatus.requiresUnlock:
            return const MpinUnlockScreen();
          case LockStatus.unlocked:
            // First-time users have no name yet — prompt once between
            // mPIN setup and the rest of the flow. On every subsequent
            // unlock the session already carries a name from `/me`.
            final session = SessionScope.of(context);
            final hasName = (session.ownerName ?? '').trim().isNotEmpty;
            if (!_nameCaptured && !hasName) {
              return NameCaptureScreen(
                onDone: () => setState(() => _nameCaptured = true),
              );
            }
            return widget.child;
          case LockStatus.lockedOut:
            // Listener above will trigger logout + snackbar; render a
            // loader briefly while that swap happens.
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

/// The three-stage flow (onboarding → setup → home) that runs after auth.
class _PhaseFlow extends StatefulWidget {
  const _PhaseFlow({
    super.key,
    required this.language,
    required this.onLanguageSelected,
    required this.onLogout,
    required this.startAtHomeIfExisting,
    required this.skipLanguageScreen,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageSelected;
  final VoidCallback onLogout;
  final bool startAtHomeIfExisting;
  final bool skipLanguageScreen;

  @override
  State<_PhaseFlow> createState() => _PhaseFlowState();
}

enum _AppPhase { onboarding, setup, home }

class _PhaseFlowState extends State<_PhaseFlow> {
  late _AppPhase _phase =
      widget.startAtHomeIfExisting ? _AppPhase.home : _AppPhase.onboarding;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);

    // `_AuthGate` decides the starting phase from `is_new`, but that's not
    // enough — if a returning user re-signs in without ever completing
    // setup, `is_new=false` would drop them onto Home with nothing to show.
    // Once `InsightsLoader` confirms there are 0 businesses on the server,
    // detour into the setup flow so they can create one.
    if (_phase == _AppPhase.home
        && session.businessesFetched
        && session.businesses.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _phase == _AppPhase.home) {
          setState(() => _phase = _AppPhase.onboarding);
        }
      });
    }

    final Widget screen = switch (_phase) {
      _AppPhase.onboarding => OnboardingFlow(
          key: const ValueKey(_AppPhase.onboarding),
          language: widget.language,
          onLanguageSelected: widget.onLanguageSelected,
          onCompleted: () => setState(() => _phase = _AppPhase.setup),
          skipLanguage: widget.skipLanguageScreen,
        ),
      _AppPhase.setup => SetupFlow(
          key: const ValueKey(_AppPhase.setup),
          onFinished: () => setState(() => _phase = _AppPhase.home),
        ),
      _AppPhase.home => InsightsLoader(
          key: const ValueKey(_AppPhase.home),
          child: AppShell(
            onLanguageSelected: widget.onLanguageSelected,
            onLogout: widget.onLogout,
          ),
        ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: screen,
    );
  }
}
