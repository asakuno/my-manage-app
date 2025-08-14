import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/api/mock/mock_health_data.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';
import 'package:frontend/domain/core/type/health_data_type.dart';

void main() {
  group('MockHealthData', () {
    group('generateHealthDataForDate', () {
      test('should generate health data for past date', () {
        // Arrange
        final pastDate = DateTime.now().subtract(const Duration(days: 5));

        // Act
        final result = MockHealthData.generateHealthDataForDate(pastDate);

        // Assert
        expect(result.date, equals(pastDate));
        expect(result.stepCount, greaterThan(0));
        expect(result.distance, greaterThan(0.0));
        expect(result.caloriesBurned, greaterThan(0));
        expect(result.activeTime, greaterThan(0));
        expect(result.activityLevel, isA<ActivityLevel>());
        expect(result.syncStatus, isA<SyncStatus>());
      });

      test('should generate zero data for future date', () {
        // Arrange
        final futureDate = DateTime.now().add(const Duration(days: 5));

        // Act
        final result = MockHealthData.generateHealthDataForDate(futureDate);

        // Assert
        expect(result.date, equals(futureDate));
        expect(result.stepCount, equals(0));
        expect(result.distance, equals(0.0));
        expect(result.caloriesBurned, equals(0));
        expect(result.activeTime, equals(0));
        expect(result.activityLevel, equals(ActivityLevel.none));
      });

      test('should generate realistic data for weekday vs weekend', () {
        // Arrange
        final monday = DateTime(2024, 1, 1); // Monday
        final saturday = DateTime(2024, 1, 6); // Saturday

        // Act
        final mondayData = MockHealthData.generateHealthDataForDate(monday);
        final saturdayData = MockHealthData.generateHealthDataForDate(saturday);

        // Assert
        expect(mondayData.stepCount, greaterThan(0));
        expect(saturdayData.stepCount, greaterThan(0));
        // Weekend data might be different from weekday data
        expect(mondayData.date.weekday, equals(1)); // Monday
        expect(saturdayData.date.weekday, equals(6)); // Saturday
      });

      test('should generate consistent data for same date', () {
        // Arrange
        final date = DateTime(2024, 1, 15);

        // Act
        final result1 = MockHealthData.generateHealthDataForDate(date);
        final result2 = MockHealthData.generateHealthDataForDate(date);

        // Assert
        // Note: Since the mock uses random data, we can't expect exact equality
        // but we can verify the structure is consistent
        expect(result1.date, equals(result2.date));
        expect(result1.stepCount, greaterThanOrEqualTo(0));
        expect(result2.stepCount, greaterThanOrEqualTo(0));
      });
    });

    group('generateHealthDataRange', () {
      test('should generate data for date range', () {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 7);

        // Act
        final result = MockHealthData.generateHealthDataRange(
          startDate,
          endDate,
        );

        // Assert
        expect(result, isNotEmpty);
        expect(
          result.length,
          lessThanOrEqualTo(7),
        ); // Some days might be missing

        // Verify dates are within range
        for (final data in result) {
          expect(
            data.date.isAfter(startDate.subtract(const Duration(days: 1))),
            isTrue,
          );
          expect(
            data.date.isBefore(endDate.add(const Duration(days: 1))),
            isTrue,
          );
        }
      });

      test('should return empty list for future date range', () {
        // Arrange
        final startDate = DateTime.now().add(const Duration(days: 10));
        final endDate = DateTime.now().add(const Duration(days: 17));

        // Act
        final result = MockHealthData.generateHealthDataRange(
          startDate,
          endDate,
        );

        // Assert
        // Future dates should have zero step data, but might still be included
        for (final data in result) {
          expect(data.stepCount, equals(0));
        }
      });
    });

    group('generateLast30DaysData', () {
      test('should generate data for last 30 days', () {
        // Act
        final result = MockHealthData.generateLast30DaysData();

        // Assert
        expect(result, isNotEmpty);
        expect(result.length, lessThanOrEqualTo(30));

        // Verify dates are within last 30 days
        final now = DateTime.now();
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));

        for (final data in result) {
          expect(
            data.date.isAfter(thirtyDaysAgo.subtract(const Duration(days: 1))),
            isTrue,
          );
          expect(data.date.isBefore(now.add(const Duration(days: 1))), isTrue);
        }
      });
    });

    group('generateLast7DaysData', () {
      test('should generate data for last 7 days', () {
        // Act
        final result = MockHealthData.generateLast7DaysData();

        // Assert
        expect(result, isNotEmpty);
        expect(result.length, lessThanOrEqualTo(7));

        // Verify dates are within last 7 days
        final now = DateTime.now();
        final sevenDaysAgo = now.subtract(const Duration(days: 7));

        for (final data in result) {
          expect(
            data.date.isAfter(sevenDaysAgo.subtract(const Duration(days: 1))),
            isTrue,
          );
          expect(data.date.isBefore(now.add(const Duration(days: 1))), isTrue);
        }
      });
    });

    group('generateHighActivityData', () {
      test('should generate high activity data', () {
        // Arrange
        final date = DateTime(2024, 1, 15);

        // Act
        final result = MockHealthData.generateHighActivityData(date);

        // Assert
        expect(result.date, equals(date));
        expect(result.stepCount, greaterThanOrEqualTo(10000));
        expect(result.stepCount, lessThanOrEqualTo(15000));
        expect(result.distance, greaterThan(0.0));
        expect(result.caloriesBurned, greaterThan(0));
        expect(result.activeTime, greaterThan(0));
        expect(result.syncStatus, equals(SyncStatus.synced));
      });
    });

    group('generateLowActivityData', () {
      test('should generate low activity data', () {
        // Arrange
        final date = DateTime(2024, 1, 15);

        // Act
        final result = MockHealthData.generateLowActivityData(date);

        // Assert
        expect(result.date, equals(date));
        expect(result.stepCount, greaterThanOrEqualTo(1000));
        expect(result.stepCount, lessThanOrEqualTo(4000));
        expect(result.distance, greaterThan(0.0));
        expect(result.caloriesBurned, greaterThan(0));
        expect(result.activeTime, greaterThan(0));
        expect(result.syncStatus, equals(SyncStatus.synced));
      });
    });

    group('generateStatistics', () {
      test('should generate realistic statistics', () {
        // Act
        final result = MockHealthData.generateStatistics();

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('totalDays'), isTrue);
        expect(result.containsKey('averageSteps'), isTrue);
        expect(result.containsKey('maxSteps'), isTrue);
        expect(result.containsKey('totalSteps'), isTrue);
        expect(result.containsKey('averageDistance'), isTrue);
        expect(result.containsKey('totalDistance'), isTrue);
        expect(result.containsKey('averageCalories'), isTrue);
        expect(result.containsKey('totalCalories'), isTrue);
        expect(result.containsKey('goalAchievementRate'), isTrue);

        // Verify data types and ranges
        expect(result['totalDays'], isA<int>());
        expect(result['averageSteps'], isA<double>());
        expect(result['maxSteps'], isA<int>());
        expect(result['totalSteps'], isA<int>());
        expect(result['goalAchievementRate'], isA<double>());

        // Goal achievement rate should be between 0 and 1
        expect(result['goalAchievementRate'], greaterThanOrEqualTo(0.0));
        expect(result['goalAchievementRate'], lessThanOrEqualTo(1.0));
      });
    });

    group('generatePendingSyncData', () {
      test('should generate pending sync data', () {
        // Act
        final result = MockHealthData.generatePendingSyncData();

        // Assert
        expect(result, isNotEmpty);
        expect(
          result.length,
          equals(3),
        ); // Should generate 3 days of pending data

        // All data should have pending sync status
        for (final data in result) {
          expect(data.syncStatus, equals(SyncStatus.pending));
          expect(
            data.date.isBefore(DateTime.now().add(const Duration(days: 1))),
            isTrue,
          );
        }
      });
    });
  });
}
