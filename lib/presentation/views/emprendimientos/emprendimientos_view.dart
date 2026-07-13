import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/lugar_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';

class EmprendimientosView extends StatefulWidget {
  const EmprendimientosView({super.key});

  @override
  State<EmprendimientosView> createState() => _EmprendimientosViewState();
}

class _EmprendimientosViewState extends State<EmprendimientosView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEmprendimientos();
    });
  }

  void _loadEmprendimientos() {
    Provider.of<LugaresViewModel>(context, listen: false).fetchEmprendimientos();
  }

  @override
  Widget build(BuildContext context) {
    final placesVm = Provider.of<LugaresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emprendimientos Locales'),
      ),
      body: placesVm.isLoading
          ? const LoadingWidget(message: 'Cargando emprendimientos...')
          : placesVm.errorMessage != null
              ? EmptyStateWidget(
                  title: 'Error de Red',
                  description: placesVm.errorMessage!,
                  icon: Icons.cloud_off_rounded,
                  buttonText: 'Reintentar',
                  onButtonPressed: _loadEmprendimientos,
                )
              : placesVm.emprendimientos.isEmpty
                  ? const EmptyStateWidget(
                      title: 'Sin emprendimientos',
                      description: 'No hay emprendimientos registrados en Sigchos.',
                      icon: Icons.storefront,
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _loadEmprendimientos(),
                      child: ListView.builder(
                        itemCount: placesVm.emprendimientos.length,
                        itemBuilder: (context, index) {
                          final emp = placesVm.emprendimientos[index];
                          return LugarCard(
                            title: emp.nombre,
                            category: emp.categoria,
                            imageUrl: emp.fotos.isNotEmpty ? emp.fotos[0] : null,
                            rating: emp.promedioCalificacion,
                            totalReviews: emp.totalCalificaciones,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Emprendimiento: ${emp.nombre} (${emp.categoria})')),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
