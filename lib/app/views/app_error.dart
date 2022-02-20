import 'package:flutter/material.dart';

import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class AppError extends StatelessWidget {
  Map<int, Map<String, dynamic>> types = {
    -1: {
      'title': 'No connection',
      'image': 'no_connection',
    },
    403: {
      'title': '403',
      'image': '403',
    },
    500: {
      'title': '500',
      'image': '500',
    },
  };

  int code;
  late Map<String, dynamic> currentType;

  AppError({
    Key? key,
    required this.code,
  }) : super(key: key) {
    currentType = types[code] ?? types[-1]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentType['title']),
                  Image.asset(
                    'assets/images/errors/${currentType['image']}.png',
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: _button(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context) {
    switch (code) {
      case 403:
      case 500:
        return ElevatedButton.icon(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => views.AppHome(),
              ),
              (route) => false,
            );
          },
          icon: Icon(Icons.home),
          label: Text('Go home'),
        );
      case -1:
        return ElevatedButton.icon(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => views.AppHome(),
              ),
              (route) => false,
            );
          },
          icon: Icon(Icons.refresh),
          label: Text('Refresh'),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
