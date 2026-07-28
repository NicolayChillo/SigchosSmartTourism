import 'package:flutter/material.dart';
import '../../domain/entities/favorito.dart';
import '../../domain/repositories/favoritos_repository.dart';

class FavoritosViewModel extends ChangeNotifier {
  final FavoritosRepository repository;

  FavoritosViewModel({required this.repository});

  List<Favorito> _favoritos = [];
  final Set<String> _claves = {};
  bool _isLoading = false;
  String? _errorMessage;
  String? _uidCargado;

  List<Favorito> get favoritos => _favoritos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _clave(String tipo, String itemId) => '${tipo}_$itemId';

  bool esFavorito(String tipo, String itemId) => _claves.contains(_clave(tipo, itemId));

  /// Carga los favoritos del usuario una sola vez por sesión (no vuelve a
  /// pedirlos a Firestore si ya se cargaron para el mismo uid).
  Future<void> cargar(String uid) async {
    if (_uidCargado == uid) return;
    _isLoading = true;
    notifyListeners();
    try {
      _favoritos = await repository.getFavoritos(uid);
      _claves
        ..clear()
        ..addAll(_favoritos.map((f) => _clave(f.tipo, f.itemId)));
      _uidCargado = uid;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggle({
    required String uid,
    required String tipo,
    required String itemId,
    required String nombre,
    String? foto,
  }) async {
    final clave = _clave(tipo, itemId);
    final yaEsFavorito = _claves.contains(clave);

    // Actualización optimista para que la estrella responda al instante.
    if (yaEsFavorito) {
      _claves.remove(clave);
      _favoritos.removeWhere((f) => f.tipo == tipo && f.itemId == itemId);
    } else {
      _claves.add(clave);
      _favoritos.insert(
        0,
        Favorito(id: clave, itemId: itemId, tipo: tipo, nombre: nombre, foto: foto, fecha: DateTime.now()),
      );
    }
    notifyListeners();

    try {
      if (yaEsFavorito) {
        await repository.removeFavorito(uid, tipo, itemId);
      } else {
        await repository.addFavorito(
          uid,
          Favorito(id: clave, itemId: itemId, tipo: tipo, nombre: nombre, foto: foto, fecha: DateTime.now()),
        );
      }
    } catch (e) {
      // Revertir si la escritura remota falla.
      if (yaEsFavorito) {
        _claves.add(clave);
        _favoritos.insert(
          0,
          Favorito(id: clave, itemId: itemId, tipo: tipo, nombre: nombre, foto: foto, fecha: DateTime.now()),
        );
      } else {
        _claves.remove(clave);
        _favoritos.removeWhere((f) => f.tipo == tipo && f.itemId == itemId);
      }
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Limpia el estado en memoria al cerrar sesión, para que no se filtren
  /// favoritos de un usuario a la sesión del siguiente en el mismo equipo.
  void limpiar() {
    _favoritos = [];
    _claves.clear();
    _uidCargado = null;
  }
}
