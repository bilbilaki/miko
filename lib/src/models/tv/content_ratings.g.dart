// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_ratings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContentRatingItemAdapter extends TypeAdapter<ContentRatingItem> {
  @override
  final typeId = 139;

  @override
  ContentRatingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentRatingItem(
      iso31661: fields[0] as String,
      rating: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContentRatingItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.iso31661)
      ..writeByte(1)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentRatingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TvContentRatingsResponseAdapter
    extends TypeAdapter<TvContentRatingsResponse> {
  @override
  final typeId = 140;

  @override
  TvContentRatingsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvContentRatingsResponse(
      id: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<ContentRatingItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, TvContentRatingsResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvContentRatingsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentRatingItem _$ContentRatingItemFromJson(Map<String, dynamic> json) =>
    _ContentRatingItem(
      iso31661: json['iso_3166_1'] as String,
      rating: json['rating'] as String,
    );

Map<String, dynamic> _$ContentRatingItemToJson(_ContentRatingItem instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'rating': instance.rating,
    };

_TvContentRatingsResponse _$TvContentRatingsResponseFromJson(
  Map<String, dynamic> json,
) => _TvContentRatingsResponse(
  id: (json['id'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => ContentRatingItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TvContentRatingsResponseToJson(
  _TvContentRatingsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'results': instance.results.map((e) => e.toJson()).toList(),
};
