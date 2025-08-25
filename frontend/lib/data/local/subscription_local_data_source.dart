import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/core/entity/subscription_status.dart';
import '../../domain/core/type/subscription_type.dart';
import 'model/subscription_status_model.dart';

/// サブスクリプションデータのローカルデータソース
/// Hiveを使用してサブスクリプション状態をローカルに保存・取得する
class SubscriptionLocalDataSource {
  static const String _boxName = 'subscription_data';
  static const String _statusKey = 'current_status';
  static const String _purchaseHistoryKey = 'purchase_history';

  late Box<SubscriptionStatusModel> _box;

  /// 初期化
  Future<void> initialize() async {
    await Hive.initFlutter();

    // アダプターの登録
    if (!Hive.isAdapterRegistered(SubscriptionStatusModelAdapter().typeId)) {
      Hive.registerAdapter(SubscriptionStatusModelAdapter());
    }

    _box = await Hive.openBox<SubscriptionStatusModel>(_boxName);
  }

  /// テスト用初期化（Hive.initFlutterを使わない）
  Future<void> initializeForTest() async {
    // アダプターの登録
    if (!Hive.isAdapterRegistered(SubscriptionStatusModelAdapter().typeId)) {
      Hive.registerAdapter(SubscriptionStatusModelAdapter());
    }

    _box = await Hive.openBox<SubscriptionStatusModel>(_boxName);
  }

  /// 現在のサブスクリプション状態を保存
  Future<void> saveSubscriptionStatus(SubscriptionStatus status) async {
    final model = SubscriptionStatusModel.fromEntity(status);
    await _box.put(_statusKey, model);
  }

  /// 現在のサブスクリプション状態を取得
  Future<SubscriptionStatus?> getSubscriptionStatus() async {
    final model = _box.get(_statusKey);
    return model?.toEntity();
  }

  /// 購入履歴を保存
  Future<void> savePurchaseHistory(List<SubscriptionStatus> history) async {
    final models = history
        .map((status) => SubscriptionStatusModel.fromEntity(status))
        .toList();

    for (int i = 0; i < models.length; i++) {
      await _box.put('$_purchaseHistoryKey$i', models[i]);
    }
  }

  /// 購入履歴を取得
  Future<List<SubscriptionStatus>> getPurchaseHistory() async {
    final List<SubscriptionStatus> history = [];

    for (final key in _box.keys) {
      if (key.toString().startsWith(_purchaseHistoryKey)) {
        final model = _box.get(key);
        if (model != null) {
          history.add(model.toEntity());
        }
      }
    }

    // 購入日順でソート
    history.sort((a, b) {
      final aDate = a.purchaseDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.purchaseDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return history;
  }

  /// 特定のプロダクトIDの購入履歴を取得
  Future<List<SubscriptionStatus>> getPurchaseHistoryByProductId(
    String productId,
  ) async {
    final allHistory = await getPurchaseHistory();
    return allHistory.where((status) => status.productId == productId).toList();
  }

  /// 最新の有効なサブスクリプションを取得
  Future<SubscriptionStatus?> getLatestActiveSubscription() async {
    final status = await getSubscriptionStatus();

    if (status != null && status.isValid) {
      return status;
    }

    // 現在の状態が無効な場合、購入履歴から最新の有効なものを探す
    final history = await getPurchaseHistory();
    for (final historyStatus in history) {
      if (historyStatus.isValid) {
        return historyStatus;
      }
    }

    return null;
  }

  /// プレミアム機能が利用可能かチェック
  Future<bool> hasFeature(PremiumFeature feature) async {
    final status = await getSubscriptionStatus();
    return status?.hasFeature(feature) ?? false;
  }

  /// サブスクリプションが期限切れかチェック
  Future<bool> isSubscriptionExpired() async {
    final status = await getSubscriptionStatus();
    return status?.isExpired ?? true;
  }

  /// トライアル期間中かチェック
  Future<bool> isInTrial() async {
    final status = await getSubscriptionStatus();
    return status?.isInTrial ?? false;
  }

  /// 残り日数を取得
  Future<int> getDaysRemaining() async {
    final status = await getSubscriptionStatus();
    return status?.daysRemaining ?? 0;
  }

  /// 友達追加可能数を取得
  Future<int> getMaxFriendsCount() async {
    final status = await getSubscriptionStatus();
    return status?.maxFriendsCount ?? 10;
  }

  /// 広告表示が必要かチェック
  Future<bool> shouldShowAds() async {
    final status = await getSubscriptionStatus();
    return status?.shouldShowAds ?? true;
  }

  /// サブスクリプション状態をリセット（無料プランに戻す）
  Future<void> resetToFreeSubscription() async {
    final freeStatus = SubscriptionStatus.free();
    await saveSubscriptionStatus(freeStatus);
  }

  /// 購入履歴をクリア
  Future<void> clearPurchaseHistory() async {
    final keysToDelete = _box.keys
        .where((key) => key.toString().startsWith(_purchaseHistoryKey))
        .toList();

    await _box.deleteAll(keysToDelete);
  }

  /// すべてのサブスクリプションデータをクリア
  Future<void> clearAllSubscriptionData() async {
    await _box.clear();
  }

  /// サブスクリプション統計を取得
  Future<Map<String, dynamic>> getSubscriptionStatistics() async {
    final history = await getPurchaseHistory();
    final currentStatus = await getSubscriptionStatus();

    final totalPurchases = history.length;
    final activePurchases = history.where((status) => status.isActive).length;
    final expiredPurchases = history.where((status) => status.isExpired).length;

    return {
      'totalPurchases': totalPurchases,
      'activePurchases': activePurchases,
      'expiredPurchases': expiredPurchases,
      'currentType': currentStatus?.type.id ?? SubscriptionType.free.id,
      'isCurrentlyActive': currentStatus?.isActive ?? false,
      'daysRemaining': currentStatus?.daysRemaining ?? 0,
    };
  }

  /// データベースを閉じる
  Future<void> close() async {
    await _box.close();
  }

  /// データが存在するかチェック
  bool get hasSubscriptionData => _box.containsKey(_statusKey);

  /// 購入履歴の件数を取得
  int get purchaseHistoryCount {
    return _box.keys
        .where((key) => key.toString().startsWith(_purchaseHistoryKey))
        .length;
  }
}
