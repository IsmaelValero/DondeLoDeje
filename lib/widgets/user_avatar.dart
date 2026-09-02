import 'package:flutter/material.dart';

import '../data/user_session.dart';
import '../theme/app_palette.dart';

/// Avatar circular con la inicial del usuario.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.name,
    this.size = 46,
    this.onTap,
  });

  final String? name;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = palette.petrol;
    final initial = UserSession.initialFor(name);
    final fontSize = size * 0.42;

    final avatar = Material(
      color: palette.softTint(accent),
      shape: const CircleBorder(),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: accent,
              height: 1,
            ),
          ),
        ),
      ),
    );

    if (onTap == null) return avatar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      ),
    );
  }
}
