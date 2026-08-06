/// The white card every in-app surface is built from.
library;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// White panel with the hairline mint border and the barely-there forest
/// shadow from the mocks (`0 1px 2px rgba(20,60,35,.04)`).
///
/// [highlighted] swaps the border to forest — the mocks use that to mark the
/// focused or primary card of a screen (active input, first business, the
/// synced-total strip).
class KhushhalCard extends StatelessWidget {
  /// Creates a card.
  const KhushhalCard({
    super.key,
    required this.child,
    this.radius = 16,
    this.padding = const EdgeInsets.all(14),
    this.highlighted = false,
    this.onTap,
  });

  /// Card contents.
  final Widget child;

  /// Corner radius — the mocks use 14 to 20 depending on the card's weight.
  final double radius;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// True for the forest border treatment.
  final bool highlighted;

  /// Makes the whole card tappable when set.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(
        color: highlighted ? AppPalette.forest : AppPalette.line,
        width: 1.5,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A143C23),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: AppPalette.onPrimary,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
