import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/core/entity/health_data.dart';
import '../../domain/core/type/activity_level_type.dart';
import '../../domain/core/type/health_data_type.dart' as domain_types;

/// ヘルスデータAPIデータソース
/// iOS HealthKit、Android Health Connect との連携を行う
class HealthApiDataSource {
  static final HealthApiDataSource _instance = HealthApiDataSource._internal();
  factory HealthApiDataSource() => _instance;
  HealthApiDataSource._internal();

  /// Health プラグインのインスタンス
  final Health _health = Health();

  /// 取得するヘルスデータの種類
  static const List<HealthDataType> _healthDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  /// ヘルスデータへのアクセス許可を要求
  Future<bool> requestHealthPermission() async {
    try {
      // プラットフォーム固有の権限チェック
      await _checkPlatformPermissions();

      // ヘルスデータへのアクセス許可を要求
      final bool hasPermissions =
          await _health.hasPermissions(_healthDataTypes) ?? false;

      if (!hasPermissions) {
        final bool granted = await _health.requestAuthorization(
          _healthDataTypes,
        );
        return granted;
      }

      return true;
    } catch (e) {
      throw HealthPermissionException(
        'Failed to request health permission: $e',
      );
    }
  }

  /// ヘルスデータへのアクセス許可状態を確認
  Future<bool> hasHealthPermission() async {
    try {
      return await _health.hasPermissions(_healthDataTypes) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 特定の日のヘルスデータを取得
  Future<HealthData?> getHealthDataForDate(DateTime date) async {
    try {
      if (!await hasHealthPermission()) {
        throw HealthPermissionException('Health permission not granted');
      }

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(microseconds: 1));

      final List<HealthDataPoint> healthDataPoints = await _health
          .getHealthDataFromTypes(
            types: _healthDataTypes,
            startTime: startOfDay,
            endTime: endOfDay,
          );

      if (healthDataPoints.isEmpty) {
        return null;
      }

      return _convertHealthDataPointsToEntity(healthDataPoints, date);
    } catch (e) {
      throw HealthDataException('Failed to get health data for date: $e');
    }
  }

  /// 日付範囲のヘルスデータを取得
  Future<List<HealthData>> getHealthDataRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      if (!await hasHealthPermission()) {
        throw HealthPermissionException('Health permission not granted');
      }

      final List<HealthData> result = [];

      // 日付範囲内の各日のデータを取得
      DateTime currentDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      final end = DateTime(endDate.year, endDate.month, endDate.day);

      while (!currentDate.isAfter(end)) {
        final healthData = await getHealthDataForDate(currentDate);
        if (healthData != null) {
          result.add(healthData);
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }

      return result;
    } catch (e) {
      throw HealthDataException('Failed to get health data range: $e');
    }
  }

  /// 今日のヘルスデータを取得
  Future<HealthData?> getTodayHealthData() async {
    final today = DateTime.now();
    return await getHealthDataForDate(today);
  }

  /// 最新のヘルスデータを取得
  Future<HealthData?> getLatestHealthData() async {
    try {
      if (!await hasHealthPermission()) {
        throw HealthPermissionException('Health permission not granted');
      }

      final now = DateTime.now();
      final startTime = now.subtract(const Duration(days: 7)); // 過去7日間から検索

      final List<HealthDataPoint> healthDataPoints = await _health
          .getHealthDataFromTypes(
            types: _healthDataTypes,
            startTime: startTime,
            endTime: now,
          );

      if (healthDataPoints.isEmpty) {
        return null;
      }

      // 最新の日付でグループ化
      final Map<String, List<HealthDataPoint>> groupedByDate = {};
      for (final point in healthDataPoints) {
        final dateKey = _getDateKey(point.dateFrom);
        groupedByDate[dateKey] ??= [];
        groupedByDate[dateKey]!.add(point);
      }

      // 最新の日付のデータを取得
      final latestDateKey = groupedByDate.keys.reduce(
        (a, b) => a.compareTo(b) > 0 ? a : b,
      );
      final latestPoints = groupedByDate[latestDateKey]!;
      final latestDate = DateTime.parse(latestDateKey);

      return _convertHealthDataPointsToEntity(latestPoints, latestDate);
    } catch (e) {
      throw HealthDataException('Failed to get latest health data: $e');
    }
  }

  /// ヘルスデータの同期
  Future<void> syncHealthData() async {
    try {
      if (!await hasHealthPermission()) {
        throw HealthPermissionException('Health permission not granted');
      }

      // 過去30日間のデータを同期
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));

      await getHealthDataRange(startDate, now);
    } catch (e) {
      throw HealthDataException('Failed to sync health data: $e');
    }
  }

  /// プラットフォーム固有の権限をチェック
  Future<void> _checkPlatformPermissions() async {
    // Android の場合、追加の権限が必要な場合がある
    if (await Permission.activityRecognition.isDenied) {
      await Permission.activityRecognition.request();
    }
  }

  /// HealthDataPoint のリストを HealthData エンティティに変換
  HealthData _convertHealthDataPointsToEntity(
    List<HealthDataPoint> healthDataPoints,
    DateTime date,
  ) {
    int stepCount = 0;
    double distance = 0.0;
    int caloriesBurned = 0;
    int activeTime = 0;

    for (final point in healthDataPoints) {
      switch (point.type) {
        case HealthDataType.STEPS:
          stepCount += (point.value as NumericHealthValue).numericValue.toInt();
          break;
        case HealthDataType.DISTANCE_WALKING_RUNNING:
          distance += (point.value as NumericHealthValue).numericValue;
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          caloriesBurned += (point.value as NumericHealthValue).numericValue
              .toInt();
          break;
        default:
          break;
      }
    }

    // 距離をメートルからキロメートルに変換
    distance = distance / 1000;

    // アクティビティレベルを計算
    final activityLevel = ActivityLevel.fromStepCount(stepCount);

    return HealthData(
      date: date,
      stepCount: stepCount,
      distance: distance,
      caloriesBurned: caloriesBurned,
      activityLevel: activityLevel,
      activeTime: activeTime,
      syncStatus: domain_types.SyncStatus.synced,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 日付からキーを生成
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// ヘルスデータ関連の例外クラス
class HealthDataException implements Exception {
  final String message;
  const HealthDataException(this.message);

  @override
  String toString() => 'HealthDataException: $message';
}

/// ヘルスデータ権限関連の例外クラス
class HealthPermissionException implements Exception {
  final String message;
  const HealthPermissionException(this.message);

  @override
  String toString() => 'HealthPermissionException: $message';
}
