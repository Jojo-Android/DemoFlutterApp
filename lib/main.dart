import 'package:demo_flutter_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifiers/user_notifier.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserNotifier())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: shoppingAppTheme,
      home: const SplashPage(),
    );
  }
}
