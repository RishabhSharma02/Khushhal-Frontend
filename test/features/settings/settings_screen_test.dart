import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/core/widgets/page_backdrop.dart';
import 'package:khushhal/features/onboarding/domain/app_language.dart';
import 'package:khushhal/features/settings/presentation/settings_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

Widget _settings(
  AppSession session, {
  ValueChanged<AppLanguage>? onLanguageSelected,
  VoidCallback? onLogout,
  Locale locale = const Locale('en'),
  double textScale = 1,
}) {
  return SessionScope(
    session: session,
    child: MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Scaffold(
              body: PageBackdrop(
                child: SettingsScreen(
                  onLanguageSelected: onLanguageSelected ?? (_) {},
                  onLogout: onLogout ?? () {},
                  onShowHome: () {},
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

void main() {
  group('SettingsScreen (1x)', () {
    testWidgets('shows profile, businesses and preferences', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_settings(AppSession.demo()));

      expect(find.text('Sunita Devi'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('Shanti Dairy Farm'), findsOneWidget);
      expect(
        find.text('${en.sectorDairy} · ${en.settingsPlaceValue}'),
        findsOneWidget,
      );
      expect(find.text(en.settingsAddBusiness), findsOneWidget);
      expect(find.text(en.settingsLanguage), findsOneWidget);
      expect(find.text(en.settingsNotificationsValue), findsOneWidget);
      expect(find.text(en.settingsVersion), findsOneWidget);
      expect(find.text(en.settingsLogOut), findsOneWidget);
    });

    testWidgets('the inline language toggle hands back the chosen language', (
      WidgetTester tester,
    ) async {
      AppLanguage? chosen;
      await tester.pumpWidget(
        _settings(
          AppSession.demo(),
          onLanguageSelected: (AppLanguage language) => chosen = language,
        ),
      );

      // Both segments are on screen at once — no sheet to open first.
      expect(find.text(AppLanguage.english.shortEndonym), findsOneWidget);

      await tester.tap(find.text(AppLanguage.hindi.shortEndonym));
      await tester.pumpAndSettle();

      expect(chosen, AppLanguage.hindi);
    });

    testWidgets('log out fires the callback', (WidgetTester tester) async {
      bool loggedOut = false;
      await tester.pumpWidget(
        _settings(AppSession.demo(), onLogout: () => loggedOut = true),
      );

      await tester.scrollUntilVisible(find.text(en.settingsLogOut), 120);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.settingsLogOut));

      expect(loggedOut, isTrue);
    });

    testWidgets('renders in Hindi', (WidgetTester tester) async {
      await tester.pumpWidget(
        _settings(AppSession.demo(), locale: const Locale('hi')),
      );

      expect(find.text(hi.settingsTitle), findsOneWidget);
      expect(find.text(hi.settingsMyBusinesses.toUpperCase()), findsOneWidget);
      expect(find.text(hi.settingsLogOut), findsOneWidget);
    });

    testWidgets('fits a small screen at the largest text size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_settings(AppSession.demo(), textScale: 2));

      expect(tester.takeException(), isNull);
    });
  });
}
