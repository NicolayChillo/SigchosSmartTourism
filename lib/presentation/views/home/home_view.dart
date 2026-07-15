import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../lugares/lugares_view.dart';
import '../hosterias/hosterias_view.dart';
import '../rutas/rutas_view.dart';
import '../perfil/perfil_view.dart';
import '../admin/admin_view.dart';
import '../../../core/theme/export.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final isAdmin = authVm.isAdmin;

    // Define views list based on user role
    final List<Widget> views = [
      const _InicioTab(),
      const LugaresView(),
      const HosteriasView(),
      const RutasView(),
      const PerfilView(),
      if (isAdmin) const AdminView(),
    ];

    return Scaffold(
      body: views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColoresApp.primario,
        unselectedItemColor: ColoresApp.textoClaro,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Lugares',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.hotel_outlined),
            activeIcon: Icon(Icons.hotel),
            label: 'Hosterías',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Rutas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          if (isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined),
              activeIcon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
        ],
      ),
    );
  }
}

class _InicioTab extends StatelessWidget {
  const _InicioTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigchos Smart Tourist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image/Hero Banner
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=800',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Descubre la magia de Sigchos',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Welcome Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0,
                color: ColoresApp.primario.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido a Sigchos!',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: ColoresApp.primario,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explora senderos andinos, admira cascadas espectaculares y experimenta la cultura local de nuestro hermoso cantón.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: ColoresApp.textoOscuro,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Quick Navigation Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categorías Principales',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildQuickLinkCard(
                  context,
                  title: 'Atractivos',
                  icon: Icons.landscape,
                  color: ColoresApp.primario,
                  onTap: () {
                    // Navigate to places tab or view
                  },
                ),
                _buildQuickLinkCard(
                  context,
                  title: 'Hosterías',
                  icon: Icons.hotel,
                  color: ColoresApp.secundario,
                  onTap: () {
                    // Navigate to hoterias tab
                  },
                ),
                _buildQuickLinkCard(
                  context,
                  title: 'Emprendimientos',
                  icon: Icons.storefront,
                  color: ColoresApp.acento,
                  onTap: () {
                    Navigator.pushNamed(context, '/emprendimientos');
                  },
                ),
                _buildQuickLinkCard(
                  context,
                  title: 'Rutas y Senderos',
                  icon: Icons.directions_walk,
                  color: Colors.brown,
                  onTap: () {
                    // Navigate to routes tab
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinkCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
