import 'package:flutter/material.dart';

import '../data/opcion_catalogo.dart';
import '../theme/app_content_colors.dart';
import '../theme/app_palette.dart';
import '../theme/catalog_icons.dart';

/// Icono coloreado de una opción de catálogo.
class CatalogIconBadge extends StatelessWidget {
  const CatalogIconBadge({
    super.key,
    required this.opcion,
    this.size = 46,
    this.iconSize = 24,
  });

  final OpcionCatalogo opcion;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = AppContentColors.forOpcion(opcion, palette);
    final accentSoft = palette.softTint(accent);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accentSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Icon(
        CatalogIcons.iconFor(opcion.iconKey),
        size: iconSize,
        color: accent,
      ),
    );
  }
}
