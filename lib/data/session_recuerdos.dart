import 'package:flutter/foundation.dart';

import 'models.dart';

class _RecuerdosNotificador extends ChangeNotifier {
  void notificar() => notifyListeners();
}

/// Recuerdos creados por el usuario.
///
/// [onCambio] lo usa la capa de persistencia para guardar tras cada cambio;
/// [cambios] permite a la interfaz refrescarse venga el cambio de donde venga.
class SessionRecuerdos {
  SessionRecuerdos._();

  static final List<Recuerdo> _items = [];
  static final _notificador = _RecuerdosNotificador();

  static void Function()? onCambio;

  static Listenable get cambios => _notificador;

  static List<Recuerdo> get items => List.unmodifiable(_items);

  static void add(Recuerdo recuerdo) {
    _items.insert(0, recuerdo);
    _notificarCambio();
  }

  static void upsert(Recuerdo recuerdo) {
    final index = _items.indexWhere((r) => r.id == recuerdo.id);
    if (index >= 0) {
      _items[index] = recuerdo;
    } else {
      _items.insert(0, recuerdo);
    }
    _notificarCambio();
  }

  static bool remove(String id) {
    final lengthBefore = _items.length;
    _items.removeWhere((r) => r.id == id);
    final removed = _items.length < lengthBefore;
    if (removed) _notificarCambio();
    return removed;
  }

  static void _notificarCambio() {
    _notificador.notificar();
    onCambio?.call();
  }

  static Recuerdo? findById(String id) {
    for (final recuerdo in _items) {
      if (recuerdo.id == id) return recuerdo;
    }
    return null;
  }

  /// Repuebla los recuerdos con lo guardado en el dispositivo.
  static void restaurar(List<Recuerdo> items) {
    _items
      ..clear()
      ..addAll(items);
  }

  /// Solo para tests.
  static void clear() {
    _items.clear();
  }
}
