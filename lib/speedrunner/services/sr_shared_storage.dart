import 'package:shared_preferences/shared_preferences.dart';

class SRSharedStorage {
  final Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

  Future<dynamic> getData(String key, Type type) async {
    final SharedPreferences prefs = await sharedPreferences;

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
    final SharedPreferences prefs = await sharedPreferences;

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
    final SharedPreferences prefs = await sharedPreferences;
    return prefs.remove(key);
  }
}
