import 'package:flutter/material.dart';

import '../data/opcion_catalogo.dart';
import '../theme/app_content_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';
import 'catalog_icon_badge.dart';

/// Tarjeta de acceso rápido a un lugar en la cuadrícula del inicio.
class LugarFrecuenteCard extends StatelessWidget {
  const LugarFrecuenteCard({
    super.key,
    required this.opcion,
    required this.objetosCount,
    required this.onTap,
  });

  final OpcionCatalogo opcion;
  final int objetosCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final accent = AppContentColors.forOpcion(opcion, palette);
    final objetosLabel = objetosCount == 1 ? '1 objeto' : '$objetosCount objetos';

    return AppSurfaceCard(
      onTap: onTap,
      accentColor: accent,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogIconBadge(opcion: opcion, size: 51, iconSize: 26),
          const Spacer(),
          Text(
            opcion.nombre,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            objetosLabel,
            style: textTheme.bodySmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
