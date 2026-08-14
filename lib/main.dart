import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/single_child_widget.dart';

import 'app/bootstrap.dart';
import 'app/session.dart';
import 'core/db/app_database.dart';
import 'core/network/api_client.dart';
import 'core/network/env.dart';
import 'core/sync/outbox_dao.dart';
import 'core/sync/sync_engine.dart';
import 'core/theme/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/lock_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/profile_repository.dart';
import 'features/auth/presentation/mpin_setup_screen.dart';
import 'features/auth/presentation/mpin_unlock_screen.dart';
import 'features/auth/presentation/name_capture_screen.dart';
import 'features/auth/presentation/otp_verify_screen.dart';
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

  // Hive survives only to hold the legacy ledger outbox until it is drained
  // into SQLite; see LegacyOutboxMigration.
  await Hive.initFlutter();
  final legacyOutbox = await LedgerOutbox.open();

  final deps = await AppDependencies.boot(
    firebaseReady: firebaseReady,
    legacyOutbox: legacyOutbox,
  );

  runApp(MyApp(firebaseReady: firebaseReady, deps: deps));
}

/// Root widget for the Khushhal application.
///
/// [deps] is optional so existing widget tests (which pump `MyApp()` bare)
/// still compile. In production `main()` always supplies it.
class MyApp extends StatefulWidget {
  const MyApp({super.key, this.firebaseReady = false, this.deps});

  final bool firebaseReady;
  final AppDependencies? deps;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLanguage _language = widget.deps?.languagePrefs.saved
      ?? AppLanguage.fromLocale(WidgetsBinding.instance.platformDispatcher.locale);

  AppSession _session = AppSession();

  /// True on the very first launch of this install — we show language
  /// select + the USP carousel before the phone-login screen. Once the
  /// carousel is finished (or the user has already picked a language on a
  /// previous run) this flips to false and the auth gate takes over.
  late bool _needsEntryOnboarding =
      !(widget.deps?.languagePrefs.hasSelected ?? true);

  /// Set by the mPIN unlock screen's "Forgot PIN? Login with OTP" action.
  /// While true, `_AuthGate` forces the PhoneLoginScreen even for someone
  /// who is technically authenticated via cached identity + saved PIN, so
  /// the user can enter a new number. The saved PIN and cached row stay
  /// intact until the new OTP verifies successfully — if the user drops
  /// out (or kills the app), the next launch falls back to the existing
  /// PIN unlock instead of stranding them without an account.
  bool _forcePhoneLogin = false;

  /// Set alongside [_forcePhoneLogin] when the user tapped "Forgot PIN?" —
  /// the same phone number is re-verified, so `_AuthGate` skips the
  /// PhoneLoginScreen and drops the user straight onto the OTP screen while
  /// the AuthBloc auto-sends the code.
  bool _forgotPinFlow = false;

  void _startNumberChange() {
    if (!_forcePhoneLogin) {
      setState(() {
        _forcePhoneLogin = true;
        _forgotPinFlow = false;
      });
    }
  }

  /// Kicks off a "Forgot PIN?" re-verify for the currently-signed-in phone
  /// without asking the user to type it again. The caller has already
  /// dispatched `AuthPhoneSubmitted` from a context that sits under the
  /// `BlocProvider<AuthBloc>` (this state's own context does not); this
  /// method just flips the gate to render OtpVerifyScreen directly. On
  /// success the PIN is cleared and the LockGate routes the user to mPIN
  /// setup.
  void _startForgotPin() {
    setState(() {
      _forcePhoneLogin = true;
      _forgotPinFlow = true;
    });
  }

  /// Undoes [_startNumberChange] — used when a fresh OTP verify succeeds
  /// (see `_AuthGate`'s BlocListener) or when the caller explicitly cancels.
  Future<void> _finishNumberChange({required bool clearPin}) async {
    if (clearPin) {
      try {
        await widget.deps?.mpinRepository.clear();
      } catch (_) {/* best effort */}
    }
    if (!mounted) return;
    setState(() {
      _forcePhoneLogin = false;
      _forgotPinFlow = false;
    });
    // When the same phone re-verifies (Forgot PIN flow), the user id does
    // not change so `_LockGate`'s key stays the same and its `initState`
    // check() does not re-run. Kick the cubit ourselves so the newly-empty
    // PIN transitions the gate to mPIN setup.
    if (clearPin) {
      try {
        // ignore: discarded_futures
        context.read<LockCubit>().check();
      } catch (_) {/* no cubit in tests */}
    }
  }

  @override
  void initState() {
    super.initState();
    final AppDependencies? deps = widget.deps;
    if (deps != null) {
      _session.bindSync(deps.syncStatus);
    }
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  void _setLanguage(AppLanguage language) {
    setState(() => _language = language);
    // Persist so subsequent launches skip the language screen.
    widget.deps?.languagePrefs.save(language);
    // ignore: discarded_futures
    widget.deps?.profileRepository.setLanguage(language.name);
  }

  /// Signs out, syncing first so nothing queued is lost silently.
  ///
  /// Logout is the one moment offline-first has to stop being invisible: the
  /// local database is about to be wiped, and anything still in the outbox goes
  /// with it. So the user is told the count and asked, rather than finding out
  /// later that a week of entries never made it.
  Future<void> _logout() async {
    final AppDependencies? deps = widget.deps;
    if (deps == null) {
      setState(() => _session = AppSession());
      if (widget.firebaseReady) await FirebaseAuth.instance.signOut();
      return;
    }

    final int unsent = await deps.syncEngine.flushBeforeLogout();
    if (unsent > 0 && mounted) {
      final bool discard = await _confirmDiscard(unsent) ?? false;
      if (!discard) return;
    }

    await deps.logout(firebaseReady: widget.firebaseReady);
    if (!mounted) return;
    setState(() {
      _session = AppSession()..bindSync(deps.syncStatus);
    });
  }

  Future<bool?> _confirmDiscard(int unsent) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Some changes are not saved online'),
        content: Text(
          '$unsent change${unsent == 1 ? '' : 's'} could not reach the server. '
          'Signing out now will discard ${unsent == 1 ? 'it' : 'them'}.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Stay signed in'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign out anyway'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Each RepositoryProvider must carry an explicit type argument so it
    // registers under the concrete type, not `dynamic`. A raw list type of
    // `<RepositoryProvider>` collapses each element to
    // `RepositoryProvider<dynamic>` and `context.read<T>()` will fail.
    final AppDependencies? deps = widget.deps;
    final providers = <SingleChildWidget>[
      if (deps != null) ...<SingleChildWidget>[
        RepositoryProvider<ApiClient>.value(value: deps.apiClient),
        RepositoryProvider<BusinessRepository>.value(
          value: deps.businessRepository,
        ),
        RepositoryProvider<LedgerRepository>.value(
          value: deps.ledgerRepository,
        ),
        RepositoryProvider<InsightsRepository>.value(
          value: deps.insightsRepository,
        ),
        RepositoryProvider<LocationRepository>.value(
          value: deps.locationRepository,
        ),
        RepositoryProvider<ProfileRepository>.value(
          value: deps.profileRepository,
        ),
        RepositoryProvider<SyncEngine>.value(value: deps.syncEngine),
        RepositoryProvider<OutboxDao>.value(value: deps.outbox),
        RepositoryProvider<AppDatabase>.value(value: deps.db),
      ],
    ];

    // When DEBUG_FIREBASE_UID is set (dev / iOS simulator), always use the
    // shim path even if Firebase initialised — the SMS OTP flow needs APNs
    // and a per-platform Firebase app registration we don't have on the
    // simulator, and the backend already accepts the shim header behind
    // DEV_TOOLS_ENABLED=true.
    final useAuthGate = widget.firebaseReady
        && deps != null
        && AppEnv.debugFirebaseUid.isEmpty;

    Widget app = _buildApp(withAuthGate: useAuthGate);

    if (useAuthGate) {
      app = BlocProvider(
        create: (_) => AuthBloc(
          repository: AuthRepository(apiClient: deps.apiClient),
          profile: deps.profileRepository,
          mpin: deps.mpinRepository,
        )..add(const AuthStarted()),
        child: app,
      );
    }

    if (deps != null) {
      app = BlocProvider(
        create: (_) => InsightsCubit(deps.insightsRepository),
        child: app,
      );
      app = MultiBlocProvider(
        providers: [
          BlocProvider<LockCubit>(
            create: (_) => LockCubit(
              deps.mpinRepository,
              profile: deps.profileRepository,
            ),
          ),
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
      home: _needsEntryOnboarding
          // Fresh install: language select → USP carousel → phone login.
          // `_setLanguage` already persists the pref, so on the next run
          // `_needsEntryOnboarding` boots false and we fall straight into
          // the auth gate.
          ? OnboardingFlow(
              language: _language,
              onLanguageSelected: _setLanguage,
              onCompleted: () => setState(() => _needsEntryOnboarding = false),
            )
          : withAuthGate
              // Pass `_forcePhoneLogin` as an explicit prop so a setState
              // on _MyAppState actually re-runs `_AuthGate.build` — a
              // `const _AuthGate()` gets canonicalised by Flutter and
              // won't rebuild on ancestor changes alone.
              ? _AuthGate(
                  forcePhoneLogin: _forcePhoneLogin,
                  forgotPinFlow: _forgotPinFlow,
                )
              : _LockGate(child: _phaseFlow(startAtHomeIfExisting: false)),
    );
  }

  Widget _phaseFlow({bool startAtHomeIfExisting = false}) {
    return _PhaseFlow(
      language: _language,
      onLanguageSelected: _setLanguage,
      onLogout: _logout,
      startAtHomeIfExisting: startAtHomeIfExisting,
      skipLanguageScreen: widget.deps?.languagePrefs.hasSelected ?? false,
    );
  }
}

/// Public bridge so callers outside this file can start a "change number"
/// flow without depending on the private [_MyAppState]. Returns whether a
/// state to receive the request was found (i.e., we're inside a running
/// [MyApp]).
abstract class ChangeNumberScope {
  static bool request(BuildContext context) {
    final root = context.findAncestorStateOfType<_MyAppState>();
    if (root == null) return false;
    root._startNumberChange();
    return true;
  }

  /// Same as [request] but for the "Forgot PIN?" path: reuses the current
  /// phone number, auto-sends the OTP and drops the user on the OTP screen
  /// rather than the phone-input screen. [context] must sit under
  /// `BlocProvider<AuthBloc>` — the mPIN screen does; `_MyAppState`'s own
  /// context does not.
  static bool forgotPin(BuildContext context, String phoneE164) {
    final root = context.findAncestorStateOfType<_MyAppState>();
    if (root == null) return false;
    context.read<AuthBloc>().add(AuthPhoneSubmitted(phoneE164));
    root._startForgotPin();
    return true;
  }
}

/// Gates the whole app on the current auth state so a signed-out user only
/// ever sees the login screen. New users are routed through Onboarding →
/// Setup; returning users land on the home shell directly.
///
/// [forcePhoneLogin] is passed down from `_MyAppState` so a change in the
/// flag rebuilds this widget — a const-constructed gate would be
/// canonicalised by Flutter and skip the rebuild on ancestor setState.
class _AuthGate extends StatelessWidget {
  const _AuthGate({this.forcePhoneLogin = false, this.forgotPinFlow = false});

  final bool forcePhoneLogin;

  /// True when [forcePhoneLogin] was set by the "Forgot PIN?" path — the
  /// same-number OTP is already in flight, so we render OtpVerifyScreen
  /// directly instead of the phone-input screen.
  final bool forgotPinFlow;

  @override
  Widget build(BuildContext context) {
    final root = context.findAncestorStateOfType<_MyAppState>();
    return BlocConsumer<AuthBloc, AuthState>(
      // Watch for a successful OTP verification while the user is in the
      // middle of a "change number" flow. We compare `me?.id` as well as
      // the status because the bloc may already be at `authenticated`
      // (old identity via cache) when the flow starts — only a new user
      // id landing here means a fresh OTP verified. In the `me?.id`-
      // unchanged case (same account, just cycling PIN), a transition
      // *into* `authenticated` from verifying is enough.
      listenWhen: (a, b) =>
          a.status != b.status || a.me?.id != b.me?.id,
      listener: (context, state) {
        final _MyAppState? root = context.findAncestorStateOfType<_MyAppState>();
        if (state.status == AuthStatus.authenticated
            && (root?._forcePhoneLogin ?? false)) {
          // Fire-and-forget: don't block the rebuild on Keystore IO.
          // ignore: discarded_futures
          root!._finishNumberChange(clearPin: true);
        }
      },
      builder: (context, state) {
        // Force the phone screen while a change-number flow is in flight,
        // no matter what the bloc says. The user tapped "Forgot PIN?
        // Login with OTP" from MpinUnlockScreen, so the bloc is still at
        // `authenticated` (cached identity + saved PIN) — we must still
        // hand the screen over to PhoneLoginScreen and keep it there
        // until either the new OTP verifies (see the listener above,
        // which then flips the flag off) or the user kills the app.
        if (forcePhoneLogin) {
          // Forgot-PIN reuses the current number: bloc already has phone /
          // verificationId, so OtpVerifyScreen renders straight away — no
          // PhoneLoginScreen flash. Falls back to a spinner while
          // AuthPhoneSubmitted is being dispatched (state is still
          // `authenticated` for the tick between setState and the frame
          // callback that fires the event).
          if (forgotPinFlow) {
            if (state.status == AuthStatus.authenticated) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return const OtpVerifyScreen();
          }
          return const PhoneLoginScreen();
        }
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
            // Mirror the signed-in user's name + phone into AppSession so
            // Settings + mPIN unlock stop showing '—' placeholders.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final me = state.me;
              if (me == null) return;
              root!._session.applyProfile(name: me.name, phone: me.phoneE164);
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
                skipLanguageScreen:
                    root.widget.deps?.languagePrefs.hasSelected ?? false,
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

  // The LockCubit is provided app-wide and its state persists across sign-
  // outs (the `unlocked` from the previous session can linger until the
  // fresh check() emits). We block rendering the mPIN/Name flows until we
  // observe a state emission after this gate's own mount — otherwise a
  // newly signed-in user briefly sees the previous user's
  // NameCaptureScreen or Home before mPIN setup takes over.
  bool _settled = false;

  /// The name on the local user row. Null while still loading.
  String? _localName;
  bool _nameLoaded = false;

  @override
  void initState() {
    super.initState();
    try {
      final cubit = context.read<LockCubit>();
      // Force a fresh mPIN check for the newly signed-in identity, then
      // flip `_settled` so the builder starts trusting cubit state.
      cubit.check().whenComplete(() {
        if (!mounted) return;
        setState(() => _settled = true);
      });
      _hasCubit = true;
    } catch (_) {
      _hasCubit = false;
    }
    unawaited(_loadLocalName());
  }

  Future<void> _loadLocalName() async {
    try {
      final user = await context.read<ProfileRepository>().current();
      if (!mounted) return;
      setState(() {
        _localName = user?.name;
        _nameLoaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _nameLoaded = true);
    }
  }

  bool get _hasStoredName => (_localName ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasCubit) return widget.child;
    return BlocConsumer<LockCubit, AppLockState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == LockStatus.lockedOut) {
          final root = context.findAncestorStateOfType<_MyAppState>();
          // ignore: discarded_futures
          root?._logout();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.authTooManyTries)),
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
            if (_shouldCaptureName(context)) {
              return NameCaptureScreen(
                onDone: () => setState(() => _localName = _nameFromSession(context)),
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

  /// Whether to ask for a name.
  ///
  /// Fires whenever the signed-in account has no name on record — locally
  /// (SQLite / session) or on the server row that `/auth/session` returned.
  /// Covers both the fresh-PIN-enrolment case and a returning user whose
  /// server row was created without a name (backend hiccup, a re-installed
  /// device that never captured one, etc.). We hold off until the local
  /// lookup has resolved to avoid a flash of the capture screen for a user
  /// whose name is already cached.
  bool _shouldCaptureName(BuildContext context) {
    if (!_nameLoaded) return false;
    if (_hasStoredName) return false;
    if ((_nameFromSession(context) ?? '').trim().isNotEmpty) return false;
    // Session name is populated via a post-frame callback in `_AuthGate`,
    // so on the first frame after mPIN setup it may still be empty even
    // though `/auth/session` returned a name. Read the AuthBloc state
    // directly to avoid the one-frame flash.
    try {
      final serverName = (context.read<AuthBloc>().state.me?.name ?? '').trim();
      if (serverName.isNotEmpty) return false;
    } catch (_) {/* AuthBloc not provided — fall through */}
    return true;
  }

  String? _nameFromSession(BuildContext context) =>
      SessionScope.of(context).ownerName;
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
  // Language + USP are now shown pre-auth on a fresh install, so a signed-
  // in new user drops straight into the setup wizard rather than seeing
  // the carousel again. `_AppPhase.onboarding` is only reached via the
  // "returning user with no businesses" detour below.
  late _AppPhase _phase =
      widget.startAtHomeIfExisting ? _AppPhase.home : _AppPhase.setup;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);

    // `_AuthGate` decides the starting phase from `is_new`, but that's not
    // enough — if a returning user re-signs in without ever completing
    // setup, `is_new=false` would drop them onto Home with nothing to show.
    // Once `InsightsLoader` confirms there are 0 businesses on the server,
    // detour into the setup wizard so they can create one. (We skip the
    // USP carousel — an existing user has already seen it pre-auth.)
    if (_phase == _AppPhase.home
        && session.businessesFetched
        && session.businesses.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _phase == _AppPhase.home) {
          setState(() => _phase = _AppPhase.setup);
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
