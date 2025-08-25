// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionStatus _$SubscriptionStatusFromJson(Map<String, dynamic> json) {
  return _SubscriptionStatus.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionStatus {
  /// サブスクリプションタイプ
  SubscriptionType get type => throw _privateConstructorUsedError;

  /// アクティブ状態
  bool get isActive => throw _privateConstructorUsedError;

  /// 利用可能なプレミアム機能
  List<PremiumFeature> get availableFeatures =>
      throw _privateConstructorUsedError;

  /// 有効期限
  DateTime? get expiryDate => throw _privateConstructorUsedError;

  /// 購入日
  DateTime? get purchaseDate => throw _privateConstructorUsedError;

  /// 自動更新設定
  bool get autoRenew => throw _privateConstructorUsedError;

  /// トライアル終了日
  DateTime? get trialEndDate => throw _privateConstructorUsedError;

  /// 元のトランザクションID
  String? get originalTransactionId => throw _privateConstructorUsedError;

  /// プロダクトID
  String? get productId => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionStatusCopyWith<SubscriptionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionStatusCopyWith<$Res> {
  factory $SubscriptionStatusCopyWith(
          SubscriptionStatus value, $Res Function(SubscriptionStatus) then) =
      _$SubscriptionStatusCopyWithImpl<$Res, SubscriptionStatus>;
  @useResult
  $Res call(
      {SubscriptionType type,
      bool isActive,
      List<PremiumFeature> availableFeatures,
      DateTime? expiryDate,
      DateTime? purchaseDate,
      bool autoRenew,
      DateTime? trialEndDate,
      String? originalTransactionId,
      String? productId});
}

/// @nodoc
class _$SubscriptionStatusCopyWithImpl<$Res, $Val extends SubscriptionStatus>
    implements $SubscriptionStatusCopyWith<$Res> {
  _$SubscriptionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isActive = null,
    Object? availableFeatures = null,
    Object? expiryDate = freezed,
    Object? purchaseDate = freezed,
    Object? autoRenew = null,
    Object? trialEndDate = freezed,
    Object? originalTransactionId = freezed,
    Object? productId = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubscriptionType,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      availableFeatures: null == availableFeatures
          ? _value.availableFeatures
          : availableFeatures // ignore: cast_nullable_to_non_nullable
              as List<PremiumFeature>,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      trialEndDate: freezed == trialEndDate
          ? _value.trialEndDate
          : trialEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      originalTransactionId: freezed == originalTransactionId
          ? _value.originalTransactionId
          : originalTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionStatusImplCopyWith<$Res>
    implements $SubscriptionStatusCopyWith<$Res> {
  factory _$$SubscriptionStatusImplCopyWith(_$SubscriptionStatusImpl value,
          $Res Function(_$SubscriptionStatusImpl) then) =
      __$$SubscriptionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SubscriptionType type,
      bool isActive,
      List<PremiumFeature> availableFeatures,
      DateTime? expiryDate,
      DateTime? purchaseDate,
      bool autoRenew,
      DateTime? trialEndDate,
      String? originalTransactionId,
      String? productId});
}

/// @nodoc
class __$$SubscriptionStatusImplCopyWithImpl<$Res>
    extends _$SubscriptionStatusCopyWithImpl<$Res, _$SubscriptionStatusImpl>
    implements _$$SubscriptionStatusImplCopyWith<$Res> {
  __$$SubscriptionStatusImplCopyWithImpl(_$SubscriptionStatusImpl _value,
      $Res Function(_$SubscriptionStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isActive = null,
    Object? availableFeatures = null,
    Object? expiryDate = freezed,
    Object? purchaseDate = freezed,
    Object? autoRenew = null,
    Object? trialEndDate = freezed,
    Object? originalTransactionId = freezed,
    Object? productId = freezed,
  }) {
    return _then(_$SubscriptionStatusImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubscriptionType,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      availableFeatures: null == availableFeatures
          ? _value._availableFeatures
          : availableFeatures // ignore: cast_nullable_to_non_nullable
              as List<PremiumFeature>,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      trialEndDate: freezed == trialEndDate
          ? _value.trialEndDate
          : trialEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      originalTransactionId: freezed == originalTransactionId
          ? _value.originalTransactionId
          : originalTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionStatusImpl extends _SubscriptionStatus {
  const _$SubscriptionStatusImpl(
      {required this.type,
      required this.isActive,
      required final List<PremiumFeature> availableFeatures,
      this.expiryDate,
      this.purchaseDate,
      this.autoRenew = false,
      this.trialEndDate,
      this.originalTransactionId,
      this.productId})
      : _availableFeatures = availableFeatures,
        super._();

  factory _$SubscriptionStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionStatusImplFromJson(json);

  /// サブスクリプションタイプ
  @override
  final SubscriptionType type;

  /// アクティブ状態
  @override
  final bool isActive;

  /// 利用可能なプレミアム機能
  final List<PremiumFeature> _availableFeatures;

  /// 利用可能なプレミアム機能
  @override
  List<PremiumFeature> get availableFeatures {
    if (_availableFeatures is EqualUnmodifiableListView)
      return _availableFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableFeatures);
  }

  /// 有効期限
  @override
  final DateTime? expiryDate;

  /// 購入日
  @override
  final DateTime? purchaseDate;

  /// 自動更新設定
  @override
  @JsonKey()
  final bool autoRenew;

  /// トライアル終了日
  @override
  final DateTime? trialEndDate;

  /// 元のトランザクションID
  @override
  final String? originalTransactionId;

  /// プロダクトID
  @override
  final String? productId;

  @override
  String toString() {
    return 'SubscriptionStatus(type: $type, isActive: $isActive, availableFeatures: $availableFeatures, expiryDate: $expiryDate, purchaseDate: $purchaseDate, autoRenew: $autoRenew, trialEndDate: $trialEndDate, originalTransactionId: $originalTransactionId, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionStatusImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other._availableFeatures, _availableFeatures) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.trialEndDate, trialEndDate) ||
                other.trialEndDate == trialEndDate) &&
            (identical(other.originalTransactionId, originalTransactionId) ||
                other.originalTransactionId == originalTransactionId) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      isActive,
      const DeepCollectionEquality().hash(_availableFeatures),
      expiryDate,
      purchaseDate,
      autoRenew,
      trialEndDate,
      originalTransactionId,
      productId);

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionStatusImplCopyWith<_$SubscriptionStatusImpl> get copyWith =>
      __$$SubscriptionStatusImplCopyWithImpl<_$SubscriptionStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionStatusImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionStatus extends SubscriptionStatus {
  const factory _SubscriptionStatus(
      {required final SubscriptionType type,
      required final bool isActive,
      required final List<PremiumFeature> availableFeatures,
      final DateTime? expiryDate,
      final DateTime? purchaseDate,
      final bool autoRenew,
      final DateTime? trialEndDate,
      final String? originalTransactionId,
      final String? productId}) = _$SubscriptionStatusImpl;
  const _SubscriptionStatus._() : super._();

  factory _SubscriptionStatus.fromJson(Map<String, dynamic> json) =
      _$SubscriptionStatusImpl.fromJson;

  /// サブスクリプションタイプ
  @override
  SubscriptionType get type;

  /// アクティブ状態
  @override
  bool get isActive;

  /// 利用可能なプレミアム機能
  @override
  List<PremiumFeature> get availableFeatures;

  /// 有効期限
  @override
  DateTime? get expiryDate;

  /// 購入日
  @override
  DateTime? get purchaseDate;

  /// 自動更新設定
  @override
  bool get autoRenew;

  /// トライアル終了日
  @override
  DateTime? get trialEndDate;

  /// 元のトランザクションID
  @override
  String? get originalTransactionId;

  /// プロダクトID
  @override
  String? get productId;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionStatusImplCopyWith<_$SubscriptionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
