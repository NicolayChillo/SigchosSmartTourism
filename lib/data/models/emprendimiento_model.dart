import '../../domain/entities/emprendimiento.dart';

class EmprendimientoModel extends Emprendimiento {
  const EmprendimientoModel({
    required super.id,
    required super.nombre,
    required super.categoria,
    required super.descripcion,
    required super.fotos,
    required super.latitude,
    required super.longitude,
    required super.geohash,
    required super.promedioCalificacion,
    required super.totalCalificaciones,
  });

  factory EmprendimientoModel.fromJson(Map<String, dynamic> json, String id) {
    return EmprendimientoModel(
      id: id,
      nombre: json['nombre'] ?? '',
      categoria: json['categoria'] ?? 'artesania',
      descripcion: json['descripcion'] ?? '',
      fotos: List<String>.from(json['fotos'] ?? []),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      geohash: json['geohash'] ?? '',
      promedioCalificacion: (json['promedioCalificacion'] as num?)?.toDouble() ?? 0.0,
      totalCalificaciones: (json['totalCalificaciones'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'descripcion': descripcion,
      'fotos': fotos,
      'latitude': latitude,
      'longitude': longitude,
      'geohash': geohash,
      'promedioCalificacion': promedioCalificacion,
      'totalCalificaciones': totalCalificaciones,
    };
  }
}
