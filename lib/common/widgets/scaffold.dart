import 'package:flutter/material.dart';

import '/libraries/views.dart' as views;

class Scaffold {
  static BottomNavigationBar bottomNavigationBar(
    BuildContext context,
    int currentIndex,
  ) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Blogs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: (value) {
        if (value == currentIndex) return;

        switch (value) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => views.Home()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => views.BlogList()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => views.ProfileView()),
            );
            break;
        }
      },
    );
  }
}
