/// The "Step x of 5" line with progress dots (1h–1m).
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Step label on the left, five 8px dots on the right, filled up to the
/// current step.
class SetupProgressHeader extends StatelessWidget {
  /// Creates the header for [label] with [filled] of [total] dots lit.
  const SetupProgressHeader({
    super.key,
    required this.label,
    required this.filled,
    this.total = 5,
    this.showBack = true,
  });

  /// The localized "Step x of 5" (optionally with the business name).
  final String label;

  /// Dots lit, counting from the left.
  final int filled;

  /// Dots in the row.
  final int total;

  /// Whether to render the top-left back arrow. Step 1 (LocationStep)
  /// hides it — there's nowhere to go back to and the user shouldn't be
  /// able to bail out of the flow at the entry point.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Back arrow — hosting SetupFlow wraps itself in a PopScope that
        // intercepts pops and reroutes them through its stepwise `_back()`
        // handler. `maybePop` is what we want here — it triggers PopScope's
        // callback, which decides between "go one step back" and "pop the
        // whole route" (that final pop is a `Navigator.pop`, which bypasses
        // PopScope's block).
        if (showBack)
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: AppPalette.forest,
              ),
            ),
          )
        else
          const SizedBox(width: 4),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppPalette.muted,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Row(
          children: <Widget>[
            for (int i = 0; i < total; i++)
              Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < filled
                        ? AppPalette.leaf
                        : const Color(0xFFC4D8C8),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
