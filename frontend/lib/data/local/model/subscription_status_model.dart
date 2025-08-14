import 'package:hive/hive.dart';
import '../../../domain/core/entity/subscription_status.dart';
import '../../../domain/core/type/subscription_type.dart';

part 'subscription_status_model.g.dart';

/// サブスクリプション状態のHiveモデル
/// ローカルストレージに保存するためのデータモデル
@HiveType(typeId: 1)
class SubscriptionStatusModel extends HiveObject {
  /// サブスクリプションタイプ
  @HiveField(0)
  late String type;

  /// アクティブ状態
  @HiveField(1)
  late bool isActive;

  /// 利用可能なプレミアム機能のリスト
  @HiveField(2)
  late List<String> availableFeatures;

  /// 有効期限（ISO 8601形式）
  @HiveField(3)
  String? expiryDate;

  /// 購入日（ISO 8601形式）
  @HiveField(4)
  String? purchaseDate;

  /// 自動更新設定
  @HiveField(5)
  late bool autoRenew;

  /// トライアル終了日（ISO 8601形式）
  @HiveField(6)
  String? trialEndDate;

  /// 元のトランザクションID
  @HiveField(7)
  String? originalTransactionId;

  /// プロダクトID
  @HiveField(8)
  String? productId;

  SubscriptionStatusModel();

  /// エンティティからモデルを作成
  SubscriptionStatusModel.fromEntity(SubscriptionStatus entity) {
    type = entity.type.id;
    isActive = entity.isActive;
    availableFeatures = entity.availableFeatures
        .map((feature) => feature.id)
        .toList();
    expiryDate = entity.expiryDate?.toIso8601String();
    purchaseDate = entity.purchaseDate?.toIso8601String();
    autoRenew = entity.autoRenew;
    trialEndDate = entity.trialEndDate?.toIso8601String();
    originalTransactionId = entity.originalTransactionId;
    productId = entity.productId;
  }

  /// モデルからエンティティを作成
  SubscriptionStatus toEntity() {
    return SubscriptionStatus(
      type: SubscriptionType.values.firstWhere(
        (subscriptionType) => subscriptionType.id == type,
        orElse: () => SubscriptionType.free,
      ),
      isActive: isActive,
      availableFeatures: availableFeatures
          .map(
            (featureId) => PremiumFeature.values.firstWhere(
              (feature) => feature.id == featureId,
              orElse: () => PremiumFeature.detailedAnalytics,
            ),
          )
          .toList(),
      expiryDate: expiryDate != null ? DateTime.parse(expiryDate!) : null,
      purchaseDate: purchaseDate != null ? DateTime.parse(purchaseDate!) : null,
      autoRenew: autoRenew,
      trialEndDate: trialEndDate != null ? DateTime.parse(trialEndDate!) : null,
      originalTransactionId: originalTransactionId,
      productId: productId,
    );
  }

  /// JSONからモデルを作成
  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    final model = SubscriptionStatusModel();
    model.type = json['type'] as String;
    model.isActive = json['isActive'] as bool;
    model.availableFeatures = (json['availableFeatures'] as List<dynamic>)
        .map((feature) => feature as String)
        .toList();
    model.expiryDate = json['expiryDate'] as String?;
    model.purchaseDate = json['purchaseDate'] as String?;
    model.autoRenew = json['autoRenew'] as bool? ?? false;
    model.trialEndDate = json['trialEndDate'] as String?;
    model.originalTransactionId = json['originalTransactionId'] as String?;
    model.productId = json['productId'] as String?;
    return model;
  }

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'isActive': isActive,
      'availableFeatures': availableFeatures,
      'expiryDate': expiryDate,
      'purchaseDate': purchaseDate,
      'autoRenew': autoRenew,
      'trialEndDate': trialEndDate,
      'originalTransactionId': originalTransactionId,
      'productId': productId,
    };
  }

  @override
  String toString() {
    return 'SubscriptionStatusModel(type: $type, isActive: $isActive, '
        'availableFeatures: $availableFeatures, expiryDate: $expiryDate, '
        'purchaseDate: $purchaseDate, autoRenew: $autoRenew, '
        'trialEndDate: $trialEndDate, originalTransactionId: $originalTransactionId, '
        'productId: $productId)';
  }
}
