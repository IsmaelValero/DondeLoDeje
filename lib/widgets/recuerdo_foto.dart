import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/foto_store.dart';

/// Muestra la foto de un recuerdo, venga de memoria o de un archivo guardado.
class RecuerdoFoto extends StatefulWidget {
  const RecuerdoFoto({
    super.key,
    this.bytes,
    this.nombre,
    required this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final Uint8List? bytes;
  final String? nombre;
  final Widget placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  State<RecuerdoFoto> createState() => _RecuerdoFotoState();
}

class _RecuerdoFotoState extends State<RecuerdoFoto> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _resolver();
  }

  @override
  void didUpdateWidget(RecuerdoFoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bytes != widget.bytes || oldWidget.nombre != widget.nombre) {
      _resolver();
    }
  }

  void _resolver() {
    final directos = widget.bytes;
    if (directos != null) {
      setState(() => _bytes = directos);
      return;
    }

    final nombre = widget.nombre;
    if (nombre == null) {
      setState(() => _bytes = null);
      return;
    }

    final enCache = FotoStore.enCache(nombre);
    if (enCache != null) {
      setState(() => _bytes = enCache);
      return;
    }

    setState(() => _bytes = null);
    FotoStore.leer(nombre).then((cargados) {
      if (!mounted || widget.nombre != nombre) return;
      setState(() => _bytes = cargados);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes == null) return widget.placeholder;

    final imagen = Image.memory(
      bytes,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );

    final radius = widget.borderRadius;
    if (radius == null) return imagen;

    return ClipRRect(borderRadius: radius, child: imagen);
  }
}
