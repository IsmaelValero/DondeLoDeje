import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/recuerdos_query.dart';
import '../data/session_recuerdos.dart';
import '../navigation/app_routes.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_surface_card.dart';
import '../widgets/catalog_icon_badge.dart';
import '../widgets/nueva_zona_dialog.dart';
import '../widgets/section_header.dart';

/// Zonas de un lugar. En ajustes solo se gestionan; al explorar, se navega a recuerdos.
class LugarZonasScreen extends StatefulWidget {
  const LugarZonasScreen({
    super.key,
    required this.categoriaId,
    this.manage = false,
  });

  static Key screenKeyFor(String categoriaId) =>
      ValueKey<String>('lugar_zonas_$categoriaId');

  final String categoriaId;
  final bool manage;

  @override
  State<LugarZonasScreen> createState() => _LugarZonasScreenState();
}

class _LugarZonasScreenState extends State<LugarZonasScreen> {
  final _catalogo = CatalogoSession.instance;

  Future<void> _agregarZona(String categoriaNombre) async {
    final nombre = await showNuevaZonaDialog(
      context: context,
      categoriaNombre: categoriaNombre,
    );
    if (nombre != null) {
      _catalogo.addZona(
        categoriaId: widget.categoriaId,
        nombre: nombre,
      );
    }
  }

  Future<void> _confirmarEliminarZona({
    required String nombre,
    required VoidCallback onConfirm,
  }) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar zona'),
        content: Text('¿Eliminar la zona “$nombre”?'),
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

  String _recuerdosLabel(int count) {
    return count == 1 ? '1 recuerdo' : '$count recuerdos';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_catalogo, SessionRecuerdos.cambios]),
      builder: (context, _) {
        final lugar = RecuerdosQuery.resolveCategoria(widget.categoriaId);
        final zonas = _catalogo.zonasForCategoria(widget.categoriaId);
        final sinZonaCount =
            RecuerdosQuery.countForCategoriaSinZona(widget.categoriaId);
        final palette = context.palette;

        return Scaffold(
          key: LugarZonasScreen.screenKeyFor(widget.categoriaId),
          appBar: AppBar(
            title: Text(lugar?.nombre ?? 'Lugar'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.sm,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              children: [
                if (lugar != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CatalogIconBadge(opcion: lugar, size: 56, iconSize: 28),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lugar.nombre,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              widget.manage
                                  ? 'Gestiona las zonas de este lugar'
                                  : 'Elige una zona para ver tus recuerdos',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: palette.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                ],
                if (widget.manage) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Zonas',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      FilledButton.tonalIcon(
                        key: const Key('btn_anadir_zona'),
                        onPressed: lugar == null
                            ? null
                            : () => _agregarZona(lugar.nombre),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Añadir'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ] else
                  const SectionTitle(title: 'Zonas'),
                if (zonas.isEmpty)
                  Text(
                    'Todavía no hay zonas en este lugar.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.textTertiary,
                        ),
                  )
                else
                  ...zonas.map(
                    (zona) {
                      final count = RecuerdosQuery.countForZona(zona.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                        child: AppSurfaceCard(
                          onTap: widget.manage
                              ? null
                              : () => AppNavigation.openZonaRecuerdos(
                                    context,
                                    categoriaId: widget.categoriaId,
                                    zonaId: zona.id,
                                  ),
                          showShadow: false,
                          child: Row(
                            children: [
                              Expanded(
                                child: widget.manage
                                    ? Text(
                                        zona.nombre,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            zona.nombre,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(
                                            _recuerdosLabel(count),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: palette.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                              ),
                              if (widget.manage)
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: palette.textTertiary,
                                  ),
                                  tooltip: 'Eliminar zona',
                                  onPressed: () => _confirmarEliminarZona(
                                    nombre: zona.nombre,
                                    onConfirm: () => _catalogo.removeZona(zona.id),
                                  ),
                                )
                              else
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: palette.textTertiary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (!widget.manage && sinZonaCount > 0) ...[
                  const SizedBox(height: AppSpacing.sectionGap),
                  AppSurfaceCard(
                    onTap: () => AppNavigation.openZonaRecuerdos(
                      context,
                      categoriaId: widget.categoriaId,
                    ),
                    showShadow: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sin zona',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _recuerdosLabel(sinZonaCount),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: palette.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: palette.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
