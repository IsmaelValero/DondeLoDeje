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
    this.fotoNombre,
  });

  final String id;
  final String emoji;
  final String titulo;
  final String ubicacion;
  final String? categoriaId;
  final String? lugarCatalogoId;
  final String? zonaId;

  /// Bytes en memoria: foto recién elegida o plataformas sin archivos (web).
  final Uint8List? fotoBytes;

  /// Nombre del archivo guardado en el dispositivo.
  final String? fotoNombre;

  bool get tieneFoto => fotoBytes != null || fotoNombre != null;

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
    String? fotoNombre,
    bool clearFoto = false,
  }) {
    return Recuerdo(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      titulo: titulo ?? this.titulo,
      ubicacion: ubicacion ?? this.ubicacion,
      categoriaId: categoriaId ?? this.categoriaId,
      lugarCatalogoId: lugarCatalogoId ?? this.lugarCatalogoId,
      zonaId: clearZonaId ? null : (zonaId ?? this.zonaId),
      fotoBytes: clearFoto ? null : (fotoBytes ?? this.fotoBytes),
      fotoNombre: clearFoto ? null : (fotoNombre ?? this.fotoNombre),
    );
  }

  /// Los bytes no se serializan: la foto vive como archivo aparte.
  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'titulo': titulo,
        'ubicacion': ubicacion,
        if (categoriaId != null) 'categoriaId': categoriaId,
        if (lugarCatalogoId != null) 'lugarCatalogoId': lugarCatalogoId,
        if (zonaId != null) 'zonaId': zonaId,
        if (fotoNombre != null) 'fotoNombre': fotoNombre,
      };

  static Recuerdo? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final titulo = json['titulo'];
    if (id is! String || titulo is! String) return null;

    return Recuerdo(
      id: id,
      emoji: json['emoji'] is String ? json['emoji'] as String : '📌',
      titulo: titulo,
      ubicacion: json['ubicacion'] is String ? json['ubicacion'] as String : '',
      categoriaId: json['categoriaId'] as String?,
      lugarCatalogoId: json['lugarCatalogoId'] as String?,
      zonaId: json['zonaId'] as String?,
      fotoNombre: json['fotoNombre'] as String?,
    );
  }
}

class MasOption {
  const MasOption({required this.emoji, required this.titulo});

  final String emoji;
  final String titulo;
}
