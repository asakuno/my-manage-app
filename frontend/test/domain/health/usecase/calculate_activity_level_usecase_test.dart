import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/health/usecase/calculate_activity_level_usecase.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/entity/activity_visualization.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';

void main() {
  group('CalculateActivityLevelUseCase', () {
    late CalculateActivityLevelUseCase useCase;

    setUp(() {
      useCase = const CalculateActivityLevelUseCase();
    });

    group('calculateLevel', () {
      test(
        'should calculate correct activity level based on step count and goal',
        () {
          const goalSteps = 8000;

          expect(
            useCase.calculateLevel(0, goalSteps: goalSteps),
            equals(ActivityLevel.none),
          );
          expect(
            useCase.calculateLevel(1600, goalSteps: goalSteps),
            equals(ActivityLevel.low),
          ); // 20%
          expect(
            useCase.calculateLevel(4000, goalSteps: goalSteps),
            equals(ActivityLevel.medium),
          ); // 50%
          expect(
            useCase.calculateLevel(6400, goalSteps: goalSteps),
            equals(ActivityLevel.high),
          ); // 80%
          expect(
            useCase.calculateLevel(8000, goalSteps: goalSteps),
            equals(ActivityLevel.high),
          ); // 100%
          expect(
            useCase.calculateLevel(9600, goalSteps: goalSteps),
            equals(ActivityLevel.veryHigh),
          ); // 120%
        },
      );

      test('should throw ArgumentError for negative step count', () {
        expect(
          () => useCase.calculateLevel(-100),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for non-positive goal steps', () {
        expect(
          () => useCase.calculateLevel(5000, goalSteps: 0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => useCase.calculateLevel(5000, goalSteps: -1000),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('createVisualization', () {
      test('should create visualization from health data', () {
        // Arrange
        final testDate = DateTime(2024, 1, 15);
        final healthData = HealthData(
          date: testDate,
          stepCount: 6400,
          distance: 4.5,
          caloriesBurned: 256,
          activityLevel: ActivityLevel.high,
        );

        // Act
        final visualization = useCase.createVisualization(
          healthData,
          goalSteps: 8000,
        );

        // Assert
        expect(visualization.date, equals(testDate));
        expect(visualization.stepCount, equals(6400));
        expect(visualization.level, equals(ActivityLevel.high));
        expect(visualization.hasData, isTrue);
        expect(visualization.goalAchievementRate, equals(0.8));
        expect(visualization.tooltip, contains('6400 steps'));
        expect(visualization.tooltip, contains('80% of goal'));
      });
    });

    group('createVisualizationList', () {
      test('should create visualization list for date range with data', () {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 3);
        final healthDataList = [
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 5000,
            distance: 3.5,
            caloriesBurned: 200,
            activityLevel: ActivityLevel.medium,
          ),
          HealthData(
            date: DateTime(2024, 1, 3),
            stepCount: 8000,
            distance: 6.0,
            caloriesBurned: 320,
            activityLevel: ActivityLevel.high,
          ),
        ];

        // Act
        final visualizations = useCase.createVisualizationList(
          healthDataList: healthDataList,
          startDate: startDate,
          endDate: endDate,
          goalSteps: 8000,
        );

        // Assert
        expect(visualizations.length, equals(3));

        // Day 1 - has data
        expect(visualizations[0].date, equals(DateTime(2024, 1, 1)));
        expect(visualizations[0].hasData, isTrue);
        expect(visualizations[0].stepCount, equals(5000));

        // Day 2 - no data
        expect(visualizations[1].date, equals(DateTime(2024, 1, 2)));
        expect(visualizations[1].hasData, isFalse);
        expect(visualizations[1].stepCount, equals(0));

        // Day 3 - has data
        expect(visualizations[2].date, equals(DateTime(2024, 1, 3)));
        expect(visualizations[2].hasData, isTrue);
        expect(visualizations[2].stepCount, equals(8000));
      });

      test('should throw ArgumentError for invalid date range', () {
        final startDate = DateTime(2024, 1, 5);
        final endDate = DateTime(2024, 1, 1);

        expect(
          () => useCase.createVisualizationList(
            healthDataList: [],
            startDate: startDate,
            endDate: endDate,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('createYearlyGrid', () {
      test('should create yearly grid with correct week structure', () {
        // Arrange
        const year = 2024;
        final healthDataList = [
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 5000,
            distance: 3.5,
            caloriesBurned: 200,
            activityLevel: ActivityLevel.medium,
          ),
          HealthData(
            date: DateTime(2024, 1, 15),
            stepCount: 8000,
            distance: 6.0,
            caloriesBurned: 320,
            activityLevel: ActivityLevel.high,
          ),
        ];

        // Act
        final yearlyGrid = useCase.createYearlyGrid(
          year: year,
          healthDataList: healthDataList,
          goalSteps: 8000,
        );

        // Assert
        expect(yearlyGrid, isNotEmpty);

        // Each week should have 7 days
        for (final week in yearlyGrid) {
          expect(week.length, equals(7));
        }

        // Should cover the entire year
        final totalDays = yearlyGrid.expand((week) => week).length;
        expect(totalDays, greaterThanOrEqualTo(365));
      });
    });

    group('calculateStatistics', () {
      test('should calculate correct statistics for visualizations', () {
        // Arrange
        final visualizations = [
          ActivityVisualization.fromHealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 5000,
            goalSteps: 8000,
          ),
          ActivityVisualization.fromHealthData(
            date: DateTime(2024, 1, 2),
            stepCount: 8000,
            goalSteps: 8000,
          ),
          ActivityVisualization.fromHealthData(
            date: DateTime(2024, 1, 3),
            stepCount: 10000,
            goalSteps: 8000,
          ),
          ActivityVisualization.noData(DateTime(2024, 1, 4)),
        ];

        // Act
        final statistics = useCase.calculateStatistics(visualizations);

        // Assert
        expect(statistics['totalDays'], equals(4));
        expect(statistics['activeDays'], equals(3));
        expect(statistics['totalSteps'], equals(23000));
        expect(statistics['averageSteps'], closeTo(7666.67, 0.1));
        expect(statistics['maxSteps'], equals(10000));
        expect(
          statistics['goalAchievementRate'],
          closeTo(0.67, 0.1),
        ); // 2 out of 3 days achieved goal
      });

      test('should return zero statistics for empty list', () {
        // Act
        final statistics = useCase.calculateStatistics([]);

        // Assert
        expect(statistics['totalDays'], equals(0));
        expect(statistics['activeDays'], equals(0));
        expect(statistics['totalSteps'], equals(0));
        expect(statistics['averageSteps'], equals(0.0));
        expect(statistics['maxSteps'], equals(0));
        expect(statistics['goalAchievementRate'], equals(0.0));
      });

      test('should return zero statistics for list with no data', () {
        // Arrange
        final visualizations = [
          ActivityVisualization.noData(DateTime(2024, 1, 1)),
          ActivityVisualization.noData(DateTime(2024, 1, 2)),
        ];

        // Act
        final statistics = useCase.calculateStatistics(visualizations);

        // Assert
        expect(statistics['totalDays'], equals(0));
        expect(statistics['activeDays'], equals(0));
        expect(statistics['totalSteps'], equals(0));
        expect(statistics['averageSteps'], equals(0.0));
        expect(statistics['maxSteps'], equals(0));
        expect(statistics['goalAchievementRate'], equals(0.0));
      });
    });
  });
}
