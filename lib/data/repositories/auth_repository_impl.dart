import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/usuario_model.dart';
import '../../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Usuario> signUp({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebase_auth.User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthFailure('No se pudo crear el usuario.');
      }

      final DateTime now = DateTime.now();
      final String defaultRol = 'turista'; // Rol turista por defecto

      final usuarioModel = UsuarioModel(
        uid: firebaseUser.uid,
        nombre: nombre,
        email: email,
        rol: defaultRol,
        fechaRegistro: now,
      );

      // Guardar en Firestore
      await _firestore
          .collection('usuarios')
          .doc(firebaseUser.uid)
          .set(usuarioModel.toJson());

      return usuarioModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      String mensaje = 'Ocurrió un error en el registro.';
      if (e.code == 'weak-password') {
        mensaje = 'La contraseña ingresada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        mensaje = 'Ya existe una cuenta registrada con este correo electrónico.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico ingresado no es válido.';
      }
      throw AuthFailure(mensaje);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<Usuario> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebase_auth.User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthFailure('Credenciales incorrectas.');
      }

      // Obtener rol e info extra de Firestore
      final userDoc = await _firestore.collection('usuarios').doc(firebaseUser.uid).get();
      if (!userDoc.exists) {
        // Si por alguna razón no existe el documento, crear uno por defecto
        final now = DateTime.now();
        final defaultUser = UsuarioModel(
          uid: firebaseUser.uid,
          nombre: email.split('@')[0],
          email: email,
          rol: 'turista',
          fechaRegistro: now,
        );
        await _firestore.collection('usuarios').doc(firebaseUser.uid).set(defaultUser.toJson());
        return defaultUser;
      }

      return UsuarioModel.fromJson(userDoc.data()!, firebaseUser.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      String mensaje = 'Error al iniciar sesión.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        mensaje = 'El correo electrónico o la contraseña son incorrectos.';
      } else if (e.code == 'user-disabled') {
        mensaje = 'Esta cuenta ha sido deshabilitada por el administrador.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no tiene un formato válido.';
      }
      throw AuthFailure(mensaje);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerFailure('Error al cerrar sesión: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      String mensaje = 'Error al enviar correo de recuperación.';
      if (e.code == 'user-not-found') {
        mensaje = 'No existe ningún usuario registrado con este correo.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido.';
      }
      throw AuthFailure(mensaje);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<Usuario?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc = await _firestore.collection('usuarios').doc(firebaseUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return UsuarioModel.fromJson(doc.data()!, firebaseUser.uid);
      }
    } catch (_) {
      // Ignorar errores al chequear offline, retornar datos básicos
    }
    return Usuario(
      uid: firebaseUser.uid,
      nombre: firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'Usuario',
      email: firebaseUser.email ?? '',
      rol: 'turista',
      fechaRegistro: DateTime.now(),
    );
  }

  @override
  Stream<Usuario?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final doc = await _firestore.collection('usuarios').doc(firebaseUser.uid).get();
        if (doc.exists && doc.data() != null) {
          return UsuarioModel.fromJson(doc.data()!, firebaseUser.uid);
        }
      } catch (_) {}
      return Usuario(
        uid: firebaseUser.uid,
        nombre: firebaseUser.displayName ?? 'Usuario',
        email: firebaseUser.email ?? '',
        rol: 'turista',
        fechaRegistro: DateTime.now(),
      );
    });
  }
}
