// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthDataImpl _$$HealthDataImplFromJson(Map<String, dynamic> json) =>
    _$HealthDataImpl(
      date: DateTime.parse(json['date'] as String),
      stepCount: (json['stepCount'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      caloriesBurned: (json['caloriesBurned'] as num).toInt(),
      activityLevel: $enumDecode(_$ActivityLevelEnumMap, json['activityLevel']),
      activeTime: (json['activeTime'] as num?)?.toInt() ?? 0,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$HealthDataImplToJson(_$HealthDataImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'stepCount': instance.stepCount,
      'distance': instance.distance,
      'caloriesBurned': instance.caloriesBurned,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
      'activeTime': instance.activeTime,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ActivityLevelEnumMap = {
  ActivityLevel.none: 'none',
  ActivityLevel.low: 'low',
  ActivityLevel.medium: 'medium',
  ActivityLevel.high: 'high',
  ActivityLevel.veryHigh: 'veryHigh',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.syncing: 'syncing',
  SyncStatus.failed: 'failed',
  SyncStatus.pending: 'pending',
};
