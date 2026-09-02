import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dondelodeje/data/catalogo_session.dart';
import 'package:dondelodeje/data/session_recuerdos.dart';
import 'package:dondelodeje/data/user_session.dart';
import 'package:dondelodeje/app.dart';
import 'package:dondelodeje/screens/apariencia_screen.dart';
import 'package:dondelodeje/screens/home_screen.dart';
import 'package:dondelodeje/screens/lugar_zonas_screen.dart';
import 'package:dondelodeje/screens/mas_screen.dart';
import 'package:dondelodeje/screens/onboarding_screen.dart';
import 'package:dondelodeje/screens/panel_lugares_screen.dart';
import 'package:dondelodeje/screens/zona_recuerdos_screen.dart';
import 'package:dondelodeje/theme/app_palette.dart';
import 'package:dondelodeje/theme/app_theme_session.dart';
import 'package:dondelodeje/widgets/lugar_frecuente_card.dart';
import 'package:dondelodeje/widgets/recuerdo_card.dart';

void expectOnHome(WidgetTester tester) {
  expect(find.byKey(HomeScreen.screenKey), findsOneWidget);
  expect(find.text('Donde'), findsOneWidget);
  expect(find.text('Lo'), findsOneWidget);
  expect(find.text('Deje'), findsOneWidget);
  expect(find.textContaining('en su sitio'), findsOneWidget);
  expect(find.text('Recientes'), findsNothing);
  expect(find.byType(NavigationBar), findsNothing);
}

Future<void> _tapGuardarRecuerdo(WidgetTester tester) async {
  final finder = find.byKey(const Key('btn_guardar_recuerdo'));
  await tester.scrollUntilVisible(
    finder,
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapEliminarRecuerdo(WidgetTester tester) async {
  final finder = find.byKey(const Key('btn_eliminar_recuerdo'));
  await tester.scrollUntilVisible(
    finder,
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _seleccionarDropdown(
  WidgetTester tester,
  Key key,
  String optionText,
) async {
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.text(optionText).last);
  await tester.pumpAndSettle();
}

/// Crea un recuerdo desde el formulario, como haría el usuario.
Future<void> crearRecuerdo(
  WidgetTester tester, {
  required String nombre,
  required String lugar,
  String? zona,
  String? ubicacion,
}) async {
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(const Key('campo_nombre')), nombre);
  await _seleccionarDropdown(tester, const Key('dropdown_categoria'), lugar);

  if (zona != null) {
    await _seleccionarDropdown(tester, const Key('dropdown_zona'), zona);
  }
  if (ubicacion != null) {
    await tester.enterText(find.byKey(const Key('campo_ubicacion')), ubicacion);
  }

  await _tapGuardarRecuerdo(tester);
}

Future<void> abrirLugar(WidgetTester tester, String nombre) async {
  final finder = find.descendant(
    of: find.byType(LugarFrecuenteCard),
    matching: find.text(nombre),
  );

  // La rejilla de lugares puede quedar bajo el pliegue en pantallas pequeñas.
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SessionRecuerdos.clear();
    CatalogoSession.instance.reset();
    AppThemeSession.instance.reset();
    UserSession.instance.reset();
    UserSession.instance.completeOnboarding('Ismael');
  });

  testWidgets('Onboarding pide el nombre la primera vez', (WidgetTester tester) async {
    UserSession.instance.reset();

    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingScreen.screenKey), findsOneWidget);
    expect(find.text('¿Cómo te llamas?'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('campo_nombre_onboarding')), 'María');
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn_empezar_onboarding')));
    await tester.pumpAndSettle();

    expectOnHome(tester);
    expect(find.text('M'), findsOneWidget);
  });

  testWidgets('Una instalación nueva arranca sin recuerdos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    expect(find.text('0 cosas en su sitio'), findsOneWidget);
    expect(find.byType(RecuerdoCard), findsNothing);
  });

  testWidgets('Perfil en Ajustes muestra el nombre y permite editarlo', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home_user_avatar')));
    await tester.pumpAndSettle();

    expect(find.byKey(MasScreen.screenKey), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Ismael'), findsWidgets);

    await tester.enterText(find.byKey(const Key('campo_nombre_perfil')), 'Ana');
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn_guardar_perfil')));
    await tester.pumpAndSettle();

    expect(UserSession.instance.displayName, 'Ana');

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('Muestra la pantalla principal con identidad visual', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    expectOnHome(tester);
    expect(find.text('¿Qué estás buscando?'), findsOneWidget);
    expect(find.text('Casa'), findsOneWidget);
    expect(find.text('Coche'), findsOneWidget);
    expect(find.text('Trastero'), findsOneWidget);
  });

  testWidgets('Desde inicio explora lugar → zona → edita recuerdo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Llaves de repuesto',
      lugar: 'Casa',
      zona: 'Cocina',
      ubicacion: 'Cajón de la entrada',
    );

    await abrirLugar(tester, 'Casa');

    expect(
      find.byKey(LugarZonasScreen.screenKeyFor('cat-casa')),
      findsOneWidget,
    );
    expect(find.text('Zonas'), findsOneWidget);
    expect(find.text('Cuarto Papás'), findsOneWidget);
    expect(find.byKey(const Key('btn_anadir_zona')), findsNothing);

    await tester.tap(find.text('Cocina'));
    await tester.pumpAndSettle();

    expect(find.byKey(ZonaRecuerdosScreen.screenKey), findsOneWidget);
    expect(find.text('Llaves de repuesto'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('recuerdo_card_contenido')),
        matching: find.text('Llaves de repuesto'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Editar recuerdo'), findsOneWidget);

    final botonCambiar = find.text('Cambiar de Sitio');
    await tester.scrollUntilVisible(
      botonCambiar,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(botonCambiar, findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expectOnHome(tester);
  });

  testWidgets('Busca recuerdos por nombre', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Cámara',
      lugar: 'Trastero',
      ubicacion: 'Estante 3',
    );

    await tester.enterText(find.byKey(const Key('home_search')), 'cámara');
    await tester.pumpAndSettle();

    expectOnHome(tester);
    expect(find.text('Cámara'), findsWidgets);
  });

  testWidgets('FAB abre nuevo recuerdo y valida el campo principal', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo recuerdo'), findsOneWidget);

    await _tapGuardarRecuerdo(tester);

    expect(find.text('Escribe qué quieres recordar'), findsOneWidget);
  });

  testWidgets('Guardar recuerdo vuelve al inicio', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Pasaporte',
      lugar: 'Trastero',
      ubicacion: 'Cajón superior',
    );

    expectOnHome(tester);
    expect(find.text('1 cosa en su sitio'), findsOneWidget);
  });

  testWidgets('Panel de lugares accesible desde menú', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home_user_avatar')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lugares'));
    await tester.pumpAndSettle();

    expect(find.byKey(PanelLugaresScreen.screenKey), findsOneWidget);
    expect(find.text('Lugares'), findsWidgets);

    await tester.tap(find.text('Añadir').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('campo_nombre_catalogo')), 'Despensa');
    await tester.tap(find.byKey(const Key('btn_confirmar_catalogo')));
    await tester.pumpAndSettle();

    expect(find.text('Despensa'), findsOneWidget);
  });

  testWidgets('Navegación abre edición al pulsar información del recuerdo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Cámara',
      lugar: 'Trastero',
      ubicacion: 'Estante 3',
    );

    await abrirLugar(tester, 'Trastero');

    await tester.tap(find.text('Sin zona'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('recuerdo_card_contenido')),
        matching: find.text('Cámara'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Editar recuerdo'), findsOneWidget);

    final botonCambiar = find.text('Cambiar de Sitio');
    await tester.scrollUntilVisible(
      botonCambiar,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(botonCambiar, findsOneWidget);
  });

  testWidgets('Imagen del recuerdo abre visor a pantalla completa', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Cámara',
      lugar: 'Trastero',
      ubicacion: 'Estante 3',
    );

    await abrirLugar(tester, 'Trastero');

    await tester.tap(find.text('Sin zona'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(RecuerdoCard, 'Cámara'),
        matching: find.byKey(const Key('recuerdo_card_imagen')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recuerdo_foto_viewer')), findsOneWidget);
    expect(find.text('Cámara'), findsWidgets);
  });

  testWidgets('Eliminar un recuerdo lo quita de la aplicación', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Pasaporte',
      lugar: 'Casa',
      zona: 'Cocina',
      ubicacion: 'Cajón de la entrada',
    );

    expect(find.text('1 cosa en su sitio'), findsOneWidget);

    await abrirLugar(tester, 'Casa');
    await tester.tap(find.text('Cocina'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('recuerdo_card_contenido')),
        matching: find.text('Pasaporte'),
      ),
    );
    await tester.pumpAndSettle();

    await _tapEliminarRecuerdo(tester);

    // Pide confirmación antes de borrar nada.
    final confirmar = find.byKey(const Key('btn_confirmar_eliminar_recuerdo'));
    expect(confirmar, findsOneWidget);
    expect(SessionRecuerdos.items, hasLength(1));

    await tester.tap(confirmar);
    await tester.pumpAndSettle();

    expect(SessionRecuerdos.items, isEmpty);
    expect(find.text('Pasaporte'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expectOnHome(tester);
    expect(find.text('0 cosas en su sitio'), findsOneWidget);
  });

  testWidgets('Cancelar el borrado deja el recuerdo intacto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await crearRecuerdo(
      tester,
      nombre: 'Pasaporte',
      lugar: 'Trastero',
      ubicacion: 'Cajón superior',
    );

    await abrirLugar(tester, 'Trastero');
    await tester.tap(find.text('Sin zona'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('recuerdo_card_contenido')),
        matching: find.text('Pasaporte'),
      ),
    );
    await tester.pumpAndSettle();

    await _tapEliminarRecuerdo(tester);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(SessionRecuerdos.items, hasLength(1));
    expect(find.text('Editar recuerdo'), findsOneWidget);
  });

  testWidgets('Pagina categorías cuando hay más de ocho', (WidgetTester tester) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    for (var i = 1; i <= 6; i++) {
      CatalogoSession.instance.addCategoria(
        nombre: 'Extra $i',
        iconKey: 'label',
      );
    }
    await tester.pumpAndSettle();

    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('Extra 1'), findsOneWidget);
    expect(find.text('Extra 6'), findsNothing);

    await tester.tap(find.byKey(const Key('btn_categorias_siguiente')));
    await tester.pumpAndSettle();

    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('Extra 6'), findsOneWidget);
    expect(find.text('Casa'), findsNothing);
  });

  testWidgets('Apariencia activa modo oscuro y claro es el predeterminado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    expect(AppThemeSession.instance.mode, ThemeMode.light);

    final lightScaffold = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(lightScaffold.theme?.scaffoldBackgroundColor, AppPalette.light.background);

    await tester.tap(find.byKey(const Key('home_user_avatar')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apariencia'));
    await tester.pumpAndSettle();

    expect(find.byKey(AparienciaScreen.screenKey), findsOneWidget);

    await tester.tap(find.byKey(const Key('theme_option_dark')));
    await tester.pumpAndSettle();

    expect(AppThemeSession.instance.mode, ThemeMode.dark);

    await tester.tap(find.byKey(const Key('theme_option_light')));
    await tester.pumpAndSettle();

    expect(AppThemeSession.instance.mode, ThemeMode.light);
  });

  testWidgets('Lugares en ajustes permite añadir zona y ver recuerdo creado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DondeLoDejeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home_user_avatar')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lugares'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Casa'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_anadir_zona')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('campo_nombre_zona')), 'Despensa');
    await tester.tap(find.byKey(const Key('btn_confirmar_zona')));
    await tester.pumpAndSettle();

    expect(find.text('Despensa'), findsOneWidget);
    expect(find.text('Sin zona'), findsNothing);

    // En ajustes la zona no navega a recuerdos, así que el toque no impacta.
    await tester.tap(find.text('Despensa'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byKey(ZonaRecuerdosScreen.screenKey), findsNothing);
    expect(find.text('Despensa'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expectOnHome(tester);

    await crearRecuerdo(
      tester,
      nombre: 'Mochila de porteo',
      lugar: 'Casa',
      zona: 'Despensa',
      ubicacion: '3er estante de la cómoda',
    );

    expectOnHome(tester);

    await abrirLugar(tester, 'Casa');

    await tester.tap(find.text('Despensa'));
    await tester.pumpAndSettle();

    expect(find.text('Mochila de porteo'), findsOneWidget);
    expect(find.text('3er estante de la cómoda'), findsOneWidget);
  });
}
