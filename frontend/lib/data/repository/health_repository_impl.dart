import 'dart:async';
import '../../domain/core/entity/health_data.dart';
import '../../domain/core/type/health_data_type.dart';
import '../../domain/health/repository/health_repository.dart';
import '../local/health_local_data_source.dart';
import '../api/health_api_data_source.dart';
import '../api/mock/mock_health_data.dart';

/// ヘルスデータリポジトリの実装クラス
/// ローカルデータソースとAPIデータソースを組み合わせてデータを管理する
class HealthRepositoryImpl implements HealthRepository {
  final HealthLocalDataSource _localDataSource;
  final HealthApiDataSource _apiDataSource;
  final bool _useMockData;

  // Stream controllers for real-time data
  final StreamController<HealthData?> _todayStepsController =
      StreamController<HealthData?>.broadcast();
  final StreamController<List<HealthData>> _healthDataController =
      StreamController<List<HealthData>>.broadcast();
  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  HealthRepositoryImpl({
    required HealthLocalDataSource localDataSource,
    required HealthApiDataSource apiDataSource,
    bool useMockData = true, // 開発中はモックデータを使用
  }) : _localDataSource = localDataSource,
       _apiDataSource = apiDataSource,
       _useMockData = useMockData;

  @override
  Future<List<HealthData>> getStepData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // まずローカルデータを取得
      List<HealthData> localData = await _localDataSource.getHealthDataRange(
        startDate,
        endDate,
      );

      if (_useMockData) {
        // モックデータを使用する場合
        if (localData.isEmpty) {
          // ローカルにデータがない場合はモックデータを生成して保存
          final mockData = MockHealthData.generateHealthDataRange(
            startDate,
            endDate,
          );
          await _localDataSource.saveHealthDataList(mockData);
          localData = mockData;
        }
      } else {
        // 実際のヘルスAPIを使用する場合
        if (await _apiDataSource.hasHealthPermission()) {
          final apiData = await _apiDataSource.getHealthDataRange(
            startDate,
            endDate,
          );

          // APIデータをローカルに保存
          if (apiData.isNotEmpty) {
            await _localDataSource.saveHealthDataList(apiData);
            localData = apiData;
          }
        }
      }

      return localData;
    } catch (e) {
      // エラーが発生した場合はローカルデータを返す
      return await _localDataSource.getHealthDataRange(startDate, endDate);
    }
  }

  @override
  Future<HealthData?> getTodayStepData() async {
    final today = DateTime.now();
    return await getStepDataForDate(today);
  }

  @override
  Future<HealthData?> getStepDataForDate(DateTime date) async {
    try {
      // まずローカルデータを確認
      HealthData? localData = await _localDataSource.getHealthData(date);

      if (_useMockData) {
        // モックデータを使用する場合
        if (localData == null) {
          final mockData = MockHealthData.generateHealthDataForDate(date);
          await _localDataSource.saveHealthData(mockData);
          localData = mockData;
        }
      } else {
        // 実際のヘルスAPIを使用する場合
        if (await _apiDataSource.hasHealthPermission()) {
          final apiData = await _apiDataSource.getHealthDataForDate(date);

          if (apiData != null) {
            await _localDataSource.saveHealthData(apiData);
            localData = apiData;
          }
        }
      }

      return localData;
    } catch (e) {
      // エラーが発生した場合はローカルデータを返す
      return await _localDataSource.getHealthData(date);
    }
  }

  @override
  Future<bool> requestHealthPermission() async {
    if (_useMockData) {
      // モックデータの場合は常に許可されたとする
      return true;
    }

    try {
      return await _apiDataSource.requestHealthPermission();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasHealthPermission() async {
    if (_useMockData) {
      // モックデータの場合は常に許可されたとする
      return true;
    }

    try {
      return await _apiDataSource.hasHealthPermission();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> syncHealthData() async {
    try {
      _syncStatusController.add(SyncStatus.syncing);

      if (_useMockData) {
        // モックデータの場合は過去30日間のデータを生成
        final now = DateTime.now();
        final startDate = now.subtract(const Duration(days: 30));
        final mockData = MockHealthData.generateHealthDataRange(startDate, now);
        await _localDataSource.saveHealthDataList(mockData);
      } else {
        // 実際のヘルスAPIから同期
        if (await _apiDataSource.hasHealthPermission()) {
          await _apiDataSource.syncHealthData();

          // 過去30日間のデータを取得してローカルに保存
          final now = DateTime.now();
          final startDate = now.subtract(const Duration(days: 30));
          final apiData = await _apiDataSource.getHealthDataRange(
            startDate,
            now,
          );

          if (apiData.isNotEmpty) {
            await _localDataSource.saveHealthDataList(apiData);
          }
        }
      }

      _syncStatusController.add(SyncStatus.synced);
    } catch (e) {
      _syncStatusController.add(SyncStatus.failed);
      rethrow;
    }
  }

  @override
  Stream<HealthData?> watchTodaySteps() {
    // 定期的に今日のデータを更新
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      final todayData = await getTodayStepData();
      _todayStepsController.add(todayData);
    });

    return _todayStepsController.stream;
  }

  @override
  Stream<List<HealthData>> watchHealthData({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // 定期的にデータを更新
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      final data = await getStepData(startDate: startDate, endDate: endDate);
      _healthDataController.add(data);
    });

    return _healthDataController.stream;
  }

  @override
  Stream<SyncStatus> watchSyncStatus() {
    return _syncStatusController.stream;
  }

  @override
  Future<void> clearLocalHealthData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (startDate != null && endDate != null) {
      await _localDataSource.deleteHealthDataRange(startDate, endDate);
    } else {
      await _localDataSource.clearAllHealthData();
    }
  }

  @override
  Future<Map<String, dynamic>> getHealthStatistics({
    required DateRangeType period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (_useMockData) {
        // モックデータの統計を返す
        return MockHealthData.generateStatistics();
      }

      // 実際のデータから統計を計算
      DateTime start, end;
      final now = DateTime.now();

      switch (period) {
        case DateRangeType.today:
          start = DateTime(now.year, now.month, now.day);
          end = now;
          break;
        case DateRangeType.thisWeek:
          start = now.subtract(Duration(days: now.weekday - 1));
          end = now;
          break;
        case DateRangeType.thisMonth:
          start = DateTime(now.year, now.month, 1);
          end = now;
          break;
        case DateRangeType.thisYear:
          start = DateTime(now.year, 1, 1);
          end = now;
          break;
        case DateRangeType.custom:
          start = startDate ?? now.subtract(const Duration(days: 30));
          end = endDate ?? now;
          break;
      }

      final data = await getStepData(startDate: start, endDate: end);

      if (data.isEmpty) {
        return {
          'totalDays': 0,
          'averageSteps': 0.0,
          'maxSteps': 0,
          'totalSteps': 0,
          'averageDistance': 0.0,
          'totalDistance': 0.0,
          'averageCalories': 0.0,
          'totalCalories': 0,
          'goalAchievementRate': 0.0,
        };
      }

      final totalSteps = data.fold<int>(0, (sum, item) => sum + item.stepCount);
      final maxSteps = data
          .map((item) => item.stepCount)
          .reduce((a, b) => a > b ? a : b);
      final totalDistance = data.fold<double>(
        0,
        (sum, item) => sum + item.distance,
      );
      final totalCalories = data.fold<int>(
        0,
        (sum, item) => sum + item.caloriesBurned,
      );

      const goalSteps = 8000;
      final goalAchievedDays = data
          .where((item) => item.stepCount >= goalSteps)
          .length;

      return {
        'totalDays': data.length,
        'averageSteps': totalSteps / data.length,
        'maxSteps': maxSteps,
        'totalSteps': totalSteps,
        'averageDistance': totalDistance / data.length,
        'totalDistance': totalDistance,
        'averageCalories': totalCalories / data.length,
        'totalCalories': totalCalories,
        'goalAchievementRate': goalAchievedDays / data.length,
      };
    } catch (e) {
      // エラーが発生した場合はローカルデータから統計を取得
      return await _localDataSource.getStatistics();
    }
  }

  @override
  Future<void> setBackgroundSyncEnabled(bool enabled) async {
    // バックグラウンド同期の設定（実装は省略）
    // 実際の実装では、プラットフォーム固有のバックグラウンドタスクを設定
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    // 最後の同期時間を取得（実装は省略）
    // 実際の実装では、SharedPreferencesやローカルDBから取得
    return DateTime.now().subtract(const Duration(hours: 1));
  }

  /// リソースを解放
  void dispose() {
    _todayStepsController.close();
    _healthDataController.close();
    _syncStatusController.close();
  }
}
