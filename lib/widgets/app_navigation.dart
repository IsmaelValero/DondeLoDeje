import 'package:flutter/material.dart';

import '../theme/app_content_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_tokens.dart';

class AppFab extends StatelessWidget {
  const AppFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = context.tokens.fabRadius;
    final palette = context.palette;
    final color = AppContentColors.forRecuerdo(palette);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: palette.fabShadow(color),
      ),
      child: FloatingActionButton.large(
        onPressed: onPressed,
        tooltip: 'Guardar un nuevo recuerdo',
        backgroundColor: color,
        foregroundColor: palette.onAccent,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }
}
