import 'package:demo_flutter_app/model/user_model.dart';
import 'package:demo_flutter_app/pages/favorite_page.dart';
import 'package:demo_flutter_app/pages/setting_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  final UserModel user;

  const MainPage({super.key, required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(user: widget.user),
      FavoritePage(userEmail: widget.user.email),
      const SettingPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
