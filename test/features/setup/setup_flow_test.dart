import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/model/business.dart';
import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/setup/presentation/setup_flow.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

Widget _app(
  AppSession session, {
  required VoidCallback onFinished,
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
            child: SetupFlow(onFinished: onFinished),
          );
        },
      ),
    ),
  );
}

/// Taps [label] and lets the stage transition settle.
///
/// Scrolls the label into view first — at double text scale, buttons inside
/// a step's scroll area can start below the fold.
Future<void> _tapThrough(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  group('SetupFlow (1h-1n)', () {
    testWidgets('walks one business from location to Finish', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession();
      bool finished = false;

      await tester.pumpWidget(_app(session, onFinished: () => finished = true));

      // 1h — location.
      expect(find.text(en.locationHeading), findsOneWidget);
      expect(find.text(en.locationDetectedValue), findsOneWidget);
      await _tapThrough(tester, en.locationConfirmCta);
      expect(session.locationConfirmed, isTrue);

      // 1i — count; the default answer (1) is enough.
      expect(find.text(en.countHeading), findsOneWidget);
      await _tapThrough(tester, en.setupNextCta);
      expect(session.plannedBusinessCount, 1);

      // 1j — hub, nothing done yet.
      expect(find.text(en.hubHeading), findsOneWidget);
      expect(find.text(en.hubDoneOf(0, 1)), findsOneWidget);
      await _tapThrough(tester, en.hubStartCta);

      // 1k — kind; dairy is preselected, so its note shows.
      expect(find.text(en.kindHeading), findsOneWidget);
      expect(find.text(en.kindDairyHint), findsOneWidget);
      await _tapThrough(tester, en.setupNextCta);

      // 1l — details; the name is the only typing in setup.
      expect(find.text(en.detailsHeading), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Shanti Dairy Farm');
      await tester.tap(find.text('＋'));
      await tester.pump();
      await _tapThrough(tester, en.setupNextCta);

      // 1m — money; rough sliders carry their defaults.
      expect(find.text(en.moneyHeading), findsOneWidget);
      await _tapThrough(tester, en.moneySeeCardCta);

      // Back at the hub with the check in place.
      expect(find.text(en.hubDoneOf(1, 1)), findsOneWidget);
      expect(find.text('Shanti Dairy Farm'), findsOneWidget);
      expect(finished, isFalse);

      await _tapThrough(tester, en.hubFinishCta);
      expect(finished, isTrue);

      expect(session.businesses, hasLength(1));
      final Business business = session.businesses.single;
      expect(business.name, 'Shanti Dairy Farm');
      expect(business.sector, BusinessSector.dairy);
      expect(business.staffCount, 2);
      expect(business.monthly.basis, MoneyBasis.roughEstimate);
      expect(business.monthly.moneyIn, 45000);
    });

    testWidgets('lets two planned businesses finish after just one', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession();
      bool finished = false;

      await tester.pumpWidget(_app(session, onFinished: () => finished = true));

      await _tapThrough(tester, en.locationConfirmCta);
      await tester.tap(find.text('2'));
      await tester.pump();
      await _tapThrough(tester, en.setupNextCta);

      expect(find.text(en.hubDoneOf(0, 2)), findsOneWidget);

      // Finish is locked while nothing is done.
      await _tapThrough(tester, en.hubFinishCta);
      expect(finished, isFalse);

      // Set up the first business with every default.
      await _tapThrough(tester, en.hubStartCta);
      await _tapThrough(tester, en.setupNextCta);
      await tester.enterText(find.byType(TextField), 'Shanti Dairy');
      await _tapThrough(tester, en.setupNextCta);
      await _tapThrough(tester, en.moneySeeCardCta);

      // One done, the second still waiting — and Finish now works.
      expect(find.text(en.hubDoneOf(1, 2)), findsOneWidget);
      expect(find.text(en.businessN(2)), findsOneWidget);
      expect(find.text(en.hubStatusNotStarted), findsOneWidget);

      await _tapThrough(tester, en.hubFinishCta);
      expect(finished, isTrue);
      expect(session.businesses, hasLength(1));
    });

    testWidgets('shows the dairy note only while dairy is picked', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession();

      await tester.pumpWidget(_app(session, onFinished: () {}));
      await _tapThrough(tester, en.locationConfirmCta);
      await _tapThrough(tester, en.setupNextCta);
      await _tapThrough(tester, en.hubStartCta);

      expect(find.text(en.kindDairyHint), findsOneWidget);

      await tester.tap(find.text(en.sectorPoultry));
      await tester.pump();
      expect(find.text(en.kindDairyHint), findsNothing);

      await tester.tap(find.text(en.sectorDairy));
      await tester.pump();
      expect(find.text(en.kindDairyHint), findsOneWidget);
    });

    testWidgets('records mode takes typed figures', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession();
      bool finished = false;

      await tester.pumpWidget(_app(session, onFinished: () => finished = true));

      await _tapThrough(tester, en.locationConfirmCta);
      await _tapThrough(tester, en.setupNextCta);
      await _tapThrough(tester, en.hubStartCta);
      await _tapThrough(tester, en.setupNextCta);
      await tester.enterText(find.byType(TextField), 'Ledger Dairy');
      await _tapThrough(tester, en.setupNextCta);

      await _tapThrough(tester, en.moneyModeRecords);
      expect(find.text(en.moneyRecordsNote), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), '43750');
      await tester.enterText(find.byType(TextField).at(1), '30500');
      await _tapThrough(tester, en.moneySeeCardCta);
      await _tapThrough(tester, en.hubFinishCta);

      expect(finished, isTrue);
      final Business business = session.businesses.single;
      expect(business.monthly.basis, MoneyBasis.fromRecords);
      expect(business.monthly.moneyIn, 43750);
      expect(business.monthly.moneyOut, 30500);
    });

    testWidgets('renders in Hindi under the Hindi locale', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession();

      await tester.pumpWidget(
        _app(session, onFinished: () {}, locale: const Locale('hi')),
      );

      expect(find.text(hi.locationHeading), findsOneWidget);
      expect(find.text(en.locationHeading), findsNothing);

      await _tapThrough(tester, hi.locationConfirmCta);
      expect(find.text(hi.countHeading), findsOneWidget);
    });

    testWidgets('fits a small screen at double text size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final AppSession session = AppSession();
      bool finished = false;

      await tester.pumpWidget(
        _app(session, onFinished: () => finished = true, textScale: 2),
      );

      await _tapThrough(tester, en.locationConfirmCta);
      expect(tester.takeException(), isNull);

      await _tapThrough(tester, en.setupNextCta);
      expect(tester.takeException(), isNull);

      await _tapThrough(tester, en.hubStartCta);
      expect(tester.takeException(), isNull);

      await _tapThrough(tester, en.setupNextCta);
      expect(tester.takeException(), isNull);

      await _tapThrough(tester, en.setupNextCta);
      expect(tester.takeException(), isNull);

      await _tapThrough(tester, en.moneySeeCardCta);
      expect(tester.takeException(), isNull);

      await _tapThrough(tester, en.hubFinishCta);
      expect(finished, isTrue);
      expect(tester.takeException(), isNull);
    });
  });
}
