import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_tokens.dart';

class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.showShadow = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final radius = BorderRadius.circular(tokens.cardRadius);

    final content = Padding(
      padding: padding ?? tokens.cardPadding,
      child: child,
    );

    final decoration = BoxDecoration(
      color: palette.surface,
      borderRadius: radius,
      border: Border.all(color: palette.border, width: 0.5),
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
        child: Ink(
          decoration: decoration,
          child: content,
        ),
      ),
    );
  }
}

class EmojiBadge extends StatelessWidget {
  const EmojiBadge({
    super.key,
    required this.emoji,
    this.size = 48,
    this.fontSize = 24,
  });

  final String emoji;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: AppRadius.smAll,
      ),
      child: Text(emoji, style: TextStyle(fontSize: fontSize)),
    );
  }
}
