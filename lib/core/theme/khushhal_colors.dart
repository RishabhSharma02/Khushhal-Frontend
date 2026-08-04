/// Custom theme tokens that sit outside Material [ColorScheme].
library;

import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Brand colors and CTA gradient, accessed via [ThemeExtension].
///
/// ```dart
/// final colors = Theme.of(context).extension<KhushhalColors>();
/// // or: context.khushhalColors
/// ```
@immutable
class KhushhalColors extends ThemeExtension<KhushhalColors> {
  /// Creates brand tokens for a theme brightness.
  const KhushhalColors({
    required this.forest,
    required this.leaf,
    required this.sprout,
    required this.mintWash,
    required this.ink,
    required this.muted,
    required this.line,
    required this.ctaGradient,
  });

  /// Deep forest green.
  final Color forest;

  /// Primary leaf green.
  final Color leaf;

  /// Bright sprout green.
  final Color sprout;

  /// Soft mint surface tint.
  final Color mintWash;

  /// Primary body text ink.
  final Color ink;

  /// Secondary / muted text.
  final Color muted;

  /// Dividers and borders.
  final Color line;

  /// CTA fill: 135° Leaf → Sprout.
  final LinearGradient ctaGradient;

  /// Tokens for light mode.
  static const KhushhalColors light = KhushhalColors(
    forest: AppPalette.forest,
    leaf: AppPalette.leaf,
    sprout: AppPalette.sprout,
    mintWash: AppPalette.mintWash,
    ink: AppPalette.ink,
    muted: AppPalette.muted,
    line: AppPalette.line,
    ctaGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppPalette.leaf, AppPalette.sprout],
    ),
  );

  /// Tokens for dark mode (same brand hues, darker surfaces).
  static const KhushhalColors dark = KhushhalColors(
    forest: AppPalette.forest,
    leaf: AppPalette.sprout,
    sprout: AppPalette.leaf,
    mintWash: Color(0xFF1A2E22),
    ink: AppPalette.mintWash,
    muted: Color(0xFF9AABA0),
    line: Color(0xFF2A4034),
    ctaGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppPalette.leaf, AppPalette.sprout],
    ),
  );

  @override
  KhushhalColors copyWith({
    Color? forest,
    Color? leaf,
    Color? sprout,
    Color? mintWash,
    Color? ink,
    Color? muted,
    Color? line,
    LinearGradient? ctaGradient,
  }) {
    return KhushhalColors(
      forest: forest ?? this.forest,
      leaf: leaf ?? this.leaf,
      sprout: sprout ?? this.sprout,
      mintWash: mintWash ?? this.mintWash,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      ctaGradient: ctaGradient ?? this.ctaGradient,
    );
  }

  @override
  KhushhalColors lerp(ThemeExtension<KhushhalColors>? other, double t) {
    if (other is! KhushhalColors) {
      return this;
    }

    return KhushhalColors(
      forest: Color.lerp(forest, other.forest, t)!,
      leaf: Color.lerp(leaf, other.leaf, t)!,
      sprout: Color.lerp(sprout, other.sprout, t)!,
      mintWash: Color.lerp(mintWash, other.mintWash, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      ctaGradient: LinearGradient.lerp(ctaGradient, other.ctaGradient, t)!,
    );
  }
}

/// Convenient access to [KhushhalColors] from a [BuildContext].
extension KhushhalColorsX on BuildContext {
  /// Brand tokens for the current theme.
  ///
  /// Falls back to [KhushhalColors.light] if the extension is missing.
  KhushhalColors get khushhalColors {
    return Theme.of(this).extension<KhushhalColors>() ?? KhushhalColors.light;
  }
}
