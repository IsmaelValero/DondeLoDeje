import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_spacing.dart';
import '../widgets/lugar_card.dart';
import '../widgets/section_header.dart';
import 'viaje_detail_screen.dart';

class ViajesScreen extends StatelessWidget {
  const ViajesScreen({super.key});

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
          const ScreenHeader(title: 'Viajes'),
          const SizedBox(height: AppSpacing.xl),
          ...SampleData.viajes.map(
            (viaje) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
              child: ViajeCard(
                emoji: viaje.emoji,
                nombre: viaje.nombre,
                recuerdosCount: viaje.recuerdosCount,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ViajeDetailScreen(viajeId: viaje.id),
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
