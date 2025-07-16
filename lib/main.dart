import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'notifiers/user_notifier.dart';
import 'notifiers/locale_notifier.dart';
import 'routes/router.dart'; // import your GoRouter instance
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppLocalizations.of(context)?.appName ?? 'Demo Flutter App',
      locale: localeNotifier.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: shoppingAppTheme,
      routerConfig: router,
    );

  }
}
