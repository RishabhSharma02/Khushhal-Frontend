/// The rail + scrollable-content frame shared by every shell screen.
library;

import 'package:flutter/material.dart';

import '../theme/officer_palette.dart';
import 'officer_nav_rail.dart';

/// Wraps a screen's content with the left [OfficerNavRail] and the mocks'
/// rounded "window" frame, scrolling the main column.
class OfficerShellScaffold extends StatelessWidget {
  /// Creates the shell frame.
  const OfficerShellScaffold({
    super.key,
    required this.section,
    required this.onSectionSelected,
    required this.children,
  });

  /// The section this screen represents, for rail highlighting.
  final OfficerSection section;

  /// Called when a different rail section is tapped.
  final ValueChanged<OfficerSection> onSectionSelected;

  /// The screen's content, laid out top-to-bottom with standard spacing.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OfficerPalette.windowSurface,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Stuck flush to the left edge, full height — not a floating
          // inset pill.
          OfficerNavRail(current: section, onSelected: onSectionSelected),
          Expanded(
            child: SafeArea(
              left: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (final Widget child in children) ...<Widget>[
                        child,
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
