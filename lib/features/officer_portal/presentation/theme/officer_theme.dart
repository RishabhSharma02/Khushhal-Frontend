/// The Officer Portal's [ThemeData], built from [OfficerPalette].
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'officer_palette.dart';

/// Centralised theme for every Officer Portal screen.
abstract final class OfficerTheme {
  /// The (only, for now) Officer Portal theme.
  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: OfficerPalette.forest,
      brightness: Brightness.light,
      primary: OfficerPalette.forest,
      surface: OfficerPalette.card,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: OfficerPalette.background,
      fontFamily: GoogleFonts.lexend().fontFamily,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          color: OfficerPalette.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: OfficerPalette.ink,
        ),
        bodyMedium: TextStyle(fontSize: 13, color: OfficerPalette.ink),
        bodySmall: TextStyle(fontSize: 12, color: OfficerPalette.muted),
      ),
      dividerColor: OfficerPalette.line,
      cardTheme: CardThemeData(
        color: OfficerPalette.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: OfficerPalette.ink,
        contentTextStyle: const TextStyle(
          fontSize: 13,
          color: OfficerPalette.card,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        width: 420,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OfficerPalette.soft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
