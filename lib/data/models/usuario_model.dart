import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.uid,
    required super.nombre,
    required super.email,
    required super.rol,
    required super.fechaRegistro,
    super.fotoPerfil,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json, String uid) {
    return UsuarioModel(
      uid: uid,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      rol: json['rol'] ?? 'turista',
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'])
          : DateTime.now(),
      fotoPerfil: json['fotoPerfil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'fotoPerfil': fotoPerfil,
    };
  }
}
