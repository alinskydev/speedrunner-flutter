import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage {
  late final SharedPreferences _preferences;

  SharedStorage._init();

  static Future<SharedStorage> init() async {
    SharedStorage instance = SharedStorage._init();
    instance._preferences = await SharedPreferences.getInstance();

    return instance;
  }

  Future<dynamic> getData(String key, Type type) async {
    switch (type) {
      case bool:
        return _preferences.getBool(key);
      case double:
        return _preferences.getDouble(key);
      case int:
        return _preferences.getInt(key);
      case String:
        return _preferences.getString(key);
      case List:
        return _preferences.getStringList(key);
    }

    return Future<void>.value(null);
  }

  Future<bool> setData(String key, dynamic value) async {
    switch (value.runtimeType) {
      case bool:
        return _preferences.setBool(key, value);
      case double:
        return _preferences.setDouble(key, value);
      case int:
        return _preferences.setInt(key, value);
      case String:
        return _preferences.setString(key, value);
      case List:
        return _preferences.setStringList(key, value);
    }

    return Future<bool>.value(false);
  }

  Future<bool> remove(String key) async {
    return _preferences.remove(key);
  }
}
