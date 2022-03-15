import 'dart:async';

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;

class Intl {
  final String _defaultLanguage = 'en';
  late String language;

  StreamController<Intl> controller = StreamController.broadcast();

  List<Map> availableLanguages = [
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

  Map<String, Map> messages = {};

  Intl._init();

  static Future<Intl> init() async {
    Intl instance = Intl._init();

    String? lang = await base.Singletons.sharedStorage.getData('language', String);
    await instance.setLanguage(lang);

    return instance;
  }

  Future<void> setLanguage(String? newLanguage) async {
    language = newLanguage ?? _defaultLanguage;
    controller.add(this);

    base.Singletons.sharedStorage.setData('language', language);
  }

  String getMessage(String key, [Map<String, dynamic>? params]) {
    String message = messages[key]?[language] ?? '';

    if (params != null) {
      params.forEach((key, value) {
        message = message.replaceAll("{$key}", value);
      });
    }

    return message;
  }
}
