import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sigchos_smart_tourist/data/datasources/remote/firestore_lugares_datasource.dart';
import 'package:sigchos_smart_tourist/data/datasources/local/local_lugares_datasource.dart';
import 'package:sigchos_smart_tourist/core/network/network_info.dart';
import 'package:sigchos_smart_tourist/data/repositories/lugares_repository_impl.dart';
import 'package:sigchos_smart_tourist/domain/entities/lugar.dart';
import 'package:sigchos_smart_tourist/core/errors/failures.dart';
import 'package:sigchos_smart_tourist/data/models/lugar_model.dart';

import 'lugares_repository_test.mocks.dart';

@GenerateMocks([
  FirestoreLugaresDataSource,
  LocalLugaresDataSource,
  NetworkInfo,
])
void main() {
  late LugaresRepositoryImpl repository;
  late MockFirestoreLugaresDataSource mockRemote;
  late MockLocalLugaresDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemote = MockFirestoreLugaresDataSource();
    mockLocal = MockLocalLugaresDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LugaresRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  // Datos de ejemplo: Modelo (lo que devuelve el datasource remoto)
  final testLugarModel = LugarModel(
    id: '1',
    nombre: 'Cascada de Sigchos',
    tipo: 'cascada',
    descripcion: 'Hermosa cascada',
    fotos: ['foto1.jpg'],
    latitude: -0.7000,
    longitude: -78.8833,
    geohash: 'abc123',
    promedioCalificacion: 4.5,
    totalCalificaciones: 10,
    creadoPor: 'admin',
    fechaCreacion: DateTime.now(),
  );

  // Entidad esperada después del mapeo (para comparar resultados)
  final testLugarEntity = Lugar(
    id: testLugarModel.id,
    nombre: testLugarModel.nombre,
    tipo: testLugarModel.tipo,
    descripcion: testLugarModel.descripcion,
    fotos: testLugarModel.fotos,
    latitude: testLugarModel.latitude,
    longitude: testLugarModel.longitude,
    geohash: testLugarModel.geohash,
    promedioCalificacion: testLugarModel.promedioCalificacion,
    totalCalificaciones: testLugarModel.totalCalificaciones,
    creadoPor: testLugarModel.creadoPor,
    fechaCreacion: testLugarModel.fechaCreacion,
  );

  group('getLugares', () {
    test('debe retornar datos remotos cuando hay conexión y actualizar caché', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getLugares(tipo: null))
          .thenAnswer((_) async => [testLugarModel]);

      // Act
      final result = await repository.getLugares();

      // Assert: el resultado debe ser una lista de entidades (se mapea internamente)
      expect(result, [testLugarEntity]);
      verify(mockRemote.getLugares(tipo: null)).called(1);
      // Verificar que cacheLugares recibe el modelo (no la entidad)
      verify(mockLocal.cacheLugares([testLugarModel])).called(1);
      verifyNever(mockLocal.getCachedLugares());
    });

    test('debe retornar datos locales cuando NO hay conexión', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // cache local devuelve modelos, el repositorio los mapea a entidades
      when(mockLocal.getCachedLugares())
          .thenAnswer((_) async => [testLugarModel]);

      // Act
      final result = await repository.getLugares();

      // Assert
      expect(result, [testLugarEntity]);
      verifyNever(mockRemote.getLugares(tipo: anyNamed('tipo')));
      verify(mockLocal.getCachedLugares()).called(1);
    });

    test('debe lanzar ConnectionFailure si no hay conexión ni datos en caché', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedLugares()).thenAnswer((_) async => []);

      // Act & Assert
      expect(
            () => repository.getLugares(),
        throwsA(isA<ConnectionFailure>()),
      );
    });

    test('debe retornar datos locales si la fuente remota falla', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getLugares(tipo: null)).thenThrow(Exception('Error remoto'));
      when(mockLocal.getCachedLugares()).thenAnswer((_) async => [testLugarModel]);

      // Act
      final result = await repository.getLugares();

      // Assert
      expect(result, [testLugarEntity]);
      verify(mockLocal.getCachedLugares()).called(1);
      // Además, verificar que no se llamó a cacheLugares (porque la remota falló)
      verifyNever(mockLocal.cacheLugares(any));
    });
  });
}