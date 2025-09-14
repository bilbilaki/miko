// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_ids.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvExternalIdsAdapter extends TypeAdapter<TvExternalIds> {
  @override
  final typeId = 138;

  @override
  TvExternalIds read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvExternalIds(
      id: (fields[0] as num).toInt(),
      imdbId: fields[1] as String?,
      freebaseMid: fields[2] as String?,
      freebaseId: fields[3] as String?,
      tvdbId: fields[4] as String?,
      tvrageId: fields[5] as String?,
      facebookId: fields[6] as String?,
      instagramId: fields[7] as String?,
      twitterId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TvExternalIds obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imdbId)
      ..writeByte(2)
      ..write(obj.freebaseMid)
      ..writeByte(3)
      ..write(obj.freebaseId)
      ..writeByte(4)
      ..write(obj.tvdbId)
      ..writeByte(5)
      ..write(obj.tvrageId)
      ..writeByte(6)
      ..write(obj.facebookId)
      ..writeByte(7)
      ..write(obj.instagramId)
      ..writeByte(8)
      ..write(obj.twitterId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvExternalIdsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvExternalIds _$TvExternalIdsFromJson(Map<String, dynamic> json) =>
    _TvExternalIds(
      id: (json['id'] as num).toInt(),
      imdbId: json['imdbId'] as String?,
      freebaseMid: json['freebaseMid'] as String?,
      freebaseId: json['freebaseId'] as String?,
      tvdbId: json['tvdbId'] as String?,
      tvrageId: json['tvrageId'] as String?,
      facebookId: json['facebook_id'] as String?,
      instagramId: json['instagram_id'] as String?,
      twitterId: json['twitter_id'] as String?,
    );

Map<String, dynamic> _$TvExternalIdsToJson(_TvExternalIds instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imdbId': instance.imdbId,
      'freebaseMid': instance.freebaseMid,
      'freebaseId': instance.freebaseId,
      'tvdbId': instance.tvdbId,
      'tvrageId': instance.tvrageId,
      'facebook_id': instance.facebookId,
      'instagram_id': instance.instagramId,
      'twitter_id': instance.twitterId,
    };
