import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/export.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/geohash_helper.dart';

/// Brújula que apunta hacia [targetLatitude]/[targetLongitude] combinando el
/// magnetómetro del dispositivo (flutter_compass) con la posición GPS actual.
class CompassWidget extends StatefulWidget {
  final double targetLatitude;
  final double targetLongitude;

  const CompassWidget({
    super.key,
    required this.targetLatitude,
    required this.targetLongitude,
  });

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  Position? _position;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarUbicacion();
  }

  Future<void> _cargarUbicacion() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('El GPS está desactivado.');

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Permiso de ubicación denegado.');
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _position = position);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColoresApp.primario.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.borde),
      ),
      child: Row(
        children: [
          _buildBrujula(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Brújula', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                if (_loading)
                  const Text('Obteniendo tu ubicación...')
                else if (_error != null)
                  Text(_error!, style: const TextStyle(color: ColoresApp.error, fontSize: 12))
                else if (_position != null)
                  Text(
                    'Distancia: ${Formatters.formatDistance(GeohashHelper.calculateDistanceInKm(
                      _position!.latitude,
                      _position!.longitude,
                      widget.targetLatitude,
                      widget.targetLongitude,
                    ))}',
                  ),
                const SizedBox(height: 4),
                if (!_loading)
                  TextButton(
                    onPressed: _cargarUbicacion,
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: const Text('Actualizar ubicación'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrujula() {
    if (_position == null) {
      return const Icon(Icons.explore_off_outlined, size: 48, color: ColoresApp.textoClaro);
    }
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final heading = snapshot.data?.heading;
        if (heading == null) {
          return const Icon(Icons.explore_off_outlined, size: 48, color: ColoresApp.textoClaro);
        }
        final bearing = GeohashHelper.calculateBearing(
          _position!.latitude,
          _position!.longitude,
          widget.targetLatitude,
          widget.targetLongitude,
        );
        final angle = (bearing - heading) * pi / 180;
        return Transform.rotate(
          angle: angle,
          child: const Icon(Icons.navigation_rounded, size: 48, color: ColoresApp.primario),
        );
      },
    );
  }
}
