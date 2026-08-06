/// Rounded selectable pills — filters, categories, chips-as-radio-buttons.
library;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A pill that is either the chosen one (forest fill, white text) or one of
/// the alternatives (white fill, mint border).
///
/// The whole app selects by tapping pills — categories on 1p, filters on
/// 1r/1v, tenure on 1l, what-ifs on 1q — so this carries the one visual
/// grammar for "picked" everywhere. [dashed] renders the softer dashed
/// border the mocks give to "Other" and to what-if chips.
class ChoicePill extends StatelessWidget {
  /// Creates a pill.
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.dashed = false,
  });

  /// Pill text.
  final String label;

  /// True renders the forest-filled state.
  final bool selected;

  /// Called on tap.
  final VoidCallback onTap;

  /// Softer dashed-border look for open-ended options.
  ///
  /// Flutter has no dashed [BorderSide]; the mocks' dashes read as "less
  /// settled than the others", which a lighter solid border also says.
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final Color border = selected
        ? AppPalette.forest
        : dashed
        ? const Color(0xFFC9D8CC)
        : AppPalette.line;

    return Material(
      color: selected ? AppPalette.forest : AppPalette.onPrimary,
      shape: StadiumBorder(side: BorderSide(color: border, width: 1.5)),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? AppPalette.onPrimary
                  : dashed
                  ? AppPalette.hint
                  : AppPalette.body,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
