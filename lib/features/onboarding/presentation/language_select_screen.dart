/// Design 1a — Step 1 · Language select.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/app_language.dart';
import '../domain/usp_slide.dart' show OnboardingAssets;
import 'onboarding_palette.dart';
import '../../../core/widgets/gradient_cta_button.dart';
import 'widgets/language_option_card.dart';
import 'widgets/onboarding_backdrop.dart';

/// First-run screen: brand mark, then a choice between the launch languages.
///
/// Tapping a card switches the app locale immediately, so the whole screen
/// re-renders in that language — no side-by-side translations. Only the card
/// titles stay in their own script, so either reader can find their row.
class LanguageSelectScreen extends StatelessWidget {
  /// Creates the language select screen.
  const LanguageSelectScreen({
    super.key,
    required this.selected,
    required this.onLanguageSelected,
    required this.onContinue,
  });

  /// The language currently on screen.
  final AppLanguage selected;

  /// Called when a language card is tapped.
  final ValueChanged<AppLanguage> onLanguageSelected;

  /// Called when the user confirms the choice.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: OnboardingBackdrop(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 28),
                    _BrandMark(l10n: l10n),
                    const SizedBox(height: 30),
                    Text(
                      l10n.languageHeading,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.languageSubheading,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: OnboardingPalette.subheading,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final AppLanguage language in AppLanguage.values) ...[
                      if (language != AppLanguage.values.first)
                        const SizedBox(height: 12),
                      LanguageOptionCard(
                        language: language,
                        selected: language == selected,
                        onTap: () => onLanguageSelected(language),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      l10n.languageMoreComingSoon,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: OnboardingPalette.hint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GradientCtaButton(
              label: l10n.languageContinue,
              onPressed: onContinue,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.languageOfflineFootnote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: AppPalette.muted,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

/// Logo, wordmark and tagline block at the top of design 1a.
class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppPalette.onPrimary,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              // 0 12px 26px -14px rgba(23,82,53,.4)
              BoxShadow(
                color: AppPalette.forest.withValues(alpha: 0.4),
                offset: const Offset(0, 12),
                blurRadius: 20,
                spreadRadius: -14,
              ),
            ],
          ),
          child: ClipOval(
            // The upload is a centred mark on a wide margin; the design crops
            // into it so the sprout fills the circle.
            child: Transform.scale(
              scale: 2.1,
              child: Image.asset(
                OnboardingAssets.logo,
                fit: BoxFit.cover,
                semanticLabel: l10n.brandName,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.brandName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.12,
            height: 1.2,
            color: AppPalette.ink,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          l10n.brandTagline,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.35,
            color: OnboardingPalette.tagline,
          ),
        ),
      ],
    );
  }
}
