class Lugar {
  final String id;
  final String nombre;
  final String tipo; // 'cascada' | 'laguna' | 'mirador' | 'sendero' | 'cultural' | 'historico'
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lugar &&
        other.id == id &&
        other.nombre == nombre &&
        other.tipo == tipo &&
        other.descripcion == descripcion &&
        _fotosEqual(other.fotos) &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.geohash == geohash &&
        other.promedioCalificacion == promedioCalificacion &&
        other.totalCalificaciones == totalCalificaciones &&
        other.creadoPor == creadoPor &&
        other.fechaCreacion == fechaCreacion;
  }

  bool _fotosEqual(List<String> other) {
    if (other.length != fotos.length) return false;
    for (var i = 0; i < fotos.length; i++) {
      if (fotos[i] != other[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        tipo,
        descripcion,
        Object.hashAll(fotos),
        latitude,
        longitude,
        geohash,
        promedioCalificacion,
        totalCalificaciones,
        creadoPor,
        fechaCreacion,
      );
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
