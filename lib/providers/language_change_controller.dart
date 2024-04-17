import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  Future<void> changeLanguage(Locale type) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      _appLocale = type;

      if (type == Locale('en')) {
        await sp.setString('language_code', 'en');
      } else {
        await sp.setString('language_code', 'hi');
      }

      // Save the selected language index as well
      await sp.setInt('languageIndex', type == Locale('en') ? 0 : 1);

      // Notify listeners after making changes
      notifyListeners();
    } catch (e) {
      print('Error changing language: $e');
    }
  }

  // Function to load the selected language from SharedPreferences
  Future<void> loadSelectedLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final languageIndex = sp.getInt('languageIndex') ?? 0; // Default to English if not found
    _appLocale = Locale.fromSubtags(languageCode: languageIndex == 0 ? 'en' : 'hi');
    notifyListeners();
  }
}
