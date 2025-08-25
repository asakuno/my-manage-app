import 'package:hive/hive.dart';
import '../../../domain/core/entity/user_profile.dart';

part 'user_profile_model.g.dart';

/// ユーザープロフィールのHiveモデル
/// ローカルストレージに保存するためのデータモデル
@HiveType(typeId: 2)
class UserProfileModel extends HiveObject {
  /// ユーザーID
  @HiveField(0)
  late String id;

  /// 表示名
  @HiveField(1)
  late String name;

  /// メールアドレス
  @HiveField(2)
  late String email;

  /// 1日の歩数目標
  @HiveField(3)
  late int dailyStepGoal;

  /// アバター画像URL
  @HiveField(4)
  String? avatarUrl;

  /// 年齢
  @HiveField(5)
  int? age;

  /// 身長（cm）
  @HiveField(6)
  double? height;

  /// 体重（kg）
  @HiveField(7)
  double? weight;

  /// タイムゾーン
  @HiveField(8)
  late String timezone;

  /// 言語設定
  @HiveField(9)
  late String language;

  /// プライバシーレベル
  @HiveField(10)
  late String privacyLevel;

  /// 通知設定
  @HiveField(11)
  late bool notificationsEnabled;

  /// 作成日時（ISO 8601形式）
  @HiveField(12)
  String? createdAt;

  /// 更新日時（ISO 8601形式）
  @HiveField(13)
  String? updatedAt;

  UserProfileModel();

  /// エンティティからモデルを作成
  UserProfileModel.fromEntity(UserProfile entity) {
    id = entity.id;
    name = entity.name;
    email = entity.email;
    dailyStepGoal = entity.dailyStepGoal;
    avatarUrl = entity.avatarUrl;
    age = entity.age;
    height = entity.height;
    weight = entity.weight;
    timezone = entity.timezone;
    language = entity.language;
    privacyLevel = entity.privacyLevel.id;
    notificationsEnabled = entity.notificationsEnabled;
    createdAt = entity.createdAt?.toIso8601String();
    updatedAt = entity.updatedAt?.toIso8601String();
  }

  /// モデルからエンティティを作成
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      dailyStepGoal: dailyStepGoal,
      avatarUrl: avatarUrl,
      age: age,
      height: height,
      weight: weight,
      timezone: timezone,
      language: language,
      privacyLevel: PrivacyLevel.values.firstWhere(
        (level) => level.id == privacyLevel,
        orElse: () => PrivacyLevel.friends,
      ),
      notificationsEnabled: notificationsEnabled,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// JSONからモデルを作成
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final model = UserProfileModel();
    model.id = json['id'] as String;
    model.name = json['name'] as String;
    model.email = json['email'] as String;
    model.dailyStepGoal = json['dailyStepGoal'] as int;
    model.avatarUrl = json['avatarUrl'] as String?;
    model.age = json['age'] as int?;
    model.height = (json['height'] as num?)?.toDouble();
    model.weight = (json['weight'] as num?)?.toDouble();
    model.timezone = json['timezone'] as String? ?? 'UTC';
    model.language = json['language'] as String? ?? 'en';
    model.privacyLevel =
        json['privacyLevel'] as String? ?? PrivacyLevel.friends.id;
    model.notificationsEnabled = json['notificationsEnabled'] as bool? ?? true;
    model.createdAt = json['createdAt'] as String?;
    model.updatedAt = json['updatedAt'] as String?;
    return model;
  }

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dailyStepGoal': dailyStepGoal,
      'avatarUrl': avatarUrl,
      'age': age,
      'height': height,
      'weight': weight,
      'timezone': timezone,
      'language': language,
      'privacyLevel': privacyLevel,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'UserProfileModel(id: $id, name: $name, email: $email, '
        'dailyStepGoal: $dailyStepGoal, avatarUrl: $avatarUrl, '
        'age: $age, height: $height, weight: $weight, '
        'timezone: $timezone, language: $language, '
        'privacyLevel: $privacyLevel, notificationsEnabled: $notificationsEnabled)';
  }
}
