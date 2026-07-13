class AppConstants {
  // App Info
  static const String appName = 'Sigchos Smart Tourist';

  // Navigation Routes
  static const String routeSplash = '/';
  static const String routeAuth = '/auth';
  static const String routeHome = '/home';
  static const String routeLugares = '/lugares';
  static const String routeHosterias = '/hosterias';
  static const String routeEmprendimientos = '/emprendimientos';
  static const String routeRutas = '/rutas';
  static const String routePerfil = '/perfil';
  static const String routeAdmin = '/admin';

  // Firebase Collections
  static const String collectionUsuarios = 'usuarios';
  static const String collectionLugares = 'lugares';
  static const String collectionHosterias = 'hosterias';
  static const String collectionEmprendimientos = 'emprendimientos';
  static const String collectionRutas = 'rutas';
  static const String collectionComentarios = 'comentarios';
  static const String collectionCalificaciones = 'calificaciones';

  // Shared Preferences or Hive Keys
  static const String keyUserRole = 'user_role';
  static const String keyIsLoggedIn = 'is_logged_in';
}
