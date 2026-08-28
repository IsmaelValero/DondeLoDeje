import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/mas_menu_item.dart';
import '../widgets/section_header.dart';

class MasScreen extends StatelessWidget {
  const MasScreen({super.key});

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
          const ScreenHeader(title: 'Más'),
          const SizedBox(height: AppSpacing.xl),
          ...SampleData.masOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
              child: MasMenuItem(
                emoji: option.emoji,
                titulo: option.titulo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
