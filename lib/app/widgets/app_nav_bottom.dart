// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

enum AppNavBottomTabs { blog, cart, home, login, product, profile, register, resetPasswordRequest }

class AppNavBottom extends StatelessWidget {
  AppNavBottomTabs current;

  late int _currentIndex;
  late Map<AppNavBottomTabs, Map<String, dynamic>> _tabs;

  Map<AppNavBottomTabs, Map<String, dynamic>> get _allTabs {
    return {
      AppNavBottomTabs.blog: {
        'label': 'Blogs',
        'icon': Icons.list_alt,
        'view': () => views.BlogList(),
      },
      AppNavBottomTabs.cart: {
        'label': 'Cart',
        'icon': widgets.AppIcons.cart,
        'view': () => views.Cart(),
        'badge': StreamBuilder(
          stream: base.Singletons.cart.controller.stream,
          initialData: base.Singletons.cart,
          builder: (context, snapshot) {
            if (base.Singletons.cart.quantity > 0) {
              return Positioned(
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
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      },
      AppNavBottomTabs.home: {
        'label': 'Home',
        'icon': Icons.home,
        'view': () => views.AppHome(),
      },
      AppNavBottomTabs.login: {
        'label': 'Login',
        'icon': Icons.login,
        'view': () => views.AuthLogin(),
      },
      AppNavBottomTabs.product: {
        'label': 'Products',
        'icon': Icons.shopping_bag_outlined,
        'view': () => views.ProductList(),
      },
      AppNavBottomTabs.profile: {
        'label': 'Profile',
        'icon': Icons.person,
        'view': () => views.ProfileView(),
      },
      AppNavBottomTabs.register: {
        'label': 'Registration',
        'icon': Icons.app_registration,
        'view': () => views.AuthRegister(),
      },
      AppNavBottomTabs.resetPasswordRequest: {
        'label': 'Reset password request',
        'icon': Icons.restore_page,
        'view': () => views.AuthResetPasswordRequest(),
      },
    };
  }

  AppNavBottom({
    Key? key,
    required this.current,
  }) : super(key: key) {
    List<AppNavBottomTabs> nav;

    if (base.Singletons.user.isAuthorized) {
      nav = [
        AppNavBottomTabs.home,
        AppNavBottomTabs.blog,
        AppNavBottomTabs.product,
        AppNavBottomTabs.cart,
        AppNavBottomTabs.profile,
      ];
    } else {
      nav = [
        AppNavBottomTabs.home,
        AppNavBottomTabs.blog,
        AppNavBottomTabs.login,
        AppNavBottomTabs.register,
        AppNavBottomTabs.resetPasswordRequest,
      ];
    }

    _tabs = Map.fromIterable(
      nav,
      key: (element) => element,
      value: (element) => _allTabs[element]!,
    );

    _currentIndex = nav.indexOf(current);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      iconSize: 40,
      items: _tabs.values.map((e) {
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
        if (value == _currentIndex) return;

        AppNavBottomTabs tabIndex = _tabs.keys.toList()[value];
        Widget view = _tabs[tabIndex]!['view']();

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => view,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}
