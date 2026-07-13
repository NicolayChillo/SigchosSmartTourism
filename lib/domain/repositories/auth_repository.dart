import '../entities/usuario.dart';

abstract class AuthRepository {
  Future<Usuario> signUp({
    required String nombre,
    required String email,
    required String password,
  });

  Future<Usuario> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<Usuario?> getCurrentUser();

  Stream<Usuario?> get onAuthStateChanged;
}
