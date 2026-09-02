import 'models.dart';

/// Datos de ejemplo para recuerdos por categoría.
class SampleData {
  SampleData._();

  static const recuerdosPorLugar = {
    'casa': [
      Recuerdo(
        id: 'c1',
        emoji: '🔑',
        titulo: 'Llaves de repuesto',
        ubicacion: 'Cajón de la entrada',
        categoriaId: 'cat-casa',
        zonaId: 'zona-casa-entrada',
      ),
      Recuerdo(
        id: 'c2',
        emoji: '📄',
        titulo: 'Documentos del coche',
        ubicacion: 'Escritorio',
        categoriaId: 'cat-casa',
        zonaId: 'zona-casa-dormitorio',
      ),
      Recuerdo(
        id: 'c3',
        emoji: '🔌',
        titulo: 'Cargador extra',
        ubicacion: 'Cajón del salón',
        categoriaId: 'cat-casa',
      ),
    ],
    'trastero': [
      Recuerdo(id: 't1', emoji: '📷', titulo: 'Cámara', ubicacion: 'Estante 3 · Caja azul'),
      Recuerdo(id: 't2', emoji: '🎿', titulo: 'Esquís', ubicacion: 'Pared derecha'),
      Recuerdo(id: 't3', emoji: '🧳', titulo: 'Maleta pequeña', ubicacion: 'Estante 1'),
    ],
    'coche': [
      Recuerdo(id: 'co1', emoji: '🦺', titulo: 'Chaleco reflectante', ubicacion: 'Guantera'),
      Recuerdo(id: 'co2', emoji: '🔧', titulo: 'Kit de herramientas', ubicacion: 'Maletero'),
    ],
  };

  static const masOptions = [
    MasOption(emoji: '📍', titulo: 'Lugares'),
    MasOption(emoji: '🎨', titulo: 'Apariencia'),
    MasOption(emoji: 'ℹ️', titulo: 'Sobre DondeLoDeje'),
  ];

  static Recuerdo? findRecuerdoById(String id) {
    for (final recuerdos in recuerdosPorLugar.values) {
      for (final recuerdo in recuerdos) {
        if (recuerdo.id == id) return recuerdo;
      }
    }
    return null;
  }
}
