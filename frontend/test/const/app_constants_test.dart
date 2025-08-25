import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/const/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('should have valid app name', () {
      // Assert
      expect(AppConstants.appName, isNotEmpty);
      expect(AppConstants.appName, 'Health Activity Visualization');
    });

    test('should have valid version', () {
      // Assert
      expect(AppConstants.appVersion, isNotEmpty);
      expect(AppConstants.appVersion, matches(RegExp(r'^\d+\.\d+\.\d+$')));
    });

    test('should have valid default step goal', () {
      // Assert
      expect(AppConstants.defaultStepGoal, 8000);
      expect(AppConstants.defaultStepGoal, greaterThan(0));
    });

    test('should have valid activity level thresholds', () {
      // Assert
      expect(AppConstants.activityLevelThresholds, hasLength(4));
      expect(AppConstants.activityLevelThresholds[0], 2000);
      expect(AppConstants.activityLevelThresholds[1], 5000);
      expect(AppConstants.activityLevelThresholds[2], 8000);
      expect(AppConstants.activityLevelThresholds[3], 12000);
    });
  });
}
