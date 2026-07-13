import '../../domain/entities/lugar.dart';
import '../../domain/entities/hosteria.dart';
import '../../domain/entities/emprendimiento.dart';
import '../../domain/entities/ruta.dart';
import '../../domain/repositories/lugares_repository.dart';
import '../datasources/remote/firestore_lugares_datasource.dart';
import '../datasources/local/local_lugares_datasource.dart';
import '../../core/network/network_info.dart';
import '../../core/errors/failures.dart';
import '../models/lugar_model.dart';
import '../models/hosteria_model.dart';
import '../models/emprendimiento_model.dart';
import '../models/ruta_model.dart';

class LugaresRepositoryImpl implements LugaresRepository {
  final FirestoreLugaresDataSource remoteDataSource;
  final LocalLugaresDataSource localDataSource;
  final NetworkInfo networkInfo;

  LugaresRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Lugar>> getLugares({String? tipo}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLugares = await remoteDataSource.getLugares(tipo: tipo);
        await localDataSource.cacheLugares(remoteLugares);
        return remoteLugares;
      } catch (e) {
        return await localDataSource.getCachedLugares();
      }
    } else {
      final cached = await localDataSource.getCachedLugares();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const ConnectionFailure();
    }
  }

  @override
  Future<List<Lugar>> getLugaresCercanos(double latitude, double longitude) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getLugaresCercanos(latitude, longitude);
    } else {
      throw const ConnectionFailure('Se requiere conexión a Internet para buscar lugares cercanos.');
    }
  }

  @override
  Future<void> createLugar(Lugar lugar) async {
    if (await networkInfo.isConnected) {
      final model = LugarModel(
        id: lugar.id,
        nombre: lugar.nombre,
        tipo: lugar.tipo,
        descripcion: lugar.descripcion,
        fotos: lugar.fotos,
        latitude: lugar.latitude,
        longitude: lugar.longitude,
        geohash: lugar.geohash,
        promedioCalificacion: lugar.promedioCalificacion,
        totalCalificaciones: lugar.totalCalificaciones,
        creadoPor: lugar.creadoPor,
        fechaCreacion: lugar.fechaCreacion,
      );
      await remoteDataSource.createLugar(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> updateLugar(Lugar lugar) async {
    if (await networkInfo.isConnected) {
      final model = LugarModel(
        id: lugar.id,
        nombre: lugar.nombre,
        tipo: lugar.tipo,
        descripcion: lugar.descripcion,
        fotos: lugar.fotos,
        latitude: lugar.latitude,
        longitude: lugar.longitude,
        geohash: lugar.geohash,
        promedioCalificacion: lugar.promedioCalificacion,
        totalCalificaciones: lugar.totalCalificaciones,
        creadoPor: lugar.creadoPor,
        fechaCreacion: lugar.fechaCreacion,
      );
      await remoteDataSource.updateLugar(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> deleteLugar(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteLugar(id);
    } else {
      throw const ConnectionFailure();
    }
  }

  // Hosterías
  @override
  Future<List<Hosteria>> getHosterias() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteHosterias = await remoteDataSource.getHosterias();
        await localDataSource.cacheHosterias(remoteHosterias);
        return remoteHosterias;
      } catch (e) {
        return await localDataSource.getCachedHosterias();
      }
    } else {
      final cached = await localDataSource.getCachedHosterias();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> createHosteria(Hosteria hosteria) async {
    if (await networkInfo.isConnected) {
      final model = HosteriaModel(
        id: hosteria.id,
        nombre: hosteria.nombre,
        descripcion: hosteria.descripcion,
        fotos: hosteria.fotos,
        latitude: hosteria.latitude,
        longitude: hosteria.longitude,
        geohash: hosteria.geohash,
        promedioCalificacion: hosteria.promedioCalificacion,
        totalCalificaciones: hosteria.totalCalificaciones,
        contacto: hosteria.contacto,
        precioRango: hosteria.precioRango,
      );
      await remoteDataSource.createHosteria(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> updateHosteria(Hosteria hosteria) async {
    if (await networkInfo.isConnected) {
      final model = HosteriaModel(
        id: hosteria.id,
        nombre: hosteria.nombre,
        descripcion: hosteria.descripcion,
        fotos: hosteria.fotos,
        latitude: hosteria.latitude,
        longitude: hosteria.longitude,
        geohash: hosteria.geohash,
        promedioCalificacion: hosteria.promedioCalificacion,
        totalCalificaciones: hosteria.totalCalificaciones,
        contacto: hosteria.contacto,
        precioRango: hosteria.precioRango,
      );
      await remoteDataSource.updateHosteria(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> deleteHosteria(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteHosteria(id);
    } else {
      throw const ConnectionFailure();
    }
  }

  // Emprendimientos
  @override
  Future<List<Emprendimiento>> getEmprendimientos({String? categoria}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEmprendimientos = await remoteDataSource.getEmprendimientos(categoria: categoria);
        await localDataSource.cacheEmprendimientos(remoteEmprendimientos);
        return remoteEmprendimientos;
      } catch (e) {
        return await localDataSource.getCachedEmprendimientos();
      }
    } else {
      final cached = await localDataSource.getCachedEmprendimientos();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> createEmprendimiento(Emprendimiento emprendimiento) async {
    if (await networkInfo.isConnected) {
      final model = EmprendimientoModel(
        id: emprendimiento.id,
        nombre: emprendimiento.nombre,
        categoria: emprendimiento.categoria,
        descripcion: emprendimiento.descripcion,
        fotos: emprendimiento.fotos,
        latitude: emprendimiento.latitude,
        longitude: emprendimiento.longitude,
        geohash: emprendimiento.geohash,
        promedioCalificacion: emprendimiento.promedioCalificacion,
        totalCalificaciones: emprendimiento.totalCalificaciones,
      );
      await remoteDataSource.createEmprendimiento(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> updateEmprendimiento(Emprendimiento emprendimiento) async {
    if (await networkInfo.isConnected) {
      final model = EmprendimientoModel(
        id: emprendimiento.id,
        nombre: emprendimiento.nombre,
        categoria: emprendimiento.categoria,
        descripcion: emprendimiento.descripcion,
        fotos: emprendimiento.fotos,
        latitude: emprendimiento.latitude,
        longitude: emprendimiento.longitude,
        geohash: emprendimiento.geohash,
        promedioCalificacion: emprendimiento.promedioCalificacion,
        totalCalificaciones: emprendimiento.totalCalificaciones,
      );
      await remoteDataSource.updateEmprendimiento(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> deleteEmprendimiento(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteEmprendimiento(id);
    } else {
      throw const ConnectionFailure();
    }
  }

  // Rutas
  @override
  Future<List<Ruta>> getRutas() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRutas = await remoteDataSource.getRutas();
        await localDataSource.cacheRutas(remoteRutas);
        return remoteRutas;
      } catch (e) {
        return await localDataSource.getCachedRutas();
      }
    } else {
      final cached = await localDataSource.getCachedRutas();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const ConnectionFailure();
    }
  }

  @override
  Future<Ruta> getRutaDetalle(String id) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getRutaDetalle(id);
    } else {
      final cached = await localDataSource.getCachedRutas();
      final localRuta = cached.firstWhere((r) => r.id == id, orElse: () => throw const ConnectionFailure());
      return localRuta;
    }
  }

  @override
  Future<void> createRuta(Ruta ruta) async {
    if (await networkInfo.isConnected) {
      final model = RutaModel(
        id: ruta.id,
        nombre: ruta.nombre,
        lugarId: ruta.lugarId,
        puntosGPS: ruta.puntosGPS,
        distanciaKm: ruta.distanciaKm,
        tiempoEstimadoMin: ruta.tiempoEstimadoMin,
        dificultad: ruta.dificultad,
      );
      await remoteDataSource.createRuta(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> updateRuta(Ruta ruta) async {
    if (await networkInfo.isConnected) {
      final model = RutaModel(
        id: ruta.id,
        nombre: ruta.nombre,
        lugarId: ruta.lugarId,
        puntosGPS: ruta.puntosGPS,
        distanciaKm: ruta.distanciaKm,
        tiempoEstimadoMin: ruta.tiempoEstimadoMin,
        dificultad: ruta.dificultad,
      );
      await remoteDataSource.updateRuta(model);
    } else {
      throw const ConnectionFailure();
    }
  }

  @override
  Future<void> deleteRuta(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteRuta(id);
    } else {
      throw const ConnectionFailure();
    }
  }

  // Comentarios y Calificaciones
  @override
  Future<List<Comentario>> getComentarios(String id, String tipoColeccion) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getComentarios(id, tipoColeccion);
    } else {
      throw const ConnectionFailure('No se pueden cargar comentarios sin conexión a Internet.');
    }
  }

  @override
  Future<void> addComentario(String id, String tipoColeccion, Comentario comentario) async {
    if (await networkInfo.isConnected) {
      final model = ComentarioModel(
        id: comentario.id,
        uid: comentario.uid,
        nombreUsuario: comentario.nombreUsuario,
        fotoUsuario: comentario.fotoUsuario,
        texto: comentario.texto,
        fecha: comentario.fecha,
        fotos: comentario.fotos,
      );
      await remoteDataSource.addComentario(id, tipoColeccion, model);
    } else {
      throw const ConnectionFailure('Requiere conexión a Internet para comentar.');
    }
  }

  @override
  Future<void> addCalificacion(String id, String tipoColeccion, Calificacion calificacion) async {
    if (await networkInfo.isConnected) {
      final model = CalificacionModel(
        uid: calificacion.uid,
        valor: calificacion.valor,
        fecha: calificacion.fecha,
      );
      await remoteDataSource.addCalificacion(id, tipoColeccion, model);
    } else {
      throw const ConnectionFailure('Requiere conexión a Internet para calificar.');
    }
  }
}
