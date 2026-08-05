import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'features/onboarding/domain/app_language.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget for the Khushhal application.
///
/// Owns the app locale so the language chosen on design 1a takes effect
/// immediately across the whole tree.
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

  bool _onboarded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khushhal',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // The entry flow is drawn on a fixed light backdrop, so it stays in the
      // light theme until the rest of the app exists.
      themeMode: ThemeMode.light,
      locale: _language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _onboarded
          ? _LoginPlaceholder(language: _language)
          : OnboardingFlow(
              language: _language,
              onLanguageSelected: (AppLanguage chosen) {
                setState(() => _language = chosen);
              },
              onCompleted: () => setState(() => _onboarded = true),
            ),
    );
  }
}

/// Stands in for the login screen (design 1f), which is not built yet.
class _LoginPlaceholder extends StatelessWidget {
  const _LoginPlaceholder({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Login — design 1f', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Not implemented yet. Onboarding finished in '
                '${language.endonym} (${language.code}).',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
