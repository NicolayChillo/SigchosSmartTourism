// Smoke test de la app: en vez de levantar MyApp() completo (que crea
// repositorios reales respaldados por Firebase y falla sin un backend real),
// se prueba AuthView -la pantalla inicial real- con un AuthRepository
// mockeado, igual que en test/widgets/auth/auth_view_test.dart.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sigchos_smart_tourist/presentation/views/auth/auth_view.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sigchos_smart_tourist/domain/entities/usuario.dart';

import 'widgets/auth/auth_view_test.mocks.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final mockAuthRepository = MockAuthRepository();
    final authStateController = StreamController<Usuario?>.broadcast();
    addTearDown(authStateController.close);

    when(mockAuthRepository.onAuthStateChanged)
        .thenAnswer((_) => authStateController.stream);
    when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(repository: mockAuthRepository),
        child: MaterialApp(home: const AuthView()),
      ),
    );

    // Verifica que la pantalla inicial de la app (login) se muestra.
    expect(find.text('Sigchos Smart Tourist'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
