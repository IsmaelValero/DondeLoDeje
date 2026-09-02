import 'dart:typed_data';

import 'foto_archivo_memoria.dart'
    if (dart.library.io) 'foto_archivo_io.dart' as archivo;

/// Guarda las fotos de los recuerdos como archivos en el dispositivo.
///
/// El JSON de datos solo almacena el nombre del archivo, para no cargar
/// imágenes enteras en memoria al arrancar.
abstract final class FotoStore {
  static const _maxEnCache = 40;

  static String? _directorio;
  static final Map<String, Uint8List> _cache = {};

  static Future<void> init() async {
    try {
      _directorio = await archivo.directorioFotos();
    } catch (_) {
      // Sin sistema de archivos disponible las fotos se quedan en memoria.
      _directorio = null;
    }
  }

  static Future<String> guardar(Uint8List bytes) async {
    final nombre = 'foto-${DateTime.now().microsecondsSinceEpoch}.jpg';
    final ruta = _rutaDe(nombre);
    if (ruta != null) {
      await archivo.escribirArchivo(ruta, bytes);
    }
    _memorizar(nombre, bytes);
    return nombre;
  }

  static Future<Uint8List?> leer(String nombre) async {
    final enCache = _cache[nombre];
    if (enCache != null) return enCache;

    final ruta = _rutaDe(nombre);
    if (ruta == null) return null;

    final bytes = await archivo.leerArchivo(ruta);
    if (bytes != null) _memorizar(nombre, bytes);
    return bytes;
  }

  /// Bytes ya cargados, para pintar sin parpadeo en el primer frame.
  static Uint8List? enCache(String nombre) => _cache[nombre];

  static Future<void> borrar(String nombre) async {
    _cache.remove(nombre);
    final ruta = _rutaDe(nombre);
    if (ruta != null) {
      await archivo.borrarArchivo(ruta);
    }
  }

  static String? _rutaDe(String nombre) {
    final directorio = _directorio;
    return directorio == null ? null : '$directorio/$nombre';
  }

  static void _memorizar(String nombre, Uint8List bytes) {
    if (_cache.length >= _maxEnCache) {
      _cache.remove(_cache.keys.first);
    }
    _cache[nombre] = bytes;
  }

  /// Solo para tests.
  static void reset() {
    _directorio = null;
    _cache.clear();
  }
}
