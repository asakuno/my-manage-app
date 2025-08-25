import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/subscription_provider.dart';

/// 広告バナーウィジェット
/// 無料ユーザーに広告を表示する
class AdBanner extends ConsumerStatefulWidget {
  const AdBanner({
    super.key,
    this.adSize = AdSize.banner,
    this.backgroundColor,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdClicked,
  });

  /// 広告サイズ
  final AdSize adSize;

  /// 背景色
  final Color? backgroundColor;

  /// 広告読み込み成功時のコールバック
  final VoidCallback? onAdLoaded;

  /// 広告読み込み失敗時のコールバック
  final VoidCallback? onAdFailedToLoad;

  /// 広告クリック時のコールバック
  final VoidCallback? onAdClicked;

  @override
  ConsumerState<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends ConsumerState<AdBanner> {
  bool _isAdLoaded = false;
  final bool _isAdFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowAds = ref.watch(shouldShowAdsProvider);

    return shouldShowAds.when(
      data: (showAds) {
        if (!showAds) {
          return const SizedBox.shrink();
        }

        return _buildAdContainer();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildAdContainer() {
    if (_isAdFailed) {
      return _buildFallbackContent();
    }

    if (!_isAdLoaded) {
      return _buildLoadingPlaceholder();
    }

    return Container(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _buildMockAd(),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildFallbackContent() {
    return Container(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Text(
          'Advertisement',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildMockAd() {
    // モック広告の実装
    // 実際の実装では Google Mobile Ads SDK を使用
    return GestureDetector(
      onTap: () {
        widget.onAdClicked?.call();
        _handleAdClick();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, color: Colors.blue.shade600, size: 24),
            const SizedBox(height: 4),
            const Text(
              'Fitness App',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'Get fit with our app!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadAd() {
    // モック実装：実際の広告読み込みをシミュレート
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isAdLoaded = true;
        });
        widget.onAdLoaded?.call();
      }
    });
  }

  void _handleAdClick() {
    // 広告クリック処理
    debugPrint('Ad clicked');
  }

  @override
  void dispose() {
    // 実際の実装では広告リソースを解放
    super.dispose();
  }
}

/// インタースティシャル広告ウィジェット
class InterstitialAdWidget extends ConsumerWidget {
  const InterstitialAdWidget({
    super.key,
    required this.child,
    this.showAdAfterActions = 5,
    this.onAdShown,
    this.onAdDismissed,
  });

  /// 子ウィジェット
  final Widget child;

  /// 何回のアクション後に広告を表示するか
  final int showAdAfterActions;

  /// 広告表示時のコールバック
  final VoidCallback? onAdShown;

  /// 広告終了時のコールバック
  final VoidCallback? onAdDismissed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowAds = ref.watch(shouldShowAdsProvider);

    return shouldShowAds.when(
      data: (showAds) {
        if (!showAds) {
          return child;
        }

        return _InterstitialAdWrapper(
          showAdAfterActions: showAdAfterActions,
          onAdShown: onAdShown,
          onAdDismissed: onAdDismissed,
          child: child,
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

class _InterstitialAdWrapper extends StatefulWidget {
  const _InterstitialAdWrapper({
    required this.child,
    required this.showAdAfterActions,
    this.onAdShown,
    this.onAdDismissed,
  });

  final Widget child;
  final int showAdAfterActions;
  final VoidCallback? onAdShown;
  final VoidCallback? onAdDismissed;

  @override
  State<_InterstitialAdWrapper> createState() => _InterstitialAdWrapperState();
}

class _InterstitialAdWrapperState extends State<_InterstitialAdWrapper> {
  int _actionCount = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: _handleUserAction, child: widget.child);
  }

  void _handleUserAction() {
    _actionCount++;

    if (_actionCount >= widget.showAdAfterActions) {
      _showInterstitialAd();
      _actionCount = 0; // リセット
    }
  }

  void _showInterstitialAd() {
    widget.onAdShown?.call();

    // モック実装：実際のインタースティシャル広告を表示
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MockInterstitialAd(
        onDismissed: () {
          Navigator.of(context).pop();
          widget.onAdDismissed?.call();
        },
      ),
    );
  }
}

class _MockInterstitialAd extends StatefulWidget {
  const _MockInterstitialAd({required this.onDismissed});

  final VoidCallback onDismissed;

  @override
  State<_MockInterstitialAd> createState() => _MockInterstitialAdState();
}

class _MockInterstitialAdState extends State<_MockInterstitialAd> {
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _countdown > 0) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        width: double.infinity,
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_filled, color: Colors.white, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Advertisement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a sample interstitial ad',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            if (_countdown > 0)
              Text(
                'Skip in $_countdown seconds',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              )
            else
              ElevatedButton(
                onPressed: widget.onDismissed,
                child: const Text('Skip Ad'),
              ),
          ],
        ),
      ),
    );
  }
}

/// 広告サイズを定義するクラス
class AdSize {
  const AdSize({required this.width, required this.height});

  final int width;
  final int height;

  static const AdSize banner = AdSize(width: 320, height: 50);
  static const AdSize largeBanner = AdSize(width: 320, height: 100);
  static const AdSize mediumRectangle = AdSize(width: 300, height: 250);
  static const AdSize fullBanner = AdSize(width: 468, height: 60);
  static const AdSize leaderboard = AdSize(width: 728, height: 90);
}

/// 広告の読み込み状態を管理するプロバイダー
final adLoadingStateProvider = StateProvider<bool>((ref) => false);

/// 広告の表示回数を管理するプロバイダー
final adImpressionCountProvider = StateProvider<int>((ref) => 0);
