import '../repository/subscription_repository.dart';
import '../../core/entity/subscription_status.dart';
import '../../core/type/subscription_type.dart';

/// サブスクリプション検証ユースケース
/// サブスクリプションの状態検証と管理を行う
class VerifySubscriptionUseCase {
  const VerifySubscriptionUseCase(this._subscriptionRepository);

  final SubscriptionRepository _subscriptionRepository;

  /// サブスクリプションの状態を検証
  /// Returns: 検証が成功した場合true
  Future<bool> call() async {
    try {
      return await _subscriptionRepository.verifySubscription();
    } catch (e) {
      throw SubscriptionVerificationException(
        'Failed to verify subscription: $e',
      );
    }
  }

  /// 現在のサブスクリプション状態を取得
  /// Returns: 現在のSubscriptionStatus
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      return await _subscriptionRepository.getSubscriptionStatus();
    } catch (e) {
      throw SubscriptionVerificationException(
        'Failed to get subscription status: $e',
      );
    }
  }

  /// 購入を復元
  /// Returns: 復元が成功した場合true
  Future<bool> restorePurchases() async {
    try {
      return await _subscriptionRepository.restorePurchases();
    } catch (e) {
      throw SubscriptionVerificationException(
        'Failed to restore purchases: $e',
      );
    }
  }

  /// 特定のプレミアム機能が利用可能かどうかを確認
  /// [feature] 確認するプレミアム機能
  /// Returns: 機能が利用可能な場合true
  Future<bool> hasFeature(PremiumFeature feature) async {
    try {
      return await _subscriptionRepository.hasFeature(feature);
    } catch (e) {
      throw SubscriptionVerificationException(
        'Failed to check feature availability: $e',
      );
    }
  }

  /// サブスクリプション状態をリアルタイムで監視
  /// Returns: SubscriptionStatusのStream
  Stream<SubscriptionStatus> watchSubscriptionStatus() {
    return _subscriptionRepository.watchSubscriptionStatus();
  }

  /// サブスクリプションが有効かどうかを確認
  /// Returns: 有効な場合true
  Future<bool> isSubscriptionActive() async {
    try {
      final status = await getSubscriptionStatus();
      return status.isActive && !status.isExpired;
    } catch (e) {
      return false;
    }
  }

  /// プレミアム機能が利用可能かどうかを確認
  /// Returns: プレミアム機能が利用可能な場合true
  Future<bool> isPremiumActive() async {
    try {
      final status = await getSubscriptionStatus();
      return status.type == SubscriptionType.premium &&
          status.isActive &&
          !status.isExpired;
    } catch (e) {
      return false;
    }
  }

  /// サブスクリプションの残り日数を取得
  /// Returns: 残り日数、無制限または無効な場合は-1
  Future<int> getDaysRemaining() async {
    try {
      final status = await getSubscriptionStatus();
      return status.daysRemaining;
    } catch (e) {
      return -1;
    }
  }

  /// サブスクリプションの詳細情報を取得
  /// Returns: サブスクリプション詳細情報のMap
  Future<Map<String, dynamic>> getSubscriptionDetails() async {
    try {
      return await _subscriptionRepository.getSubscriptionDetails();
    } catch (e) {
      throw SubscriptionVerificationException(
        'Failed to get subscription details: $e',
      );
    }
  }

  /// 自動更新設定を変更
  /// [enabled] 自動更新を有効にするかどうか
  /// Returns: 設定変更が成功した場合true
  Future<bool> setAutoRenew(bool enabled) async {
    try {
      return await _subscriptionRepository.setAutoRenew(enabled);
    } catch (e) {
      throw SubscriptionVerificationException('Failed to set auto renew: $e');
    }
  }

  /// サブスクリプションをキャンセル
  /// Returns: キャンセルが成功した場合true
  Future<bool> cancelSubscription() async {
    try {
      return await _subscriptionRepository.cancelSubscription();
    } catch (e) {
      throw SubscriptionVerificationException(
        'Failed to cancel subscription: $e',
      );
    }
  }

  /// サブスクリプションの期限切れチェック
  /// Returns: 期限切れの場合true
  Future<bool> isSubscriptionExpired() async {
    try {
      final status = await getSubscriptionStatus();
      return status.isExpired;
    } catch (e) {
      return true; // エラーの場合は安全のため期限切れとして扱う
    }
  }

  /// トライアル期間中かどうかを確認
  /// Returns: トライアル期間中の場合true
  Future<bool> isInTrial() async {
    try {
      final status = await getSubscriptionStatus();
      return status.isInTrial;
    } catch (e) {
      return false;
    }
  }

  /// 友達追加可能数を取得
  /// Returns: 最大友達数
  Future<int> getMaxFriendsCount() async {
    try {
      final status = await getSubscriptionStatus();
      return status.maxFriendsCount;
    } catch (e) {
      return 10; // デフォルトは無料プランの制限
    }
  }

  /// 広告表示が必要かどうかを確認
  /// Returns: 広告表示が必要な場合true
  Future<bool> shouldShowAds() async {
    try {
      final status = await getSubscriptionStatus();
      return status.shouldShowAds;
    } catch (e) {
      return true; // エラーの場合は安全のため広告表示
    }
  }

  /// サブスクリプション検証の詳細情報を取得
  /// Returns: 検証情報のMap
  Future<Map<String, dynamic>> getVerificationInfo() async {
    try {
      final status = await getSubscriptionStatus();
      final details = await getSubscriptionDetails();

      return {
        'subscriptionType': status.type.id,
        'isActive': status.isActive,
        'isExpired': status.isExpired,
        'daysRemaining': status.daysRemaining,
        'availableFeatures': status.availableFeatures.map((f) => f.id).toList(),
        'details': details,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// サブスクリプション検証関連の例外クラス
class SubscriptionVerificationException implements Exception {
  const SubscriptionVerificationException(this.message);

  final String message;

  @override
  String toString() => 'SubscriptionVerificationException: $message';
}
