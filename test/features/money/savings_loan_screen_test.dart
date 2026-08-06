import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/money/presentation/savings_loan_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';

final AppLocalizationsEn en = AppLocalizationsEn();

Widget _app(AppSession session) {
  return SessionScope(
    session: session,
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SavingsLoanScreen(),
    ),
  );
}

void main() {
  group('SavingsLoanScreen (1t)', () {
    testWidgets('shows both numbers with Indian grouping', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_app(AppSession.demo()));
      await tester.pumpAndSettle();

      expect(find.text('₹41,200'), findsOneWidget);
      expect(find.text('₹86,000'), findsOneWidget);
      expect(find.text(en.savingsHint), findsOneWidget);
      expect(find.text(en.loanHint), findsOneWidget);
    });

    testWidgets('Change edits savings through the dialog', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo();
      await tester.pumpWidget(_app(session));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.changeCta).first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '50000');
      await tester.tap(find.text(en.saveCta));
      await tester.pumpAndSettle();

      expect(session.savingsInr, 50000);
      expect(find.text('₹50,000'), findsOneWidget);
    });

    testWidgets('Cancel keeps the old number', (WidgetTester tester) async {
      final AppSession session = AppSession.demo();
      await tester.pumpWidget(_app(session));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.changeCta).last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '1');
      await tester.tap(find.text(en.cancelCta));
      await tester.pumpAndSettle();

      expect(session.loanInr, 86000);
      expect(find.text('₹86,000'), findsOneWidget);
    });
  });
}
