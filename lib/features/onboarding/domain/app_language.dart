/// Languages Khushhal ships with at launch.
library;

import 'dart:ui' show Locale;

import '../../../l10n/app_localizations.dart';

/// A language offered on the entry screen (design 1a).
///
/// Scoped to the two launch languages; the screen carries a "more languages
/// coming soon" line instead of a longer regional list.
enum AppLanguage {
  /// हिंदी — Hindi (India).
  hindi(endonym: 'हिंदी', shortEndonym: 'हिंदी', code: 'hi'),

  /// English (India).
  english(endonym: 'English', shortEndonym: 'Eng', code: 'en');

  const AppLanguage({
    required this.endonym,
    required this.shortEndonym,
    required this.code,
  });

  /// The language's name in its own script, used as the card title.
  ///
  /// Never translated: a reader of either language has to be able to find
  /// their own row before any language has been chosen.
  final String endonym;

  /// [endonym] shortened to fit the inline toggle in Settings, still in the
  /// language's own script and, like [endonym], never translated.
  final String shortEndonym;

  /// ISO 639-1 language code.
  final String code;

  /// The locale this language maps to.
  Locale get locale => Locale(code);

  /// The language whose [locale] matches [locale], falling back to [english].
  static AppLanguage fromLocale(Locale locale) {
    return AppLanguage.values.firstWhere(
      (AppLanguage language) => language.code == locale.languageCode,
      orElse: () => AppLanguage.english,
    );
  }

  /// The card subtitle, written in the language currently on screen.
  String subtitle(AppLocalizations l10n) {
    return switch (this) {
      AppLanguage.hindi => l10n.languageSubtitleHindi,
      AppLanguage.english => l10n.languageSubtitleEnglish,
    };
  }
}
