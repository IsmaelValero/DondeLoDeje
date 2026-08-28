import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class CategoriaChip extends StatelessWidget {
  const CategoriaChip({
    super.key,
    required this.emoji,
    required this.nombre,
    this.onTap,
  });

  final String emoji;
  final String nombre;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final palette = context.palette;

    return SizedBox(
      width: 84,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Ink(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: palette.border, width: 0.5),
              boxShadow: palette.subtleShadows,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md + 2,
                horizontal: AppSpacing.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    nombre,
                    style: textTheme.labelLarge?.copyWith(
                      color: palette.textPrimary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
