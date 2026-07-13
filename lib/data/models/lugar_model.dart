import '../../domain/entities/lugar.dart';

class LugarModel extends Lugar {
  const LugarModel({
    required super.id,
    required super.nombre,
    required super.tipo,
    required super.descripcion,
    required super.fotos,
    required super.latitude,
    required super.longitude,
    required super.geohash,
    required super.promedioCalificacion,
    required super.totalCalificaciones,
    required super.creadoPor,
    required super.fechaCreacion,
  });

  factory LugarModel.fromJson(Map<String, dynamic> json, String id) {
    return LugarModel(
      id: id,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? 'cascada',
      descripcion: json['descripcion'] ?? '',
      fotos: List<String>.from(json['fotos'] ?? []),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      geohash: json['geohash'] ?? '',
      promedioCalificacion: (json['promedioCalificacion'] as num?)?.toDouble() ?? 0.0,
      totalCalificaciones: (json['totalCalificaciones'] as num?)?.toInt() ?? 0,
      creadoPor: json['creadoPor'] ?? '',
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.parse(json['fechaCreacion'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
      'fotos': fotos,
      'latitude': latitude,
      'longitude': longitude,
      'geohash': geohash,
      'promedioCalificacion': promedioCalificacion,
      'totalCalificaciones': totalCalificaciones,
      'creadoPor': creadoPor,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }
}

class ComentarioModel extends Comentario {
  const ComentarioModel({
    required super.id,
    required super.uid,
    required super.nombreUsuario,
    super.fotoUsuario,
    required super.texto,
    required super.fecha,
    super.fotos,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json, String id) {
    return ComentarioModel(
      id: id,
      uid: json['uid'] ?? '',
      nombreUsuario: json['nombreUsuario'] ?? '',
      fotoUsuario: json['fotoUsuario'],
      texto: json['texto'] ?? '',
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      fotos: json['fotos'] != null ? List<String>.from(json['fotos']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nombreUsuario': nombreUsuario,
      'fotoUsuario': fotoUsuario,
      'texto': texto,
      'fecha': fecha.toIso8601String(),
      'fotos': fotos,
    };
  }
}

class CalificacionModel extends Calificacion {
  const CalificacionModel({
    required super.uid,
    required super.valor,
    required super.fecha,
  });

  factory CalificacionModel.fromJson(Map<String, dynamic> json, String uid) {
    return CalificacionModel(
      uid: uid,
      valor: (json['valor'] as num?)?.toInt() ?? 5,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valor': valor,
      'fecha': fecha.toIso8601String(),
    };
  }
}
