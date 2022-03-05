import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/views.dart' as views;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await base.Bootstrap.init();

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState? of(BuildContext context) => context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: base.I18N.controller.stream,
        initialData: base.I18N.language,
        builder: (context, snapshot) {
          String language = snapshot.data as String;

          return MaterialApp(
            title: 'Speedrunner CMS',
            navigatorKey: config.AppSettings.navigatorKey,
            theme: config.AppTheme.data,
            locale: Locale(language, ''),
            supportedLocales: base.I18N.availableLanguages.values.map((e) => e['locale']),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            builder: (context, child) {
              return child!;
            },
            home: views.AppHome(),
          );
        });
  }
}
