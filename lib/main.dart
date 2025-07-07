import 'package:demo_flutter_app/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifiers/user_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => UserNotifier(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashPage(),
    );
  }
}
