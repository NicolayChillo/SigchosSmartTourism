import 'package:flutter/material.dart';
import '../../domain/entities/lugar.dart';
import '../../domain/entities/hosteria.dart';
import '../../domain/entities/emprendimiento.dart';
import '../../domain/entities/ruta.dart';
import '../../domain/repositories/lugares_repository.dart';

class LugaresViewModel extends ChangeNotifier {
  final LugaresRepository repository;

  LugaresViewModel({required this.repository});

  // State Variables
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Lugar> _lugares = [];
  List<Lugar> _lugaresCercanos = [];
  List<Hosteria> _hosterias = [];
  List<Emprendimiento> _emprendimientos = [];
  List<Ruta> _rutas = [];
  List<Comentario> _comentarios = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Lugar> get lugares => _lugares;
  List<Lugar> get lugaresCercanos => _lugaresCercanos;
  List<Hosteria> get hosterias => _hosterias;
  List<Emprendimiento> get emprendimientos => _emprendimientos;
  List<Ruta> get rutas => _rutas;
  List<Comentario> get comentarios => _comentarios;

  // Setters
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Loaders
  Future<void> fetchLugares({String? tipo}) async {
    _setLoading(true);
    _setError(null);
    try {
      _lugares = await repository.getLugares(tipo: tipo);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchLugaresCercanos(double latitude, double longitude) async {
    _setLoading(true);
    _setError(null);
    try {
      _lugaresCercanos = await repository.getLugaresCercanos(latitude, longitude);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchHosterias() async {
    _setLoading(true);
    _setError(null);
    try {
      _hosterias = await repository.getHosterias();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchEmprendimientos({String? categoria}) async {
    _setLoading(true);
    _setError(null);
    try {
      _emprendimientos = await repository.getEmprendimientos(categoria: categoria);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchRutas() async {
    _setLoading(true);
    _setError(null);
    try {
      _rutas = await repository.getRutas();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchComentarios(String id, String tipoColeccion) async {
    _setLoading(true);
    _setError(null);
    try {
      _comentarios = await repository.getComentarios(id, tipoColeccion);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Actions / Mutations
  Future<bool> addComentario(String id, String tipoColeccion, Comentario comentario) async {
    _setError(null);
    try {
      await repository.addComentario(id, tipoColeccion, comentario);
      await fetchComentarios(id, tipoColeccion);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> addCalificacion(String id, String tipoColeccion, Calificacion calificacion) async {
    _setError(null);
    try {
      await repository.addCalificacion(id, tipoColeccion, calificacion);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Admin Actions
  Future<bool> createLugar(Lugar lugar) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.createLugar(lugar);
      await fetchLugares();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateLugar(Lugar lugar) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.updateLugar(lugar);
      await fetchLugares();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteLugar(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.deleteLugar(id);
      await fetchLugares();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Admin Hosterías Actions
  Future<bool> createHosteria(Hosteria hosteria) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.createHosteria(hosteria);
      await fetchHosterias();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateHosteria(Hosteria hosteria) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.updateHosteria(hosteria);
      await fetchHosterias();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteHosteria(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.deleteHosteria(id);
      await fetchHosterias();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Admin Emprendimientos Actions
  Future<bool> createEmprendimiento(Emprendimiento emprendimiento) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.createEmprendimiento(emprendimiento);
      await fetchEmprendimientos();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateEmprendimiento(Emprendimiento emprendimiento) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.updateEmprendimiento(emprendimiento);
      await fetchEmprendimientos();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteEmprendimiento(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.deleteEmprendimiento(id);
      await fetchEmprendimientos();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Admin Rutas Actions
  Future<bool> createRuta(Ruta ruta) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.createRuta(ruta);
      await fetchRutas();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateRuta(Ruta ruta) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.updateRuta(ruta);
      await fetchRutas();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteRuta(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.deleteRuta(id);
      await fetchRutas();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
