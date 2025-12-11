import 'package:social_golf_app/core/localization/Language/language_ar.dart';
import 'package:social_golf_app/core/localization/Language/language_en.dart';
import 'package:social_golf_app/core/localization/Language/languages.dart';
import 'package:flutter/material.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    debugPrint("Langgggg---${locale.languageCode}");
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return Languagear();
      default:
        return LanguageEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
