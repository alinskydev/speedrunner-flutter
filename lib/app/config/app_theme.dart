import 'package:flutter/material.dart';

import '/libraries/config.dart' as config;

class AppTheme {
  static ThemeData? data = ThemeData(
    fontFamily: 'Oswald',
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: Colors.white,
      onBackground: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      primary: config.AppStyle.colors.primary,
      primaryContainer: Colors.black,
      onPrimary: Colors.white,
      secondary: config.AppStyle.colors.secondary,
      secondaryContainer: Color(0xffa1a1a1),
      onSecondary: Colors.white,
      surface: Color(0xff1c1f1f),
      onSurface: Colors.black,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: config.AppStyle.fontSizes.bodyMedium),
      headlineMedium: TextStyle(fontSize: config.AppStyle.fontSizes.headlineMedium),
      labelMedium: TextStyle(fontSize: config.AppStyle.fontSizes.labelMedium),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.green,
    ),
  );
}
