import 'package:flutter/foundation.dart';

import '../theme/catalog_icons.dart';
import 'opcion_catalogo.dart';
import 'zona.dart';

/// Catálogo en memoria de categorías y sus zonas.
class CatalogoSession extends ChangeNotifier {
  CatalogoSession._();

  static final CatalogoSession instance = CatalogoSession._();

  static const _categoriasIniciales = [
    OpcionCatalogo(
      id: 'cat-casa',
      nombre: 'Casa',
      iconKey: 'home',
      colorKey: CatalogColorKeys.green,
    ),
    OpcionCatalogo(
      id: 'cat-coche',
      nombre: 'Coche',
      iconKey: 'car',
      colorKey: CatalogColorKeys.terracotta,
    ),
    OpcionCatalogo(
      id: 'cat-trastero',
      nombre: 'Trastero',
      iconKey: 'box',
      colorKey: CatalogColorKeys.petrol,
    ),
  ];

  static const _zonasIniciales = [
    Zona(id: 'zona-casa-cocina', categoriaId: 'cat-casa', nombre: 'Cocina'),
    Zona(id: 'zona-casa-salon', categoriaId: 'cat-casa', nombre: 'Salón'),
    Zona(id: 'zona-casa-bano', categoriaId: 'cat-casa', nombre: 'Baño'),
    Zona(id: 'zona-casa-papas', categoriaId: 'cat-casa', nombre: 'Cuarto Papás'),
  ];

  List<OpcionCatalogo> _categorias = List.of(_categoriasIniciales);
  List<Zona> _zonas = List.of(_zonasIniciales);

  List<OpcionCatalogo> get categorias => List.unmodifiable(_categorias);

  List<Zona> get zonas => List.unmodifiable(_zonas);

  List<Zona> zonasForCategoria(String categoriaId) {
    return _zonas.where((z) => z.categoriaId == categoriaId).toList();
  }

  Zona? zonaById(String? id) {
    if (id == null) return null;
    for (final zona in _zonas) {
      if (zona.id == id) return zona;
    }
    return null;
  }

  OpcionCatalogo? categoriaById(String? id) {
    if (id == null) return null;
    for (final categoria in _categorias) {
      if (categoria.id == id) return categoria;
    }
    return null;
  }

  OpcionCatalogo get categoriaDefault => _categorias.first;

  OpcionCatalogo addCategoria({
    required String nombre,
    required String iconKey,
    String? colorKey,
  }) {
    final opcion = OpcionCatalogo(
      id: 'cat-${DateTime.now().millisecondsSinceEpoch}',
      nombre: nombre.trim(),
      iconKey: iconKey,
      colorKey: colorKey,
    );
    _categorias.add(opcion);
    notifyListeners();
    return opcion;
  }

  Zona addZona({
    required String categoriaId,
    required String nombre,
  }) {
    final zona = Zona(
      id: 'zona-${DateTime.now().millisecondsSinceEpoch}',
      categoriaId: categoriaId,
      nombre: nombre.trim(),
    );
    _zonas.add(zona);
    notifyListeners();
    return zona;
  }

  bool removeCategoria(String id) {
    final lengthBefore = _categorias.length;
    _categorias.removeWhere((c) => c.id == id);
    final removed = _categorias.length < lengthBefore;
    if (removed) {
      _zonas.removeWhere((z) => z.categoriaId == id);
      notifyListeners();
    }
    return removed;
  }

  bool removeZona(String id) {
    final lengthBefore = _zonas.length;
    _zonas.removeWhere((z) => z.id == id);
    final removed = _zonas.length < lengthBefore;
    if (removed) notifyListeners();
    return removed;
  }

  /// Repuebla el catálogo con lo guardado en el dispositivo.
  void restaurar({
    required List<OpcionCatalogo> categorias,
    required List<Zona> zonas,
  }) {
    _categorias = List.of(categorias);
    _zonas = List.of(zonas);
    notifyListeners();
  }

  /// Solo para tests.
  void reset() {
    _categorias = List.of(_categoriasIniciales);
    _zonas = List.of(_zonasIniciales);
    notifyListeners();
  }
}
