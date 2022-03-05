import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/views.dart' as views;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await base.Bootstrap.init();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: base.Intl.controller.stream,
      initialData: base.Intl.language,
      builder: (context, snapshot) {
        String language = snapshot.data as String;

        return MaterialApp(
          title: 'Speedrunner CMS',
          navigatorKey: config.AppSettings.navigatorKey,
          theme: config.AppTheme.data,
          locale: Locale(language, ''),
          supportedLocales: base.Intl.availableLanguages.values.map((e) => e['locale']),
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
      },
    );
  }
}
