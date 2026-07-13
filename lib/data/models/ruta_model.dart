import '../../domain/entities/ruta.dart';

class RutaModel extends Ruta {
  const RutaModel({
    required super.id,
    required super.nombre,
    required super.lugarId,
    required super.puntosGPS,
    required super.distanciaKm,
    required super.tiempoEstimadoMin,
    required super.dificultad,
  });

  factory RutaModel.fromJson(Map<String, dynamic> json, String id) {
    var rawPuntos = json['puntosGPS'] as List<dynamic>? ?? [];
    List<RutaPunto> puntos = rawPuntos.map((p) {
      // p should be a map containing 'latitude' and 'longitude'
      final map = p as Map<String, dynamic>;
      return RutaPunto(
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
      );
    }).toList();

    return RutaModel(
      id: id,
      nombre: json['nombre'] ?? '',
      lugarId: json['lugarId'] ?? '',
      puntosGPS: puntos,
      distanciaKm: (json['distanciaKm'] as num?)?.toDouble() ?? 0.0,
      tiempoEstimadoMin: (json['tiempoEstimadoMin'] as num?)?.toInt() ?? 0,
      dificultad: json['dificultad'] ?? 'Fácil',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'lugarId': lugarId,
      'puntosGPS': puntosGPS.map((p) => {
        'latitude': p.latitude,
        'longitude': p.longitude,
      }).toList(),
      'distanciaKm': distanciaKm,
      'tiempoEstimadoMin': tiempoEstimadoMin,
      'dificultad': dificultad,
    };
  }
}
