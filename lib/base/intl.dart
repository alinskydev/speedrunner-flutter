import 'dart:async';

import '/libraries/base.dart' as base;

class Intl {
  static const String _defaultLanguage = 'en';
  static String language = _defaultLanguage;

  static StreamController<String> controller = StreamController.broadcast();

  static List<Map> availableLanguages = [
    {
      'code': 'en',
      'label': 'English',
    },
    {
      'code': 'ru',
      'label': 'Russian',
    },
    {
      'code': 'de',
      'label': 'German',
    },
  ];

  static Map<String, Map> messages = {};

  static Future<void> setLanguage(String newLanguage) async {
    await base.Singletons.sharedStorage.setData('language', newLanguage);
    controller.add(newLanguage);
  }

  static String getMessage(String key, [Map<String, dynamic>? params]) {
    String message = messages[key]?[language] ?? '';

    if (params != null) {
      params.forEach((key, value) {
        message = message.replaceAll("{$key}", value);
      });
    }

    return message;
  }
}
