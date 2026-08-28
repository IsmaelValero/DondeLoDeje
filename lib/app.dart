import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_mode.dart';

class DondeLoDejeApp extends StatelessWidget {
  const DondeLoDejeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DondeLoDeje',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: AppThemeMode.current,
      home: const HomeShell(),
    );
  }
}
