import 'dart:async';
import '../../domain/core/entity/subscription_status.dart';
import '../../domain/core/type/subscription_type.dart';
import '../../domain/subscription/repository/subscription_repository.dart';
import '../local/subscription_local_data_source.dart';
import '../api/mock/mock_subscription_data.dart';

/// サブスクリプションリポジトリの実装クラス
/// ローカルデータソースとモックデータを組み合わせてサブスクリプション機能を管理する
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource _localDataSource;
  final bool _useMockData;

  // Stream controllers for real-time data
  final StreamController<SubscriptionStatus> _subscriptionStatusController =
      StreamController<SubscriptionStatus>.broadcast();
  final StreamController<PurchaseStatus> _purchaseStatusController =
      StreamController<PurchaseStatus>.broadcast();

  SubscriptionRepositoryImpl({
    required SubscriptionLocalDataSource localDataSource,
    bool useMockData = true, // 開発中はモックデータを使用
  }) : _localDataSource = localDataSource,
       _useMockData = useMockData;

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      // まずローカルデータを確認
      SubscriptionStatus? localStatus = await _localDataSource
          .getSubscriptionStatus();

      if (_useMockData) {
        // モックデータを使用する場合
        if (localStatus == null) {
          // ローカルにデータがない場合はランダムなモックデータを生成
          final mockStatus = MockSubscriptionData.generateRandomSubscription();
          await _localDataSource.saveSubscriptionStatus(mockStatus);
          localStatus = mockStatus;
        }
      } else {
        // 実際のストアAPIで検証（実装は省略）
        // 実際の実装では、App Store / Google Play の API を使用
      }

      return localStatus ?? SubscriptionStatus.free();
    } catch (e) {
      // エラーが発生した場合は無料プランを返す
      return SubscriptionStatus.free();
    }
  }

  @override
  Future<bool> purchaseSubscription(SubscriptionType type) async {
    try {
      _purchaseStatusController.add(PurchaseStatus.processing);

      if (_useMockData) {
        // モックデータの場合は購入処理をシミュレート
        await Future.delayed(const Duration(seconds: 2)); // 購入処理の待機時間をシミュレート

        final purchaseResult = MockSubscriptionData.generatePurchaseResult(
          success: true,
        );

        if (purchaseResult['success'] as bool) {
          // 購入成功時はプレミアムサブスクリプションを作成
          final premiumStatus =
              MockSubscriptionData.generatePremiumSubscription();
          await _localDataSource.saveSubscriptionStatus(premiumStatus);

          // 購入履歴に追加
          final history = await _localDataSource.getPurchaseHistory();
          history.add(premiumStatus);
          await _localDataSource.savePurchaseHistory(history);

          _purchaseStatusController.add(PurchaseStatus.success);
          _subscriptionStatusController.add(premiumStatus);

          return true;
        } else {
          _purchaseStatusController.add(PurchaseStatus.failed);
          return false;
        }
      } else {
        // 実際のストア購入処理（実装は省略）
        // 実際の実装では、in_app_purchase プラグインを使用
        _purchaseStatusController.add(PurchaseStatus.failed);
        return false;
      }
    } catch (e) {
      _purchaseStatusController.add(PurchaseStatus.failed);
      return false;
    }
  }

  @override
  Future<bool> verifySubscription() async {
    try {
      if (_useMockData) {
        // モックデータの場合は検証をシミュレート
        final currentStatus = await getSubscriptionStatus();
        final verificationResult =
            MockSubscriptionData.generateVerificationResult(
              isValid: currentStatus.isActive,
              transactionId: currentStatus.originalTransactionId,
            );

        return verificationResult['valid'] as bool;
      } else {
        // 実際のストア検証処理（実装は省略）
        // 実際の実装では、サーバーサイドでレシート検証を行う
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    try {
      _purchaseStatusController.add(PurchaseStatus.restoring);

      if (_useMockData) {
        // モックデータの場合は復元処理をシミュレート
        await Future.delayed(const Duration(seconds: 1));

        final restoreResult = MockSubscriptionData.generateRestoreResult(
          hasValidPurchases: true,
        );

        if (restoreResult['success'] as bool &&
            restoreResult['restoredCount'] as int > 0) {
          // 復元されたプレミアムサブスクリプションを作成
          final premiumStatus =
              MockSubscriptionData.generatePremiumSubscription();
          await _localDataSource.saveSubscriptionStatus(premiumStatus);

          _purchaseStatusController.add(PurchaseStatus.success);
          _subscriptionStatusController.add(premiumStatus);

          return true;
        } else {
          _purchaseStatusController.add(PurchaseStatus.failed);
          return false;
        }
      } else {
        // 実際のストア復元処理（実装は省略）
        _purchaseStatusController.add(PurchaseStatus.failed);
        return false;
      }
    } catch (e) {
      _purchaseStatusController.add(PurchaseStatus.failed);
      return false;
    }
  }

  @override
  Future<bool> cancelSubscription() async {
    try {
      if (_useMockData) {
        // モックデータの場合はキャンセル処理をシミュレート
        await _localDataSource.resetToFreeSubscription();
        final freeStatus = SubscriptionStatus.free();
        _subscriptionStatusController.add(freeStatus);
        return true;
      } else {
        // 実際のキャンセル処理（実装は省略）
        // 実際の実装では、ストアの管理画面に誘導
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<SubscriptionType>> getAvailableSubscriptions() async {
    // 利用可能なサブスクリプションタイプを返す
    return SubscriptionType.values;
  }

  @override
  Future<bool> hasFeature(PremiumFeature feature) async {
    final status = await getSubscriptionStatus();
    return status.hasFeature(feature);
  }

  @override
  Stream<SubscriptionStatus> watchSubscriptionStatus() {
    // 定期的にサブスクリプション状態を更新
    Timer.periodic(const Duration(minutes: 30), (timer) async {
      final status = await getSubscriptionStatus();
      _subscriptionStatusController.add(status);
    });

    return _subscriptionStatusController.stream;
  }

  @override
  Stream<PurchaseStatus> watchPurchaseStatus() {
    return _purchaseStatusController.stream;
  }

  @override
  Future<Map<String, dynamic>?> getSubscriptionPrice(
    SubscriptionType type,
  ) async {
    if (_useMockData) {
      // モックデータの場合は固定価格を返す
      return {
        'price': type.price,
        'currency': 'USD',
        'period': type == SubscriptionType.premium ? 'monthly' : 'free',
        'formattedPrice': '\$${type.price.toStringAsFixed(2)}',
      };
    } else {
      // 実際のストア価格取得（実装は省略）
      return null;
    }
  }

  @override
  Future<bool> applyPromoCode(String promoCode) async {
    if (_useMockData) {
      // モックデータの場合はプロモーションコードをシミュレート
      if (promoCode.toUpperCase() == 'PREMIUM30') {
        // 30日間無料のプロモーション
        final trialStatus = MockSubscriptionData.generateTrialSubscription();
        await _localDataSource.saveSubscriptionStatus(trialStatus);
        _subscriptionStatusController.add(trialStatus);
        return true;
      }
      return false;
    } else {
      // 実際のプロモーションコード処理（実装は省略）
      return false;
    }
  }

  @override
  Future<bool> setAutoRenew(bool enabled) async {
    try {
      final currentStatus = await _localDataSource.getSubscriptionStatus();
      if (currentStatus == null) {
        return false;
      }
      final updatedStatus = currentStatus.copyWith(autoRenew: enabled);
      await _localDataSource.saveSubscriptionStatus(updatedStatus);
      _subscriptionStatusController.add(updatedStatus);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<PurchaseHistory>> getPurchaseHistory() async {
    if (_useMockData) {
      // モックデータの場合は購入履歴を生成
      final mockHistory = MockSubscriptionData.generatePurchaseHistory();
      return mockHistory
          .map(
            (status) => PurchaseHistory(
              transactionId: status.originalTransactionId ?? 'mock_transaction',
              productId: status.productId ?? 'premium_monthly',
              purchaseDate: status.purchaseDate ?? DateTime.now(),
              amount: SubscriptionType.premium.price,
              currency: 'USD',
              expiryDate: status.expiryDate,
              isActive: status.isActive,
            ),
          )
          .toList();
    } else {
      // 実際の購入履歴取得（実装は省略）
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getSubscriptionDetails() async {
    final status = await getSubscriptionStatus();
    final statistics = await _localDataSource.getSubscriptionStatistics();

    return {
      'currentSubscription': {
        'type': status.type.id,
        'isActive': status.isActive,
        'expiryDate': status.expiryDate?.toIso8601String(),
        'daysRemaining': status.daysRemaining,
        'autoRenew': status.autoRenew,
        'features': status.availableFeatures.map((f) => f.id).toList(),
      },
      'statistics': statistics,
      'pricing': {
        'premium': {
          'price': SubscriptionType.premium.price,
          'currency': 'USD',
          'period': 'monthly',
        },
      },
    };
  }

  /// リソースを解放
  void dispose() {
    _subscriptionStatusController.close();
    _purchaseStatusController.close();
  }
}
