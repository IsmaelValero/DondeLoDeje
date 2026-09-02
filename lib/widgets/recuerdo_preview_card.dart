import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/opcion_catalogo.dart';
import '../data/zona.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

/// Previsualización ligera de cómo quedará el recuerdo.
class RecuerdoPreviewCard extends StatelessWidget {
  const RecuerdoPreviewCard({
    super.key,
    required this.nombre,
    required this.categoria,
    this.zona,
    required this.ubicacionConcreta,
    this.fotoBytes,
  });

  final String nombre;
  final OpcionCatalogo categoria;
  final Zona? zona;
  final String ubicacionConcreta;
  final Uint8List? fotoBytes;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final titulo = nombre.trim().isEmpty ? 'Tu recuerdo' : nombre.trim();
    final detalleTexto = ubicacionConcreta.trim();

    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fotoBytes != null)
                ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: Image.memory(
                    fotoBytes!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const RecuerdoSinFotoBadge(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      categoria.nombre,
                      style: textTheme.bodyLarge?.copyWith(
                        color: palette.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (zona != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        zona!.nombre,
                        style: textTheme.bodyMedium?.copyWith(
                          color: palette.petrol,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (detalleTexto.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              detalleTexto,
              style: textTheme.bodyMedium?.copyWith(
                color: palette.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
