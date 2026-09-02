import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

class RecuerdoFieldLabel extends StatelessWidget {
  const RecuerdoFieldLabel({
    super.key,
    required this.label,
    required this.palette,
    this.optional = false,
  });

  final String label;
  final AppPalette palette;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
        ),
        if (optional) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Opcional',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textTertiary,
                ),
          ),
        ],
      ],
    );
  }
}
