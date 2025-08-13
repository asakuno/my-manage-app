import '../repository/subscription_repository.dart';
import '../../core/type/subscription_type.dart';

/// サブスクリプション購入ユースケース
/// サブスクリプションの購入処理とビジネスロジックを管理する
class PurchaseSubscriptionUseCase {
  const PurchaseSubscriptionUseCase(this._subscriptionRepository);

  final SubscriptionRepository _subscriptionRepository;

  /// サブスクリプションを購入
  /// [type] 購入するサブスクリプションタイプ
  /// Returns: 購入が成功した場合true
  Future<bool> call(SubscriptionType type) async {
    try {
      // 現在のサブスクリプション状態を確認
      final currentStatus = await _subscriptionRepository
          .getSubscriptionStatus();

      // 既にプレミアムプランの場合はエラー
      if (currentStatus.type == SubscriptionType.premium &&
          currentStatus.isActive) {
        throw SubscriptionException('Already subscribed to premium plan');
      }

      // 無料プランを購入しようとした場合はエラー
      if (type == SubscriptionType.free) {
        throw SubscriptionException('Cannot purchase free plan');
      }

      // 購入処理を実行
      final purchaseResult = await _subscriptionRepository.purchaseSubscription(
        type,
      );

      if (!purchaseResult) {
        throw SubscriptionException('Purchase failed');
      }

      return true;
    } catch (e) {
      if (e is SubscriptionException) {
        rethrow;
      }
      throw SubscriptionException('Failed to purchase subscription: $e');
    }
  }

  /// 利用可能なサブスクリプション商品を取得
  /// Returns: 購入可能なSubscriptionTypeのリスト
  Future<List<SubscriptionType>> getAvailableSubscriptions() async {
    try {
      return await _subscriptionRepository.getAvailableSubscriptions();
    } catch (e) {
      throw SubscriptionException('Failed to get available subscriptions: $e');
    }
  }

  /// サブスクリプションの価格情報を取得
  /// [type] 価格を取得するサブスクリプションタイプ
  /// Returns: 価格情報のMap
  Future<Map<String, dynamic>?> getSubscriptionPrice(
    SubscriptionType type,
  ) async {
    try {
      return await _subscriptionRepository.getSubscriptionPrice(type);
    } catch (e) {
      throw SubscriptionException('Failed to get subscription price: $e');
    }
  }

  /// 購入前の検証を実行
  /// [type] 購入予定のサブスクリプションタイプ
  /// Returns: 購入可能な場合true
  Future<bool> validatePurchase(SubscriptionType type) async {
    try {
      // 現在のサブスクリプション状態を確認
      final currentStatus = await _subscriptionRepository
          .getSubscriptionStatus();

      // 無料プランを購入しようとした場合
      if (type == SubscriptionType.free) {
        return false;
      }

      // 既にアクティブなプレミアムプランがある場合
      if (currentStatus.type == SubscriptionType.premium &&
          currentStatus.isActive) {
        return false;
      }

      // 利用可能な商品かどうかを確認
      final availableSubscriptions = await getAvailableSubscriptions();
      if (!availableSubscriptions.contains(type)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 購入処理の状態を監視
  /// Returns: 購入処理状態のStream
  Stream<PurchaseStatus> watchPurchaseStatus() {
    return _subscriptionRepository.watchPurchaseStatus();
  }

  /// プロモーションコードを適用
  /// [promoCode] プロモーションコード
  /// Returns: 適用が成功した場合true
  Future<bool> applyPromoCode(String promoCode) async {
    if (promoCode.trim().isEmpty) {
      throw SubscriptionException('Promo code cannot be empty');
    }

    try {
      return await _subscriptionRepository.applyPromoCode(promoCode);
    } catch (e) {
      throw SubscriptionException('Failed to apply promo code: $e');
    }
  }

  /// 購入可能性をチェック
  /// デバイスの設定や制限をチェックする
  /// Returns: 購入可能な場合true
  Future<bool> canMakePurchases() async {
    try {
      // 利用可能な商品があるかどうかで判定
      final availableSubscriptions = await getAvailableSubscriptions();
      return availableSubscriptions.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 購入履歴を取得
  /// Returns: 購入履歴のリスト
  Future<List<PurchaseHistory>> getPurchaseHistory() async {
    try {
      return await _subscriptionRepository.getPurchaseHistory();
    } catch (e) {
      throw SubscriptionException('Failed to get purchase history: $e');
    }
  }

  /// 購入エラーの詳細情報を取得
  /// Returns: エラー情報のMap
  Future<Map<String, dynamic>> getPurchaseErrorInfo() async {
    try {
      final canPurchase = await canMakePurchases();
      final availableSubscriptions = await getAvailableSubscriptions();
      final currentStatus = await _subscriptionRepository
          .getSubscriptionStatus();

      return {
        'canMakePurchases': canPurchase,
        'availableSubscriptions': availableSubscriptions
            .map((s) => s.id)
            .toList(),
        'currentSubscription': currentStatus.type.id,
        'isCurrentlyActive': currentStatus.isActive,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// サブスクリプション関連の例外クラス
class SubscriptionException implements Exception {
  const SubscriptionException(this.message);

  final String message;

  @override
  String toString() => 'SubscriptionException: $message';
}
