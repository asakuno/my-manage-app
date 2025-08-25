import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'test_helpers.dart';
import 'widget_test_utils.dart';
import 'mock_factories.dart';
import 'test_data_builders.dart';

void main() {
  group('Test Utilities Tests', () {
    group('TestHelpers', () {
      test('should create provider container with overrides', () {
        final container = TestHelpers.createContainer(overrides: []);

        expect(container, isA<ProviderContainer>());

        TestHelpers.disposeContainer(container);
      });

      test('should create test date with default values', () {
        final date = TestHelpers.createTestDate();

        expect(date.year, equals(2024));
        expect(date.month, equals(1));
        expect(date.day, equals(1));
      });

      test('should create test date range', () {
        final range = TestHelpers.createTestDateRange();

        expect(range['start'], isA<DateTime>());
        expect(range['end'], isA<DateTime>());
        expect(range['end']!.isAfter(range['start']!), isTrue);
      });
    });

    group('MockFactories', () {
      test('should create health repository mock', () {
        final mock = MockFactories.createHealthRepository();

        expect(mock, isA<MockHealthRepositoryImpl>());
      });

      test('should create get step data use case mock', () {
        final mock = MockFactories.createGetStepDataUseCase();

        expect(mock, isA<MockGetStepDataUseCase>());
      });

      test('should reset all mocks', () {
        // Create some mocks
        MockFactories.createHealthRepository();
        MockFactories.createGetStepDataUseCase();

        // Reset should not throw
        expect(() => MockFactories.resetAllMocks(), returnsNormally);
      });

      test('should clear all mocks', () {
        // Create some mocks
        MockFactories.createHealthRepository();
        MockFactories.createGetStepDataUseCase();

        // Clear should not throw
        expect(() => MockFactories.clearAllMocks(), returnsNormally);
      });
    });

    group('TestDataBuilders', () {
      test('should build health data with default values', () {
        final healthData = TestDataBuilders.healthData().build();

        expect(healthData.stepCount, equals(5000));
        expect(healthData.distance, equals(3.5));
        expect(healthData.caloriesBurned, equals(250));
      });

      test('should build health data with custom step count', () {
        final healthData = TestDataBuilders.healthData()
            .withStepCount(10000)
            .build();

        expect(healthData.stepCount, equals(10000));
        expect(healthData.distance, greaterThan(0));
        expect(healthData.caloriesBurned, greaterThan(0));
      });

      test('should build activity visualization with default values', () {
        final visualization = TestDataBuilders.activityVisualization().build();

        expect(visualization.stepCount, equals(5000));
        expect(visualization.hasData, isTrue);
        expect(visualization.goalAchievementRate, equals(0.625));
      });

      test('should build activity visualization with no data', () {
        final visualization = TestDataBuilders.activityVisualization()
            .withNoData()
            .build();

        expect(visualization.stepCount, equals(0));
        expect(visualization.hasData, isFalse);
        expect(visualization.goalAchievementRate, equals(0.0));
      });

      test('should create health data range', () {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);

        final dataList = TestDataBuilders.healthDataRange(
          startDate: startDate,
          endDate: endDate,
        );

        expect(dataList.length, equals(7));
        expect(dataList.first.date, equals(startDate));
        expect(dataList.last.date, equals(endDate));
      });

      test('should create activity statistics', () {
        final stats = TestDataBuilders.activityStatistics();

        expect(stats['totalSteps'], equals(50000));
        expect(stats['averageSteps'], equals(7142.86));
        expect(stats['goalAchievementRate'], equals(0.89));
        expect(stats['activeDays'], equals(6));
        expect(stats['totalDays'], equals(7));
      });
    });

    testWidgets('WidgetTestUtils should create test app', (tester) async {
      final testWidget = const Text('Test Widget');

      await WidgetTestUtils.pumpWidgetWithProviders(tester, testWidget);

      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('WidgetTestUtils should find widgets by text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Hello World'))),
      );

      WidgetTestUtils.expectTextDisplayed('Hello World');
      WidgetTestUtils.expectWidgetExists(
        WidgetTestUtils.findByText('Hello World'),
      );
    });
  });
}
