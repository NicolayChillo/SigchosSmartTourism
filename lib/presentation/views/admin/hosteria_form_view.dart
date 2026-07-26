import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/export.dart';
import '../../../core/utils/geohash_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../domain/entities/hosteria.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/location_picker_field.dart';
import '../../widgets/photo_picker_field.dart';

class HosteriaFormView extends StatefulWidget {
  final Hosteria? hosteria;

  const HosteriaFormView({super.key, this.hosteria});

  @override
  State<HosteriaFormView> createState() => _HosteriaFormViewState();
}

class _HosteriaFormViewState extends State<HosteriaFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _contactoCtrl;
  late final TextEditingController _precioCtrl;
  late List<String> _fotos;
  late LatLng _ubicacion;
  bool _guardando = false;

  bool get _esEdicion => widget.hosteria != null;

  @override
  void initState() {
    super.initState();
    final h = widget.hosteria;
    _nombreCtrl = TextEditingController(text: h?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: h?.descripcion ?? '');
    _contactoCtrl = TextEditingController(text: h?.contacto ?? '');
    _precioCtrl = TextEditingController(text: h?.precioRango ?? '');
    _fotos = List<String>.from(h?.fotos ?? []);
    _ubicacion = h != null ? LatLng(h.latitude, h.longitude) : kSigchosCentro;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _contactoCtrl.dispose();
    _precioCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final h = widget.hosteria;

    final hosteria = Hosteria(
      id: h?.id ?? '',
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      fotos: _fotos,
      latitude: _ubicacion.latitude,
      longitude: _ubicacion.longitude,
      geohash: GeohashHelper.encodeGeohash(_ubicacion.latitude, _ubicacion.longitude),
      promedioCalificacion: h?.promedioCalificacion ?? 0,
      totalCalificaciones: h?.totalCalificaciones ?? 0,
      contacto: _contactoCtrl.text.trim(),
      precioRango: _precioCtrl.text.trim(),
    );

    final ok = _esEdicion ? await vm.updateHosteria(hosteria) : await vm.createHosteria(hosteria);

    if (mounted) {
      setState(() => _guardando = false);
      if (ok) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? 'No se pudo guardar la hostería'), backgroundColor: ColoresApp.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar hostería' : 'Nueva hostería')),
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
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
                validator: (v) => Validators.validateRequired(v, 'Descripción'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactoCtrl,
                decoration: const InputDecoration(labelText: 'Contacto'),
                validator: (v) => Validators.validateRequired(v, 'Contacto'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioCtrl,
                decoration: const InputDecoration(labelText: 'Rango de precio (ej. \$20 - \$50)'),
                validator: (v) => Validators.validateRequired(v, 'Precio'),
              ),
              const SizedBox(height: 20),
              PhotoPickerField(fotos: _fotos, onChanged: (f) => setState(() => _fotos = f)),
              const SizedBox(height: 20),
              LocationPickerField(initial: _ubicacion, onChanged: (p) => _ubicacion = p),
              const SizedBox(height: 28),
              CustomButton(
                text: _esEdicion ? 'GUARDAR CAMBIOS' : 'CREAR HOSTERÍA',
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
