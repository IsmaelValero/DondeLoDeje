/// Zona dentro de una categoría (solo nombre, sin icono propio).
class Zona {
  const Zona({
    required this.id,
    required this.categoriaId,
    required this.nombre,
  });

  final String id;
  final String categoriaId;
  final String nombre;

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoriaId': categoriaId,
        'nombre': nombre,
      };

  static Zona? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final categoriaId = json['categoriaId'];
    final nombre = json['nombre'];
    if (id is! String || categoriaId is! String || nombre is! String) {
      return null;
    }

    return Zona(id: id, categoriaId: categoriaId, nombre: nombre);
  }
}
