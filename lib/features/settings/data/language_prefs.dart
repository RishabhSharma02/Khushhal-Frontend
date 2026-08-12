import 'package:shared_preferences/shared_preferences.dart';

import '../../onboarding/domain/app_language.dart';

/// Persists the user's language choice so we don't re-ask on every launch.
///
/// The `hasSelected` flag is separate from the value so we can distinguish
/// "user hasn't picked yet, use the platform locale as a hint" from "user
/// explicitly picked English on a Hindi device".
class LanguagePrefs {
  static const _kSelected = 'khushhal.lang.hasSelected';
  static const _kValue = 'khushhal.lang.value'; // 'hi' | 'en'

  final SharedPreferences _p;
  LanguagePrefs._(this._p);

  static Future<LanguagePrefs> open() async {
    return LanguagePrefs._(await SharedPreferences.getInstance());
  }

  bool get hasSelected => _p.getBool(_kSelected) ?? false;

  AppLanguage? get saved {
    final v = _p.getString(_kValue);
    if (v == null) return null;
    return v == 'hi' ? AppLanguage.hindi : AppLanguage.english;
  }

  Future<void> save(AppLanguage lang) async {
    await _p.setString(_kValue, lang == AppLanguage.hindi ? 'hi' : 'en');
    await _p.setBool(_kSelected, true);
  }

  Future<void> clear() async {
    await _p.remove(_kSelected);
    await _p.remove(_kValue);
  }
}
