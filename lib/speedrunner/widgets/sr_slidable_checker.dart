import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/libraries/base.dart' as base;
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class SRSlidableChecker extends StatefulWidget {
  Widget child;
  String tag;

  SRSlidableChecker({
    Key? key,
    required this.child,
    required this.tag,
  }) : super(key: key);

  @override
  State<SRSlidableChecker> createState() => _SRSlidableCheckerState();
}

class _SRSlidableCheckerState extends State<SRSlidableChecker> {
  static List<String> _checkedTags = [];

  @override
  void initState() {
    super.initState();

    if (_checkedTags.contains(widget.tag)) return;

    _checkedTags.add(widget.tag);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(seconds: 1));

      await Slidable.of(context)?.openEndActionPane(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutQuint,
      );

      await Future.delayed(Duration(seconds: 1));

      await Slidable.of(context)?.close(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutQuint,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
