/// Typography: Lexend + Noto Sans Devanagari.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds the app [TextTheme] with Lexend and Devanagari fallback.
abstract final class AppTypography {
  /// Material 3 type scale using Lexend, with Noto Sans Devanagari
  /// as [TextStyle.fontFamilyFallback] for Hindi glyphs.
  static TextTheme textTheme({
    required Color bodyColor,
    required Color displayColor,
    required Color mutedColor,
  }) {
    final String? devanagari = GoogleFonts.notoSansDevanagari().fontFamily;
    final List<String> fallback = [?devanagari];

    final TextTheme base = GoogleFonts.lexendTextTheme().apply(
      bodyColor: bodyColor,
      displayColor: displayColor,
      fontFamilyFallback: fallback,
    );

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: mutedColor,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: mutedColor,
      ),
    );
  }
}
