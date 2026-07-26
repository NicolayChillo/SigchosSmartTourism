import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import 'lugar_detail_view.dart';
import '../../widgets/lugar_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/theme/export.dart';

class LugaresView extends StatefulWidget {
  const LugaresView({super.key});

  @override
  State<LugaresView> createState() => _LugaresViewState();
}

class _LugaresViewState extends State<LugaresView> {
  String _selectedTipo = ''; // Empty string means "All"

  final List<Map<String, String>> _categories = [
    {'label': 'Todos', 'value': ''},
    {'label': 'Cascadas', 'value': 'cascada'},
    {'label': 'Miradores', 'value': 'mirador'},
    {'label': 'Senderos', 'value': 'sendero'},
    {'label': 'Cultural', 'value': 'cultural'},
    {'label': 'Histórico', 'value': 'historico'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLugares();
    });
  }

  void _loadLugares() {
    Provider.of<LugaresViewModel>(context, listen: false).fetchLugares(
      tipo: _selectedTipo.isEmpty ? null : _selectedTipo,
    );
  }

  Future<void> _buscarCercanos(BuildContext context, LugaresViewModel vm) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activa el GPS para buscar atractivos cercanos.')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se necesita permiso de ubicación para esta función.')),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Buscando atractivos cercanos...')),
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      await vm.fetchLugaresCercanos(position.latitude, position.longitude);
      if (context.mounted) _mostrarCercanos(context, vm);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo obtener tu ubicación: $e')),
        );
      }
    }
  }

  void _mostrarCercanos(BuildContext context, LugaresViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final cercanos = vm.lugaresCercanos;
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Atractivos cercanos (radio 20 km)',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: cercanos.isEmpty
                      ? const Center(child: Text('No se encontraron atractivos cerca de ti.'))
                      : ListView.builder(
                          itemCount: cercanos.length,
                          itemBuilder: (context, index) {
                            final lugar = cercanos[index];
                            return ListTile(
                              leading: const Icon(Icons.place, color: ColoresApp.primario),
                              title: Text(lugar.nombre),
                              subtitle: Text(lugar.tipo),
                              onTap: () {
                                Navigator.pop(ctx);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => LugarDetailView(lugar: lugar)),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final placesVm = Provider.of<LugaresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atractivos Turísticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => _buscarCercanos(context, placesVm),
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedTipo == cat['value'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTipo = cat['value']!;
                      });
                      _loadLugares();
                    },
                    selectedColor: ColoresApp.primario,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : ColoresApp.textoOscuro,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          // Places List Area
          Expanded(
            child: placesVm.isLoading
                ? const LoadingWidget(message: 'Cargando atractivos...')
                : placesVm.errorMessage != null
                    ? EmptyStateWidget(
                        title: 'Error de Conexión',
                        description: placesVm.errorMessage!,
                        icon: Icons.wifi_off_rounded,
                        buttonText: 'Reintentar',
                        onButtonPressed: _loadLugares,
                      )
                    : placesVm.lugares.isEmpty
                        ? const EmptyStateWidget(
                            title: 'No hay atractivos',
                            description: 'No se encontraron lugares en esta categoría.',
                            icon: Icons.nature_people_outlined,
                          )
                        : RefreshIndicator(
                            onRefresh: () async => _loadLugares(),
                            child: ListView.builder(
                              itemCount: placesVm.lugares.length,
                              itemBuilder: (context, index) {
                                final lugar = placesVm.lugares[index];
                                return LugarCard(
                                  title: lugar.nombre,
                                  category: lugar.tipo,
                                  imageUrl: lugar.fotos.isNotEmpty ? lugar.fotos[0] : null,
                                  rating: lugar.promedioCalificacion,
                                  totalReviews: lugar.totalCalificaciones,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => LugarDetailView(lugar: lugar)),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
