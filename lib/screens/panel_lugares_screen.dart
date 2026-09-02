import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/opcion_catalogo.dart';
import '../navigation/app_routes.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_surface_card.dart';
import '../widgets/catalog_icon_badge.dart';
import '../widgets/nueva_opcion_dialog.dart';

/// Panel de Ajustes para gestionar lugares.
class PanelLugaresScreen extends StatefulWidget {
  const PanelLugaresScreen({super.key});

  static const screenKey = ValueKey<String>('panel_lugares_screen');

  @override
  State<PanelLugaresScreen> createState() => _PanelLugaresScreenState();
}

class _PanelLugaresScreenState extends State<PanelLugaresScreen> {
  final _catalogo = CatalogoSession.instance;

  Future<void> _agregarLugar() async {
    final borrador = await showNuevaOpcionDialog(
      context: context,
      titulo: 'Nuevo lugar',
      hintNombre: 'Ej. Despensa, garaje…',
    );
    if (borrador != null) {
      _catalogo.addCategoria(
        nombre: borrador.nombre,
        iconKey: borrador.iconKey,
        colorKey: borrador.colorKey,
      );
    }
  }

  Future<void> _confirmarEliminar({
    required String nombre,
    required VoidCallback onConfirm,
  }) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar lugar'),
        content: Text('¿Eliminar “$nombre”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado == true) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _catalogo,
      builder: (context, _) {
        return Scaffold(
          key: PanelLugaresScreen.screenKey,
          appBar: AppBar(
            title: const Text('Lugares'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              children: [
                _SeccionLugares(
                  titulo: 'Tus lugares',
                  descripcion: 'Organiza dónde guardas las cosas y sus zonas',
                  opciones: _catalogo.categorias,
                  onAgregar: _agregarLugar,
                  onTap: (opcion) => AppNavigation.openLugarZonas(
                    context,
                    opcion.id,
                    manage: true,
                  ),
                  onEliminar: (opcion) => _confirmarEliminar(
                    nombre: opcion.nombre,
                    onConfirm: () => _catalogo.removeCategoria(opcion.id),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SeccionLugares extends StatelessWidget {
  const _SeccionLugares({
    required this.titulo,
    required this.descripcion,
    required this.opciones,
    required this.onAgregar,
    required this.onTap,
    required this.onEliminar,
  });

  final String titulo;
  final String descripcion;
  final List<OpcionCatalogo> opciones;
  final VoidCallback onAgregar;
  final ValueChanged<OpcionCatalogo> onTap;
  final ValueChanged<OpcionCatalogo> onEliminar;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    descripcion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: onAgregar,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...opciones.map(
          (opcion) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
            child: AppSurfaceCard(
              onTap: () => onTap(opcion),
              showShadow: false,
              accentColor: palette.petrol,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  CatalogIconBadge(opcion: opcion, size: 40, iconSize: 20),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      opcion.nombre,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Eliminar',
                    onPressed: () => onEliminar(opcion),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: palette.textTertiary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: palette.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
