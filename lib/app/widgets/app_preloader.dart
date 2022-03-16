import 'package:flutter/material.dart';

class AppPreloader extends StatelessWidget {
  const AppPreloader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
