// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionLocalDataSourceHash() =>
    r'8ccb08c692834cb6404f0b8d86429f8fed61dfb1';

/// サブスクリプションローカルデータソースプロバイダー
///
/// Copied from [subscriptionLocalDataSource].
@ProviderFor(subscriptionLocalDataSource)
final subscriptionLocalDataSourceProvider =
    AutoDisposeProvider<SubscriptionLocalDataSource>.internal(
  subscriptionLocalDataSource,
  name: r'subscriptionLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionLocalDataSourceRef
    = AutoDisposeProviderRef<SubscriptionLocalDataSource>;
String _$subscriptionRepositoryHash() =>
    r'e5d1a9fdb773f71d745ff09f2782c1612a3dcaca';

/// サブスクリプションリポジトリプロバイダー
///
/// Copied from [subscriptionRepository].
@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider =
    AutoDisposeProvider<SubscriptionRepositoryImpl>.internal(
  subscriptionRepository,
  name: r'subscriptionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionRepositoryRef
    = AutoDisposeProviderRef<SubscriptionRepositoryImpl>;
String _$purchaseSubscriptionUseCaseHash() =>
    r'9cf6878ab59a80342e85433e44ea163fec272cf6';

/// サブスクリプション購入ユースケースプロバイダー
///
/// Copied from [purchaseSubscriptionUseCase].
@ProviderFor(purchaseSubscriptionUseCase)
final purchaseSubscriptionUseCaseProvider =
    AutoDisposeProvider<PurchaseSubscriptionUseCase>.internal(
  purchaseSubscriptionUseCase,
  name: r'purchaseSubscriptionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$purchaseSubscriptionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PurchaseSubscriptionUseCaseRef
    = AutoDisposeProviderRef<PurchaseSubscriptionUseCase>;
String _$verifySubscriptionUseCaseHash() =>
    r'158c33acb9879f0385a235cbbecc46aa9788f2b2';

/// サブスクリプション検証ユースケースプロバイダー
///
/// Copied from [verifySubscriptionUseCase].
@ProviderFor(verifySubscriptionUseCase)
final verifySubscriptionUseCaseProvider =
    AutoDisposeProvider<VerifySubscriptionUseCase>.internal(
  verifySubscriptionUseCase,
  name: r'verifySubscriptionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verifySubscriptionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerifySubscriptionUseCaseRef
    = AutoDisposeProviderRef<VerifySubscriptionUseCase>;
String _$isPremiumActiveHash() => r'3ea49f718ec916414bd65132969616324331279e';

/// プレミアム状態プロバイダー（簡易アクセス用）
///
/// Copied from [isPremiumActive].
@ProviderFor(isPremiumActive)
final isPremiumActiveProvider = AutoDisposeFutureProvider<bool>.internal(
  isPremiumActive,
  name: r'isPremiumActiveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPremiumActiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPremiumActiveRef = AutoDisposeFutureProviderRef<bool>;
String _$shouldShowAdsHash() => r'84f373ec81f09f3f47fba47cee4575bf90a09da6';

/// 広告表示必要性プロバイダー
///
/// Copied from [shouldShowAds].
@ProviderFor(shouldShowAds)
final shouldShowAdsProvider = AutoDisposeFutureProvider<bool>.internal(
  shouldShowAds,
  name: r'shouldShowAdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shouldShowAdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShouldShowAdsRef = AutoDisposeFutureProviderRef<bool>;
String _$maxFriendsCountHash() => r'f3509258d1e3debd94b4ecacbc3cb3bb0a6588d5';

/// 友達追加可能数プロバイダー
///
/// Copied from [maxFriendsCount].
@ProviderFor(maxFriendsCount)
final maxFriendsCountProvider = AutoDisposeFutureProvider<int>.internal(
  maxFriendsCount,
  name: r'maxFriendsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$maxFriendsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MaxFriendsCountRef = AutoDisposeFutureProviderRef<int>;
String _$subscriptionDaysRemainingHash() =>
    r'6c790773742dad34419c67b2c018a8c9a7476f93';

/// サブスクリプション残り日数プロバイダー
///
/// Copied from [subscriptionDaysRemaining].
@ProviderFor(subscriptionDaysRemaining)
final subscriptionDaysRemainingProvider =
    AutoDisposeFutureProvider<int>.internal(
  subscriptionDaysRemaining,
  name: r'subscriptionDaysRemainingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionDaysRemainingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionDaysRemainingRef = AutoDisposeFutureProviderRef<int>;
String _$isSubscriptionExpiredHash() =>
    r'0d869ec8d72bf843b0d9e41ef90d1ae05c96f4e0';

/// サブスクリプション期限切れ状態プロバイダー
///
/// Copied from [isSubscriptionExpired].
@ProviderFor(isSubscriptionExpired)
final isSubscriptionExpiredProvider = AutoDisposeFutureProvider<bool>.internal(
  isSubscriptionExpired,
  name: r'isSubscriptionExpiredProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isSubscriptionExpiredHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsSubscriptionExpiredRef = AutoDisposeFutureProviderRef<bool>;
String _$isInTrialHash() => r'59e085b7a54d46962c08ac8df60f005edd78e910';

/// トライアル状態プロバイダー
///
/// Copied from [isInTrial].
@ProviderFor(isInTrial)
final isInTrialProvider = AutoDisposeFutureProvider<bool>.internal(
  isInTrial,
  name: r'isInTrialProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isInTrialHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsInTrialRef = AutoDisposeFutureProviderRef<bool>;
String _$canMakePurchasesHash() => r'1af00f87957b603fe4835dda61323044342c8d92';

/// 購入可能性チェックプロバイダー
///
/// Copied from [canMakePurchases].
@ProviderFor(canMakePurchases)
final canMakePurchasesProvider = AutoDisposeFutureProvider<bool>.internal(
  canMakePurchases,
  name: r'canMakePurchasesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canMakePurchasesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanMakePurchasesRef = AutoDisposeFutureProviderRef<bool>;
String _$subscriptionStateHash() => r'2ae90483659d96be78f25634c25d925a0ecbe89d';

/// サブスクリプション状態プロバイダー
///
/// Copied from [SubscriptionState].
@ProviderFor(SubscriptionState)
final subscriptionStateProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionState, SubscriptionStatus>.internal(
  SubscriptionState.new,
  name: r'subscriptionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionState = AutoDisposeAsyncNotifier<SubscriptionStatus>;
String _$subscriptionStateStreamHash() =>
    r'5bd56efea922dd10485223864ff85dd34992c6d9';

/// サブスクリプション状態をリアルタイムで監視するプロバイダー
///
/// Copied from [SubscriptionStateStream].
@ProviderFor(SubscriptionStateStream)
final subscriptionStateStreamProvider = AutoDisposeStreamNotifierProvider<
    SubscriptionStateStream, SubscriptionStatus>.internal(
  SubscriptionStateStream.new,
  name: r'subscriptionStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionStateStream
    = AutoDisposeStreamNotifier<SubscriptionStatus>;
String _$premiumFeatureAccessHash() =>
    r'542acd2b9f374accbd51a6f0aaaa47627f4fb7fd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PremiumFeatureAccess
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final PremiumFeature feature;

  FutureOr<bool> build(
    PremiumFeature feature,
  );
}

/// プレミアム機能利用可否プロバイダー
///
/// Copied from [PremiumFeatureAccess].
@ProviderFor(PremiumFeatureAccess)
const premiumFeatureAccessProvider = PremiumFeatureAccessFamily();

/// プレミアム機能利用可否プロバイダー
///
/// Copied from [PremiumFeatureAccess].
class PremiumFeatureAccessFamily extends Family<AsyncValue<bool>> {
  /// プレミアム機能利用可否プロバイダー
  ///
  /// Copied from [PremiumFeatureAccess].
  const PremiumFeatureAccessFamily();

  /// プレミアム機能利用可否プロバイダー
  ///
  /// Copied from [PremiumFeatureAccess].
  PremiumFeatureAccessProvider call(
    PremiumFeature feature,
  ) {
    return PremiumFeatureAccessProvider(
      feature,
    );
  }

  @override
  PremiumFeatureAccessProvider getProviderOverride(
    covariant PremiumFeatureAccessProvider provider,
  ) {
    return call(
      provider.feature,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'premiumFeatureAccessProvider';
}

/// プレミアム機能利用可否プロバイダー
///
/// Copied from [PremiumFeatureAccess].
class PremiumFeatureAccessProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PremiumFeatureAccess, bool> {
  /// プレミアム機能利用可否プロバイダー
  ///
  /// Copied from [PremiumFeatureAccess].
  PremiumFeatureAccessProvider(
    PremiumFeature feature,
  ) : this._internal(
          () => PremiumFeatureAccess()..feature = feature,
          from: premiumFeatureAccessProvider,
          name: r'premiumFeatureAccessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$premiumFeatureAccessHash,
          dependencies: PremiumFeatureAccessFamily._dependencies,
          allTransitiveDependencies:
              PremiumFeatureAccessFamily._allTransitiveDependencies,
          feature: feature,
        );

  PremiumFeatureAccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feature,
  }) : super.internal();

  final PremiumFeature feature;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant PremiumFeatureAccess notifier,
  ) {
    return notifier.build(
      feature,
    );
  }

  @override
  Override overrideWith(PremiumFeatureAccess Function() create) {
    return ProviderOverride(
      origin: this,
      override: PremiumFeatureAccessProvider._internal(
        () => create()..feature = feature,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feature: feature,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PremiumFeatureAccess, bool>
      createElement() {
    return _PremiumFeatureAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PremiumFeatureAccessProvider && other.feature == feature;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feature.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PremiumFeatureAccessRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `feature` of this provider.
  PremiumFeature get feature;
}

class _PremiumFeatureAccessProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PremiumFeatureAccess, bool>
    with PremiumFeatureAccessRef {
  _PremiumFeatureAccessProviderElement(super.provider);

  @override
  PremiumFeature get feature =>
      (origin as PremiumFeatureAccessProvider).feature;
}

String _$subscriptionPurchaseHash() =>
    r'abe3b27fed27e236ca45fe0d78c23f69a86c4ee8';

/// サブスクリプション購入処理プロバイダー
///
/// Copied from [SubscriptionPurchase].
@ProviderFor(SubscriptionPurchase)
final subscriptionPurchaseProvider =
    AutoDisposeAsyncNotifierProvider<SubscriptionPurchase, bool?>.internal(
  SubscriptionPurchase.new,
  name: r'subscriptionPurchaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionPurchaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionPurchase = AutoDisposeAsyncNotifier<bool?>;
String _$subscriptionDetailsHash() =>
    r'dcf4606a1c0b0d094531457f4d5ad27d77425ec6';

/// サブスクリプション詳細情報プロバイダー
///
/// Copied from [SubscriptionDetails].
@ProviderFor(SubscriptionDetails)
final subscriptionDetailsProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionDetails, Map<String, dynamic>>.internal(
  SubscriptionDetails.new,
  name: r'subscriptionDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionDetails = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$purchaseHistoryHash() => r'ff2db8135610d78829cb1fa96a8757c3b2548833';

/// 購入履歴プロバイダー
///
/// Copied from [PurchaseHistory].
@ProviderFor(PurchaseHistory)
final purchaseHistoryProvider =
    AutoDisposeAsyncNotifierProvider<PurchaseHistory, List<dynamic>>.internal(
  PurchaseHistory.new,
  name: r'purchaseHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$purchaseHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PurchaseHistory = AutoDisposeAsyncNotifier<List<dynamic>>;
String _$subscriptionManagerHash() =>
    r'bb742bc057865032c19cbac4298578998dd197fe';

/// サブスクリプション管理の統合プロバイダー
///
/// Copied from [SubscriptionManager].
@ProviderFor(SubscriptionManager)
final subscriptionManagerProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionManager, Map<String, dynamic>>.internal(
  SubscriptionManager.new,
  name: r'subscriptionManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionManager = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
