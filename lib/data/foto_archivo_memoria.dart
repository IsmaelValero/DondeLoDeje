import 'dart:typed_data';

/// Sustituto en plataformas sin sistema de archivos (web): las fotos solo
/// viven en la caché de memoria de [FotoStore] durante la sesión.
Future<String?> directorioFotos() async => null;

Future<void> escribirArchivo(String ruta, Uint8List bytes) async {}

Future<Uint8List?> leerArchivo(String ruta) async => null;

Future<void> borrarArchivo(String ruta) async {}
