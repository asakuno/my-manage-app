import 'package:flutter/material.dart';

/// アクティビティレベルを表すEnum
/// 歩数に基づいて色の濃さを決定する
enum ActivityLevel {
  /// データなし（0歩）
  none(0, Colors.grey),

  /// 低レベル（1-2000歩）
  low(1, Color(0xFFE8F5E8)),

  /// 中レベル（2001-5000歩）
  medium(2, Color(0xFFB8E6B8)),

  /// 高レベル（5001-8000歩）
  high(3, Color(0xFF7DD87D)),

  /// 最高レベル（8001歩以上）
  veryHigh(4, Color(0xFF4CAF50));

  const ActivityLevel(this.level, this.color);

  /// レベル値（0-4）
  final int level;

  /// 表示色
  final Color color;

  /// 歩数からアクティビティレベルを計算
  static ActivityLevel fromStepCount(int stepCount) {
    if (stepCount == 0) return ActivityLevel.none;
    if (stepCount <= 2000) return ActivityLevel.low;
    if (stepCount <= 5000) return ActivityLevel.medium;
    if (stepCount <= 8000) return ActivityLevel.high;
    return ActivityLevel.veryHigh;
  }

  /// 目標歩数に基づいてアクティビティレベルを計算
  static ActivityLevel fromStepCountWithGoal(int stepCount, int goalSteps) {
    if (stepCount == 0) return ActivityLevel.none;

    final percentage = stepCount / goalSteps;
    if (percentage <= 0.25) return ActivityLevel.low;
    if (percentage <= 0.625) return ActivityLevel.medium;
    if (percentage <= 1.0) return ActivityLevel.high;
    return ActivityLevel.veryHigh;
  }
}
