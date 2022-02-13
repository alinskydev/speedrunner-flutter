import 'package:flutter/material.dart';
import '/libraries/widgets.dart' as widgets;

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Profile'),
      ),
      bottomNavigationBar: widgets.Scaffold.bottomNavigationBar(context, 2),
    );
  }
}
