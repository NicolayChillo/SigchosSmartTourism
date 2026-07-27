import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sigchos_smart_tourist/presentation/views/home/home_view.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/lugares_viewmodel.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/notifications_viewmodel.dart';
import 'package:sigchos_smart_tourist/domain/repositories/lugares_repository.dart';
import 'package:sigchos_smart_tourist/domain/repositories/auth_repository.dart';

import 'home_view_test.mocks.dart';

@GenerateMocks([LugaresRepository, AuthRepository]) // ✅ añadimos AuthRepository
void main() {
  late MockLugaresRepository mockLugaresRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockLugaresRepo = MockLugaresRepository();
    mockAuthRepo = MockAuthRepository();
    when(mockAuthRepo.onAuthStateChanged).thenAnswer((_) => Stream.empty()); // ✅
  });

  Widget createWidget() {
    return MultiProvider( // ✅ usamos MultiProvider
      providers: [
        ChangeNotifierProvider<LugaresViewModel>(
          create: (_) => LugaresViewModel(repository: mockLugaresRepo),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(repository: mockAuthRepo),
        ),
        ChangeNotifierProvider<NotificationsViewModel>(
          create: (_) => NotificationsViewModel(autoInit: false),
        ),
      ],
      child: const MaterialApp(home: HomeView()),
    );
  }

  testWidgets('debe mostrar el título y las categorías', (tester) async {
    when(mockLugaresRepo.getLugares()).thenAnswer((_) async => []);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Sigchos Smart Tourist'), findsOneWidget);
      expect(find.text('Atractivos'), findsOneWidget);
      // "Hosterías" aparece tanto en la tarjeta de acceso rápido como en el
      // ítem del bottom nav.
      expect(find.text('Hosterías'), findsWidgets);
      expect(find.text('Emprendimientos'), findsOneWidget);
      expect(find.text('Rutas y Senderos'), findsOneWidget);
    });
  });
}