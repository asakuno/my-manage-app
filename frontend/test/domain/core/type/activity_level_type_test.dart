import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';

void main() {
  group('ActivityLevel', () {
    test('should have correct level values', () {
      expect(ActivityLevel.none.level, equals(0));
      expect(ActivityLevel.low.level, equals(1));
      expect(ActivityLevel.medium.level, equals(2));
      expect(ActivityLevel.high.level, equals(3));
      expect(ActivityLevel.veryHigh.level, equals(4));
    });

    test('should have correct colors', () {
      expect(ActivityLevel.none.color, equals(Colors.grey));
      expect(ActivityLevel.low.color, equals(const Color(0xFFE8F5E8)));
      expect(ActivityLevel.medium.color, equals(const Color(0xFFB8E6B8)));
      expect(ActivityLevel.high.color, equals(const Color(0xFF7DD87D)));
      expect(ActivityLevel.veryHigh.color, equals(const Color(0xFF4CAF50)));
    });

    group('fromStepCount', () {
      test('should return correct level for step counts', () {
        expect(ActivityLevel.fromStepCount(0), equals(ActivityLevel.none));
        expect(ActivityLevel.fromStepCount(1500), equals(ActivityLevel.low));
        expect(ActivityLevel.fromStepCount(2000), equals(ActivityLevel.low));
        expect(ActivityLevel.fromStepCount(3500), equals(ActivityLevel.medium));
        expect(ActivityLevel.fromStepCount(5000), equals(ActivityLevel.medium));
        expect(ActivityLevel.fromStepCount(7000), equals(ActivityLevel.high));
        expect(ActivityLevel.fromStepCount(8000), equals(ActivityLevel.high));
        expect(
          ActivityLevel.fromStepCount(10000),
          equals(ActivityLevel.veryHigh),
        );
      });
    });

    group('fromStepCountWithGoal', () {
      test('should return correct level based on goal percentage', () {
        const goalSteps = 8000;

        // 0% of goal
        expect(
          ActivityLevel.fromStepCountWithGoal(0, goalSteps),
          equals(ActivityLevel.none),
        );

        // 20% of goal (1600 steps)
        expect(
          ActivityLevel.fromStepCountWithGoal(1600, goalSteps),
          equals(ActivityLevel.low),
        );

        // 50% of goal (4000 steps)
        expect(
          ActivityLevel.fromStepCountWithGoal(4000, goalSteps),
          equals(ActivityLevel.medium),
        );

        // 80% of goal (6400 steps)
        expect(
          ActivityLevel.fromStepCountWithGoal(6400, goalSteps),
          equals(ActivityLevel.high),
        );

        // 100% of goal (8000 steps)
        expect(
          ActivityLevel.fromStepCountWithGoal(8000, goalSteps),
          equals(ActivityLevel.high),
        );

        // 120% of goal (9600 steps)
        expect(
          ActivityLevel.fromStepCountWithGoal(9600, goalSteps),
          equals(ActivityLevel.veryHigh),
        );
      });

      test('should handle edge cases', () {
        // Test with different goal values
        expect(
          ActivityLevel.fromStepCountWithGoal(5000, 10000),
          equals(ActivityLevel.medium),
        );

        expect(
          ActivityLevel.fromStepCountWithGoal(5000, 4000),
          equals(ActivityLevel.veryHigh),
        );
      });
    });
  });
}
