/// The four USP slides shown after the language choice (designs 1b–1e).
library;

import 'package:flutter/foundation.dart';

import '../../../l10n/app_localizations.dart';

/// Image assets used by the entry flow.
abstract final class OnboardingAssets {
  /// Brand mark — sprout in an open palm.
  static const String logo = 'assets/images/khushhal_logo.jpg';

  /// USP 1 artwork — rising chart sprouting leaves.
  static const String uspForecast = 'assets/images/usp_forecast.png';

  /// USP 2 artwork — palm holding a card, icons around it.
  static const String uspOnePlace = 'assets/images/usp_one_place.png';

  /// USP 3 artwork — checklist with leaf ticks.
  static const String uspActions = 'assets/images/usp_actions.png';

  /// USP 4 artwork — phone with a sprout, no-signal calm.
  static const String uspOffline = 'assets/images/usp_offline.png';
}

/// One slide of the USP carousel, already resolved into the on-screen
/// language.
@immutable
class UspSlide {
  /// Creates a slide.
  const UspSlide({
    required this.title,
    required this.body,
    required this.imageAsset,
    required this.imageDescription,
  });

  /// Headline, centered above the body.
  final String title;

  /// Supporting sentence.
  final String body;

  /// Artwork asset path, one of [OnboardingAssets].
  final String imageAsset;

  /// Description of the artwork, used as its semantic label and as the
  /// placeholder caption while the asset is missing from the bundle.
  final String imageDescription;

  /// How many slides the carousel has — designs 1b, 1c, 1d and 1e.
  static const int count = 4;

  /// The four slides in order (1b → 1e), in the language of [l10n].
  static List<UspSlide> all(AppLocalizations l10n) {
    return <UspSlide>[
      UspSlide(
        title: l10n.uspForecastTitle,
        body: l10n.uspForecastBody,
        imageAsset: OnboardingAssets.uspForecast,
        imageDescription: l10n.uspForecastImage,
      ),
      UspSlide(
        title: l10n.uspOnePlaceTitle,
        body: l10n.uspOnePlaceBody,
        imageAsset: OnboardingAssets.uspOnePlace,
        imageDescription: l10n.uspOnePlaceImage,
      ),
      UspSlide(
        title: l10n.uspActionsTitle,
        body: l10n.uspActionsBody,
        imageAsset: OnboardingAssets.uspActions,
        imageDescription: l10n.uspActionsImage,
      ),
      UspSlide(
        title: l10n.uspOfflineTitle,
        body: l10n.uspOfflineBody,
        imageAsset: OnboardingAssets.uspOffline,
        imageDescription: l10n.uspOfflineImage,
      ),
    ];
  }
}
