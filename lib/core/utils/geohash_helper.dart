import 'dart:math';

class GeohashHelper {
  /// Calculate distance between two coordinates in kilometers using Haversine formula
  static double calculateDistanceInKm(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const double earthRadiusKm = 6371.0;
    
    final double dLat = _degreesToRadians(endLatitude - startLatitude);
    final double dLon = _degreesToRadians(endLongitude - startLongitude);

    final double lat1Rad = _degreesToRadians(startLatitude);
    final double lat2Rad = _degreesToRadians(endLatitude);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1Rad) * cos(lat2Rad);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double _radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  /// Bearing (0-360°, 0 = norte) desde el punto de origen hacia el destino,
  /// para usarse junto al heading de la brújula del dispositivo.
  static double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    final double lat1Rad = _degreesToRadians(startLatitude);
    final double lat2Rad = _degreesToRadians(endLatitude);
    final double dLon = _degreesToRadians(endLongitude - startLongitude);

    final double y = sin(dLon) * cos(lat2Rad);
    final double x =
        cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);

    final double bearing = _radiansToDegrees(atan2(y, x));
    return (bearing + 360) % 360;
  }

  /// Simple implementation of geohash encoding for reference/fallback
  static String encodeGeohash(double latitude, double longitude, {int precision = 9}) {
    const String base32 = '0123456789bcdefghjkmnpqrstuvwxyz';
    final List<int> bits = [16, 8, 4, 2, 1];
    
    double minLat = -90.0, maxLat = 90.0;
    double minLon = -180.0, maxLon = 180.0;
    
    StringBuffer geohash = StringBuffer();
    int bit = 0;
    int ch = 0;
    bool isEven = true;

    while (geohash.length < precision) {
      double mid;
      if (isEven) {
        mid = (minLon + maxLon) / 2.0;
        if (longitude > mid) {
          ch |= bits[bit];
          minLon = mid;
        } else {
          maxLon = mid;
        }
      } else {
        mid = (minLat + maxLat) / 2.0;
        if (latitude > mid) {
          ch |= bits[bit];
          minLat = mid;
        } else {
          maxLat = mid;
        }
      }

      isEven = !isEven;
      if (bit < 4) {
        bit++;
      } else {
        geohash.write(base32[ch]);
        bit = 0;
        ch = 0;
      }
    }

    return geohash.toString();
  }
}
