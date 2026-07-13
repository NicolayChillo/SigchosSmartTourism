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
