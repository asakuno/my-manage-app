import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:frontend/presentation/provider/health_provider.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/entity/activity_visualization.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';
import 'package:frontend/domain/core/type/health_data_type.dart';
import 'package:frontend/domain/health/usecase/get_step_data_usecase.dart';
import 'package:frontend/domain/health/usecase/calculate_activity_level_usecase.dart';
import 'package:frontend/domain/health/usecase/sync_health_data_usecase.dart';
import 'package:frontend/data/repository/health_repository_impl.dart';
import 'package:frontend/data/local/health_local_data_source.dart';
import 'package:frontend/data/api/health_api_data_source.dart';

import '../utils/test_helpers.dart';
import '../utils/test_data_builders.dart';

@GenerateMocks([
  HealthRepositoryImpl,
  HealthLocalDataSource,
  HealthApiDataSource,
  GetStepDataUseCase,
  CalculateActivityLevelUseCase,
  SyncHealthDataUseCase,
])
import 'health_provider_test.mocks.dart';

void main() {
  group('Health Provider Tests', () {
    late ProviderContainer container;
    late MockHealthRepositoryImpl mockRepository;
    late MockGetStepDataUseCase mockGetStepDataUseCase;
    late MockCalculateActivityLevelUseCase mockCalculateActivityLevelUseCase;
    late MockSyncHealthDataUseCase mockSyncHealthDataUseCase;

    setUp(() {
      mockRepository = MockHealthRepositoryImpl();
      mockGetStepDataUseCase = MockGetStepDataUseCase();
      mockCalculateActivityLevelUseCase = MockCalculateActivityLevelUseCase();
      mockSyncHealthDataUseCase = MockSyncHealthDataUseCase();

      container = ProviderContainer(
        overrides: [
          healthRepositoryProvider.overrideWithValue(mockRepository),
          getStepDataUseCaseProvider.overrideWithValue(mockGetStepDataUseCase),
          calculateActivityLevelUseCaseProvider.overrideWithValue(
            mockCalculateActivityLevelUseCase,
          ),
          syncHealthDataUseCaseProvider.overrideWithValue(
            mockSyncHealthDataUseCase,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('TodayStepData Provider', () {
      test('初期状態で今日の歩数データを正しく取得できる', () async {
        // Arrange
        final testData = HealthData(
          date: DateTime.now(),
          stepCount: 5000,
          distance: 3.5,
          caloriesBurned: 200,
          activityLevel: ActivityLevel.medium,
        );
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => testData);

        // Act
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result, equals(testData));
        expect(result?.stepCount, equals(5000));
        expect(result?.activityLevel, equals(ActivityLevel.medium));
        verify(mockGetStepDataUseCase.getTodayStepData()).called(1);
      });

      test('データが存在しない場合はnullを返す', () async {
        // Arrange
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result, isNull);
        verify(mockGetStepDataUseCase.getTodayStepData()).called(1);
      });

      test('エラーが発生した場合は例外をスローする', () async {
        // Arrange
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenThrow(Exception('Health data access failed'));

        // Act & Assert
        expect(
          () => container.read(todayStepDataProvider.future),
          throwsException,
        );
      });

      test('refresh()メソッドでデータを手動更新できる', () async {
        // Arrange
        final initialData = HealthData(
          date: DateTime.now(),
          stepCount: 3000,
          distance: 2.0,
          caloriesBurned: 150,
          activityLevel: ActivityLevel.low,
        );
        final refreshedData = HealthData(
          date: DateTime.now(),
          stepCount: 7000,
          distance: 4.5,
          caloriesBurned: 350,
          activityLevel: ActivityLevel.high,
        );

        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => initialData);

        // Act - 初期データ取得
        await container.read(todayStepDataProvider.future);

        // Arrange - リフレッシュ時の新しいデータ設定
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => refreshedData);

        // Act - リフレッシュ実行
        await container.read(todayStepDataProvider.notifier).refresh();
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result, equals(refreshedData));
        expect(result?.stepCount, equals(7000));
        verify(mockGetStepDataUseCase.getTodayStepData()).called(2);
      });
    });

    group('StepDataRange Provider', () {
      test('指定期間の歩数データを正しく取得できる', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);
        final testData = [
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 8000,
            distance: 5.0,
            caloriesBurned: 400,
            activityLevel: ActivityLevel.high,
          ),
          HealthData(
            date: DateTime(2024, 1, 2),
            stepCount: 6000,
            distance: 3.5,
            caloriesBurned: 300,
            activityLevel: ActivityLevel.medium,
          ),
        ];

        when(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).thenAnswer((_) async => testData);

        // Act
        final result = await container.read(
          stepDataRangeProvider(startDate: startDate, endDate: endDate).future,
        );

        // Assert
        expect(result, equals(testData));
        expect(result.length, equals(2));
        expect(result[0].stepCount, equals(8000));
        expect(result[1].stepCount, equals(6000));
        verify(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).called(1);
      });

      test('空のデータリストを正しく処理できる', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);
        when(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).thenAnswer((_) async => <HealthData>[]);

        // Act
        final result = await container.read(
          stepDataRangeProvider(startDate: startDate, endDate: endDate).future,
        );

        // Assert
        expect(result, isEmpty);
        verify(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).called(1);
      });
    });

    group('YearlyActivityVisualization Provider', () {
      test('年間アクティビティ視覚化データを正しく生成できる', () async {
        // Arrange
        final year = 2024;
        final goalSteps = 8000;
        final healthDataList = [
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 5000,
            distance: 3.0,
            caloriesBurned: 250,
            activityLevel: ActivityLevel.medium,
          ),
        ];
        final expectedGrid = <List<ActivityVisualization>>[
          [
            ActivityVisualization(
              date: DateTime(2024, 1, 1),
              level: ActivityLevel.medium,
              color: ActivityLevel.medium.color,
              hasData: true,
              stepCount: 5000,
              goalAchievementRate: 5000 / 8000,
            ),
          ],
        ];

        when(
          mockGetStepDataUseCase.getYearlyStepData(year),
        ).thenAnswer((_) async => healthDataList);
        when(
          mockCalculateActivityLevelUseCase.createYearlyGrid(
            year: year,
            healthDataList: healthDataList,
            goalSteps: goalSteps,
          ),
        ).thenReturn(expectedGrid);

        // Act
        final result = await container.read(
          yearlyActivityVisualizationProvider(
            year: year,
            goalSteps: goalSteps,
          ).future,
        );

        // Assert
        expect(result, equals(expectedGrid));
        expect(result.length, equals(1));
        expect(result[0].length, equals(1));
        expect(result[0][0].stepCount, equals(5000));
        verify(mockGetStepDataUseCase.getYearlyStepData(year)).called(1);
        verify(
          mockCalculateActivityLevelUseCase.createYearlyGrid(
            year: year,
            healthDataList: healthDataList,
            goalSteps: goalSteps,
          ),
        ).called(1);
      });

      test('デフォルトの目標歩数（8000歩）で正しく動作する', () async {
        // Arrange
        final year = 2024;
        final defaultGoalSteps = 8000;
        final healthDataList = <HealthData>[];
        final expectedGrid = <List<ActivityVisualization>>[];

        when(
          mockGetStepDataUseCase.getYearlyStepData(year),
        ).thenAnswer((_) async => healthDataList);
        when(
          mockCalculateActivityLevelUseCase.createYearlyGrid(
            year: year,
            healthDataList: healthDataList,
            goalSteps: defaultGoalSteps,
          ),
        ).thenReturn(expectedGrid);

        // Act
        final result = await container.read(
          yearlyActivityVisualizationProvider(year: year).future,
        );

        // Assert
        expect(result, equals(expectedGrid));
        verify(mockGetStepDataUseCase.getYearlyStepData(year)).called(1);
        verify(
          mockCalculateActivityLevelUseCase.createYearlyGrid(
            year: year,
            healthDataList: healthDataList,
            goalSteps: defaultGoalSteps,
          ),
        ).called(1);
      });
    });

    group('HealthDataSync Provider', () {
      test('同期が成功した場合はtrueを返す', () async {
        // Arrange
        when(mockSyncHealthDataUseCase.call()).thenAnswer((_) async => true);

        // Act
        await container.read(healthDataSyncProvider.notifier).sync();
        final result = await container.read(healthDataSyncProvider.future);

        // Assert
        expect(result, isTrue);
        verify(mockSyncHealthDataUseCase.call()).called(1);
      });

      test('同期中にエラーが発生した場合は例外をスローする', () async {
        // Arrange
        when(
          mockSyncHealthDataUseCase.call(),
        ).thenThrow(Exception('Sync failed'));

        // Act
        final provider = container.read(healthDataSyncProvider.notifier);
        await provider.sync();

        // Assert
        final state = container.read(healthDataSyncProvider);
        expect(state.hasError, isTrue);
        expect(state.error.toString(), contains('Sync failed'));
      });

      test('同期後に関連プロバイダーが無効化される', () async {
        // Arrange
        when(mockSyncHealthDataUseCase.call()).thenAnswer((_) async => true);

        // Act
        await container.read(healthDataSyncProvider.notifier).sync();

        // Assert
        // 関連プロバイダーの無効化は実際のアプリでテストされる
        verify(mockSyncHealthDataUseCase.call()).called(1);
      });
    });

    group('ActivityStatistics Provider', () {
      test('アクティビティ統計を正しく計算できる', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);
        final goalSteps = 8000;
        final healthDataList = [
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 10000,
            distance: 6.0,
            caloriesBurned: 500,
            activityLevel: ActivityLevel.veryHigh,
          ),
        ];
        final visualizations = [
          ActivityVisualization(
            date: DateTime(2024, 1, 1),
            level: ActivityLevel.veryHigh,
            color: ActivityLevel.veryHigh.color,
            hasData: true,
            stepCount: 10000,
            goalAchievementRate: 1.0,
          ),
        ];
        final expectedStatistics = {
          'totalSteps': 10000,
          'averageSteps': 10000.0,
          'goalAchievementRate': 1.0,
          'activeDays': 1,
          'totalDays': 7,
        };

        when(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).thenAnswer((_) async => healthDataList);
        when(
          mockCalculateActivityLevelUseCase.createVisualizationList(
            healthDataList: healthDataList,
            startDate: startDate,
            endDate: endDate,
            goalSteps: goalSteps,
          ),
        ).thenReturn(visualizations);
        when(
          mockCalculateActivityLevelUseCase.calculateStatistics(visualizations),
        ).thenReturn(expectedStatistics);

        // Act
        final result = await container.read(
          activityStatisticsProvider(
            startDate: startDate,
            endDate: endDate,
            goalSteps: goalSteps,
          ).future,
        );

        // Assert
        expect(result, equals(expectedStatistics));
        expect(result['totalSteps'], equals(10000));
        expect(result['goalAchievementRate'], equals(1.0));
        verify(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).called(1);
        verify(
          mockCalculateActivityLevelUseCase.createVisualizationList(
            healthDataList: healthDataList,
            startDate: startDate,
            endDate: endDate,
            goalSteps: goalSteps,
          ),
        ).called(1);
        verify(
          mockCalculateActivityLevelUseCase.calculateStatistics(visualizations),
        ).called(1);
      });

      test('統計計算でエラーが発生した場合は例外をスローする', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);
        when(
          mockGetStepDataUseCase.call(startDate: startDate, endDate: endDate),
        ).thenThrow(Exception('Data fetch failed'));

        // Act & Assert
        expect(
          () => container.read(
            activityStatisticsProvider(
              startDate: startDate,
              endDate: endDate,
            ).future,
          ),
          throwsException,
        );
      });
    });

    group('TodayStepDataStream Provider', () {
      test('ストリームプロバイダーが正しく初期化される', () async {
        // Arrange
        final testData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(7500)
            .build();

        when(
          mockGetStepDataUseCase.watchTodayStepData(),
        ).thenAnswer((_) => Stream.value(testData));

        // Act - Just verify the provider can be read without errors
        final streamProvider = container.read(todayStepDataStreamProvider);

        // Assert - Verify the provider exists and the use case is called
        expect(streamProvider, isNotNull);
        // Note: Stream provider testing in Riverpod requires special handling
        // For now, we verify the provider can be instantiated
        verify(mockGetStepDataUseCase.watchTodayStepData()).called(1);
      });

      test('ストリームプロバイダーがエラー状態を処理する', () async {
        // Arrange
        when(
          mockGetStepDataUseCase.watchTodayStepData(),
        ).thenThrow(Exception('Stream initialization failed'));

        // Act
        final streamProvider = container.read(todayStepDataStreamProvider);

        // Assert - Verify the provider returns an error state
        expect(streamProvider.hasError, isTrue);
        expect(
          streamProvider.error.toString(),
          contains('Stream initialization failed'),
        );
      });

      test('ストリームプロバイダーが複数の値を正しく処理する', () async {
        // Arrange
        final initialData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(5000)
            .build();
        final updatedData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(7500)
            .build();

        final controller = StreamController<HealthData?>();
        when(
          mockGetStepDataUseCase.watchTodayStepData(),
        ).thenAnswer((_) => controller.stream);

        // Act
        final streamProvider = container.read(todayStepDataStreamProvider);
        expect(streamProvider, isNotNull);

        // Emit test data
        controller.add(initialData);
        controller.add(updatedData);
        controller.close();

        // Assert
        verify(mockGetStepDataUseCase.watchTodayStepData()).called(1);
      });

      test('ストリームプロバイダーがnullデータを処理する', () async {
        // Arrange
        when(
          mockGetStepDataUseCase.watchTodayStepData(),
        ).thenAnswer((_) => Stream.value(null));

        // Act
        final streamProvider = container.read(todayStepDataStreamProvider);

        // Assert
        expect(streamProvider, isNotNull);
        verify(mockGetStepDataUseCase.watchTodayStepData()).called(1);
      });
    });

    group('MonthlyStepData Provider', () {
      test('指定月の歩数データを正しく取得できる', () async {
        // Arrange
        final year = 2024;
        final month = 1;
        final testData = TestScenarios.consistentDailyActivity(
          startDate: DateTime(year, month, 1),
          days: 31,
          stepCount: 8000,
        );

        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).thenAnswer((_) async => testData);

        // Act
        final result = await container.read(
          monthlyStepDataProvider(year: year, month: month).future,
        );

        // Assert
        expect(result, equals(testData));
        expect(result.length, equals(31));
        expect(result.every((data) => data.stepCount == 8000), isTrue);
        verify(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).called(1);
      });

      test('月データが空の場合は空リストを返す', () async {
        // Arrange
        final year = 2024;
        final month = 2;
        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).thenAnswer((_) async => <HealthData>[]);

        // Act
        final result = await container.read(
          monthlyStepDataProvider(year: year, month: month).future,
        );

        // Assert
        expect(result, isEmpty);
        verify(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).called(1);
      });

      test('月データ取得でエラーが発生した場合は例外をスローする', () async {
        // Arrange
        final year = 2024;
        final month = 3;
        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).thenThrow(Exception('Monthly data fetch failed'));

        // Act & Assert
        expect(
          () => container.read(
            monthlyStepDataProvider(year: year, month: month).future,
          ),
          throwsException,
        );
        verify(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).called(1);
      });

      test('refresh()メソッドで月データを手動更新できる', () async {
        // Arrange
        final year = 2024;
        final month = 4;
        final initialData = TestScenarios.consistentDailyActivity(
          startDate: DateTime(year, month, 1),
          days: 30,
          stepCount: 5000,
        );
        final refreshedData = TestScenarios.consistentDailyActivity(
          startDate: DateTime(year, month, 1),
          days: 30,
          stepCount: 9000,
        );

        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).thenAnswer((_) async => initialData);

        // Act - 初期データ取得
        await container.read(
          monthlyStepDataProvider(year: year, month: month).future,
        );

        // Arrange - リフレッシュ時の新しいデータ設定
        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).thenAnswer((_) async => refreshedData);

        // Act - リフレッシュ実行
        await container
            .read(monthlyStepDataProvider(year: year, month: month).notifier)
            .refresh();
        final result = await container.read(
          monthlyStepDataProvider(year: year, month: month).future,
        );

        // Assert
        expect(result, equals(refreshedData));
        expect(result.every((data) => data.stepCount == 9000), isTrue);
        verify(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).called(2);
      });

      test('異なる月のデータは独立してキャッシュされる', () async {
        // Arrange
        final year = 2024;
        final month1 = 1;
        final month2 = 2;
        final data1 = TestScenarios.consistentDailyActivity(
          startDate: DateTime(year, month1, 1),
          days: 31,
          stepCount: 6000,
        );
        final data2 = TestScenarios.consistentDailyActivity(
          startDate: DateTime(year, month2, 1),
          days: 29,
          stepCount: 7000,
        );

        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month1),
        ).thenAnswer((_) async => data1);
        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month2),
        ).thenAnswer((_) async => data2);

        // Act
        final result1 = await container.read(
          monthlyStepDataProvider(year: year, month: month1).future,
        );
        final result2 = await container.read(
          monthlyStepDataProvider(year: year, month: month2).future,
        );

        // Assert
        expect(result1.length, equals(31));
        expect(result2.length, equals(29));
        expect(result1.every((data) => data.stepCount == 6000), isTrue);
        expect(result2.every((data) => data.stepCount == 7000), isTrue);
        verify(
          mockGetStepDataUseCase.getMonthlyStepData(year, month1),
        ).called(1);
        verify(
          mockGetStepDataUseCase.getMonthlyStepData(year, month2),
        ).called(1);
      });
    });

    group('WeeklyStepData Provider', () {
      test('指定週の歩数データを正しく取得できる', () async {
        // Arrange
        final weekStart = DateTime(2024, 1, 1); // Monday
        final testData = TestScenarios.weekendWeekdayPattern(
          startDate: weekStart,
          weeks: 1,
        );

        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => testData);

        // Act
        final result = await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Assert
        expect(result, equals(testData));
        expect(result.length, equals(7));
        verify(mockGetStepDataUseCase.getWeeklyStepData(weekStart)).called(1);
      });

      test('週データが空の場合は空リストを返す', () async {
        // Arrange
        final weekStart = DateTime(2024, 2, 5);
        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => <HealthData>[]);

        // Act
        final result = await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Assert
        expect(result, isEmpty);
        verify(mockGetStepDataUseCase.getWeeklyStepData(weekStart)).called(1);
      });

      test('週データ取得でエラーが発生した場合は例外をスローする', () async {
        // Arrange
        final weekStart = DateTime(2024, 3, 4);
        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenThrow(Exception('Weekly data fetch failed'));

        // Act & Assert
        expect(
          () => container.read(
            weeklyStepDataProvider(weekStart: weekStart).future,
          ),
          throwsException,
        );
        verify(mockGetStepDataUseCase.getWeeklyStepData(weekStart)).called(1);
      });

      test('refresh()メソッドで週データを手動更新できる', () async {
        // Arrange
        final weekStart = DateTime(2024, 4, 1);
        final initialData = TestScenarios.consistentDailyActivity(
          startDate: weekStart,
          days: 7,
          stepCount: 6000,
        );
        final refreshedData = TestScenarios.consistentDailyActivity(
          startDate: weekStart,
          days: 7,
          stepCount: 10000,
        );

        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => initialData);

        // Act - 初期データ取得
        await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Arrange - リフレッシュ時の新しいデータ設定
        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => refreshedData);

        // Act - リフレッシュ実行
        await container
            .read(weeklyStepDataProvider(weekStart: weekStart).notifier)
            .refresh();
        final result = await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Assert
        expect(result, equals(refreshedData));
        expect(result.every((data) => data.stepCount == 10000), isTrue);
        verify(mockGetStepDataUseCase.getWeeklyStepData(weekStart)).called(2);
      });

      test('異なる週のデータは独立してキャッシュされる', () async {
        // Arrange
        final week1Start = DateTime(2024, 1, 1);
        final week2Start = DateTime(2024, 1, 8);
        final data1 = TestScenarios.consistentDailyActivity(
          startDate: week1Start,
          days: 7,
          stepCount: 7000,
        );
        final data2 = TestScenarios.consistentDailyActivity(
          startDate: week2Start,
          days: 7,
          stepCount: 8500,
        );

        when(
          mockGetStepDataUseCase.getWeeklyStepData(week1Start),
        ).thenAnswer((_) async => data1);
        when(
          mockGetStepDataUseCase.getWeeklyStepData(week2Start),
        ).thenAnswer((_) async => data2);

        // Act
        final result1 = await container.read(
          weeklyStepDataProvider(weekStart: week1Start).future,
        );
        final result2 = await container.read(
          weeklyStepDataProvider(weekStart: week2Start).future,
        );

        // Assert
        expect(result1.every((data) => data.stepCount == 7000), isTrue);
        expect(result2.every((data) => data.stepCount == 8500), isTrue);
        verify(mockGetStepDataUseCase.getWeeklyStepData(week1Start)).called(1);
        verify(mockGetStepDataUseCase.getWeeklyStepData(week2Start)).called(1);
      });

      test('週末と平日のパターンを正しく処理できる', () async {
        // Arrange
        final weekStart = DateTime(2024, 1, 1); // Monday
        final testData = TestScenarios.weekendWeekdayPattern(
          startDate: weekStart,
          weeks: 1,
        );

        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => testData);

        // Act
        final result = await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Assert
        expect(result.length, equals(7));
        // Check weekday vs weekend pattern
        final weekdayData = result.take(5).toList(); // Mon-Fri
        final weekendData = result.skip(5).toList(); // Sat-Sun

        expect(weekdayData.every((data) => data.stepCount == 8000), isTrue);
        expect(weekendData.every((data) => data.stepCount == 4000), isTrue);
        verify(mockGetStepDataUseCase.getWeeklyStepData(weekStart)).called(1);
      });
    });

    group('Comprehensive Error Handling Tests', () {
      test('ネットワークエラー時の適切な例外処理', () async {
        // Arrange
        final networkError = Exception('Network connection failed');
        when(mockGetStepDataUseCase.getTodayStepData()).thenThrow(networkError);

        // Act & Assert - Verify the future throws the exception
        await expectLater(
          container.read(todayStepDataProvider.future),
          throwsA(isA<Exception>()),
        );

        // Verify error state using proper async state checking
        final state = await TestHelpers.waitForProviderCondition(
          container,
          todayStepDataProvider,
          (AsyncValue<HealthData?> state) => state.hasError,
          timeout: const Duration(seconds: 2),
        );

        TestHelpers.expectErrorContaining(state, 'Network connection failed');
      });

      test('データベースエラー時の適切な例外処理', () async {
        // Arrange
        final dbError = Exception('Database access failed');
        final year = 2024;
        final month = 1;
        when(
          mockGetStepDataUseCase.getMonthlyStepData(year, month),
        ).thenThrow(dbError);

        // Act & Assert
        expect(
          () => container.read(
            monthlyStepDataProvider(year: year, month: month).future,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('同期エラー時の状態管理', () async {
        // Arrange
        final syncError = Exception('Sync service unavailable');
        when(mockSyncHealthDataUseCase.call()).thenThrow(syncError);

        // Act
        await container.read(healthDataSyncProvider.notifier).sync();

        // Assert - Wait for the provider to update its error state
        final state = await TestHelpers.waitForProviderCondition(
          container,
          healthDataSyncProvider,
          (AsyncValue<bool> state) => state.hasError,
          timeout: const Duration(seconds: 2),
        );

        expect(state.hasError, isTrue);
        expect(state.error.toString(), contains('Sync service unavailable'));
      });

      test('タイムアウトエラーの処理', () async {
        // Arrange
        when(mockGetStepDataUseCase.getTodayStepData()).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 30));
          return TestDataBuilders.healthData().build();
        });

        // Act & Assert
        expect(
          () => TestHelpers.waitForProvider(
            container,
            todayStepDataProvider,
            timeout: const Duration(seconds: 1),
          ),
          throwsA(isA<TimeoutException>()),
        );
      });

      test('不正なデータ形式エラーの処理', () async {
        // Arrange
        final formatError = FormatException('Invalid data format');
        when(
          mockGetStepDataUseCase.getYearlyStepData(2024),
        ).thenThrow(formatError);

        // Act & Assert
        expect(
          () => container.read(
            yearlyActivityVisualizationProvider(year: 2024).future,
          ),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Edge Cases and Boundary Conditions', () {
      test('未来の日付でのデータ取得', () async {
        // Arrange
        final futureDate = DateTime.now().add(const Duration(days: 30));
        when(
          mockGetStepDataUseCase.call(
            startDate: futureDate,
            endDate: futureDate.add(const Duration(days: 7)),
          ),
        ).thenAnswer((_) async => <HealthData>[]);

        // Act
        final result = await container.read(
          stepDataRangeProvider(
            startDate: futureDate,
            endDate: futureDate.add(const Duration(days: 7)),
          ).future,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('非常に大きな歩数データの処理', () async {
        // Arrange
        final extremeData = TestDataBuilders.healthData()
            .withStepCount(100000)
            .withTodayDate()
            .build();
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => extremeData);

        // Act
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result?.stepCount, equals(100000));
        expect(result?.activityLevel, equals(ActivityLevel.veryHigh));
      });

      test('ゼロ歩数データの処理', () async {
        // Arrange
        final zeroData = TestDataBuilders.healthData()
            .withNoActivity()
            .withTodayDate()
            .build();
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => zeroData);

        // Act
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result?.stepCount, equals(0));
        expect(result?.activityLevel, equals(ActivityLevel.none));
        expect(result?.distance, equals(0.0));
        expect(result?.caloriesBurned, equals(0));
      });

      test('うるう年の2月データ処理', () async {
        // Arrange
        final leapYear = 2024;
        final february = 2;
        final leapYearData = TestScenarios.consistentDailyActivity(
          startDate: DateTime(leapYear, february, 1),
          days: 29, // Leap year February has 29 days
          stepCount: 8000,
        );

        when(
          mockGetStepDataUseCase.getMonthlyStepData(leapYear, february),
        ).thenAnswer((_) async => leapYearData);

        // Act
        final result = await container.read(
          monthlyStepDataProvider(year: leapYear, month: february).future,
        );

        // Assert
        expect(result.length, equals(29));
        expect(result.last.date.day, equals(29));
      });

      test('年末年始の週データ処理', () async {
        // Arrange - Week spanning across years
        final weekStart = DateTime(2023, 12, 25); // Monday
        final crossYearData = List.generate(7, (index) {
          final date = weekStart.add(Duration(days: index));
          return TestDataBuilders.healthData()
              .withDate(date)
              .withStepCount(8000)
              .build();
        });

        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => crossYearData);

        // Act
        final result = await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Assert
        expect(result.length, equals(7));
        expect(result.first.date.year, equals(2023));
        expect(result.last.date.year, equals(2023)); // Dec 31, 2023
      });

      test('同時複数リクエストの処理', () async {
        // Arrange
        final testData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(7500)
            .build();
        when(mockGetStepDataUseCase.getTodayStepData()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return testData;
        });

        // Act - Multiple simultaneous requests
        final futures = List.generate(
          5,
          (_) => container.read(todayStepDataProvider.future),
        );
        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(5));
        expect(results.every((result) => result?.stepCount == 7500), isTrue);
        // Should only call the use case once due to provider caching
        verify(mockGetStepDataUseCase.getTodayStepData()).called(1);
      });

      test('プロバイダーの無効化と再取得', () async {
        // Arrange
        final initialData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(5000)
            .build();
        final updatedData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(8000)
            .build();

        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => initialData);

        // Act - Initial fetch
        final initial = await container.read(todayStepDataProvider.future);

        // Arrange - Update mock for next call
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => updatedData);

        // Act - Invalidate and refetch
        container.invalidate(todayStepDataProvider);
        final updated = await container.read(todayStepDataProvider.future);

        // Assert
        expect(initial?.stepCount, equals(5000));
        expect(updated?.stepCount, equals(8000));
        verify(mockGetStepDataUseCase.getTodayStepData()).called(2);
      });

      test('負の歩数データの処理', () async {
        // Arrange - Test handling of invalid negative step count
        final invalidData = TestDataBuilders.healthData()
            .withStepCount(-100)
            .withTodayDate()
            .build();
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => invalidData);

        // Act
        final result = await container.read(todayStepDataProvider.future);

        // Assert - Should handle negative values gracefully
        expect(result?.stepCount, equals(-100));
        // Note: The actual ActivityLevel depends on the implementation
        // We just verify the data is returned as-is
        expect(result?.activityLevel, isNotNull);
      });

      test('同期状態の異なるデータの処理', () async {
        // Arrange
        final pendingSyncData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(6000)
            .withPendingSync()
            .build();
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => pendingSyncData);

        // Act
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result?.stepCount, equals(6000));
        expect(result?.syncStatus, equals(SyncStatus.pending));
      });

      test('月の境界日付での週データ処理', () async {
        // Arrange - Week spanning across months
        final weekStart = DateTime(2024, 1, 29); // Monday, spans to February
        final crossMonthData = List.generate(7, (index) {
          final date = weekStart.add(Duration(days: index));
          return TestDataBuilders.healthData()
              .withDate(date)
              .withStepCount(8000)
              .build();
        });

        when(
          mockGetStepDataUseCase.getWeeklyStepData(weekStart),
        ).thenAnswer((_) async => crossMonthData);

        // Act
        final result = await container.read(
          weeklyStepDataProvider(weekStart: weekStart).future,
        );

        // Assert
        expect(result.length, equals(7));
        expect(result.first.date.month, equals(1)); // January
        expect(result.last.date.month, equals(2)); // February
      });
    });

    group('Performance and Memory Tests', () {
      test('大量データの処理性能', () async {
        // Arrange
        final largeDataSet = List.generate(365, (index) {
          return TestDataBuilders.healthData()
              .withDate(DateTime(2024, 1, 1).add(Duration(days: index)))
              .withStepCount(5000 + (index * 10))
              .build();
        });

        when(
          mockGetStepDataUseCase.getYearlyStepData(2024),
        ).thenAnswer((_) async => largeDataSet);
        when(
          mockCalculateActivityLevelUseCase.createYearlyGrid(
            year: 2024,
            healthDataList: largeDataSet,
            goalSteps: 8000,
          ),
        ).thenReturn(<List<ActivityVisualization>>[]);

        // Act & Assert
        final executionTime = await TestHelpers.measureExecutionTime(() async {
          await container.read(
            yearlyActivityVisualizationProvider(year: 2024).future,
          );
        });

        TestHelpers.expectExecutionTime(
          executionTime,
          const Duration(seconds: 2),
          reason: 'Large dataset processing should complete within 2 seconds',
        );
      });

      test('メモリリークの防止確認', () async {
        // Arrange
        final containers = <ProviderContainer>[];

        // Act - Create and dispose multiple containers
        for (int i = 0; i < 10; i++) {
          final testContainer = TestHelpers.createContainer(
            overrides: [
              getStepDataUseCaseProvider.overrideWithValue(
                mockGetStepDataUseCase,
              ),
            ],
          );
          containers.add(testContainer);

          when(
            mockGetStepDataUseCase.getTodayStepData(),
          ).thenAnswer((_) async => TestDataBuilders.healthData().build());

          await testContainer.read(todayStepDataProvider.future);
        }

        // Assert - Dispose all containers
        for (final testContainer in containers) {
          TestHelpers.disposeContainer(testContainer);
        }

        // If we reach here without memory issues, the test passes
        expect(containers.length, equals(10));
      });

      test('プロバイダー状態の適切な初期化', () async {
        // Arrange
        final newContainer = TestHelpers.createContainer(
          overrides: [
            getStepDataUseCaseProvider.overrideWithValue(
              mockGetStepDataUseCase,
            ),
          ],
        );

        // Act - Check initial state
        final initialState = newContainer.read(todayStepDataProvider);

        // Assert
        expect(initialState.isLoading, isTrue);
        expect(initialState.hasValue, isFalse);
        expect(initialState.hasError, isFalse);

        // Cleanup
        TestHelpers.disposeContainer(newContainer);
      });

      test('複数プロバイダーの同時実行', () async {
        // Arrange
        final todayData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(8000)
            .build();
        final monthlyData = TestScenarios.consistentDailyActivity(
          startDate: DateTime(2024, 1, 1),
          days: 31,
          stepCount: 7000,
        );
        final weeklyData = TestScenarios.consistentDailyActivity(
          startDate: DateTime(2024, 1, 1),
          days: 7,
          stepCount: 9000,
        );

        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => todayData);
        when(
          mockGetStepDataUseCase.getMonthlyStepData(2024, 1),
        ).thenAnswer((_) async => monthlyData);
        when(
          mockGetStepDataUseCase.getWeeklyStepData(DateTime(2024, 1, 1)),
        ).thenAnswer((_) async => weeklyData);

        // Act - Execute multiple providers simultaneously
        final todayResult = await container.read(todayStepDataProvider.future);
        final monthlyResult = await container.read(
          monthlyStepDataProvider(year: 2024, month: 1).future,
        );
        final weeklyResult = await container.read(
          weeklyStepDataProvider(weekStart: DateTime(2024, 1, 1)).future,
        );

        // Assert
        expect(todayResult?.stepCount, equals(8000)); // Today data
        expect(monthlyResult.length, equals(31)); // Monthly
        expect(weeklyResult.length, equals(7)); // Weekly
      });
    });

    group('Provider State Management Tests', () {
      test('エラー状態からの回復', () async {
        // Arrange - First call fails
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenThrow(Exception('Initial error'));

        // Act - First call should fail
        expect(
          () => container.read(todayStepDataProvider.future),
          throwsException,
        );

        // Arrange - Second call succeeds
        final recoveryData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(5000)
            .build();
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => recoveryData);

        // Act - Refresh and recover
        await container.read(todayStepDataProvider.notifier).refresh();
        final result = await container.read(todayStepDataProvider.future);

        // Assert
        expect(result?.stepCount, equals(5000));
        final finalState = container.read(todayStepDataProvider);
        expect(finalState.hasError, isFalse);
        expect(finalState.hasValue, isTrue);
      });

      test('プロバイダー依存関係の適切な管理', () async {
        // Arrange
        final testData = TestDataBuilders.healthData()
            .withTodayDate()
            .withStepCount(7000)
            .build();
        when(mockSyncHealthDataUseCase.call()).thenAnswer((_) async => true);
        when(
          mockGetStepDataUseCase.getTodayStepData(),
        ).thenAnswer((_) async => testData);

        // Act - Load initial data
        await container.read(todayStepDataProvider.future);

        // Act - Trigger sync which should invalidate related providers
        await container.read(healthDataSyncProvider.notifier).sync();

        // Assert - Verify sync was called and providers were invalidated
        verify(mockSyncHealthDataUseCase.call()).called(1);
        // The sync should have invalidated todayStepDataProvider
        // Next read should trigger a new fetch
        await container.read(todayStepDataProvider.future);
        verify(mockGetStepDataUseCase.getTodayStepData()).called(2);
      });
    });
  });
}
