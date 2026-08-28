import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

class LugarCard extends StatelessWidget {
  const LugarCard({
    super.key,
    required this.emoji,
    required this.nombre,
    required this.recuerdosCount,
    this.onTap,
  });

  final String emoji;
  final String nombre;
  final int recuerdosCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final palette = context.palette;

    return AppSurfaceCard(
      onTap: onTap,
      child: Row(
        children: [
          EmojiBadge(emoji: emoji, size: 56, fontSize: 28),
          const SizedBox(width: AppSpacing.md + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$recuerdosCount recuerdos',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: palette.textTertiary,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class ViajeCard extends StatelessWidget {
  const ViajeCard({
    super.key,
    required this.emoji,
    required this.nombre,
    required this.recuerdosCount,
    this.onTap,
  });

  final String emoji;
  final String nombre;
  final int recuerdosCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LugarCard(
      emoji: emoji,
      nombre: nombre,
      recuerdosCount: recuerdosCount,
      onTap: onTap,
    );
  }
}
