import 'package:flutter/material.dart';

/// Preferencia de tema en memoria (claro por defecto).
class AppThemeSession extends ChangeNotifier {
  AppThemeSession._();

  static final AppThemeSession instance = AppThemeSession._();

  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void reset() {
    _mode = ThemeMode.light;
    notifyListeners();
  }
}
