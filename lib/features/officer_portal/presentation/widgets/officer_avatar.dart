/// The initials-circle avatar (".av") used for people and icon wells.
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';

/// A filled circle showing either [text] (initials or an emoji icon) or
/// [imageAsset] (the app logo) — exactly one must be provided.
class OfficerAvatar extends StatelessWidget {
  /// Creates a text/emoji avatar.
  const OfficerAvatar({
    super.key,
    required this.text,
    this.size = 44,
    this.background = OfficerPalette.forest,
    this.foreground = OfficerPalette.onForest,
    this.fontSize,
  }) : imageAsset = null;

  /// Creates a logo avatar from an image asset.
  const OfficerAvatar.logo({
    super.key,
    required this.imageAsset,
    this.size = 44,
    this.background = OfficerPalette.forest,
  }) : text = null,
       foreground = OfficerPalette.onForest,
       fontSize = null;

  /// The initials or emoji to show.
  final String? text;

  /// The logo asset path to show instead of [text].
  final String? imageAsset;

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
    final String? asset = imageAsset;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: asset != null
          ? ClipOval(
              child: Image.asset(
                asset,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          : Text(
              text!,
              style: TextStyle(
                fontSize: fontSize ?? size * 0.4,
                fontWeight: FontWeight.w800,
                color: foreground,
              ),
            ),
    );
  }
}
