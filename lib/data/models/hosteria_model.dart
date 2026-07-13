import '../../domain/entities/hosteria.dart';

class HosteriaModel extends Hosteria {
  const HosteriaModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.fotos,
    required super.latitude,
    required super.longitude,
    required super.geohash,
    required super.promedioCalificacion,
    required super.totalCalificaciones,
    required super.contacto,
    required super.precioRango,
  });

  factory HosteriaModel.fromJson(Map<String, dynamic> json, String id) {
    return HosteriaModel(
      id: id,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fotos: List<String>.from(json['fotos'] ?? []),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      geohash: json['geohash'] ?? '',
      promedioCalificacion: (json['promedioCalificacion'] as num?)?.toDouble() ?? 0.0,
      totalCalificaciones: (json['totalCalificaciones'] as num?)?.toInt() ?? 0,
      contacto: json['contacto'] ?? '',
      precioRango: json['precioRango'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fotos': fotos,
      'latitude': latitude,
      'longitude': longitude,
      'geohash': geohash,
      'promedioCalificacion': promedioCalificacion,
      'totalCalificaciones': totalCalificaciones,
      'contacto': contacto,
      'precioRango': precioRango,
    };
  }
}
