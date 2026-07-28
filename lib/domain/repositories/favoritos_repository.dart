import '../entities/favorito.dart';

abstract class FavoritosRepository {
  Future<List<Favorito>> getFavoritos(String uid);

  Future<void> addFavorito(String uid, Favorito favorito);

  Future<void> removeFavorito(String uid, String tipo, String itemId);
}
