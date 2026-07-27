import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../../core/theme/export.dart';
import '../../../core/data/seed_data.dart';
import 'lugar_form_view.dart';
import 'hosteria_form_view.dart';
import 'emprendimiento_form_view.dart';
import 'ruta_form_view.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  Future<void> _cargarCatalogoInicial(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cargar catálogo inicial'),
        content: const Text(
          'Esto creará los 14 atractivos, 5 hosterías y 5 emprendimientos reales de Sigchos en Firestore. '
          'Vuelve a ejecutarlo solo si sabes que quieres duplicar registros.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cargar')),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;

    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Cargando catálogo inicial...')));

    var creados = 0;
    for (final lugar in seedLugares) {
      if (await vm.createLugar(lugar)) creados++;
    }
    for (final hosteria in seedHosterias) {
      if (await vm.createHosteria(hosteria)) creados++;
    }
    for (final emprendimiento in seedEmprendimientos) {
      if (await vm.createEmprendimiento(emprendimiento)) creados++;
    }

    messenger.showSnackBar(
      SnackBar(content: Text('Catálogo cargado: $creados registros creados.')),
    );
  }

  Future<void> _cargarRutasIniciales(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cargar rutas iniciales'),
        content: const Text(
          'Esto creará las 12 rutas de senderismo reales de Sigchos (Circuito Quilotoa y otras) en Firestore. '
          'Vuelve a ejecutarlo solo si sabes que quieres duplicar registros.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cargar')),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;

    final vm = Provider.of<LugaresViewModel>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Cargando rutas iniciales...')));

    var creados = 0;
    for (final ruta in seedRutas) {
      if (await vm.createRuta(ruta)) creados++;
    }

    messenger.showSnackBar(
      SnackBar(content: Text('Rutas cargadas: $creados registros creados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel de Administración'),
          actions: [
            IconButton(
              tooltip: 'Cargar catálogo inicial',
              icon: const Icon(Icons.cloud_upload_outlined),
              onPressed: () => _cargarCatalogoInicial(context),
            ),
            IconButton(
              tooltip: 'Cargar rutas iniciales',
              icon: const Icon(Icons.route_outlined),
              onPressed: () => _cargarRutasIniciales(context),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: ColoresApp.secundario,
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

  void _abrirFormulario(BuildContext context, {dynamic item}) {
    Widget form;
    switch (coleccion) {
      case 'lugares':
        form = LugarFormView(lugar: item);
        break;
      case 'hosterias':
        form = HosteriaFormView(hosteria: item);
        break;
      case 'emprendimientos':
        form = EmprendimientoFormView(emprendimiento: item);
        break;
      default:
        form = RutaFormView(ruta: item);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => form));
  }

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
                style: Theme.of(context).textTheme.bodyMedium,
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
                          onPressed: () => _abrirFormulario(context, item: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
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
        backgroundColor: ColoresApp.secundario,
        onPressed: () => _abrirFormulario(context),
        child: const Icon(Icons.add, color: Colors.white),
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
