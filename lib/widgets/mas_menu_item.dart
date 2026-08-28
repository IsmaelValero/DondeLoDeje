import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

class MasMenuItem extends StatelessWidget {
  const MasMenuItem({
    super.key,
    required this.emoji,
    required this.titulo,
    this.onTap,
  });

  final String emoji;
  final String titulo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppSurfaceCard(
      onTap: onTap,
      showShadow: false,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: AppSpacing.md + 2),
          Expanded(
            child: Text(
              titulo,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: palette.textTertiary,
            size: 22,
          ),
        ],
      ),
    );
  }
}
