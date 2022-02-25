import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;

class AppNavBottom extends StatelessWidget {
  String currentName;
  late final int currentIndex;

  Map<String, Map<String, dynamic>> nav = {};

  AppNavBottom({
    Key? key,
    required this.currentName,
  }) : super(key: key) {
    if (base.User.isAuthorized) {
      nav = {
        'home': {
          'label': 'Home',
          'icon': Icons.home,
        },
        'blog': {
          'label': 'Blogs',
          'icon': Icons.list_alt,
        },
        'product': {
          'label': 'Products',
          'icon': Icons.shopping_bag_outlined,
        },
        'cart': {
          'label': 'Cart',
          'icon': services.AppIcons.cart,
          'iconBadge': services.Cart.quantity > 0 ? services.Cart.quantity.toString() : null,
        },
        'profile': {
          'label': 'Profile',
          'icon': Icons.person,
        },
      };
    } else {
      nav = {
        'home': {
          'label': 'Home',
          'icon': Icons.home,
        },
        'blog': {
          'label': 'Blogs',
          'icon': Icons.list_alt,
        },
        'login': {
          'label': 'Login',
          'icon': Icons.login,
        },
        'register': {
          'label': 'Registration',
          'icon': Icons.app_registration,
        },
        'reset_password_request': {
          'label': 'Reset password request',
          'icon': Icons.restore_page,
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
      iconSize: 40,
      items: nav.values.map((e) {
        return BottomNavigationBarItem(
          label: e['label'],
          icon: Stack(
            children: [
              Icon(e['icon']),
              e['iconBadge'] != null
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          e['iconBadge'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      }).toList(),
      onTap: (value) {
        if (value == currentIndex) return;

        Widget? view;

        switch (nav.keys.toList()[value]) {
          case 'blog':
            view = views.BlogList();
            break;
          case 'home':
            view = views.AppHome();
            break;
          case 'login':
            view = views.AuthLogin();
            break;
          case 'product':
            view = views.ProductList();
            break;
          case 'profile':
            view = views.ProfileView();
            break;
          case 'register':
            view = views.AuthRegister();
            break;
          case 'reset_password_request':
            view = views.AuthResetPasswordRequest();
            break;
        }

        if (view != null) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => view!,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      },
    );
  }
}
