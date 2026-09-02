import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'user_avatar.dart';

/// Cabecera del inicio con título, subtítulo y acceso a Ajustes vía perfil.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.subtitle,
    this.userName,
    this.onAjustesTap,
  });

  final String subtitle;
  final String? userName;
  final VoidCallback? onAjustesTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Donde',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      letterSpacing: -0.8,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(
                    'Lo',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      letterSpacing: -0.8,
                      color: palette.terracotta,
                    ),
                  ),
                  Text(
                    'Deje',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      letterSpacing: -0.8,
                      color: palette.petrol,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        if (onAjustesTap != null)
          UserAvatar(
            key: const Key('home_user_avatar'),
            name: userName,
            onTap: onAjustesTap,
          ),
      ],
    );
  }
}
