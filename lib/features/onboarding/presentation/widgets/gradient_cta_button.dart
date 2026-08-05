/// The full-width gradient action button used across the entry flow.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Primary call to action — 135° Leaf → Sprout, 18px radius, 18px label.
///
/// Carries "Continue" on 1a and again under the USP carousel on 1b–1e. The
/// label is the word on its own: the design mocks trail it with an arrow, but
/// a full-width green button already reads as forward.
///
/// Settles slightly under the finger while pressed and springs back on
/// release, so the one tappable thing on these screens visibly answers the
/// touch.
class GradientCtaButton extends StatefulWidget {
  /// Creates the primary action button.
  const GradientCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// Button text.
  final String label;

  /// Called on tap.
  final VoidCallback onPressed;

  @override
  State<GradientCtaButton> createState() => _GradientCtaButtonState();
}

class _GradientCtaButtonState extends State<GradientCtaButton> {
  static const BorderRadius _radius = BorderRadius.all(Radius.circular(18));

  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (mounted && _pressed != pressed) {
      setState(() => _pressed = pressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final KhushhalColors colors = context.khushhalColors;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: colors.ctaGradient,
            borderRadius: _radius,
            boxShadow: <BoxShadow>[
              // 0 14px 30px -14px rgba(31,122,69,.55)
              BoxShadow(
                color: AppPalette.leaf.withValues(alpha: 0.55),
                offset: const Offset(0, 14),
                blurRadius: 24,
                spreadRadius: -14,
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onPressed,
            onTapDown: (TapDownDetails _) => _setPressed(true),
            onTapUp: (TapUpDetails _) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            borderRadius: _radius,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.onPrimary,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
