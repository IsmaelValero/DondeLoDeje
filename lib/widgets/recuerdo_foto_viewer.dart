import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

/// Visor a pantalla completa de la foto o icono por defecto de un recuerdo.
class RecuerdoFotoViewer extends StatelessWidget {
  const RecuerdoFotoViewer({super.key, required this.recuerdo});

  final Recuerdo recuerdo;

  static Future<void> open(BuildContext context, Recuerdo recuerdo) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => RecuerdoFotoViewer(recuerdo: recuerdo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      key: const Key('recuerdo_foto_viewer'),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          recuerdo.titulo,
          style: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _Media(recuerdo: recuerdo, palette: palette),
            ),
          ),
        ),
      ),
    );
  }
}

class _Media extends StatelessWidget {
  const _Media({required this.recuerdo, required this.palette});

  final Recuerdo recuerdo;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final foto = recuerdo.fotoBytes;
    if (foto != null) {
      return Image.memory(
        foto,
        fit: BoxFit.contain,
      );
    }

    return RecuerdoSinFotoBadge(
      size: 160,
      iconSize: 80,
      accentColor: palette.terracotta,
    );
  }
}
