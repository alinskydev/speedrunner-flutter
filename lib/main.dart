import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await base.Bootstrap.init();

    runApp(App());
  }, (error, stack) {
    services.AppException exception = services.AppExceptionInternalError();
    if (error is services.AppException) exception = error;

    runApp(App(home: views.AppError(exception: exception)));
  });
}

class App extends StatelessWidget {
  Widget? home;

  App({
    Key? key,
    this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: base.Singletons.intl.controller.stream,
      initialData: base.Singletons.intl,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Speedrunner',
          navigatorKey: base.Singletons.settings.navigatorKey,
          theme: config.AppTheme.data,
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
          home: home ?? views.AppHome(),
        );
      },
    );
  }
}
