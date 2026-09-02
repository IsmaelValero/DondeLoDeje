import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dondelodeje/data/almacen_local.dart';
import 'package:dondelodeje/data/catalogo_session.dart';
import 'package:dondelodeje/data/persistencia.dart';
import 'package:dondelodeje/data/recuerdos_query.dart';
import 'package:dondelodeje/data/session_recuerdos.dart';
import 'package:dondelodeje/data/user_session.dart';
import 'package:dondelodeje/theme/app_theme_session.dart';
import 'package:dondelodeje/utils/recuerdo_factory.dart';

/// Vuelve al estado de una app recién instalada, conservando el almacén.
void simularCierre() {
  Persistencia.reset();
  SessionRecuerdos.clear();
  CatalogoSession.instance.reset();
  UserSession.instance.reset();
  AppThemeSession.instance.reset();
}

void main() {
  setUp(simularCierre);
  tearDown(simularCierre);

  test('el nombre y el tema sobreviven al cierre de la app', () async {
    final almacen = AlmacenMemoria();
    await Persistencia.init(almacen: almacen);

    UserSession.instance.completeOnboarding('Ismael');
    AppThemeSession.instance.setMode(ThemeMode.dark);
    await Persistencia.guardarAhora();

    simularCierre();
    expect(UserSession.instance.displayName, isNull);

    await Persistencia.init(almacen: almacen);

    expect(UserSession.instance.displayName, 'Ismael');
    expect(AppThemeSession.instance.mode, ThemeMode.dark);
  });

  test('los lugares y zonas creados sobreviven al cierre', () async {
    final almacen = AlmacenMemoria();
    await Persistencia.init(almacen: almacen);

    final lugar = CatalogoSession.instance.addCategoria(
      nombre: 'Despensa',
      iconKey: 'store',
    );
    CatalogoSession.instance.addZona(
      categoriaId: lugar.id,
      nombre: 'Estante alto',
    );
    await Persistencia.guardarAhora();

    simularCierre();
    await Persistencia.init(almacen: almacen);

    final nombres =
        CatalogoSession.instance.categorias.map((c) => c.nombre).toList();
    expect(nombres, contains('Despensa'));
    expect(
      CatalogoSession.instance.zonasForCategoria(lugar.id).map((z) => z.nombre),
      contains('Estante alto'),
    );
  });

  test('un lugar eliminado no reaparece al reabrir', () async {
    final almacen = AlmacenMemoria();
    await Persistencia.init(almacen: almacen);

    CatalogoSession.instance.removeCategoria('cat-coche');
    await Persistencia.guardarAhora();

    simularCierre();
    await Persistencia.init(almacen: almacen);

    final ids = CatalogoSession.instance.categorias.map((c) => c.id).toList();
    expect(ids, isNot(contains('cat-coche')));
    expect(ids, contains('cat-casa'));
  });

  test('los recuerdos creados sobreviven al cierre', () async {
    final almacen = AlmacenMemoria();
    await Persistencia.init(almacen: almacen);

    SessionRecuerdos.add(
      RecuerdoFactory.fromForm(
        nombre: 'Mochila de porteo',
        categoria: CatalogoSession.instance.categoriaDefault,
        ubicacionConcreta: '3er estante',
        fotoNombre: 'foto-1.jpg',
      ),
    );
    await Persistencia.guardarAhora();

    simularCierre();
    expect(SessionRecuerdos.items, isEmpty);

    await Persistencia.init(almacen: almacen);

    expect(SessionRecuerdos.items, hasLength(1));
    final recuerdo = SessionRecuerdos.items.first;
    expect(recuerdo.titulo, 'Mochila de porteo');
    expect(recuerdo.ubicacion, '3er estante');
    expect(recuerdo.fotoNombre, 'foto-1.jpg');
  });

  test('la edición de un recuerdo sobrevive al cierre', () async {
    final almacen = AlmacenMemoria();
    await Persistencia.init(almacen: almacen);

    SessionRecuerdos.add(
      RecuerdoFactory.fromForm(
        nombre: 'Cámara',
        categoria: CatalogoSession.instance.categoriaDefault,
        ubicacionConcreta: 'Estante 3',
      ),
    );

    SessionRecuerdos.upsert(
      RecuerdoFactory.fromFormUpdate(
        original: SessionRecuerdos.items.first,
        nombre: 'Cámara réflex',
        categoria: CatalogoSession.instance.categoriaDefault,
        ubicacionConcreta: 'Caja azul',
      ),
    );
    await Persistencia.guardarAhora();

    simularCierre();
    await Persistencia.init(almacen: almacen);

    expect(SessionRecuerdos.items, hasLength(1));
    expect(SessionRecuerdos.items.first.titulo, 'Cámara réflex');
    expect(SessionRecuerdos.items.first.ubicacion, 'Caja azul');
  });

  test('una instalación nueva no trae datos de ejemplo', () async {
    await Persistencia.init(almacen: AlmacenMemoria());

    expect(SessionRecuerdos.items, isEmpty);
    expect(RecuerdosQuery.totalRecuerdos(), 0);
    expect(
      CatalogoSession.instance.categorias.map((c) => c.nombre),
      ['Casa', 'Coche', 'Trastero'],
    );
    expect(
      CatalogoSession.instance.zonasForCategoria('cat-casa').map((z) => z.nombre),
      ['Cocina', 'Salón', 'Baño', 'Cuarto Papás'],
    );
    expect(CatalogoSession.instance.zonasForCategoria('cat-coche'), isEmpty);
    expect(CatalogoSession.instance.zonasForCategoria('cat-trastero'), isEmpty);
  });

  test('un almacén corrupto no impide arrancar', () async {
    final almacen = AlmacenMemoria('{esto no es json valido');

    await Persistencia.init(almacen: almacen);

    expect(CatalogoSession.instance.categorias, isNotEmpty);
    expect(UserSession.instance.hasCompletedOnboarding, isFalse);
  });
}
