import 'package:flutter/material.dart';

import '../data/user_session.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';
import 'user_avatar.dart';

/// Bloque de perfil dentro de Ajustes (avatar, nombre editable).
class AjustesPerfilSection extends StatefulWidget {
  const AjustesPerfilSection({super.key});

  @override
  State<AjustesPerfilSection> createState() => _AjustesPerfilSectionState();
}

class _AjustesPerfilSectionState extends State<AjustesPerfilSection> {
  late final TextEditingController _controller;
  late String _savedName;

  @override
  void initState() {
    super.initState();
    _savedName = UserSession.instance.displayName ?? '';
    _controller = TextEditingController(text: _savedName);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final current = _controller.text.trim();
    return current.isNotEmpty && current != _savedName.trim();
  }

  void _guardar() {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;

    UserSession.instance.setDisplayName(nombre);
    setState(() => _savedName = nombre);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nombre actualizado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final nombre = _controller.text;

    return AppSurfaceCard(
      showShadow: false,
      child: Column(
        children: [
          UserAvatar(
            name: nombre,
            size: 72,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            nombre.trim().isEmpty ? 'Tu perfil' : nombre.trim(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tu espacio personal en DondeLoDeje',
            style: textTheme.bodyMedium?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nombre',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            key: const Key('campo_nombre_perfil'),
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (_hasChanges) _guardar();
            },
            decoration: const InputDecoration(
              hintText: 'Cómo quieres que te llamemos',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              key: const Key('btn_guardar_perfil'),
              onPressed: _hasChanges ? _guardar : null,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
