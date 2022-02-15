import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/libraries/base.dart' as base;

class Bootstrap {
  static Future<void> init() async {
    Map<String, String> storage = await FlutterSecureStorage().readAll();

    base.User.authToken = storage['authToken'];
    base.User.isAuthorized = base.User.authToken != null;
  }
}
