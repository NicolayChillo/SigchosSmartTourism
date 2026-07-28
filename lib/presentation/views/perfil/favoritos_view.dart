import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/favoritos_viewmodel.dart';
import '../../viewmodels/lugares_viewmodel.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../domain/entities/favorito.dart';
import '../lugares/lugar_detail_view.dart';
import '../hosterias/hosteria_detail_view.dart';
import '../emprendimientos/emprendimiento_detail_view.dart';

const Map<String, String> _tipoLabels = {
  'lugares': 'Atractivo',
  'hosterias': 'Hostería',
  'emprendimientos': 'Emprendimiento',
};

class FavoritosView extends StatefulWidget {
  const FavoritosView({super.key});

  @override
  State<FavoritosView> createState() => _FavoritosViewState();
}

class _FavoritosViewState extends State<FavoritosView> {
  bool _abriendo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = Provider.of<AuthViewModel>(context, listen: false).currentUser?.uid;
      if (uid != null) {
        Provider.of<FavoritosViewModel>(context, listen: false).cargar(uid);
      }
    });
  }

  Future<void> _abrirDetalle(Favorito fav) async {
    if (_abriendo) return;
    setState(() => _abriendo = true);
    final lugaresVm = Provider.of<LugaresViewModel>(context, listen: false);

    try {
      switch (fav.tipo) {
        case 'lugares':
          if (lugaresVm.lugares.isEmpty) await lugaresVm.fetchLugares();
          final lugar = _buscar(lugaresVm.lugares, fav.itemId, (l) => l.id);
          if (lugar == null) return _noDisponible();
          if (!mounted) return;
          Navigator.push(context, MaterialPageRoute(builder: (_) => LugarDetailView(lugar: lugar)));
          break;
        case 'hosterias':
          if (lugaresVm.hosterias.isEmpty) await lugaresVm.fetchHosterias();
          final hosteria = _buscar(lugaresVm.hosterias, fav.itemId, (h) => h.id);
          if (hosteria == null) return _noDisponible();
          if (!mounted) return;
          Navigator.push(context, MaterialPageRoute(builder: (_) => HosteriaDetailView(hosteria: hosteria)));
          break;
        case 'emprendimientos':
          if (lugaresVm.emprendimientos.isEmpty) await lugaresVm.fetchEmprendimientos();
          final emp = _buscar(lugaresVm.emprendimientos, fav.itemId, (e) => e.id);
          if (emp == null) return _noDisponible();
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmprendimientoDetailView(emprendimiento: emp)),
          );
          break;
      }
    } finally {
      if (mounted) setState(() => _abriendo = false);
    }
  }

  T? _buscar<T>(List<T> lista, String id, String Function(T) getId) {
    for (final item in lista) {
      if (getId(item) == id) return item;
    }
    return null;
  }

  void _noDisponible() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Este elemento ya no está disponible en el catálogo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritosVm = Provider.of<FavoritosViewModel>(context);
    final uid = Provider.of<AuthViewModel>(context, listen: false).currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: favoritosVm.isLoading
          ? const LoadingWidget(message: 'Cargando tus favoritos...')
          : favoritosVm.favoritos.isEmpty
              ? const EmptyStateWidget(
                  title: 'Sin favoritos todavía',
                  description: 'Toca el ícono de corazón en cualquier atractivo, hostería o emprendimiento para guardarlo aquí.',
                  icon: Icons.favorite_border,
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: favoritosVm.favoritos.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final fav = favoritosVm.favoritos[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 52,
                          height: 52,
                          child: AppImage(path: fav.foto ?? '', fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(fav.nombre),
                      subtitle: Text(_tipoLabels[fav.tipo] ?? fav.tipo),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.redAccent),
                        tooltip: 'Quitar de favoritos',
                        onPressed: uid == null
                            ? null
                            : () => favoritosVm.toggle(
                                  uid: uid,
                                  tipo: fav.tipo,
                                  itemId: fav.itemId,
                                  nombre: fav.nombre,
                                  foto: fav.foto,
                                ),
                      ),
                      onTap: () => _abrirDetalle(fav),
                    );
                  },
                ),
    );
  }
}
