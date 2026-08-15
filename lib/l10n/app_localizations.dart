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

  /// Progress line at the top of guided setup screens (1h, 1i).
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String setupStepOf(int step, int total);

  /// Progress line on per-business setup screens (1k-1m).
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total} · {business}'**
  String setupStepOfBusiness(int step, int total, String business);

  /// Placeholder name for a business before it is named (1j).
  ///
  /// In en, this message translates to:
  /// **'Business {n}'**
  String businessN(int n);

  /// No description provided for @locationHeading.
  ///
  /// In en, this message translates to:
  /// **'Where is your business?'**
  String get locationHeading;

  /// No description provided for @locationUseMine.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get locationUseMine;

  /// No description provided for @locationOneTap.
  ///
  /// In en, this message translates to:
  /// **'1 tap'**
  String get locationOneTap;

  /// No description provided for @locationMapHint.
  ///
  /// In en, this message translates to:
  /// **'Map — pin drops here'**
  String get locationMapHint;

  /// No description provided for @locationDetectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get locationDetectedLabel;

  /// No description provided for @locationDetectedValue.
  ///
  /// In en, this message translates to:
  /// **'Vill. Rampur · Sitapur · UP'**
  String get locationDetectedValue;

  /// No description provided for @locationDetectedMandi.
  ///
  /// In en, this message translates to:
  /// **'Nearest mandi: Sitapur (4 km)'**
  String get locationDetectedMandi;

  /// No description provided for @locationPickByHand.
  ///
  /// In en, this message translates to:
  /// **'Or pick by hand:'**
  String get locationPickByHand;

  /// No description provided for @locationState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get locationState;

  /// No description provided for @locationDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get locationDistrict;

  /// No description provided for @locationVillage.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get locationVillage;

  /// No description provided for @locationWhy.
  ///
  /// In en, this message translates to:
  /// **'Why location? Local mandi prices, weather alerts and seasonality feed your forecast.'**
  String get locationWhy;

  /// No description provided for @locationConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get locationConfirmCta;

  /// No description provided for @countHeading.
  ///
  /// In en, this message translates to:
  /// **'How many businesses do you run?'**
  String get countHeading;

  /// No description provided for @countFourPlus.
  ///
  /// In en, this message translates to:
  /// **'4+'**
  String get countFourPlus;

  /// No description provided for @countNote.
  ///
  /// In en, this message translates to:
  /// **'Just the count — you set up each business one by one on the next screen.'**
  String get countNote;

  /// No description provided for @setupNextCta.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get setupNextCta;

  /// No description provided for @hubTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up businesses'**
  String get hubTitle;

  /// No description provided for @hubDoneOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String hubDoneOf(int done, int total);

  /// No description provided for @hubHeading.
  ///
  /// In en, this message translates to:
  /// **'Set up each business'**
  String get hubHeading;

  /// No description provided for @hubStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get hubStatusNotStarted;

  /// No description provided for @hubStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get hubStatusDone;

  /// No description provided for @hubTaskKind.
  ///
  /// In en, this message translates to:
  /// **'Type & sector'**
  String get hubTaskKind;

  /// No description provided for @hubTaskDetails.
  ///
  /// In en, this message translates to:
  /// **'Details — name, since, staff'**
  String get hubTaskDetails;

  /// No description provided for @hubTaskMoney.
  ///
  /// In en, this message translates to:
  /// **'Monthly money'**
  String get hubTaskMoney;

  /// No description provided for @hubTaskPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get hubTaskPending;

  /// No description provided for @hubStartCta.
  ///
  /// In en, this message translates to:
  /// **'Start setup'**
  String get hubStartCta;

  /// No description provided for @hubFinishCta.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get hubFinishCta;

  /// No description provided for @hubFinishHint.
  ///
  /// In en, this message translates to:
  /// **'You can finish with 1 done and add the rest later'**
  String get hubFinishHint;

  /// No description provided for @hubAddAnother.
  ///
  /// In en, this message translates to:
  /// **'Add new business'**
  String get hubAddAnother;

  /// No description provided for @kindHeading.
  ///
  /// In en, this message translates to:
  /// **'What kind of business?'**
  String get kindHeading;

  /// No description provided for @segmentPrompt.
  ///
  /// In en, this message translates to:
  /// **'I am a…'**
  String get segmentPrompt;

  /// No description provided for @segmentShg.
  ///
  /// In en, this message translates to:
  /// **'SHG'**
  String get segmentShg;

  /// No description provided for @segmentFpo.
  ///
  /// In en, this message translates to:
  /// **'FPO'**
  String get segmentFpo;

  /// No description provided for @segmentOwn.
  ///
  /// In en, this message translates to:
  /// **'Own'**
  String get segmentOwn;

  /// No description provided for @sectorPrompt.
  ///
  /// In en, this message translates to:
  /// **'My work is…'**
  String get sectorPrompt;

  /// No description provided for @sectorDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get sectorDairy;

  /// No description provided for @sectorPoultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get sectorPoultry;

  /// No description provided for @sectorFoodProcessing.
  ///
  /// In en, this message translates to:
  /// **'Food proc.'**
  String get sectorFoodProcessing;

  /// No description provided for @sectorCrafts.
  ///
  /// In en, this message translates to:
  /// **'Crafts'**
  String get sectorCrafts;

  /// No description provided for @sectorShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get sectorShop;

  /// No description provided for @sectorOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sectorOther;

  /// No description provided for @kindDairyHint.
  ///
  /// In en, this message translates to:
  /// **'Dairy picked: winter flush season and Sitapur fodder prices load automatically.'**
  String get kindDairyHint;

  /// No description provided for @kindPoultryHint.
  ///
  /// In en, this message translates to:
  /// **'Poultry picked: feed price swings and summer heat-stress alerts kick in for your area.'**
  String get kindPoultryHint;

  /// No description provided for @kindFoodProcessingHint.
  ///
  /// In en, this message translates to:
  /// **'Food processing picked: input-cost tracking and monsoon demand shifts are factored into your forecast.'**
  String get kindFoodProcessingHint;

  /// No description provided for @kindCraftsHint.
  ///
  /// In en, this message translates to:
  /// **'Handicrafts picked: raw-material seasonality and festival demand windows shape your outlook.'**
  String get kindCraftsHint;

  /// No description provided for @kindShopHint.
  ///
  /// In en, this message translates to:
  /// **'Shop picked: local footfall trends, mandi holidays and fortnightly stock cycles feed your forecast.'**
  String get kindShopHint;

  /// No description provided for @kindOtherHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use only your entries for now — the score gets sharper as you record more months.'**
  String get kindOtherHint;

  /// No description provided for @kindOtherFieldHint.
  ///
  /// In en, this message translates to:
  /// **'What kind of business?'**
  String get kindOtherFieldHint;

  /// No description provided for @detailsHeading.
  ///
  /// In en, this message translates to:
  /// **'About your business'**
  String get detailsHeading;

  /// No description provided for @detailsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get detailsNameLabel;

  /// No description provided for @detailsSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Running since'**
  String get detailsSinceLabel;

  /// No description provided for @tenureUnderOneYear.
  ///
  /// In en, this message translates to:
  /// **'< 1 yr'**
  String get tenureUnderOneYear;

  /// No description provided for @tenureOneToThree.
  ///
  /// In en, this message translates to:
  /// **'1–3 yrs'**
  String get tenureOneToThree;

  /// No description provided for @tenureThreeToTen.
  ///
  /// In en, this message translates to:
  /// **'3–10 yrs'**
  String get tenureThreeToTen;

  /// No description provided for @tenureTenPlus.
  ///
  /// In en, this message translates to:
  /// **'10+ yrs'**
  String get tenureTenPlus;

  /// No description provided for @detailsStaffLabel.
  ///
  /// In en, this message translates to:
  /// **'People working (including you)'**
  String get detailsStaffLabel;

  /// No description provided for @moneyHeading.
  ///
  /// In en, this message translates to:
  /// **'Your money each month'**
  String get moneyHeading;

  /// No description provided for @moneyModeRough.
  ///
  /// In en, this message translates to:
  /// **'Rough estimate'**
  String get moneyModeRough;

  /// No description provided for @moneyModeRecords.
  ///
  /// In en, this message translates to:
  /// **'From my records'**
  String get moneyModeRecords;

  /// No description provided for @moneyInLabel.
  ///
  /// In en, this message translates to:
  /// **'Income (sales)'**
  String get moneyInLabel;

  /// Records-mode label naming the month being typed in (1n).
  ///
  /// In en, this message translates to:
  /// **'Income (sales) · {month}'**
  String moneyInMonthLabel(String month);

  /// No description provided for @moneyOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenditure (costs)'**
  String get moneyOutLabel;

  /// No description provided for @moneyEmiLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan EMI'**
  String get moneyEmiLabel;

  /// No description provided for @moneySavingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Savings today'**
  String get moneySavingsLabel;

  /// No description provided for @moneyRecordsNote.
  ///
  /// In en, this message translates to:
  /// **'Type last month\'s totals from your diary.'**
  String get moneyRecordsNote;

  /// No description provided for @moneyMoreMonths.
  ///
  /// In en, this message translates to:
  /// **'Have more months? Add them after setup — more months = better forecast.'**
  String get moneyMoreMonths;

  /// No description provided for @moneySeeCardCta.
  ///
  /// In en, this message translates to:
  /// **'See my health card'**
  String get moneySeeCardCta;

  /// No description provided for @homeSwitchHint.
  ///
  /// In en, this message translates to:
  /// **'Tap business name to switch'**
  String get homeSwitchHint;

  /// No description provided for @chipSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get chipSynced;

  /// No description provided for @chipSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get chipSyncing;

  /// No description provided for @chipOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get chipOffline;

  /// No description provided for @scoreAsOn.
  ///
  /// In en, this message translates to:
  /// **'Score as on {date}'**
  String scoreAsOn(String date);

  /// No description provided for @scoreNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get scoreNew;

  /// No description provided for @healthTapForForecast.
  ///
  /// In en, this message translates to:
  /// **'Tap for forecast →'**
  String get healthTapForForecast;

  /// No description provided for @addEntryOtherHint.
  ///
  /// In en, this message translates to:
  /// **'Describe this expense…'**
  String get addEntryOtherHint;

  /// Health card headline on a green band (1o). The emoji is appended by HealthCard so it can follow the score, not just the band.
  ///
  /// In en, this message translates to:
  /// **'{name}: HEALTHY'**
  String healthHeadlineLow(String name);

  /// Health card headline on an amber band (1o).
  ///
  /// In en, this message translates to:
  /// **'{name}: NEEDS CARE'**
  String healthHeadlineMedium(String name);

  /// Health card headline on a red band (1o).
  ///
  /// In en, this message translates to:
  /// **'{name}: AT RISK'**
  String healthHeadlineHigh(String name);

  /// Health card summary line on a green band (1o).
  ///
  /// In en, this message translates to:
  /// **'Business is doing well · Score {score}/100'**
  String healthSummaryLow(int score);

  /// Health card summary line on an amber band (1o).
  ///
  /// In en, this message translates to:
  /// **'Business needs some care · Score {score}/100'**
  String healthSummaryMedium(int score);

  /// Health card summary line on a red band (1o).
  ///
  /// In en, this message translates to:
  /// **'Business is under strain · Score {score}/100'**
  String healthSummaryHigh(int score);

  /// No description provided for @scoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'Score {score}/100'**
  String scoreOutOf(int score);

  /// No description provided for @riskLowBadge.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get riskLowBadge;

  /// No description provided for @riskMediumBadge.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get riskMediumBadge;

  /// No description provided for @riskHighBadge.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get riskHighBadge;

  /// No description provided for @homeNextUpdate.
  ///
  /// In en, this message translates to:
  /// **'Next update {date}'**
  String homeNextUpdate(String date);

  /// No description provided for @homeDaysWritten.
  ///
  /// In en, this message translates to:
  /// **'{written} of {days} days written'**
  String homeDaysWritten(int written, int days);

  /// No description provided for @homeDayOf30.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of 30'**
  String homeDayOf30(int day);

  /// No description provided for @homeScoreAsOf.
  ///
  /// In en, this message translates to:
  /// **'Score as of {date}'**
  String homeScoreAsOf(String date);

  /// No description provided for @homeMonthJustStarted.
  ///
  /// In en, this message translates to:
  /// **'{month} just started'**
  String homeMonthJustStarted(String month);

  /// No description provided for @homeScoreNote.
  ///
  /// In en, this message translates to:
  /// **'Score refreshes every 30 days. Keep writing entries — they build the next one.'**
  String get homeScoreNote;

  /// No description provided for @tileMoneyIn.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get tileMoneyIn;

  /// No description provided for @tileMoneyOut.
  ///
  /// In en, this message translates to:
  /// **'Expenditure'**
  String get tileMoneyOut;

  /// No description provided for @tileThisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get tileThisMonth;

  /// No description provided for @tileSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get tileSavings;

  /// No description provided for @tileLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get tileLoan;

  /// No description provided for @tileTapToEdit.
  ///
  /// In en, this message translates to:
  /// **'tap to edit'**
  String get tileTapToEdit;

  /// No description provided for @tileMovedFrom.
  ///
  /// In en, this message translates to:
  /// **'was {amount} · {month}'**
  String tileMovedFrom(String amount, String month);

  /// No description provided for @tileMovedFromPlain.
  ///
  /// In en, this message translates to:
  /// **'was {amount}'**
  String tileMovedFromPlain(String amount);

  /// No description provided for @homeWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get homeWatch;

  /// No description provided for @watchTitle.
  ///
  /// In en, this message translates to:
  /// **'{month} may be tight'**
  String watchTitle(String month);

  /// No description provided for @watchTitleNoMonth.
  ///
  /// In en, this message translates to:
  /// **'Money may get tight soon'**
  String get watchTitleNoMonth;

  /// No description provided for @watchReasonMandi.
  ///
  /// In en, this message translates to:
  /// **'fodder price rising in Sitapur.'**
  String get watchReasonMandi;

  /// No description provided for @watchReasonScore.
  ///
  /// In en, this message translates to:
  /// **'from your latest score.'**
  String get watchReasonScore;

  /// No description provided for @watchReasonForecast.
  ///
  /// In en, this message translates to:
  /// **'from the new forecast.'**
  String get watchReasonForecast;

  /// No description provided for @watchAction.
  ///
  /// In en, this message translates to:
  /// **'Do this: buy fodder early with your group'**
  String get watchAction;

  /// No description provided for @watchSeePlan.
  ///
  /// In en, this message translates to:
  /// **'Do this: see what to do'**
  String get watchSeePlan;

  /// No description provided for @homeWriteEntryCta.
  ///
  /// In en, this message translates to:
  /// **'Write today\'s entry'**
  String get homeWriteEntryCta;

  /// No description provided for @homeMonthClosedBanner.
  ///
  /// In en, this message translates to:
  /// **'{month} is closed — new score ready'**
  String homeMonthClosedBanner(String month);

  /// No description provided for @homeSeeChangedCta.
  ///
  /// In en, this message translates to:
  /// **'See what changed'**
  String get homeSeeChangedCta;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'No network — everything still works. {count} entries will sync later.'**
  String offlineBanner(int count);

  /// No description provided for @offlineHealthHeadline.
  ///
  /// In en, this message translates to:
  /// **'Business is HEALTHY'**
  String get offlineHealthHeadline;

  /// No description provided for @offlineHealthHeadlineMedium.
  ///
  /// In en, this message translates to:
  /// **'Business is ON WATCH'**
  String get offlineHealthHeadlineMedium;

  /// No description provided for @offlineHealthHeadlineHigh.
  ///
  /// In en, this message translates to:
  /// **'Business is AT RISK'**
  String get offlineHealthHeadlineHigh;

  /// No description provided for @offlineScoreLine.
  ///
  /// In en, this message translates to:
  /// **'Score {score}/100 · as on {date}'**
  String offlineScoreLine(int score, String date);

  /// No description provided for @offlineMandiStale.
  ///
  /// In en, this message translates to:
  /// **'Mandi prices as of {days} days ago'**
  String offlineMandiStale(int days);

  /// No description provided for @addEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get addEntryTitle;

  /// No description provided for @addEntrySavesOffline.
  ///
  /// In en, this message translates to:
  /// **'Saves offline'**
  String get addEntrySavesOffline;

  /// No description provided for @entryIn.
  ///
  /// In en, this message translates to:
  /// **'IN'**
  String get entryIn;

  /// No description provided for @entryOut.
  ///
  /// In en, this message translates to:
  /// **'OUT'**
  String get entryOut;

  /// No description provided for @addEntryAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get addEntryAmount;

  /// No description provided for @addEntryWhatFor.
  ///
  /// In en, this message translates to:
  /// **'What for?'**
  String get addEntryWhatFor;

  /// No description provided for @categoryMilkSale.
  ///
  /// In en, this message translates to:
  /// **'Milk sale'**
  String get categoryMilkSale;

  /// No description provided for @categoryFodder.
  ///
  /// In en, this message translates to:
  /// **'Fodder'**
  String get categoryFodder;

  /// No description provided for @categoryVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get categoryVet;

  /// No description provided for @categoryEmi.
  ///
  /// In en, this message translates to:
  /// **'EMI'**
  String get categoryEmi;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @addEntryMonthNote.
  ///
  /// In en, this message translates to:
  /// **'Adds to {month} · your score updates on {date}'**
  String addEntryMonthNote(String month, String date);

  /// No description provided for @saveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveCta;

  /// No description provided for @forecastMadeOn.
  ///
  /// In en, this message translates to:
  /// **'Made on {date} · next forecast {next}'**
  String forecastMadeOn(String date, String next);

  /// No description provided for @forecastHeading.
  ///
  /// In en, this message translates to:
  /// **'Next 6 months of your money'**
  String get forecastHeading;

  /// No description provided for @forecastInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'In {month}, money OUT may be more than money IN.'**
  String forecastInsightTitle(String month);

  /// Why the flagged month is tight. The amount is savings on hand today, not a forecast figure.
  ///
  /// In en, this message translates to:
  /// **'Money OUT is forecast above money IN that month. You have {amount} saved today — that is the buffer it would draw on.'**
  String forecastInsightWhy(String amount);

  /// Forecast insight title when the model flagged no month at all — shown instead of naming a month.
  ///
  /// In en, this message translates to:
  /// **'No tight month in the next 6 months.'**
  String get forecastNoRiskTitle;

  /// Forecast insight body when the model flagged no month at all.
  ///
  /// In en, this message translates to:
  /// **'Money IN stays ahead of money OUT right across the window. Keep writing entries — next month\'s forecast can change this.'**
  String get forecastNoRiskWhy;

  /// No description provided for @whatIfNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get whatIfNormal;

  /// No description provided for @whatIfSpike.
  ///
  /// In en, this message translates to:
  /// **'Price spike?'**
  String get whatIfSpike;

  /// No description provided for @whatIfWeather.
  ///
  /// In en, this message translates to:
  /// **'Bad weather?'**
  String get whatIfWeather;

  /// No description provided for @forecastWhatCta.
  ///
  /// In en, this message translates to:
  /// **'What should I do?'**
  String get forecastWhatCta;

  /// No description provided for @updateTitle.
  ///
  /// In en, this message translates to:
  /// **'Your {month} update'**
  String updateTitle(String month);

  /// No description provided for @updateScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} · Health score'**
  String updateScoreLabel(String name);

  /// Score delta chip on 1q2; the ▲ glyph is drawn by the widget.
  ///
  /// In en, this message translates to:
  /// **'{points} from {month}'**
  String updateDeltaFrom(int points, String month);

  /// No description provided for @updateWhyMoved.
  ///
  /// In en, this message translates to:
  /// **'Why it moved'**
  String get updateWhyMoved;

  /// No description provided for @reasonMilkIncome.
  ///
  /// In en, this message translates to:
  /// **'Milk income rose {amount} over {month}.'**
  String reasonMilkIncome(String amount, String month);

  /// No description provided for @reasonSteadyEntries.
  ///
  /// In en, this message translates to:
  /// **'You wrote entries on {written} of {days} days — steady records count.'**
  String reasonSteadyEntries(int written, int days);

  /// No description provided for @reasonFodderCost.
  ///
  /// In en, this message translates to:
  /// **'Fodder cost up {amount} — it held the score back.'**
  String reasonFodderCost(String amount);

  /// No description provided for @updateBandLabel.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get updateBandLabel;

  /// No description provided for @updateSeeForecastCta.
  ///
  /// In en, this message translates to:
  /// **'See the new 6-month forecast'**
  String get updateSeeForecastCta;

  /// No description provided for @updateFixedNote.
  ///
  /// In en, this message translates to:
  /// **'Your score is fixed until {date} — nothing you do today changes it'**
  String updateFixedNote(String date);

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// No description provided for @alertsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String alertsFilterAll(int count);

  /// No description provided for @alertsFilterUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent ({count})'**
  String alertsFilterUrgent(int count);

  /// No description provided for @alertsFilterInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get alertsFilterInfo;

  /// No description provided for @alertSavingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings may run low in {month}'**
  String alertSavingsTitle(String month);

  /// Savings alert title when the forecast flags no particular month.
  ///
  /// In en, this message translates to:
  /// **'Savings may run low'**
  String get alertSavingsTitleNoMonth;

  /// Savings alert detail. Only the raised date is a real figure, so no rupee amount is quoted.
  ///
  /// In en, this message translates to:
  /// **'From your latest forecast · raised {date}'**
  String alertSavingsDetail(String date);

  /// Savings alert detail for a feed that carries no raised date.
  ///
  /// In en, this message translates to:
  /// **'From your latest forecast'**
  String get alertSavingsDetailUndated;

  /// No description provided for @alertSavingsAction.
  ///
  /// In en, this message translates to:
  /// **'See 3 things to do'**
  String get alertSavingsAction;

  /// No description provided for @alertFodderTitle.
  ///
  /// In en, this message translates to:
  /// **'Fodder price up 14% in Sitapur mandi'**
  String get alertFodderTitle;

  /// No description provided for @alertFodderDetail.
  ///
  /// In en, this message translates to:
  /// **'Affects your monthly costs · {date}'**
  String alertFodderDetail(String date);

  /// No description provided for @alertRainTitle.
  ///
  /// In en, this message translates to:
  /// **'Heavy rain expected this week'**
  String get alertRainTitle;

  /// No description provided for @alertRainDetail.
  ///
  /// In en, this message translates to:
  /// **'Protect fodder stock · weather dept.'**
  String get alertRainDetail;

  /// No description provided for @alertsSmsNote.
  ///
  /// In en, this message translates to:
  /// **'Alerts also arrive as SMS when the app is offline'**
  String get alertsSmsNote;

  /// No description provided for @talkToOfficerCta.
  ///
  /// In en, this message translates to:
  /// **'Talk to field officer'**
  String get talkToOfficerCta;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'{month} plan'**
  String planTitle(String month);

  /// No description provided for @planTightTitle.
  ///
  /// In en, this message translates to:
  /// **'{month} looks tight'**
  String planTightTitle(String month);

  /// No description provided for @planTightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Savings could fall from {from} to {to}'**
  String planTightSubtitle(String from, String to);

  /// No description provided for @planDoThese.
  ///
  /// In en, this message translates to:
  /// **'Do these 3 things:'**
  String get planDoThese;

  /// No description provided for @planFodderTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy fodder early, with your group'**
  String get planFodderTitle;

  /// No description provided for @planFodderBenefit.
  ///
  /// In en, this message translates to:
  /// **'Saves ~{amount} before prices rise'**
  String planFodderBenefit(String amount);

  /// No description provided for @planWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep {amount}/week aside from now'**
  String planWeeklyTitle(String amount);

  /// No description provided for @planWeeklyBenefit.
  ///
  /// In en, this message translates to:
  /// **'Adds {amount} buffer by {month}'**
  String planWeeklyBenefit(String amount, String month);

  /// No description provided for @planEmiTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask the bank to move your EMI date to milk-payment week'**
  String get planEmiTitle;

  /// No description provided for @planEmiNote.
  ///
  /// In en, this message translates to:
  /// **'Show this screen at the branch'**
  String get planEmiNote;

  /// No description provided for @planDoneChip.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get planDoneChip;

  /// No description provided for @alertDriverLiquidityTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash buffer is tight'**
  String get alertDriverLiquidityTitle;

  /// No description provided for @alertDriverLiquiditySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Savings or debt cover is low. The steps below rebuild your buffer.'**
  String get alertDriverLiquiditySubtitle;

  /// No description provided for @alertDriverClimateDeficitTitle.
  ///
  /// In en, this message translates to:
  /// **'Rainfall below normal'**
  String get alertDriverClimateDeficitTitle;

  /// No description provided for @alertDriverClimateDeficitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local rain is below normal — expect input prices to rise.'**
  String get alertDriverClimateDeficitSubtitle;

  /// No description provided for @alertDriverClimateExcessTitle.
  ///
  /// In en, this message translates to:
  /// **'Rainfall higher than usual'**
  String get alertDriverClimateExcessTitle;

  /// No description provided for @alertDriverClimateExcessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Heavier than usual rainfall — protect stored inputs.'**
  String get alertDriverClimateExcessSubtitle;

  /// No description provided for @alertDriverMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Market prices moved against you'**
  String get alertDriverMarketTitle;

  /// No description provided for @alertDriverMarketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of trade have moved against your sector.'**
  String get alertDriverMarketSubtitle;

  /// No description provided for @alertDriverNewBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh business — extra care needed'**
  String get alertDriverNewBusinessTitle;

  /// No description provided for @alertDriverNewBusinessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A newer business needs closer daily tracking.'**
  String get alertDriverNewBusinessSubtitle;

  /// No description provided for @alertDriverWatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch out for {month}'**
  String alertDriverWatchTitle(String month);

  /// No description provided for @alertDriverGenericSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the steps below to stay on track.'**
  String get alertDriverGenericSubtitle;

  /// No description provided for @alertMarkingNote.
  ///
  /// In en, this message translates to:
  /// **'Marking actions done here helps the ML model re-score your business next month.'**
  String get alertMarkingNote;

  /// No description provided for @planNote.
  ///
  /// In en, this message translates to:
  /// **'Do 1 & 2 and {month} savings stay above {amount}. The forecast updates live as you mark things done.'**
  String planNote(String month, String amount);

  /// No description provided for @savingsLoanTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings & loan'**
  String get savingsLoanTitle;

  /// No description provided for @changeCta.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeCta;

  /// No description provided for @savingsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap Change to correct the amount anytime'**
  String get savingsHint;

  /// No description provided for @loanHint.
  ///
  /// In en, this message translates to:
  /// **'As told by you'**
  String get loanHint;

  /// No description provided for @cancelCta.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelCta;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @historyFilterSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get historyFilterSalary;

  /// No description provided for @historyInMonth.
  ///
  /// In en, this message translates to:
  /// **'IN · {month}'**
  String historyInMonth(String month);

  /// No description provided for @historyOutMonth.
  ///
  /// In en, this message translates to:
  /// **'OUT · {month}'**
  String historyOutMonth(String month);

  /// No description provided for @historyLoanPaid.
  ///
  /// In en, this message translates to:
  /// **'Loan paid'**
  String get historyLoanPaid;

  /// No description provided for @historyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get historyToday;

  /// No description provided for @historyYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get historyYesterday;

  /// No description provided for @historyByVoice.
  ///
  /// In en, this message translates to:
  /// **'by voice'**
  String get historyByVoice;

  /// No description provided for @historyWillSync.
  ///
  /// In en, this message translates to:
  /// **'will sync'**
  String get historyWillSync;

  /// No description provided for @historyTapToCorrect.
  ///
  /// In en, this message translates to:
  /// **'Tap an entry to correct it'**
  String get historyTapToCorrect;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncTitle;

  /// No description provided for @syncSending.
  ///
  /// In en, this message translates to:
  /// **'Sending {count} saved entries…'**
  String syncSending(int count);

  /// No description provided for @syncWaitingHeader.
  ///
  /// In en, this message translates to:
  /// **'Waiting to send'**
  String get syncWaitingHeader;

  /// No description provided for @syncStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get syncStatusSent;

  /// No description provided for @syncStatusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get syncStatusSending;

  /// No description provided for @syncStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'waiting'**
  String get syncStatusWaiting;

  /// No description provided for @syncAutoNote.
  ///
  /// In en, this message translates to:
  /// **'Auto-syncs when network returns — you never need this screen. Uses about 50 KB a week; works on 2G.'**
  String get syncAutoNote;

  /// No description provided for @syncLastFull.
  ///
  /// In en, this message translates to:
  /// **'Last full sync'**
  String get syncLastFull;

  /// No description provided for @syncNowCta.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNowCta;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get settingsEdit;

  /// No description provided for @settingsMyBusinesses.
  ///
  /// In en, this message translates to:
  /// **'My businesses'**
  String get settingsMyBusinesses;

  /// No description provided for @settingsAddBusiness.
  ///
  /// In en, this message translates to:
  /// **'Add new business'**
  String get settingsAddBusiness;

  /// No description provided for @settingsSeeReport.
  ///
  /// In en, this message translates to:
  /// **'See report'**
  String get settingsSeeReport;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsValue.
  ///
  /// In en, this message translates to:
  /// **'SMS + in-app alerts on'**
  String get settingsNotificationsValue;

  /// No description provided for @settingsNotificationsNone.
  ///
  /// In en, this message translates to:
  /// **'No alerts right now'**
  String get settingsNotificationsNone;

  /// No description provided for @settingsNotificationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alert to see} other{{count} alerts to see}}'**
  String settingsNotificationsCount(int count);

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsContact;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Khushhal'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get settingsVersion;

  /// No description provided for @settingsLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogOut;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'Khushhal is a money diary for your small business.'**
  String get aboutIntro;

  /// No description provided for @aboutHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'Write down the money that comes in and the money that goes out. It takes one minute a day.'**
  String get aboutHowItWorks;

  /// No description provided for @aboutScore.
  ///
  /// In en, this message translates to:
  /// **'Every month Khushhal gives your business a health score and tells you what to do next.'**
  String get aboutScore;

  /// No description provided for @aboutOffline.
  ///
  /// In en, this message translates to:
  /// **'It works without network. Your entries stay safe on this phone and go online later.'**
  String get aboutOffline;

  /// No description provided for @aboutHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Helpline'**
  String get aboutHelpTitle;

  /// No description provided for @aboutHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the number to call us.'**
  String get aboutHelpBody;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hurray! Welcome to Khushhal'**
  String get authWelcomeTitle;

  /// No description provided for @authWhatToCallYou.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get authWhatToCallYou;

  /// No description provided for @authFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get authFirstName;

  /// No description provided for @authLastNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Last name (optional)'**
  String get authLastNameOptional;

  /// No description provided for @authSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get authSaving;

  /// No description provided for @authSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {reason}'**
  String authSaveFailed(String reason);

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String authWelcomeBack(String name);

  /// No description provided for @authEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN'**
  String get authEnterPin;

  /// No description provided for @authForgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get authForgotPin;

  /// No description provided for @authLoginWithMobile.
  ///
  /// In en, this message translates to:
  /// **'Login with mobile number'**
  String get authLoginWithMobile;

  /// No description provided for @authEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get authEnterCode;

  /// No description provided for @authSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {phone} · '**
  String authSentTo(String phone);

  /// No description provided for @authResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in 0:{secs}'**
  String authResendIn(String secs);

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get authPhoneTitle;

  /// No description provided for @authPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit code by SMS. No password needed.'**
  String get authPhoneSubtitle;

  /// No description provided for @authGetOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get authGetOtp;

  /// No description provided for @authSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get authSending;

  /// No description provided for @authTooManyTries.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries — please sign in again.'**
  String get authTooManyTries;

  /// No description provided for @authWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong mPIN. {left} attempts left.'**
  String authWrongPin(int left);

  /// No description provided for @authCreatePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your PIN'**
  String get authCreatePinTitle;

  /// No description provided for @authCreatePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick 4 digits you will remember.\nNext time you open the app, just enter this.'**
  String get authCreatePinSubtitle;

  /// No description provided for @authConfirmPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Type it again'**
  String get authConfirmPinTitle;

  /// No description provided for @authConfirmPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the same 4 digits once more to confirm.'**
  String get authConfirmPinSubtitle;

  /// No description provided for @authPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs do not match. Try again.'**
  String get authPinMismatch;
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
