import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/export.dart';
import '../../../core/utils/geohash_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../domain/entities/lugar.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/location_picker_field.dart';
import '../../widgets/photo_picker_field.dart';

const Map<String, String> tiposLugar = {
  'cascada': 'Cascada',
  'laguna': 'Laguna',
  'mirador': 'Mirador',
  'sendero': 'Sendero',
  'historico': 'Histórico',
  'cultural': 'Cultural',
};

class LugarFormView extends StatefulWidget {
  final Lugar? lugar;

  const LugarFormView({super.key, this.lugar});

  @override
  State<LugarFormView> createState() => _LugarFormViewState();
}

class _LugarFormViewState extends State<LugarFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late String _tipo;
  late List<String> _fotos;
  late LatLng _ubicacion;
  bool _guardando = false;

  bool get _esEdicion => widget.lugar != null;

  @override
  void initState() {
    super.initState();
    final l = widget.lugar;
    _nombreCtrl = TextEditingController(text: l?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: l?.descripcion ?? '');
    _tipo = l?.tipo ?? tiposLugar.keys.first;
    _fotos = List<String>.from(l?.fotos ?? []);
    _ubicacion = l != null ? LatLng(l.latitude, l.longitude) : kSigchosCentro;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final l = widget.lugar;

    final lugar = Lugar(
      id: l?.id ?? '',
      nombre: _nombreCtrl.text.trim(),
      tipo: _tipo,
      descripcion: _descripcionCtrl.text.trim(),
      fotos: _fotos,
      latitude: _ubicacion.latitude,
      longitude: _ubicacion.longitude,
      geohash: GeohashHelper.encodeGeohash(_ubicacion.latitude, _ubicacion.longitude),
      promedioCalificacion: l?.promedioCalificacion ?? 0,
      totalCalificaciones: l?.totalCalificaciones ?? 0,
      creadoPor: l?.creadoPor ?? authVm.currentUser?.uid ?? 'admin',
      fechaCreacion: l?.fechaCreacion ?? DateTime.now(),
    );

    final ok = _esEdicion ? await vm.updateLugar(lugar) : await vm.createLugar(lugar);

    if (mounted) {
      setState(() => _guardando = false);
      if (ok) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? 'No se pudo guardar el atractivo'), backgroundColor: ColoresApp.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar atractivo' : 'Nuevo atractivo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => Validators.validateRequired(v, 'Nombre'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: tiposLugar.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setState(() => _tipo = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 5,
                validator: (v) => Validators.validateRequired(v, 'Descripción'),
              ),
              const SizedBox(height: 20),
              PhotoPickerField(fotos: _fotos, onChanged: (f) => setState(() => _fotos = f)),
              const SizedBox(height: 20),
              LocationPickerField(initial: _ubicacion, onChanged: (p) => _ubicacion = p),
              const SizedBox(height: 28),
              CustomButton(
                text: _esEdicion ? 'GUARDAR CAMBIOS' : 'CREAR ATRACTIVO',
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
