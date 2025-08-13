import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import '../type/activity_level_type.dart';

part 'activity_visualization.freezed.dart';

/// アクティビティ視覚化エンティティ
/// GitHubの草のような表示のための単一セルを表現する
@freezed
class ActivityVisualization with _$ActivityVisualization {
  const factory ActivityVisualization({
    /// 対象日付
    required DateTime date,

    /// アクティビティレベル
    required ActivityLevel level,

    /// 表示色
    required Color color,

    /// データが存在するかどうか
    required bool hasData,

    /// 歩数（オプション）
    @Default(0) int stepCount,

    /// 目標達成率（0.0-1.0）
    @Default(0.0) double goalAchievementRate,

    /// ツールチップテキスト
    String? tooltip,
  }) = _ActivityVisualization;

  const ActivityVisualization._();

  /// ファクトリーメソッド：HealthDataから作成
  factory ActivityVisualization.fromHealthData({
    required DateTime date,
    int stepCount = 0,
    int goalSteps = 8000,
    bool hasData = true,
  }) {
    final level = hasData
        ? ActivityLevel.fromStepCountWithGoal(stepCount, goalSteps)
        : ActivityLevel.none;

    final achievementRate = hasData && goalSteps > 0
        ? (stepCount / goalSteps).clamp(0.0, 1.0)
        : 0.0;

    final tooltip = hasData
        ? '$stepCount steps (${(achievementRate * 100).toInt()}% of goal)'
        : 'No data';

    return ActivityVisualization(
      date: date,
      level: level,
      color: level.color,
      hasData: hasData,
      stepCount: stepCount,
      goalAchievementRate: achievementRate,
      tooltip: tooltip,
    );
  }

  /// ファクトリーメソッド：データなしの場合
  factory ActivityVisualization.noData(DateTime date) {
    return ActivityVisualization(
      date: date,
      level: ActivityLevel.none,
      color: Colors.grey.shade200,
      hasData: false,
      tooltip: 'No data available',
    );
  }

  /// 日付が今日かどうかを判定
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 日付が未来かどうかを判定
  bool get isFuture {
    final now = DateTime.now();
    return date.isAfter(DateTime(now.year, now.month, now.day));
  }

  /// 週の何日目かを取得（月曜日=1, 日曜日=7）
  int get weekday => date.weekday;
}
