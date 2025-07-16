import 'dart:async';

import 'package:demo_flutter_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../notifiers/user_notifier.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

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
    final minSplashTime = Future.delayed(const Duration(seconds: 1));
    final userNotifier = context.read<UserNotifier>();
    final loadUser = userNotifier.loadUserFromDB();

    await Future.wait([minSplashTime, loadUser]);

    if (!mounted) return;

    final user = userNotifier.user;

    // ✅ ใช้ go_router นำทาง
    if (user != null) {
      context.goNamed(AppRoutes.main);
    } else {
      context.goNamed(AppRoutes.login);
    }
  }


  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: color.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: local.appTitle,
                child: Icon(Icons.shopping_bag, size: 80, color: color.primary),
              ),
              const SizedBox(height: 16),
              Text(
                local.appTitle,
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
