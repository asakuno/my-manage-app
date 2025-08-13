import '../../core/entity/health_data.dart';
import '../../core/entity/activity_visualization.dart';
import '../../core/type/activity_level_type.dart';

/// アクティビティレベル計算ユースケース
/// 歩数データからアクティビティレベルを計算し、視覚化データを生成する
class CalculateActivityLevelUseCase {
  const CalculateActivityLevelUseCase();

  /// 歩数からアクティビティレベルを計算
  /// [stepCount] 歩数
  /// [goalSteps] 目標歩数（デフォルト: 8000歩）
  /// Returns: 計算されたActivityLevel
  ActivityLevel calculateLevel(int stepCount, {int goalSteps = 8000}) {
    if (stepCount < 0) {
      throw ArgumentError('Step count cannot be negative');
    }

    if (goalSteps <= 0) {
      throw ArgumentError('Goal steps must be positive');
    }

    return ActivityLevel.fromStepCountWithGoal(stepCount, goalSteps);
  }

  /// HealthDataからActivityVisualizationを生成
  /// [healthData] ヘルスデータ
  /// [goalSteps] 目標歩数（デフォルト: 8000歩）
  /// Returns: 生成されたActivityVisualization
  ActivityVisualization createVisualization(
    HealthData healthData, {
    int goalSteps = 8000,
  }) {
    return ActivityVisualization.fromHealthData(
      date: healthData.date,
      stepCount: healthData.stepCount,
      goalSteps: goalSteps,
      hasData: true,
    );
  }

  /// 日付範囲のActivityVisualizationリストを生成
  /// [healthDataList] ヘルスデータのリスト
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// [goalSteps] 目標歩数（デフォルト: 8000歩）
  /// Returns: ActivityVisualizationのリスト
  List<ActivityVisualization> createVisualizationList({
    required List<HealthData> healthDataList,
    required DateTime startDate,
    required DateTime endDate,
    int goalSteps = 8000,
  }) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    // HealthDataをMapに変換（日付をキーとする）
    final healthDataMap = <DateTime, HealthData>{};
    for (final data in healthDataList) {
      final dateKey = DateTime(data.date.year, data.date.month, data.date.day);
      healthDataMap[dateKey] = data;
    }

    final visualizations = <ActivityVisualization>[];
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final endDateNormalized = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    while (!currentDate.isAfter(endDateNormalized)) {
      final healthData = healthDataMap[currentDate];

      if (healthData != null) {
        visualizations.add(
          createVisualization(healthData, goalSteps: goalSteps),
        );
      } else {
        visualizations.add(ActivityVisualization.noData(currentDate));
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return visualizations;
  }

  /// GitHub風カレンダー表示用の週間グリッドを生成
  /// [year] 年
  /// [healthDataList] ヘルスデータのリスト
  /// [goalSteps] 目標歩数（デフォルト: 8000歩）
  /// Returns: 週ごとのActivityVisualizationリストのリスト
  List<List<ActivityVisualization>> createYearlyGrid({
    required int year,
    required List<HealthData> healthDataList,
    int goalSteps = 8000,
  }) {
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);

    // 年間のvisualizationを生成
    final yearlyVisualizations = createVisualizationList(
      healthDataList: healthDataList,
      startDate: startDate,
      endDate: endDate,
      goalSteps: goalSteps,
    );

    // 週ごとにグループ化
    final weeks = <List<ActivityVisualization>>[];
    var currentWeek = <ActivityVisualization>[];

    // 年始の曜日を取得（月曜日=1, 日曜日=7）
    final firstDayWeekday = startDate.weekday;

    // 年始が月曜日でない場合、前の週の空白日を追加
    for (int i = 1; i < firstDayWeekday; i++) {
      final emptyDate = startDate.subtract(Duration(days: firstDayWeekday - i));
      currentWeek.add(ActivityVisualization.noData(emptyDate));
    }

    // 年間データを週ごとに分割
    for (final visualization in yearlyVisualizations) {
      currentWeek.add(visualization);

      // 日曜日（weekday=7）で週を区切る
      if (visualization.date.weekday == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    // 最後の週が不完全な場合、空白日で埋める
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        final lastDate = currentWeek.last.date;
        final nextDate = lastDate.add(const Duration(days: 1));
        currentWeek.add(ActivityVisualization.noData(nextDate));
      }
      weeks.add(currentWeek);
    }

    return weeks;
  }

  /// アクティビティレベルの統計を計算
  /// [visualizations] ActivityVisualizationのリスト
  /// Returns: 統計データのMap
  Map<String, dynamic> calculateStatistics(
    List<ActivityVisualization> visualizations,
  ) {
    final dataWithSteps = visualizations.where((v) => v.hasData).toList();

    if (dataWithSteps.isEmpty) {
      return {
        'totalDays': 0,
        'activeDays': 0,
        'totalSteps': 0,
        'averageSteps': 0.0,
        'maxSteps': 0,
        'levelDistribution': <ActivityLevel, int>{},
        'streakDays': 0,
        'goalAchievementRate': 0.0,
      };
    }

    final totalSteps = dataWithSteps.fold<int>(
      0,
      (sum, v) => sum + v.stepCount,
    );

    final averageSteps = totalSteps / dataWithSteps.length;
    final maxSteps = dataWithSteps
        .map((v) => v.stepCount)
        .reduce((a, b) => a > b ? a : b);

    // レベル別の分布を計算
    final levelDistribution = <ActivityLevel, int>{};
    for (final level in ActivityLevel.values) {
      levelDistribution[level] = dataWithSteps
          .where((v) => v.level == level)
          .length;
    }

    // 連続日数を計算
    int streakDays = 0;
    int currentStreak = 0;
    for (final visualization in visualizations.reversed) {
      if (visualization.hasData && visualization.stepCount > 0) {
        currentStreak++;
      } else {
        if (currentStreak > streakDays) {
          streakDays = currentStreak;
        }
        currentStreak = 0;
      }
    }
    if (currentStreak > streakDays) {
      streakDays = currentStreak;
    }

    // 目標達成率を計算
    final goalAchievedDays = dataWithSteps
        .where((v) => v.goalAchievementRate >= 1.0)
        .length;
    final goalAchievementRate = goalAchievedDays / dataWithSteps.length;

    return {
      'totalDays': visualizations.length,
      'activeDays': dataWithSteps.length,
      'totalSteps': totalSteps,
      'averageSteps': averageSteps,
      'maxSteps': maxSteps,
      'levelDistribution': levelDistribution,
      'streakDays': streakDays,
      'goalAchievementRate': goalAchievementRate,
    };
  }
}
