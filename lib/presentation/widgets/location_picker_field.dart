import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/export.dart';

const LatLng kSigchosCentro = LatLng(-0.7012, -78.8872);

/// Mapa interactivo: toca para mover el marcador y elegir la ubicación de
/// un lugar/hostería/emprendimiento nuevo o existente.
class LocationPickerField extends StatefulWidget {
  final LatLng initial;
  final ValueChanged<LatLng> onChanged;

  const LocationPickerField({super.key, required this.initial, required this.onChanged});

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  late LatLng _seleccionado = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ubicación (toca el mapa para ajustar)', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 220,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _seleccionado, zoom: 13),
              markers: {
                Marker(
                  markerId: const MarkerId('seleccion'),
                  position: _seleccionado,
                  draggable: true,
                  onDragEnd: _actualizar,
                ),
              },
              onTap: _actualizar,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${_seleccionado.latitude.toStringAsFixed(6)}, ${_seleccionado.longitude.toStringAsFixed(6)}',
          style: const TextStyle(color: ColoresApp.textoClaro, fontSize: 12),
        ),
      ],
    );
  }

  void _actualizar(LatLng punto) {
    setState(() => _seleccionado = punto);
    widget.onChanged(punto);
  }
}
