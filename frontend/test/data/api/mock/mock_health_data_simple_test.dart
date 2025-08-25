import 'package:test/test.dart';
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
  });
}
