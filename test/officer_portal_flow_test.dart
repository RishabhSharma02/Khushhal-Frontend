import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khushhal/features/officer_portal/presentation/officer_portal_root.dart';

void main() {
  Future<void> setSurface(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> signIn(WidgetTester tester) async {
    await tester.pumpWidget(const OfficerPortalRoot());
    await tester.tap(find.text('Sign in →'));
    await tester.pumpAndSettle();
  }

  for (final Size size in <Size>[const Size(1400, 900), const Size(390, 844)]) {
    final String sizeLabel = size.width > 1000 ? 'wide' : 'narrow';

    testWidgets('$sizeLabel: dashboard renders without overflow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      expect(find.text('Hello, Ramesh!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: enterprises list opens a detail screen', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.storefront_rounded));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Shanti Dairy').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('AI flag'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: visits screen renders without overflow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.event_note_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('logged'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: reports screen renders without overflow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.bar_chart_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('Reports —'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$sizeLabel: profile and logout flow', (
      WidgetTester tester,
    ) async {
      await setSurface(tester, size);
      await signIn(tester);

      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();
      expect(find.text('My profile'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Log out ▸').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out ▸').first);
      await tester.pumpAndSettle();
      expect(find.text('Log out of KHUSH-HAL?'), findsOneWidget);

      await tester.tap(find.text('Log out ▸').last);
      await tester.pumpAndSettle();
      expect(find.text("You're signed out"), findsOneWidget);

      await tester.tap(find.text('Sign in again →'));
      await tester.pumpAndSettle();
      expect(find.text("KHUSH-HAL Officers' Portal"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('add-visit dialog records a new visit', (
    WidgetTester tester,
  ) async {
    await setSurface(tester, const Size(1400, 900));
    await signIn(tester);

    await tester.tap(find.text('+ Log visit'));
    await tester.pumpAndSettle();
    expect(find.text('Log visit'), findsOneWidget);

    await tester.tap(find.text('🔍 Search enterprise…'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lakshmi Foods'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log visit ✓'));
    await tester.pumpAndSettle();
    expect(find.text('Visit logged'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Back to visits'));
    await tester.pumpAndSettle();
  });
}
