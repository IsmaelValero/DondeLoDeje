import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Diálogo sencillo para añadir una zona (solo nombre).
Future<String?> showNuevaZonaDialog({
  required BuildContext context,
  required String categoriaNombre,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _NuevaZonaDialog(categoriaNombre: categoriaNombre),
  );
}

class _NuevaZonaDialog extends StatefulWidget {
  const _NuevaZonaDialog({required this.categoriaNombre});

  final String categoriaNombre;

  @override
  State<_NuevaZonaDialog> createState() => _NuevaZonaDialogState();
}

class _NuevaZonaDialogState extends State<_NuevaZonaDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmar() {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;
    Navigator.of(context).pop(nombre);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva zona'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Dentro de ${widget.categoriaNombre}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            key: const Key('campo_nombre_zona'),
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Ej. Cuarto papás, garaje…',
            ),
            onSubmitted: (_) => _confirmar(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('btn_confirmar_zona'),
          onPressed: _confirmar,
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}
