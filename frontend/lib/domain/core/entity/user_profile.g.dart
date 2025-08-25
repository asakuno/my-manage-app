// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dailyStepGoal: (json['dailyStepGoal'] as num).toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      age: (json['age'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      timezone: json['timezone'] as String? ?? 'UTC',
      language: json['language'] as String? ?? 'en',
      privacyLevel:
          $enumDecodeNullable(_$PrivacyLevelEnumMap, json['privacyLevel']) ??
              PrivacyLevel.friends,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'dailyStepGoal': instance.dailyStepGoal,
      'avatarUrl': instance.avatarUrl,
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'timezone': instance.timezone,
      'language': instance.language,
      'privacyLevel': _$PrivacyLevelEnumMap[instance.privacyLevel]!,
      'notificationsEnabled': instance.notificationsEnabled,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PrivacyLevelEnumMap = {
  PrivacyLevel.public: 'public',
  PrivacyLevel.friends: 'friends',
  PrivacyLevel.private: 'private',
};
