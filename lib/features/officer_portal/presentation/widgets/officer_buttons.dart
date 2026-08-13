/// The two button styles used across the Officer Portal (".btnp"/".btno").
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';

/// A filled forest-green CTA — the mocks' ".btnp".
class OfficerPrimaryButton extends StatelessWidget {
  /// Creates a primary button.
  const OfficerPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.destructive = false,
    this.expand = true,
  });

  /// The button's label.
  final String label;

  /// Called on tap; `null` disables the button.
  final VoidCallback? onPressed;

  /// Renders in [OfficerPalette.statusRed] for destructive actions
  /// ("Log out").
  final bool destructive;

  /// Whether the button fills its parent's width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Widget button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: destructive
            ? OfficerPalette.statusRed
            : OfficerPalette.forest,
        foregroundColor: OfficerPalette.onForest,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// An outlined forest-green button — the mocks' ".btno".
class OfficerSecondaryButton extends StatelessWidget {
  /// Creates a secondary button.
  const OfficerSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = false,
  });

  /// The button's label.
  final String label;

  /// Called on tap; `null` disables the button.
  final VoidCallback? onPressed;

  /// Whether the button fills its parent's width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Widget button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: OfficerPalette.forest,
        side: const BorderSide(color: OfficerPalette.forest, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
