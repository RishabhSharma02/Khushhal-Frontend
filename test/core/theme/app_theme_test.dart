import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/core/theme/theme.dart';

void main() {
  group('KhushhalColors', () {
    test('light tokens match brand palette', () {
      const KhushhalColors colors = KhushhalColors.light;

      expect(colors.forest, AppPalette.forest);
      expect(colors.leaf, AppPalette.leaf);
      expect(colors.sprout, AppPalette.sprout);
      expect(colors.mintWash, AppPalette.mintWash);
      expect(colors.ink, AppPalette.ink);
      expect(colors.muted, AppPalette.muted);
      expect(colors.line, AppPalette.line);
    });

    test('copyWith overrides only provided fields', () {
      final KhushhalColors updated = KhushhalColors.light.copyWith(
        leaf: const Color(0xFF000000),
      );

      expect(updated.leaf, const Color(0xFF000000));
      expect(updated.forest, AppPalette.forest);
    });

    test('lerp blends toward other at t = 1', () {
      final KhushhalColors lerped = KhushhalColors.light.lerp(
        KhushhalColors.dark,
        1,
      );

      expect(lerped.leaf, KhushhalColors.dark.leaf);
      expect(lerped.ink, KhushhalColors.dark.ink);
    });
  });

  group('AppTheme', () {
    testWidgets('light theme registers KhushhalColors extension', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (BuildContext context) {
              final KhushhalColors colors = context.khushhalColors;
              return Text(colors.leaf.toString());
            },
          ),
        ),
      );

      expect(find.text(AppPalette.leaf.toString()), findsOneWidget);
    });

    test('light and dark expose Material 3 color schemes', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.brightness, Brightness.light);
      expect(AppTheme.dark.brightness, Brightness.dark);
      expect(AppTheme.light.colorScheme.primary, AppPalette.leaf);
      expect(AppTheme.dark.colorScheme.primary, AppPalette.sprout);
    });
  });
}
