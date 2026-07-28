import '../../domain/entities/favorito.dart';

class FavoritoModel extends Favorito {
  const FavoritoModel({
    required super.id,
    required super.itemId,
    required super.tipo,
    required super.nombre,
    super.foto,
    required super.fecha,
  });

  factory FavoritoModel.fromJson(Map<String, dynamic> json, String id) {
    return FavoritoModel(
      id: id,
      itemId: json['itemId'] ?? '',
      tipo: json['tipo'] ?? '',
      nombre: json['nombre'] ?? '',
      foto: json['foto'],
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'tipo': tipo,
      'nombre': nombre,
      'foto': foto,
      'fecha': fecha.toIso8601String(),
    };
  }
}
