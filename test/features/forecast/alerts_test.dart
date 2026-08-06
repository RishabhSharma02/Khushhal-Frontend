import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/forecast/presentation/alert_detail_screen.dart';
import 'package:khushhal/features/forecast/presentation/alerts_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';

final AppLocalizationsEn en = AppLocalizationsEn();

Widget _app(Widget child, {AppSession? session}) {
  return SessionScope(
    session: session ?? AppSession.demo(),
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  group('AlertsScreen (1r)', () {
    testWidgets('lists all three alerts by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const AlertsScreen()));
      await tester.pumpAndSettle();

      expect(find.text(en.alertSavingsTitle('November')), findsOneWidget);
      expect(find.text(en.alertFodderTitle), findsOneWidget);
      expect(find.text(en.alertRainTitle), findsOneWidget);
      expect(find.text(en.alertsSmsNote), findsOneWidget);
    });

    testWidgets('the urgent filter keeps only the amber alert', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const AlertsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.alertsFilterUrgent(1)));
      await tester.pump();

      expect(find.text(en.alertSavingsTitle('November')), findsOneWidget);
      expect(find.text(en.alertFodderTitle), findsNothing);
      expect(find.text(en.alertRainTitle), findsNothing);
    });

    testWidgets('the info filter hides the urgent alert', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const AlertsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.alertsFilterInfo));
      await tester.pump();

      expect(find.text(en.alertSavingsTitle('November')), findsNothing);
      expect(find.text(en.alertFodderTitle), findsOneWidget);
      expect(find.text(en.alertRainTitle), findsOneWidget);
    });

    testWidgets('the urgent alert opens the plan (1s)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const AlertsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.alertSavingsTitle('November')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDetailScreen), findsOneWidget);
    });
  });

  group('AlertDetailScreen (1s)', () {
    testWidgets('shows the three actions with their benefits', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(const AlertDetailScreen()));
      await tester.pumpAndSettle();

      expect(find.text(en.planTightTitle('November')), findsOneWidget);
      expect(find.text(en.planFodderTitle), findsOneWidget);
      expect(find.text(en.planWeeklyTitle('₹500')), findsOneWidget);
      expect(find.text(en.planEmiTitle), findsOneWidget);
      expect(find.text(en.planDoneChip), findsNWidgets(3));
    });

    testWidgets('marking an action done sticks in the session', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo();
      await tester.pumpWidget(
        _app(const AlertDetailScreen(), session: session),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.planDoneChip).first);
      await tester.pump();

      expect(session.planActions.first.done, isTrue);

      // A rebuild keeps the state — it lives in the session, not the widget.
      await tester.pumpWidget(
        _app(const AlertDetailScreen(), session: session),
      );
      await tester.pumpAndSettle();
      expect(session.planActions.first.done, isTrue);

      await tester.tap(find.text(en.planDoneChip).first);
      await tester.pump();
      expect(session.planActions.first.done, isFalse);
    });
  });
}
