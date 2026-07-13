import '../entities/lugar.dart';
import '../repositories/lugares_repository.dart';

class GetLugaresCercanos {
  final LugaresRepository repository;

  GetLugaresCercanos(this.repository);

  Future<List<Lugar>> call(double latitude, double longitude) async {
    return await repository.getLugaresCercanos(latitude, longitude);
  }
}
