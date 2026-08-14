/// Host for the approved entry flow: designs 1a → 1b–1e.
library;

import 'package:flutter/material.dart';

import '../domain/app_language.dart';
import 'language_select_screen.dart';
import 'usp_carousel_screen.dart';

/// Runs the first-run entry flow.
///
/// Design 1a picks the language, then designs 1b–1e introduce the four USPs.
/// Leaving the carousel — by Skip or by "Get started" on 1e — hands off to
/// login (design 1f), which is not part of this flow.
///
/// The chosen language is owned above this widget so selecting it can swap the
/// app locale straight away, re-rendering 1a in that language.
class OnboardingFlow extends StatefulWidget {
  /// Creates the entry flow.
  const OnboardingFlow({
    super.key,
    required this.language,
    required this.onLanguageSelected,
    required this.onCompleted,
    this.skipLanguage = false,
  });

  /// The language currently on screen.
  final AppLanguage language;

  /// Called when the user taps a language card on design 1a.
  final ValueChanged<AppLanguage> onLanguageSelected;

  /// Called once the user leaves the carousel.
  final VoidCallback onCompleted;

  /// When true, the language screen is skipped — the user's language was
  /// already saved on a previous run and can only be changed from Settings.
  final bool skipLanguage;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late bool _languageConfirmed = widget.skipLanguage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: _languageConfirmed
          ? UspCarouselScreen(
              key: const ValueKey<String>('1b-1e-usp-carousel'),
              onFinished: widget.onCompleted,
            )
          : LanguageSelectScreen(
              key: const ValueKey<String>('1a-language-select'),
              selected: widget.language,
              onLanguageSelected: widget.onLanguageSelected,
              onContinue: () => setState(() => _languageConfirmed = true),
            ),
    );
  }
}
