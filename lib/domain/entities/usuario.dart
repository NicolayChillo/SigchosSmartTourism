class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String rol; // 'turista' | 'administrador'
  final DateTime fechaRegistro;
  final String? fotoPerfil;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.fechaRegistro,
    this.fotoPerfil,
  });
}
