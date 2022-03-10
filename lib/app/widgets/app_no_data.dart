import 'package:flutter/material.dart';

enum AppNoDataTypes { blog, cart }

class AppNoData extends StatelessWidget {
  AppNoDataTypes type;

  AppNoData({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: _inner(),
    );
  }

  Widget _inner() {
    switch (type) {
      case AppNoDataTypes.blog:
        return Text(
          'No blogs',
          style: TextStyle(fontSize: 70),
        );
      case AppNoDataTypes.cart:
        return Text(
          'Cart empty',
          style: TextStyle(fontSize: 70),
        );
    }
  }
}
