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

  @override
  String setupStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String setupStepOfBusiness(int step, int total, String business) {
    return 'Step $step of $total · $business';
  }

  @override
  String businessN(int n) {
    return 'Business $n';
  }

  @override
  String get locationHeading => 'Where is your business?';

  @override
  String get locationUseMine => 'Use my location';

  @override
  String get locationOneTap => '1 tap';

  @override
  String get locationMapHint => 'Map — pin drops here';

  @override
  String get locationDetectedLabel => 'Detected';

  @override
  String get locationDetectedValue => 'Vill. Rampur · Sitapur · UP';

  @override
  String get locationDetectedMandi => 'Nearest mandi: Sitapur (4 km)';

  @override
  String get locationPickByHand => 'Or pick by hand:';

  @override
  String get locationState => 'State';

  @override
  String get locationDistrict => 'District';

  @override
  String get locationVillage => 'Village';

  @override
  String get locationWhy =>
      'Why location? Local mandi prices, weather alerts and seasonality feed your forecast.';

  @override
  String get locationConfirmCta => 'Confirm location';

  @override
  String get countHeading => 'How many businesses do you run?';

  @override
  String get countFourPlus => '4+';

  @override
  String get countNote =>
      'Just the count — you set up each business one by one on the next screen.';

  @override
  String get setupNextCta => 'Next';

  @override
  String get hubTitle => 'Set up businesses';

  @override
  String hubDoneOf(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get hubHeading => 'Set up each business';

  @override
  String get hubStatusNotStarted => 'Not started';

  @override
  String get hubStatusDone => 'Done';

  @override
  String get hubTaskKind => 'Type & sector';

  @override
  String get hubTaskDetails => 'Details — name, since, staff';

  @override
  String get hubTaskMoney => 'Monthly money';

  @override
  String get hubTaskPending => 'pending';

  @override
  String get hubStartCta => 'Start setup';

  @override
  String get hubFinishCta => 'Finish';

  @override
  String get hubFinishHint =>
      'You can finish with 1 done and add the rest later';

  @override
  String get hubAddAnother => 'Add new business';

  @override
  String get kindHeading => 'What kind of business?';

  @override
  String get segmentPrompt => 'I am a…';

  @override
  String get segmentShg => 'SHG';

  @override
  String get segmentFpo => 'FPO';

  @override
  String get segmentOwn => 'Own';

  @override
  String get sectorPrompt => 'My work is…';

  @override
  String get sectorDairy => 'Dairy';

  @override
  String get sectorPoultry => 'Poultry';

  @override
  String get sectorFoodProcessing => 'Food proc.';

  @override
  String get sectorCrafts => 'Crafts';

  @override
  String get sectorShop => 'Shop';

  @override
  String get sectorOther => 'Other';

  @override
  String get kindDairyHint =>
      'Dairy picked: winter flush season and Sitapur fodder prices load automatically.';

  @override
  String get kindPoultryHint =>
      'Poultry picked: feed price swings and summer heat-stress alerts kick in for your area.';

  @override
  String get kindFoodProcessingHint =>
      'Food processing picked: input-cost tracking and monsoon demand shifts are factored into your forecast.';

  @override
  String get kindCraftsHint =>
      'Handicrafts picked: raw-material seasonality and festival demand windows shape your outlook.';

  @override
  String get kindShopHint =>
      'Shop picked: local footfall trends, mandi holidays and fortnightly stock cycles feed your forecast.';

  @override
  String get kindOtherHint =>
      'We\'ll use only your entries for now — the score gets sharper as you record more months.';

  @override
  String get kindOtherFieldHint => 'What kind of business?';

  @override
  String get detailsHeading => 'About your business';

  @override
  String get detailsNameLabel => 'Business name';

  @override
  String get detailsSinceLabel => 'Running since';

  @override
  String get tenureUnderOneYear => '< 1 yr';

  @override
  String get tenureOneToThree => '1–3 yrs';

  @override
  String get tenureThreeToTen => '3–10 yrs';

  @override
  String get tenureTenPlus => '10+ yrs';

  @override
  String get detailsStaffLabel => 'People working (including you)';

  @override
  String get moneyHeading => 'Your money each month';

  @override
  String get moneyModeRough => 'Rough estimate';

  @override
  String get moneyModeRecords => 'From my records';

  @override
  String get moneyInLabel => 'Income (sales)';

  @override
  String moneyInMonthLabel(String month) {
    return 'Income (sales) · $month';
  }

  @override
  String get moneyOutLabel => 'Expenditure (costs)';

  @override
  String get moneyEmiLabel => 'Loan EMI';

  @override
  String get moneySavingsLabel => 'Savings today';

  @override
  String get moneyRecordsNote => 'Type last month\'s totals from your diary.';

  @override
  String get moneyMoreMonths =>
      'Have more months? Add them after setup — more months = better forecast.';

  @override
  String get moneySeeCardCta => 'See my health card';

  @override
  String get homeSwitchHint => 'Tap business name to switch';

  @override
  String homeBusinessKindSector(String segment, String sector) {
    return '$segment · $sector';
  }

  @override
  String get homeOfficerCardTitle => 'Your field officer';

  @override
  String homeOfficerId(String id) {
    return 'Officer ID · $id';
  }

  @override
  String get homeOfficerCallTooltip => 'Call officer';

  @override
  String homeOfficerCallFailed(String phone) {
    return 'Could not open dialer for $phone';
  }

  @override
  String get homeOfflineDeviceTitle => 'Device is offline';

  @override
  String homeOfflineSyncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries waiting to sync',
      one: '1 entry waiting to sync',
      zero: 'Nothing waiting to sync',
    );
    return '$_temp0';
  }

  @override
  String get chipSynced => 'Synced';

  @override
  String get chipSyncing => 'Syncing…';

  @override
  String get chipOffline => 'Offline';

  @override
  String scoreAsOn(String date) {
    return 'Score as on $date';
  }

  @override
  String get scoreNew => 'New';

  @override
  String get healthTapForForecast => 'Tap for forecast →';

  @override
  String get addEntryOtherHint => 'Describe this expense…';

  @override
  String healthHeadlineLow(String name) {
    return '$name: HEALTHY';
  }

  @override
  String healthHeadlineMedium(String name) {
    return '$name: NEEDS CARE';
  }

  @override
  String healthHeadlineHigh(String name) {
    return '$name: AT RISK';
  }

  @override
  String healthSummaryLow(int score) {
    return 'Business is doing well · Score $score/100';
  }

  @override
  String healthSummaryMedium(int score) {
    return 'Business needs some care · Score $score/100';
  }

  @override
  String healthSummaryHigh(int score) {
    return 'Business is under strain · Score $score/100';
  }

  @override
  String scoreOutOf(int score) {
    return 'Score $score/100';
  }

  @override
  String get riskLowBadge => 'Low risk';

  @override
  String get riskMediumBadge => 'Medium risk';

  @override
  String get riskHighBadge => 'High risk';

  @override
  String homeNextUpdate(String date) {
    return 'Next update $date';
  }

  @override
  String homeDaysWritten(int written, int days) {
    return '$written of $days days written';
  }

  @override
  String homeDayOf30(int day) {
    return 'Day $day of 30';
  }

  @override
  String homeScoreAsOf(String date) {
    return 'Score as of $date';
  }

  @override
  String homeMonthJustStarted(String month) {
    return '$month just started';
  }

  @override
  String get homeScoreNote =>
      'Score refreshes every 30 days. Keep writing entries — they build the next one.';

  @override
  String get tileMoneyIn => 'Income';

  @override
  String get tileMoneyOut => 'Expenditure';

  @override
  String get tileThisMonth => 'this month';

  @override
  String get tileSavings => 'Savings';

  @override
  String get tileLoan => 'Loan';

  @override
  String get tileTapToEdit => 'tap to edit';

  @override
  String tileMovedFrom(String amount, String month) {
    return 'was $amount · $month';
  }

  @override
  String tileMovedFromPlain(String amount) {
    return 'was $amount';
  }

  @override
  String get homeWatch => 'Watch';

  @override
  String watchTitle(String month) {
    return '$month may be tight';
  }

  @override
  String get watchTitleNoMonth => 'Money may get tight soon';

  @override
  String get watchReasonMandi => 'fodder price rising in Sitapur.';

  @override
  String get watchReasonScore => 'from your latest score.';

  @override
  String get watchReasonForecast => 'from the new forecast.';

  @override
  String get watchAction => 'Do this: buy fodder early with your group';

  @override
  String get watchSeePlan => 'Do this: see what to do';

  @override
  String get homeWriteEntryCta => 'Write today\'s entry';

  @override
  String homeMonthClosedBanner(String month) {
    return '$month is closed — new score ready';
  }

  @override
  String get homeSeeChangedCta => 'See what changed';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String offlineBanner(int count) {
    return 'No network — everything still works. $count entries will sync later.';
  }

  @override
  String get offlineHealthHeadline => 'Business is HEALTHY';

  @override
  String get offlineHealthHeadlineMedium => 'Business is ON WATCH';

  @override
  String get offlineHealthHeadlineHigh => 'Business is AT RISK';

  @override
  String offlineScoreLine(int score, String date) {
    return 'Score $score/100 · as on $date';
  }

  @override
  String offlineMandiStale(int days) {
    return 'Mandi prices as of $days days ago';
  }

  @override
  String get addEntryTitle => 'Add entry';

  @override
  String get addEntrySavesOffline => 'Saves offline';

  @override
  String get entryIn => 'IN';

  @override
  String get entryOut => 'OUT';

  @override
  String get addEntryAmount => 'Amount';

  @override
  String get addEntryWhatFor => 'What for?';

  @override
  String get categoryMilkSale => 'Milk sale';

  @override
  String get categoryFodder => 'Fodder';

  @override
  String get categoryVet => 'Vet';

  @override
  String get categoryEmi => 'EMI';

  @override
  String get categoryOther => 'Other';

  @override
  String addEntryMonthNote(String month, String date) {
    return 'Adds to $month · your score updates on $date';
  }

  @override
  String get saveCta => 'Save';

  @override
  String forecastMadeOn(String date, String next) {
    return 'Made on $date · next forecast $next';
  }

  @override
  String get forecastHeading => 'Next 6 months of your money';

  @override
  String get forecastNetLabel => 'Net cash flow';

  @override
  String forecastInsightTitle(String month) {
    return 'In $month, money OUT may be more than money IN.';
  }

  @override
  String forecastInsightWhy(String amount) {
    return 'Money OUT is forecast above money IN that month. You have $amount saved today — that is the buffer it would draw on.';
  }

  @override
  String get forecastNoRiskTitle => 'No tight month in the next 6 months.';

  @override
  String get forecastNoRiskWhy =>
      'Money IN stays ahead of money OUT right across the window. Keep writing entries — next month\'s forecast can change this.';

  @override
  String get whatIfNormal => 'Normal';

  @override
  String get whatIfSpike => 'Price spike?';

  @override
  String get whatIfWeather => 'Bad weather?';

  @override
  String get forecastWhatCta => 'What should I do?';

  @override
  String updateTitle(String month) {
    return 'Your $month update';
  }

  @override
  String updateScoreLabel(String name) {
    return '$name · Health score';
  }

  @override
  String updateDeltaFrom(int points, String month) {
    return '$points from $month';
  }

  @override
  String get updateWhyMoved => 'Why it moved';

  @override
  String reasonMilkIncome(String amount, String month) {
    return 'Milk income rose $amount over $month.';
  }

  @override
  String reasonSteadyEntries(int written, int days) {
    return 'You wrote entries on $written of $days days — steady records count.';
  }

  @override
  String reasonFodderCost(String amount) {
    return 'Fodder cost up $amount — it held the score back.';
  }

  @override
  String get updateBandLabel => 'Band';

  @override
  String get updateSeeForecastCta => 'See the new 6-month forecast';

  @override
  String updateFixedNote(String date) {
    return 'Your score is fixed until $date — nothing you do today changes it';
  }

  @override
  String get alertsTitle => 'Alerts';

  @override
  String alertsFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String alertsFilterUrgent(int count) {
    return 'Urgent ($count)';
  }

  @override
  String get alertsFilterInfo => 'Info';

  @override
  String alertSavingsTitle(String month) {
    return 'Savings may run low in $month';
  }

  @override
  String get alertSavingsTitleNoMonth => 'Savings may run low';

  @override
  String alertSavingsDetail(String date) {
    return 'From your latest forecast · raised $date';
  }

  @override
  String get alertSavingsDetailUndated => 'From your latest forecast';

  @override
  String get alertSavingsAction => 'See 3 things to do';

  @override
  String get alertFodderTitle => 'Fodder price up 14% in Sitapur mandi';

  @override
  String alertFodderDetail(String date) {
    return 'Affects your monthly costs · $date';
  }

  @override
  String get alertRainTitle => 'Heavy rain expected this week';

  @override
  String get alertRainDetail => 'Protect fodder stock · weather dept.';

  @override
  String get alertsSmsNote =>
      'Alerts also arrive as SMS when the app is offline';

  @override
  String get talkToOfficerCta => 'Talk to field officer';

  @override
  String planTitle(String month) {
    return '$month plan';
  }

  @override
  String planTightTitle(String month) {
    return '$month looks tight';
  }

  @override
  String planTightSubtitle(String from, String to) {
    return 'Savings could fall from $from to $to';
  }

  @override
  String get planDoThese => 'Do these 3 things:';

  @override
  String get planFodderTitle => 'Buy fodder early, with your group';

  @override
  String planFodderBenefit(String amount) {
    return 'Saves ~$amount before prices rise';
  }

  @override
  String planWeeklyTitle(String amount) {
    return 'Keep $amount/week aside from now';
  }

  @override
  String planWeeklyBenefit(String amount, String month) {
    return 'Adds $amount buffer by $month';
  }

  @override
  String get planEmiTitle =>
      'Ask the bank to move your EMI date to milk-payment week';

  @override
  String get planEmiNote => 'Show this screen at the branch';

  @override
  String get planDoneChip => 'Done';

  @override
  String get alertDriverLiquidityTitle => 'Cash buffer is tight';

  @override
  String get alertDriverLiquiditySubtitle =>
      'Savings or debt cover is low. The steps below rebuild your buffer.';

  @override
  String get alertDriverClimateDeficitTitle => 'Rainfall below normal';

  @override
  String get alertDriverClimateDeficitSubtitle =>
      'Local rain is below normal — expect input prices to rise.';

  @override
  String get alertDriverClimateExcessTitle => 'Rainfall higher than usual';

  @override
  String get alertDriverClimateExcessSubtitle =>
      'Heavier than usual rainfall — protect stored inputs.';

  @override
  String get alertDriverMarketTitle => 'Market prices moved against you';

  @override
  String get alertDriverMarketSubtitle =>
      'Terms of trade have moved against your sector.';

  @override
  String get alertDriverNewBusinessTitle =>
      'Fresh business — extra care needed';

  @override
  String get alertDriverNewBusinessSubtitle =>
      'A newer business needs closer daily tracking.';

  @override
  String alertDriverWatchTitle(String month) {
    return 'Watch out for $month';
  }

  @override
  String get alertDriverGenericSubtitle =>
      'Follow the steps below to stay on track.';

  @override
  String get alertMarkingNote =>
      'Marking actions done here helps the ML model re-score your business next month.';

  @override
  String planNote(String month, String amount) {
    return 'Do 1 & 2 and $month savings stay above $amount. The forecast updates live as you mark things done.';
  }

  @override
  String get savingsLoanTitle => 'Savings & loan';

  @override
  String get changeCta => 'Change';

  @override
  String get savingsHint => 'Tap Change to correct the amount anytime';

  @override
  String get loanHint => 'As told by you';

  @override
  String get cancelCta => 'Cancel';

  @override
  String get historyTitle => 'History';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyFilterSalary => 'Salary';

  @override
  String historyInMonth(String month) {
    return 'IN · $month';
  }

  @override
  String historyOutMonth(String month) {
    return 'OUT · $month';
  }

  @override
  String get historyLoanPaid => 'Loan paid';

  @override
  String get historyToday => 'Today';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String get historyByVoice => 'by voice';

  @override
  String get historyWillSync => 'will sync';

  @override
  String get historyTapToCorrect => 'Tap an entry to correct it';

  @override
  String get syncTitle => 'Sync';

  @override
  String syncSending(int count) {
    return 'Sending $count saved entries…';
  }

  @override
  String get syncWaitingHeader => 'Waiting to send';

  @override
  String get syncStatusSent => 'Sent';

  @override
  String get syncStatusSending => 'Sending…';

  @override
  String get syncStatusWaiting => 'waiting';

  @override
  String get syncAutoNote =>
      'Auto-syncs when network returns — you never need this screen. Uses about 50 KB a week; works on 2G.';

  @override
  String get syncLastFull => 'Last full sync';

  @override
  String get syncNowCta => 'Sync now';

  @override
  String get editBusinessTitle => 'Edit business';

  @override
  String get editBusinessKindLabel => 'Business kind';

  @override
  String get editBusinessSectorLabel => 'Sector';

  @override
  String get editBusinessLockedNote =>
      'Kind and sector are fixed after setup — changing them would reset your health score.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsEdit => 'Edit';

  @override
  String get settingsMyBusinesses => 'My businesses';

  @override
  String get settingsAddBusiness => 'Add new business';

  @override
  String get settingsSeeReport => 'See report';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsValue => 'SMS + in-app alerts on';

  @override
  String get settingsNotificationsNone => 'No alerts right now';

  @override
  String settingsNotificationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alerts to see',
      one: '1 alert to see',
    );
    return '$_temp0';
  }

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsContact => 'Contact us';

  @override
  String get settingsAbout => 'About Khushhal';

  @override
  String get settingsVersion => 'v1.0.0';

  @override
  String get settingsLogOut => 'Log out';

  @override
  String get aboutIntro => 'Khushhal is a money diary for your small business.';

  @override
  String get aboutHowItWorks =>
      'Write down the money that comes in and the money that goes out. It takes one minute a day.';

  @override
  String get aboutScore =>
      'Every month Khushhal gives your business a health score and tells you what to do next.';

  @override
  String get aboutOffline =>
      'It works without network. Your entries stay safe on this phone and go online later.';

  @override
  String get aboutHelpTitle => 'Helpline';

  @override
  String get aboutHelpBody => 'Tap the number to call us.';

  @override
  String get authWelcomeTitle => 'Hurray! Welcome to Khushhal';

  @override
  String get authWhatToCallYou => 'What should we call you?';

  @override
  String get authFirstName => 'First name';

  @override
  String get authLastNameOptional => 'Last name (optional)';

  @override
  String get authSaving => 'Saving…';

  @override
  String authSaveFailed(String reason) {
    return 'Save failed: $reason';
  }

  @override
  String get authContinue => 'Continue';

  @override
  String authWelcomeBack(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get authEnterPin => 'Enter your 4-digit PIN';

  @override
  String get authForgotPin => 'Forgot PIN?';

  @override
  String get authLoginWithMobile => 'Login with mobile number';

  @override
  String get authEnterCode => 'Enter the code';

  @override
  String authSentTo(String phone) {
    return 'Sent to $phone · ';
  }

  @override
  String authResendIn(String secs) {
    return 'Resend in 0:$secs';
  }

  @override
  String get authResendCode => 'Resend code';

  @override
  String get authPhoneTitle => 'Enter your mobile number';

  @override
  String get authPhoneSubtitle =>
      'We will send a 6-digit code by SMS. No password needed.';

  @override
  String get authGetOtp => 'Get OTP';

  @override
  String get authSending => 'Sending…';

  @override
  String get authTooManyTries => 'Too many wrong tries — please sign in again.';

  @override
  String authWrongPin(int left) {
    return 'Wrong mPIN. $left attempts left.';
  }

  @override
  String get authCreatePinTitle => 'Create your PIN';

  @override
  String get authCreatePinSubtitle =>
      'Pick 4 digits you will remember.\nNext time you open the app, just enter this.';

  @override
  String get authConfirmPinTitle => 'Type it again';

  @override
  String get authConfirmPinSubtitle =>
      'Enter the same 4 digits once more to confirm.';

  @override
  String get authPinMismatch => 'The PINs do not match. Try again.';
}
