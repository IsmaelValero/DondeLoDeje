import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/opcion_catalogo.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'catalog_icon_badge.dart';
import 'nueva_opcion_dialog.dart';

/// Desplegable de categorías con opción para añadir más.
class CatalogoDropdown extends StatelessWidget {
  const CatalogoDropdown({
    super.key,
    required this.label,
    required this.opciones,
    required this.valorSeleccionado,
    required this.onChanged,
    required this.tituloNuevo,
    required this.hintNuevo,
    required this.onAgregar,
    this.validator,
  });

  final String label;
  final List<OpcionCatalogo> opciones;
  final String? valorSeleccionado;
  final ValueChanged<OpcionCatalogo?> onChanged;
  final String tituloNuevo;
  final String hintNuevo;
  final OpcionCatalogo Function(OpcionCatalogo) onAgregar;
  final String? Function(String?)? validator;

  Future<void> _onSelect(BuildContext context, String? value) async {
    if (value == agregarOpcionCatalogoId) {
      final borrador = await showNuevaOpcionDialog(
        context: context,
        titulo: tituloNuevo,
        hintNombre: hintNuevo,
      );
      if (borrador != null) {
        onChanged(onAgregar(borrador));
      }
      return;
    }

    OpcionCatalogo? seleccion;
    for (final opcion in opciones) {
      if (opcion.id == value) {
        seleccion = opcion;
        break;
      }
    }
    onChanged(seleccion);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return DropdownButtonFormField<String>(
      value: valorSeleccionado,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: [
        ...opciones.map(
          (opcion) => DropdownMenuItem(
            value: opcion.id,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CatalogIconBadge(opcion: opcion, size: 28, iconSize: 16),
                const SizedBox(width: AppSpacing.sm),
                Text(opcion.nombre),
              ],
            ),
          ),
        ),
        DropdownMenuItem(
          value: agregarOpcionCatalogoId,
          child: Row(
            children: [
              Icon(Icons.add_rounded, size: 20, color: palette.petrol),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Añadir…',
                style: TextStyle(color: palette.petrol),
              ),
            ],
          ),
        ),
      ],
      onChanged: (value) => _onSelect(context, value),
      validator: validator,
    );
  }
}

class CategoriaDropdown extends StatelessWidget {
  const CategoriaDropdown({
    super.key,
    required this.valorSeleccionado,
    required this.onChanged,
    this.validator,
  });

  final String? valorSeleccionado;
  final ValueChanged<OpcionCatalogo?> onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final catalogo = CatalogoSession.instance;

    return CatalogoDropdown(
      label: 'Selecciona una categoría',
      opciones: catalogo.categorias,
      valorSeleccionado: valorSeleccionado,
      onChanged: onChanged,
      tituloNuevo: 'Nueva categoría',
      hintNuevo: 'Ej. Despensa, habitación…',
      onAgregar: (borrador) => catalogo.addCategoria(
        nombre: borrador.nombre,
        iconKey: borrador.iconKey,
        colorKey: borrador.colorKey,
      ),
      validator: validator,
    );
  }
}
