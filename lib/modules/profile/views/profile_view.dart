import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class ProfileView extends base.View {
  ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<Map<String, dynamic>> profileFuture = services.AppNetwork(
    uri: Uri(
      path: 'profile/view',
    ),
  ).sendRequest().then((value) {
    return value.data;
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
              await base.Singletons.intl.setLanguage(value);

              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => views.ProfileView(),
                ),
                (route) => false,
              );

              services.AppNotificator(context).sendMessage('Language has been changed');
            },
            itemBuilder: (BuildContext context) {
              return base.Singletons.intl.availableLanguages.map((e) {
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
              await base.Singletons.user.logout();

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
        child: FutureBuilder<Map<String, dynamic>>(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.data == null) return SizedBox.shrink();

            models.Profile profile = models.Profile(snapshot.data!);

            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  services.Image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ).renderNetwork(
                    url: profile.getValue('image'),
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
                            child: Text(profile.getValue('username')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Full name'),
                          ),
                          TableCell(
                            child: Text(profile.getValue('full_name')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Phone'),
                          ),
                          TableCell(
                            child: Text(profile.getValue('phone')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Address'),
                          ),
                          TableCell(
                            child: Text(profile.getValue('address')),
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
        current: widgets.AppNavBottomTabs.profile,
      ),
    );
  }
}
