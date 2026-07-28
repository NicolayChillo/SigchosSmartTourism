class Favorito {
  final String id; // "${tipo}_${itemId}"
  final String itemId;
  final String tipo; // 'lugares' | 'hosterias' | 'emprendimientos'
  final String nombre;
  final String? foto;
  final DateTime fecha;

  const Favorito({
    required this.id,
    required this.itemId,
    required this.tipo,
    required this.nombre,
    this.foto,
    required this.fecha,
  });
}
