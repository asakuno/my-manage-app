import 'dart:math';
import '../../../domain/core/entity/health_data.dart';
import '../../../domain/core/type/activity_level_type.dart';
import '../../../domain/core/type/health_data_type.dart';

/// モックヘルスデータクラス
/// 開発・テスト用のサンプルヘルスデータを提供する
class MockHealthData {
  static final Random _random = Random();

  /// 特定の日のモックヘルスデータを生成
  static HealthData generateHealthDataForDate(DateTime date) {
    // 曜日や日付に基づいてある程度現実的なデータを生成
    final dayOfWeek = date.weekday;
    final isWeekend =
        dayOfWeek == DateTime.saturday || dayOfWeek == DateTime.sunday;
    final isToday = _isToday(date);
    final isFuture = date.isAfter(DateTime.now());

    // 未来の日付の場合はデータなし
    if (isFuture) {
      return HealthData(
        date: date,
        stepCount: 0,
        distance: 0.0,
        caloriesBurned: 0,
        activityLevel: ActivityLevel.none,
        activeTime: 0,
        syncStatus: SyncStatus.synced,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // 基本歩数を設定（平日は多め、週末は少なめ）
    int baseSteps;
    if (isWeekend) {
      baseSteps = 3000 + _random.nextInt(8000); // 3000-11000歩
    } else {
      baseSteps = 5000 + _random.nextInt(10000); // 5000-15000歩
    }

    // 今日の場合は時間に応じて調整
    int stepCount = baseSteps;
    if (isToday) {
      final hour = DateTime.now().hour;
      final progressRatio = hour / 24.0;
      stepCount = (baseSteps * progressRatio).round();
    }

    // 距離を計算（歩数から推定）
    final distance = stepCount * 0.0008; // 1歩約0.8m

    // 消費カロリーを計算（歩数から推定）
    final caloriesBurned = (stepCount * 0.04).round(); // 1歩約0.04kcal

    // アクティブ時間を計算（歩数から推定）
    final activeTime = (stepCount / 100).round(); // 100歩で1分程度

    // アクティビティレベルを計算
    final activityLevel = ActivityLevel.fromStepCount(stepCount);

    // 同期状態をランダムに設定（ほとんどは同期済み）
    final syncStatus = _random.nextDouble() < 0.95
        ? SyncStatus.synced
        : SyncStatus.pending;

    return HealthData(
      date: date,
      stepCount: stepCount,
      distance: distance,
      caloriesBurned: caloriesBurned,
      activityLevel: activityLevel,
      activeTime: activeTime,
      syncStatus: syncStatus,
      createdAt: date.add(Duration(hours: _random.nextInt(24))),
      updatedAt: DateTime.now(),
    );
  }

  /// 日付範囲のモックヘルスデータを生成
  static List<HealthData> generateHealthDataRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final List<HealthData> result = [];

    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!currentDate.isAfter(end)) {
      // 90%の確率でデータを生成（たまにデータがない日を作る）
      if (_random.nextDouble() < 0.9) {
        result.add(generateHealthDataForDate(currentDate));
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return result;
  }

  /// 過去30日間のモックヘルスデータを生成
  static List<HealthData> generateLast30DaysData() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 30));
    final endDate = now.subtract(const Duration(days: 1));
    return generateHealthDataRange(startDate, endDate);
  }

  /// 過去7日間のモックヘルスデータを生成
  static List<HealthData> generateLast7DaysData() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));
    final endDate = now.subtract(const Duration(days: 1));
    return generateHealthDataRange(startDate, endDate);
  }

  /// 今年のモックヘルスデータを生成
  static List<HealthData> generateThisYearData() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    return generateHealthDataRange(startOfYear, now);
  }

  /// 高アクティビティユーザーのデータを生成
  static HealthData generateHighActivityData(DateTime date) {
    final stepCount = 10000 + _random.nextInt(5000); // 10000-15000歩
    final distance = stepCount * 0.0008;
    final caloriesBurned = (stepCount * 0.04).round();
    final activeTime = (stepCount / 80).round(); // より活発

    return HealthData(
      date: date,
      stepCount: stepCount,
      distance: distance,
      caloriesBurned: caloriesBurned,
      activityLevel: ActivityLevel.fromStepCount(stepCount),
      activeTime: activeTime,
      syncStatus: SyncStatus.synced,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 低アクティビティユーザーのデータを生成
  static HealthData generateLowActivityData(DateTime date) {
    final stepCount = 1000 + _random.nextInt(3000); // 1000-4000歩
    final distance = stepCount * 0.0008;
    final caloriesBurned = (stepCount * 0.04).round();
    final activeTime = (stepCount / 120).round(); // あまり活発でない

    return HealthData(
      date: date,
      stepCount: stepCount,
      distance: distance,
      caloriesBurned: caloriesBurned,
      activityLevel: ActivityLevel.fromStepCount(stepCount),
      activeTime: activeTime,
      syncStatus: SyncStatus.synced,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 統計用のサンプルデータを生成
  static Map<String, dynamic> generateStatistics() {
    final data = generateLast30DaysData();

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
  }

  /// 同期が必要なデータを生成
  static List<HealthData> generatePendingSyncData() {
    final List<HealthData> result = [];
    final now = DateTime.now();

    // 過去3日間で同期が必要なデータを生成
    for (int i = 0; i < 3; i++) {
      final date = now.subtract(Duration(days: i));
      final data = generateHealthDataForDate(date);
      result.add(data.copyWith(syncStatus: SyncStatus.pending));
    }

    return result;
  }

  /// 日付が今日かどうかを判定
  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
