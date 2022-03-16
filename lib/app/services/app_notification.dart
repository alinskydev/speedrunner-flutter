import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;

class AppNotificator {
  BuildContext context;

  AppNotificator(this.context);

  void sendMessage(
    String message, {
    Color? color,
  }) {
    Color backgroundColor;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.all(15),
        backgroundColor: color ?? base.Singletons.style.colors.primary,
        content: Container(
          child: Text(message),
        ),
      ),
    );
  }
}
