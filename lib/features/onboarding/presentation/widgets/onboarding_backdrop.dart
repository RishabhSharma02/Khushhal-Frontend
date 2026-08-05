/// Shared page frame for the entry flow.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../onboarding_palette.dart';

/// The mint-to-white backdrop and edge padding shared by designs 1a–1e.
///
/// The design mocks draw a phone status bar and home indicator; those are the
/// platform's own chrome, so this uses [SafeArea] instead of redrawing them.
class OnboardingBackdrop extends StatelessWidget {
  /// Wraps [child] in the entry-flow backdrop.
  const OnboardingBackdrop({super.key, required this.child});

  /// Screen content, laid out inside the safe area.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: OnboardingPalette.backdrop),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: OnboardingPalette.body),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
