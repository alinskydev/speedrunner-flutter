library app_bootstrap;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;

part 'extensions.dart';

class Bootstrap {
  static Future<void> init() async {
    await initBase();
    await initIntl();
    await initUser();
    await initCart();
  }

  static Future<void> initBase() async {
    if (!config.AppSettings.isDebug) {
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        exit(1);
      };
    }
  }

  static Future<void> initIntl() async {
    String? language = await services.AppSharedStorage().getData('language', String);
    if (language != null) await base.Intl.setLanguage(language);

    base.Intl.messages = await services.AppNetwork(
      path: 'information/translations',
    ).getData().then((value) {
      if (value['body'] is Map) {
        return Map<String, Map>.from(value['body']);
      } else {
        return <String, Map>{};
      }
    });
  }

  static Future<void> initUser() async {
    base.User.authToken = await FlutterSecureStorage().read(key: 'authToken');
    base.User.isAuthorized = base.User.authToken != null;
  }

  static Future<void> initCart() async {
    String? cart = await services.AppSharedStorage().getData('cart', String);
    Map<String, dynamic> data = cart != null ? jsonDecode(cart) : {};

    if (data.isNotEmpty) services.Cart.changeAll(data);
  }
}
