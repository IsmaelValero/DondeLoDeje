import 'package:flutter_test/flutter_test.dart';

import 'package:dondelodeje/theme/app_palette.dart';
import 'package:dondelodeje/theme/catalog_colors.dart';
import 'package:dondelodeje/theme/catalog_icons.dart';

void main() {
  test('CatalogIcons.lugares incluye iconos de lugares pedidos', () {
    final keys = CatalogIcons.lugares.map((entry) => entry.key).toSet();

    expect(keys, contains('moto'));
    expect(keys, contains('store'));
    expect(keys, contains('work'));
    expect(keys, contains('kitchen'));
    expect(keys, contains('van'));
    expect(keys, containsAll(['home', 'car', 'garage']));
    expect(keys, isNot(contains('camera')));
    expect(keys, isNot(contains('document')));
  });

  test('CatalogColorKeys.selectable ofrece al menos 10 colores', () {
    expect(CatalogColorKeys.selectable.length, greaterThanOrEqualTo(10));

    final lightColors = CatalogColorKeys.selectable
        .map((key) => CatalogColors.fromKey(key, AppPalette.light))
        .toSet();
    final darkColors = CatalogColorKeys.selectable
        .map((key) => CatalogColors.fromKey(key, AppPalette.dark))
        .toSet();

    expect(lightColors.length, CatalogColorKeys.selectable.length);
    expect(darkColors.length, CatalogColorKeys.selectable.length);
  });
}
