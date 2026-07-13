class Emprendimiento {
  final String id;
  final String nombre;
  final String categoria; // 'artesania' | 'gastronomia'
  final String descripcion;
  final List<String> fotos;
  final double latitude;
  final double longitude;
  final String geohash;
  final double promedioCalificacion;
  final int totalCalificaciones;

  const Emprendimiento({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.fotos,
    required this.latitude,
    required this.longitude,
    required this.geohash,
    required this.promedioCalificacion,
    required this.totalCalificaciones,
  });
}
