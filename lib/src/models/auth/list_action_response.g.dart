// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_action_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListActionResponseAdapter extends TypeAdapter<ListActionResponse> {
  @override
  final typeId = 149;

  @override
  ListActionResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListActionResponse(
      success: fields[0] as bool,
      statusCode: (fields[1] as num).toInt(),
      statusMessage: fields[2] as String,
      listId: (fields[3] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ListActionResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.statusCode)
      ..writeByte(2)
      ..write(obj.statusMessage)
      ..writeByte(3)
      ..write(obj.listId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListActionResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListActionResponse _$ListActionResponseFromJson(Map<String, dynamic> json) =>
    _ListActionResponse(
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
      statusMessage: json['status_message'] as String,
      listId: (json['list_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ListActionResponseToJson(_ListActionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'status_message': instance.statusMessage,
      'list_id': instance.listId,
    };
