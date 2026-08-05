/// A selectable language row on design 1a.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/app_language.dart';
import '../onboarding_palette.dart';

/// One language choice — name in-script, subtitle in the on-screen language,
/// radio on the right.
///
/// Sized for low digital literacy per the approved a11y pass: 21px language
/// name, 28px radio, and a row that clears the 44px minimum target.
class LanguageOptionCard extends StatelessWidget {
  /// Creates a language row.
  const LanguageOptionCard({
    super.key,
    required this.language,
    required this.selected,
    required this.onTap,
  });

  /// The language this row offers.
  final AppLanguage language;

  /// Whether this is the currently chosen language.
  final bool selected;

  /// Called when the row is tapped.
  final VoidCallback onTap;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(18));

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String subtitle = language.subtitle(l10n);

    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      label: '${language.endonym}, $subtitle',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? null : AppPalette.onPrimary,
            gradient: selected ? OnboardingPalette.selectedCard : null,
            border: Border.all(
              color: selected ? AppPalette.forest : AppPalette.line,
              width: 1.5,
            ),
            borderRadius: _radius,
            boxShadow: <BoxShadow>[
              if (selected)
                // 0 12px 26px -14px rgba(23,82,53,.55)
                BoxShadow(
                  color: AppPalette.forest.withValues(alpha: 0.55),
                  offset: const Offset(0, 12),
                  blurRadius: 20,
                  spreadRadius: -14,
                )
              else
                // 0 1px 2px rgba(20,60,35,.04)
                const BoxShadow(
                  color: Color(0x0A143C23),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: _radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          language.endonym,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            height: 1.25,
                            color: selected
                                ? AppPalette.onPrimary
                                : OnboardingPalette.cardTitle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: selected
                                ? AppPalette.onPrimary.withValues(alpha: 0.78)
                                : AppPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _RadioDot(selected: selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The 28px selection indicator at the end of a [LanguageOptionCard].
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppPalette.onPrimary : null,
        border: selected
            ? null
            : Border.all(color: OnboardingPalette.radioOutline, width: 2.5),
      ),
      child: selected
          ? const Icon(
              Icons.check_rounded,
              size: 18,
              color: AppPalette.forest,
              weight: 800,
            )
          : null,
    );
  }
}
