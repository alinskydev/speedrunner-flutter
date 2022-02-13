import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/extensions.dart';
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

import '/base/config.dart' as config;

class DeletableBox extends StatefulWidget {
  Widget Function(BuildContext context, _DeletableBoxState state) builder;

  DeletableBox({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<DeletableBox> createState() => _DeletableBoxState();
}

class _DeletableBoxState extends State<DeletableBox> {
  bool _is_deleted = false;

  @override
  Widget build(BuildContext context) {
    return _is_deleted ? SizedBox.shrink() : widget.builder(context, this);
  }

  void delete() {
    setState(() => _is_deleted = true);
  }
}
