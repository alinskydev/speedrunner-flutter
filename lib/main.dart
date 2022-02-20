import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/base.dart' as base;
import '/libraries/bloc.dart' as bloc;
import '/libraries/styles.dart' as styles;
import '/libraries/views.dart' as views;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await base.Bootstrap.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: base.Config.navigatorKey,
      theme: styles.AppTheme.data,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => bloc.CartCubit()),
          ],
          child: child!,
        );
      },
      home: views.AppHome(),
    );
  }
}
