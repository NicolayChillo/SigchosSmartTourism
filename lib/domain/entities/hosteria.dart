class Hosteria {
  final String id;
  final String nombre;
  final String descripcion;
  final List<String> fotos;
  final double latitude;
  final double longitude;
  final String geohash;
  final double promedioCalificacion;
  final int totalCalificaciones;
  final String contacto;
  final String precioRango; // e.g., "$$ - $$$" or "$20 - $50"

  const Hosteria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fotos,
    required this.latitude,
    required this.longitude,
    required this.geohash,
    required this.promedioCalificacion,
    required this.totalCalificaciones,
    required this.contacto,
    required this.precioRango,
  });
}
