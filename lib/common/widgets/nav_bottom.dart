import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;

class NavBottom extends StatelessWidget {
  String currentName;
  late final int currentIndex;

  Map<String, Map<_NavKeys, dynamic>> nav = {};

  NavBottom({
    Key? key,
    required this.currentName,
  }) : super(key: key) {
    if (base.User.isAuthorized) {
      nav = {
        'home': {
          _NavKeys.label: 'Home',
          _NavKeys.icon: Icons.home,
        },
        'blog': {
          _NavKeys.label: 'Blogs',
          _NavKeys.icon: Icons.list_alt,
        },
        'profile': {
          _NavKeys.label: 'Profile',
          _NavKeys.icon: Icons.person,
        },
      };
    } else {
      nav = {
        'home': {
          _NavKeys.label: 'Home',
          _NavKeys.icon: Icons.home,
        },
        'blog': {
          _NavKeys.label: 'Blogs',
          _NavKeys.icon: Icons.list_alt,
        },
        'login': {
          _NavKeys.label: 'Login',
          _NavKeys.icon: Icons.login,
        },
        'register': {
          _NavKeys.label: 'Registration',
          _NavKeys.icon: Icons.app_registration,
        },
        'reset_password_request': {
          _NavKeys.label: 'Reset password request',
          _NavKeys.icon: Icons.restore_page,
        },
      };
    }

    currentIndex = nav.keys.toList().indexOf(currentName);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      items: nav.values.map((e) {
        return BottomNavigationBarItem(
          label: e[_NavKeys.label],
          icon: Icon(e[_NavKeys.icon]),
        );
      }).toList(),
      onTap: (value) {
        if (value == currentIndex) return;

        Widget? view;

        switch (nav.keys.toList()[value]) {
          case 'home':
            view = views.AppHome();
            break;
          case 'blog':
            view = views.BlogList();
            break;
          case 'login':
            view = views.AuthLogin();
            break;
          case 'register':
            view = views.AuthRegister();
            break;
          case 'reset_password_request':
            view = views.AuthResetPasswordRequest();
            break;
          case 'profile':
            view = views.ProfileView();
            break;
        }

        if (view != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => view!),
          );
        }
      },
    );
  }
}

enum _NavKeys { label, icon }
