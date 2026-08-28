import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/sample_data.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/recuerdo_card.dart';
import '../widgets/section_header.dart';

class ViajeDetailScreen extends StatelessWidget {
  const ViajeDetailScreen({super.key, required this.viajeId});

  final String viajeId;

  @override
  Widget build(BuildContext context) {
    final viaje = SampleData.viajeById(viajeId);
    final recuerdos = SampleData.recuerdosPorViaje[viajeId] ?? [];

    final antes = recuerdos.where((r) => r.faseViaje == FaseViaje.antes).toList();
    final durante = recuerdos.where((r) => r.faseViaje == FaseViaje.durante).toList();
    final otros = recuerdos.where((r) => r.faseViaje == FaseViaje.otros).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viaje'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.sm,
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
          ),
          children: [
            if (viaje != null) ...[
              DetailHeader(
                emoji: viaje.emoji,
                title: viaje.nombre,
                subtitle: '${viaje.recuerdosCount} recuerdos',
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            if (recuerdos.isEmpty)
              Text(
                'No hay recuerdos de ejemplo para este viaje.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.palette.textTertiary,
                    ),
              )
            else ...[
              if (antes.isNotEmpty) _FaseSection(title: 'Antes del viaje', recuerdos: antes),
              if (durante.isNotEmpty) _FaseSection(title: 'Durante el viaje', recuerdos: durante),
              if (otros.isNotEmpty) _FaseSection(title: 'Otros recuerdos', recuerdos: otros),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaseSection extends StatelessWidget {
  const _FaseSection({required this.title, required this.recuerdos});

  final String title;
  final List<Recuerdo> recuerdos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaseSectionHeader(title: title),
        ...recuerdos.map(
          (recuerdo) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
            child: RecuerdoCard(recuerdo: recuerdo),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
