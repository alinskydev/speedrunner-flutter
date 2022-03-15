library app_bootstrap;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '/libraries/base.dart' as base;

part 'extensions.dart';

class Bootstrap {
  static Future<void> init() async {
    await _initBase();
    await base.Singletons.init();
  }

  static Future<void> _initBase() async {
    // FlutterError.onError = (details) {
    //   FlutterError.presentError(details);
    //   exit(1);
    // };
  }
}
