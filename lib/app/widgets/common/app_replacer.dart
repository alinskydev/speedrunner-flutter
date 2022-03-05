import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class AppReplacer extends StatefulWidget {
  Widget Function(BuildContext context, _AppReplacerState replacerState) builder;

  AppReplacer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<AppReplacer> createState() => _AppReplacerState();
}

class _AppReplacerState extends State<AppReplacer> {
  Widget? deletedWidget;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: deletedWidget ?? widget.builder(context, this),
    );
  }

  void process({
    Widget replacer = const SizedBox.shrink(),
  }) async {
    setState(() {
      deletedWidget = replacer;
    });
  }
}
