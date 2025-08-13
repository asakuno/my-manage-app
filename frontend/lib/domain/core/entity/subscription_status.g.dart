// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionStatusImpl _$$SubscriptionStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionStatusImpl(
      type: $enumDecode(_$SubscriptionTypeEnumMap, json['type']),
      isActive: json['isActive'] as bool,
      availableFeatures: (json['availableFeatures'] as List<dynamic>)
          .map((e) => $enumDecode(_$PremiumFeatureEnumMap, e))
          .toList(),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      autoRenew: json['autoRenew'] as bool? ?? false,
      trialEndDate: json['trialEndDate'] == null
          ? null
          : DateTime.parse(json['trialEndDate'] as String),
      originalTransactionId: json['originalTransactionId'] as String?,
      productId: json['productId'] as String?,
    );

Map<String, dynamic> _$$SubscriptionStatusImplToJson(
        _$SubscriptionStatusImpl instance) =>
    <String, dynamic>{
      'type': _$SubscriptionTypeEnumMap[instance.type]!,
      'isActive': instance.isActive,
      'availableFeatures': instance.availableFeatures
          .map((e) => _$PremiumFeatureEnumMap[e]!)
          .toList(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'trialEndDate': instance.trialEndDate?.toIso8601String(),
      'originalTransactionId': instance.originalTransactionId,
      'productId': instance.productId,
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.free: 'free',
  SubscriptionType.premium: 'premium',
};

const _$PremiumFeatureEnumMap = {
  PremiumFeature.detailedAnalytics: 'detailedAnalytics',
  PremiumFeature.dataExport: 'dataExport',
  PremiumFeature.adFree: 'adFree',
  PremiumFeature.unlimitedFriends: 'unlimitedFriends',
  PremiumFeature.customGoals: 'customGoals',
};
