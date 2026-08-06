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

  // In-app shades from the "First light" scheme, shared by the screens after
  // onboarding (guided setup, home, history, settings and the money flows).

  /// Flat near-white canvas behind the main app screens.
  static const Color canvas = Color(0xFFF7FAF7);

  /// Strong text on white cards — titles and amounts.
  static const Color cardInk = Color(0xFF1C2B24);

  /// Body text one step darker than [muted].
  static const Color body = Color(0xFF44584C);

  /// Hints and metadata.
  static const Color hint = Color(0xFF7A8A7F);

  /// Fainter still — timestamps, fine print.
  static const Color faint = Color(0xFF9AA89E);

  /// Disabled / empty-state strokes and text.
  static const Color idle = Color(0xFFAFC4B3);

  /// Filled mint chip behind positive badges ("Synced", icon wells).
  static const Color mintChip = Color(0xFFE7F5EC);

  /// Background of the mint information note.
  static const Color mintNote = Color(0xFFEDF6EE);

  /// Border of the mint information note.
  static const Color mintNoteBorder = Color(0xFFD3E6D6);

  /// Ink inside the mint information note.
  static const Color mintNoteInk = Color(0xFF2E4A38);

  /// Outline of secondary pill buttons and chips.
  static const Color outline = Color(0xFFCFE0D2);

  /// Border of the "low risk" pill.
  static const Color riskLowBorder = Color(0xFFB6DEC0);

  /// Amber wash behind warnings ("November looks tight", offline notes).
  static const Color amberWash = Color(0xFFFCF6E7);

  /// Border of amber warning surfaces.
  static const Color amberBorder = Color(0xFFECD9A8);

  /// Strong amber text — warning titles.
  static const Color amberInk = Color(0xFF7A5A00);

  /// Muted amber text — warning body copy.
  static const Color amberMuted = Color(0xFF8A7A45);

  /// Amber accent — the highlighted forecast month.
  static const Color amberAccent = Color(0xFFB07C00);

  /// Money going out — expense amounts and the down arrow.
  static const Color expense = Color(0xFFA3541F);

  /// Destructive actions ("Log out").
  static const Color danger = Color(0xFFC0392B);

  /// Border around destructive actions.
  static const Color dangerBorder = Color(0xFFF5C5C5);
}
