import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_session.dart';
import '../widgets/app_surface_card.dart';

/// Selector de apariencia: claro (predeterminado) u oscuro.
class AparienciaScreen extends StatelessWidget {
  const AparienciaScreen({super.key});

  static const screenKey = ValueKey<String>('apariencia_screen');

  @override
  Widget build(BuildContext context) {
    final session = AppThemeSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        return Scaffold(
          key: screenKey,
          appBar: AppBar(title: const Text('Apariencia')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              children: [
                Text(
                  'Elige cómo quieres ver DondeLoDeje',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                _ThemeOptionTile(
                  key: const Key('theme_option_light'),
                  emoji: '☀️',
                  title: 'Claro',
                  subtitle: 'Fondo crema y colores cálidos',
                  previewColors: [
                    AppPalette.light.background,
                    AppPalette.light.card,
                    AppPalette.light.terracotta,
                    AppPalette.light.petrol,
                  ],
                  selected: session.mode == ThemeMode.light,
                  onTap: () => session.setMode(ThemeMode.light),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                _ThemeOptionTile(
                  key: const Key('theme_option_dark'),
                  emoji: '🌙',
                  title: 'Oscuro',
                  subtitle: 'Fondos profundos con acentos vivos',
                  previewColors: [
                    AppPalette.dark.background,
                    AppPalette.dark.card,
                    AppPalette.dark.terracotta,
                    AppPalette.dark.petrol,
                  ],
                  selected: session.mode == ThemeMode.dark,
                  onTap: () => session.setMode(ThemeMode.dark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.previewColors,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> previewColors;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final accent = selected ? palette.petrol : palette.border;

    return AppSurfaceCard(
      onTap: onTap,
      accentColor: accent,
      showShadow: false,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    for (var i = 0; i < previewColors.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.xs),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: previewColors[i],
                          shape: BoxShape.circle,
                          border: Border.all(color: palette.border),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? palette.petrol : palette.textTertiary,
            size: 26,
          ),
        ],
      ),
    );
  }
}
