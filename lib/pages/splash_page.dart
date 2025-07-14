import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/user_notifier.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();

    _initApp();
  }

  Future<void> _initApp() async {
    // Wait at least 1s to make splash visible
    await Future.delayed(const Duration(seconds: 2));

    final userNotifier = context.read<UserNotifier>();
    await userNotifier.loadUserFromDB();
    final user = userNotifier.user;

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) =>
        user != null ? MainPage(user: user) : const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag,
                size: 80,
                color: color.primary,
              ),
              const SizedBox(height: 16),
              Text(
                "Demo Flutter App",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
