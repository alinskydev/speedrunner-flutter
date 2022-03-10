import 'package:flutter/material.dart';

import '/libraries/config.dart' as config;

enum AppNotificatorTypes { primary, success, error }

class AppNotificator {
  BuildContext context;

  AppNotificator(this.context);

  void sendMessage({
    required String message,
    AppNotificatorTypes type = AppNotificatorTypes.primary,
  }) {
    Color backgroundColor;

    switch (type) {
      case AppNotificatorTypes.primary:
        backgroundColor = config.AppStyle.colors.primary;
        break;
      case AppNotificatorTypes.success:
        backgroundColor = config.AppStyle.colors.success;
        break;
      case AppNotificatorTypes.error:
        backgroundColor = config.AppStyle.colors.error;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.all(15),
        backgroundColor: backgroundColor,
        content: Container(
          child: Text(message),
        ),
      ),
    );
  }
}
