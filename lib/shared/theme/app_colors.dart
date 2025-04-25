import 'package:flutter/material.dart';

abstract class AppColors {
  Color get appBarColor;
  Color get appBarTextColor;
  Color get iconColor;
  Color get backgroundColor;
  Color get loaderColor;
  Color get accentColor;
  Color get mainColor;
  Color get textColor;
  Color get inactiveIconColor;
  Brightness get brightness;
}

class LightThemeColors implements AppColors {
  @override
  Color get appBarColor => const Color(0xFF21C065);

  @override
  Color get appBarTextColor => Colors.white;

  @override
  Color get iconColor => Colors.white;

  @override
  Color get backgroundColor => const Color(0xFFF5F5F5);

  @override
  Color get loaderColor => Colors.grey;

  @override
  Color get accentColor => Colors.amberAccent;

  @override
  Color get mainColor => const Color(0xFF21C065);

  @override
  Color get textColor => Colors.black87;

  @override
  Color get inactiveIconColor => Colors.black38;

  @override
  Brightness get brightness => Brightness.light;
}

class DarkThemeColors implements AppColors {
  @override
  Color get appBarColor => const Color(0xFF118049);

  @override
  Color get appBarTextColor => Colors.white;

  @override
  Color get iconColor => Colors.white70;

  @override
  Color get backgroundColor => const Color(0xFF1C1C1E);

  @override
  Color get loaderColor => Colors.white38;

  @override
  Color get accentColor => Colors.amberAccent;

  @override
  Color get mainColor => const Color(0xFF118049);

  @override
  Color get textColor => Colors.white;

  @override
  Color get inactiveIconColor => Colors.white38;

  @override
  Brightness get brightness => Brightness.dark;
}
