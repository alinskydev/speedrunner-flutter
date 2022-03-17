import 'package:flutter/material.dart';

abstract class View extends StatefulWidget {
  static View? current;

  View({Key? key}) : super(key: key) {
    current = this;
  }
}
