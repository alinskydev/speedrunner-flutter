import 'package:flutter/material.dart';

import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;

class AppError extends StatelessWidget {
  services.AppException exception;

  AppError({
    Key? key,
    required this.exception,
  }) : super(key: key);

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
                  Text(exception.label),
                  Image.asset(
                    exception.image,
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
    switch (exception.buttonRoute) {
      case services.AppExceptionButtonActions.goHome:
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
      case services.AppExceptionButtonActions.refresh:
        return ElevatedButton.icon(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                // pageBuilder: (context, animation, secondaryAnimation) => views.AppHome(),
                pageBuilder: (context, animation, secondaryAnimation) => config.AppSettings.currentView,
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
