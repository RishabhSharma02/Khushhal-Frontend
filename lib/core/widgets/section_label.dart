/// Tiny upper-case section headers ("MY BUSINESSES", "WAITING TO SEND").
library;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Letter-spaced 11px label above a group of cards.
class SectionLabel extends StatelessWidget {
  /// Creates a section label.
  const SectionLabel(this.text, {super.key});

  /// Label text; rendered upper-case (Devanagari has no case and passes
  /// through unchanged).
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.9,
        color: AppPalette.hint,
        height: 1.2,
      ),
    );
  }
}
