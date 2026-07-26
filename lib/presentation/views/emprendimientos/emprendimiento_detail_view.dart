import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/export.dart';
import '../../../core/utils/map_launcher.dart';
import '../../../domain/entities/emprendimiento.dart';
import '../../widgets/compass_widget.dart';
import '../../widgets/photo_gallery.dart';
import '../../widgets/review_section.dart';

class EmprendimientoDetailView extends StatelessWidget {
  final Emprendimiento emprendimiento;

  const EmprendimientoDetailView({super.key, required this.emprendimiento});

  @override
  Widget build(BuildContext context) {
    final destino = LatLng(emprendimiento.latitude, emprendimiento.longitude);

    return Scaffold(
      appBar: AppBar(title: Text(emprendimiento.nombre)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoGallery(fotos: emprendimiento.fotos),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColoresApp.secundario,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      emprendimiento.categoria.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(emprendimiento.nombre, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        emprendimiento.promedioCalificacion.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text('(${emprendimiento.totalCalificaciones} calificaciones)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(emprendimiento.descripcion, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  CompassWidget(targetLatitude: emprendimiento.latitude, targetLongitude: emprendimiento.longitude),
                  const SizedBox(height: 20),
                  Text('Ubicación', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: destino, zoom: 14),
                        markers: {
                          Marker(markerId: MarkerId(emprendimiento.id), position: destino, infoWindow: InfoWindow(title: emprendimiento.nombre)),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => MapLauncher.abrirDirecciones(emprendimiento.latitude, emprendimiento.longitude),
                      icon: const Icon(Icons.directions),
                      label: const Text('Cómo llegar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColoresApp.primario,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  ReviewSection(id: emprendimiento.id, tipoColeccion: 'emprendimientos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
