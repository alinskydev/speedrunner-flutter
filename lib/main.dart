import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await base.Bootstrap.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: base.Config.navigatorKey,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.blue,
        ),
      ),
      builder: (context, child) {
        return child!;
      },
      home: views.Home(),
    );
  }
}
