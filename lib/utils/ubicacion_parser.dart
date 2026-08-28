/// Parsea cadenas de ubicación del tipo "Lugar · Detalle · Subdetalle".
class UbicacionParts {
  const UbicacionParts({this.lugar, required this.detalle});

  final String? lugar;
  final String detalle;

  factory UbicacionParts.fromString(String ubicacion) {
    final parts = ubicacion.split(' · ').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return UbicacionParts(
        lugar: parts.first,
        detalle: parts.sublist(1).join(' · '),
      );
    }
    return UbicacionParts(detalle: ubicacion);
  }
}
