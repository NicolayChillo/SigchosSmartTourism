class Lugar {
  final String id;
  final String nombre;
  final String tipo; // 'cascada' | 'mirador' | 'sendero' | 'cultural' | 'historico'
  final String descripcion;
  final List<String> fotos;
  final double latitude;
  final double longitude;
  final String geohash;
  final double promedioCalificacion;
  final int totalCalificaciones;
  final String creadoPor;
  final DateTime fechaCreacion;

  const Lugar({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
    required this.fotos,
    required this.latitude,
    required this.longitude,
    required this.geohash,
    required this.promedioCalificacion,
    required this.totalCalificaciones,
    required this.creadoPor,
    required this.fechaCreacion,
  });
}

class Comentario {
  final String id;
  final String uid;
  final String nombreUsuario;
  final String? fotoUsuario;
  final String texto;
  final DateTime fecha;
  final List<String>? fotos;

  const Comentario({
    required this.id,
    required this.uid,
    required this.nombreUsuario,
    this.fotoUsuario,
    required this.texto,
    required this.fecha,
    this.fotos,
  });
}

class Calificacion {
  final String uid;
  final int valor;
  final DateTime fecha;

  const Calificacion({
    required this.uid,
    required this.valor,
    required this.fecha,
  });
}
