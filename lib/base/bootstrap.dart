import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;

class Bootstrap {
  static Map<String, String> secureStorage = {};

  static Future<void> init() async {
    secureStorage = await FlutterSecureStorage().readAll();

    await initI18N();
    await initUser();
    await initCart();
  }

  static Future<void> initI18N() async {
    String? language = await services.SRSharedStorage().getData('language', String);
    await base.I18N.setLanguage(language);

    base.I18N.messages = await services.SRApiRequest(
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
    base.User.authToken = secureStorage['authToken'];
    base.User.isAuthorized = base.User.authToken != null;
  }

  static Future<void> initCart() async {
    Map<String, dynamic> data = await services.SRSharedStorage().getData('cart', String).then((value) {
      return value != null ? jsonDecode(value) : {};
    });

    if (data.isNotEmpty) services.Cart.changeAll(data);
  }
}
