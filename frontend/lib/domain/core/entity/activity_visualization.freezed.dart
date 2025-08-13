// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_visualization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ActivityVisualization {
  /// 対象日付
  DateTime get date => throw _privateConstructorUsedError;

  /// アクティビティレベル
  ActivityLevel get level => throw _privateConstructorUsedError;

  /// 表示色
  Color get color => throw _privateConstructorUsedError;

  /// データが存在するかどうか
  bool get hasData => throw _privateConstructorUsedError;

  /// 歩数（オプション）
  int get stepCount => throw _privateConstructorUsedError;

  /// 目標達成率（0.0-1.0）
  double get goalAchievementRate => throw _privateConstructorUsedError;

  /// ツールチップテキスト
  String? get tooltip => throw _privateConstructorUsedError;

  /// Create a copy of ActivityVisualization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityVisualizationCopyWith<ActivityVisualization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityVisualizationCopyWith<$Res> {
  factory $ActivityVisualizationCopyWith(ActivityVisualization value,
          $Res Function(ActivityVisualization) then) =
      _$ActivityVisualizationCopyWithImpl<$Res, ActivityVisualization>;
  @useResult
  $Res call(
      {DateTime date,
      ActivityLevel level,
      Color color,
      bool hasData,
      int stepCount,
      double goalAchievementRate,
      String? tooltip});
}

/// @nodoc
class _$ActivityVisualizationCopyWithImpl<$Res,
        $Val extends ActivityVisualization>
    implements $ActivityVisualizationCopyWith<$Res> {
  _$ActivityVisualizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityVisualization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? level = null,
    Object? color = null,
    Object? hasData = null,
    Object? stepCount = null,
    Object? goalAchievementRate = null,
    Object? tooltip = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      hasData: null == hasData
          ? _value.hasData
          : hasData // ignore: cast_nullable_to_non_nullable
              as bool,
      stepCount: null == stepCount
          ? _value.stepCount
          : stepCount // ignore: cast_nullable_to_non_nullable
              as int,
      goalAchievementRate: null == goalAchievementRate
          ? _value.goalAchievementRate
          : goalAchievementRate // ignore: cast_nullable_to_non_nullable
              as double,
      tooltip: freezed == tooltip
          ? _value.tooltip
          : tooltip // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityVisualizationImplCopyWith<$Res>
    implements $ActivityVisualizationCopyWith<$Res> {
  factory _$$ActivityVisualizationImplCopyWith(
          _$ActivityVisualizationImpl value,
          $Res Function(_$ActivityVisualizationImpl) then) =
      __$$ActivityVisualizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      ActivityLevel level,
      Color color,
      bool hasData,
      int stepCount,
      double goalAchievementRate,
      String? tooltip});
}

/// @nodoc
class __$$ActivityVisualizationImplCopyWithImpl<$Res>
    extends _$ActivityVisualizationCopyWithImpl<$Res,
        _$ActivityVisualizationImpl>
    implements _$$ActivityVisualizationImplCopyWith<$Res> {
  __$$ActivityVisualizationImplCopyWithImpl(_$ActivityVisualizationImpl _value,
      $Res Function(_$ActivityVisualizationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityVisualization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? level = null,
    Object? color = null,
    Object? hasData = null,
    Object? stepCount = null,
    Object? goalAchievementRate = null,
    Object? tooltip = freezed,
  }) {
    return _then(_$ActivityVisualizationImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      hasData: null == hasData
          ? _value.hasData
          : hasData // ignore: cast_nullable_to_non_nullable
              as bool,
      stepCount: null == stepCount
          ? _value.stepCount
          : stepCount // ignore: cast_nullable_to_non_nullable
              as int,
      goalAchievementRate: null == goalAchievementRate
          ? _value.goalAchievementRate
          : goalAchievementRate // ignore: cast_nullable_to_non_nullable
              as double,
      tooltip: freezed == tooltip
          ? _value.tooltip
          : tooltip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ActivityVisualizationImpl extends _ActivityVisualization {
  const _$ActivityVisualizationImpl(
      {required this.date,
      required this.level,
      required this.color,
      required this.hasData,
      this.stepCount = 0,
      this.goalAchievementRate = 0.0,
      this.tooltip})
      : super._();

  /// 対象日付
  @override
  final DateTime date;

  /// アクティビティレベル
  @override
  final ActivityLevel level;

  /// 表示色
  @override
  final Color color;

  /// データが存在するかどうか
  @override
  final bool hasData;

  /// 歩数（オプション）
  @override
  @JsonKey()
  final int stepCount;

  /// 目標達成率（0.0-1.0）
  @override
  @JsonKey()
  final double goalAchievementRate;

  /// ツールチップテキスト
  @override
  final String? tooltip;

  @override
  String toString() {
    return 'ActivityVisualization(date: $date, level: $level, color: $color, hasData: $hasData, stepCount: $stepCount, goalAchievementRate: $goalAchievementRate, tooltip: $tooltip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityVisualizationImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.hasData, hasData) || other.hasData == hasData) &&
            (identical(other.stepCount, stepCount) ||
                other.stepCount == stepCount) &&
            (identical(other.goalAchievementRate, goalAchievementRate) ||
                other.goalAchievementRate == goalAchievementRate) &&
            (identical(other.tooltip, tooltip) || other.tooltip == tooltip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, level, color, hasData,
      stepCount, goalAchievementRate, tooltip);

  /// Create a copy of ActivityVisualization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityVisualizationImplCopyWith<_$ActivityVisualizationImpl>
      get copyWith => __$$ActivityVisualizationImplCopyWithImpl<
          _$ActivityVisualizationImpl>(this, _$identity);
}

abstract class _ActivityVisualization extends ActivityVisualization {
  const factory _ActivityVisualization(
      {required final DateTime date,
      required final ActivityLevel level,
      required final Color color,
      required final bool hasData,
      final int stepCount,
      final double goalAchievementRate,
      final String? tooltip}) = _$ActivityVisualizationImpl;
  const _ActivityVisualization._() : super._();

  /// 対象日付
  @override
  DateTime get date;

  /// アクティビティレベル
  @override
  ActivityLevel get level;

  /// 表示色
  @override
  Color get color;

  /// データが存在するかどうか
  @override
  bool get hasData;

  /// 歩数（オプション）
  @override
  int get stepCount;

  /// 目標達成率（0.0-1.0）
  @override
  double get goalAchievementRate;

  /// ツールチップテキスト
  @override
  String? get tooltip;

  /// Create a copy of ActivityVisualization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityVisualizationImplCopyWith<_$ActivityVisualizationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
