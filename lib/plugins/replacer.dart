import 'package:flutter/material.dart';

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
  Widget? replacer;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: replacer ?? widget.builder(context, this),
    );
  }

  void process({
    Widget replacer = const SizedBox.shrink(),
  }) {
    setState(() {
      this.replacer = replacer;
    });
  }
}
