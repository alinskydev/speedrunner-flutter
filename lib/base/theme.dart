import 'package:flutter/material.dart';

class Theme {
  static ThemeData? data = ThemeData(
    buttonTheme: ButtonThemeData(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.green,
    ),
    colorScheme: ColorScheme(
      background: Colors.white,
      onBackground: Colors.black,
      brightness: Brightness.light,
      error: Colors.red,
      onError: Colors.white,
      primary: Colors.cyan,
      onPrimary: Colors.white,
      secondary: Color(0xff5c6c87),
      secondaryVariant: Color(0xffa1a1a1),
      onSecondary: Colors.white,
      primaryVariant: Colors.black,
      surface: Color(0xff1c1f1f),
      onSurface: Colors.white,
    ),
    fontFamily: 'Oswald',
    textTheme: TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.blue,
    ),
  );
}
