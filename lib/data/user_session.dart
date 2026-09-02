import 'package:flutter/material.dart';

/// Perfil del usuario en memoria (nombre mostrado en inicio y perfil).
class UserSession extends ChangeNotifier {
  UserSession._();

  static final UserSession instance = UserSession._();

  String? _displayName;

  String? get displayName => _displayName;

  bool get hasCompletedOnboarding {
    final name = _displayName?.trim();
    return name != null && name.isNotEmpty;
  }

  static String initialFor(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return '?';

    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  String get initial => initialFor(_displayName);

  void completeOnboarding(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    if (_displayName == trimmed) return;
    _displayName = trimmed;
    notifyListeners();
  }

  void setDisplayName(String name) => completeOnboarding(name);

  /// Repuebla el perfil con lo guardado en el dispositivo.
  void restaurar(String? name) {
    final trimmed = name?.trim();
    _displayName = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    notifyListeners();
  }

  void reset() {
    _displayName = null;
    notifyListeners();
  }
}
