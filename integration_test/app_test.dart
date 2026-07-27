// Prueba de integración real: arranca la app completa (Firebase real
// incluido) en un dispositivo/emulador. Se ejecuta con:
//   flutter test integration_test/app_test.dart -d <device>
// No se recoge con `flutter test` (que solo mira la carpeta test/), por eso
// vive fuera de ahí, siguiendo la convención del paquete integration_test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sigchos_smart_tourist/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('flujo completo de autenticación y navegación', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Si el dispositivo ya tenía una sesión persistida de una corrida
    // anterior, cerrarla para que la prueba siempre arranque en Auth.
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      await tester.pumpAndSettle();
    }

    // 1. Verificar que estamos en la pantalla de auth
    expect(find.text('Iniciar Sesión'), findsOneWidget);

    // 2. Rellenar email y contraseña (cuenta de prueba real del proyecto)
    await tester.enterText(find.byType(TextFormField).at(0), 'testqa.maps@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test1234');
    await tester.tap(find.text('INGRESAR'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 3. Verificar que navega al home (widget exclusivo de HomeView)
    expect(find.text('Categorías Principales'), findsOneWidget);
  });
}
