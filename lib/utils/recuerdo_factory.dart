import '../data/opcion_catalogo.dart';
import '../data/models.dart';
import '../data/zona.dart';
import '../theme/catalog_icons.dart';

/// Construye recuerdos a partir de datos de formulario.
abstract final class RecuerdoFactory {
  static String buildUbicacion({String? ubicacionConcreta}) {
    return ubicacionConcreta?.trim() ?? '';
  }

  static Recuerdo fromForm({
    required String nombre,
    required OpcionCatalogo categoria,
    Zona? zona,
    String? ubicacionConcreta,
    String? fotoNombre,
  }) {
    return Recuerdo(
      id: 'rec-${DateTime.now().microsecondsSinceEpoch}',
      emoji: CatalogIcons.emojiFor(categoria.iconKey),
      titulo: nombre.trim(),
      ubicacion: buildUbicacion(ubicacionConcreta: ubicacionConcreta),
      categoriaId: categoria.id,
      lugarCatalogoId: categoria.id,
      zonaId: zona?.id,
      fotoNombre: fotoNombre,
    );
  }

  static Recuerdo fromFormUpdate({
    required Recuerdo original,
    required String nombre,
    required OpcionCatalogo categoria,
    Zona? zona,
    String? ubicacionConcreta,
    String? fotoNombre,
  }) {
    final actualizado = original.copyWith(
      emoji: CatalogIcons.emojiFor(categoria.iconKey),
      titulo: nombre.trim(),
      ubicacion: buildUbicacion(ubicacionConcreta: ubicacionConcreta),
      categoriaId: categoria.id,
      lugarCatalogoId: categoria.id,
      zonaId: zona?.id,
      clearZonaId: zona == null,
      clearFoto: true,
    );

    return fotoNombre == null
        ? actualizado
        : actualizado.copyWith(fotoNombre: fotoNombre);
  }
}
