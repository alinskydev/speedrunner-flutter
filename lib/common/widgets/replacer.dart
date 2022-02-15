import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/extensions.dart';
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class Replacer extends StatefulWidget {
  Widget Function(BuildContext context, _ReplacerState replacerState) builder;

  Replacer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<Replacer> createState() => _ReplacerState();
}

class _ReplacerState extends State<Replacer> {
  Widget? deletedWidget;

  @override
  Widget build(BuildContext context) {
    return deletedWidget ?? widget.builder(context, this);
  }

  void process({
    Widget replacer = const SizedBox.shrink(),
  }) async {
    setState(() => deletedWidget = replacer);
  }
}
