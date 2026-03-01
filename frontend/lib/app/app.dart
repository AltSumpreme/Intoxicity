import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'router.dart';

class IntoxicityApp extends StatelessWidget {
  const IntoxicityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Intoxicity',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
