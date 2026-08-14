import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/entries/presentation/add_entry_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';
import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/l10n/app_localizations_hi.dart';

final AppLocalizationsEn en = AppLocalizationsEn();
final AppLocalizationsHi hi = AppLocalizationsHi();

/// Hosts the screen behind a push so saving can pop back here.
class _Host extends StatelessWidget {
  const _Host();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext _) => const AddEntryScreen(),
              ),
            );
          },
          child: const Text('open'),
        ),
      ),
    );
  }
}

Widget _app(AppSession session, {Locale locale = const Locale('en')}) {
  return SessionScope(
    session: session,
    child: MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _Host(),
    ),
  );
}

Future<void> _open(WidgetTester tester, AppSession session) async {
  await tester.pumpWidget(_app(session));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  group('AddEntryScreen (1p)', () {
    testWidgets('does nothing without an amount', (WidgetTester tester) async {
      final AppSession session = AppSession.demo();
      final int entriesBefore = session.entries.length;
      await _open(tester, session);

      await tester.tap(find.text(en.saveCta));
      await tester.pumpAndSettle();

      // Still here, nothing recorded.
      expect(find.byType(AddEntryScreen), findsOneWidget);
      expect(session.entries.length, entriesBefore);
    });

    testWidgets('renders Hindi copy under the Hindi locale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(AppSession.demo(), locale: const Locale('hi')),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text(hi.addEntryTitle), findsOneWidget);
      expect(find.text(hi.entryIn), findsOneWidget);
      expect(find.text(en.addEntryTitle), findsNothing);
    });
  });
}
