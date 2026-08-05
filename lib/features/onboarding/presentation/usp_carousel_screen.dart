/// Designs 1b–1e — Steps 2–5 · the four USP slides.
library;

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/usp_slide.dart';
import 'widgets/gradient_cta_button.dart';
import 'widgets/onboarding_backdrop.dart';
import 'widgets/usp_carousel.dart';

/// The USP pitch: a carousel that plays itself, over a single Continue.
///
/// The four cards scroll on their own and loop, so the pitch arrives without
/// the user having to discover a swipe or work through a Next button — reading
/// is the only thing asked of them. Continue sits below the strip the whole
/// time and is the one way forward, so leaving stays a deliberate tap no
/// matter which card happens to be showing.
class UspCarouselScreen extends StatelessWidget {
  /// Creates the USP carousel screen.
  const UspCarouselScreen({
    super.key,
    required this.onFinished,
    this.slideDuration = const Duration(seconds: 4),
  });

  /// Called when the user taps Continue.
  final VoidCallback onFinished;

  /// How long each card is held before the carousel scrolls to the next.
  final Duration slideDuration;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: OnboardingBackdrop(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: UspCarousel(
                slides: UspSlide.all(l10n),
                slideDuration: slideDuration,
              ),
            ),
            const SizedBox(height: 24),
            GradientCtaButton(
              label: l10n.onboardingContinue,
              onPressed: onFinished,
            ),
          ],
        ),
      ),
    );
  }
}
