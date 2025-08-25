// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 2;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..email = fields[2] as String
      ..dailyStepGoal = fields[3] as int
      ..avatarUrl = fields[4] as String?
      ..age = fields[5] as int?
      ..height = fields[6] as double?
      ..weight = fields[7] as double?
      ..timezone = fields[8] as String
      ..language = fields[9] as String
      ..privacyLevel = fields[10] as String
      ..notificationsEnabled = fields[11] as bool
      ..createdAt = fields[12] as String?
      ..updatedAt = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.dailyStepGoal)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.height)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.timezone)
      ..writeByte(9)
      ..write(obj.language)
      ..writeByte(10)
      ..write(obj.privacyLevel)
      ..writeByte(11)
      ..write(obj.notificationsEnabled)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
