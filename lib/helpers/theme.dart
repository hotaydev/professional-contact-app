import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App Dark Theme
ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'OpenSans',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
  primaryTextTheme: ThemeData.dark().primaryTextTheme.apply(
        fontFamily: 'OpenSans',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
  scaffoldBackgroundColor: Color(0xFF181818),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF181818),
    foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  textSelectionTheme: ThemeData.dark().textSelectionTheme.copyWith(
        cursorColor: Colors.blue.shade500,
        selectionColor: Colors.blue.shade200,
        selectionHandleColor: Colors.blue.shade500,
      ),
);

/// App Light Theme
ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'OpenSans',
        bodyColor: Colors.grey.shade900,
        displayColor: Colors.grey.shade900,
      ),
  primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
        fontFamily: 'OpenSans',
        bodyColor: Colors.grey.shade900,
        displayColor: Colors.grey.shade900,
      ),
  scaffoldBackgroundColor: Color(0xFFFDFDFD),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFDFDFD),
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  textSelectionTheme: ThemeData.light().textSelectionTheme.copyWith(
        cursorColor: Colors.blue.shade800,
        selectionColor: Colors.blue.shade200,
        selectionHandleColor: Colors.blue.shade800,
      ),
);

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
