import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/export.dart';
import '../../../core/utils/geohash_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../domain/entities/emprendimiento.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/location_picker_field.dart';
import '../../widgets/photo_picker_field.dart';

const Map<String, String> categoriasEmprendimiento = {
  'artesania': 'Artesanía',
  'gastronomia': 'Gastronomía',
};

class EmprendimientoFormView extends StatefulWidget {
  final Emprendimiento? emprendimiento;

  const EmprendimientoFormView({super.key, this.emprendimiento});

  @override
  State<EmprendimientoFormView> createState() => _EmprendimientoFormViewState();
}

class _EmprendimientoFormViewState extends State<EmprendimientoFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late String _categoria;
  late List<String> _fotos;
  late LatLng _ubicacion;
  bool _guardando = false;

  bool get _esEdicion => widget.emprendimiento != null;

  @override
  void initState() {
    super.initState();
    final e = widget.emprendimiento;
    _nombreCtrl = TextEditingController(text: e?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: e?.descripcion ?? '');
    _categoria = e?.categoria ?? categoriasEmprendimiento.keys.first;
    _fotos = List<String>.from(e?.fotos ?? []);
    _ubicacion = e != null ? LatLng(e.latitude, e.longitude) : kSigchosCentro;
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

    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final e = widget.emprendimiento;

    final emprendimiento = Emprendimiento(
      id: e?.id ?? '',
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoria,
      descripcion: _descripcionCtrl.text.trim(),
      fotos: _fotos,
      latitude: _ubicacion.latitude,
      longitude: _ubicacion.longitude,
      geohash: GeohashHelper.encodeGeohash(_ubicacion.latitude, _ubicacion.longitude),
      promedioCalificacion: e?.promedioCalificacion ?? 0,
      totalCalificaciones: e?.totalCalificaciones ?? 0,
    );

    final ok = _esEdicion
        ? await vm.updateEmprendimiento(emprendimiento)
        : await vm.createEmprendimiento(emprendimiento);

    if (mounted) {
      setState(() => _guardando = false);
      if (ok) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? 'No se pudo guardar el emprendimiento'), backgroundColor: ColoresApp.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar emprendimiento' : 'Nuevo emprendimiento')),
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
                initialValue: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: categoriasEmprendimiento.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setState(() => _categoria = v!),
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
                text: _esEdicion ? 'GUARDAR CAMBIOS' : 'CREAR EMPRENDIMIENTO',
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
