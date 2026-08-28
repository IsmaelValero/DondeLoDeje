import 'models.dart';

class SampleData {
  SampleData._();

  static const categoriasFrecuentes = [
    CategoriaFrecuente(id: 'casa', emoji: '🏠', nombre: 'Casa'),
    CategoriaFrecuente(id: 'trastero', emoji: '📦', nombre: 'Trastero'),
    CategoriaFrecuente(id: 'coche', emoji: '🚗', nombre: 'Coche'),
    CategoriaFrecuente(id: 'viajes', emoji: '✈️', nombre: 'Viajes'),
  ];

  static const recuerdosRecientes = [
    Recuerdo(
      id: '1',
      emoji: '📷',
      titulo: 'Cámara',
      ubicacion: 'Trastero · Estante 3 · Caja azul',
      lugarId: 'trastero',
    ),
    Recuerdo(
      id: '2',
      emoji: '🔑',
      titulo: 'Llaves de repuesto',
      ubicacion: 'Casa · Cajón de la entrada',
      lugarId: 'casa',
    ),
    Recuerdo(
      id: '3',
      emoji: '🎒',
      titulo: 'Adaptador de Japón',
      ubicacion: 'Maleta grande · Bolsillo lateral',
      viajeId: 'japon-2026',
    ),
    Recuerdo(
      id: '4',
      emoji: '📄',
      titulo: 'Documentos del coche',
      ubicacion: 'Casa · Escritorio',
      lugarId: 'casa',
    ),
  ];

  static const lugares = [
    Lugar(id: 'casa', emoji: '🏠', nombre: 'Casa', recuerdosCount: 23),
    Lugar(id: 'trastero', emoji: '📦', nombre: 'Trastero', recuerdosCount: 41),
    Lugar(id: 'coche', emoji: '🚗', nombre: 'Coche', recuerdosCount: 8),
    Lugar(
      id: 'casa-padres',
      emoji: '🏡',
      nombre: 'Casa de mis padres',
      recuerdosCount: 12,
    ),
  ];

  static const viajes = [
    Viaje(id: 'japon-2026', emoji: '🇯🇵', nombre: 'Japón 2026', recuerdosCount: 12),
    Viaje(id: 'italia-2025', emoji: '🇮🇹', nombre: 'Italia 2025', recuerdosCount: 8),
    Viaje(id: 'portugal-2024', emoji: '🇵🇹', nombre: 'Portugal 2024', recuerdosCount: 5),
  ];

  static const recuerdosPorLugar = {
    'casa': [
      Recuerdo(id: 'c1', emoji: '🔑', titulo: 'Llaves de repuesto', ubicacion: 'Cajón de la entrada'),
      Recuerdo(id: 'c2', emoji: '📄', titulo: 'Documentos del coche', ubicacion: 'Escritorio'),
      Recuerdo(id: 'c3', emoji: '🔌', titulo: 'Cargador extra', ubicacion: 'Cajón del salón'),
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
    'casa-padres': [
      Recuerdo(id: 'p1', emoji: '🔑', titulo: 'Llaves de repuesto', ubicacion: 'Cajón de la cocina'),
      Recuerdo(id: 'p2', emoji: '📚', titulo: 'Libros de la uni', ubicacion: 'Habitación de invitados'),
    ],
  };

  static const recuerdosPorViaje = {
    'japon-2026': [
      Recuerdo(
        id: 'j1',
        emoji: '🎒',
        titulo: 'Adaptador de Japón',
        ubicacion: 'Maleta grande · Bolsillo lateral',
        faseViaje: FaseViaje.antes,
      ),
      Recuerdo(
        id: 'j2',
        emoji: '💴',
        titulo: 'Yenes en efectivo',
        ubicacion: 'Cartera de viaje',
        faseViaje: FaseViaje.antes,
      ),
      Recuerdo(
        id: 'j3',
        emoji: '🗺️',
        titulo: 'Guía de Kioto',
        ubicacion: 'Mochila de día',
        faseViaje: FaseViaje.durante,
      ),
      Recuerdo(
        id: 'j4',
        emoji: '🎁',
        titulo: 'Recuerdos de Osaka',
        ubicacion: 'Caja del trastero',
        faseViaje: FaseViaje.otros,
      ),
    ],
    'italia-2025': [
      Recuerdo(
        id: 'i1',
        emoji: '🎫',
        titulo: 'Entradas al Coliseo',
        ubicacion: 'Sobre de documentos',
        faseViaje: FaseViaje.antes,
      ),
      Recuerdo(
        id: 'i2',
        emoji: '🍷',
        titulo: 'Botella de vino',
        ubicacion: 'Cocina · Alacena',
        faseViaje: FaseViaje.otros,
      ),
    ],
    'portugal-2024': [
      Recuerdo(
        id: 'po1',
        emoji: '🏖️',
        titulo: 'Toalla de playa',
        ubicacion: 'Armario del baño',
        faseViaje: FaseViaje.otros,
      ),
    ],
  };

  static const masOptions = [
    MasOption(emoji: '⭐', titulo: 'Favoritos'),
    MasOption(emoji: '🗃️', titulo: 'Archivados'),
    MasOption(emoji: '🏷️', titulo: 'Categorías'),
    MasOption(emoji: '🔔', titulo: 'Recordatorios'),
    MasOption(emoji: '🎨', titulo: 'Apariencia'),
    MasOption(emoji: '💾', titulo: 'Exportar / importar'),
    MasOption(emoji: 'ℹ️', titulo: 'Sobre DondeLoDeje'),
  ];

  static Lugar? lugarById(String id) {
    for (final lugar in lugares) {
      if (lugar.id == id) return lugar;
    }
    return null;
  }

  static Viaje? viajeById(String id) {
    for (final viaje in viajes) {
      if (viaje.id == id) return viaje;
    }
    return null;
  }
}
