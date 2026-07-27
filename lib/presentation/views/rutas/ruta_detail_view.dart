import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/export.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/map_launcher.dart';
import '../../../domain/entities/lugar.dart';
import '../../../domain/entities/ruta.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/photo_gallery.dart';
import '../lugares/lugar_detail_view.dart';

class RutaDetailView extends StatelessWidget {
  final Ruta ruta;

  const RutaDetailView({super.key, required this.ruta});

  @override
  Widget build(BuildContext context) {
    final puntos = ruta.puntosGPS.map((p) => LatLng(p.latitude, p.longitude)).toList();
    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final lugaresCoincidentes = vm.lugares.where((l) => l.id == ruta.lugarId);
    final Lugar? lugarAsociado = lugaresCoincidentes.isEmpty ? null : lugaresCoincidentes.first;

    Color difficultyColor;
    switch (ruta.dificultad.toLowerCase()) {
      case 'fácil':
        difficultyColor = Colors.green;
        break;
      case 'moderado':
        difficultyColor = Colors.orange;
        break;
      case 'difícil':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = ColoresApp.textoClaro;
    }

    return Scaffold(
      appBar: AppBar(title: Text(ruta.nombre)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ruta.fotos.isNotEmpty) PhotoGallery(fotos: ruta.fotos),
            if (puntos.isNotEmpty)
              SizedBox(
                height: 260,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: puntos.first, zoom: 13),
                  polylines: {
                    Polyline(
                      polylineId: PolylineId(ruta.id),
                      points: puntos,
                      color: ColoresApp.primario,
                      width: 4,
                    ),
                  },
                  markers: {
                    Marker(markerId: const MarkerId('inicio'), position: puntos.first, infoWindow: const InfoWindow(title: 'Inicio')),
                    Marker(markerId: const MarkerId('fin'), position: puntos.last, infoWindow: const InfoWindow(title: 'Fin')),
                  },
                  zoomControlsEnabled: false,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ruta.nombre, style: Theme.of(context).textTheme.titleLarge),
                  if (ruta.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(ruta.descripcion, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 12,
                    children: [
                      _infoChip(Icons.social_distance, Formatters.formatDistance(ruta.distanciaKm)),
                      _infoChip(Icons.access_time, Formatters.formatDuration(ruta.tiempoEstimadoMin)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: difficultyColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ruta.dificultad,
                          style: TextStyle(color: difficultyColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (puntos.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => MapLauncher.abrirDirecciones(puntos.last.latitude, puntos.last.longitude),
                        icon: const Icon(Icons.navigation),
                        label: const Text('Navegación GPS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.primario,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  if (lugarAsociado != null) ...[
                    const SizedBox(height: 24),
                    Text('Atractivo asociado', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16)),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.landscape, color: ColoresApp.primario),
                        title: Text(lugarAsociado.nombre),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LugarDetailView(lugar: lugarAsociado)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: ColoresApp.textoClaro),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
