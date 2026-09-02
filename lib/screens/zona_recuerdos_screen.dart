import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/recuerdos_query.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/recuerdo_card.dart';
import '../widgets/section_header.dart';

/// Recuerdos de una zona (o sin zona).
class ZonaRecuerdosScreen extends StatefulWidget {
  const ZonaRecuerdosScreen({
    super.key,
    required this.categoriaId,
    this.zonaId,
  });

  static const screenKey = ValueKey<String>('zona_recuerdos_screen');

  final String categoriaId;
  final String? zonaId;

  @override
  State<ZonaRecuerdosScreen> createState() => _ZonaRecuerdosScreenState();
}

class _ZonaRecuerdosScreenState extends State<ZonaRecuerdosScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final catalogo = CatalogoSession.instance;
    final lugar = RecuerdosQuery.resolveCategoria(widget.categoriaId);
    final zona = catalogo.zonaById(widget.zonaId);
    final titulo = zona?.nombre ?? 'Sin zona';
    final recuerdos = widget.zonaId == null
        ? RecuerdosQuery.forCategoriaSinZona(widget.categoriaId)
        : RecuerdosQuery.forZona(widget.zonaId!);
    final palette = context.palette;

    return Scaffold(
      key: ZonaRecuerdosScreen.screenKey,
      appBar: AppBar(title: Text(titulo)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
          ),
          children: [
            if (lugar != null)
              Text(
                lugar.nombre,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            const SizedBox(height: AppSpacing.sectionGap),
            const SectionTitle(title: 'Recuerdos'),
            if (recuerdos.isEmpty)
              Text(
                'No hay recuerdos en esta zona.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.textTertiary,
                    ),
              )
            else
              ...recuerdos.map(
                (recuerdo) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                  child: RecuerdoCard(
                    recuerdo: recuerdo,
                    onUpdated: _refresh,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
