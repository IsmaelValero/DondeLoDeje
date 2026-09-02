/// Categoría principal del catálogo (con icono y color).
class OpcionCatalogo {
  const OpcionCatalogo({
    required this.id,
    required this.nombre,
    required this.iconKey,
    this.colorKey,
  });

  final String id;
  final String nombre;
  final String iconKey;
  /// null o [CatalogColorKeys.auto] → color automático según id.
  final String? colorKey;

  OpcionCatalogo copyWith({
    String? id,
    String? nombre,
    String? iconKey,
    String? colorKey,
  }) {
    return OpcionCatalogo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      iconKey: iconKey ?? this.iconKey,
      colorKey: colorKey ?? this.colorKey,
    );
  }
}

/// Valor especial del desplegable para añadir una opción nueva.
const agregarOpcionCatalogoId = '__agregar__';
