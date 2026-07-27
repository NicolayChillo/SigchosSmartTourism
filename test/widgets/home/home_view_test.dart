import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sigchos_smart_tourist/presentation/views/home/home_view.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/lugares_viewmodel.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sigchos_smart_tourist/domain/repositories/lugares_repository.dart';
import 'package:sigchos_smart_tourist/domain/repositories/auth_repository.dart';
import 'package:sigchos_smart_tourist/domain/entities/lugar.dart';

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
      ],
      child: const MaterialApp(home: HomeView()),
    );
  }

  testWidgets('debe mostrar el título y las categorías', (tester) async {
    when(mockLugaresRepo.getLugares()).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidget());

    expect(find.text('Sigchos Smart Tourist'), findsOneWidget);
    expect(find.text('Atractivos'), findsOneWidget);
    expect(find.text('Hosterías'), findsOneWidget);
    expect(find.text('Emprendimientos'), findsOneWidget);
    expect(find.text('Rutas'), findsOneWidget);
  });
}