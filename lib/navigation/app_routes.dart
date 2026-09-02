import 'package:flutter/material.dart';

/// Rutas de navegación de DondeLoDeje.
abstract final class AppRoutes {
  static const home = '/';
  static const mas = '/mas';

  static const lugarZonas = '/lugares/zonas';
  static const zonaRecuerdos = '/zonas/recuerdos';

  static const crearRecuerdo = '/recuerdos/crear';
  static const editarRecuerdo = '/recuerdos/editar';
  static const panelLugares = '/mas/lugares';
  static const apariencia = '/mas/apariencia';
  static const onboarding = '/onboarding';
}

/// Acciones de navegación reutilizables.
abstract final class AppNavigation {
  static void openMas(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.mas);
  }

  static void openCrearRecuerdo(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.crearRecuerdo);
  }

  static void openPanelLugares(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.panelLugares);
  }

  static void openApariencia(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.apariencia);
  }

  static void openLugarZonas(
    BuildContext context,
    String categoriaId, {
    bool manage = false,
  }) {
    Navigator.of(context).pushNamed(
      AppRoutes.lugarZonas,
      arguments: LugarZonasArgs(
        categoriaId: categoriaId,
        manage: manage,
      ),
    );
  }

  static void openZonaRecuerdos(
    BuildContext context, {
    required String categoriaId,
    String? zonaId,
  }) {
    Navigator.of(context).pushNamed(
      AppRoutes.zonaRecuerdos,
      arguments: ZonaRecuerdosArgs(
        categoriaId: categoriaId,
        zonaId: zonaId,
      ),
    );
  }

  static Future<bool?> openEditarRecuerdo(
    BuildContext context,
    String recuerdoId,
  ) {
    return Navigator.of(context).pushNamed<bool>(
      AppRoutes.editarRecuerdo,
      arguments: recuerdoId,
    );
  }
}

/// Argumentos para la pantalla de zonas de un lugar.
class LugarZonasArgs {
  const LugarZonasArgs({
    required this.categoriaId,
    this.manage = false,
  });

  final String categoriaId;
  final bool manage;
}

/// Argumentos para la pantalla de recuerdos de una zona.
class ZonaRecuerdosArgs {
  const ZonaRecuerdosArgs({
    required this.categoriaId,
    this.zonaId,
  });

  final String categoriaId;
  final String? zonaId;
}
