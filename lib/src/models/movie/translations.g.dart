// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslationDataAdapter extends TypeAdapter<TranslationData> {
  @override
  final typeId = 115;

  @override
  TranslationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationData(
      title: fields[0] as String?,
      overview: fields[1] as String?,
      homepage: fields[2] as String?,
      tagline: fields[3] as String?,
      runtime: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.overview)
      ..writeByte(2)
      ..write(obj.homepage)
      ..writeByte(3)
      ..write(obj.tagline)
      ..writeByte(4)
      ..write(obj.runtime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslationItemAdapter extends TypeAdapter<TranslationItem> {
  @override
  final typeId = 116;

  @override
  TranslationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationItem(
      iso6391: fields[0] as String,
      name: fields[1] as String,
      englishName: fields[2] as String,
      data: fields[3] as TranslationData,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationItem obj) {
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
      other is TranslationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslationsResponseAdapter extends TypeAdapter<TranslationsResponse> {
  @override
  final typeId = 117;

  @override
  TranslationsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationsResponse(
      id: (fields[0] as num).toInt(),
      translations: (fields[1] as List).cast<TranslationItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, TranslationsResponse obj) {
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
      other is TranslationsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranslationData _$TranslationDataFromJson(Map<String, dynamic> json) =>
    _TranslationData(
      title: json['title'] as String?,
      overview: json['overview'] as String?,
      homepage: json['homepage'] as String?,
      tagline: json['tagline'] as String?,
      runtime: json['runtime'] as String?,
    );

Map<String, dynamic> _$TranslationDataToJson(_TranslationData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'overview': instance.overview,
      'homepage': instance.homepage,
      'tagline': instance.tagline,
      'runtime': instance.runtime,
    };

_TranslationItem _$TranslationItemFromJson(Map<String, dynamic> json) =>
    _TranslationItem(
      iso6391: json['iso_639_1'] as String,
      name: json['name'] as String,
      englishName: json['english_name'] as String,
      data: TranslationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TranslationItemToJson(_TranslationItem instance) =>
    <String, dynamic>{
      'iso_639_1': instance.iso6391,
      'name': instance.name,
      'english_name': instance.englishName,
      'data': instance.data.toJson(),
    };

_TranslationsResponse _$TranslationsResponseFromJson(
  Map<String, dynamic> json,
) => _TranslationsResponse(
  id: (json['id'] as num).toInt(),
  translations: (json['translations'] as List<dynamic>)
      .map((e) => TranslationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TranslationsResponseToJson(
  _TranslationsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'translations': instance.translations.map((e) => e.toJson()).toList(),
};
