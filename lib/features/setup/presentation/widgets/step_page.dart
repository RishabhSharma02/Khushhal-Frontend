/// Shared skeleton for one setup step: header, scrollable body, pinned CTA.
library;

import 'package:flutter/material.dart';

/// Lays a step out so the call to action never scrolls away.
///
/// The body scrolls when large text outgrows a small screen; the header, the
/// CTA and any footer under it stay pinned, matching how the mocks anchor
/// the button above the home indicator.
class StepPage extends StatelessWidget {
  /// Creates a step page.
  const StepPage({
    super.key,
    required this.header,
    required this.children,
    required this.cta,
    this.footer,
  });

  /// Progress header row, pinned on top.
  final Widget header;

  /// Scrollable step content.
  final List<Widget> children;

  /// Primary action, pinned at the bottom.
  final Widget cta;

  /// Optional line under the CTA (the hub's finish hint).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(top: 4), child: header),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 6),
        cta,
        ?footer,
      ],
    );
  }
}
