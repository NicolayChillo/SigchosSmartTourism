import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/lugar_model.dart';
import '../../models/hosteria_model.dart';
import '../../models/emprendimiento_model.dart';
import '../../models/ruta_model.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/geohash_helper.dart';

abstract class FirestoreLugaresDataSource {
  // Lugares
  Future<List<LugarModel>> getLugares({String? tipo});
  Future<List<LugarModel>> getLugaresCercanos(double latitude, double longitude);
  Future<void> createLugar(LugarModel lugar);
  Future<void> updateLugar(LugarModel lugar);
  Future<void> deleteLugar(String id);

  // Hosterías
  Future<List<HosteriaModel>> getHosterias();
  Future<void> createHosteria(HosteriaModel hosteria);
  Future<void> updateHosteria(HosteriaModel hosteria);
  Future<void> deleteHosteria(String id);

  // Emprendimientos
  Future<List<EmprendimientoModel>> getEmprendimientos({String? categoria});
  Future<void> createEmprendimiento(EmprendimientoModel emprendimiento);
  Future<void> updateEmprendimiento(EmprendimientoModel emprendimiento);
  Future<void> deleteEmprendimiento(String id);

  // Rutas
  Future<List<RutaModel>> getRutas();
  Future<RutaModel> getRutaDetalle(String id);
  Future<void> createRuta(RutaModel ruta);
  Future<void> updateRuta(RutaModel ruta);
  Future<void> deleteRuta(String id);

  // Comentarios y calificaciones
  Future<List<ComentarioModel>> getComentarios(String id, String coleccionPadre);
  Future<void> addComentario(String id, String coleccionPadre, ComentarioModel comentario);
  Future<void> addCalificacion(String id, String coleccionPadre, CalificacionModel calificacion);
}

class FirestoreLugaresDataSourceImpl implements FirestoreLugaresDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Radio de búsqueda para "atractivos cercanos", en kilómetros.
  static const double _radioCercanosKm = 20.0;

  @override
  Future<List<LugarModel>> getLugares({String? tipo}) async {
    try {
      Query query = _firestore.collection('lugares');
      if (tipo != null && tipo.isNotEmpty) {
        query = query.where('tipo', isEqualTo: tipo);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => LugarModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('Error al obtener lugares: ${e.toString()}');
    }
  }

  @override
  Future<List<LugarModel>> getLugaresCercanos(double latitude, double longitude) async {
    // El catálogo de esta app es pequeño (decenas de atractivos), así que en
    // vez de una geoquery de Firestore, se trae todo y se filtra/ordena por
    // distancia real en el cliente con GeohashHelper.
    final todos = await getLugares();
    final conDistancia = todos.map((l) {
      final distancia = GeohashHelper.calculateDistanceInKm(
        latitude,
        longitude,
        l.latitude,
        l.longitude,
      );
      return (lugar: l, distancia: distancia);
    }).where((e) => e.distancia <= _radioCercanosKm).toList()
      ..sort((a, b) => a.distancia.compareTo(b.distancia));

    return conDistancia.map((e) => e.lugar).toList();
  }

  @override
  Future<void> createLugar(LugarModel lugar) async {
    try {
      await _firestore
          .collection('lugares')
          .doc(lugar.id.isEmpty ? null : lugar.id)
          .set(lugar.toJson());
    } catch (e) {
      throw ServerFailure('Error al guardar el lugar: ${e.toString()}');
    }
  }

  @override
  Future<void> updateLugar(LugarModel lugar) async {
    try {
      await _firestore.collection('lugares').doc(lugar.id).update(lugar.toJson());
    } catch (e) {
      throw ServerFailure('Error al actualizar el lugar: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteLugar(String id) async {
    try {
      await _firestore.collection('lugares').doc(id).delete();
    } catch (e) {
      throw ServerFailure('Error al eliminar el lugar: ${e.toString()}');
    }
  }

  // Hosterías
  @override
  Future<List<HosteriaModel>> getHosterias() async {
    try {
      final snapshot = await _firestore.collection('hosterias').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final geoPoint = data['geopoint'] as GeoPoint?;
        return HosteriaModel.fromJson({
          ...data,
          'latitude': geoPoint?.latitude ?? 0.0,
          'longitude': geoPoint?.longitude ?? 0.0,
        }, doc.id);
      }).toList();
    } catch (e) {
      throw ServerFailure('Error al obtener hosterías: ${e.toString()}');
    }
  }

  @override
  Future<void> createHosteria(HosteriaModel hosteria) async {
    try {
      final geoPoint = GeoPoint(hosteria.latitude, hosteria.longitude);
      final json = hosteria.toJson();
      json['geopoint'] = geoPoint;
      await _firestore.collection('hosterias').doc(hosteria.id.isEmpty ? null : hosteria.id).set(json);
    } catch (e) {
      throw ServerFailure('Error al crear hostería: ${e.toString()}');
    }
  }

  @override
  Future<void> updateHosteria(HosteriaModel hosteria) async {
    try {
      final geoPoint = GeoPoint(hosteria.latitude, hosteria.longitude);
      final json = hosteria.toJson();
      json['geopoint'] = geoPoint;
      await _firestore.collection('hosterias').doc(hosteria.id).update(json);
    } catch (e) {
      throw ServerFailure('Error al actualizar hostería: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteHosteria(String id) async {
    try {
      await _firestore.collection('hosterias').doc(id).delete();
    } catch (e) {
      throw ServerFailure('Error al eliminar hostería: ${e.toString()}');
    }
  }

  // Emprendimientos
  @override
  Future<List<EmprendimientoModel>> getEmprendimientos({String? categoria}) async {
    try {
      Query query = _firestore.collection('emprendimientos');
      if (categoria != null && categoria.isNotEmpty) {
        query = query.where('categoria', isEqualTo: categoria);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final geoPoint = data['geopoint'] as GeoPoint?;
        return EmprendimientoModel.fromJson({
          ...data,
          'latitude': geoPoint?.latitude ?? 0.0,
          'longitude': geoPoint?.longitude ?? 0.0,
        }, doc.id);
      }).toList();
    } catch (e) {
      throw ServerFailure('Error al obtener emprendimientos: ${e.toString()}');
    }
  }

  @override
  Future<void> createEmprendimiento(EmprendimientoModel emprendimiento) async {
    try {
      final geoPoint = GeoPoint(emprendimiento.latitude, emprendimiento.longitude);
      final json = emprendimiento.toJson();
      json['geopoint'] = geoPoint;
      await _firestore.collection('emprendimientos').doc(emprendimiento.id.isEmpty ? null : emprendimiento.id).set(json);
    } catch (e) {
      throw ServerFailure('Error al crear emprendimiento: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmprendimiento(EmprendimientoModel emprendimiento) async {
    try {
      final geoPoint = GeoPoint(emprendimiento.latitude, emprendimiento.longitude);
      final json = emprendimiento.toJson();
      json['geopoint'] = geoPoint;
      await _firestore.collection('emprendimientos').doc(emprendimiento.id).update(json);
    } catch (e) {
      throw ServerFailure('Error al actualizar emprendimiento: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEmprendimiento(String id) async {
    try {
      await _firestore.collection('emprendimientos').doc(id).delete();
    } catch (e) {
      throw ServerFailure('Error al eliminar emprendimiento: ${e.toString()}');
    }
  }

  // Rutas
  @override
  Future<List<RutaModel>> getRutas() async {
    try {
      final snapshot = await _firestore.collection('rutas').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RutaModel.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      throw ServerFailure('Error al obtener rutas: ${e.toString()}');
    }
  }

  @override
  Future<RutaModel> getRutaDetalle(String id) async {
    try {
      final doc = await _firestore.collection('rutas').doc(id).get();
      if (!doc.exists) {
        throw ServerFailure('La ruta especificada no existe');
      }
      return RutaModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw ServerFailure('Error al obtener detalle de la ruta: ${e.toString()}');
    }
  }

  @override
  Future<void> createRuta(RutaModel ruta) async {
    try {
      await _firestore.collection('rutas').doc(ruta.id.isEmpty ? null : ruta.id).set(ruta.toJson());
    } catch (e) {
      throw ServerFailure('Error al crear ruta: ${e.toString()}');
    }
  }

  @override
  Future<void> updateRuta(RutaModel ruta) async {
    try {
      await _firestore.collection('rutas').doc(ruta.id).update(ruta.toJson());
    } catch (e) {
      throw ServerFailure('Error al actualizar ruta: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRuta(String id) async {
    try {
      await _firestore.collection('rutas').doc(id).delete();
    } catch (e) {
      throw ServerFailure('Error al eliminar ruta: ${e.toString()}');
    }
  }

  // Comentarios y calificaciones
  @override
  Future<List<ComentarioModel>> getComentarios(String id, String coleccionPadre) async {
    try {
      final snapshot = await _firestore
          .collection(coleccionPadre)
          .doc(id)
          .collection('comentarios')
          .orderBy('fecha', descending: true)
          .get();

      return snapshot.docs.map((doc) => ComentarioModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw ServerFailure('Error al obtener comentarios: ${e.toString()}');
    }
  }

  @override
  Future<void> addComentario(String id, String coleccionPadre, ComentarioModel comentario) async {
    try {
      await _firestore
          .collection(coleccionPadre)
          .doc(id)
          .collection('comentarios')
          .doc(comentario.id.isEmpty ? null : comentario.id)
          .set(comentario.toJson());
    } catch (e) {
      throw ServerFailure('Error al guardar comentario: ${e.toString()}');
    }
  }

  @override
  Future<void> addCalificacion(String id, String coleccionPadre, CalificacionModel calificacion) async {
    try {
      final docRef = _firestore.collection(coleccionPadre).doc(id);
      // El ID del documento es el UID del usuario para evitar doble calificación
      await docRef.collection('calificaciones').doc(calificacion.uid).set(calificacion.toJson());

      // El padre guarda el promedio y el total precalculados para no tener
      // que leer toda la subcolección en cada listado.
      final todas = await docRef.collection('calificaciones').get();
      final valores = todas.docs
          .map((d) => (d.data()['valor'] as num?)?.toInt() ?? 0)
          .toList();
      final total = valores.length;
      final promedio = total == 0
          ? 0.0
          : valores.reduce((a, b) => a + b) / total;

      await docRef.update({
        'promedioCalificacion': promedio,
        'totalCalificaciones': total,
      });
    } catch (e) {
      throw ServerFailure('Error al registrar calificación: ${e.toString()}');
    }
  }
}
