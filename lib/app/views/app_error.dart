import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;

enum AppErrorType { noConnection, notAllowed, internal }
enum _AppErrorAction { goHome, refresh }

class AppError extends StatelessWidget {
  AppErrorType type;

  late Map<String, dynamic> _currentType;

  Map<AppErrorType, Map<String, dynamic>> get _types {
    return {
      AppErrorType.noConnection: {
        'label': 'No connection',
        'image': 'assets/images/errors/no_connection.png',
        'action': _AppErrorAction.refresh,
      },
      AppErrorType.notAllowed: {
        'label': 'Access denied',
        'image': 'assets/images/errors/403.png',
        'action': _AppErrorAction.goHome,
      },
      AppErrorType.internal: {
        'label': 'Internal error',
        'image': 'assets/images/errors/500.png',
        'action': _AppErrorAction.goHome,
      },
    };
  }

  AppError({
    Key? key,
    this.type = AppErrorType.internal,
  }) : super(key: key) {
    _currentType = _types[type]!;
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
                  Text(_currentType['label']),
                  Image.asset(
                    _currentType['image'],
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
    switch ((_currentType['action'] as _AppErrorAction)) {
      case _AppErrorAction.goHome:
        return ElevatedButton.icon(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => views.AppHome(),
                transitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
          icon: Icon(Icons.home),
          label: Text('Go home'),
        );
      case _AppErrorAction.refresh:
        return ElevatedButton.icon(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => base.View.current ?? views.AppHome(),
                transitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
          icon: Icon(Icons.refresh),
          label: Text('Refresh'),
        );
    }
  }
}
