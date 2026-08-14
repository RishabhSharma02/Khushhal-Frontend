/// The labeled field row used on every form (auth screens, add visit).
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';

/// A form field: a small uppercase [label] above a soft-filled input.
class LabeledField extends StatelessWidget {
  /// Creates a labeled text field.
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.trailing,
    this.helperText,
    this.maxLines = 1,
    this.validator,
  });

  /// The small caption above the field, e.g. "EMAIL".
  final String label;

  /// The field's controller.
  final TextEditingController controller;

  /// Placeholder shown when empty.
  final String? hintText;

  /// Whether to mask input (password fields).
  final bool obscureText;

  /// The keyboard type to show.
  final TextInputType? keyboardType;

  /// An optional trailing widget, e.g. a "verified" chip or reveal icon.
  final Widget? trailing;

  /// Small helper copy under the field.
  final String? helperText;

  /// Number of lines — >1 for the agenda/notes textarea.
  final int maxLines;

  /// Optional form validation.
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 2),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: OfficerPalette.muted,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: OfficerPalette.ink),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: trailing == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: trailing,
                  ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(
              helperText!,
              style: const TextStyle(
                fontSize: 10.5,
                color: OfficerPalette.muted,
              ),
            ),
          ),
      ],
    );
  }
}

/// A read-only version of [LabeledField] — used for display-only rows like
/// the Add-visit dialog's date/time pickers.
class LabeledDisplayField extends StatelessWidget {
  /// Creates a read-only labeled field.
  const LabeledDisplayField({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });

  /// The small caption above the field.
  final String label;

  /// The value shown inside the field.
  final String value;

  /// Called when the field is tapped (e.g. to open a date picker).
  final VoidCallback? onTap;

  /// An optional trailing widget.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 2),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: OfficerPalette.muted,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: OfficerPalette.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: OfficerPalette.ink,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
