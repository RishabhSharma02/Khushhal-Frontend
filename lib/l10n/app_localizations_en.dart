// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brandName => 'Khushhal';

  @override
  String get brandTagline => 'Your business ka health card';

  @override
  String get languageHeading => 'Choose your language';

  @override
  String get languageSubheading => 'You can change this later in Settings.';

  @override
  String get languageSubtitleHindi => 'Hindi';

  @override
  String get languageSubtitleEnglish => 'English (India)';

  @override
  String get languageMoreComingSoon => 'More languages coming soon';

  @override
  String get languageContinue => 'Continue';

  @override
  String get languageOfflineFootnote => 'Works without internet after setup';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get uspForecastTitle => 'See 6 months ahead';

  @override
  String get uspForecastBody =>
      'Your next 6 months of cash — inflow, kharcha and EMI — predicted from your daily entries.';

  @override
  String get uspForecastImage => 'Rising chart sprouting leaves';

  @override
  String get uspOnePlaceTitle => 'Everything in one place';

  @override
  String get uspOnePlaceBody =>
      'Sales, kharcha, loans, stock — your whole business on one health card.';

  @override
  String get uspOnePlaceImage => 'Palm holding a card, icons around it';

  @override
  String get uspActionsTitle => 'Clear steps to lower risk';

  @override
  String get uspActionsBody =>
      'Every warning comes with what to do next — simple actions, in plain words.';

  @override
  String get uspActionsImage => 'Checklist with leaf ticks';

  @override
  String get uspOfflineTitle => 'Works without internet';

  @override
  String get uspOfflineBody =>
      'Record entries all day with no network. Everything syncs when signal returns.';

  @override
  String get uspOfflineImage => 'Phone with a sprout, no-signal calm';
}
