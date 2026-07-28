import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/favorito.dart';
import '../../domain/repositories/favoritos_repository.dart';
import '../models/favorito_model.dart';
import '../../../core/errors/failures.dart';

class FavoritosRepositoryImpl implements FavoritosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _coleccion(String uid) =>
      _firestore.collection('usuarios').doc(uid).collection('favoritos');

  @override
  Future<List<Favorito>> getFavoritos(String uid) async {
    try {
      final snapshot = await _coleccion(uid).orderBy('fecha', descending: true).get();
      // map<Favorito> (no solo .map) para que la lista resultante quede
      // tipada como List<Favorito> en tiempo de ejecución, no List<FavoritoModel>;
      // si no, insertar un Favorito genérico luego (ver FavoritosViewModel)
      // lanza un error de tipo covariante.
      return snapshot.docs.map<Favorito>((doc) => FavoritoModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw ServerFailure('Error al obtener favoritos: ${e.toString()}');
    }
  }

  @override
  Future<void> addFavorito(String uid, Favorito favorito) async {
    try {
      final model = FavoritoModel(
        id: favorito.id,
        itemId: favorito.itemId,
        tipo: favorito.tipo,
        nombre: favorito.nombre,
        foto: favorito.foto,
        fecha: favorito.fecha,
      );
      await _coleccion(uid).doc(favorito.id).set(model.toJson());
    } catch (e) {
      throw ServerFailure('Error al guardar favorito: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorito(String uid, String tipo, String itemId) async {
    try {
      await _coleccion(uid).doc('${tipo}_$itemId').delete();
    } catch (e) {
      throw ServerFailure('Error al quitar favorito: ${e.toString()}');
    }
  }
}
