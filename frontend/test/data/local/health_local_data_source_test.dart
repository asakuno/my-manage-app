import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/local/health_local_data_source.dart';
import 'package:frontend/data/local/model/health_data_model.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';
import 'package:frontend/domain/core/type/health_data_type.dart';
import 'package:hive/hive.dart';

void main() {
  group('HealthLocalDataSource', () {
    late HealthLocalDataSource dataSource;

    setUp(() async {
      // Hiveのテスト用初期化（メモリ内で実行）
      Hive.init('test');

      // アダプターの登録
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HealthDataModelAdapter());
      }

      dataSource = HealthLocalDataSource();
      await dataSource.initializeForTest();
      
      // テスト開始前にデータをクリア
      await dataSource.clearAllHealthData();
    });

    tearDown(() async {
      try {
        await dataSource.close();
        await Hive.deleteFromDisk();
      } catch (e) {
        // テスト環境でのエラーを無視
      }
    });

    group('saveHealthData', () {
      test('should save health data successfully', () async {
        // Arrange
        final healthData = HealthData(
          date: DateTime(2024, 1, 15),
          stepCount: 8500,
          distance: 6.8,
          caloriesBurned: 340,
          activityLevel: ActivityLevel.high,
          activeTime: 85,
          syncStatus: SyncStatus.synced,
        );

        // Act
        await dataSource.saveHealthData(healthData);

        // Assert
        final savedData = await dataSource.getHealthData(DateTime(2024, 1, 15));
        expect(savedData, isNotNull);
        expect(savedData!.stepCount, equals(8500));
        expect(savedData.distance, equals(6.8));
        expect(savedData.caloriesBurned, equals(340));
        expect(savedData.activityLevel, equals(ActivityLevel.high));
      });
    });

    group('getHealthData', () {
      test('should return null when no data exists for date', () async {
        // Act
        final result = await dataSource.getHealthData(DateTime(2024, 1, 15));

        // Assert
        expect(result, isNull);
      });

      test('should return health data when data exists for date', () async {
        // Arrange
        final healthData = HealthData(
          date: DateTime(2024, 1, 15),
          stepCount: 5000,
          distance: 4.0,
          caloriesBurned: 200,
          activityLevel: ActivityLevel.medium,
        );
        await dataSource.saveHealthData(healthData);

        // Act
        final result = await dataSource.getHealthData(DateTime(2024, 1, 15));

        // Assert
        expect(result, isNotNull);
        expect(result!.stepCount, equals(5000));
        expect(result.distance, equals(4.0));
      });
    });

    group('getHealthDataRange', () {
      test('should return empty list when no data in range', () async {
        // Act
        final result = await dataSource.getHealthDataRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 7),
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should return health data in date range', () async {
        // Arrange
        final healthData1 = HealthData(
          date: DateTime(2024, 1, 1),
          stepCount: 5000,
          distance: 4.0,
          caloriesBurned: 200,
          activityLevel: ActivityLevel.medium,
        );
        final healthData2 = HealthData(
          date: DateTime(2024, 1, 3),
          stepCount: 7000,
          distance: 5.6,
          caloriesBurned: 280,
          activityLevel: ActivityLevel.high,
        );

        await dataSource.saveHealthData(healthData1);
        await dataSource.saveHealthData(healthData2);

        // Act
        final result = await dataSource.getHealthDataRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 7),
        );

        // Assert
        expect(result, hasLength(2));
        expect(result[0].stepCount, equals(5000));
        expect(result[1].stepCount, equals(7000));
      });
    });

    group('saveHealthDataList', () {
      test('should save multiple health data entries', () async {
        // Arrange
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
            stepCount: 6000,
            distance: 4.8,
            caloriesBurned: 240,
            activityLevel: ActivityLevel.medium,
          ),
        ];

        // Act
        await dataSource.saveHealthDataList(healthDataList);

        // Assert
        final result = await dataSource.getHealthDataRange(
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 2),
        );
        expect(result, hasLength(2));
      });
    });

    group('deleteHealthData', () {
      test('should delete health data for specific date', () async {
        // Arrange
        final healthData = HealthData(
          date: DateTime(2024, 1, 15),
          stepCount: 5000,
          distance: 4.0,
          caloriesBurned: 200,
          activityLevel: ActivityLevel.medium,
        );
        await dataSource.saveHealthData(healthData);

        // Act
        await dataSource.deleteHealthData(DateTime(2024, 1, 15));

        // Assert
        final result = await dataSource.getHealthData(DateTime(2024, 1, 15));
        expect(result, isNull);
      });
    });

    group('clearAllHealthData', () {
      test('should clear all health data', () async {
        // Arrange
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
            stepCount: 6000,
            distance: 4.8,
            caloriesBurned: 240,
            activityLevel: ActivityLevel.medium,
          ),
        ];
        await dataSource.saveHealthDataList(healthDataList);

        // Act
        await dataSource.clearAllHealthData();

        // Assert
        expect(dataSource.dataCount, equals(0));
      });
    });

    group('hasData', () {
      test('should return false when no data exists', () {
        // Act
        final result = dataSource.hasData(DateTime(2024, 1, 15));

        // Assert
        expect(result, isFalse);
      });

      test('should return true when data exists', () async {
        // Arrange
        final healthData = HealthData(
          date: DateTime(2024, 1, 15),
          stepCount: 5000,
          distance: 4.0,
          caloriesBurned: 200,
          activityLevel: ActivityLevel.medium,
        );
        await dataSource.saveHealthData(healthData);

        // Act
        final result = dataSource.hasData(DateTime(2024, 1, 15));

        // Assert
        expect(result, isTrue);
      });
    });

    group('getStatistics', () {
      test('should return empty statistics when no data', () async {
        // Act
        final result = await dataSource.getStatistics();

        // Assert
        expect(result['totalDays'], equals(0));
        expect(result['averageSteps'], equals(0.0));
        expect(result['maxSteps'], equals(0));
        expect(result['totalSteps'], equals(0));
      });

      test('should calculate statistics correctly', () async {
        // Arrange
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
          HealthData(
            date: DateTime(2024, 1, 3),
            stepCount: 6000,
            distance: 4.8,
            caloriesBurned: 240,
            activityLevel: ActivityLevel.medium,
          ),
        ];
        await dataSource.saveHealthDataList(healthDataList);

        // Act
        final result = await dataSource.getStatistics();

        // Assert
        expect(result['totalDays'], equals(3));
        expect(result['averageSteps'], equals(6000.0));
        expect(result['maxSteps'], equals(7000));
        expect(result['totalSteps'], equals(18000));
      });
    });
  });
}
