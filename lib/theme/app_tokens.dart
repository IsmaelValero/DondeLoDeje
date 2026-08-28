import 'package:flutter/material.dart';

import 'app_radius.dart';
import 'app_spacing.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.cardRadius,
    required this.chipRadius,
    required this.fabRadius,
    required this.cardPadding,
    required this.screenPadding,
  });

  final double cardRadius;
  final double chipRadius;
  final double fabRadius;
  final EdgeInsets cardPadding;
  final EdgeInsets screenPadding;

  static const defaults = AppTokens(
    cardRadius: AppRadius.md,
    chipRadius: AppRadius.md,
    fabRadius: AppRadius.lg,
    cardPadding: EdgeInsets.all(AppSpacing.cardPadding),
    screenPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.screenHorizontal,
      vertical: AppSpacing.screenVertical,
    ),
  );

  @override
  AppTokens copyWith({
    double? cardRadius,
    double? chipRadius,
    double? fabRadius,
    EdgeInsets? cardPadding,
    EdgeInsets? screenPadding,
  }) {
    return AppTokens(
      cardRadius: cardRadius ?? this.cardRadius,
      chipRadius: chipRadius ?? this.chipRadius,
      fabRadius: fabRadius ?? this.fabRadius,
      cardPadding: cardPadding ?? this.cardPadding,
      screenPadding: screenPadding ?? this.screenPadding,
    );
  }

  @override
  AppTokens lerp(covariant ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      cardRadius: other.cardRadius,
      chipRadius: other.chipRadius,
      fabRadius: other.fabRadius,
      cardPadding: other.cardPadding,
      screenPadding: other.screenPadding,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>() ?? AppTokens.defaults;
}
