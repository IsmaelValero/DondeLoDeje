import 'package:flutter/material.dart';

/// Modo de tema activo en la aplicación.
///
/// Cuando se implemente el selector de apariencia, cambiar [current] o
/// conectarlo a un gestor de estado. Valores previstos:
/// [ThemeMode.light], [ThemeMode.dark], [ThemeMode.system].
abstract final class AppThemeMode {
  static const ThemeMode current = ThemeMode.light;
}
