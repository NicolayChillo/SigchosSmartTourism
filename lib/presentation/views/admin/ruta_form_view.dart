import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/export.dart';
import '../../../core/utils/geohash_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../domain/entities/ruta.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/location_picker_field.dart' show kSigchosCentro;
import '../../widgets/photo_picker_field.dart';

const List<String> dificultades = ['Fácil', 'Moderado', 'Difícil'];

class RutaFormView extends StatefulWidget {
  final Ruta? ruta;

  const RutaFormView({super.key, this.ruta});

  @override
  State<RutaFormView> createState() => _RutaFormViewState();
}

class _RutaFormViewState extends State<RutaFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _tiempoCtrl;
  late String _dificultad;
  String? _lugarId;
  late List<LatLng> _puntos;
  late List<String> _fotos;
  bool _guardando = false;

  bool get _esEdicion => widget.ruta != null;

  @override
  void initState() {
    super.initState();
    final r = widget.ruta;
    _nombreCtrl = TextEditingController(text: r?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: r?.descripcion ?? '');
    _tiempoCtrl = TextEditingController(text: r?.tiempoEstimadoMin.toString() ?? '');
    _dificultad = r?.dificultad ?? dificultades.first;
    _lugarId = r?.lugarId;
    _puntos = r?.puntosGPS.map((p) => LatLng(p.latitude, p.longitude)).toList() ?? [];
    _fotos = List.of(r?.fotos ?? const []);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _tiempoCtrl.dispose();
    super.dispose();
  }

  double get _distanciaCalculada {
    double total = 0;
    for (var i = 0; i < _puntos.length - 1; i++) {
      total += GeohashHelper.calculateDistanceInKm(
        _puntos[i].latitude,
        _puntos[i].longitude,
        _puntos[i + 1].latitude,
        _puntos[i + 1].longitude,
      );
    }
    return total;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_puntos.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marca al menos 2 puntos en el mapa para la ruta.')),
      );
      return;
    }
    if (_lugarId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el atractivo asociado a la ruta.')),
      );
      return;
    }

    setState(() => _guardando = true);
    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final r = widget.ruta;

    final ruta = Ruta(
      id: r?.id ?? '',
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      lugarId: _lugarId!,
      puntosGPS: _puntos.map((p) => RutaPunto(latitude: p.latitude, longitude: p.longitude)).toList(),
      fotos: _fotos,
      distanciaKm: _distanciaCalculada,
      tiempoEstimadoMin: int.tryParse(_tiempoCtrl.text.trim()) ?? 0,
      dificultad: _dificultad,
    );

    final ok = _esEdicion ? await vm.updateRuta(ruta) : await vm.createRuta(ruta);

    if (mounted) {
      setState(() => _guardando = false);
      if (ok) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? 'No se pudo guardar la ruta'), backgroundColor: ColoresApp.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LugaresViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar ruta' : 'Nueva ruta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la ruta'),
                validator: (v) => Validators.validateRequired(v, 'Nombre'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              PhotoPickerField(
                fotos: _fotos,
                onChanged: (fotos) => setState(() => _fotos = fotos),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _lugarId,
                decoration: const InputDecoration(labelText: 'Atractivo asociado'),
                hint: const Text('Selecciona un atractivo'),
                items: vm.lugares
                    .map((l) => DropdownMenuItem(value: l.id, child: Text(l.nombre)))
                    .toList(),
                onChanged: (v) => setState(() => _lugarId = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _dificultad,
                decoration: const InputDecoration(labelText: 'Dificultad'),
                items: dificultades.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => _dificultad = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tiempoCtrl,
                decoration: const InputDecoration(labelText: 'Tiempo estimado (minutos)'),
                keyboardType: TextInputType.number,
                validator: (v) => Validators.validateRequired(v, 'Tiempo estimado'),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntos de la ruta (toca el mapa para agregar)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 260,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _puntos.isNotEmpty ? _puntos.first : kSigchosCentro,
                      zoom: 13,
                    ),
                    onTap: (p) => setState(() => _puntos.add(p)),
                    polylines: {
                      if (_puntos.length > 1)
                        Polyline(
                          polylineId: const PolylineId('preview'),
                          points: _puntos,
                          color: ColoresApp.primario,
                          width: 4,
                        ),
                    },
                    markers: {
                      for (var i = 0; i < _puntos.length; i++)
                        Marker(
                          markerId: MarkerId('punto_$i'),
                          position: _puntos[i],
                          infoWindow: InfoWindow(title: 'Punto ${i + 1}'),
                        ),
                    },
                    zoomControlsEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${_puntos.length} puntos · ${_distanciaCalculada.toStringAsFixed(2)} km'),
                  const Spacer(),
                  TextButton(
                    onPressed: _puntos.isEmpty ? null : () => setState(() => _puntos.removeLast()),
                    child: const Text('Deshacer último punto'),
                  ),
                  TextButton(
                    onPressed: _puntos.isEmpty ? null : () => setState(() => _puntos.clear()),
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: _esEdicion ? 'GUARDAR CAMBIOS' : 'CREAR RUTA',
                isLoading: _guardando,
                onPressed: _guardar,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
