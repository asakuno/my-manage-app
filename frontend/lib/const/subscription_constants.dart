/// サブスクリプション関連の定数定義
class SubscriptionConstants {
  // プロダクトID（実際のApp Store/Google Playで設定する値）
  static const String premiumMonthlyProductId = 'premium_monthly';
  static const String premiumYearlyProductId = 'premium_yearly';

  // サブスクリプション価格（表示用、実際の価格はストアから取得）
  static const String premiumMonthlyPrice = '¥480';
  static const String premiumYearlyPrice = '¥4,800';

  // 無料トライアル期間
  static const int freeTrialDays = 7;

  // プレミアム機能制限
  static const int freeUserFriendLimit = 10;
  static const int premiumUserFriendLimit = 50;
  static const int freeUserExportLimit = 0; // エクスポート不可
  static const int premiumUserExportLimit = -1; // 無制限

  // 広告設定
  static const Duration adDisplayInterval = Duration(minutes: 5);
  static const int maxAdsPerSession = 10;

  // サブスクリプション検証設定
  static const Duration subscriptionCheckInterval = Duration(hours: 24);
  static const Duration gracePeriod = Duration(days: 3);

  // レシート検証設定
  static const int maxReceiptVerificationRetries = 3;
  static const Duration receiptVerificationTimeout = Duration(seconds: 30);

  // プライベートコンストラクタ
  SubscriptionConstants._();

  /// プロダクトIDのリストを取得
  static List<String> get allProductIds => [
    premiumMonthlyProductId,
    premiumYearlyProductId,
  ];

  /// 無料ユーザーの制限チェック
  static bool canAddMoreFriends(int currentFriendCount, bool isPremium) {
    final limit = isPremium ? premiumUserFriendLimit : freeUserFriendLimit;
    return currentFriendCount < limit;
  }

  /// エクスポート機能の利用可否チェック
  static bool canExportData(bool isPremium) {
    return isPremium;
  }
}
