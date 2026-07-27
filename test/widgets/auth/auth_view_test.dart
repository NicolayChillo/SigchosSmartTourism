import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:sigchos_smart_tourist/presentation/views/auth/auth_view.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sigchos_smart_tourist/domain/repositories/auth_repository.dart';
import 'package:sigchos_smart_tourist/domain/entities/usuario.dart';

import 'auth_view_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late StreamController<Usuario?> authStateController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authStateController = StreamController<Usuario?>.broadcast();

    // Configurar el stream de autenticación
    when(mockAuthRepository.onAuthStateChanged)
        .thenAnswer((_) => authStateController.stream);

    // Configurar comportamientos por defecto (exitosos)
    when(mockAuthRepository.signIn(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Usuario(
      uid: '123',
      nombre: 'Test User',
      email: 'test@example.com',
      rol: 'turista',
      fechaRegistro: DateTime.now(),
    ));

    when(mockAuthRepository.signUp(
      nombre: anyNamed('nombre'),
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Usuario(
      uid: '123',
      nombre: 'Test User',
      email: 'test@example.com',
      rol: 'turista',
      fechaRegistro: DateTime.now(),
    ));

    when(mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => null);
  });

  tearDown(() {
    authStateController.close();
  });

  // Función para construir el widget con el ViewModel mockeado
  Widget buildTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(
        repository: mockAuthRepository,
      ),
      child: MaterialApp(
        home: const AuthView(),
        routes: {
          '/home': (context) => const Scaffold(
            body: Text('Home Page'),
          ),
        },
      ),
    );
  }

  group('AuthView - Modo Login', () {
    testWidgets('debe mostrar el formulario de login inicialmente', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Sigchos Smart Tourist'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('INGRESAR'), findsOneWidget);
      expect(find.text('¿No tienes cuenta? Regístrate aquí'), findsOneWidget);
    });

    testWidgets('debe mostrar error de validación si el email es inválido', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField).at(0), 'correo-invalido');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('INGRESAR'));
      await tester.pump();

      // ✅ Mensaje correcto según Validators.validateEmail
      expect(find.text('Ingrese un correo electrónico válido'), findsOneWidget);
      verifyNever(mockAuthRepository.signIn(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    testWidgets('con credenciales válidas debe llamar a login y navegar a home', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('INGRESAR'));
      await tester.pump();

      // Verificar que se llamó a signIn con los argumentos correctos
      verify(mockAuthRepository.signIn(
        email: 'test@example.com',
        password: '123456',
      )).called(1);

      // Emitir usuario autenticado para que el ViewModel lo reciba
      authStateController.add(Usuario(
        uid: '123',
        nombre: 'Test User',
        email: 'test@example.com',
        rol: 'turista',
        fechaRegistro: DateTime.now(),
      ));
      await tester.pumpAndSettle();

      // Verificar navegación
      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('si login falla, debe mostrar SnackBar con el error', (tester) async {
      // Configurar fallo
      when(mockAuthRepository.signIn(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow('Credenciales incorrectas');

      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('INGRESAR'));
      await tester.pump();

      // Verificar SnackBar
      expect(find.text('Credenciales incorrectas'), findsOneWidget);
      // No debe navegar
      expect(find.text('Home Page'), findsNothing);
    });
  });

  group('AuthView - Modo Registro', () {
    testWidgets('al tocar "Regístrate aquí" debe cambiar a modo registro', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('¿No tienes cuenta? Regístrate aquí'));
      await tester.pump();

      expect(find.text('Crear una cuenta'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('REGISTRARME'), findsOneWidget);
      expect(find.text('¿Ya tienes una cuenta? Inicia sesión'), findsOneWidget);
    });

    testWidgets('debe mostrar error de validación si el nombre está vacío', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('¿No tienes cuenta? Regístrate aquí'));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), ''); // nombre vacío
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '123456');

      await tester.tap(find.text('REGISTRARME'));
      await tester.pump();

      expect(find.text('El campo Nombre es obligatorio'), findsOneWidget);
      verifyNever(mockAuthRepository.signUp(
        nombre: anyNamed('nombre'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    testWidgets('con datos válidos debe llamar a register y navegar a home', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('¿No tienes cuenta? Regístrate aquí'));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Usuario Test');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '123456');
      await tester.tap(find.text('REGISTRARME'));
      await tester.pump();

      verify(mockAuthRepository.signUp(
        nombre: 'Usuario Test',
        email: 'test@example.com',
        password: '123456',
      )).called(1);

      // Emitir usuario autenticado para que el ViewModel lo reciba
      authStateController.add(Usuario(
        uid: '123',
        nombre: 'Usuario Test',
        email: 'test@example.com',
        rol: 'turista',
        fechaRegistro: DateTime.now(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('si register falla, debe mostrar SnackBar con el error', (tester) async {
      when(mockAuthRepository.signUp(
        nombre: anyNamed('nombre'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow('El email ya está registrado');

      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('¿No tienes cuenta? Regístrate aquí'));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Usuario Test');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '123456');
      await tester.tap(find.text('REGISTRARME'));
      await tester.pump();

      expect(find.text('El email ya está registrado'), findsOneWidget);
    });
  });
}