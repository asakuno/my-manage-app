import 'package:freezed_annotation/freezed_annotation.dart';
import '../type/activity_level_type.dart';
import '../type/health_data_type.dart';

part 'health_data.freezed.dart';
part 'health_data.g.dart';

/// ヘルスデータエンティティ
/// 特定の日のヘルスデータを表現する
@freezed
class HealthData with _$HealthData {
  const factory HealthData({
    /// データの日付
    required DateTime date,

    /// 歩数
    required int stepCount,

    /// 距離（km）
    required double distance,

    /// 消費カロリー（kcal）
    required int caloriesBurned,

    /// アクティビティレベル
    required ActivityLevel activityLevel,

    /// アクティブ時間（分）
    @Default(0) int activeTime,

    /// 同期状態
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// 作成日時
    DateTime? createdAt,

    /// 更新日時
    DateTime? updatedAt,
  }) = _HealthData;

  const HealthData._();

  factory HealthData.fromJson(Map<String, dynamic> json) =>
      _$HealthDataFromJson(json);

  /// 目標歩数に対する達成率を計算
  double getAchievementRate(int goalSteps) {
    if (goalSteps <= 0) return 0.0;
    return (stepCount / goalSteps).clamp(0.0, 1.0);
  }

  /// データが有効かどうかを判定
  bool get isValid => stepCount >= 0 && distance >= 0 && caloriesBurned >= 0;

  /// データが今日のものかどうかを判定
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
