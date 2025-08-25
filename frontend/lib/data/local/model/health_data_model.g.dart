// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthDataModelAdapter extends TypeAdapter<HealthDataModel> {
  @override
  final int typeId = 0;

  @override
  HealthDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthDataModel()
      ..date = fields[0] as String
      ..stepCount = fields[1] as int
      ..distance = fields[2] as double
      ..caloriesBurned = fields[3] as int
      ..activityLevel = fields[4] as int
      ..activeTime = fields[5] as int
      ..syncStatus = fields[6] as String
      ..createdAt = fields[7] as String?
      ..updatedAt = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, HealthDataModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.stepCount)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
      ..write(obj.caloriesBurned)
      ..writeByte(4)
      ..write(obj.activityLevel)
      ..writeByte(5)
      ..write(obj.activeTime)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
