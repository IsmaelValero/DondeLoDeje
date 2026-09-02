import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';
import 'recuerdo_foto.dart';

/// Selector opcional de fotografía para un recuerdo.
class FotoRecuerdoPicker extends StatelessWidget {
  const FotoRecuerdoPicker({
    super.key,
    required this.fotoBytes,
    required this.onChanged,
    this.fotoNombre,
  });

  final Uint8List? fotoBytes;
  final String? fotoNombre;
  final ValueChanged<Uint8List?> onChanged;

  bool get _tieneFoto => fotoBytes != null || fotoNombre != null;

  Future<void> _elegirFoto(BuildContext context) async {
    final origen = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => const _OrigenFotoSheet(),
    );
    if (origen == null) return;

    final picker = ImagePicker();
    final imagen = await picker.pickImage(
      source: origen,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (imagen == null) return;

    onChanged(await imagen.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppSurfaceCard(
      onTap: () => _elegirFoto(context),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: !_tieneFoto
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
                        'Opcional — hazla ahora o elígela de la galería',
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
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: RecuerdoFoto(
                    bytes: fotoBytes,
                    nombre: fotoNombre,
                    borderRadius: AppRadius.mdAll,
                    placeholder: const SizedBox.shrink(),
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

class _OrigenFotoSheet extends StatelessWidget {
  const _OrigenFotoSheet();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            key: const Key('btn_foto_camara'),
            leading: Icon(Icons.photo_camera_outlined, color: palette.petrol),
            title: const Text('Hacer una foto'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            key: const Key('btn_foto_galeria'),
            leading: Icon(Icons.photo_library_outlined, color: palette.petrol),
            title: const Text('Elegir de la galería'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
