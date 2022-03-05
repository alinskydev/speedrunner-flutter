import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

import '/main.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  Future<Map> profileFuture = services.AppHttp(
    path: 'profile/view',
  ).getData().then((value) {
    return value['body'];
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language),
            onSelected: (value) async {
              await base.Intl.setLanguage(value);

              services.AppNotificator(context).sendMessage(
                message: Text('Language has been changed'),
              );

              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => views.ProfileView(),
                ),
                (route) => false,
              );
            },
            itemBuilder: (BuildContext context) {
              return base.Intl.availableLanguages.values.map((e) {
                return PopupMenuItem<String>(
                  value: e['code'],
                  child: Text(e['label']),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => views.ProfileUpdate()),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await base.User.logout();

              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => views.AppHome(),
                ),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.data == null) return SizedBox.shrink();

            Map<String, dynamic> profile = snapshot.data as Map<String, dynamic>;

            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  services.AppImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ).renderNetwork(
                    url: profile['image'],
                  ),
                  SizedBox(height: 30),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Username'),
                          ),
                          TableCell(
                            child: Text(profile['username'] ?? ''),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Full name'),
                          ),
                          TableCell(
                            child: Text(profile['full_name'] ?? ''),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Phone'),
                          ),
                          TableCell(
                            child: Text(profile['phone'] ?? ''),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Address'),
                          ),
                          TableCell(
                            child: Text(profile['address'] ?? ''),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'profile',
      ),
    );
  }
}
