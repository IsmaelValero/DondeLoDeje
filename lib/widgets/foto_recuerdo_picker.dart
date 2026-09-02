import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

/// Selector opcional de fotografía para un recuerdo.
class FotoRecuerdoPicker extends StatelessWidget {
  const FotoRecuerdoPicker({
    super.key,
    required this.fotoBytes,
    required this.onChanged,
  });

  final Uint8List? fotoBytes;
  final ValueChanged<Uint8List?> onChanged;

  Future<void> _elegirFoto(BuildContext context) async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (imagen == null) return;

    final bytes = await imagen.readAsBytes();
    onChanged(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppSurfaceCard(
      onTap: () => _elegirFoto(context),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: fotoBytes == null
          ? Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.accentSoft,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: palette.accent,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Añadir fotografía',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Opcional — ayuda a reconocer el objeto',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: palette.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.memory(
                      fotoBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _elegirFoto(context),
                      icon: const Icon(Icons.photo_outlined, size: 18),
                      label: const Text('Cambiar'),
                    ),
                    TextButton.icon(
                      onPressed: () => onChanged(null),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Quitar'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
