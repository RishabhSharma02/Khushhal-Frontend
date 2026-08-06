import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/model/business.dart';
import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/core/widgets/page_backdrop.dart';
import 'package:khushhal/features/entries/presentation/add_entry_screen.dart';
import 'package:khushhal/features/forecast/presentation/alert_detail_screen.dart';
import 'package:khushhal/features/forecast/presentation/alerts_screen.dart';
import 'package:khushhal/features/forecast/presentation/forecast_screen.dart';
import 'package:khushhal/features/forecast/presentation/monthly_update_screen.dart';
import 'package:khushhal/features/home/presentation/app_shell.dart';
import 'package:khushhal/features/home/presentation/home_screen.dart';
import 'package:khushhal/features/home/presentation/widgets/business_pill.dart';
import 'package:khushhal/features/money/presentation/savings_loan_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

/// A session in the everyday state (1o) — demo minus the pending update.
AppSession _settledSession() => AppSession.demo()..acceptMonthlyUpdate();

const Business _secondBusiness = Business(
  name: 'Sunita Kirana Store',
  segment: BusinessSegment.own,
  sector: BusinessSector.shop,
  tenure: BusinessTenure.oneToThreeYears,
  staffCount: 1,
  monthly: MonthlyMoney(
    moneyIn: 20000,
    moneyOut: 15000,
    loanEmi: 0,
    savings: 10000,
    basis: MoneyBasis.roughEstimate,
  ),
);

Widget _app(
  Widget home, {
  required AppSession session,
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
            child: home,
          );
        },
      ),
    ),
  );
}

Widget _homeOnly(AppSession session, {Locale locale = const Locale('en')}) {
  return _app(
    const Scaffold(body: PageBackdrop(child: HomeScreen())),
    session: session,
    locale: locale,
  );
}

Widget _shell(
  AppSession session, {
  Locale locale = const Locale('en'),
  double textScale = 1,
}) {
  return _app(
    AppShell(onLanguageSelected: (_) {}, onLogout: () {}),
    session: session,
    locale: locale,
    textScale: textScale,
  );
}

void main() {
  group('HomeScreen (1o)', () {
    testWidgets('shows the health card, four tiles and the watch item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_homeOnly(_settledSession()));

      expect(find.text(en.healthHeadline('Shanti Dairy Farm')), findsOneWidget);
      expect(find.text(en.healthSummary(76)), findsOneWidget);
      expect(find.text(en.tileMoneyIn), findsOneWidget);
      expect(find.text(en.tileMoneyOut), findsOneWidget);
      expect(find.text('${en.tileSavings} ✎'), findsOneWidget);
      expect(find.text('${en.tileLoan} ✎'), findsOneWidget);
      expect(find.text('₹43,750'), findsOneWidget);
      expect(find.text('₹41,200'), findsOneWidget);
      expect(find.text(en.homeWatch), findsOneWidget);
      expect(find.text(en.watchAction), findsOneWidget);
      expect(find.text(en.homeWriteEntryCta), findsOneWidget);
    });

    testWidgets('savings tile opens savings & loan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_homeOnly(_settledSession()));

      await tester.ensureVisible(find.text('${en.tileSavings} ✎'));
      await tester.tap(find.text('${en.tileSavings} ✎'));
      await tester.pumpAndSettle();

      expect(find.byType(SavingsLoanScreen), findsOneWidget);
    });

    testWidgets('health card opens the forecast', (WidgetTester tester) async {
      await tester.pumpWidget(_homeOnly(_settledSession()));

      await tester.ensureVisible(find.text(en.healthSummary(76)));
      await tester.tap(find.text(en.healthSummary(76)));
      await tester.pumpAndSettle();

      expect(find.byType(ForecastScreen), findsOneWidget);
    });

    testWidgets('watch card opens alerts; its action opens the plan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_homeOnly(_settledSession()));

      await tester.ensureVisible(find.text(en.watchAction));
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.watchAction));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDetailScreen), findsOneWidget);

      Navigator.of(tester.element(find.byType(AlertDetailScreen))).pop();
      await tester.pumpAndSettle();

      final Finder watchTitle = find.textContaining(
        en.watchTitle('Nov'),
        findRichText: true,
      );
      await tester.ensureVisible(watchTitle);
      await tester.pumpAndSettle();
      await tester.tap(watchTitle);
      await tester.pumpAndSettle();
      expect(find.byType(AlertsScreen), findsOneWidget);
    });

    testWidgets('write-entry button opens the entry form', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_homeOnly(_settledSession()));

      await tester.tap(find.text(en.homeWriteEntryCta));
      await tester.pumpAndSettle();

      expect(find.byType(AddEntryScreen), findsOneWidget);
    });

    testWidgets('the business pill switches businesses', (
      WidgetTester tester,
    ) async {
      final AppSession session = _settledSession()
        ..addBusiness(_secondBusiness);
      await tester.pumpWidget(_homeOnly(session));

      await tester.tap(find.byType(BusinessPill));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sunita Kirana Store'));
      await tester.pumpAndSettle();

      expect(
        find.text(en.healthHeadline('Sunita Kirana Store')),
        findsOneWidget,
      );
    });
  });

  group('HomeScreen — month closed (1o2)', () {
    testWidgets('shows the banner, NEW stamp and the reveal button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_homeOnly(AppSession.demo()));

      expect(find.text(en.homeMonthClosedBanner('October')), findsOneWidget);
      expect(find.text(en.scoreNew.toUpperCase()), findsOneWidget);
      expect(find.text('▲ 4'), findsOneWidget);
      expect(find.text(en.homeSeeChangedCta), findsOneWidget);
      expect(find.text(en.homeWriteEntryCta), findsNothing);
    });

    testWidgets('reveal button opens the monthly update', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_homeOnly(AppSession.demo()));

      await tester.tap(find.text(en.homeSeeChangedCta));
      await tester.pumpAndSettle();

      expect(find.byType(MonthlyUpdateScreen), findsOneWidget);
    });

    testWidgets('settles to the everyday home once the update is accepted', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo();
      await tester.pumpWidget(_homeOnly(session));

      session.acceptMonthlyUpdate();
      await tester.pump();

      expect(find.text(en.homeMonthClosedBanner('October')), findsNothing);
      expect(find.text(en.scoreNew.toUpperCase()), findsNothing);
      expect(find.text(en.healthSummary(76)), findsOneWidget);
      expect(find.text(en.homeWriteEntryCta), findsOneWidget);
    });
  });

  group('HomeScreen — offline (1u)', () {
    testWidgets('degrades to the on-device essentials', (
      WidgetTester tester,
    ) async {
      final AppSession session = _settledSession()
        ..connectivity = ConnectivityStatus.offline;
      await tester.pumpWidget(_homeOnly(session));

      expect(find.text(en.brandName), findsOneWidget);
      expect(find.text(en.offlineBanner(1)), findsOneWidget);
      expect(find.text(en.offlineHealthHeadline), findsOneWidget);
      expect(find.text(en.tileMoneyIn), findsOneWidget);
      expect(find.text('${en.tileSavings} ✎'), findsNothing);
      expect(find.text('${en.tileLoan} ✎'), findsNothing);
      expect(find.text(en.homeWatch), findsNothing);
      expect(find.text(en.homeWriteEntryCta), findsOneWidget);
    });
  });

  group('AppShell', () {
    testWidgets('tabs switch between home, history and settings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_shell(_settledSession()));

      IndexedStack stack() =>
          tester.widget<IndexedStack>(find.byType(IndexedStack));

      expect(stack().index, 0);

      await tester.tap(find.text(en.navHistory));
      await tester.pumpAndSettle();
      expect(stack().index, 1);

      await tester.tap(find.text(en.navSettings));
      await tester.pumpAndSettle();
      expect(stack().index, 2);

      await tester.tap(find.text(en.navHome));
      await tester.pumpAndSettle();
      expect(stack().index, 0);
    });

    testWidgets('renders in Hindi', (WidgetTester tester) async {
      await tester.pumpWidget(
        _shell(_settledSession(), locale: const Locale('hi')),
      );

      expect(find.text(hi.navHome), findsOneWidget);
      expect(find.text(hi.navHistory), findsOneWidget);
      expect(find.text(hi.homeWriteEntryCta), findsOneWidget);
      expect(find.text(hi.healthHeadline('Shanti Dairy Farm')), findsOneWidget);
    });

    testWidgets('fits a small screen at the largest text size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_shell(_settledSession(), textScale: 2));
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(en.navHistory));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(en.navSettings));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
