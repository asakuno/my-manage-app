// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_status_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionStatusModelAdapter
    extends TypeAdapter<SubscriptionStatusModel> {
  @override
  final int typeId = 1;

  @override
  SubscriptionStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionStatusModel()
      ..type = fields[0] as String
      ..isActive = fields[1] as bool
      ..availableFeatures = (fields[2] as List).cast<String>()
      ..expiryDate = fields[3] as String?
      ..purchaseDate = fields[4] as String?
      ..autoRenew = fields[5] as bool
      ..trialEndDate = fields[6] as String?
      ..originalTransactionId = fields[7] as String?
      ..productId = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, SubscriptionStatusModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.isActive)
      ..writeByte(2)
      ..write(obj.availableFeatures)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.purchaseDate)
      ..writeByte(5)
      ..write(obj.autoRenew)
      ..writeByte(6)
      ..write(obj.trialEndDate)
      ..writeByte(7)
      ..write(obj.originalTransactionId)
      ..writeByte(8)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
