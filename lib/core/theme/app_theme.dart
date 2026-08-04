/// Centralized [ThemeData] for Khushhal (light + dark).
library;

import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_typography.dart';
import 'khushhal_colors.dart';

/// Builds Material 3 light and dark themes from the brand palette.
abstract final class AppTheme {
  /// Light theme — Mint wash surfaces, Leaf primary.
  static ThemeData get light => _build(
    brightness: Brightness.light,
    brand: KhushhalColors.light,
    colorScheme: _lightColorScheme,
  );

  /// Dark theme — Forest/Ink surfaces, Sprout primary.
  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    brand: KhushhalColors.dark,
    colorScheme: _darkColorScheme,
  );

  static ColorScheme get _lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppPalette.leaf,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppPalette.leaf,
      onPrimary: AppPalette.onPrimary,
      primaryContainer: AppPalette.forest,
      onPrimaryContainer: AppPalette.onPrimary,
      secondary: AppPalette.sprout,
      onSecondary: AppPalette.onPrimary,
      secondaryContainer: AppPalette.mintWash,
      onSecondaryContainer: AppPalette.ink,
      surface: AppPalette.mintWash,
      onSurface: AppPalette.ink,
      onSurfaceVariant: AppPalette.muted,
      outline: AppPalette.line,
      outlineVariant: AppPalette.line,
    );
  }

  static ColorScheme get _darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppPalette.leaf,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppPalette.sprout,
      onPrimary: AppPalette.ink,
      primaryContainer: AppPalette.forest,
      onPrimaryContainer: AppPalette.mintWash,
      secondary: AppPalette.leaf,
      onSecondary: AppPalette.onPrimary,
      surface: AppPalette.ink,
      onSurface: AppPalette.mintWash,
      onSurfaceVariant: const Color(0xFF9AABA0),
      outline: const Color(0xFF2A4034),
      outlineVariant: const Color(0xFF2A4034),
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required KhushhalColors brand,
    required ColorScheme colorScheme,
  }) {
    final TextTheme textTheme = AppTypography.textTheme(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      mutedColor: colorScheme.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[brand],
      appBarTheme: _appBarTheme(colorScheme, textTheme, brand),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme, textTheme),
      filledButtonTheme: _filledButtonTheme(colorScheme, textTheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme, textTheme),
      textButtonTheme: _textButtonTheme(colorScheme, textTheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: _inputDecorationTheme(colorScheme, textTheme),
      chipTheme: _chipTheme(colorScheme, textTheme),
      cardTheme: _cardTheme(colorScheme),
    );
  }

  static AppBarTheme _appBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    KhushhalColors brand,
  ) {
    return AppBarTheme(
      backgroundColor: brand.forest,
      foregroundColor: AppPalette.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: AppPalette.onPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.pressed)) {
            return AppPalette.forest;
          }
          return colorScheme.primary;
        }),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStatePropertyAll(
          textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  static FloatingActionButtonThemeData _fabTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 2,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.brightness == Brightness.light
          ? AppPalette.onPrimary
          : colorScheme.surfaceContainerHighest,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: baseBorder.copyWith(
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );
  }

  static ChipThemeData _chipTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ChipThemeData(
      backgroundColor: colorScheme.secondaryContainer,
      selectedColor: colorScheme.secondary,
      labelStyle: textTheme.labelMedium,
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.brightness == Brightness.light
          ? AppPalette.onPrimary
          : colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline),
      ),
    );
  }
}
