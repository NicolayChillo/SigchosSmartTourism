import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';

class RutasView extends StatefulWidget {
  const RutasView({super.key});

  @override
  State<RutasView> createState() => _RutasViewState();
}

class _RutasViewState extends State<RutasView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRutas();
    });
  }

  void _loadRutas() {
    Provider.of<LugaresViewModel>(context, listen: false).fetchRutas();
  }

  @override
  Widget build(BuildContext context) {
    final placesVm = Provider.of<LugaresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas y Senderos'),
      ),
      body: placesVm.isLoading
          ? const LoadingWidget(message: 'Cargando senderos...')
          : placesVm.errorMessage != null
              ? EmptyStateWidget(
                  title: 'Error de Carga',
                  description: placesVm.errorMessage!,
                  icon: Icons.map_outlined,
                  buttonText: 'Reintentar',
                  onButtonPressed: _loadRutas,
                )
              : placesVm.rutas.isEmpty
                  ? const EmptyStateWidget(
                      title: 'Sin rutas registradas',
                      description: 'No se encontraron senderos de excursión.',
                      icon: Icons.directions_walk,
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _loadRutas(),
                      child: ListView.builder(
                        itemCount: placesVm.rutas.length,
                        itemBuilder: (context, index) {
                          final ruta = placesVm.rutas[index];
                          
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
                              difficultyColor = AppColors.textSecondary;
                          }

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.directions_run_rounded,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                ruta.nombre,
                                style: AppTextStyles.titleSmall.copyWith(fontSize: 16),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.social_distance, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(Formatters.formatDistance(ruta.distanciaKm)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(Formatters.formatDuration(ruta.tiempoEstimadoMin)),
                                  ],
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: difficultyColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ruta.dificultad,
                                      style: TextStyle(
                                        color: difficultyColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Cargando mapa para: ${ruta.nombre}')),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
