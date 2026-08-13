/// The initials-circle avatar (".av") used for people and icon wells.
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';

/// A filled circle showing [text] (initials or an emoji icon).
class OfficerAvatar extends StatelessWidget {
  /// Creates an avatar.
  const OfficerAvatar({
    super.key,
    required this.text,
    this.size = 44,
    this.background = OfficerPalette.forest,
    this.foreground = OfficerPalette.onForest,
    this.fontSize,
  });

  /// The initials or emoji to show.
  final String text;

  /// Diameter in logical pixels.
  final double size;

  /// Fill color.
  final Color background;

  /// Text color.
  final Color foreground;

  /// Overrides the default proportional font size.
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? size * 0.4,
          fontWeight: FontWeight.w800,
          color: foreground,
        ),
      ),
    );
  }
}
