import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'app_localizations.dart';

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).translate(key);
}

const String ENGLISH = 'en';
const String TURKISH = 'tr';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;
    case TURKISH:
      _temp = Locale(languageCode, 'TR');
      break;
    default:
      _temp = Locale(ENGLISH, 'US');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  String locale = await Devicelocale.currentLocale;
  locale = locale.split('_')[0];

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs == null && ['en', 'tr'].contains(locale)) {
    String languageCode = locale;
    return _locale(languageCode);
  } else {
    String languageCode = _prefs.getString(LANGUAGE_CODE) ?? locale;
    return _locale(languageCode);
  }
}
