import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../theme/app_theme_session.dart';
import 'almacen_local.dart';
import 'catalogo_session.dart';
import 'foto_store.dart';
import 'models.dart';
import 'opcion_catalogo.dart';
import 'session_recuerdos.dart';
import 'user_session.dart';
import 'zona.dart';

/// Guarda y restaura los datos del usuario en el dispositivo.
///
/// Todo vive en local: no hay servidores ni sincronización.
abstract final class Persistencia {
  static const _version = 1;
  static const _esperaGuardado = Duration(milliseconds: 300);

  static AlmacenLocal _almacen = AlmacenMemoria();
  static bool _iniciada = false;
  static bool _restaurando = false;
  static Timer? _guardadoPendiente;

  static Future<void> init({AlmacenLocal? almacen}) async {
    if (_iniciada) return;

    _almacen = almacen ?? const AlmacenPreferencias();
    await FotoStore.init();
    await _restaurar();
    _escucharCambios();
    _iniciada = true;
  }

  static Future<void> _restaurar() async {
    final crudo = await _almacen.leer();
    if (crudo == null || crudo.isEmpty) return;

    _restaurando = true;
    try {
      final decodificado = jsonDecode(crudo);
      if (decodificado is! Map<String, dynamic>) return;

      UserSession.instance.restaurar(decodificado['nombre'] as String?);
      AppThemeSession.instance.restaurar(
        _temaDesde(decodificado['tema'] as String?),
      );

      final categorias = _lista(decodificado['categorias'], OpcionCatalogo.fromJson);
      final zonas = _lista(decodificado['zonas'], Zona.fromJson);
      if (categorias.isNotEmpty || zonas.isNotEmpty) {
        CatalogoSession.instance.restaurar(categorias: categorias, zonas: zonas);
      }

      SessionRecuerdos.restaurar(
        _lista(decodificado['recuerdos'], Recuerdo.fromJson),
      );
    } catch (_) {
      // Con datos corruptos se arranca limpio en vez de dejar la app inservible.
    } finally {
      _restaurando = false;
    }
  }

  static void _escucharCambios() {
    CatalogoSession.instance.addListener(_programarGuardado);
    UserSession.instance.addListener(_programarGuardado);
    AppThemeSession.instance.addListener(_programarGuardado);
    SessionRecuerdos.onCambio = _programarGuardado;
  }

  static void _programarGuardado() {
    if (_restaurando) return;

    _guardadoPendiente?.cancel();
    _guardadoPendiente = Timer(_esperaGuardado, guardarAhora);
  }

  static Future<void> guardarAhora() async {
    _guardadoPendiente?.cancel();
    _guardadoPendiente = null;

    final datos = {
      'version': _version,
      'nombre': UserSession.instance.displayName,
      'tema': AppThemeSession.instance.mode.name,
      'categorias': [
        for (final categoria in CatalogoSession.instance.categorias)
          categoria.toJson(),
      ],
      'zonas': [
        for (final zona in CatalogoSession.instance.zonas) zona.toJson(),
      ],
      'recuerdos': [
        for (final recuerdo in SessionRecuerdos.items) recuerdo.toJson(),
      ],
    };

    await _almacen.escribir(jsonEncode(datos));
  }

  static ThemeMode _temaDesde(String? valor) {
    return switch (valor) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
  }

  static List<T> _lista<T>(
    Object? crudo,
    T? Function(Map<String, dynamic>) parse,
  ) {
    if (crudo is! List) return [];

    final resultado = <T>[];
    for (final elemento in crudo) {
      if (elemento is! Map) continue;
      final parsed = parse(Map<String, dynamic>.from(elemento));
      if (parsed != null) resultado.add(parsed);
    }
    return resultado;
  }

  /// Solo para tests.
  static void reset() {
    _guardadoPendiente?.cancel();
    _guardadoPendiente = null;
    CatalogoSession.instance.removeListener(_programarGuardado);
    UserSession.instance.removeListener(_programarGuardado);
    AppThemeSession.instance.removeListener(_programarGuardado);
    SessionRecuerdos.onCambio = null;
    _almacen = AlmacenMemoria();
    _iniciada = false;
    _restaurando = false;
  }
}
