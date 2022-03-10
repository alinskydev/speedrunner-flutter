import 'package:flutter/material.dart';

import '/libraries/config.dart' as config;

abstract class StatelessView extends StatelessWidget {
  StatelessView({Key? key}) : super(key: key) {
    config.AppSettings.currentView = this;
  }
}

abstract class StatefulView extends StatefulWidget {
  StatefulView({Key? key}) : super(key: key) {
    config.AppSettings.currentView = this;
  }
}
