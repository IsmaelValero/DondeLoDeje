import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dondelodeje/theme/app_palette.dart';
import 'package:dondelodeje/theme/app_theme.dart';

void main() {
  test('AppPalette.dark usa los tonos de marca especificados', () {
    const palette = AppPalette.dark;

    expect(palette.background, const Color(0xFF171817));
    expect(palette.surface, const Color(0xFF20221F));
    expect(palette.card, const Color(0xFF292C28));
    expect(palette.terracotta, const Color(0xFFF07855));
    expect(palette.mustard, const Color(0xFFF2C14E));
    expect(palette.green, const Color(0xFF63B879));
    expect(palette.blue, const Color(0xFF5C9BD1));
    expect(palette.petrol, const Color(0xFF4C9AA8));
    expect(palette.useCardShadow, isFalse);
  });

  test('buildDarkTheme expone la paleta oscura', () {
    final theme = buildDarkTheme();
    final palette = theme.extension<AppPalette>();

    expect(theme.brightness, Brightness.dark);
    expect(palette, AppPalette.dark);
    expect(theme.scaffoldBackgroundColor, AppPalette.dark.background);
    expect(theme.cardTheme.color, AppPalette.dark.card);
  });
}
