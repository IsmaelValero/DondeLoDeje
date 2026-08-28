import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// Tema claro — activo en producción.
ThemeData buildLightTheme() => _buildTheme(AppPalette.light, Brightness.light);

/// Tema oscuro — preparado, no activo todavía.
ThemeData buildDarkTheme() => _buildTheme(AppPalette.dark, Brightness.dark);

/// Alias de compatibilidad con el nombre anterior.
ThemeData buildAppTheme() => buildLightTheme();

ThemeData _buildTheme(AppPalette palette, Brightness brightness) {
  final isLight = brightness == Brightness.light;

  final colorScheme = isLight
      ? ColorScheme.light(
          primary: palette.accent,
          onPrimary: palette.onAccent,
          primaryContainer: palette.accentLight,
          onPrimaryContainer: palette.accentDark,
          secondary: palette.accentDark,
          surface: palette.surface,
          onSurface: palette.textPrimary,
          onSurfaceVariant: palette.textSecondary,
          outline: palette.border,
          outlineVariant: palette.divider,
        )
      : ColorScheme.dark(
          primary: palette.accent,
          onPrimary: palette.onAccent,
          primaryContainer: palette.accentLight,
          onPrimaryContainer: palette.accent,
          secondary: palette.accentDark,
          surface: palette.surface,
          onSurface: palette.textPrimary,
          onSurfaceVariant: palette.textSecondary,
          outline: palette.border,
          outlineVariant: palette.divider,
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.background,
    textTheme: buildAppTextTheme(palette),
    extensions: [AppTokens.defaults, palette],
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      foregroundColor: palette.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      systemOverlayStyle:
          isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    ),
    cardTheme: CardTheme(
      color: palette.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
        side: BorderSide(color: palette.border, width: 0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md + 2,
      ),
      hintStyle: TextStyle(
        color: palette.textTertiary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.mdAll,
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdAll,
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdAll,
        borderSide: BorderSide(color: palette.accent, width: 1.5),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: palette.accent,
      foregroundColor: palette.onAccent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: palette.surface,
      indicatorColor: palette.accentLight,
      surfaceTintColor: Colors.transparent,
      shadowColor: palette.shadow,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 24,
          color: selected ? palette.accent : palette.textTertiary,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? palette.accent : palette.textTertiary,
        );
      }),
    ),
    dividerTheme: DividerThemeData(
      color: palette.divider,
      thickness: 1,
      space: 1,
    ),
    splashColor: palette.accent.withValues(alpha: 0.08),
    highlightColor: palette.accent.withValues(alpha: 0.04),
  );
}
