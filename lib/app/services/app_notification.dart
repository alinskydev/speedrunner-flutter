import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;

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
        backgroundColor = base.Singletons.style.colors.primary;
        break;
      case AppNotificatorTypes.success:
        backgroundColor = base.Singletons.style.colors.success;
        break;
      case AppNotificatorTypes.error:
        backgroundColor = base.Singletons.style.colors.error;
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
