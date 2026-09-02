import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String?> directorioFotos() async {
  final base = await getApplicationDocumentsDirectory();
  final directorio = Directory('${base.path}/fotos');
  if (!await directorio.exists()) {
    await directorio.create(recursive: true);
  }
  return directorio.path;
}

Future<void> escribirArchivo(String ruta, Uint8List bytes) async {
  await File(ruta).writeAsBytes(bytes, flush: true);
}

Future<Uint8List?> leerArchivo(String ruta) async {
  final archivo = File(ruta);
  if (!await archivo.exists()) return null;
  return archivo.readAsBytes();
}

Future<void> borrarArchivo(String ruta) async {
  final archivo = File(ruta);
  if (await archivo.exists()) {
    await archivo.delete();
  }
}
