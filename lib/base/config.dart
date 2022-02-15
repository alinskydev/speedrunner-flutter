import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Config {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  static Map api = {
    'url': 'http://10.0.2.2',
    'scheme': 'http',
    'host': '10.0.2.2',
  };
}
