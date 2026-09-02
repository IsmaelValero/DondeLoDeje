import 'dart:typed_data';

class Recuerdo {
  const Recuerdo({
    required this.id,
    required this.emoji,
    required this.titulo,
    required this.ubicacion,
    this.categoriaId,
    this.lugarCatalogoId,
    this.zonaId,
    this.fotoBytes,
  });

  final String id;
  final String emoji;
  final String titulo;
  final String ubicacion;
  final String? categoriaId;
  final String? lugarCatalogoId;
  final String? zonaId;
  final Uint8List? fotoBytes;

  Recuerdo copyWith({
    String? id,
    String? emoji,
    String? titulo,
    String? ubicacion,
    String? categoriaId,
    String? lugarCatalogoId,
    String? zonaId,
    bool clearZonaId = false,
    Uint8List? fotoBytes,
  }) {
    return Recuerdo(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      titulo: titulo ?? this.titulo,
      ubicacion: ubicacion ?? this.ubicacion,
      categoriaId: categoriaId ?? this.categoriaId,
      lugarCatalogoId: lugarCatalogoId ?? this.lugarCatalogoId,
      zonaId: clearZonaId ? null : (zonaId ?? this.zonaId),
      fotoBytes: fotoBytes ?? this.fotoBytes,
    );
  }
}

class MasOption {
  const MasOption({required this.emoji, required this.titulo});

  final String emoji;
  final String titulo;
}
