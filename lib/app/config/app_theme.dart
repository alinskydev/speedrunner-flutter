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
      primary: config.AppStyle.getColor('primary'),
      onPrimary: Colors.white,
      secondary: config.AppStyle.getColor('secondary'),
      secondaryVariant: Color(0xffa1a1a1),
      onSecondary: Colors.white,
      primaryVariant: Colors.black,
      surface: Color(0xff1c1f1f),
      onSurface: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        )),
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
