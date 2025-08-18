import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/core/entity/subscription_status.dart';
import '../../domain/core/type/subscription_type.dart';
import '../../domain/subscription/usecase/purchase_subscription_usecase.dart';
import '../../domain/subscription/usecase/verify_subscription_usecase.dart';
import '../../domain/subscription/repository/subscription_repository.dart';
import '../../data/repository/subscription_repository_impl.dart';
import '../../data/local/subscription_local_data_source.dart';

part 'subscription_provider.g.dart';

/// サブスクリプションローカルデータソースプロバイダー
@riverpod
SubscriptionLocalDataSource subscriptionLocalDataSource(SubscriptionLocalDataSourceRef ref) {
  return SubscriptionLocalDataSource();
}

/// サブスクリプションリポジトリプロバイダー
@riverpod
SubscriptionRepositoryImpl subscriptionRepository(SubscriptionRepositoryRef ref) {
  return SubscriptionRepositoryImpl(
    localDataSource: ref.watch(subscriptionLocalDataSourceProvider),
  );
}

/// サブスクリプション購入ユースケースプロバイダー
@riverpod
PurchaseSubscriptionUseCase purchaseSubscriptionUseCase(PurchaseSubscriptionUseCaseRef ref) {
  return PurchaseSubscriptionUseCase(ref.watch(subscriptionRepositoryProvider));
}

/// サブスクリプション検証ユースケースプロバイダー
@riverpod
VerifySubscriptionUseCase verifySubscriptionUseCase(VerifySubscriptionUseCaseRef ref) {
  return VerifySubscriptionUseCase(ref.watch(subscriptionRepositoryProvider));
}

/// サブスクリプション状態プロバイダー
@riverpod
class SubscriptionState extends _$SubscriptionState {
  @override
  Future<SubscriptionStatus> build() async {
    final useCase = ref.watch(verifySubscriptionUseCaseProvider);
    return await useCase.getSubscriptionStatus();
  }

  /// サブスクリプション状態を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      return await useCase.getSubscriptionStatus();
    });
  }

  /// サブスクリプションを検証
  Future<bool> verify() async {
    try {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      final result = await useCase.call();

      if (result) {
        // 検証成功時は状態を更新
        await refresh();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  /// 購入を復元
  Future<bool> restorePurchases() async {
    try {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      final result = await useCase.restorePurchases();

      if (result) {
        // 復元成功時は状態を更新
        await refresh();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  /// サブスクリプションをキャンセル
  Future<bool> cancelSubscription() async {
    try {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      final result = await useCase.cancelSubscription();

      if (result) {
        // キャンセル成功時は状態を更新
        await refresh();
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  /// 自動更新設定を変更
  Future<bool> setAutoRenew(bool enabled) async {
    try {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      final result = await useCase.setAutoRenew(enabled);

      if (result) {
        // 設定変更成功時は状態を更新
        await refresh();
      }

      return result;
    } catch (e) {
      return false;
    }
  }
}

/// サブスクリプション状態をリアルタイムで監視するプロバイダー
@riverpod
class SubscriptionStateStream extends _$SubscriptionStateStream {
  @override
  Stream<SubscriptionStatus> build() {
    final useCase = ref.watch(verifySubscriptionUseCaseProvider);
    return useCase.watchSubscriptionStatus();
  }
}

/// プレミアム機能利用可否プロバイダー
@riverpod
class PremiumFeatureAccess extends _$PremiumFeatureAccess {
  @override
  Future<bool> build(PremiumFeature feature) async {
    final useCase = ref.watch(verifySubscriptionUseCaseProvider);
    return await useCase.hasFeature(feature);
  }

  /// 機能利用可否を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      return await useCase.hasFeature(feature);
    });
  }
}

/// サブスクリプション購入処理プロバイダー
@riverpod
class SubscriptionPurchase extends _$SubscriptionPurchase {
  @override
  Future<bool?> build() async {
    return null; // 初期状態は未処理
  }

  /// サブスクリプションを購入
  Future<bool> purchase(SubscriptionType type) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      final success = await useCase.call(type);

      if (success) {
        // 購入成功時はサブスクリプション状態を更新
        ref.invalidate(subscriptionStateProvider);
      }

      return success;
    });

    state = result;
    return result.value ?? false;
  }

  /// 購入前の検証
  Future<bool> validatePurchase(SubscriptionType type) async {
    try {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      return await useCase.validatePurchase(type);
    } catch (e) {
      return false;
    }
  }

  /// 利用可能なサブスクリプションを取得
  Future<List<SubscriptionType>> getAvailableSubscriptions() async {
    try {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      return await useCase.getAvailableSubscriptions();
    } catch (e) {
      return [];
    }
  }

  /// サブスクリプション価格を取得
  Future<Map<String, dynamic>?> getPrice(SubscriptionType type) async {
    try {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      return await useCase.getSubscriptionPrice(type);
    } catch (e) {
      return null;
    }
  }

  /// プロモーションコードを適用
  Future<bool> applyPromoCode(String promoCode) async {
    try {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      final result = await useCase.applyPromoCode(promoCode);

      if (result) {
        // プロモーションコード適用成功時はサブスクリプション状態を更新
        ref.invalidate(subscriptionStateProvider);
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  /// 購入処理の状態を監視
  Stream<PurchaseStatus> watchPurchaseStatus() {
    final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
    return useCase.watchPurchaseStatus();
  }

  /// 購入エラー情報を取得
  Future<Map<String, dynamic>> getPurchaseErrorInfo() async {
    try {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      return await useCase.getPurchaseErrorInfo();
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// プレミアム状態プロバイダー（簡易アクセス用）
@riverpod
Future<bool> isPremiumActive(IsPremiumActiveRef ref) async {
  final useCase = ref.watch(verifySubscriptionUseCaseProvider);
  return await useCase.isPremiumActive();
}

/// 広告表示必要性プロバイダー
@riverpod
Future<bool> shouldShowAds(ShouldShowAdsRef ref) async {
  final useCase = ref.watch(verifySubscriptionUseCaseProvider);
  return await useCase.shouldShowAds();
}

/// 友達追加可能数プロバイダー
@riverpod
Future<int> maxFriendsCount(MaxFriendsCountRef ref) async {
  final useCase = ref.watch(verifySubscriptionUseCaseProvider);
  return await useCase.getMaxFriendsCount();
}

/// サブスクリプション残り日数プロバイダー
@riverpod
Future<int> subscriptionDaysRemaining(SubscriptionDaysRemainingRef ref) async {
  final useCase = ref.watch(verifySubscriptionUseCaseProvider);
  return await useCase.getDaysRemaining();
}

/// サブスクリプション期限切れ状態プロバイダー
@riverpod
Future<bool> isSubscriptionExpired(IsSubscriptionExpiredRef ref) async {
  final useCase = ref.watch(verifySubscriptionUseCaseProvider);
  return await useCase.isSubscriptionExpired();
}

/// トライアル状態プロバイダー
@riverpod
Future<bool> isInTrial(IsInTrialRef ref) async {
  final useCase = ref.watch(verifySubscriptionUseCaseProvider);
  return await useCase.isInTrial();
}

/// サブスクリプション詳細情報プロバイダー
@riverpod
class SubscriptionDetails extends _$SubscriptionDetails {
  @override
  Future<Map<String, dynamic>> build() async {
    final useCase = ref.watch(verifySubscriptionUseCaseProvider);
    return await useCase.getSubscriptionDetails();
  }

  /// 詳細情報を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(verifySubscriptionUseCaseProvider);
      return await useCase.getSubscriptionDetails();
    });
  }
}

/// 購入可能性チェックプロバイダー
@riverpod
Future<bool> canMakePurchases(CanMakePurchasesRef ref) async {
  final useCase = ref.watch(purchaseSubscriptionUseCaseProvider);
  return await useCase.canMakePurchases();
}

/// 購入履歴プロバイダー
@riverpod
class PurchaseHistory extends _$PurchaseHistory {
  @override
  Future<List<dynamic>> build() async {
    final useCase = ref.watch(purchaseSubscriptionUseCaseProvider);
    return await useCase.getPurchaseHistory();
  }

  /// 購入履歴を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(purchaseSubscriptionUseCaseProvider);
      return await useCase.getPurchaseHistory();
    });
  }
}

/// サブスクリプション管理の統合プロバイダー
@riverpod
class SubscriptionManager extends _$SubscriptionManager {
  @override
  Future<Map<String, dynamic>> build() async {
    final subscriptionState = await ref.watch(subscriptionStateProvider.future);
    final isPremium = await ref.watch(isPremiumActiveProvider.future);
    final shouldShowAds = await ref.watch(shouldShowAdsProvider.future);
    final maxFriends = await ref.watch(maxFriendsCountProvider.future);
    final daysRemaining = await ref.watch(
      subscriptionDaysRemainingProvider.future,
    );

    return {
      'subscriptionStatus': subscriptionState,
      'isPremium': isPremium,
      'shouldShowAds': shouldShowAds,
      'maxFriendsCount': maxFriends,
      'daysRemaining': daysRemaining,
      'availableFeatures': subscriptionState.availableFeatures
          .map((f) => f.id)
          .toList(),
    };
  }

  /// 統合情報を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    // 関連するプロバイダーを無効化
    ref.invalidate(subscriptionStateProvider);
    ref.invalidate(isPremiumActiveProvider);
    ref.invalidate(shouldShowAdsProvider);
    ref.invalidate(maxFriendsCountProvider);
    ref.invalidate(subscriptionDaysRemainingProvider);

    state = await AsyncValue.guard(() async {
      final subscriptionState = await ref.read(
        subscriptionStateProvider.future,
      );
      final isPremium = await ref.read(isPremiumActiveProvider.future);
      final shouldShowAds = await ref.read(shouldShowAdsProvider.future);
      final maxFriends = await ref.read(maxFriendsCountProvider.future);
      final daysRemaining = await ref.read(
        subscriptionDaysRemainingProvider.future,
      );

      return {
        'subscriptionStatus': subscriptionState,
        'isPremium': isPremium,
        'shouldShowAds': shouldShowAds,
        'maxFriendsCount': maxFriends,
        'daysRemaining': daysRemaining,
        'availableFeatures': subscriptionState.availableFeatures
            .map((f) => f.id)
            .toList(),
      };
    });
  }
}
