library app_bootstrap;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;
import '/libraries/singletons.dart' as singletons;

part 'extensions.dart';

class Bootstrap {
  static Future<void> init() async {
    await _initBase();
    await _initSingletons();
    await _initIntl();
    await _initUser();
  }

  static Future<void> _initBase() async {
    if (!config.AppSettings.isDebug) {
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        exit(1);
      };
    }
  }

  static Future<void> _initSingletons() async {
    base.Singletons.sharedStorage = await singletons.AppSharedStorage.init();
    base.Singletons.fileStorage = await singletons.AppFileStorage.init();
    base.Singletons.cart = await singletons.AppCart.init();
  }

  static Future<void> _initIntl() async {
    String? language = await base.Singletons.sharedStorage.getData('language', String);
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

  static Future<void> _initUser() async {
    base.User.authToken = await FlutterSecureStorage().read(key: 'authToken');
    base.User.isAuthorized = base.User.authToken != null;
  }
}
