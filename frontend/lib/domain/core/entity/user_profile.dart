import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// プライバシーレベルを表すEnum
enum PrivacyLevel {
  /// 公開
  @JsonValue('public')
  public('public', 'Public'),

  /// 友達のみ
  @JsonValue('friends')
  friends('friends', 'Friends Only'),

  /// 非公開
  @JsonValue('private')
  private('private', 'Private');

  const PrivacyLevel(this.id, this.displayName);

  /// プライバシーレベルID
  final String id;

  /// 表示名
  final String displayName;
}

/// ユーザープロフィールエンティティ
/// ユーザーの基本情報と設定を管理する
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    /// ユーザーID
    required String id,

    /// 表示名
    required String name,

    /// メールアドレス
    required String email,

    /// 1日の歩数目標
    required int dailyStepGoal,

    /// アバター画像URL
    String? avatarUrl,

    /// 年齢
    int? age,

    /// 身長（cm）
    double? height,

    /// 体重（kg）
    double? weight,

    /// タイムゾーン
    @Default('UTC') String timezone,

    /// 言語設定
    @Default('en') String language,

    /// プライバシーレベル
    @Default(PrivacyLevel.friends) PrivacyLevel privacyLevel,

    /// 通知設定
    @Default(true) bool notificationsEnabled,

    /// 作成日時
    DateTime? createdAt,

    /// 更新日時
    DateTime? updatedAt,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// BMIを計算
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// 目標歩数が有効かどうかを判定
  bool get hasValidGoal => dailyStepGoal >= 1000 && dailyStepGoal <= 50000;

  /// プロフィールが完全かどうかを判定
  bool get isComplete => name.isNotEmpty && email.isNotEmpty && hasValidGoal;
}
