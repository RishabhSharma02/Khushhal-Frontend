/// The outlined companion to `GradientCtaButton`.
library;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Full-width outlined action — white fill, forest border and label.
///
/// Used where the action is available but not the screen's push: "Talk to
/// field officer" (1r, 1s), "Sync now" (1w), and the hub's "Finish" while it
/// is still locked (1j).
class SecondaryCtaButton extends StatelessWidget {
  /// Creates the outlined action button.
  const SecondaryCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  });

  /// Button text.
  final String label;

  /// Called on tap; ignored while disabled.
  final VoidCallback onPressed;

  /// Optional icon before the label.
  final IconData? icon;

  /// False greys the button out (1j's Finish before any business is done).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color foreground = enabled
        ? AppPalette.forest
        : const Color(0xFF9AB0A0);

    return Material(
      color: AppPalette.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: enabled ? AppPalette.forest : AppPalette.outline,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: 9),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
