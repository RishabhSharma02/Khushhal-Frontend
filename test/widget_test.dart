import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/l10n/app_localizations_en.dart';
import 'package:khushhal/main.dart';

void main() {
  final AppLocalizationsEn en = AppLocalizationsEn();

  testWidgets('app opens on the language select screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text(en.languageHeading), findsOneWidget);
    expect(find.text(en.languageMoreComingSoon), findsOneWidget);
  });

  testWidgets('continuing from language select opens the USP carousel', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text(en.languageContinue));
    await tester.pumpAndSettle();

    expect(find.text(en.languageHeading), findsNothing);
    expect(find.text(en.uspForecastTitle), findsOneWidget);
  });
}
