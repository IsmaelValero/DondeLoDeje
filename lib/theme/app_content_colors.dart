import 'package:flutter/material.dart';

import '../data/opcion_catalogo.dart';
import 'catalog_colors.dart';
import 'catalog_icons.dart';
import 'app_palette.dart';

/// Colores por tipo de contenido — semánticos, no decorativos.
abstract final class AppContentColors {
  static Color fromKey(String key, AppPalette palette) {
    return CatalogColors.fromKey(key, palette);
  }

  static Color forOpcion(OpcionCatalogo opcion, AppPalette palette) {
    final key = opcion.colorKey;
    if (key != null && key != CatalogColorKeys.auto) {
      return fromKey(key, palette);
    }
    return autoForId(opcion.id, palette);
  }

  static Color softForOpcion(OpcionCatalogo opcion, AppPalette palette) {
    return palette.softTint(forOpcion(opcion, palette));
  }

  static Color autoForId(String id, AppPalette palette) {
    const keys = CatalogColorKeys.selectable;
    final index = id.hashCode.abs() % keys.length;
    return fromKey(keys[index], palette);
  }

  static Color forRecuerdo(AppPalette palette) => palette.terracotta;

  static Color forFavorito(AppPalette palette) => palette.mustard;

  static Color defaultForCategoria(AppPalette palette) => palette.terracotta;
}
