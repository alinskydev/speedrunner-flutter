import 'dart:developer';
import 'package:flutter/material.dart';

import '/libraries/views.dart' as views;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
