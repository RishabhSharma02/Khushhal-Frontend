import 'package:flutter/material.dart';

import 'app/session.dart';
import 'core/theme/theme.dart';
import 'features/home/presentation/app_shell.dart';
import 'features/onboarding/domain/app_language.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/setup/presentation/setup_flow.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

/// The top-level stretches of the approved flow.
///
/// Login and OTP (designs 1f–1g3) are deliberately not part of this build,
/// so setup follows the carousel directly.
enum _AppPhase {
  /// Language select and the USP carousel (1a–1e).
  onboarding,

  /// Guided setup (1h–1n).
  setup,

  /// The three-tab app (1o onwards).
  home,
}

/// Root widget for the Khushhal application.
///
/// Owns the app locale so the language chosen on design 1a (or later in
/// Settings) takes effect immediately across the whole tree, and owns the
/// [AppSession] so logging out can drop every trace of the previous run.
class MyApp extends StatefulWidget {
  /// Creates the root app widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Starts on the device language when it is one we ship, so a Hindi handset
  /// opens design 1a already in Hindi. The user can still switch on the card.
  AppLanguage _language = AppLanguage.fromLocale(
    WidgetsBinding.instance.platformDispatcher.locale,
  );

  _AppPhase _phase = _AppPhase.onboarding;

  AppSession _session = AppSession();

  void _setLanguage(AppLanguage language) {
    setState(() => _language = language);
  }

  void _logout() {
    setState(() {
      _phase = _AppPhase.onboarding;
      _session = AppSession();
    });
  }

  Widget _phaseScreen() {
    return switch (_phase) {
      _AppPhase.onboarding => OnboardingFlow(
        key: const ValueKey<_AppPhase>(_AppPhase.onboarding),
        language: _language,
        onLanguageSelected: _setLanguage,
        onCompleted: () => setState(() => _phase = _AppPhase.setup),
      ),
      _AppPhase.setup => SetupFlow(
        key: const ValueKey<_AppPhase>(_AppPhase.setup),
        onFinished: () => setState(() => _phase = _AppPhase.home),
      ),
      _AppPhase.home => AppShell(
        key: const ValueKey<_AppPhase>(_AppPhase.home),
        onLanguageSelected: _setLanguage,
        onLogout: _logout,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khushhal',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // The approved screens are all drawn on the light "First light"
      // scheme; dark stays off until designs exist for it.
      themeMode: ThemeMode.light,
      locale: _language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Above the Navigator, not around `home`: pushed routes (add entry,
      // forecast, alerts…) must find the session too.
      builder: (BuildContext context, Widget? child) {
        return SessionScope(session: _session, child: child!);
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: _phaseScreen(),
      ),
    );
  }
}
