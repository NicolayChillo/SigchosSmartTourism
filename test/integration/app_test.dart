import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sigchos_smart_tourist/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('flujo completo de autenticación y navegación', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. Verificar que estamos en la pantalla de auth
    expect(find.text('Iniciar Sesión'), findsOneWidget);

    // 2. Rellenar email y contraseña (usuarios de prueba)
    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    // 3. Verificar que navega al home (esperar algún widget del home)
    // Ajusta según tu implementación real
    expect(find.text('Sigchos Smart Tourist'), findsOneWidget);
  });
}