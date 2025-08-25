import 'package:freezed_annotation/freezed_annotation.dart';
import '../type/subscription_type.dart';

part 'subscription_status.freezed.dart';
part 'subscription_status.g.dart';

/// サブスクリプション状態エンティティ
/// ユーザーの課金状態とプレミアム機能の利用可否を管理する
@freezed
class SubscriptionStatus with _$SubscriptionStatus {
  const factory SubscriptionStatus({
    /// サブスクリプションタイプ
    required SubscriptionType type,

    /// アクティブ状態
    required bool isActive,

    /// 利用可能なプレミアム機能
    required List<PremiumFeature> availableFeatures,

    /// 有効期限
    DateTime? expiryDate,

    /// 購入日
    DateTime? purchaseDate,

    /// 自動更新設定
    @Default(false) bool autoRenew,

    /// トライアル終了日
    DateTime? trialEndDate,

    /// 元のトランザクションID
    String? originalTransactionId,

    /// プロダクトID
    String? productId,
  }) = _SubscriptionStatus;

  const SubscriptionStatus._();

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusFromJson(json);

  /// ファクトリーメソッド：無料プラン
  factory SubscriptionStatus.free() {
    return const SubscriptionStatus(
      type: SubscriptionType.free,
      isActive: true,
      availableFeatures: [],
    );
  }

  /// ファクトリーメソッド：プレミアムプラン
  factory SubscriptionStatus.premium({
    required DateTime expiryDate,
    DateTime? purchaseDate,
    bool autoRenew = true,
    String? originalTransactionId,
    String? productId,
  }) {
    return SubscriptionStatus(
      type: SubscriptionType.premium,
      isActive: DateTime.now().isBefore(expiryDate),
      availableFeatures: PremiumFeature.values,
      expiryDate: expiryDate,
      purchaseDate: purchaseDate,
      autoRenew: autoRenew,
      originalTransactionId: originalTransactionId,
      productId: productId,
    );
  }

  /// プレミアム機能が利用可能かどうかを判定
  bool hasFeature(PremiumFeature feature) {
    return isActive && availableFeatures.contains(feature);
  }

  /// サブスクリプションが期限切れかどうかを判定
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// トライアル期間中かどうかを判定
  bool get isInTrial {
    if (trialEndDate == null) return false;
    return DateTime.now().isBefore(trialEndDate!);
  }

  /// サブスクリプションが有効かどうかを判定
  bool get isValid => isActive && !isExpired;

  /// 残り日数を計算
  int get daysRemaining {
    if (expiryDate == null) return 0;
    final now = DateTime.now();
    if (now.isAfter(expiryDate!)) return 0;
    return expiryDate!.difference(now).inDays;
  }

  /// 友達追加可能数を取得
  int get maxFriendsCount {
    return hasFeature(PremiumFeature.unlimitedFriends) ? 50 : 10;
  }

  /// 広告表示が必要かどうかを判定
  bool get shouldShowAds => !hasFeature(PremiumFeature.adFree);
}
