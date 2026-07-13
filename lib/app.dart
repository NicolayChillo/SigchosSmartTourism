import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/network/network_info.dart';

// Data Sources
import 'data/datasources/remote/firestore_lugares_datasource.dart';
import 'data/datasources/local/local_lugares_datasource.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/lugares_repository_impl.dart';

// ViewModels
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/lugares_viewmodel.dart';

// Views
import 'presentation/views/auth/auth_view.dart';
import 'presentation/views/home/home_view.dart';
import 'presentation/views/emprendimientos/emprendimientos_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Network Check
        Provider<NetworkInfo>(
          create: (_) => NetworkInfoImpl(),
        ),
        
        // Data Sources
        Provider<FirestoreLugaresDataSource>(
          create: (_) => FirestoreLugaresDataSourceImpl(),
        ),
        Provider<LocalLugaresDataSource>(
          create: (_) => LocalLugaresDataSourceImpl(),
        ),

        // Repositories
        Provider<AuthRepositoryImpl>(
          create: (_) => AuthRepositoryImpl(),
        ),
        ProxyProvider3<FirestoreLugaresDataSource, LocalLugaresDataSource, NetworkInfo, LugaresRepositoryImpl>(
          update: (_, remote, local, network, previous) => LugaresRepositoryImpl(
            remoteDataSource: remote,
            localDataSource: local,
            networkInfo: network,
          ),
        ),

        // ViewModels
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            repository: Provider.of<AuthRepositoryImpl>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<LugaresViewModel>(
          create: (context) => LugaresViewModel(
            repository: Provider.of<LugaresRepositoryImpl>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppConstants.routeAuth,
        routes: {
          AppConstants.routeAuth: (context) => const AuthView(),
          AppConstants.routeHome: (context) => const HomeView(),
          AppConstants.routeEmprendimientos: (context) => const EmprendimientosView(),
        },
      ),
    );
  }
}
