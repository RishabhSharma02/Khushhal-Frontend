/// Artwork slot on the USP slides (designs 1b–1e).
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../onboarding_palette.dart';

/// The 28px-radius artwork panel at the top of a USP slide.
///
/// Mirrors the design's `<image-slot>`. The slide artwork is line drawing on
/// its own white ground, so the panel is white too and the two read as one
/// card on the mint backdrop. The drawing is fitted whole rather than filled:
/// these illustrations carry meaning out to their edges — a sun, a calendar, a
/// crossed-out signal — and cropping would take it away.
///
/// When the asset is not in the bundle it renders a labelled placeholder
/// rather than failing, so the flow stays runnable while artwork is still
/// being produced.
class UspIllustration extends StatelessWidget {
  /// Creates an artwork panel for [assetPath].
  const UspIllustration({
    super.key,
    required this.assetPath,
    required this.description,
  });

  /// Asset path of the slide artwork.
  final String assetPath;

  /// Human description of the artwork, used for accessibility and as the
  /// placeholder caption.
  final String description;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(28));

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.onPrimary,
        borderRadius: _radius,
        border: Border.all(color: AppPalette.line),
        boxShadow: <BoxShadow>[
          // Just enough lift to hold the panel off the mint backdrop.
          BoxShadow(
            color: AppPalette.forest.withValues(alpha: 0.10),
            offset: const Offset(0, 10),
            blurRadius: 24,
            spreadRadius: -12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: _radius,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Image.asset(
                assetPath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                // Decoded at the size it is drawn at. The artwork ships far
                // larger than any phone shows it, and these are the users
                // least able to spare the memory.
                cacheWidth:
                    (constraints.maxWidth *
                            MediaQuery.devicePixelRatioOf(context))
                        .round(),
                semanticLabel: description,
                errorBuilder:
                    (BuildContext context, Object error, StackTrace? stack) {
                      return _MissingArtwork(description: description);
                    },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Stand-in shown when a slide's artwork asset is absent.
class _MissingArtwork extends StatelessWidget {
  const _MissingArtwork({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    // Sits inside the panel, so it only has to fill it — the rounding, edge
    // and lift come from the panel itself.
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppPalette.mintWash),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.image_outlined,
                size: 40,
                color: OnboardingPalette.radioOutline,
              ),
              const SizedBox(height: 12),
              // The caption gives way rather than overrunning the slot: this
              // stands in for a picture, so it must not push the layout around
              // at large text sizes.
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: OnboardingPalette.hint,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
