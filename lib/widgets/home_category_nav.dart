import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Navegación inferior central entre páginas de categorías del inicio.
class HomeCategoryNav extends StatelessWidget {
  const HomeCategoryNav({
    super.key,
    required this.canGoLeft,
    required this.canGoRight,
    required this.onPrevious,
    required this.onNext,
    this.pageIndex,
    this.pageCount,
  });

  final bool canGoLeft;
  final bool canGoRight;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final int? pageIndex;
  final int? pageCount;

  @override
  Widget build(BuildContext context) {
    if (!canGoLeft && !canGoRight) {
      return const SizedBox.shrink();
    }

    final palette = context.palette;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.md,
        ),
        child: Center(
          child: Material(
            elevation: 0,
            color: palette.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(color: palette.border),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: palette.subtleShadows,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ArrowButton(
                      key: const Key('btn_categorias_anterior'),
                      icon: Icons.chevron_left_rounded,
                      enabled: canGoLeft,
                      onPressed: onPrevious,
                    ),
                    if (pageIndex != null && pageCount != null && pageCount! > 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        child: Text(
                          '${pageIndex! + 1}/$pageCount',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: palette.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    _ArrowButton(
                      key: const Key('btn_categorias_siguiente'),
                      icon: Icons.chevron_right_rounded,
                      enabled: canGoRight,
                      onPressed: onNext,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 28),
      color: enabled ? palette.petrol : palette.textTertiary.withValues(alpha: 0.35),
      splashRadius: 22,
      tooltip: icon == Icons.chevron_left_rounded ? 'Anterior' : 'Siguiente',
    );
  }
}
