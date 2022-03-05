import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;

class AppNotificator {
  BuildContext context;

  AppNotificator(this.context);

  void sendMessage({
    required Widget message,
    Color? backgroundColor,
  }) {
    backgroundColor ??= Theme.of(context).colorScheme.primary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.all(15),
        backgroundColor: backgroundColor,
        content: Container(
          child: message,
        ),
      ),
    );
  }
}
