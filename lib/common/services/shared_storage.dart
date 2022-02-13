import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage {
  Future<dynamic> getData(String key, Type type) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case bool:
        return prefs.getBool(key);
      case double:
        return prefs.getDouble(key);
      case int:
        return prefs.getInt(key);
      case String:
        return prefs.getString(key);
      case List:
        return prefs.getStringList(key);
    }

    return Future<void>.value(null);
  }

  Future<bool> setData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case bool:
        return prefs.setBool(key, value);
      case double:
        return prefs.setDouble(key, value);
      case int:
        return prefs.setInt(key, value);
      case String:
        return prefs.setString(key, value);
      case List:
        return prefs.setStringList(key, value);
    }

    return Future<bool>.value(false);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
