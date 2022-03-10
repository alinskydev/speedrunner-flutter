import 'package:flutter/material.dart';

class AppStyle {
  static _AppColors colors = _AppColors();
  static _AppFontSizes fontSizes = _AppFontSizes();
}

class _AppColors {
  final Color primary = Color(0xFF00BCD4);
  final Color secondary = Color(0xff5c6c87);
}

class _AppFontSizes {
  final double bodyMedium = 16;
  final double headlineMedium = 30;
  final double labelMedium = 16;
}
