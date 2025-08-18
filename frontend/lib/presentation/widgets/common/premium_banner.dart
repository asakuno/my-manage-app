import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/core/type/subscription_type.dart';
import '../../provider/subscription_provider.dart';

/// プレミアム機能への誘導バナーウィジェット
/// 無料ユーザーにプレミアム機能をアピールする
class PremiumBanner extends ConsumerWidget {
  const PremiumBanner({
    super.key,
    this.feature,
    this.message,
    this.showCloseButton = true,
    this.onUpgrade,
    this.onClose,
  });

  /// 関連するプレミアム機能
  final PremiumFeature? feature;

  /// カスタムメッセージ
  final String? message;

  /// 閉じるボタンを表示するかどうか
  final bool showCloseButton;

  /// アップグレードボタンタップ時のコールバック
  final VoidCallback? onUpgrade;

  /// 閉じるボタンタップ時のコールバック
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionStateProvider);

    return subscriptionState.when(
      data: (status) {
        // プレミアムユーザーには表示しない
        if (status.type == SubscriptionType.premium && status.isActive) {
          return const SizedBox.shrink();
        }

        return _buildBanner(context, ref);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBanner(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withValues(alpha: 0.1),
            theme.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(showCloseButton ? 16 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Premium Feature',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message ?? _getDefaultMessage(),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleUpgrade(context, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Upgrade to Premium'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => _showFeatureDetails(context),
                      child: const Text('Learn More'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showCloseButton)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ),
        ],
      ),
    );
  }

  String _getDefaultMessage() {
    switch (feature) {
      case PremiumFeature.detailedAnalytics:
        return 'Get detailed insights into your activity patterns with advanced analytics and trends.';
      case PremiumFeature.dataExport:
        return 'Export your health data in CSV or PDF format for external analysis.';
      case PremiumFeature.adFree:
        return 'Enjoy an ad-free experience and focus on your health goals.';
      case PremiumFeature.unlimitedFriends:
        return 'Add unlimited friends and compete with your entire network.';
      case PremiumFeature.customGoals:
        return 'Set custom activity goals and personalize your experience.';
      default:
        return 'Unlock premium features to get the most out of your health journey.';
    }
  }

  void _handleUpgrade(BuildContext context, WidgetRef ref) {
    if (onUpgrade != null) {
      onUpgrade!();
    } else {
      _showUpgradeDialog(context, ref);
    }
  }

  void _showUpgradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => PremiumUpgradeDialog(feature: feature),
    );
  }

  void _showFeatureDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PremiumFeaturesSheet(highlightedFeature: feature),
    );
  }
}

/// プレミアムアップグレードダイアログ
class PremiumUpgradeDialog extends ConsumerWidget {
  const PremiumUpgradeDialog({super.key, this.feature});

  final PremiumFeature? feature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.star, color: theme.primaryColor),
          const SizedBox(width: 8),
          const Text('Upgrade to Premium'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unlock all premium features for just \$9.99/month:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...PremiumFeature.values.map((f) => _buildFeatureItem(f, theme)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: () => _handlePurchase(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Upgrade Now'),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(PremiumFeature feature, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: theme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature.displayName,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();

    final purchaseNotifier = ref.read(subscriptionPurchaseProvider.notifier);
    final success = await purchaseNotifier.purchase(SubscriptionType.premium);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Successfully upgraded to Premium!'
                : 'Purchase failed. Please try again.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

/// プレミアム機能詳細シート
class PremiumFeaturesSheet extends StatelessWidget {
  const PremiumFeaturesSheet({super.key, this.highlightedFeature});

  final PremiumFeature? highlightedFeature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: theme.primaryColor, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Premium Features',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...PremiumFeature.values.map(
            (feature) => _buildDetailedFeatureItem(
              feature,
              theme,
              isHighlighted: feature == highlightedFeature,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Upgrade to Premium - \$9.99/month',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedFeatureItem(
    PremiumFeature feature,
    ThemeData theme, {
    bool isHighlighted = false,
  }) {
    final descriptions = {
      PremiumFeature.detailedAnalytics:
          'Advanced charts, trends, and insights into your activity patterns',
      PremiumFeature.dataExport:
          'Export your data in CSV or PDF format for external analysis',
      PremiumFeature.adFree:
          'Enjoy a clean, distraction-free experience without ads',
      PremiumFeature.unlimitedFriends:
          'Add unlimited friends and compete with your entire network',
      PremiumFeature.customGoals:
          'Set personalized goals and customize your activity levels',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? theme.primaryColor.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: theme.primaryColor, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: theme.primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptions[feature] ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
