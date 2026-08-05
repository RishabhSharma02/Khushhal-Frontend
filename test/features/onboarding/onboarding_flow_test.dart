import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/onboarding/domain/app_language.dart';
import 'package:khushhal/features/onboarding/domain/usp_slide.dart';
import 'package:khushhal/features/onboarding/presentation/usp_carousel_screen.dart';
import 'package:khushhal/features/onboarding/presentation/widgets/page_dots.dart';
import 'package:khushhal/features/onboarding/presentation/widgets/usp_carousel.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';
import 'package:khushhal/main.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

Widget _localized(
  Widget child, {
  Locale locale = const Locale('en'),
  bool disableAnimations = false,
  double textScale = 1,
}) {
  return MaterialApp(
    theme: AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // Pinned rather than inherited from the host: whether this machine has
    // "reduce motion" on decides whether the carousel scrolls itself.
    home: Builder(
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: disableAnimations,
            textScaler: TextScaler.linear(textScale),
          ),
          child: child,
        );
      },
    ),
  );
}

void main() {
  group('LanguageSelectScreen (1a)', () {
    testWidgets('lists both launch languages in their own script', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text(AppLanguage.hindi.endonym), findsOneWidget);
      expect(find.text(AppLanguage.english.endonym), findsOneWidget);
    });

    testWidgets('renders in the selected language, without translations '
        'alongside', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Opens in English on an English device.
      expect(find.text(en.languageHeading), findsOneWidget);
      expect(find.text(hi.languageHeading), findsNothing);

      await tester.tap(find.text(AppLanguage.hindi.endonym));
      await tester.pumpAndSettle();

      // Every string swaps; nothing English is left behind on the screen.
      expect(find.text(hi.languageHeading), findsOneWidget);
      expect(find.text(hi.languageSubheading), findsOneWidget);
      expect(find.text(hi.languageContinue), findsOneWidget);
      expect(find.text(hi.languageMoreComingSoon), findsOneWidget);
      expect(find.text(hi.languageOfflineFootnote), findsOneWidget);
      expect(find.text(hi.brandName), findsOneWidget);

      expect(find.text(en.languageHeading), findsNothing);
      expect(find.text(en.languageContinue), findsNothing);
      expect(find.text(en.languageMoreComingSoon), findsNothing);
      expect(find.text(en.brandName), findsNothing);

      // The card titles are the one thing that stays in-script.
      expect(find.text(AppLanguage.english.endonym), findsOneWidget);
    });

    testWidgets('carries the chosen language into the carousel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text(AppLanguage.hindi.endonym));
      await tester.pumpAndSettle();
      await tester.tap(find.text(hi.languageContinue));
      await tester.pumpAndSettle();

      expect(find.text(hi.uspForecastTitle), findsOneWidget);
      expect(find.text(en.uspForecastTitle), findsNothing);
    });
  });

  group('UspCarouselScreen (1b–1e)', () {
    const Duration hold = Duration(seconds: 2);

    Future<void> pumpCarousel(
      WidgetTester tester, {
      required VoidCallback onFinished,
      Locale locale = const Locale('en'),
      Duration slideDuration = hold,
      bool disableAnimations = false,
    }) {
      return tester.pumpWidget(
        _localized(
          UspCarouselScreen(
            onFinished: onFinished,
            slideDuration: slideDuration,
          ),
          locale: locale,
          disableAnimations: disableAnimations,
        ),
      );
    }

    /// Waits out one hold and the glide that follows it.
    Future<void> waitForNextCard(WidgetTester tester) async {
      await tester.pump(hold);
      await tester.pumpAndSettle();
    }

    testWidgets('opens on the first card', (WidgetTester tester) async {
      await pumpCarousel(tester, onFinished: () {});

      _expectShowing(tester, en.uspForecastTitle);
      expect(_activeDot(tester), 0);
    });

    testWidgets('scrolls itself through all four cards', (
      WidgetTester tester,
    ) async {
      await pumpCarousel(tester, onFinished: () {});

      final List<String> titles = <String>[
        en.uspForecastTitle,
        en.uspOnePlaceTitle,
        en.uspActionsTitle,
        en.uspOfflineTitle,
      ];

      for (int index = 0; index < titles.length; index++) {
        _expectShowing(tester, titles[index]);
        expect(_activeDot(tester), index);

        if (index < titles.length - 1) {
          await waitForNextCard(tester);
        }
      }
    });

    testWidgets('comes back round to the first card instead of dead-ending', (
      WidgetTester tester,
    ) async {
      bool finished = false;
      await pumpCarousel(tester, onFinished: () => finished = true);

      for (int index = 0; index < 4; index++) {
        await waitForNextCard(tester);
      }

      _expectShowing(tester, en.uspForecastTitle);
      expect(_activeDot(tester), 0);

      // Looping is not leaving: only a tap ends onboarding.
      expect(finished, isFalse);
    });

    testWidgets('holds still when the device asks for reduced motion', (
      WidgetTester tester,
    ) async {
      await pumpCarousel(tester, onFinished: () {}, disableAnimations: true);

      await tester.pump(hold * 3);
      await tester.pumpAndSettle();

      _expectShowing(tester, en.uspForecastTitle);
      expect(_activeDot(tester), 0);
    });

    testWidgets('a drag takes over and settles on a whole card', (
      WidgetTester tester,
    ) async {
      await pumpCarousel(
        tester,
        onFinished: () {},
        slideDuration: const Duration(minutes: 5),
      );

      await tester.drag(find.byType(ListView), const Offset(-450, 0));
      await tester.pumpAndSettle();

      _expectShowing(tester, en.uspOnePlaceTitle);
      expect(_activeDot(tester), 1);
    });

    testWidgets('picks the timer back up after a drag', (
      WidgetTester tester,
    ) async {
      await pumpCarousel(tester, onFinished: () {});

      await tester.drag(find.byType(ListView), const Offset(-450, 0));
      await tester.pumpAndSettle();
      await waitForNextCard(tester);

      _expectShowing(tester, en.uspActionsTitle);
      expect(_activeDot(tester), 2);
    });

    testWidgets('Continue stays on screen and is the only way forward', (
      WidgetTester tester,
    ) async {
      await pumpCarousel(tester, onFinished: () {});

      expect(find.text(en.onboardingContinue), findsOneWidget);

      for (int index = 0; index < 3; index++) {
        await waitForNextCard(tester);
        expect(find.text(en.onboardingContinue), findsOneWidget);
      }
    });

    testWidgets('Continue leaves the flow from whichever card is showing', (
      WidgetTester tester,
    ) async {
      bool finished = false;
      await pumpCarousel(tester, onFinished: () => finished = true);

      await waitForNextCard(tester);
      await tester.tap(find.text(en.onboardingContinue));

      expect(finished, isTrue);
    });

    testWidgets('fits a small screen at the largest text sizes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _localized(
          UspCarouselScreen(onFinished: () {}, slideDuration: hold),
          textScale: 2,
        ),
      );

      // The card gives the picture up before it clips a word, so nothing here
      // may overflow whatever the text size.
      for (int index = 0; index < 4; index++) {
        await waitForNextCard(tester);
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('ships the artwork for every slide', (
      WidgetTester tester,
    ) async {
      // A missing asset degrades to a captioned placeholder at runtime, which
      // is easy to miss in a review — so check the bundle itself.
      for (final String asset in <String>[
        OnboardingAssets.uspForecast,
        OnboardingAssets.uspOnePlace,
        OnboardingAssets.uspActions,
        OnboardingAssets.uspOffline,
      ]) {
        final ByteData data = await rootBundle.load(asset);

        expect(
          data.lengthInBytes,
          greaterThan(0),
          reason: '$asset should be in the bundle',
        );
      }
    });

    testWidgets('renders Hindi copy under the Hindi locale', (
      WidgetTester tester,
    ) async {
      await pumpCarousel(
        tester,
        onFinished: () {},
        locale: const Locale('hi'),
        slideDuration: const Duration(minutes: 5),
      );

      expect(find.text(hi.uspForecastTitle), findsOneWidget);
      expect(find.text(hi.onboardingContinue), findsOneWidget);
      expect(find.text(en.uspForecastTitle), findsNothing);
    });
  });
}

/// Asserts [title] belongs to the card sitting in the middle of the strip —
/// its neighbours are on screen too, just off to the sides.
void _expectShowing(WidgetTester tester, String title) {
  expect(
    find.text(title),
    findsOneWidget,
    reason: '"$title" should be on the strip',
  );
  expect(
    tester.getCenter(find.text(title)).dx,
    closeTo(tester.getCenter(find.byType(UspCarousel)).dx, 1),
    reason: '"$title" should be the card in the middle',
  );
}

int _activeDot(WidgetTester tester) {
  return tester.widget<PageDots>(find.byType(PageDots)).activeIndex;
}
