import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  static String? authToken;
  static bool isAuthorized = false;

  static Future<void> login(String token) async {
    authToken = 'Basic ${base64Encode(utf8.encode('$token:'))}';
    isAuthorized = true;

    FlutterSecureStorage().write(key: 'authToken', value: authToken);
  }

  static Future<void> logout() async {
    authToken = null;
    isAuthorized = false;

    FlutterSecureStorage().delete(key: 'authToken');
  }
}
