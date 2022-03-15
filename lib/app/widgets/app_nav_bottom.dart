import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class AppNavBottom extends StatelessWidget {
  String currentName;
  late final int currentIndex;

  Map<String, Map<String, dynamic>> nav = {};

  AppNavBottom({
    Key? key,
    required this.currentName,
  }) : super(key: key) {
    if (base.Singletons.user.isAuthorized) {
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
          'icon': widgets.AppIcons.cart,
          'badge': StreamBuilder(
            stream: base.Singletons.cart.controller.stream,
            initialData: base.Singletons.cart,
            builder: (context, snapshot) {
              return base.Singletons.cart.quantity > 0
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
                          base.Singletons.cart.quantity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
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
              e['badge'] ?? SizedBox.shrink(),
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
          case 'cart':
            view = views.Cart();
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
