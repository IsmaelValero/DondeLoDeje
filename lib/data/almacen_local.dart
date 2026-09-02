import 'package:shared_preferences/shared_preferences.dart';

/// Destino donde se guarda el JSON con los datos del usuario.
abstract class AlmacenLocal {
  Future<String?> leer();

  Future<void> escribir(String contenido);
}

/// Almacenamiento real del dispositivo.
class AlmacenPreferencias implements AlmacenLocal {
  const AlmacenPreferencias();

  static const _clave = 'dondelodeje_datos_v1';

  @override
  Future<String?> leer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_clave);
  }

  @override
  Future<void> escribir(String contenido) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, contenido);
  }
}

/// Almacenamiento volátil para tests.
class AlmacenMemoria implements AlmacenLocal {
  AlmacenMemoria([this._contenido]);

  String? _contenido;

  @override
  Future<String?> leer() async => _contenido;

  @override
  Future<void> escribir(String contenido) async {
    _contenido = contenido;
  }
}
