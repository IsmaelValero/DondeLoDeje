import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: '¿Qué estás buscando?',
        prefixIcon: Icon(
          Icons.search_rounded,
          color: palette.textTertiary,
          size: 22,
        ),
      ),
    );
  }
}
