import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  /// Abre Google Maps (app o navegador) con direcciones hacia el destino.
  static Future<void> abrirDirecciones(double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> llamar(String telefono) async {
    final uri = Uri(scheme: 'tel', path: telefono);
    await launchUrl(uri);
  }
}
