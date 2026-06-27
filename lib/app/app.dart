// it's main configuration file for the app

import 'package:flutter/material.dart';
import 'package:logeria/core/theme/app_theme.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Logeria',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}