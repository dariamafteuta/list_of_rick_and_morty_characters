import 'package:flutter/material.dart';

import 'app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;
  AppColors get colors => _isDark ? DarkThemeColors() : LightThemeColors();
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

ThemeData themeDataFromAppColors(AppColors colors) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: colors.backgroundColor,
    primaryColor: colors.mainColor,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.appBarColor,
      foregroundColor: colors.appBarTextColor,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: colors.appBarTextColor),
      bodyMedium: TextStyle(color: colors.appBarTextColor),
    ),
    iconTheme: IconThemeData(color: colors.iconColor),
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.mainColor,
      brightness: colors.brightness,
    ),
  );
}
