import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/data/repository/health_repository_impl.dart';
import 'package:frontend/data/local/health_local_data_source.dart';
import 'package:frontend/data/api/health_api_data_source.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';
import 'package:frontend/domain/core/type/health_data_type.dart';

import 'health_repository_impl_test.mocks.dart';

@GenerateMocks([HealthLocalDataSource, HealthApiDataSource])
void main() {
  group('HealthRepositoryImpl', () {
    late HealthRepositoryImpl repository;
    late MockHealthLocalDataSource mockLocalDataSource;
    late MockHealthApiDataSource mockApiDataSource;

    setUp(() {
      mockLocalDataSource = MockHealthLocalDataSource();
      mockApiDataSource = MockHealthApiDataSource();
      repository = HealthRepositoryImpl(
        localDataSource: mockLocalDataSource,
        apiDataSource: mockApiDataSource,
        useMockData: true,
      );
    });

    tearDown(() {
      repository.dispose();
    });

    group('getStepData', () {
      test('should return local data when available', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);
        final expectedData = [
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 5000,
            distance: 4.0,
            caloriesBurned: 200,
            activityLevel: ActivityLevel.medium,
          ),
        ];

        when(
          mockLocalDataSource.getHealthDataRange(startDate, endDate),
        ).thenAnswer((_) async => expectedData);

        // Act
        final result = await repository.getStepData(
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result, equals(expectedData));
        verify(
          mockLocalDataSource.getHealthDataRange(startDate, endDate),
        ).called(1);
      });

      test(
        'should generate mock data when local data is empty and using mock',
        () async {
          // Arrange
          final startDate = DateTime(2024, 1, 1);
          final endDate = DateTime(2024, 1, 7);

          when(
            mockLocalDataSource.getHealthDataRange(startDate, endDate),
          ).thenAnswer((_) async => []);
          when(
            mockLocalDataSource.saveHealthDataList(any),
          ).thenAnswer((_) async => {});

          // Act
          final result = await repository.getStepData(
            startDate: startDate,
            endDate: endDate,
          );

          // Assert
          expect(result, isNotEmpty);
          verify(
            mockLocalDataSource.getHealthDataRange(startDate, endDate),
          ).called(1);
          verify(mockLocalDataSource.saveHealthDataList(any)).called(1);
        },
      );
    });

    group('getTodayStepData', () {
      test('should return today\'s health data', () async {
        // Arrange
        final today = DateTime.now();
        final expectedData = HealthData(
          date: today,
          stepCount: 8000,
          distance: 6.4,
          caloriesBurned: 320,
          activityLevel: ActivityLevel.high,
        );

        when(
          mockLocalDataSource.getHealthData(any),
        ).thenAnswer((_) async => expectedData);

        // Act
        final result = await repository.getTodayStepData();

        // Assert
        expect(result, equals(expectedData));
        verify(mockLocalDataSource.getHealthData(any)).called(1);
      });
    });

    group('getStepDataForDate', () {
      test('should return health data for specific date', () async {
        // Arrange
        final date = DateTime(2024, 1, 15);
        final expectedData = HealthData(
          date: date,
          stepCount: 7500,
          distance: 6.0,
          caloriesBurned: 300,
          activityLevel: ActivityLevel.high,
        );

        when(
          mockLocalDataSource.getHealthData(date),
        ).thenAnswer((_) async => expectedData);

        // Act
        final result = await repository.getStepDataForDate(date);

        // Assert
        expect(result, equals(expectedData));
        verify(mockLocalDataSource.getHealthData(date)).called(1);
      });

      test('should generate mock data when no local data exists', () async {
        // Arrange
        final date = DateTime(2024, 1, 15);

        when(
          mockLocalDataSource.getHealthData(date),
        ).thenAnswer((_) async => null);
        when(
          mockLocalDataSource.saveHealthData(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.getStepDataForDate(date);

        // Assert
        expect(result, isNotNull);
        expect(result!.date, equals(date));
        verify(mockLocalDataSource.getHealthData(date)).called(1);
        verify(mockLocalDataSource.saveHealthData(any)).called(1);
      });
    });

    group('requestHealthPermission', () {
      test('should return true when using mock data', () async {
        // Act
        final result = await repository.requestHealthPermission();

        // Assert
        expect(result, isTrue);
      });

      test('should call API data source when not using mock data', () async {
        // Arrange
        repository = HealthRepositoryImpl(
          localDataSource: mockLocalDataSource,
          apiDataSource: mockApiDataSource,
          useMockData: false,
        );

        when(
          mockApiDataSource.requestHealthPermission(),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.requestHealthPermission();

        // Assert
        expect(result, isTrue);
        verify(mockApiDataSource.requestHealthPermission()).called(1);
      });
    });

    group('hasHealthPermission', () {
      test('should return true when using mock data', () async {
        // Act
        final result = await repository.hasHealthPermission();

        // Assert
        expect(result, isTrue);
      });

      test('should call API data source when not using mock data', () async {
        // Arrange
        repository = HealthRepositoryImpl(
          localDataSource: mockLocalDataSource,
          apiDataSource: mockApiDataSource,
          useMockData: false,
        );

        when(
          mockApiDataSource.hasHealthPermission(),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.hasHealthPermission();

        // Assert
        expect(result, isFalse);
        verify(mockApiDataSource.hasHealthPermission()).called(1);
      });
    });

    group('syncHealthData', () {
      test('should generate mock data when using mock data', () async {
        // Arrange
        when(
          mockLocalDataSource.saveHealthDataList(any),
        ).thenAnswer((_) async => {});

        // Act
        await repository.syncHealthData();

        // Assert
        verify(mockLocalDataSource.saveHealthDataList(any)).called(1);
      });

      test('should sync with API when not using mock data', () async {
        // Arrange
        repository = HealthRepositoryImpl(
          localDataSource: mockLocalDataSource,
          apiDataSource: mockApiDataSource,
          useMockData: false,
        );

        when(
          mockApiDataSource.hasHealthPermission(),
        ).thenAnswer((_) async => true);
        when(mockApiDataSource.syncHealthData()).thenAnswer((_) async => {});
        when(
          mockApiDataSource.getHealthDataRange(any, any),
        ).thenAnswer((_) async => []);
        when(
          mockLocalDataSource.saveHealthDataList(any),
        ).thenAnswer((_) async => {});

        // Act
        await repository.syncHealthData();

        // Assert
        verify(mockApiDataSource.hasHealthPermission()).called(1);
        verify(mockApiDataSource.syncHealthData()).called(1);
        verify(mockApiDataSource.getHealthDataRange(any, any)).called(1);
      });
    });

    group('clearLocalHealthData', () {
      test('should clear all data when no date range specified', () async {
        // Arrange
        when(
          mockLocalDataSource.clearAllHealthData(),
        ).thenAnswer((_) async => {});

        // Act
        await repository.clearLocalHealthData();

        // Assert
        verify(mockLocalDataSource.clearAllHealthData()).called(1);
      });

      test('should clear data in range when dates specified', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);

        when(
          mockLocalDataSource.deleteHealthDataRange(startDate, endDate),
        ).thenAnswer((_) async => {});

        // Act
        await repository.clearLocalHealthData(
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        verify(
          mockLocalDataSource.deleteHealthDataRange(startDate, endDate),
        ).called(1);
      });
    });

    group('getHealthStatistics', () {
      test('should return mock statistics when using mock data', () async {
        // Act
        final result = await repository.getHealthStatistics(
          period: DateRangeType.thisWeek,
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('totalDays'), isTrue);
        expect(result.containsKey('averageSteps'), isTrue);
        expect(result.containsKey('maxSteps'), isTrue);
        expect(result.containsKey('totalSteps'), isTrue);
      });

      test(
        'should calculate statistics from actual data when not using mock',
        () async {
          // Arrange
          repository = HealthRepositoryImpl(
            localDataSource: mockLocalDataSource,
            apiDataSource: mockApiDataSource,
            useMockData: false,
          );

          final healthDataList = [
            HealthData(
              date: DateTime(2024, 1, 1),
              stepCount: 5000,
              distance: 4.0,
              caloriesBurned: 200,
              activityLevel: ActivityLevel.medium,
            ),
            HealthData(
              date: DateTime(2024, 1, 2),
              stepCount: 7000,
              distance: 5.6,
              caloriesBurned: 280,
              activityLevel: ActivityLevel.high,
            ),
          ];

          when(
            mockLocalDataSource.getHealthDataRange(any, any),
          ).thenAnswer((_) async => healthDataList);

          // Act
          final result = await repository.getHealthStatistics(
            period: DateRangeType.thisWeek,
          );

          // Assert
          expect(result['totalDays'], equals(2));
          expect(result['averageSteps'], equals(6000.0));
          expect(result['maxSteps'], equals(7000));
          expect(result['totalSteps'], equals(12000));
        },
      );
    });

    group('getLastSyncTime', () {
      test('should return a recent sync time', () async {
        // Act
        final result = await repository.getLastSyncTime();

        // Assert
        expect(result, isNotNull);
        expect(result!.isBefore(DateTime.now()), isTrue);
      });
    });
  });
}
