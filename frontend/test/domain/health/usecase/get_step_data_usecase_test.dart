import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/domain/health/usecase/get_step_data_usecase.dart';
import 'package:frontend/domain/health/repository/health_repository.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';

import 'get_step_data_usecase_test.mocks.dart';

@GenerateMocks([HealthRepository])
void main() {
  group('GetStepDataUseCase', () {
    late GetStepDataUseCase useCase;
    late MockHealthRepository mockRepository;

    setUp(() {
      mockRepository = MockHealthRepository();
      useCase = GetStepDataUseCase(mockRepository);
    });

    group('call', () {
      test('should return sorted health data for valid date range', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 3);
        final healthDataList = [
          HealthData(
            date: DateTime(2024, 1, 3),
            stepCount: 7000,
            distance: 5.0,
            caloriesBurned: 280,
            activityLevel: ActivityLevel.high,
          ),
          HealthData(
            date: DateTime(2024, 1, 1),
            stepCount: 5000,
            distance: 3.5,
            caloriesBurned: 200,
            activityLevel: ActivityLevel.medium,
          ),
          HealthData(
            date: DateTime(2024, 1, 2),
            stepCount: 8500,
            distance: 6.0,
            caloriesBurned: 340,
            activityLevel: ActivityLevel.high,
          ),
        ];

        when(
          mockRepository.getStepData(startDate: startDate, endDate: endDate),
        ).thenAnswer((_) async => healthDataList);

        // Act
        final result = await useCase.call(
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result.length, equals(3));
        expect(
          result[0].date,
          equals(DateTime(2024, 1, 1)),
        ); // Should be sorted
        expect(result[1].date, equals(DateTime(2024, 1, 2)));
        expect(result[2].date, equals(DateTime(2024, 1, 3)));
        verify(
          mockRepository.getStepData(startDate: startDate, endDate: endDate),
        ).called(1);
      });

      test('should throw ArgumentError for invalid date range', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 5);
        final endDate = DateTime(2024, 1, 1);

        // Act & Assert
        expect(
          () => useCase.call(startDate: startDate, endDate: endDate),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(
          mockRepository.getStepData(
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        );
      });

      test('should adjust end date if it is in the future', () async {
        // Arrange
        final startDate = DateTime.now().subtract(const Duration(days: 2));
        final futureEndDate = DateTime.now().add(const Duration(days: 2));
        final expectedEndDate = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

        when(
          mockRepository.getStepData(
            startDate: startDate,
            endDate: expectedEndDate,
          ),
        ).thenAnswer((_) async => []);

        // Act
        await useCase.call(startDate: startDate, endDate: futureEndDate);

        // Assert
        verify(
          mockRepository.getStepData(
            startDate: startDate,
            endDate: expectedEndDate,
          ),
        ).called(1);
      });

      test('should throw HealthDataException when repository throws', () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 3);

        when(
          mockRepository.getStepData(startDate: startDate, endDate: endDate),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(
          () => useCase.call(startDate: startDate, endDate: endDate),
          throwsA(isA<HealthDataException>()),
        );
      });
    });

    group('getTodayStepData', () {
      test('should return today step data', () async {
        // Arrange
        final todayData = HealthData(
          date: DateTime.now(),
          stepCount: 6000,
          distance: 4.2,
          caloriesBurned: 240,
          activityLevel: ActivityLevel.medium,
        );

        when(
          mockRepository.getTodayStepData(),
        ).thenAnswer((_) async => todayData);

        // Act
        final result = await useCase.getTodayStepData();

        // Assert
        expect(result, equals(todayData));
        verify(mockRepository.getTodayStepData()).called(1);
      });

      test('should return null when no data available', () async {
        // Arrange
        when(mockRepository.getTodayStepData()).thenAnswer((_) async => null);

        // Act
        final result = await useCase.getTodayStepData();

        // Assert
        expect(result, isNull);
        verify(mockRepository.getTodayStepData()).called(1);
      });

      test('should throw HealthDataException when repository throws', () async {
        // Arrange
        when(
          mockRepository.getTodayStepData(),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(
          () => useCase.getTodayStepData(),
          throwsA(isA<HealthDataException>()),
        );
      });
    });

    group('getStepDataForDate', () {
      test('should return data for valid past date', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15);
        final healthData = HealthData(
          date: testDate,
          stepCount: 7500,
          distance: 5.5,
          caloriesBurned: 300,
          activityLevel: ActivityLevel.high,
        );

        when(
          mockRepository.getStepDataForDate(testDate),
        ).thenAnswer((_) async => healthData);

        // Act
        final result = await useCase.getStepDataForDate(testDate);

        // Assert
        expect(result, equals(healthData));
        verify(mockRepository.getStepDataForDate(testDate)).called(1);
      });

      test('should return null for future date', () async {
        // Arrange
        final futureDate = DateTime.now().add(const Duration(days: 1));

        // Act
        final result = await useCase.getStepDataForDate(futureDate);

        // Assert
        expect(result, isNull);
        verifyNever(mockRepository.getStepDataForDate(any));
      });

      test('should throw HealthDataException when repository throws', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15);
        when(
          mockRepository.getStepDataForDate(testDate),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(
          () => useCase.getStepDataForDate(testDate),
          throwsA(isA<HealthDataException>()),
        );
      });
    });

    group('getWeeklyStepData', () {
      test('should return weekly data for given week start', () async {
        // Arrange
        final weekStart = DateTime(2024, 1, 1); // Monday
        final weekEnd = DateTime(2024, 1, 7); // Sunday
        final weeklyData = <HealthData>[];

        when(
          mockRepository.getStepData(startDate: weekStart, endDate: weekEnd),
        ).thenAnswer((_) async => weeklyData);

        // Act
        final result = await useCase.getWeeklyStepData(weekStart);

        // Assert
        expect(result, equals(weeklyData));
        verify(
          mockRepository.getStepData(startDate: weekStart, endDate: weekEnd),
        ).called(1);
      });
    });

    group('getMonthlyStepData', () {
      test('should return monthly data for given year and month', () async {
        // Arrange
        const year = 2024;
        const month = 1;
        final startDate = DateTime(year, month, 1);
        final endDate = DateTime(year, month + 1, 0); // Last day of month
        final monthlyData = <HealthData>[];

        when(
          mockRepository.getStepData(startDate: startDate, endDate: endDate),
        ).thenAnswer((_) async => monthlyData);

        // Act
        final result = await useCase.getMonthlyStepData(year, month);

        // Assert
        expect(result, equals(monthlyData));
        verify(
          mockRepository.getStepData(startDate: startDate, endDate: endDate),
        ).called(1);
      });
    });
  });
}
