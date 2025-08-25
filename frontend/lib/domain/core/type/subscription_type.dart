/// サブスクリプションタイプを表すEnum
enum SubscriptionType {
  /// 無料プラン
  free('free', 'Free Plan', 0.0),

  /// プレミアムプラン（月額）
  premium('premium', 'Premium Plan', 9.99);

  const SubscriptionType(this.id, this.displayName, this.price);

  /// サブスクリプションID
  final String id;

  /// 表示名
  final String displayName;

  /// 価格（USD）
  final double price;
}

/// プレミアム機能を表すEnum
enum PremiumFeature {
  /// 詳細分析機能
  detailedAnalytics('detailed_analytics', 'Detailed Analytics'),

  /// データエクスポート機能
  dataExport('data_export', 'Data Export'),

  /// 広告非表示
  adFree('ad_free', 'Ad-Free Experience'),

  /// 無制限友達追加
  unlimitedFriends('unlimited_friends', 'Unlimited Friends'),

  /// カスタム目標設定
  customGoals('custom_goals', 'Custom Goals');

  const PremiumFeature(this.id, this.displayName);

  /// 機能ID
  final String id;

  /// 表示名
  final String displayName;
}
