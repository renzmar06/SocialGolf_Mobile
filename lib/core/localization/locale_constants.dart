import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:social_golf_app/main.dart';
import 'package:flutter/material.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";
PreferencesUtil preferences = serviceLocator<PreferencesUtil>();

Future<Locale> setLocale(String languageCode) async {
  await preferences.setPreferencesData(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode =
      preferences.getPreferencesData(prefSelectedLanguageCode) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : const Locale('en', '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var locale = await setLocale(selectedLanguageCode);
  MyApp.setLocale(context, locale);
}
