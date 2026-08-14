// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get brandName => 'खुशहाल';

  @override
  String get brandTagline => 'आपके बिज़नेस का हेल्थ कार्ड';

  @override
  String get languageHeading => 'अपनी भाषा चुनें';

  @override
  String get languageSubheading => 'इसे बाद में सेटिंग्स में बदल सकते हैं।';

  @override
  String get languageSubtitleHindi => 'हिंदी (भारत)';

  @override
  String get languageSubtitleEnglish => 'अंग्रेज़ी';

  @override
  String get languageMoreComingSoon => 'और भाषाएँ जल्द आ रही हैं';

  @override
  String get languageContinue => 'आगे बढ़ें';

  @override
  String get languageOfflineFootnote => 'सेटअप के बाद बिना इंटरनेट चलेगा';

  @override
  String get onboardingContinue => 'आगे बढ़ें';

  @override
  String onboardingStepOf(int current, int total) {
    return '$total में से $current कदम';
  }

  @override
  String get uspForecastTitle => '6 महीने आगे देखें';

  @override
  String get uspForecastBody =>
      'आपकी रोज़ की एंट्री से अगले 6 महीने का पैसा — आमदनी, खर्चा और EMI — पहले से दिख जाएगा।';

  @override
  String get uspForecastImage => 'बढ़ता चार्ट, जिसमें से पत्तियाँ निकल रही हैं';

  @override
  String get uspOnePlaceTitle => 'सब कुछ एक जगह';

  @override
  String get uspOnePlaceBody =>
      'बिक्री, खर्चा, कर्ज़, स्टॉक — आपका पूरा बिज़नेस एक ही हेल्थ कार्ड पर।';

  @override
  String get uspOnePlaceImage => 'हथेली पर कार्ड, चारों ओर छोटे आइकन';

  @override
  String get uspActionsTitle => 'जोखिम कम करने के आसान कदम';

  @override
  String get uspActionsBody =>
      'हर चेतावनी के साथ यह भी कि आगे क्या करना है — आसान कदम, सीधी भाषा में।';

  @override
  String get uspActionsImage => 'पत्ती के निशान वाली चेकलिस्ट';

  @override
  String get uspOfflineTitle => 'बिना इंटरनेट भी चलता है';

  @override
  String get uspOfflineBody =>
      'बिना नेटवर्क पूरे दिन एंट्री करें। सिग्नल आते ही सब अपने आप सिंक हो जाएगा।';

  @override
  String get uspOfflineImage => 'फ़ोन पर अंकुर, बिना सिग्नल के शांत दृश्य';

  @override
  String setupStepOf(int step, int total) {
    return '$total में से $step कदम';
  }

  @override
  String setupStepOfBusiness(int step, int total, String business) {
    return '$total में से $step कदम · $business';
  }

  @override
  String businessN(int n) {
    return 'बिज़नेस $n';
  }

  @override
  String get locationHeading => 'आपका बिज़नेस कहाँ है?';

  @override
  String get locationUseMine => 'मेरी लोकेशन इस्तेमाल करें';

  @override
  String get locationOneTap => '1 टैप';

  @override
  String get locationMapHint => 'नक्शा — पिन यहाँ गिरेगा';

  @override
  String get locationDetectedLabel => 'मिली लोकेशन';

  @override
  String get locationDetectedValue => 'गाँव रामपुर · सीतापुर · यूपी';

  @override
  String get locationDetectedMandi => 'सबसे पास की मंडी: सीतापुर (4 किमी)';

  @override
  String get locationPickByHand => 'या खुद चुनें:';

  @override
  String get locationState => 'राज्य';

  @override
  String get locationDistrict => 'ज़िला';

  @override
  String get locationVillage => 'गाँव';

  @override
  String get locationWhy =>
      'लोकेशन क्यों? आपकी मंडी के भाव, मौसम की चेतावनी और सीज़न — सब आपके अनुमान में काम आते हैं।';

  @override
  String get locationConfirmCta => 'लोकेशन पक्की करें';

  @override
  String get countHeading => 'आप कितने बिज़नेस चलाते हैं?';

  @override
  String get countFourPlus => '4+';

  @override
  String get countNote =>
      'बस गिनती बताएँ — अगली स्क्रीन पर हर बिज़नेस एक-एक करके सेट होगा।';

  @override
  String get setupNextCta => 'आगे';

  @override
  String get hubTitle => 'बिज़नेस सेट करें';

  @override
  String hubDoneOf(int done, int total) {
    return '$total में से $done पूरे';
  }

  @override
  String get hubHeading => 'हर बिज़नेस सेट करें';

  @override
  String get hubStatusNotStarted => 'अभी शुरू नहीं';

  @override
  String get hubStatusDone => 'हो गया';

  @override
  String get hubTaskKind => 'किस्म और काम';

  @override
  String get hubTaskDetails => 'जानकारी — नाम, कब से, लोग';

  @override
  String get hubTaskMoney => 'महीने का पैसा';

  @override
  String get hubTaskPending => 'बाकी';

  @override
  String get hubStartCta => 'सेटअप शुरू करें';

  @override
  String get hubFinishCta => 'पूरा करें';

  @override
  String get hubFinishHint =>
      '1 पूरा होने पर भी आगे बढ़ सकते हैं, बाकी बाद में जोड़ लें';

  @override
  String get hubAddAnother => 'नया बिज़नेस जोड़ें';

  @override
  String get kindHeading => 'कैसा बिज़नेस है?';

  @override
  String get segmentPrompt => 'मैं हूँ…';

  @override
  String get segmentShg => 'SHG';

  @override
  String get segmentFpo => 'FPO';

  @override
  String get segmentOwn => 'अपना';

  @override
  String get sectorPrompt => 'मेरा काम है…';

  @override
  String get sectorDairy => 'डेयरी';

  @override
  String get sectorPoultry => 'मुर्गी पालन';

  @override
  String get sectorFoodProcessing => 'फ़ूड प्रोसेसिंग';

  @override
  String get sectorCrafts => 'हस्तशिल्प';

  @override
  String get sectorShop => 'दुकान';

  @override
  String get sectorOther => 'और कुछ';

  @override
  String get kindDairyHint =>
      'डेयरी चुनी: सर्दी का फ्लश सीज़न और सीतापुर के चारे के भाव अपने आप जुड़ गए।';

  @override
  String get kindPoultryHint =>
      'मुर्गी पालन चुना: दाने की क़ीमत में उतार-चढ़ाव और गर्मी की चेतावनियाँ आपके इलाके के हिसाब से जुड़ेंगी।';

  @override
  String get kindFoodProcessingHint =>
      'फ़ूड प्रोसेसिंग चुना: कच्चे माल की क़ीमत और मानसून की माँग का असर आपके अनुमान में जुड़ेगा।';

  @override
  String get kindCraftsHint =>
      'हस्तशिल्प चुना: कच्चे माल का सीज़न और त्यौहारों की माँग आपके अनुमान में शामिल होगी।';

  @override
  String get kindShopHint =>
      'दुकान चुनी: स्थानीय बिक्री, मंडी की छुट्टियाँ और स्टॉक चक्र आपके अनुमान में जुड़ेंगे।';

  @override
  String get kindOtherHint =>
      'फ़िलहाल सिर्फ़ आपकी एंट्री से चलेगा — जितने महीने लिखेंगे, स्कोर उतना सटीक होगा।';

  @override
  String get detailsHeading => 'अपने बिज़नेस के बारे में';

  @override
  String get detailsNameLabel => 'बिज़नेस का नाम';

  @override
  String get detailsSinceLabel => 'कब से चल रहा है';

  @override
  String get tenureUnderOneYear => '1 साल से कम';

  @override
  String get tenureOneToThree => '1–3 साल';

  @override
  String get tenureThreeToTen => '3–10 साल';

  @override
  String get tenureTenPlus => '10+ साल';

  @override
  String get detailsStaffLabel => 'काम करने वाले लोग (आप मिलाकर)';

  @override
  String get moneyHeading => 'आपका हर महीने का पैसा';

  @override
  String get moneyModeRough => 'मोटा अंदाज़ा';

  @override
  String get moneyModeRecords => 'मेरे हिसाब से';

  @override
  String get moneyInLabel => 'पैसा आया (बिक्री)';

  @override
  String moneyInMonthLabel(String month) {
    return 'पैसा आया (बिक्री) · $month';
  }

  @override
  String get moneyOutLabel => 'पैसा गया (खर्चा)';

  @override
  String get moneyEmiLabel => 'कर्ज़ की EMI';

  @override
  String get moneySavingsLabel => 'आज की बचत';

  @override
  String get moneyRecordsNote => 'अपनी डायरी से पिछले महीने के कुल लिखें।';

  @override
  String get moneyMoreMonths =>
      'और महीने हैं? सेटअप के बाद जोड़ें — जितने महीने, उतना सही अनुमान।';

  @override
  String get moneySeeCardCta => 'मेरा हेल्थ कार्ड देखें';

  @override
  String get homeSwitchHint => 'बिज़नेस बदलने के लिए नाम पर टैप करें';

  @override
  String get chipSynced => 'सिंक हो गया';

  @override
  String get chipSyncing => 'सिंक हो रहा है…';

  @override
  String get chipOffline => 'ऑफ़लाइन';

  @override
  String scoreAsOn(String date) {
    return '$date का स्कोर';
  }

  @override
  String get scoreNew => 'नया';

  @override
  String healthHeadlineLow(String name) {
    return '$name: सेहतमंद';
  }

  @override
  String healthHeadlineMedium(String name) {
    return '$name: ध्यान चाहिए';
  }

  @override
  String healthHeadlineHigh(String name) {
    return '$name: जोखिम में';
  }

  @override
  String healthSummaryLow(int score) {
    return 'बिज़नेस अच्छा चल रहा है · स्कोर $score/100';
  }

  @override
  String healthSummaryMedium(int score) {
    return 'बिज़नेस को थोड़ा ध्यान चाहिए · स्कोर $score/100';
  }

  @override
  String healthSummaryHigh(int score) {
    return 'बिज़नेस पर दबाव है · स्कोर $score/100';
  }

  @override
  String scoreOutOf(int score) {
    return 'स्कोर $score/100';
  }

  @override
  String get riskLowBadge => 'कम जोखिम';

  @override
  String get riskMediumBadge => 'मध्यम जोखिम';

  @override
  String get riskHighBadge => 'ज़्यादा जोखिम';

  @override
  String homeNextUpdate(String date) {
    return 'अगला अपडेट $date';
  }

  @override
  String homeDaysWritten(int written, int days) {
    return '$days में से $written दिन लिखे';
  }

  @override
  String homeDayOf30(int day) {
    return '30 में से $day दिन';
  }

  @override
  String homeScoreAsOf(String date) {
    return '$date का स्कोर';
  }

  @override
  String homeMonthJustStarted(String month) {
    return '$month अभी शुरू हुआ है';
  }

  @override
  String get homeScoreNote =>
      'स्कोर हर 30 दिन में बदलता है। रोज़ की एंट्री अगला स्कोर बनाती है।';

  @override
  String get tileMoneyIn => 'पैसा आया';

  @override
  String get tileMoneyOut => 'पैसा गया';

  @override
  String get tileThisMonth => 'इस महीने';

  @override
  String get tileSavings => 'बचत';

  @override
  String get tileLoan => 'कर्ज़';

  @override
  String get tileTapToEdit => 'बदलने के लिए टैप करें';

  @override
  String tileMovedFrom(String amount, String month) {
    return 'पहले $amount · $month';
  }

  @override
  String tileMovedFromPlain(String amount) {
    return 'पहले $amount';
  }

  @override
  String get homeWatch => 'नज़र रखें';

  @override
  String watchTitle(String month) {
    return '$month में तंगी हो सकती है';
  }

  @override
  String get watchTitleNoMonth => 'आगे पैसे की तंगी हो सकती है';

  @override
  String get watchReasonMandi => 'सीतापुर में चारे का भाव बढ़ रहा है।';

  @override
  String get watchReasonScore => 'आपके ताज़ा स्कोर के हिसाब से।';

  @override
  String get watchReasonForecast => 'नए अनुमान के हिसाब से।';

  @override
  String get watchAction => 'यह करें: समूह के साथ चारा पहले ही खरीद लें';

  @override
  String get watchSeePlan => 'यह करें: देखें क्या करना है';

  @override
  String get homeWriteEntryCta => 'आज की एंट्री लिखें';

  @override
  String homeMonthClosedBanner(String month) {
    return '$month पूरा हुआ — नया स्कोर तैयार है';
  }

  @override
  String get homeSeeChangedCta => 'देखें क्या बदला';

  @override
  String get navHome => 'होम';

  @override
  String get navHistory => 'हिसाब';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String offlineBanner(int count) {
    return 'नेटवर्क नहीं है — फिर भी सब चलता है। $count एंट्री बाद में सिंक होंगी।';
  }

  @override
  String get offlineHealthHeadline => 'बिज़नेस सेहतमंद है';

  @override
  String offlineScoreLine(int score, String date) {
    return 'स्कोर $score/100 · $date का';
  }

  @override
  String offlineMandiStale(int days) {
    return 'मंडी के भाव $days दिन पुराने';
  }

  @override
  String get addEntryTitle => 'एंट्री जोड़ें';

  @override
  String get addEntrySavesOffline => 'ऑफ़लाइन भी सेव';

  @override
  String get entryIn => 'आया';

  @override
  String get entryOut => 'गया';

  @override
  String get addEntryAmount => 'रकम';

  @override
  String get addEntryWhatFor => 'किस लिए?';

  @override
  String get categoryMilkSale => 'दूध बिक्री';

  @override
  String get categoryFodder => 'चारा';

  @override
  String get categoryVet => 'पशु डॉक्टर';

  @override
  String get categoryEmi => 'EMI';

  @override
  String get categoryOther => 'और कुछ';

  @override
  String addEntryMonthNote(String month, String date) {
    return '$month में जुड़ेगा · स्कोर $date को बदलेगा';
  }

  @override
  String get saveCta => 'सेव करें';

  @override
  String forecastMadeOn(String date, String next) {
    return '$date को बना · अगला अनुमान $next';
  }

  @override
  String get forecastHeading => 'आपके पैसे के अगले 6 महीने';

  @override
  String forecastInsightTitle(String month) {
    return '$month में पैसा गया, पैसा आया से ज़्यादा हो सकता है।';
  }

  @override
  String forecastInsightWhy(String amount) {
    return 'अनुमान है कि उस महीने पैसा गया, पैसा आया से ऊपर रहेगा। आज आपके पास $amount की बचत है — सहारा वही बनेगी।';
  }

  @override
  String get forecastNoRiskTitle =>
      'अगले 6 महीनों में कोई तंग महीना नहीं दिख रहा।';

  @override
  String get forecastNoRiskWhy =>
      'पूरे छह महीने पैसा आया, पैसा गया से आगे रहता है। एंट्री लिखते रहें — अगले महीने का अनुमान इसे बदल सकता है।';

  @override
  String get whatIfNormal => 'सामान्य';

  @override
  String get whatIfSpike => 'भाव बढ़े तो?';

  @override
  String get whatIfWeather => 'मौसम बिगड़े तो?';

  @override
  String get forecastWhatCta => 'मैं क्या करूँ?';

  @override
  String updateTitle(String month) {
    return 'आपका $month का अपडेट';
  }

  @override
  String updateScoreLabel(String name) {
    return '$name · हेल्थ स्कोर';
  }

  @override
  String updateDeltaFrom(int points, String month) {
    return '$month से $points ऊपर';
  }

  @override
  String get updateWhyMoved => 'क्यों बदला';

  @override
  String reasonMilkIncome(String amount, String month) {
    return 'दूध की कमाई $month के मुकाबले $amount बढ़ी।';
  }

  @override
  String reasonSteadyEntries(int written, int days) {
    return 'आपने $days में से $written दिन एंट्री लिखी — लगातार लिखना काम आता है।';
  }

  @override
  String reasonFodderCost(String amount) {
    return 'चारे का खर्चा $amount बढ़ा — इसने स्कोर रोका।';
  }

  @override
  String get updateBandLabel => 'श्रेणी';

  @override
  String get updateSeeForecastCta => 'नया 6 महीने का अनुमान देखें';

  @override
  String updateFixedNote(String date) {
    return 'आपका स्कोर $date तक वही रहेगा — आज कुछ भी करने से नहीं बदलेगा';
  }

  @override
  String get alertsTitle => 'चेतावनी';

  @override
  String alertsFilterAll(int count) {
    return 'सब ($count)';
  }

  @override
  String alertsFilterUrgent(int count) {
    return 'ज़रूरी ($count)';
  }

  @override
  String get alertsFilterInfo => 'जानकारी';

  @override
  String alertSavingsTitle(String month) {
    return '$month में बचत कम पड़ सकती है';
  }

  @override
  String get alertSavingsTitleNoMonth => 'बचत कम पड़ सकती है';

  @override
  String alertSavingsDetail(String date) {
    return 'आपके ताज़ा अनुमान से · $date को उठी';
  }

  @override
  String get alertSavingsDetailUndated => 'आपके ताज़ा अनुमान से';

  @override
  String get alertSavingsAction => '3 काम देखें';

  @override
  String get alertFodderTitle => 'सीतापुर मंडी में चारा 14% महँगा';

  @override
  String alertFodderDetail(String date) {
    return 'आपके महीने के खर्चे पर असर · $date';
  }

  @override
  String get alertRainTitle => 'इस हफ़्ते तेज़ बारिश के आसार';

  @override
  String get alertRainDetail => 'चारे का स्टॉक बचाएँ · मौसम विभाग';

  @override
  String get alertsSmsNote => 'ऐप ऑफ़लाइन हो तो चेतावनी SMS से भी आती है';

  @override
  String get talkToOfficerCta => 'फ़ील्ड अफ़सर से बात करें';

  @override
  String planTitle(String month) {
    return '$month की योजना';
  }

  @override
  String planTightTitle(String month) {
    return '$month में तंगी दिख रही है';
  }

  @override
  String planTightSubtitle(String from, String to) {
    return 'बचत $from से घटकर $to रह सकती है';
  }

  @override
  String get planDoThese => 'ये 3 काम करें:';

  @override
  String get planFodderTitle => 'समूह के साथ चारा पहले ही खरीद लें';

  @override
  String planFodderBenefit(String amount) {
    return 'भाव बढ़ने से पहले करीब $amount बचेंगे';
  }

  @override
  String planWeeklyTitle(String amount) {
    return 'अब से हर हफ़्ते $amount अलग रखें';
  }

  @override
  String planWeeklyBenefit(String amount, String month) {
    return '$month तक $amount की बचत जुड़ेगी';
  }

  @override
  String get planEmiTitle =>
      'बैंक से EMI की तारीख़ दूध-पेमेंट वाले हफ़्ते में करवाएँ';

  @override
  String get planEmiNote => 'बैंक में यह स्क्रीन दिखाएँ';

  @override
  String get planDoneChip => 'हो गया';

  @override
  String planNote(String month, String amount) {
    return 'काम 1 और 2 करें तो $month की बचत $amount से ऊपर रहेगी। जैसे-जैसे काम पूरे करेंगे, अनुमान तुरंत बदलेगा।';
  }

  @override
  String get savingsLoanTitle => 'बचत और कर्ज़';

  @override
  String get changeCta => 'बदलें';

  @override
  String get savingsHint => 'रकम कभी भी ठीक करने के लिए \'बदलें\' दबाएँ';

  @override
  String get loanHint => 'आपके बताए अनुसार';

  @override
  String get cancelCta => 'रहने दें';

  @override
  String get historyTitle => 'हिसाब';

  @override
  String get historyFilterAll => 'सब';

  @override
  String get historyFilterSalary => 'पगार';

  @override
  String historyInMonth(String month) {
    return 'आया · $month';
  }

  @override
  String historyOutMonth(String month) {
    return 'गया · $month';
  }

  @override
  String get historyLoanPaid => 'कर्ज़ चुकाया';

  @override
  String get historyToday => 'आज';

  @override
  String get historyYesterday => 'कल';

  @override
  String get historyByVoice => 'बोलकर';

  @override
  String get historyWillSync => 'सिंक होगा';

  @override
  String get historyTapToCorrect => 'एंट्री ठीक करने के लिए उस पर टैप करें';

  @override
  String get syncTitle => 'सिंक';

  @override
  String syncSending(int count) {
    return '$count सेव एंट्री भेज रहे हैं…';
  }

  @override
  String get syncWaitingHeader => 'भेजने बाकी';

  @override
  String get syncStatusSent => 'भेज दी';

  @override
  String get syncStatusSending => 'भेज रहे…';

  @override
  String get syncStatusWaiting => 'बाकी';

  @override
  String get syncAutoNote =>
      'नेटवर्क आते ही अपने आप सिंक होता है — यह स्क्रीन खोलने की ज़रूरत नहीं। हफ़्ते में करीब 50 KB लगता है; 2G पर भी चलता है।';

  @override
  String get syncLastFull => 'पिछला पूरा सिंक';

  @override
  String get syncNowCta => 'अभी सिंक करें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsEdit => 'बदलें';

  @override
  String get settingsMyBusinesses => 'मेरे बिज़नेस';

  @override
  String get settingsAddBusiness => 'नया बिज़नेस जोड़ें';

  @override
  String get settingsPreferences => 'पसंद';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsNotifications => 'सूचनाएँ';

  @override
  String get settingsNotificationsValue => 'SMS + ऐप में चेतावनी चालू';

  @override
  String get settingsNotificationsNone => 'अभी कोई चेतावनी नहीं';

  @override
  String settingsNotificationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चेतावनियाँ देखें',
      one: '1 चेतावनी देखें',
    );
    return '$_temp0';
  }

  @override
  String get settingsSupport => 'मदद';

  @override
  String get settingsContact => 'हमसे बात करें';

  @override
  String get settingsAbout => 'खुशहाल के बारे में';

  @override
  String get settingsVersion => 'v1.0.0';

  @override
  String get settingsLogOut => 'लॉग आउट';

  @override
  String get aboutIntro =>
      'खुशहाल आपके छोटे बिज़नेस की हिसाब-किताब की डायरी है।';

  @override
  String get aboutHowItWorks =>
      'जो पैसा आया और जो गया, वह लिख दें। रोज़ एक मिनट लगता है।';

  @override
  String get aboutScore =>
      'हर महीने खुशहाल आपके बिज़नेस को सेहत स्कोर देता है और बताता है कि आगे क्या करें।';

  @override
  String get aboutOffline =>
      'नेटवर्क न हो तो भी चलता है। आपकी एंट्री इस फ़ोन में सुरक्षित रहती है और बाद में ऑनलाइन चली जाती है।';

  @override
  String get aboutHelpTitle => 'हेल्पलाइन';

  @override
  String get aboutHelpBody => 'बात करने के लिए नंबर दबाएँ।';

  @override
  String get authWelcomeTitle => 'स्वागत है खुशहाल में!';

  @override
  String get authWhatToCallYou => 'आपको क्या नाम से पुकारें?';

  @override
  String get authFirstName => 'पहला नाम';

  @override
  String get authLastNameOptional => 'उपनाम (वैकल्पिक)';

  @override
  String get authSaving => 'सेव हो रहा है…';

  @override
  String authSaveFailed(String reason) {
    return 'सेव नहीं हुआ: $reason';
  }

  @override
  String get authContinue => 'आगे बढ़ें';

  @override
  String authWelcomeBack(String name) {
    return 'वापसी पर स्वागत है, $name';
  }

  @override
  String get authEnterPin => 'अपना 4-अंकों का PIN डालें';

  @override
  String get authForgotPin => 'PIN भूल गए? OTP से लॉगिन करें';

  @override
  String get authEnterCode => 'कोड डालें';

  @override
  String authSentTo(String phone) {
    return '$phone पर भेजा · ';
  }

  @override
  String authResendIn(String secs) {
    return 'फिर से भेजें 0:$secs';
  }

  @override
  String get authResendCode => 'फिर से भेजें';

  @override
  String get authPhoneTitle => 'अपना मोबाइल नंबर डालें';

  @override
  String get authPhoneSubtitle =>
      'हम SMS से 6 अंकों का कोड भेजेंगे। पासवर्ड की ज़रूरत नहीं।';

  @override
  String get authGetOtp => 'OTP भेजें';

  @override
  String get authSending => 'भेज रहे हैं…';

  @override
  String get authTooManyTries => 'बहुत बार गलत — कृपया दोबारा साइन इन करें।';

  @override
  String authWrongPin(int left) {
    return 'PIN गलत है। $left कोशिश बाकी।';
  }

  @override
  String get authCreatePinTitle => 'अपना PIN बनाएँ';

  @override
  String get authCreatePinSubtitle =>
      '4 अंक चुनें जो याद रहें।\nअगली बार ऐप खोलते ही यही डालना है।';

  @override
  String get authConfirmPinTitle => 'फिर से टाइप करें';

  @override
  String get authConfirmPinSubtitle =>
      'पक्का करने के लिए वही 4 अंक एक बार और डालें।';

  @override
  String get authPinMismatch => 'PIN मेल नहीं खा रहे। फिर से कोशिश करें।';
}
