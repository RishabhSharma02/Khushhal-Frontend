import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/entries/presentation/add_entry_screen.dart';
import 'package:khushhal/features/forecast/presentation/alert_detail_screen.dart';
import 'package:khushhal/features/forecast/presentation/alerts_screen.dart';
import 'package:khushhal/features/forecast/presentation/forecast_screen.dart';
import 'package:khushhal/features/forecast/presentation/monthly_update_screen.dart';
import 'package:khushhal/features/money/presentation/savings_loan_screen.dart';
import 'package:khushhal/features/sync/presentation/sync_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';

/// Every money-flow screen on a small phone at the largest text size.
///
/// The cards may scroll, but nothing is allowed to overflow.
void main() {
  const Map<String, Widget> screens = <String, Widget>{
    'AddEntryScreen (1p)': AddEntryScreen(),
    'ForecastScreen (1q)': ForecastScreen(),
    'MonthlyUpdateScreen (1q2)': MonthlyUpdateScreen(),
    'AlertsScreen (1r)': AlertsScreen(),
    'AlertDetailScreen (1s)': AlertDetailScreen(),
    'SavingsLoanScreen (1t)': SavingsLoanScreen(),
    'SyncScreen (1w)': SyncScreen(),
  };

  for (final MapEntry<String, Widget> screen in screens.entries) {
    testWidgets('${screen.key} fits 320x568 at 2x text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        SessionScope(
          session: AppSession.demo(),
          child: MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (BuildContext context) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: screen.value,
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
