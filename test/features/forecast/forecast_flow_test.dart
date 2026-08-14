import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/forecast/presentation/alert_detail_screen.dart';
import 'package:khushhal/features/forecast/presentation/forecast_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';

final AppLocalizationsEn en = AppLocalizationsEn();

Widget _app(Widget child) {
  return SessionScope(
    session: AppSession.demo(),
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  group('ForecastScreen (1q)', () {
    testWidgets('the CTA opens the plan (1s)', (WidgetTester tester) async {
      await tester.pumpWidget(_app(const ForecastScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.forecastWhatCta));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDetailScreen), findsOneWidget);
    });
  });
}
