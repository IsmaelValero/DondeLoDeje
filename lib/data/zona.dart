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
}
