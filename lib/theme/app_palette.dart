import 'package:flutter/material.dart';

/// Colores semánticos de DondeLoDeje, disponibles vía [ThemeExtension].
/// Los widgets deben usar [BuildContext.palette] en lugar de colores fijos.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentDark,
    required this.accentLight,
    required this.accentSoft,
    required this.border,
    required this.divider,
    required this.shadow,
    required this.onAccent,
    required this.useCardShadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentDark;
  final Color accentLight;
  final Color accentSoft;
  final Color border;
  final Color divider;
  final Color shadow;
  final Color onAccent;
  final bool useCardShadow;

  /// Tema claro — valores actuales de producción.
  static const light = AppPalette(
    background: Color(0xFFEFE8DE),
    surface: Color(0xFFFAF5EE),
    surfaceMuted: Color(0xFFF5EFE6),
    textPrimary: Color(0xFF2F2B27),
    textSecondary: Color(0xFF7D756C),
    textTertiary: Color(0xFFA3988E),
    accent: Color(0xFF6D9189),
    accentDark: Color(0xFF587A72),
    accentLight: Color(0xFFDFE9E5),
    accentSoft: Color(0xFFECF2EF),
    border: Color(0xFFE3DAD0),
    divider: Color(0xFFEAE3D9),
    shadow: Color(0x0A2F2B27),
    onAccent: Color(0xFFFFFFFF),
    useCardShadow: true,
  );

  /// Tema oscuro — versión provisional, pendiente de diseño detallado.
  static const dark = AppPalette(
    background: Color(0xFF1F1D1A),
    surface: Color(0xFF2A2724),
    surfaceMuted: Color(0xFF32302C),
    textPrimary: Color(0xFFEDE8E1),
    textSecondary: Color(0xFFB5ACA2),
    textTertiary: Color(0xFF8E857C),
    accent: Color(0xFF8BAFA6),
    accentDark: Color(0xFF6D9189),
    accentLight: Color(0xFF3A4541),
    accentSoft: Color(0xFF2E3835),
    border: Color(0xFF3A3632),
    divider: Color(0xFF33302C),
    shadow: Color(0x00000000),
    onAccent: Color(0xFFF5F2ED),
    useCardShadow: false,
  );

  List<BoxShadow> get cardShadows {
    if (!useCardShadow) return const [];
    return const [
      BoxShadow(
        color: Color(0x0A2F2B27),
        blurRadius: 12,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: Color(0x052F2B27),
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ];
  }

  List<BoxShadow> get subtleShadows {
    if (!useCardShadow) return const [];
    return const [
      BoxShadow(
        color: Color(0x072F2B27),
        blurRadius: 6,
        offset: Offset(0, 1),
      ),
    ];
  }

  List<BoxShadow> get fabShadow => [
        BoxShadow(
          color: accent.withValues(alpha: useCardShadow ? 0.28 : 0.18),
          blurRadius: 18,
          offset: const Offset(0, 5),
        ),
      ];

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentDark,
    Color? accentLight,
    Color? accentSoft,
    Color? border,
    Color? divider,
    Color? shadow,
    Color? onAccent,
    bool? useCardShadow,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentDark: accentDark ?? this.accentDark,
      accentLight: accentLight ?? this.accentLight,
      accentSoft: accentSoft ?? this.accentSoft,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
      onAccent: onAccent ?? this.onAccent,
      useCardShadow: useCardShadow ?? this.useCardShadow,
    );
  }

  @override
  AppPalette lerp(covariant ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
