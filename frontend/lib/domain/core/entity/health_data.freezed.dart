// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthData _$HealthDataFromJson(Map<String, dynamic> json) {
  return _HealthData.fromJson(json);
}

/// @nodoc
mixin _$HealthData {
  /// データの日付
  DateTime get date => throw _privateConstructorUsedError;

  /// 歩数
  int get stepCount => throw _privateConstructorUsedError;

  /// 距離（km）
  double get distance => throw _privateConstructorUsedError;

  /// 消費カロリー（kcal）
  int get caloriesBurned => throw _privateConstructorUsedError;

  /// アクティビティレベル
  ActivityLevel get activityLevel => throw _privateConstructorUsedError;

  /// アクティブ時間（分）
  int get activeTime => throw _privateConstructorUsedError;

  /// 同期状態
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// 作成日時
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this HealthData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthDataCopyWith<HealthData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthDataCopyWith<$Res> {
  factory $HealthDataCopyWith(
          HealthData value, $Res Function(HealthData) then) =
      _$HealthDataCopyWithImpl<$Res, HealthData>;
  @useResult
  $Res call(
      {DateTime date,
      int stepCount,
      double distance,
      int caloriesBurned,
      ActivityLevel activityLevel,
      int activeTime,
      SyncStatus syncStatus,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$HealthDataCopyWithImpl<$Res, $Val extends HealthData>
    implements $HealthDataCopyWith<$Res> {
  _$HealthDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? stepCount = null,
    Object? distance = null,
    Object? caloriesBurned = null,
    Object? activityLevel = null,
    Object? activeTime = null,
    Object? syncStatus = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stepCount: null == stepCount
          ? _value.stepCount
          : stepCount // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      caloriesBurned: null == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as int,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      activeTime: null == activeTime
          ? _value.activeTime
          : activeTime // ignore: cast_nullable_to_non_nullable
              as int,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthDataImplCopyWith<$Res>
    implements $HealthDataCopyWith<$Res> {
  factory _$$HealthDataImplCopyWith(
          _$HealthDataImpl value, $Res Function(_$HealthDataImpl) then) =
      __$$HealthDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int stepCount,
      double distance,
      int caloriesBurned,
      ActivityLevel activityLevel,
      int activeTime,
      SyncStatus syncStatus,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$HealthDataImplCopyWithImpl<$Res>
    extends _$HealthDataCopyWithImpl<$Res, _$HealthDataImpl>
    implements _$$HealthDataImplCopyWith<$Res> {
  __$$HealthDataImplCopyWithImpl(
      _$HealthDataImpl _value, $Res Function(_$HealthDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? stepCount = null,
    Object? distance = null,
    Object? caloriesBurned = null,
    Object? activityLevel = null,
    Object? activeTime = null,
    Object? syncStatus = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$HealthDataImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stepCount: null == stepCount
          ? _value.stepCount
          : stepCount // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      caloriesBurned: null == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as int,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      activeTime: null == activeTime
          ? _value.activeTime
          : activeTime // ignore: cast_nullable_to_non_nullable
              as int,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataImpl extends _HealthData {
  const _$HealthDataImpl(
      {required this.date,
      required this.stepCount,
      required this.distance,
      required this.caloriesBurned,
      required this.activityLevel,
      this.activeTime = 0,
      this.syncStatus = SyncStatus.synced,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$HealthDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataImplFromJson(json);

  /// データの日付
  @override
  final DateTime date;

  /// 歩数
  @override
  final int stepCount;

  /// 距離（km）
  @override
  final double distance;

  /// 消費カロリー（kcal）
  @override
  final int caloriesBurned;

  /// アクティビティレベル
  @override
  final ActivityLevel activityLevel;

  /// アクティブ時間（分）
  @override
  @JsonKey()
  final int activeTime;

  /// 同期状態
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// 作成日時
  @override
  final DateTime? createdAt;

  /// 更新日時
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'HealthData(date: $date, stepCount: $stepCount, distance: $distance, caloriesBurned: $caloriesBurned, activityLevel: $activityLevel, activeTime: $activeTime, syncStatus: $syncStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.stepCount, stepCount) ||
                other.stepCount == stepCount) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.caloriesBurned, caloriesBurned) ||
                other.caloriesBurned == caloriesBurned) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.activeTime, activeTime) ||
                other.activeTime == activeTime) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      stepCount,
      distance,
      caloriesBurned,
      activityLevel,
      activeTime,
      syncStatus,
      createdAt,
      updatedAt);

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataImplCopyWith<_$HealthDataImpl> get copyWith =>
      __$$HealthDataImplCopyWithImpl<_$HealthDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataImplToJson(
      this,
    );
  }
}

abstract class _HealthData extends HealthData {
  const factory _HealthData(
      {required final DateTime date,
      required final int stepCount,
      required final double distance,
      required final int caloriesBurned,
      required final ActivityLevel activityLevel,
      final int activeTime,
      final SyncStatus syncStatus,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$HealthDataImpl;
  const _HealthData._() : super._();

  factory _HealthData.fromJson(Map<String, dynamic> json) =
      _$HealthDataImpl.fromJson;

  /// データの日付
  @override
  DateTime get date;

  /// 歩数
  @override
  int get stepCount;

  /// 距離（km）
  @override
  double get distance;

  /// 消費カロリー（kcal）
  @override
  int get caloriesBurned;

  /// アクティビティレベル
  @override
  ActivityLevel get activityLevel;

  /// アクティブ時間（分）
  @override
  int get activeTime;

  /// 同期状態
  @override
  SyncStatus get syncStatus;

  /// 作成日時
  @override
  DateTime? get createdAt;

  /// 更新日時
  @override
  DateTime? get updatedAt;

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthDataImplCopyWith<_$HealthDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
