import 'dart:async';

import 'package:flutter/material.dart';

import '/libraries/services.dart' as services;

class I18N {
  static String defaultLanguage = 'en';
  static String language = defaultLanguage;

  static StreamController<String> controller = StreamController<String>.broadcast();

  static Map<String, Map> availableLanguages = {
    'en': {
      'code': 'en',
      'label': 'English',
      'locale': Locale('en', ''),
    },
    'ru': {
      'code': 'ru',
      'label': 'Russian',
      'locale': Locale('ru', ''),
    },
    'de': {
      'code': 'de',
      'label': 'German',
      'locale': Locale('de', ''),
    },
  };

  static Map<String, Map> messages = {};

  static Future<void> setLanguage(String? newLanguage) async {
    language = newLanguage ?? defaultLanguage;
    await services.SRSharedStorage().setData('language', language);

    controller.add(language);
  }

  static String getMessage(String key, [Map<String, dynamic>? params = null]) {
    String message = messages[key]?[language] ?? '';

    if (params != null) {
      params.forEach((key, value) {
        message = message.replaceAll("{$key}", value);
      });
    }

    return message;
  }
}
