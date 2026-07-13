import '../../models/lugar_model.dart';
import '../../models/hosteria_model.dart';
import '../../models/emprendimiento_model.dart';
import '../../models/ruta_model.dart';

abstract class LocalLugaresDataSource {
  Future<List<LugarModel>> getCachedLugares();
  Future<void> cacheLugares(List<LugarModel> lugares);

  Future<List<HosteriaModel>> getCachedHosterias();
  Future<void> cacheHosterias(List<HosteriaModel> hosterias);

  Future<List<EmprendimientoModel>> getCachedEmprendimientos();
  Future<void> cacheEmprendimientos(List<EmprendimientoModel> emprendimientos);

  Future<List<RutaModel>> getCachedRutas();
  Future<void> cacheRutas(List<RutaModel> rutas);

  Future<void> clearCache();
}

class LocalLugaresDataSourceImpl implements LocalLugaresDataSource {
  List<LugarModel> _cachedLugares = [];
  List<HosteriaModel> _cachedHosterias = [];
  List<EmprendimientoModel> _cachedEmprendimientos = [];
  List<RutaModel> _cachedRutas = [];

  @override
  Future<List<LugarModel>> getCachedLugares() async {
    return _cachedLugares;
  }

  @override
  Future<void> cacheLugares(List<LugarModel> lugares) async {
    _cachedLugares = lugares;
  }

  @override
  Future<List<HosteriaModel>> getCachedHosterias() async {
    return _cachedHosterias;
  }

  @override
  Future<void> cacheHosterias(List<HosteriaModel> hosterias) async {
    _cachedHosterias = hosterias;
  }

  @override
  Future<List<EmprendimientoModel>> getCachedEmprendimientos() async {
    return _cachedEmprendimientos;
  }

  @override
  Future<void> cacheEmprendimientos(List<EmprendimientoModel> emprendimientos) async {
    _cachedEmprendimientos = emprendimientos;
  }

  @override
  Future<List<RutaModel>> getCachedRutas() async {
    return _cachedRutas;
  }

  @override
  Future<void> cacheRutas(List<RutaModel> rutas) async {
    _cachedRutas = rutas;
  }

  @override
  Future<void> clearCache() async {
    _cachedLugares.clear();
    _cachedHosterias.clear();
    _cachedEmprendimientos.clear();
    _cachedRutas.clear();
  }
}
