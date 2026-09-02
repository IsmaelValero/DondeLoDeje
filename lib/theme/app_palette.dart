import 'package:flutter/material.dart';

/// Colores semánticos de DondeLoDeje, disponibles vía [ThemeExtension].
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentDark,
    required this.accentLight,
    required this.accentSoft,
    required this.accentWarm,
    required this.terracotta,
    required this.mustard,
    required this.green,
    required this.blue,
    required this.petrol,
    required this.border,
    required this.divider,
    required this.shadow,
    required this.onAccent,
    required this.useCardShadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentDark;
  final Color accentLight;
  final Color accentSoft;
  final Color accentWarm;
  final Color terracotta;
  final Color mustard;
  final Color green;
  final Color blue;
  final Color petrol;
  final Color border;
  final Color divider;
  final Color shadow;
  final Color onAccent;
  final bool useCardShadow;

  /// Tema claro — paleta cálida y expresiva.
  static const light = AppPalette(
    background: Color(0xFFF6F1E7),
    surface: Color(0xFFFFFDF8),
    surfaceMuted: Color(0xFFEDE6DA),
    card: Color(0xFFFFFDF8),
    textPrimary: Color(0xFF25231F),
    textSecondary: Color(0xFF706B63),
    textTertiary: Color(0xFF9A948B),
    accent: Color(0xFF245C6B),
    accentDark: Color(0xFF1A4550),
    accentLight: Color(0xFF3978B8),
    accentSoft: Color(0xFFE4EDF0),
    accentWarm: Color(0xFFD65A3A),
    terracotta: Color(0xFFD65A3A),
    mustard: Color(0xFFE3A72F),
    green: Color(0xFF3E8E5B),
    blue: Color(0xFF3978B8),
    petrol: Color(0xFF245C6B),
    border: Color(0xFFE8E0D4),
    divider: Color(0xFFE8E0D4),
    shadow: Color(0x1825231F),
    onAccent: Color(0xFFFFFFFF),
    useCardShadow: true,
  );

  /// Tema oscuro — fondos profundos con acentos de marca más luminosos.
  static const dark = AppPalette(
    background: Color(0xFF171817),
    surface: Color(0xFF20221F),
    surfaceMuted: Color(0xFF252825),
    card: Color(0xFF292C28),
    textPrimary: Color(0xFFF6F1E7),
    textSecondary: Color(0xFFC8C2B8),
    textTertiary: Color(0xFF8F8980),
    accent: Color(0xFF4C9AA8),
    accentDark: Color(0xFF3A7F8C),
    accentLight: Color(0xFF5C9BD1),
    accentSoft: Color(0xFF263033),
    accentWarm: Color(0xFFF07855),
    terracotta: Color(0xFFF07855),
    mustard: Color(0xFFF2C14E),
    green: Color(0xFF63B879),
    blue: Color(0xFF5C9BD1),
    petrol: Color(0xFF4C9AA8),
    border: Color(0xFF3A3E39),
    divider: Color(0xFF323530),
    shadow: Color(0x00000000),
    onAccent: Color(0xFF171817),
    useCardShadow: false,
  );

  Color softTint(Color color) =>
      color.withValues(alpha: useCardShadow ? 0.14 : 0.26);

  double get cardBorderAlpha => useCardShadow ? 0.18 : 0.34;

  List<BoxShadow> get cardShadows {
    if (!useCardShadow) return const [];
    return const [
      BoxShadow(
        color: Color(0x1425231F),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Color(0x0825231F),
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ];
  }

  List<BoxShadow> get subtleShadows {
    if (!useCardShadow) return const [];
    return const [
      BoxShadow(
        color: Color(0x0C25231F),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ];
  }

  List<BoxShadow> fabShadow(Color base) => [
        BoxShadow(
          color: base.withValues(alpha: useCardShadow ? 0.18 : 0.12),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentDark,
    Color? accentLight,
    Color? accentSoft,
    Color? accentWarm,
    Color? terracotta,
    Color? mustard,
    Color? green,
    Color? blue,
    Color? petrol,
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
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentDark: accentDark ?? this.accentDark,
      accentLight: accentLight ?? this.accentLight,
      accentSoft: accentSoft ?? this.accentSoft,
      accentWarm: accentWarm ?? this.accentWarm,
      terracotta: terracotta ?? this.terracotta,
      mustard: mustard ?? this.mustard,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      petrol: petrol ?? this.petrol,
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
