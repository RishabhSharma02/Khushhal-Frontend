/// Shared page frame for every screen after onboarding.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

/// The screen's canvas: mint-to-white gradient during guided setup, flat
/// near-white once the app proper starts (home, tabs and their subscreens).
///
/// The design mocks draw a phone status bar and home indicator; those are
/// the platform's own chrome, so this uses [SafeArea] instead of redrawing
/// them. Edge padding matches the mocks' 22px sides.
class PageBackdrop extends StatelessWidget {
  /// Creates the frame around [child].
  const PageBackdrop({super.key, required this.child, this.gradient = false});

  /// Screen content, laid out inside the safe area.
  final Widget child;

  /// True for the setup-flow mint gradient; false for the flat canvas.
  final bool gradient;

  /// The guided-setup backdrop, identical to onboarding's.
  static const LinearGradient setupGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFE3F1E3), Color(0xFFF4FAF3), Color(0xFFFFFFFF)],
    stops: <double>[0, 0.45, 1],
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: DecoratedBox(
        decoration: gradient
            ? const BoxDecoration(gradient: setupGradient)
            : const BoxDecoration(color: AppPalette.canvas),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
            child: child,
          ),
        ),
      ),
    );
  }
}
