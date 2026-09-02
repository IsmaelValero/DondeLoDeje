import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/catalogo_session.dart';
import '../data/foto_store.dart';
import '../data/opcion_catalogo.dart';
import '../data/recuerdos_query.dart';
import '../data/models.dart';
import '../data/session_recuerdos.dart';
import '../data/zona.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/recuerdo_factory.dart';
import '../utils/recuerdo_resolver.dart';
import '../widgets/catalogo_dropdown.dart';
import '../widgets/foto_recuerdo_picker.dart';
import '../widgets/recuerdo_field_label.dart';
import '../widgets/recuerdo_preview_card.dart';
import '../widgets/zona_dropdown.dart';

/// Formulario para crear o editar un recuerdo.
class CrearRecuerdoScreen extends StatefulWidget {
  const CrearRecuerdoScreen({super.key, this.recuerdoId});

  /// Si se indica, el formulario abre en modo edición.
  final String? recuerdoId;

  bool get isEditing => recuerdoId != null;

  @override
  State<CrearRecuerdoScreen> createState() => _CrearRecuerdoScreenState();
}

class _CrearRecuerdoScreenState extends State<CrearRecuerdoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _catalogo = CatalogoSession.instance;

  late String _categoriaId;
  String _zonaId = sinZonaId;
  Uint8List? _fotoBytes;
  String? _fotoNombre;
  bool _fotoCambiada = false;
  Recuerdo? _recuerdoOriginal;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _recuerdoOriginal = RecuerdosQuery.findById(widget.recuerdoId!);
      if (_recuerdoOriginal != null) {
        final categoriaId = RecuerdoResolver.categoriaIdFor(_recuerdoOriginal!) ??
            _catalogo.categoriaDefault.id;
        final categoria = _catalogo.categoriaById(categoriaId) ??
            _catalogo.categoriaDefault;
        _categoriaId = categoria.id;
        _fotoBytes = _recuerdoOriginal!.fotoBytes;
        _fotoNombre = _recuerdoOriginal!.fotoNombre;
        _nombreController.text = _recuerdoOriginal!.titulo;
        _ubicacionController.text = RecuerdoResolver.ubicacionConcretaForEdit(
          _recuerdoOriginal!,
          categoria,
        );
        _zonaId = RecuerdoResolver.zonaIdFor(_recuerdoOriginal!) ?? sinZonaId;
      } else {
        _categoriaId = _catalogo.categoriaDefault.id;
      }
    } else {
      _categoriaId = _catalogo.categoriaDefault.id;
    }
    _nombreController.addListener(_onFieldsChanged);
    _ubicacionController.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _nombreController
      ..removeListener(_onFieldsChanged)
      ..dispose();
    _ubicacionController
      ..removeListener(_onFieldsChanged)
      ..dispose();
    super.dispose();
  }

  void _onFieldsChanged() => setState(() {});

  OpcionCatalogo get _categoriaSeleccionada =>
      _catalogo.categoriaById(_categoriaId) ?? _catalogo.categoriaDefault;

  Zona? get _zonaSeleccionada => zonaFromId(_zonaId);

  void _onCategoriaChanged(String categoriaId) {
    setState(() {
      _categoriaId = categoriaId;
      final zonasValidas = _catalogo.zonasForCategoria(categoriaId);
      if (!zonasValidas.any((z) => z.id == _zonaId)) {
        _zonaId = sinZonaId;
      }
    });
  }

  /// Escribe la foto nueva en el dispositivo y borra la anterior si se cambió.
  Future<String?> _persistirFoto() async {
    final anterior = _recuerdoOriginal?.fotoNombre;
    if (!_fotoCambiada) return anterior;

    if (anterior != null) {
      await FotoStore.borrar(anterior);
    }

    final bytes = _fotoBytes;
    if (bytes == null) return null;
    return FotoStore.guardar(bytes);
  }

  Future<void> _confirmarEliminar() async {
    final original = _recuerdoOriginal;
    if (original == null) return;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar recuerdo'),
        content: Text('¿Eliminar “${original.titulo}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('btn_confirmar_eliminar_recuerdo'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    final fotoNombre = original.fotoNombre;
    if (fotoNombre != null) {
      await FotoStore.borrar(fotoNombre);
    }
    SessionRecuerdos.remove(original.id);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final original = _recuerdoOriginal;
    if (widget.isEditing && original == null) return;

    final fotoNombre = await _persistirFoto();
    if (!mounted) return;

    if (widget.isEditing) {
      SessionRecuerdos.upsert(
        RecuerdoFactory.fromFormUpdate(
          original: original!,
          nombre: _nombreController.text,
          categoria: _categoriaSeleccionada,
          zona: _zonaSeleccionada,
          ubicacionConcreta: _ubicacionController.text,
          fotoNombre: fotoNombre,
        ),
      );
    } else {
      SessionRecuerdos.add(
        RecuerdoFactory.fromForm(
          nombre: _nombreController.text,
          categoria: _categoriaSeleccionada,
          zona: _zonaSeleccionada,
          ubicacionConcreta: _ubicacionController.text,
          fotoNombre: fotoNombre,
        ),
      );
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing && _recuerdoOriginal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar recuerdo')),
        body: const Center(child: Text('No se encontró este recuerdo.')),
      );
    }

    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return ListenableBuilder(
      listenable: _catalogo,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isEditing ? 'Editar recuerdo' : 'Nuevo recuerdo'),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl + bottomInset,
                ),
                children: [
                  RecuerdoPreviewCard(
                    nombre: _nombreController.text,
                    categoria: _categoriaSeleccionada,
                    zona: _zonaSeleccionada,
                    ubicacionConcreta: _ubicacionController.text,
                    fotoBytes: _fotoBytes,
                    fotoNombre: _fotoNombre,
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  RecuerdoFieldLabel(
                    label: '¿Qué quieres recordar?',
                    palette: palette,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    key: const Key('campo_nombre'),
                    controller: _nombreController,
                    autofocus: !widget.isEditing,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ej. Cámara, pasaporte, llaves...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xl,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe qué quieres recordar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  RecuerdoFieldLabel(
                    label: 'Categoría',
                    palette: palette,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CategoriaDropdown(
                    key: const Key('dropdown_categoria'),
                    valorSeleccionado: _categoriaId,
                    onChanged: (categoria) {
                      if (categoria != null) {
                        _onCategoriaChanged(categoria.id);
                      }
                    },
                  ),
                  if (_catalogo.zonasForCategoria(_categoriaId).isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    RecuerdoFieldLabel(
                      label: 'Zona',
                      optional: true,
                      palette: palette,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ZonaDropdown(
                      categoriaId: _categoriaId,
                      valorSeleccionado: _zonaId,
                      onChanged: (zonaId) => setState(() => _zonaId = zonaId),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  RecuerdoFieldLabel(
                    label: 'Ubicación concreta',
                    optional: true,
                    palette: palette,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    key: const Key('campo_ubicacion'),
                    controller: _ubicacionController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Ej. 3er estante de la cómoda, guantera...',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  RecuerdoFieldLabel(
                    label: 'Fotografía',
                    optional: true,
                    palette: palette,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FotoRecuerdoPicker(
                    fotoBytes: _fotoBytes,
                    fotoNombre: _fotoNombre,
                    onChanged: (bytes) => setState(() {
                      _fotoBytes = bytes;
                      _fotoCambiada = true;
                      if (bytes == null) _fotoNombre = null;
                    }),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  FilledButton(
                    key: Key(
                      widget.isEditing
                          ? 'btn_guardar_edicion'
                          : 'btn_guardar_recuerdo',
                    ),
                    onPressed: _guardar,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Text(
                        widget.isEditing ? 'Cambiar de Sitio' : 'Guardar recuerdo',
                      ),
                    ),
                  ),
                  if (widget.isEditing) ...[
                    const SizedBox(height: AppSpacing.md),
                    TextButton.icon(
                      key: const Key('btn_eliminar_recuerdo'),
                      onPressed: _confirmarEliminar,
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      label: const Text('Eliminar recuerdo'),
                      style: TextButton.styleFrom(
                        foregroundColor: palette.terracotta,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
