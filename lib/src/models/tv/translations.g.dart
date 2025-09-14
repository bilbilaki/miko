// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvTranslationDataAdapter extends TypeAdapter<TvTranslationData> {
  @override
  final typeId = 135;

  @override
  TvTranslationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvTranslationData(
      name: fields[0] as String?,
      overview: fields[1] as String?,
      homepage: fields[2] as String?,
      tagline: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TvTranslationData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.overview)
      ..writeByte(2)
      ..write(obj.homepage)
      ..writeByte(3)
      ..write(obj.tagline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvTranslationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TvTranslationItemAdapter extends TypeAdapter<TvTranslationItem> {
  @override
  final typeId = 136;

  @override
  TvTranslationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvTranslationItem(
      iso6391: fields[0] as String,
      name: fields[1] as String,
      englishName: fields[2] as String,
      data: fields[3] as TvTranslationData,
    );
  }

  @override
  void write(BinaryWriter writer, TvTranslationItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.iso6391)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.englishName)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvTranslationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TvTranslationsResponseAdapter
    extends TypeAdapter<TvTranslationsResponse> {
  @override
  final typeId = 137;

  @override
  TvTranslationsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvTranslationsResponse(
      id: (fields[0] as num).toInt(),
      translations: (fields[1] as List).cast<TvTranslationItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, TvTranslationsResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.translations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvTranslationsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvTranslationData _$TvTranslationDataFromJson(Map<String, dynamic> json) =>
    _TvTranslationData(
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      homepage: json['homepage'] as String?,
      tagline: json['tagline'] as String?,
    );

Map<String, dynamic> _$TvTranslationDataToJson(_TvTranslationData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'overview': instance.overview,
      'homepage': instance.homepage,
      'tagline': instance.tagline,
    };

_TvTranslationItem _$TvTranslationItemFromJson(Map<String, dynamic> json) =>
    _TvTranslationItem(
      iso6391: json['iso_639_1'] as String,
      name: json['name'] as String,
      englishName: json['english_name'] as String,
      data: TvTranslationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TvTranslationItemToJson(_TvTranslationItem instance) =>
    <String, dynamic>{
      'iso_639_1': instance.iso6391,
      'name': instance.name,
      'english_name': instance.englishName,
      'data': instance.data.toJson(),
    };

_TvTranslationsResponse _$TvTranslationsResponseFromJson(
  Map<String, dynamic> json,
) => _TvTranslationsResponse(
  id: (json['id'] as num).toInt(),
  translations: (json['translations'] as List<dynamic>)
      .map((e) => TvTranslationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TvTranslationsResponseToJson(
  _TvTranslationsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'translations': instance.translations.map((e) => e.toJson()).toList(),
};
