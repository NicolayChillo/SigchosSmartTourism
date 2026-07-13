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
  final String lugarId;
  final List<RutaPunto> puntosGPS;
  final double distanciaKm;
  final int tiempoEstimadoMin;
  final String dificultad; // 'Fácil' | 'Moderado' | 'Difícil'

  const Ruta({
    required this.id,
    required this.nombre,
    required this.lugarId,
    required this.puntosGPS,
    required this.distanciaKm,
    required this.tiempoEstimadoMin,
    required this.dificultad,
  });
}
