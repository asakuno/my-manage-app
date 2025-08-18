import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/core/entity/health_data.dart';
import '../../domain/core/entity/activity_visualization.dart';
import '../../domain/health/usecase/get_step_data_usecase.dart';
import '../../domain/health/usecase/calculate_activity_level_usecase.dart';
import '../../domain/health/usecase/sync_health_data_usecase.dart';
import '../../data/repository/health_repository_impl.dart';
import '../../data/local/health_local_data_source.dart';
import '../../data/api/health_api_data_source.dart';

part 'health_provider.g.dart';

/// ヘルスローカルデータソースプロバイダー
@riverpod
HealthLocalDataSource healthLocalDataSource(HealthLocalDataSourceRef ref) {
  return HealthLocalDataSource();
}

/// ヘルスAPIデータソースプロバイダー
@riverpod
HealthApiDataSource healthApiDataSource(HealthApiDataSourceRef ref) {
  return HealthApiDataSource();
}

/// ヘルスリポジトリプロバイダー
@riverpod
HealthRepositoryImpl healthRepository(HealthRepositoryRef ref) {
  return HealthRepositoryImpl(
    localDataSource: ref.watch(healthLocalDataSourceProvider),
    apiDataSource: ref.watch(healthApiDataSourceProvider),
  );
}

/// 歩数データ取得ユースケースプロバイダー
@riverpod
GetStepDataUseCase getStepDataUseCase(GetStepDataUseCaseRef ref) {
  return GetStepDataUseCase(ref.watch(healthRepositoryProvider));
}

/// アクティビティレベル計算ユースケースプロバイダー
@riverpod
CalculateActivityLevelUseCase calculateActivityLevelUseCase(
  CalculateActivityLevelUseCaseRef ref,
) {
  return const CalculateActivityLevelUseCase();
}

/// ヘルスデータ同期ユースケースプロバイダー
@riverpod
SyncHealthDataUseCase syncHealthDataUseCase(SyncHealthDataUseCaseRef ref) {
  return SyncHealthDataUseCase(ref.watch(healthRepositoryProvider));
}

/// 今日の歩数データプロバイダー
@riverpod
class TodayStepData extends _$TodayStepData {
  @override
  Future<HealthData?> build() async {
    final useCase = ref.watch(getStepDataUseCaseProvider);
    return await useCase.getTodayStepData();
  }

  /// データを手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getStepDataUseCaseProvider);
      return await useCase.getTodayStepData();
    });
  }
}

/// 指定期間の歩数データプロバイダー
@riverpod
class StepDataRange extends _$StepDataRange {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Future<List<HealthData>> build({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _startDate = startDate;
    _endDate = endDate;
    final useCase = ref.watch(getStepDataUseCaseProvider);
    return await useCase.call(startDate: startDate, endDate: endDate);
  }

  /// データを手動で更新
  Future<void> refresh() async {
    if (_startDate == null || _endDate == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getStepDataUseCaseProvider);
      return await useCase.call(startDate: _startDate!, endDate: _endDate!);
    });
  }
}

/// 今日の歩数データをリアルタイムで監視するプロバイダー
@riverpod
class TodayStepDataStream extends _$TodayStepDataStream {
  @override
  Stream<HealthData?> build() {
    final useCase = ref.watch(getStepDataUseCaseProvider);
    return useCase.watchTodayStepData();
  }
}

/// 年間アクティビティ視覚化データプロバイダー
@riverpod
class YearlyActivityVisualization extends _$YearlyActivityVisualization {
  int? _year;
  int? _goalSteps;

  @override
  Future<List<List<ActivityVisualization>>> build({
    required int year,
    int goalSteps = 8000,
  }) async {
    _year = year;
    _goalSteps = goalSteps;
    final getStepDataUseCase = ref.watch(getStepDataUseCaseProvider);
    final calculateActivityLevelUseCase = ref.watch(
      calculateActivityLevelUseCaseProvider,
    );

    // 年間の歩数データを取得
    final healthDataList = await getStepDataUseCase.getYearlyStepData(year);

    // GitHub風カレンダー表示用のグリッドを生成
    return calculateActivityLevelUseCase.createYearlyGrid(
      year: year,
      healthDataList: healthDataList,
      goalSteps: goalSteps,
    );
  }

  /// データを手動で更新
  Future<void> refresh() async {
    if (_year == null || _goalSteps == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getStepDataUseCase = ref.read(getStepDataUseCaseProvider);
      final calculateActivityLevelUseCase = ref.read(
        calculateActivityLevelUseCaseProvider,
      );

      final healthDataList = await getStepDataUseCase.getYearlyStepData(_year!);

      return calculateActivityLevelUseCase.createYearlyGrid(
        year: _year!,
        healthDataList: healthDataList,
        goalSteps: _goalSteps!,
      );
    });
  }
}

/// 月間歩数データプロバイダー
@riverpod
class MonthlyStepData extends _$MonthlyStepData {
  int? _year;
  int? _month;

  @override
  Future<List<HealthData>> build({
    required int year,
    required int month,
  }) async {
    _year = year;
    _month = month;
    final useCase = ref.watch(getStepDataUseCaseProvider);
    return await useCase.getMonthlyStepData(year, month);
  }

  /// データを手動で更新
  Future<void> refresh() async {
    if (_year == null || _month == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getStepDataUseCaseProvider);
      return await useCase.getMonthlyStepData(_year!, _month!);
    });
  }
}

/// 週間歩数データプロバイダー
@riverpod
class WeeklyStepData extends _$WeeklyStepData {
  DateTime? _weekStart;

  @override
  Future<List<HealthData>> build({required DateTime weekStart}) async {
    _weekStart = weekStart;
    final useCase = ref.watch(getStepDataUseCaseProvider);
    return await useCase.getWeeklyStepData(weekStart);
  }

  /// データを手動で更新
  Future<void> refresh() async {
    if (_weekStart == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getStepDataUseCaseProvider);
      return await useCase.getWeeklyStepData(_weekStart!);
    });
  }
}

/// ヘルスデータ同期状態プロバイダー
@riverpod
class HealthDataSync extends _$HealthDataSync {
  @override
  Future<bool> build() async {
    return true; // 初期状態は同期済み
  }

  /// ヘルスデータを同期
  Future<void> sync() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(syncHealthDataUseCaseProvider);
      await useCase.call();

      // 関連するプロバイダーを無効化して再取得を促す
      ref.invalidate(todayStepDataProvider);
      ref.invalidate(yearlyActivityVisualizationProvider);

      return true;
    });
  }
}

/// アクティビティ統計プロバイダー
@riverpod
class ActivityStatistics extends _$ActivityStatistics {
  DateTime? _startDate;
  DateTime? _endDate;
  int? _goalSteps;

  @override
  Future<Map<String, dynamic>> build({
    required DateTime startDate,
    required DateTime endDate,
    int goalSteps = 8000,
  }) async {
    _startDate = startDate;
    _endDate = endDate;
    _goalSteps = goalSteps;
    final getStepDataUseCase = ref.watch(getStepDataUseCaseProvider);
    final calculateActivityLevelUseCase = ref.watch(
      calculateActivityLevelUseCaseProvider,
    );

    // 指定期間の歩数データを取得
    final healthDataList = await getStepDataUseCase.call(
      startDate: startDate,
      endDate: endDate,
    );

    // アクティビティ視覚化データを生成
    final visualizations = calculateActivityLevelUseCase
        .createVisualizationList(
          healthDataList: healthDataList,
          startDate: startDate,
          endDate: endDate,
          goalSteps: goalSteps,
        );

    // 統計を計算
    return calculateActivityLevelUseCase.calculateStatistics(visualizations);
  }

  /// データを手動で更新
  Future<void> refresh() async {
    if (_startDate == null || _endDate == null || _goalSteps == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getStepDataUseCase = ref.read(getStepDataUseCaseProvider);
      final calculateActivityLevelUseCase = ref.read(
        calculateActivityLevelUseCaseProvider,
      );

      final healthDataList = await getStepDataUseCase.call(
        startDate: _startDate!,
        endDate: _endDate!,
      );

      final visualizations = calculateActivityLevelUseCase
          .createVisualizationList(
            healthDataList: healthDataList,
            startDate: _startDate!,
            endDate: _endDate!,
            goalSteps: _goalSteps!,
          );

      return calculateActivityLevelUseCase.calculateStatistics(visualizations);
    });
  }
}
