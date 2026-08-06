import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/model/ledger.dart';
import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/core/widgets/page_backdrop.dart';
import 'package:khushhal/features/entries/presentation/add_entry_screen.dart';
import 'package:khushhal/features/entries/presentation/history_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

Widget _history(
  AppSession session, {
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
            child: const Scaffold(body: PageBackdrop(child: HistoryScreen())),
          );
        },
      ),
    ),
  );
}

void main() {
  group('HistoryScreen (1v)', () {
    testWidgets('shows the month totals strip', (WidgetTester tester) async {
      await tester.pumpWidget(_history(AppSession.demo()));

      expect(find.text(en.historyInMonth('Oct')), findsOneWidget);
      expect(find.text(en.historyOutMonth('Oct')), findsOneWidget);
      expect(find.text(en.historyLoanPaid), findsOneWidget);
      expect(find.text('₹43,750'), findsOneWidget);
      expect(find.text('₹38,550'), findsOneWidget);
      expect(find.text('₹8,000'), findsOneWidget);
    });

    testWidgets('groups entries by day with their notes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_history(AppSession.demo()));

      expect(find.text(en.historyToday.toUpperCase()), findsOneWidget);
      expect(find.text(en.historyYesterday.toUpperCase()), findsOneWidget);
      expect(find.text('+₹1,850'), findsOneWidget);
      expect(find.text('−₹600'), findsOneWidget);
      expect(find.textContaining(en.historyByVoice), findsOneWidget);
      expect(find.textContaining(en.historyWillSync), findsOneWidget);
      expect(find.textContaining(en.historyTapToCorrect), findsOneWidget);
    });

    testWidgets('the IN filter hides money going out', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_history(AppSession.demo()));

      await tester.tap(find.text(en.entryIn));
      await tester.pump();

      expect(find.text('+₹1,850'), findsOneWidget);
      expect(find.text('+₹1,700'), findsOneWidget);
      expect(find.text('−₹600'), findsNothing);
      expect(find.text('−₹8,000'), findsNothing);
    });

    testWidgets('the Loan filter keeps only EMI entries', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_history(AppSession.demo()));

      await tester.tap(find.text(en.tileLoan));
      await tester.pump();

      expect(find.text('−₹8,000'), findsOneWidget);
      expect(find.text('+₹1,850'), findsNothing);
    });

    testWidgets('a new entry appears and moves the totals', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo();
      await tester.pumpWidget(_history(session));

      session.addEntry(
        LedgerEntry(
          kind: EntryKind.moneyIn,
          amountInr: 2200,
          category: EntryCategory.milkSale,
          recordedAt: DateTime(2026, 10, 22, 10, 0),
        ),
      );
      await tester.pump();

      expect(find.text('+₹2,200'), findsOneWidget);
      expect(find.text('₹45,950'), findsOneWidget);
    });

    testWidgets('tapping an entry opens the entry form to correct it', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_history(AppSession.demo()));

      await tester.tap(find.text('+₹1,850'));
      await tester.pumpAndSettle();

      expect(find.byType(AddEntryScreen), findsOneWidget);
    });

    testWidgets('renders in Hindi', (WidgetTester tester) async {
      await tester.pumpWidget(
        _history(AppSession.demo(), locale: const Locale('hi')),
      );

      expect(find.text(hi.historyTitle), findsOneWidget);
      expect(find.text(hi.historyLoanPaid), findsOneWidget);
      expect(find.text(hi.historyToday.toUpperCase()), findsOneWidget);
    });

    testWidgets('fits a small screen at the largest text size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_history(AppSession.demo(), textScale: 2));

      expect(tester.takeException(), isNull);
    });
  });
}
