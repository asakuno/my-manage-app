import 'package:hive/hive.dart';
import '../../../domain/core/entity/health_data.dart';
import '../../../domain/core/type/activity_level_type.dart';
import '../../../domain/core/type/health_data_type.dart';

part 'health_data_model.g.dart';

/// ヘルスデータのHiveモデル
/// ローカルストレージに保存するためのデータモデル
@HiveType(typeId: 0)
class HealthDataModel extends HiveObject {
  /// データの日付（ISO 8601形式）
  @HiveField(0)
  late String date;

  /// 歩数
  @HiveField(1)
  late int stepCount;

  /// 距離（km）
  @HiveField(2)
  late double distance;

  /// 消費カロリー（kcal）
  @HiveField(3)
  late int caloriesBurned;

  /// アクティビティレベル（0-4）
  @HiveField(4)
  late int activityLevel;

  /// アクティブ時間（分）
  @HiveField(5)
  late int activeTime;

  /// 同期状態
  @HiveField(6)
  late String syncStatus;

  /// 作成日時（ISO 8601形式）
  @HiveField(7)
  String? createdAt;

  /// 更新日時（ISO 8601形式）
  @HiveField(8)
  String? updatedAt;

  HealthDataModel();

  /// エンティティからモデルを作成
  HealthDataModel.fromEntity(HealthData entity) {
    date = entity.date.toIso8601String();
    stepCount = entity.stepCount;
    distance = entity.distance;
    caloriesBurned = entity.caloriesBurned;
    activityLevel = entity.activityLevel.level;
    activeTime = entity.activeTime;
    syncStatus = entity.syncStatus.id;
    createdAt = entity.createdAt?.toIso8601String();
    updatedAt = entity.updatedAt?.toIso8601String();
  }

  /// モデルからエンティティを作成
  HealthData toEntity() {
    return HealthData(
      date: DateTime.parse(date),
      stepCount: stepCount,
      distance: distance,
      caloriesBurned: caloriesBurned,
      activityLevel: ActivityLevel.values.firstWhere(
        (level) => level.level == activityLevel,
        orElse: () => ActivityLevel.none,
      ),
      activeTime: activeTime,
      syncStatus: SyncStatus.values.firstWhere(
        (status) => status.id == syncStatus,
        orElse: () => SyncStatus.synced,
      ),
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// JSONからモデルを作成
  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    final model = HealthDataModel();
    model.date = json['date'] as String;
    model.stepCount = json['stepCount'] as int;
    model.distance = (json['distance'] as num).toDouble();
    model.caloriesBurned = json['caloriesBurned'] as int;
    model.activityLevel = json['activityLevel'] as int;
    model.activeTime = json['activeTime'] as int? ?? 0;
    model.syncStatus = json['syncStatus'] as String? ?? SyncStatus.synced.id;
    model.createdAt = json['createdAt'] as String?;
    model.updatedAt = json['updatedAt'] as String?;
    return model;
  }

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'stepCount': stepCount,
      'distance': distance,
      'caloriesBurned': caloriesBurned,
      'activityLevel': activityLevel,
      'activeTime': activeTime,
      'syncStatus': syncStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'HealthDataModel(date: $date, stepCount: $stepCount, distance: $distance, '
        'caloriesBurned: $caloriesBurned, activityLevel: $activityLevel, '
        'activeTime: $activeTime, syncStatus: $syncStatus)';
  }
}
