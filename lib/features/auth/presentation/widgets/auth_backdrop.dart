import 'package:flutter/material.dart';

/// Shared background for the login / OTP / mPIN screens.
///
/// Matches the design import: 180° gradient from a soft green wash at the
/// top through mint into pure white at the bottom, with the child scrolled
/// in a SafeArea so the notch and home indicator don't collide with copy.
class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key, required this.child});
  final Widget child;

  static const gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3F1E3), Color(0xFFF4FAF3), Color(0xFFFFFFFF)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: gradient),
      child: SafeArea(child: child),
    );
  }
}
