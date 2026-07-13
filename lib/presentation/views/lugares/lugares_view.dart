import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/lugar_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final placesVm = Provider.of<LugaresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atractivos Turísticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // Trigger GPS nearby search
              placesVm.fetchLugaresCercanos(-0.7012, -78.8872); // Sigchos coordinates mock
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Buscando atractivos cercanos...')),
              );
            },
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
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
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
                                    // Open place details view
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Detalle de ${lugar.nombre}')),
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
