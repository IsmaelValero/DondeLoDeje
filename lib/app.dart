import 'package:flutter/material.dart';

import 'data/catalogo_session.dart';
import 'data/user_session.dart';
import 'navigation/app_router.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_session.dart';

class DondeLoDejeApp extends StatelessWidget {
  const DondeLoDejeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        CatalogoSession.instance,
        AppThemeSession.instance,
        UserSession.instance,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'DondeLoDeje',
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: AppThemeSession.instance.mode,
          home: AppRoot(),
          routes: AppRouter.routes,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}

/// Raíz que muestra onboarding o inicio según el perfil del usuario.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    if (!UserSession.instance.hasCompletedOnboarding) {
      return const OnboardingScreen();
    }

    return const HomeScreen();
  }
}
