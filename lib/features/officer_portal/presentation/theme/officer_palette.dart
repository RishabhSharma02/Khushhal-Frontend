/// The Officer Portal's own brand palette — "soft-sage Khet & Khadi".
///
/// Deliberately separate from [AppPalette]/[KhushhalColors]: the design
/// names a distinct scheme from the consumer app's "First light" greens, one
/// persona per palette.
library;

import 'package:flutter/material.dart';

/// Immutable "Khet & Khadi" color tokens, lifted from the hi-fi mocks.
abstract final class OfficerPalette {
  /// The canvas behind every screen.
  static const Color background = Color(0xFFDDD9CE);

  /// The frame background inside the canvas (behind the rail and cards).
  static const Color windowSurface = Color(0xFFEAE7DE);

  /// White card surfaces.
  static const Color card = Color(0xFFFFFFFF);

  /// Soft inset surfaces inside a card (e.g. stat tiles).
  static const Color soft = Color(0xFFF6F4EE);

  /// Primary text ink.
  static const Color ink = Color(0xFF22271F);

  /// Secondary / muted text.
  static const Color muted = Color(0xFF8A877A);

  /// A touch darker than [muted], for card body copy.
  static const Color body = Color(0xFF6B6A5F);

  /// Divider lines.
  static const Color line = Color(0xFFF0EBE0);

  /// Deep forest green — primary actions, active nav, links.
  static const Color forest = Color(0xFF1B5E43);

  /// Hover/active link shade.
  static const Color forestDark = Color(0xFF134631);

  /// Content on filled forest surfaces.
  static const Color onForest = Color(0xFFF6F1E7);

  /// Healthy / positive status green.
  static const Color statusGreen = Color(0xFF3E8E5A);

  /// Watch / warning status amber.
  static const Color statusAmber = Color(0xFFE8A13D);

  /// At-risk / negative status red.
  static const Color statusRed = Color(0xFFC0503C);

  /// Healthy chip background.
  static const Color chipGreenBg = Color(0xFFEAF3EC);

  /// Healthy chip text.
  static const Color chipGreenInk = Color(0xFF1B5E43);

  /// Watch chip background.
  static const Color chipAmberBg = Color(0xFFFDF6EA);

  /// Watch chip text.
  static const Color chipAmberInk = Color(0xFFB07514);

  /// At-risk chip background.
  static const Color chipRedBg = Color(0xFFFBEEE9);

  /// At-risk chip text.
  static const Color chipRedInk = Color(0xFFC0503C);

  /// Neutral chip background.
  static const Color chipNeutralBg = Color(0xFFF6F4EE);

  /// Neutral chip text.
  static const Color chipNeutralInk = Color(0xFF6B6A5F);

  /// A lighter forecast-bar tint of [statusGreen].
  static const Color forecastIn = Color(0xFF9CC4A8);

  /// A lighter forecast-bar tint for the OUT series.
  static const Color forecastOut = Color(0xFFE5E1D6);

  /// The recorded OUT bar tint.
  static const Color recordedOut = Color(0xFFDCD8CC);
}
