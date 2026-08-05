/// Carousel position indicator for designs 1b–1e.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../onboarding_palette.dart';

/// Row of pill dots; the active one widens to 22px.
class PageDots extends StatelessWidget {
  /// Creates an indicator for [count] pages with [activeIndex] highlighted.
  const PageDots({super.key, required this.count, required this.activeIndex});

  /// Total number of pages.
  final int count;

  /// Zero-based index of the current page.
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: l10n.onboardingStepOf(activeIndex + 1, count),
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int index = 0; index < count; index++) ...<Widget>[
            if (index > 0) const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: index == activeIndex ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == activeIndex
                    ? AppPalette.leaf
                    : OnboardingPalette.dotInactive,
                borderRadius: const BorderRadius.all(Radius.circular(99)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
