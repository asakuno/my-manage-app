import 'dart:math';
import '../../../domain/core/entity/subscription_status.dart';
import '../../../domain/core/type/subscription_type.dart';

/// モックサブスクリプションデータクラス
/// 開発・テスト用のサンプルサブスクリプションデータを提供する
class MockSubscriptionData {
  static final Random _random = Random();

  /// 無料プランのモックデータを生成
  static SubscriptionStatus generateFreeSubscription() {
    return SubscriptionStatus.free();
  }

  /// プレミアムプランのモックデータを生成
  static SubscriptionStatus generatePremiumSubscription({
    bool isActive = true,
    int daysFromNow = 30,
  }) {
    final now = DateTime.now();
    final expiryDate = now.add(Duration(days: daysFromNow));
    final purchaseDate = now.subtract(Duration(days: _random.nextInt(30)));

    return SubscriptionStatus.premium(
      expiryDate: expiryDate,
      purchaseDate: purchaseDate,
      autoRenew: true,
      originalTransactionId: 'mock_transaction_${_random.nextInt(100000)}',
      productId: 'premium_monthly',
    );
  }

  /// 期限切れプレミアムプランのモックデータを生成
  static SubscriptionStatus generateExpiredPremiumSubscription() {
    final now = DateTime.now();
    final expiryDate = now.subtract(Duration(days: _random.nextInt(30) + 1));
    final purchaseDate = expiryDate.subtract(Duration(days: 30));

    return SubscriptionStatus.premium(
      expiryDate: expiryDate,
      purchaseDate: purchaseDate,
      autoRenew: false,
      originalTransactionId:
          'mock_transaction_expired_${_random.nextInt(100000)}',
      productId: 'premium_monthly',
    );
  }

  /// トライアル中のプレミアムプランのモックデータを生成
  static SubscriptionStatus generateTrialSubscription() {
    final now = DateTime.now();
    final trialEndDate = now.add(const Duration(days: 7));
    final expiryDate = now.add(const Duration(days: 37)); // トライアル + 30日
    final purchaseDate = now.subtract(const Duration(days: 1));

    return SubscriptionStatus(
      type: SubscriptionType.premium,
      isActive: true,
      availableFeatures: PremiumFeature.values,
      expiryDate: expiryDate,
      purchaseDate: purchaseDate,
      autoRenew: true,
      trialEndDate: trialEndDate,
      originalTransactionId: 'mock_trial_${_random.nextInt(100000)}',
      productId: 'premium_monthly',
    );
  }

  /// ランダムなサブスクリプション状態を生成
  static SubscriptionStatus generateRandomSubscription() {
    final subscriptionTypes = [
      () => generateFreeSubscription(),
      () => generatePremiumSubscription(),
      () => generateExpiredPremiumSubscription(),
      () => generateTrialSubscription(),
    ];

    final randomIndex = _random.nextInt(subscriptionTypes.length);
    return subscriptionTypes[randomIndex]();
  }

  /// 購入履歴のモックデータを生成
  static List<SubscriptionStatus> generatePurchaseHistory() {
    final List<SubscriptionStatus> history = [];
    final now = DateTime.now();

    // 過去の購入履歴を3-5件生成
    final historyCount = 3 + _random.nextInt(3);

    for (int i = 0; i < historyCount; i++) {
      final daysAgo = (i + 1) * 30 + _random.nextInt(30);
      final purchaseDate = now.subtract(Duration(days: daysAgo));
      final expiryDate = purchaseDate.add(const Duration(days: 30));
      final isExpired = expiryDate.isBefore(now);

      final subscription = SubscriptionStatus(
        type: SubscriptionType.premium,
        isActive: !isExpired,
        availableFeatures: isExpired ? [] : PremiumFeature.values,
        expiryDate: expiryDate,
        purchaseDate: purchaseDate,
        autoRenew: i == 0, // 最新のもののみ自動更新
        originalTransactionId: 'mock_history_${_random.nextInt(100000)}_$i',
        productId: 'premium_monthly',
      );

      history.add(subscription);
    }

    return history;
  }

  /// 特定のプロダクトIDの購入履歴を生成
  static List<SubscriptionStatus> generatePurchaseHistoryByProductId(
    String productId,
  ) {
    final allHistory = generatePurchaseHistory();
    return allHistory.where((status) => status.productId == productId).toList();
  }

  /// サブスクリプション統計のモックデータを生成
  static Map<String, dynamic> generateSubscriptionStatistics() {
    final history = generatePurchaseHistory();
    final currentStatus = generateRandomSubscription();

    final totalPurchases = history.length;
    final activePurchases = history.where((status) => status.isActive).length;
    final expiredPurchases = history.where((status) => status.isExpired).length;

    return {
      'totalPurchases': totalPurchases,
      'activePurchases': activePurchases,
      'expiredPurchases': expiredPurchases,
      'currentType': currentStatus.type.id,
      'isCurrentlyActive': currentStatus.isActive,
      'daysRemaining': currentStatus.daysRemaining,
      'totalRevenue': totalPurchases * SubscriptionType.premium.price,
      'monthlyRevenue': activePurchases * SubscriptionType.premium.price,
    };
  }

  /// プレミアム機能の利用状況モックデータを生成
  static Map<PremiumFeature, bool> generateFeatureUsage() {
    final Map<PremiumFeature, bool> usage = {};

    for (final feature in PremiumFeature.values) {
      // ランダムに機能の利用状況を設定
      usage[feature] = _random.nextBool();
    }

    return usage;
  }

  /// 購入処理のモック結果を生成
  static Map<String, dynamic> generatePurchaseResult({
    bool success = true,
    String? errorMessage,
  }) {
    if (success) {
      return {
        'success': true,
        'transactionId':
            'mock_transaction_${DateTime.now().millisecondsSinceEpoch}',
        'productId': 'premium_monthly',
        'purchaseDate': DateTime.now().toIso8601String(),
        'expiryDate': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String(),
      };
    } else {
      return {
        'success': false,
        'error': errorMessage ?? 'Purchase failed',
        'errorCode': _random.nextInt(1000) + 4000,
      };
    }
  }

  /// 購入復元処理のモック結果を生成
  static Map<String, dynamic> generateRestoreResult({
    bool hasValidPurchases = true,
  }) {
    if (hasValidPurchases) {
      // 復元可能な有効な購入を確実に1つ以上作成
      final validPurchase = generatePremiumSubscription();
      final restoredPurchases = [validPurchase];

      return {
        'success': true,
        'restoredCount': restoredPurchases.length,
        'purchases': restoredPurchases
            .map(
              (status) => {
                'transactionId': status.originalTransactionId,
                'productId': status.productId,
                'purchaseDate': status.purchaseDate?.toIso8601String(),
                'expiryDate': status.expiryDate?.toIso8601String(),
              },
            )
            .toList(),
      };
    } else {
      return {'success': true, 'restoredCount': 0, 'purchases': []};
    }
  }

  /// サブスクリプション検証のモック結果を生成
  static Map<String, dynamic> generateVerificationResult({
    bool isValid = true,
    String? transactionId,
  }) {
    if (isValid) {
      return {
        'valid': true,
        'transactionId':
            transactionId ?? 'mock_transaction_${_random.nextInt(100000)}',
        'productId': 'premium_monthly',
        'expiryDate': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String(),
        'autoRenew': true,
      };
    } else {
      return {
        'valid': false,
        'reason': 'Transaction not found or expired',
        'errorCode': 4004,
      };
    }
  }

  /// 利用可能な商品のモックデータを生成
  static List<Map<String, dynamic>> generateAvailableProducts() {
    return [
      {
        'productId': 'premium_monthly',
        'type': 'subscription',
        'price': '9.99',
        'currency': 'USD',
        'title': 'Premium Monthly',
        'description': 'Get access to all premium features',
        'period': 'monthly',
      },
      {
        'productId': 'premium_yearly',
        'type': 'subscription',
        'price': '99.99',
        'currency': 'USD',
        'title': 'Premium Yearly',
        'description': 'Get access to all premium features with 2 months free',
        'period': 'yearly',
      },
    ];
  }
}
