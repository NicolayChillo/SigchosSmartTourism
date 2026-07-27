import 'package:flutter_test/flutter_test.dart';
import 'package:sigchos_smart_tourist/core/utils/geohash_helper.dart';

void main() {
  group('GeohashHelper', () {
    test('calcula distancia correctamente entre dos puntos', () {
      // Sigchos (aproximado)
      const lat1 = -0.7000;
      const lon1 = -78.8833;
      // Atracción cercana (ejemplo)
      const lat2 = -0.7100;
      const lon2 = -78.9000;

      final distancia = GeohashHelper.calculateDistanceInKm(
        lat1, lon1,
        lat2, lon2,
      );

      // Distancia esperada ~2.1 km (valor aproximado)
      expect(distancia, closeTo(2.1, 0.5));
    });

    test('distancia a sí mismo debe ser 0', () {
      const lat = -0.7000;
      const lon = -78.8833;
      final distancia = GeohashHelper.calculateDistanceInKm(lat, lon, lat, lon);
      expect(distancia, 0.0);
    });
  });
}