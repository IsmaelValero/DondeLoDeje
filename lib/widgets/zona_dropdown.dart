import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/zona.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Valor vacío para omitir la zona en formularios.
const sinZonaId = '';

/// Desplegable opcional de zonas filtrado por categoría.
class ZonaDropdown extends StatelessWidget {
  const ZonaDropdown({
    super.key,
    required this.categoriaId,
    required this.valorSeleccionado,
    required this.onChanged,
  });

  final String categoriaId;
  final String valorSeleccionado;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final zonas = CatalogoSession.instance.zonasForCategoria(categoriaId);

    if (zonas.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String>(
      key: const Key('dropdown_zona'),
      value: valorSeleccionado.isEmpty ? sinZonaId : valorSeleccionado,
      decoration: const InputDecoration(
        labelText: 'Selecciona una zona',
      ),
      items: [
        DropdownMenuItem(
          value: sinZonaId,
          child: Text(
            'Sin zona',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
        ...zonas.map(
          (zona) => DropdownMenuItem(
            value: zona.id,
            child: Text(zona.nombre),
          ),
        ),
      ],
      onChanged: (value) => onChanged(value ?? sinZonaId),
    );
  }
}

Zona? zonaFromId(String? id) {
  if (id == null || id.isEmpty) return null;
  return CatalogoSession.instance.zonaById(id);
}
