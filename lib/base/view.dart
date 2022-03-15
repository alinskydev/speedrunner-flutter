import 'package:flutter/material.dart';

import '/libraries/views.dart' as views;

abstract class View extends StatefulWidget {
  View({Key? key}) : super(key: key) {
    current = this;
  }

  static View? current;
}
