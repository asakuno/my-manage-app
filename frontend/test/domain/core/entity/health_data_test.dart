import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';
import 'package:frontend/domain/core/type/health_data_type.dart';

void main() {
  group('HealthData', () {
    late HealthData healthData;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2024, 1, 15);
      healthData = HealthData(
        date: testDate,
        stepCount: 8500,
        distance: 6.5,
        caloriesBurned: 320,
        activityLevel: ActivityLevel.high,
        activeTime: 45,
        syncStatus: SyncStatus.synced,
      );
    });

    test('should create HealthData with correct properties', () {
      expect(healthData.date, equals(testDate));
      expect(healthData.stepCount, equals(8500));
      expect(healthData.distance, equals(6.5));
      expect(healthData.caloriesBurned, equals(320));
      expect(healthData.activityLevel, equals(ActivityLevel.high));
      expect(healthData.activeTime, equals(45));
      expect(healthData.syncStatus, equals(SyncStatus.synced));
    });

    test('should calculate achievement rate correctly', () {
      // Test with goal of 10000 steps
      final achievementRate = healthData.getAchievementRate(10000);
      expect(achievementRate, equals(0.85));

      // Test with goal of 8000 steps (over 100%)
      final achievementRateOver = healthData.getAchievementRate(8000);
      expect(achievementRateOver, equals(1.0)); // Should be clamped to 1.0

      // Test with zero goal
      final achievementRateZero = healthData.getAchievementRate(0);
      expect(achievementRateZero, equals(0.0));
    });

    test('should validate data correctly', () {
      expect(healthData.isValid, isTrue);

      // Test with negative values
      final invalidData = HealthData(
        date: testDate,
        stepCount: -100,
        distance: 6.5,
        caloriesBurned: 320,
        activityLevel: ActivityLevel.high,
      );
      expect(invalidData.isValid, isFalse);
    });

    test('should detect if data is for today', () {
      final today = DateTime.now();
      final todayData = HealthData(
        date: today,
        stepCount: 5000,
        distance: 3.0,
        caloriesBurned: 200,
        activityLevel: ActivityLevel.medium,
      );

      expect(todayData.isToday, isTrue);
      expect(healthData.isToday, isFalse);
    });

    test('should create copy with modified properties', () {
      final copiedData = healthData.copyWith(stepCount: 9000, distance: 7.0);

      expect(copiedData.stepCount, equals(9000));
      expect(copiedData.distance, equals(7.0));
      expect(copiedData.date, equals(healthData.date)); // Unchanged
      expect(
        copiedData.caloriesBurned,
        equals(healthData.caloriesBurned),
      ); // Unchanged
    });

    test('should support equality comparison', () {
      final sameData = HealthData(
        date: testDate,
        stepCount: 8500,
        distance: 6.5,
        caloriesBurned: 320,
        activityLevel: ActivityLevel.high,
        activeTime: 45,
        syncStatus: SyncStatus.synced,
      );

      final differentData = healthData.copyWith(stepCount: 9000);

      expect(healthData, equals(sameData));
      expect(healthData, isNot(equals(differentData)));
    });

    test('should have proper string representation', () {
      final stringRep = healthData.toString();
      expect(stringRep, contains('HealthData'));
      expect(stringRep, contains('8500'));
      expect(stringRep, contains('6.5'));
    });
  });
}
