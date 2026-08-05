/// Surface tints specific to the entry flow (designs 1a–1e).
///
/// These are screen-level shades from the "First light" scheme rather than
/// brand tokens, so they live with the feature instead of in [AppPalette].
library;

import 'package:flutter/material.dart';

/// Entry-flow shades, taken from the design's inline styles.
abstract final class OnboardingPalette {
  /// Screen backdrop — mint at the top fading to white.
  static const LinearGradient backdrop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFE3F1E3), Color(0xFFF4FAF3), Color(0xFFFFFFFF)],
    stops: <double>[0, 0.45, 1],
  );

  /// Fill behind a selected language card — 135° Forest → Leaf.
  static const LinearGradient selectedCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF175235), Color(0xFF1F7A45)],
  );

  /// Default body text on the entry screens.
  static const Color body = Color(0xFF152F21);

  /// Tagline under the wordmark.
  static const Color tagline = Color(0xFF5E7A68);

  /// Secondary heading and the "Skip" action.
  static const Color subheading = Color(0xFF4E6B58);

  /// Language name on an unselected card.
  static const Color cardTitle = Color(0xFF1C2B24);

  /// Outline of an unselected radio dot.
  static const Color radioOutline = Color(0xFFAFC4B3);

  /// The "more languages coming soon" line.
  static const Color hint = Color(0xFF7A8A7F);

  /// Body copy on the USP slides.
  static const Color uspBody = Color(0xFF44584C);

  /// An inactive carousel dot.
  static const Color dotInactive = Color(0xFFC4D8C8);
}
