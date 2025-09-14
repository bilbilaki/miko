// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RatingResponseAdapter extends TypeAdapter<RatingResponse> {
  @override
  final typeId = 150;

  @override
  RatingResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingResponse(
      success: fields[0] as bool,
      statusCode: (fields[1] as num).toInt(),
      statusMessage: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RatingResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.statusCode)
      ..writeByte(2)
      ..write(obj.statusMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RatingResponse _$RatingResponseFromJson(Map<String, dynamic> json) =>
    _RatingResponse(
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
      statusMessage: json['status_message'] as String,
    );

Map<String, dynamic> _$RatingResponseToJson(_RatingResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'status_message': instance.statusMessage,
    };
