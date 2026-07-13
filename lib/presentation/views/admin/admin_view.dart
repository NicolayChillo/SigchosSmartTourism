import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../../core/theme/app_theme.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel de Administración'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.secondary,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.landscape), text: 'Atractivos'),
              Tab(icon: Icon(Icons.hotel), text: 'Hosterías'),
              Tab(icon: Icon(Icons.storefront), text: 'Negocios'),
              Tab(icon: Icon(Icons.map), text: 'Rutas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AdminListTab(coleccion: 'lugares'),
            _AdminListTab(coleccion: 'hosterias'),
            _AdminListTab(coleccion: 'emprendimientos'),
            _AdminListTab(coleccion: 'rutas'),
          ],
        ),
      ),
    );
  }
}

class _AdminListTab extends StatelessWidget {
  final String coleccion;

  const _AdminListTab({required this.coleccion});

  @override
  Widget build(BuildContext context) {
    final placesVm = Provider.of<LugaresViewModel>(context);

    // Filter items depending on tab selection
    List<dynamic> items = [];
    if (coleccion == 'lugares') {
      items = placesVm.lugares;
    } else if (coleccion == 'hosterias') {
      items = placesVm.hosterias;
    } else if (coleccion == 'emprendimientos') {
      items = placesVm.emprendimientos;
    } else if (coleccion == 'rutas') {
      items = placesVm.rutas;
    }

    return Scaffold(
      body: items.isEmpty
          ? Center(
              child: Text(
                'No hay registros para mostrar.',
                style: AppTextStyles.bodyMedium,
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item.nombre),
                    subtitle: Text(
                      coleccion == 'rutas'
                          ? 'Dificultad: ${item.dificultad}'
                          : 'ID: ${item.id}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Trigger edit dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Editar ${item.nombre}')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Show delete confirmation dialog
                            _confirmDelete(context, placesVm, item);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Trigger create dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Crear nuevo registro en $coleccion')),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, LugaresViewModel vm, dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro de que desea eliminar a "${item.nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(ctx);
              bool success = false;
              if (coleccion == 'lugares') {
                success = await vm.deleteLugar(item.id);
              } else if (coleccion == 'hosterias') {
                success = await vm.deleteHosteria(item.id);
              } else if (coleccion == 'emprendimientos') {
                success = await vm.deleteEmprendimiento(item.id);
              } else if (coleccion == 'rutas') {
                success = await vm.deleteRuta(item.id);
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Eliminado con éxito' : 'Ocurrió un error al eliminar'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
