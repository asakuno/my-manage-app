import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('should provide light theme', () {
      // Arrange & Act
      final lightTheme = AppTheme.lightTheme;

      // Assert
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.useMaterial3, true);
    });

    test('should provide dark theme', () {
      // Arrange & Act
      final darkTheme = AppTheme.darkTheme;

      // Assert
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.useMaterial3, true);
    });
  });
}
