import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../widgets/lugar_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';

class HosteriasView extends StatefulWidget {
  const HosteriasView({super.key});

  @override
  State<HosteriasView> createState() => _HosteriasViewState();
}

class _HosteriasViewState extends State<HosteriasView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHosterias();
    });
  }

  void _loadHosterias() {
    Provider.of<LugaresViewModel>(context, listen: false).fetchHosterias();
  }

  @override
  Widget build(BuildContext context) {
    final placesVm = Provider.of<LugaresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospedaje y Hosterías'),
      ),
      body: placesVm.isLoading
          ? const LoadingWidget(message: 'Buscando hosterías...')
          : placesVm.errorMessage != null
              ? EmptyStateWidget(
                  title: 'Error al Cargar',
                  description: placesVm.errorMessage!,
                  icon: Icons.error_outline_rounded,
                  buttonText: 'Reintentar',
                  onButtonPressed: _loadHosterias,
                )
              : placesVm.hosterias.isEmpty
                  ? const EmptyStateWidget(
                      title: 'Sin opciones de hospedaje',
                      description: 'No se han registrado hosterías todavía.',
                      icon: Icons.hotel_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _loadHosterias(),
                      child: ListView.builder(
                        itemCount: placesVm.hosterias.length,
                        itemBuilder: (context, index) {
                          final hosteria = placesVm.hosterias[index];
                          return LugarCard(
                            title: hosteria.nombre,
                            category: 'Hostería - ${hosteria.precioRango}',
                            imageUrl: hosteria.fotos.isNotEmpty ? hosteria.fotos[0] : null,
                            rating: hosteria.promedioCalificacion,
                            totalReviews: hosteria.totalCalificaciones,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Hostería: ${hosteria.nombre}. Contacto: ${hosteria.contacto}')),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
