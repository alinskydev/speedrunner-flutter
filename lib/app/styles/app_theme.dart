import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData? data = ThemeData(
    fontFamily: 'Oswald',
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.zero),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        )),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.green,
    ),
  );
}
