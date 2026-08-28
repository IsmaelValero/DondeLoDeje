import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/lugar_card.dart';
import '../widgets/section_header.dart';
import 'lugar_detail_screen.dart';

class LugaresScreen extends StatelessWidget {
  const LugaresScreen({super.key});

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
          const ScreenHeader(title: 'Lugares'),
          const SizedBox(height: AppSpacing.xl),
          ...SampleData.lugares.map(
            (lugar) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
              child: LugarCard(
                emoji: lugar.emoji,
                nombre: lugar.nombre,
                recuerdosCount: lugar.recuerdosCount,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LugarDetailScreen(lugarId: lugar.id),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
