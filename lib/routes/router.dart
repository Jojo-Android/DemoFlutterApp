import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/login_page.dart';
import '../pages/main_page.dart';
import '../pages/register_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';

final router = GoRouter(
  initialLocation: AppRoutes.splashPath,
  routes: [
    GoRoute(
      name: AppRoutes.splash,
      path: AppRoutes.splashPath,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: AppRoutes.login,
      path: AppRoutes.loginPath,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: AppRoutes.register,
      path: AppRoutes.registerPath,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: AppRoutes.main,
      path: AppRoutes.mainPath,
      builder: (context, state) => const MainPage(),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('404 - Page Not Found'))),
);
