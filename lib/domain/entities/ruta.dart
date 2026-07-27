class RutaPunto {
  final double latitude;
  final double longitude;

  const RutaPunto({
    required this.latitude,
    required this.longitude,
  });
}

class Ruta {
  final String id;
  final String nombre;
  final String descripcion;
  final String lugarId;
  final List<RutaPunto> puntosGPS;
  final List<String> fotos;
  final double distanciaKm;
  final int tiempoEstimadoMin;
  final String dificultad; // 'Fácil' | 'Moderado' | 'Difícil'

  const Ruta({
    required this.id,
    required this.nombre,
    this.descripcion = '',
    required this.lugarId,
    required this.puntosGPS,
    this.fotos = const [],
    required this.distanciaKm,
    required this.tiempoEstimadoMin,
    required this.dificultad,
  });
}
