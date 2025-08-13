import 'package:flutter/material.dart';

/// アプリケーション全体で使用される色定義
class AppColors {
  // プライマリカラー（緑系統）
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);

  // アクティビティレベル色（GitHubの草風）
  static const Color activityNone = Color(0xFFEEEEEE);
  static const Color activityLevel1 = Color(0xFFC8E6C9);
  static const Color activityLevel2 = Color(0xFF81C784);
  static const Color activityLevel3 = Color(0xFF4CAF50);
  static const Color activityLevel4 = Color(0xFF2E7D32);

  // ダークモード用アクティビティレベル色
  static const Color activityNoneDark = Color(0xFF2C2C2C);
  static const Color activityLevel1Dark = Color(0xFF1B5E20);
  static const Color activityLevel2Dark = Color(0xFF2E7D32);
  static const Color activityLevel3Dark = Color(0xFF388E3C);
  static const Color activityLevel4Dark = Color(0xFF4CAF50);

  // セカンダリカラー
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFF57C00);

  // システムカラー
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);

  // 背景色
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // テキストカラー
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // プレミアム機能カラー
  static const Color premium = Color(0xFFFFD700);
  static const Color premiumGradientStart = Color(0xFFFFD700);
  static const Color premiumGradientEnd = Color(0xFFFFA000);

  // プライベートコンストラクタ
  AppColors._();

  /// アクティビティレベルに応じた色を取得
  static Color getActivityColor(int level, {bool isDark = false}) {
    if (isDark) {
      switch (level) {
        case 0:
          return activityNoneDark;
        case 1:
          return activityLevel1Dark;
        case 2:
          return activityLevel2Dark;
        case 3:
          return activityLevel3Dark;
        case 4:
          return activityLevel4Dark;
        default:
          return activityNoneDark;
      }
    } else {
      switch (level) {
        case 0:
          return activityNone;
        case 1:
          return activityLevel1;
        case 2:
          return activityLevel2;
        case 3:
          return activityLevel3;
        case 4:
          return activityLevel4;
        default:
          return activityNone;
      }
    }
  }
}
