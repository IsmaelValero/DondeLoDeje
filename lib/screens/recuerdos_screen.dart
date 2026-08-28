import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_search_field.dart';
import '../widgets/categoria_chip.dart';
import '../widgets/recuerdo_card.dart';
import '../widgets/section_header.dart';

class RecuerdosScreen extends StatelessWidget {
  const RecuerdosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.lg,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          const ScreenHeader(title: 'DondeLoDeje'),
          const SizedBox(height: AppSpacing.xl),
          const AppSearchField(),
          const SizedBox(height: AppSpacing.sectionGap),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SampleData.categoriasFrecuentes.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final categoria = SampleData.categoriasFrecuentes[index];
                return CategoriaChip(
                  emoji: categoria.emoji,
                  nombre: categoria.nombre,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionTitle(title: 'Recientes'),
          ...SampleData.recuerdosRecientes.map(
            (recuerdo) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
              child: RecuerdoCard(recuerdo: recuerdo),
            ),
          ),
        ],
      ),
    );
  }
}
