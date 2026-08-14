import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/app/session.dart';
import 'package:khushhal/core/theme/theme.dart';
import 'package:khushhal/core/widgets/page_backdrop.dart';
import 'package:khushhal/features/entries/presentation/history_screen.dart';
import 'package:khushhal/l10n/app_localizations.dart';

Widget _history(AppSession session, {double textScale = 1}) {
  return SessionScope(
    session: session,
    child: MaterialApp(
      theme: AppTheme.light,
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
