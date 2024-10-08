import 'package:flutter/material.dart';

/// App Dark Theme
ThemeData darkTheme = ThemeData.dark().copyWith();

/// App Light Theme
ThemeData lightTheme = ThemeData.light().copyWith();

/// Available app themes
enum ThemeType { light, dark }

/// ## Theme handler for the application
class ThemeHelper extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;
  ThemeType _themeType = ThemeType.light;

  toggleTheme() {
    if (_themeType == ThemeType.dark) {
      currentTheme = lightTheme;
      _themeType = ThemeType.light;
    } else if (_themeType == ThemeType.light) {
      currentTheme = darkTheme;
      _themeType = ThemeType.dark;
    }
    return notifyListeners();
  }

  ThemeType getTheme() {
    return _themeType;
  }
}
