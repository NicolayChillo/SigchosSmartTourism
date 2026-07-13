import 'package:flutter/material.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel({required this.repository}) {
    _init();
  }

  bool _isLoading = false;
  String? _errorMessage;
  Usuario? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Usuario? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.rol == 'administrador';

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _init() {
    repository.onAuthStateChanged.listen((Usuario? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> checkCurrentUser() async {
    _currentUser = await repository.getCurrentUser();
    notifyListeners();
  }

  Future<bool> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await repository.signUp(
        nombre: nombre,
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await repository.signIn(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await repository.signOut();
      _currentUser = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await repository.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
