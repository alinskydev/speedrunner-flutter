import 'package:flutter/material.dart';

class AppStyle {
  static Map<String, Color> colors = {
    'primary': Color(0xFF00BCD4),
    'secondary': Color(0xff5c6c87),
  };

  static Map<String, double> fontSizes = {
    'default': 16,
    'cart': 20,
  };

  static Color getColor(String key) => colors[key] ?? colors['primary']!;
  static double getFontSize(String key) => fontSizes[key] ?? fontSizes['default']!;
}
