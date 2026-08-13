/// The white rounded card surface used across every Officer Portal screen.
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';

/// A plain white card with the portal's standard radius and padding.
class OfficerCard extends StatelessWidget {
  /// Creates a card.
  const OfficerCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = OfficerPalette.card,
    this.outlined = false,
  });

  /// The card's contents.
  final Widget child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Background color — defaults to white, but 5f/5b use tinted variants.
  final Color color;

  /// Whether to draw the "next up" forest outline (5d's outlined row).
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: outlined
            ? Border.all(color: OfficerPalette.forest, width: 1.5)
            : null,
      ),
      child: child,
    );
  }
}

/// A soft inset surface used for stat tiles inside a card.
class OfficerSoftTile extends StatelessWidget {
  /// Creates a soft tile.
  const OfficerSoftTile({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  /// The tile's contents.
  final Widget child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: OfficerPalette.soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
