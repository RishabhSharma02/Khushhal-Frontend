import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/forecast/presentation/alert_detail_screen.dart';
import 'package:khushhal/features/forecast/presentation/forecast_screen.dart';
import 'package:khushhal/features/forecast/presentation/monthly_update_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

Widget _app(
  Widget child, {
  AppSession? session,
  Locale locale = const Locale('en'),
}) {
  return SessionScope(
    session: session ?? AppSession.demo(),
    child: MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  group('ForecastScreen (1q)', () {
    testWidgets('shows six months with the risk month flagged', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const ForecastScreen()));
      await tester.pumpAndSettle();

      for (final String month in <String>[
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
        'Jan',
      ]) {
        expect(find.text(month), findsOneWidget);
      }

      expect(find.text(en.forecastInsightTitle('November')), findsOneWidget);
      expect(find.text(en.forecastMadeOn('1 Nov', '1 Dec')), findsOneWidget);
    });

    testWidgets('the CTA opens the plan (1s)', (WidgetTester tester) async {
      await tester.pumpWidget(_app(const ForecastScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.forecastWhatCta));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDetailScreen), findsOneWidget);
    });

    testWidgets('what-if chips select without changing the edition', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const ForecastScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.whatIfSpike));
      await tester.pump();

      // Still the same official edition underneath.
      expect(find.text(en.forecastMadeOn('1 Nov', '1 Dec')), findsOneWidget);
    });
  });

  group('MonthlyUpdateScreen (1q2)', () {
    testWidgets('reveals the new score and consumes the pending update', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo();
      expect(session.updateReady, isTrue);

      await tester.pumpWidget(
        _app(const MonthlyUpdateScreen(), session: session),
      );
      await tester.pumpAndSettle();

      expect(session.updateReady, isFalse);
      expect(session.health?.score, 76);
      expect(find.text('76'), findsOneWidget);
      expect(
        find.text('▲ ${en.updateDeltaFrom(4, 'October')}'),
        findsOneWidget,
      );
      expect(
        find.text(en.reasonMilkIncome('₹4,200', 'September')),
        findsOneWidget,
      );
      expect(find.text(en.reasonSteadyEntries(28, 31)), findsOneWidget);
      expect(find.text(en.reasonFodderCost('₹1,900')), findsOneWidget);
    });

    testWidgets('still renders once the update was already accepted', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo()..acceptMonthlyUpdate();

      await tester.pumpWidget(
        _app(const MonthlyUpdateScreen(), session: session),
      );
      await tester.pumpAndSettle();

      expect(find.text('76'), findsOneWidget);
    });

    testWidgets('the CTA replaces the reveal with the forecast', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const MonthlyUpdateScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.updateSeeForecastCta));
      await tester.pumpAndSettle();

      expect(find.byType(ForecastScreen), findsOneWidget);
      expect(find.byType(MonthlyUpdateScreen), findsNothing);
    });

    testWidgets('renders Hindi copy under the Hindi locale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(const MonthlyUpdateScreen(), locale: const Locale('hi')),
      );
      await tester.pumpAndSettle();

      expect(find.text(hi.updateWhyMoved), findsOneWidget);
      expect(find.text(en.updateWhyMoved), findsNothing);
    });
  });
}
