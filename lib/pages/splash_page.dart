// lib/pages/splash_page.dart

import 'package:demo_flutter_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/user_notifier.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    await userNotifier.loadUserFromDB();

    final user = userNotifier.user;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null ? MainPage(user: user) : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // 🔄 Loading
    );
  }
}
