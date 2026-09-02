import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/zona.dart';
import '../navigation/app_routes.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../utils/recuerdo_resolver.dart';
import 'app_surface_card.dart';
import 'recuerdo_foto_viewer.dart';

class RecuerdoCard extends StatelessWidget {
  const RecuerdoCard({
    super.key,
    required this.recuerdo,
    this.onEdit,
    this.onUpdated,
  });

  final Recuerdo recuerdo;
  final VoidCallback? onEdit;
  final VoidCallback? onUpdated;

  Future<void> _openEdit(BuildContext context) async {
    if (onEdit != null) {
      onEdit!();
      return;
    }

    final updated = await AppNavigation.openEditarRecuerdo(context, recuerdo.id);
    if (updated == true) {
      onUpdated?.call();
    }
  }

  void _openImagen(BuildContext context) {
    RecuerdoFotoViewer.open(context, recuerdo);
  }

  @override
  Widget build(BuildContext context) {
    final zona = RecuerdoResolver.zonaFor(recuerdo);
    final ubicacionConcreta = RecuerdoResolver.ubicacionConcretaForDisplay(recuerdo);
    final textTheme = Theme.of(context).textTheme;
    final palette = context.palette;

    return AppSurfaceCard(
      key: Key('recuerdo_card_${recuerdo.id}'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg - 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            key: const Key('recuerdo_card_imagen'),
            behavior: HitTestBehavior.opaque,
            onTap: () => _openImagen(context),
            child: recuerdo.fotoBytes != null
                ? ClipRRect(
                    borderRadius: AppRadius.smAll,
                    child: Image.memory(
                      recuerdo.fotoBytes!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  )
                : const RecuerdoSinFotoBadge(),
          ),
          const SizedBox(width: AppSpacing.md + 2),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('recuerdo_card_contenido'),
                onTap: () => _openEdit(context),
                borderRadius: AppRadius.smAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: _buildContenido(
                    zona,
                    ubicacionConcreta,
                    textTheme,
                    palette,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido(
    Zona? zona,
    String ubicacionConcreta,
    TextTheme textTheme,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recuerdo.titulo,
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (zona != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.meeting_room_outlined,
                size: 15,
                color: palette.petrol.withValues(alpha: 0.9),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  zona.nombre,
                  style: textTheme.bodyMedium?.copyWith(
                    color: palette.petrol,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (ubicacionConcreta.isNotEmpty) ...[
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
                  ubicacionConcreta,
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
    );
  }
}
