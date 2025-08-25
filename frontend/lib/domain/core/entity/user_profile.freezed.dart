// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  /// ユーザーID
  String get id => throw _privateConstructorUsedError;

  /// 表示名
  String get name => throw _privateConstructorUsedError;

  /// メールアドレス
  String get email => throw _privateConstructorUsedError;

  /// 1日の歩数目標
  int get dailyStepGoal => throw _privateConstructorUsedError;

  /// アバター画像URL
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// 年齢
  int? get age => throw _privateConstructorUsedError;

  /// 身長（cm）
  double? get height => throw _privateConstructorUsedError;

  /// 体重（kg）
  double? get weight => throw _privateConstructorUsedError;

  /// タイムゾーン
  String get timezone => throw _privateConstructorUsedError;

  /// 言語設定
  String get language => throw _privateConstructorUsedError;

  /// プライバシーレベル
  PrivacyLevel get privacyLevel => throw _privateConstructorUsedError;

  /// 通知設定
  bool get notificationsEnabled => throw _privateConstructorUsedError;

  /// 作成日時
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      int dailyStepGoal,
      String? avatarUrl,
      int? age,
      double? height,
      double? weight,
      String timezone,
      String language,
      PrivacyLevel privacyLevel,
      bool notificationsEnabled,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? dailyStepGoal = null,
    Object? avatarUrl = freezed,
    Object? age = freezed,
    Object? height = freezed,
    Object? weight = freezed,
    Object? timezone = null,
    Object? language = null,
    Object? privacyLevel = null,
    Object? notificationsEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      dailyStepGoal: null == dailyStepGoal
          ? _value.dailyStepGoal
          : dailyStepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      privacyLevel: null == privacyLevel
          ? _value.privacyLevel
          : privacyLevel // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      int dailyStepGoal,
      String? avatarUrl,
      int? age,
      double? height,
      double? weight,
      String timezone,
      String language,
      PrivacyLevel privacyLevel,
      bool notificationsEnabled,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? dailyStepGoal = null,
    Object? avatarUrl = freezed,
    Object? age = freezed,
    Object? height = freezed,
    Object? weight = freezed,
    Object? timezone = null,
    Object? language = null,
    Object? privacyLevel = null,
    Object? notificationsEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      dailyStepGoal: null == dailyStepGoal
          ? _value.dailyStepGoal
          : dailyStepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      privacyLevel: null == privacyLevel
          ? _value.privacyLevel
          : privacyLevel // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.name,
      required this.email,
      required this.dailyStepGoal,
      this.avatarUrl,
      this.age,
      this.height,
      this.weight,
      this.timezone = 'UTC',
      this.language = 'en',
      this.privacyLevel = PrivacyLevel.friends,
      this.notificationsEnabled = true,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  /// ユーザーID
  @override
  final String id;

  /// 表示名
  @override
  final String name;

  /// メールアドレス
  @override
  final String email;

  /// 1日の歩数目標
  @override
  final int dailyStepGoal;

  /// アバター画像URL
  @override
  final String? avatarUrl;

  /// 年齢
  @override
  final int? age;

  /// 身長（cm）
  @override
  final double? height;

  /// 体重（kg）
  @override
  final double? weight;

  /// タイムゾーン
  @override
  @JsonKey()
  final String timezone;

  /// 言語設定
  @override
  @JsonKey()
  final String language;

  /// プライバシーレベル
  @override
  @JsonKey()
  final PrivacyLevel privacyLevel;

  /// 通知設定
  @override
  @JsonKey()
  final bool notificationsEnabled;

  /// 作成日時
  @override
  final DateTime? createdAt;

  /// 更新日時
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, dailyStepGoal: $dailyStepGoal, avatarUrl: $avatarUrl, age: $age, height: $height, weight: $weight, timezone: $timezone, language: $language, privacyLevel: $privacyLevel, notificationsEnabled: $notificationsEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.dailyStepGoal, dailyStepGoal) ||
                other.dailyStepGoal == dailyStepGoal) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.privacyLevel, privacyLevel) ||
                other.privacyLevel == privacyLevel) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      dailyStepGoal,
      avatarUrl,
      age,
      height,
      weight,
      timezone,
      language,
      privacyLevel,
      notificationsEnabled,
      createdAt,
      updatedAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String name,
      required final String email,
      required final int dailyStepGoal,
      final String? avatarUrl,
      final int? age,
      final double? height,
      final double? weight,
      final String timezone,
      final String language,
      final PrivacyLevel privacyLevel,
      final bool notificationsEnabled,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  /// ユーザーID
  @override
  String get id;

  /// 表示名
  @override
  String get name;

  /// メールアドレス
  @override
  String get email;

  /// 1日の歩数目標
  @override
  int get dailyStepGoal;

  /// アバター画像URL
  @override
  String? get avatarUrl;

  /// 年齢
  @override
  int? get age;

  /// 身長（cm）
  @override
  double? get height;

  /// 体重（kg）
  @override
  double? get weight;

  /// タイムゾーン
  @override
  String get timezone;

  /// 言語設定
  @override
  String get language;

  /// プライバシーレベル
  @override
  PrivacyLevel get privacyLevel;

  /// 通知設定
  @override
  bool get notificationsEnabled;

  /// 作成日時
  @override
  DateTime? get createdAt;

  /// 更新日時
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
