import 'package:flutter/material.dart';

class _Colors {
  final Color primary = const Color(0xFF00BCD4);
  final Color success = const Color(0xFF00FF37);
  final Color secondary = const Color(0xff5c6c87);
  final Color error = const Color(0xFFAF0808);
}

class _FontSizes {
  final double bodyMedium = 16;
  final double headlineMedium = 30;
  final double labelMedium = 16;
}

class Style {
  _Colors colors = _Colors();
  _FontSizes fontSizes = _FontSizes();

  ThemeData get theme {
    return ThemeData(
      fontFamily: 'Oswald',
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        background: Colors.white,
        onBackground: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        primary: colors.primary,
        primaryContainer: Colors.black,
        onPrimary: Colors.white,
        secondary: colors.secondary,
        secondaryContainer: Color(0xffa1a1a1),
        onSecondary: Colors.white,
        surface: Color(0xff1c1f1f),
        onSurface: Colors.black,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: fontSizes.bodyMedium),
        headlineMedium: TextStyle(fontSize: fontSizes.headlineMedium),
        labelMedium: TextStyle(fontSize: fontSizes.labelMedium),
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

  Style._init();
  static Future<Style> init() async => Style._init();
}
