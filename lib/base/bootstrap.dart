import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;

class Bootstrap {
  static Map<String, String> secureStorage = {};

  static Future<void> init() async {
    secureStorage = await FlutterSecureStorage().readAll();

    await initUser();
    await initCart();
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
