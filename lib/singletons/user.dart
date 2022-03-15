import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String? authToken;
  bool isAuthorized = false;

  User._init();

  static Future<User> init() async {
    User instance = User._init();
    instance.authToken = await _storage.read(key: 'authToken');
    instance.isAuthorized = instance.authToken != null;

    return instance;
  }

  Future<void> login(String token) async {
    authToken = 'Basic ${base64Encode(utf8.encode('$token:'))}';
    isAuthorized = true;

    _storage.write(key: 'authToken', value: authToken);
  }

  Future<void> logout() async {
    authToken = null;
    isAuthorized = false;

    _storage.delete(key: 'authToken');
  }
}
