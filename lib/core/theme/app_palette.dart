/// Brand color constants for Khushhal.
///
/// These are the fixed design tokens. Prefer reading runtime colors via
/// [KhushhalColors] from [ThemeData.extensions] so light/dark themes work.
library;

import 'package:flutter/material.dart';

/// Immutable brand palette (Forest / Leaf / Sprout system).
abstract final class AppPalette {
  /// Deep forest green — app bars, strong emphasis.
  static const Color forest = Color(0xFF175235);

  /// Primary leaf green — CTAs, primary actions.
  static const Color leaf = Color(0xFF1F7A45);

  /// Bright sprout green — secondary / accent.
  static const Color sprout = Color(0xFF2F9E5F);

  /// Soft mint wash — light surfaces and backgrounds.
  static const Color mintWash = Color(0xFFE3F1E3);

  /// Near-black ink — primary text on light surfaces.
  static const Color ink = Color(0xFF123B27);

  /// Muted gray-green — secondary / hint text.
  static const Color muted = Color(0xFF5C6B62);

  /// Subtle line / divider color.
  static const Color line = Color(0xFFDFEADF);

  /// Content on filled primary surfaces.
  static const Color onPrimary = Color(0xFFFFFFFF);
}
