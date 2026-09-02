import 'package:flutter/material.dart';

import '../theme/app_content_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/catalog_colors.dart';
import '../theme/catalog_icons.dart';
import '../data/opcion_catalogo.dart';
import 'catalog_icon_badge.dart';

/// Diálogo para añadir categoría: nombre, icono y color.
Future<OpcionCatalogo?> showNuevaOpcionDialog({
  required BuildContext context,
  required String titulo,
  required String hintNombre,
  String iconKeyInicial = CatalogIcons.defaultCategoriaKey,
}) {
  return showDialog<OpcionCatalogo>(
    context: context,
    builder: (context) => _NuevaOpcionDialog(
      titulo: titulo,
      hintNombre: hintNombre,
      iconKeyInicial: iconKeyInicial,
    ),
  );
}

class _NuevaOpcionDialog extends StatefulWidget {
  const _NuevaOpcionDialog({
    required this.titulo,
    required this.hintNombre,
    required this.iconKeyInicial,
  });

  final String titulo;
  final String hintNombre;
  final String iconKeyInicial;

  @override
  State<_NuevaOpcionDialog> createState() => _NuevaOpcionDialogState();
}

class _NuevaOpcionDialogState extends State<_NuevaOpcionDialog> {
  final _nombreController = TextEditingController();
  late String _iconKey;
  String? _colorKey;

  @override
  void initState() {
    super.initState();
    _iconKey = widget.iconKeyInicial;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  OpcionCatalogo get _preview => OpcionCatalogo(
        id: 'preview',
        nombre: _nombreController.text.trim().isEmpty
            ? 'Vista previa'
            : _nombreController.text.trim(),
        iconKey: _iconKey,
        colorKey: _colorKey,
      );

  void _confirmar() {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) return;

    Navigator.of(context).pop(
      OpcionCatalogo(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        nombre: nombre,
        iconKey: _iconKey,
        colorKey: _colorKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AlertDialog(
      title: Text(widget.titulo),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('campo_nombre_catalogo'),
                controller: _nombreController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: widget.hintNombre,
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _confirmar(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Icono',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _IconPickerGrid(
                selectedKey: _iconKey,
                onSelected: (key) => setState(() => _iconKey = key),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Color',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ColorPickerRow(
                selectedKey: _colorKey,
                onSelected: (key) => setState(() => _colorKey = key),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  CatalogIconBadge(opcion: _preview, size: 40, iconSize: 22),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _preview.nombre,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _colorKey == null
                    ? 'Color automático según la paleta de la app'
                    : 'Color fijo seleccionado',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('btn_confirmar_catalogo'),
          onPressed: _confirmar,
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}

class _IconPickerGrid extends StatelessWidget {
  const _IconPickerGrid({
    required this.selectedKey,
    required this.onSelected,
  });

  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemCount: CatalogIcons.lugares.length,
      itemBuilder: (context, index) {
        final entry = CatalogIcons.lugares[index];
        final selected = entry.key == selectedKey;
        final preview = OpcionCatalogo(
          id: entry.key,
          nombre: entry.label,
          iconKey: entry.key,
        );

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(entry.key),
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? palette.petrol : palette.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Center(
                child: CatalogIconBadge(
                  opcion: preview,
                  size: 36,
                  iconSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ColorPickerRow extends StatelessWidget {
  const _ColorPickerRow({
    required this.selectedKey,
    required this.onSelected,
  });

  final String? selectedKey;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _ColorChip(
          label: 'Auto',
          color: AppContentColors.defaultForCategoria(palette),
          selected: selectedKey == null,
          onTap: () => onSelected(null),
        ),
        ...CatalogColorKeys.selectable.map(
          (key) => _ColorChip(
            label: CatalogColors.labelFor(key),
            color: AppContentColors.fromKey(key, palette),
            selected: selectedKey == key,
            onTap: () => onSelected(key),
          ),
        ),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: CircleAvatar(backgroundColor: color, radius: 8),
      label: Text(label),
      showCheckmark: false,
    );
  }
}
