import 'package:flutter/material.dart';

import '../screens/apariencia_screen.dart';
import '../screens/panel_lugares_screen.dart';
import '../screens/crear_recuerdo_screen.dart';
import '../screens/lugar_zonas_screen.dart';
import '../screens/mas_screen.dart';
import '../screens/zona_recuerdos_screen.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.mas: (_) => const MasScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.lugarZonas:
        final args = settings.arguments;
        if (args is LugarZonasArgs) {
          return _pageRoute(
            settings,
            LugarZonasScreen(
              categoriaId: args.categoriaId,
              manage: args.manage,
            ),
          );
        }
        if (args is String) {
          return _pageRoute(
            settings,
            LugarZonasScreen(categoriaId: args),
          );
        }
        return _unknownRoute(settings);
      case AppRoutes.zonaRecuerdos:
        final args = settings.arguments as ZonaRecuerdosArgs?;
        if (args == null) return _unknownRoute(settings);
        return _pageRoute(
          settings,
          ZonaRecuerdosScreen(
            categoriaId: args.categoriaId,
            zonaId: args.zonaId,
          ),
        );
      case AppRoutes.crearRecuerdo:
        return _pageRoute(settings, const CrearRecuerdoScreen());
      case AppRoutes.editarRecuerdo:
        final recuerdoId = settings.arguments as String?;
        if (recuerdoId == null) return _unknownRoute(settings);
        return _pageRoute<bool>(
          settings,
          CrearRecuerdoScreen(recuerdoId: recuerdoId),
        );
      case AppRoutes.panelLugares:
        return _pageRoute(settings, const PanelLugaresScreen());
      case AppRoutes.apariencia:
        return _pageRoute(settings, const AparienciaScreen());
      default:
        return null;
    }
  }

  static MaterialPageRoute<T> _pageRoute<T>(RouteSettings settings, Widget page) {
    return MaterialPageRoute<T>(
      settings: settings,
      builder: (_) => page,
    );
  }

  static MaterialPageRoute<void> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Ruta no encontrada')),
        body: Center(child: Text('Ruta desconocida: ${settings.name}')),
      ),
    );
  }
}
