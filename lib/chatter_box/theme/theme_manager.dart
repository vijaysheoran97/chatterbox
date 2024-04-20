import 'package:flutter/material.dart';

import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeManager with ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  ThemeManager(String? selectedTheme) {
    if (selectedTheme != null) {
      switch (selectedTheme) {
        case 'light':
          _currentTheme = lightTheme;
          break;
        case 'dark':
          _currentTheme = darkTheme;
          break;
      }
    }
  }

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}