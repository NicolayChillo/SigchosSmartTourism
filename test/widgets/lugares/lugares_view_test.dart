import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sigchos_smart_tourist/presentation/views/lugares/lugares_view.dart';
import 'package:sigchos_smart_tourist/presentation/viewmodels/lugares_viewmodel.dart';
import 'package:sigchos_smart_tourist/domain/repositories/lugares_repository.dart';
import 'package:sigchos_smart_tourist/domain/entities/lugar.dart';

import 'lugares_view_test.mocks.dart';

@GenerateMocks([LugaresRepository])
void main() {
  late MockLugaresRepository mockRepo;

  setUp(() {
    mockRepo = MockLugaresRepository();
  });

  Widget buildTestWidget() {
    return ChangeNotifierProvider<LugaresViewModel>(
      create: (_) => LugaresViewModel(repository: mockRepo),
      child: const MaterialApp(home: LugaresView()),
    );
  }

  Lugar buildLugar(String id, String nombre) {
    return Lugar(
      id: id,
      nombre: nombre,
      tipo: 'cascada',
      descripcion: 'Descripción de prueba',
      fotos: const ['https://example.com/foto.jpg'],
      latitude: -0.7,
      longitude: -78.88,
      geohash: 'abc123',
      promedioCalificacion: 4.2,
      totalCalificaciones: 3,
      creadoPor: 'seed',
      fechaCreacion: DateTime(2026, 1, 1),
    );
  }

  testWidgets('muestra el estado vacío cuando no hay atractivos', (tester) async {
    when(mockRepo.getLugares(tipo: null)).thenAnswer((_) async => []);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Atractivos Turísticos'), findsOneWidget);
    expect(find.text('No hay atractivos'), findsOneWidget);
  });

  testWidgets('muestra la lista de atractivos cuando hay datos', (tester) async {
    when(mockRepo.getLugares(tipo: null)).thenAnswer(
      (_) async => [buildLugar('1', 'Laguna de Quilotoa'), buildLugar('2', 'Cañón del Toachi')],
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Laguna de Quilotoa'), findsOneWidget);
      expect(find.text('Cañón del Toachi'), findsOneWidget);
      expect(find.text('No hay atractivos'), findsNothing);
    });
  });

  testWidgets('al tocar un filtro vuelve a pedir los lugares con ese tipo', (tester) async {
    when(mockRepo.getLugares(tipo: null)).thenAnswer((_) async => []);
    when(mockRepo.getLugares(tipo: 'cascada')).thenAnswer((_) async => []);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cascadas'));
    await tester.pumpAndSettle();

    verify(mockRepo.getLugares(tipo: 'cascada')).called(1);
  });
}
