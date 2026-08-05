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
}
