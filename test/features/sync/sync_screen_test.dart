import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/features/sync/presentation/sync_screen.dart';
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
      home: const SyncScreen(),
    ),
  );
}

void main() {
  group('SyncScreen (1w)', () {
    testWidgets('Sync now empties the queue and settles the chip', (
      WidgetTester tester,
    ) async {
      final AppSession session = AppSession.demo();
      await tester.pumpWidget(_app(session));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.syncNowCta));
      await tester.pumpAndSettle();

      expect(session.pendingEntryCount, 0);
      expect(find.text(en.chipSynced), findsOneWidget);
      expect(find.text(en.syncSending(1)), findsNothing);
      expect(find.text(en.syncStatusSending), findsNothing);
    });
  });
}
