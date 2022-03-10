import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/libraries/views.dart' as views;

class AppSettings {
  static bool isDebug = true;

  static Widget currentView = views.AppHome();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  static Uri apiUri = Uri(
    scheme: 'http',
    host: '10.0.2.2',
  );
}
