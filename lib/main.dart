import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runZonedGuarded(() async {
    await base.Bootstrap.init();

    runApp(App());
  }, (error, stack) {
    runApp(App());
  });
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: base.Singletons.intl.controller.stream,
      initialData: base.Singletons.intl,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Speedrunner',
          navigatorKey: base.Singletons.settings.navigatorKey,
          theme: base.Singletons.style.theme,
          locale: Locale(base.Singletons.intl.language, ''),
          supportedLocales: base.Singletons.intl.availableLanguages.map((e) => Locale(e['code'], '')),
          localizationsDelegates: const [
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
