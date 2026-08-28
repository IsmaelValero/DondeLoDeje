enum FaseViaje { antes, durante, otros }

class Recuerdo {
  const Recuerdo({
    required this.id,
    required this.emoji,
    required this.titulo,
    required this.ubicacion,
    this.lugarId,
    this.viajeId,
    this.faseViaje,
  });

  final String id;
  final String emoji;
  final String titulo;
  final String ubicacion;
  final String? lugarId;
  final String? viajeId;
  final FaseViaje? faseViaje;
}

class Lugar {
  const Lugar({
    required this.id,
    required this.emoji,
    required this.nombre,
    required this.recuerdosCount,
  });

  final String id;
  final String emoji;
  final String nombre;
  final int recuerdosCount;
}

class Viaje {
  const Viaje({
    required this.id,
    required this.emoji,
    required this.nombre,
    required this.recuerdosCount,
  });

  final String id;
  final String emoji;
  final String nombre;
  final int recuerdosCount;
}

class CategoriaFrecuente {
  const CategoriaFrecuente({
    required this.id,
    required this.emoji,
    required this.nombre,
  });

  final String id;
  final String emoji;
  final String nombre;
}

class MasOption {
  const MasOption({required this.emoji, required this.titulo});

  final String emoji;
  final String titulo;
}
