import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Settings {
  bool isDebug = true;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  Uri apiUri = Uri(
    scheme: 'http',
    host: '10.0.2.2',
  );

  Settings._init();
  static Future<Settings> init() async => Settings._init();
}
