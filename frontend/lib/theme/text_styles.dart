import 'package:flutter/material.dart';
import 'colors.dart';

/// アプリケーション全体で使用されるテキストスタイル定義
class AppTextStyles {
  // ヘッダー系
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ボディ系
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // ラベル系
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // 特殊用途
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // 数値表示用（歩数など）
  static const TextStyle numberLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle numberMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle numberSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // プライベートコンストラクタ
  AppTextStyles._();

  /// ライトテーマ用のテキストスタイルを取得
  static TextTheme getLightTextTheme() {
    return TextTheme(
      displayLarge: h1.copyWith(color: AppColors.textPrimaryLight),
      displayMedium: h2.copyWith(color: AppColors.textPrimaryLight),
      displaySmall: h3.copyWith(color: AppColors.textPrimaryLight),
      headlineLarge: h3.copyWith(color: AppColors.textPrimaryLight),
      headlineMedium: h4.copyWith(color: AppColors.textPrimaryLight),
      headlineSmall: labelLarge.copyWith(color: AppColors.textPrimaryLight),
      titleLarge: h4.copyWith(color: AppColors.textPrimaryLight),
      titleMedium: labelLarge.copyWith(color: AppColors.textPrimaryLight),
      titleSmall: labelMedium.copyWith(color: AppColors.textPrimaryLight),
      bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryLight),
      bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryLight),
      bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryLight),
      labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryLight),
      labelMedium: labelMedium.copyWith(color: AppColors.textSecondaryLight),
      labelSmall: labelSmall.copyWith(color: AppColors.textSecondaryLight),
    );
  }

  /// ダークテーマ用のテキストスタイルを取得
  static TextTheme getDarkTextTheme() {
    return TextTheme(
      displayLarge: h1.copyWith(color: AppColors.textPrimaryDark),
      displayMedium: h2.copyWith(color: AppColors.textPrimaryDark),
      displaySmall: h3.copyWith(color: AppColors.textPrimaryDark),
      headlineLarge: h3.copyWith(color: AppColors.textPrimaryDark),
      headlineMedium: h4.copyWith(color: AppColors.textPrimaryDark),
      headlineSmall: labelLarge.copyWith(color: AppColors.textPrimaryDark),
      titleLarge: h4.copyWith(color: AppColors.textPrimaryDark),
      titleMedium: labelLarge.copyWith(color: AppColors.textPrimaryDark),
      titleSmall: labelMedium.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryDark),
      labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryDark),
      labelMedium: labelMedium.copyWith(color: AppColors.textSecondaryDark),
      labelSmall: labelSmall.copyWith(color: AppColors.textSecondaryDark),
    );
  }
}
