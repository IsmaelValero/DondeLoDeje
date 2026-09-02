import '../data/catalogo_session.dart';
import '../data/opcion_catalogo.dart';
import '../data/models.dart';
import '../data/zona.dart';
import 'ubicacion_parser.dart';

/// Resuelve categoría, zona y campos editables a partir de un recuerdo.
abstract final class RecuerdoResolver {
  static String? categoriaIdFor(Recuerdo recuerdo) {
    if (recuerdo.categoriaId != null) return recuerdo.categoriaId;
    if (recuerdo.lugarCatalogoId != null) return recuerdo.lugarCatalogoId;
    return null;
  }

  static String? zonaIdFor(Recuerdo recuerdo) => recuerdo.zonaId;

  static Zona? zonaFor(Recuerdo recuerdo) {
    return CatalogoSession.instance.zonaById(recuerdo.zonaId);
  }

  static String ubicacionConcretaForEdit(
    Recuerdo recuerdo,
    OpcionCatalogo? categoria,
  ) {
    final parts = UbicacionParts.fromString(recuerdo.ubicacion);
    if (categoria != null && parts.lugar == categoria.nombre) {
      return parts.detalle;
    }
    if (parts.lugar != null && parts.detalle.isNotEmpty) {
      return parts.detalle;
    }
    return recuerdo.ubicacion;
  }

  static String ubicacionConcretaForDisplay(Recuerdo recuerdo) {
    final categoriaId = categoriaIdFor(recuerdo);
    final categoria = CatalogoSession.instance.categoriaById(categoriaId);
    return ubicacionConcretaForEdit(recuerdo, categoria);
  }
}
