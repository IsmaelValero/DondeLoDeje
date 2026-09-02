import 'catalogo_session.dart';
import 'opcion_catalogo.dart';
import 'session_recuerdos.dart';
import 'models.dart';

/// Consultas unificadas de recuerdos por lugar, zona y categoría.
abstract final class RecuerdosQuery {
  static OpcionCatalogo? resolveCategoria(String id) {
    return CatalogoSession.instance.categoriaById(id);
  }

  static Recuerdo? findById(String id) => SessionRecuerdos.findById(id);

  static bool _perteneceACategoria(Recuerdo recuerdo, String categoriaId) {
    return recuerdo.categoriaId == categoriaId ||
        recuerdo.lugarCatalogoId == categoriaId;
  }

  static List<Recuerdo> forCategoria(String id) {
    return SessionRecuerdos.items
        .where((recuerdo) => _perteneceACategoria(recuerdo, id))
        .toList();
  }

  static List<Recuerdo> forZona(String zonaId) {
    final zona = CatalogoSession.instance.zonaById(zonaId);
    if (zona == null) return [];

    return forCategoria(zona.categoriaId)
        .where((recuerdo) => recuerdo.zonaId == zonaId)
        .toList();
  }

  static List<Recuerdo> forCategoriaSinZona(String categoriaId) {
    return forCategoria(categoriaId)
        .where((recuerdo) => recuerdo.zonaId == null || recuerdo.zonaId!.isEmpty)
        .toList();
  }

  static int countForZona(String zonaId) => forZona(zonaId).length;

  static int countForCategoriaSinZona(String categoriaId) =>
      forCategoriaSinZona(categoriaId).length;

  static List<Recuerdo> allRecuerdos() {
    final seen = <String>{};
    final result = <Recuerdo>[];

    for (final categoria in CatalogoSession.instance.categorias) {
      for (final recuerdo in forCategoria(categoria.id)) {
        if (seen.add(recuerdo.id)) {
          result.add(recuerdo);
        }
      }
    }

    return result;
  }

  static List<Recuerdo> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return [];

    return allRecuerdos().where((recuerdo) {
      final categoria = resolveCategoria(
        recuerdo.categoriaId ?? recuerdo.lugarCatalogoId ?? '',
      );
      final zona = CatalogoSession.instance.zonaById(recuerdo.zonaId);
      return recuerdo.titulo.toLowerCase().contains(normalized) ||
          recuerdo.ubicacion.toLowerCase().contains(normalized) ||
          (categoria?.nombre.toLowerCase().contains(normalized) ?? false) ||
          (zona?.nombre.toLowerCase().contains(normalized) ?? false);
    }).toList();
  }

  static int countForCategoria(String id) => forCategoria(id).length;

  static int countForOpcion(OpcionCatalogo opcion) => forCategoria(opcion.id).length;

  static int totalRecuerdos() => allRecuerdos().length;

  static String subtituloInicio() {
    final total = totalRecuerdos();
    return total == 1 ? '1 cosa en su sitio' : '$total cosas en su sitio';
  }
}
