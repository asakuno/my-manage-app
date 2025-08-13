import '../../core/entity/subscription_status.dart';
import '../../core/type/subscription_type.dart';

/// サブスクリプションリポジトリの抽象クラス
/// 課金機能とプレミアム機能の管理を担当する
abstract class SubscriptionRepository {
  /// 現在のサブスクリプション状態を取得
  /// Returns: 現在のSubscriptionStatus
  Future<SubscriptionStatus> getSubscriptionStatus();

  /// サブスクリプションを購入
  /// [type] 購入するサブスクリプションタイプ
  /// Returns: 購入が成功した場合true
  Future<bool> purchaseSubscription(SubscriptionType type);

  /// サブスクリプションの状態を検証
  /// プラットフォームのストアで購入状態を確認する
  /// Returns: 検証が成功した場合true
  Future<bool> verifySubscription();

  /// 購入を復元
  /// 以前の購入を復元する（機種変更時など）
  /// Returns: 復元が成功した場合true
  Future<bool> restorePurchases();

  /// サブスクリプションをキャンセル
  /// Returns: キャンセルが成功した場合true
  Future<bool> cancelSubscription();

  /// 利用可能なサブスクリプション商品を取得
  /// Returns: 購入可能なSubscriptionTypeのリスト
  Future<List<SubscriptionType>> getAvailableSubscriptions();

  /// 特定のプレミアム機能が利用可能かどうかを確認
  /// [feature] 確認するプレミアム機能
  /// Returns: 機能が利用可能な場合true
  Future<bool> hasFeature(PremiumFeature feature);

  /// サブスクリプション状態をリアルタイムで監視
  /// Returns: SubscriptionStatusのStream
  Stream<SubscriptionStatus> watchSubscriptionStatus();

  /// 購入処理の状態を監視
  /// Returns: 購入処理状態のStream
  Stream<PurchaseStatus> watchPurchaseStatus();

  /// サブスクリプションの価格情報を取得
  /// [type] 価格を取得するサブスクリプションタイプ
  /// Returns: 価格情報のMap（価格、通貨、期間など）
  Future<Map<String, dynamic>?> getSubscriptionPrice(SubscriptionType type);

  /// プロモーションコードを適用
  /// [promoCode] プロモーションコード
  /// Returns: 適用が成功した場合true
  Future<bool> applyPromoCode(String promoCode);

  /// サブスクリプションの自動更新設定を変更
  /// [enabled] 自動更新を有効にするかどうか
  /// Returns: 設定変更が成功した場合true
  Future<bool> setAutoRenew(bool enabled);

  /// 購入履歴を取得
  /// Returns: 購入履歴のリスト
  Future<List<PurchaseHistory>> getPurchaseHistory();

  /// サブスクリプションの詳細情報を取得
  /// Returns: サブスクリプション詳細情報のMap
  Future<Map<String, dynamic>> getSubscriptionDetails();
}

/// 購入処理の状態を表すEnum
enum PurchaseStatus {
  /// 待機中
  pending,

  /// 処理中
  processing,

  /// 成功
  success,

  /// 失敗
  failed,

  /// キャンセル
  cancelled,

  /// 復元中
  restoring,
}

/// 購入履歴エンティティ
class PurchaseHistory {
  const PurchaseHistory({
    required this.transactionId,
    required this.productId,
    required this.purchaseDate,
    required this.amount,
    required this.currency,
    this.expiryDate,
    this.isActive = false,
  });

  /// トランザクションID
  final String transactionId;

  /// プロダクトID
  final String productId;

  /// 購入日
  final DateTime purchaseDate;

  /// 金額
  final double amount;

  /// 通貨
  final String currency;

  /// 有効期限
  final DateTime? expiryDate;

  /// アクティブ状態
  final bool isActive;
}
