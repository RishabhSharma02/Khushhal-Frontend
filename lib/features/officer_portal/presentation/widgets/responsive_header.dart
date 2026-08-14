/// A screen-title row that stacks its action buttons below the title once
/// there isn't room to sit beside it (used by Enterprises, Visits, Reports,
/// Data sync).
library;

import 'package:flutter/material.dart';

/// Lays [title] and [actions] out in a row when there's room, or a column
/// when there isn't — the fix for a `Row(children: [title, Spacer(),
/// ...actions])` overflowing on narrow screens.
class ResponsiveHeader extends StatelessWidget {
  /// Creates a responsive header.
  const ResponsiveHeader({super.key, required this.title, required this.actions});

  /// The heading widget (usually a title + subtitle column).
  final Widget title;

  /// Trailing action buttons/chips.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 640) {
          return Row(
            children: <Widget>[
              Expanded(child: title),
              const SizedBox(width: 14),
              Wrap(spacing: 8, runSpacing: 8, children: actions),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title,
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        );
      },
    );
  }
}
