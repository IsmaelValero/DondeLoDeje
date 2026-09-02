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

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'iconKey': iconKey,
        if (colorKey != null) 'colorKey': colorKey,
      };

  static OpcionCatalogo? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final nombre = json['nombre'];
    if (id is! String || nombre is! String) return null;

    return OpcionCatalogo(
      id: id,
      nombre: nombre,
      iconKey: json['iconKey'] is String ? json['iconKey'] as String : 'pin',
      colorKey: json['colorKey'] as String?,
    );
  }
}

/// Valor especial del desplegable para añadir una opción nueva.
const agregarOpcionCatalogoId = '__agregar__';
