import 'package:flutter/material.dart';

import 'catalog_icons.dart';
import 'app_palette.dart';

/// Colores seleccionables para lugares (claro y oscuro).
abstract final class CatalogColors {
  static Color fromKey(String key, AppPalette palette) {
    final dark = !palette.useCardShadow;

    return switch (key) {
      CatalogColorKeys.green => palette.green,
      CatalogColorKeys.blue => palette.blue,
      CatalogColorKeys.terracotta => palette.terracotta,
      CatalogColorKeys.mustard => palette.mustard,
      CatalogColorKeys.petrol => palette.petrol,
      CatalogColorKeys.purple => dark ? _darkPurple : _lightPurple,
      CatalogColorKeys.coral => dark ? _darkCoral : _lightCoral,
      CatalogColorKeys.orange => dark ? _darkOrange : _lightOrange,
      CatalogColorKeys.teal => dark ? _darkTeal : _lightTeal,
      CatalogColorKeys.indigo => dark ? _darkIndigo : _lightIndigo,
      CatalogColorKeys.sage => dark ? _darkSage : _lightSage,
      _ => palette.petrol,
    };
  }

  static String labelFor(String key) {
    return switch (key) {
      CatalogColorKeys.green => 'Verde',
      CatalogColorKeys.blue => 'Azul',
      CatalogColorKeys.terracotta => 'Terracota',
      CatalogColorKeys.mustard => 'Mostaza',
      CatalogColorKeys.petrol => 'Petróleo',
      CatalogColorKeys.purple => 'Violeta',
      CatalogColorKeys.coral => 'Coral',
      CatalogColorKeys.orange => 'Naranja',
      CatalogColorKeys.teal => 'Turquesa',
      CatalogColorKeys.indigo => 'Índigo',
      CatalogColorKeys.sage => 'Salvia',
      _ => key,
    };
  }

  static const _lightPurple = Color(0xFF7B5EA7);
  static const _darkPurple = Color(0xFFA88BD4);
  static const _lightCoral = Color(0xFFD4577A);
  static const _darkCoral = Color(0xFFF07A98);
  static const _lightOrange = Color(0xFFE8893A);
  static const _darkOrange = Color(0xFFF5A54A);
  static const _lightTeal = Color(0xFF2A9D8F);
  static const _darkTeal = Color(0xFF4DBFB0);
  static const _lightIndigo = Color(0xFF5B6BBF);
  static const _darkIndigo = Color(0xFF7B8FE0);
  static const _lightSage = Color(0xFF6B8F5E);
  static const _darkSage = Color(0xFF8FB87E);
}
