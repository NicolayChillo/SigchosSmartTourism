import '../entities/lugar.dart';
import '../entities/hosteria.dart';
import '../entities/emprendimiento.dart';
import '../entities/ruta.dart';

abstract class LugaresRepository {
  // Lugares
  Future<List<Lugar>> getLugares({String? tipo});
  Future<List<Lugar>> getLugaresCercanos(double latitude, double longitude);
  Future<void> createLugar(Lugar lugar);
  Future<void> updateLugar(Lugar lugar);
  Future<void> deleteLugar(String id);

  // Hosterías
  Future<List<Hosteria>> getHosterias();
  Future<void> createHosteria(Hosteria hosteria);
  Future<void> updateHosteria(Hosteria hosteria);
  Future<void> deleteHosteria(String id);

  // Emprendimientos
  Future<List<Emprendimiento>> getEmprendimientos({String? categoria});
  Future<void> createEmprendimiento(Emprendimiento emprendimiento);
  Future<void> updateEmprendimiento(Emprendimiento emprendimiento);
  Future<void> deleteEmprendimiento(String id);

  // Rutas
  Future<List<Ruta>> getRutas();
  Future<Ruta> getRutaDetalle(String id);
  Future<void> createRuta(Ruta ruta);
  Future<void> updateRuta(Ruta ruta);
  Future<void> deleteRuta(String id);

  // Experiencias (Comentarios y Calificaciones)
  Future<List<Comentario>> getComentarios(String id, String tipoColeccion);
  Future<void> addComentario(String id, String tipoColeccion, Comentario comentario);
  Future<void> addCalificacion(String id, String tipoColeccion, Calificacion calificacion);
}
