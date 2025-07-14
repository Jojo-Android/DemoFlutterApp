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

  final List<Widget> pages = const [
    const HomePage(),
    const FavoritePage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_currentIndex],
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
          showUnselectedLabels: theme.bottomNavigationBarTheme.showUnselectedLabels ?? true,
          type: theme.bottomNavigationBarTheme.type ?? BottomNavigationBarType.fixed,
          selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle: theme.bottomNavigationBarTheme.unselectedLabelStyle,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

