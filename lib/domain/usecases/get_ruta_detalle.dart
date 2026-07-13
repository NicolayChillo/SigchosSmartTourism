import '../entities/ruta.dart';
import '../repositories/lugares_repository.dart';

class GetRutaDetalle {
  final LugaresRepository repository;

  GetRutaDetalle(this.repository);

  Future<Ruta> call(String id) async {
    return await repository.getRutaDetalle(id);
  }
}
