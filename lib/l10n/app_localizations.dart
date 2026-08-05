import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// Wordmark under the logo on the language select screen (1a).
  ///
  /// In en, this message translates to:
  /// **'Khushhal'**
  String get brandName;

  /// Line under the wordmark on the language select screen (1a).
  ///
  /// In en, this message translates to:
  /// **'Your business ka health card'**
  String get brandTagline;

  /// Heading of the language select screen (1a).
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageHeading;

  /// Supporting line under the language heading (1a).
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get languageSubheading;

  /// Subtitle on the Hindi card (1a). The card title itself stays in Devanagari.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageSubtitleHindi;

  /// Subtitle on the English card (1a).
  ///
  /// In en, this message translates to:
  /// **'English (India)'**
  String get languageSubtitleEnglish;

  /// Note below the language cards (1a).
  ///
  /// In en, this message translates to:
  /// **'More languages coming soon'**
  String get languageMoreComingSoon;

  /// Primary action on the language select screen (1a).
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get languageContinue;

  /// Reassurance line under the Continue button (1a).
  ///
  /// In en, this message translates to:
  /// **'Works without internet after setup'**
  String get languageOfflineFootnote;

  /// The one way out of the USP carousel (1b-1e). It stays on screen while the cards scroll themselves, so there is no Skip or Next alongside it.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// Screen-reader label for the carousel position dots.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepOf(int current, int total);

  /// Headline of USP slide 1 (1b).
  ///
  /// In en, this message translates to:
  /// **'See 6 months ahead'**
  String get uspForecastTitle;

  /// Body of USP slide 1 (1b).
  ///
  /// In en, this message translates to:
  /// **'Your next 6 months of cash — inflow, kharcha and EMI — predicted from your daily entries.'**
  String get uspForecastBody;

  /// Description of the USP slide 1 artwork (1b).
  ///
  /// In en, this message translates to:
  /// **'Rising chart sprouting leaves'**
  String get uspForecastImage;

  /// Headline of USP slide 2 (1c).
  ///
  /// In en, this message translates to:
  /// **'Everything in one place'**
  String get uspOnePlaceTitle;

  /// Body of USP slide 2 (1c).
  ///
  /// In en, this message translates to:
  /// **'Sales, kharcha, loans, stock — your whole business on one health card.'**
  String get uspOnePlaceBody;

  /// Description of the USP slide 2 artwork (1c).
  ///
  /// In en, this message translates to:
  /// **'Palm holding a card, icons around it'**
  String get uspOnePlaceImage;

  /// Headline of USP slide 3 (1d).
  ///
  /// In en, this message translates to:
  /// **'Clear steps to lower risk'**
  String get uspActionsTitle;

  /// Body of USP slide 3 (1d).
  ///
  /// In en, this message translates to:
  /// **'Every warning comes with what to do next — simple actions, in plain words.'**
  String get uspActionsBody;

  /// Description of the USP slide 3 artwork (1d).
  ///
  /// In en, this message translates to:
  /// **'Checklist with leaf ticks'**
  String get uspActionsImage;

  /// Headline of USP slide 4 (1e).
  ///
  /// In en, this message translates to:
  /// **'Works without internet'**
  String get uspOfflineTitle;

  /// Body of USP slide 4 (1e).
  ///
  /// In en, this message translates to:
  /// **'Record entries all day with no network. Everything syncs when signal returns.'**
  String get uspOfflineBody;

  /// Description of the USP slide 4 artwork (1e).
  ///
  /// In en, this message translates to:
  /// **'Phone with a sprout, no-signal calm'**
  String get uspOfflineImage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
