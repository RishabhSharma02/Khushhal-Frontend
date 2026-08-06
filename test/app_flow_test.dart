import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/features/settings/presentation/settings_screen.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/main.dart';

final AppLocalizationsEn en = AppLocalizationsEn();

/// The whole approved journey in one run: language select (1a), USP carousel
/// (1b–1e), guided setup (1h–1n), home (1o2 first, since a fresh score is
/// waiting), and out again via Settings' log out.
///
/// Login/OTP (1f–1g3) are deliberately absent from this build, so the
/// carousel hands straight over to setup.
void main() {
  testWidgets('a new user reaches home and can log back out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // 1a → 1b: confirm the language.
    await tester.tap(find.text(en.languageContinue));
    await tester.pumpAndSettle();

    // 1b–1e → 1h: one Continue leaves the carousel.
    await tester.tap(find.text(en.onboardingContinue));
    await tester.pumpAndSettle();

    // 1h: the detected location is already on screen; confirm it.
    expect(find.text(en.locationHeading), findsOneWidget);
    await tester.tap(find.text(en.locationConfirmCta));
    await tester.pumpAndSettle();

    // 1i: the default count (1) is fine.
    await tester.tap(find.text(en.setupNextCta));
    await tester.pumpAndSettle();

    // 1j → 1k: begin the one business.
    await tester.tap(find.text(en.hubStartCta));
    await tester.pumpAndSettle();

    // 1k: defaults (SHG · Dairy) are the mock's picks.
    await tester.tap(find.text(en.setupNextCta));
    await tester.pumpAndSettle();

    // 1l: the name is the one thing that must be typed.
    await tester.enterText(find.byType(TextField).first, 'Shanti Dairy Farm');
    await tester.tap(find.text(en.setupNextCta));
    await tester.pumpAndSettle();

    // 1m: rough-estimate defaults stand.
    await tester.tap(find.text(en.moneySeeCardCta));
    await tester.pumpAndSettle();

    // 1j again: the business shows done and Finish is unlocked.
    expect(find.text('Shanti Dairy Farm'), findsOneWidget);
    await tester.tap(find.text(en.hubFinishCta));
    await tester.pumpAndSettle();

    // Home: a fresh month-end score is waiting (1o2), under the name the
    // user just typed.
    expect(find.text('Shanti Dairy Farm'), findsOneWidget);
    expect(find.text(en.homeSeeChangedCta), findsOneWidget);

    // Settings → Log out lands back on the language screen with a clean
    // slate.
    await tester.tap(find.text(en.navSettings));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(en.settingsLogOut),
      200,
      scrollable: find
          .descendant(
            of: find.byType(SettingsScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text(en.settingsLogOut));
    await tester.pumpAndSettle();

    expect(find.text(en.languageHeading), findsOneWidget);
  });
}
