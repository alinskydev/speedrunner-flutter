import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableChecker extends StatefulWidget {
  Widget child;
  String tag;

  SlidableChecker({
    Key? key,
    required this.child,
    required this.tag,
  }) : super(key: key);

  @override
  State<SlidableChecker> createState() => _SlidableCheckerState();
}

class _SlidableCheckerState extends State<SlidableChecker> {
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
