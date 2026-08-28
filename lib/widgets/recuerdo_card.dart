import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/ubicacion_parser.dart';
import 'app_surface_card.dart';

class RecuerdoCard extends StatelessWidget {
  const RecuerdoCard({super.key, required this.recuerdo, this.onTap});

  final Recuerdo recuerdo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final parts = UbicacionParts.fromString(recuerdo.ubicacion);
    final textTheme = Theme.of(context).textTheme;
    final palette = context.palette;

    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg - 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmojiBadge(emoji: recuerdo.emoji, size: 52, fontSize: 26),
          const SizedBox(width: AppSpacing.md + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recuerdo.titulo,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (parts.lugar != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 15,
                        color: palette.accent.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          parts.lugar!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: palette.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (parts.detalle.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.near_me_outlined,
                          size: 14,
                          color: palette.textTertiary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          parts.detalle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: palette.textTertiary,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
