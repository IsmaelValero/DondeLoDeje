import 'models.dart';
import 'sample_data.dart';

/// Recuerdos creados o editados durante la sesión actual (sin persistencia).
class SessionRecuerdos {
  SessionRecuerdos._();

  static final List<Recuerdo> _items = [];
  static final Map<String, Recuerdo> _overrides = {};

  static List<Recuerdo> get items => List.unmodifiable(_items);

  static Iterable<Recuerdo> get overrides => _overrides.values;

  static Recuerdo? overrideFor(String id) => _overrides[id];

  static bool hasOverride(String id) => _overrides.containsKey(id);

  static void add(Recuerdo recuerdo) {
    _items.insert(0, recuerdo);
  }

  static void upsert(Recuerdo recuerdo) {
    final sessionIndex = _items.indexWhere((r) => r.id == recuerdo.id);
    if (sessionIndex >= 0) {
      _items[sessionIndex] = recuerdo;
      return;
    }

    if (recuerdo.id.startsWith('session-')) {
      _items.insert(0, recuerdo);
      return;
    }

    _overrides[recuerdo.id] = recuerdo;
  }

  static Recuerdo? findById(String id) {
    for (final recuerdo in _items) {
      if (recuerdo.id == id) return recuerdo;
    }
    if (_overrides.containsKey(id)) return _overrides[id];
    return SampleData.findRecuerdoById(id);
  }

  /// Solo para tests.
  static void clear() {
    _items.clear();
    _overrides.clear();
  }
}
