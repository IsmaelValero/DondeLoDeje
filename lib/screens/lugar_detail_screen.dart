import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/recuerdo_card.dart';
import '../widgets/section_header.dart';

class LugarDetailScreen extends StatelessWidget {
  const LugarDetailScreen({super.key, required this.lugarId});

  final String lugarId;

  @override
  Widget build(BuildContext context) {
    final lugar = SampleData.lugarById(lugarId);
    final recuerdos = SampleData.recuerdosPorLugar[lugarId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugar'),
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
            if (lugar != null) ...[
              DetailHeader(
                emoji: lugar.emoji,
                title: lugar.nombre,
                subtitle: '${lugar.recuerdosCount} recuerdos',
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            const SectionTitle(title: 'Recuerdos en este lugar'),
            if (recuerdos.isEmpty)
              Text(
                'No hay recuerdos de ejemplo para este lugar.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.palette.textTertiary,
                    ),
              )
            else
              ...recuerdos.map(
                (recuerdo) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                  child: RecuerdoCard(recuerdo: recuerdo),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
