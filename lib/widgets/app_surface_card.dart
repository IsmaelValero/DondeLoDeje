import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_tokens.dart';

class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.showShadow = true,
    this.accentColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool showShadow;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final radius = BorderRadius.circular(tokens.cardRadius);
    final accent = accentColor ?? palette.petrol;

    final content = Padding(
      padding: padding ?? tokens.cardPadding,
      child: child,
    );

    final decoration = BoxDecoration(
      color: palette.card,
      borderRadius: radius,
      border: Border.all(
        color: accent.withValues(alpha: palette.cardBorderAlpha),
        width: 1,
      ),
      boxShadow: showShadow ? palette.cardShadows : null,
    );

    if (onTap == null) {
      return DecoratedBox(
        decoration: decoration,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: accent.withValues(alpha: 0.08),
        highlightColor: accent.withValues(alpha: 0.04),
        child: Ink(
          decoration: decoration,
          child: content,
        ),
      ),
    );
  }
}

class RecuerdoSinFotoBadge extends StatelessWidget {
  const RecuerdoSinFotoBadge({
    super.key,
    this.size = 52,
    this.iconSize = 26,
    this.accentColor,
  });

  final double size;
  final double iconSize;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = accentColor ?? palette.terracotta;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.softTint(accent),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Icon(
        Icons.category_outlined,
        size: iconSize,
        color: accent,
      ),
    );
  }
}
