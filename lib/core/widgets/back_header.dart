/// The "← Title" header row on pushed screens.
library;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Back arrow, screen title, and an optional trailing widget (a chip on most
/// screens).
///
/// Pops the route by default. This is the one place an arrow glyph is right:
/// it points somewhere, it is not decoration on a label.
class BackHeader extends StatelessWidget {
  /// Creates the header.
  const BackHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onBack,
  });

  /// Screen title.
  final String title;

  /// Widget at the far end of the row.
  final Widget? trailing;

  /// Overrides the default `Navigator.pop`.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 22,
              color: AppPalette.forest,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppPalette.ink,
              height: 1.25,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
