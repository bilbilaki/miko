// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_providers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchProviderAdapter extends TypeAdapter<WatchProvider> {
  @override
  final typeId = 122;

  @override
  WatchProvider read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchProvider(
      providerId: (fields[0] as num).toInt(),
      providerName: fields[1] as String,
      logoPath: fields[2] as String?,
      displayPriority: (fields[3] as num?)?.toInt(),
      type: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WatchProvider obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.providerId)
      ..writeByte(1)
      ..write(obj.providerName)
      ..writeByte(2)
      ..write(obj.logoPath)
      ..writeByte(3)
      ..write(obj.displayPriority)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchProviderCountryAdapter extends TypeAdapter<WatchProviderCountry> {
  @override
  final typeId = 123;

  @override
  WatchProviderCountry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchProviderCountry(
      link: fields[0] as String?,
      flatrate: (fields[1] as List?)?.cast<WatchProvider>(),
      rent: (fields[2] as List?)?.cast<WatchProvider>(),
      buy: (fields[3] as List?)?.cast<WatchProvider>(),
      ads: (fields[4] as List?)?.cast<WatchProvider>(),
    );
  }

  @override
  void write(BinaryWriter writer, WatchProviderCountry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.link)
      ..writeByte(1)
      ..write(obj.flatrate)
      ..writeByte(2)
      ..write(obj.rent)
      ..writeByte(3)
      ..write(obj.buy)
      ..writeByte(4)
      ..write(obj.ads);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchProviderCountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchProvidersResponseAdapter
    extends TypeAdapter<WatchProvidersResponse> {
  @override
  final typeId = 124;

  @override
  WatchProvidersResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchProvidersResponse(
      id: (fields[0] as num).toInt(),
      results: (fields[1] as Map).cast<String, WatchProviderCountry>(),
    );
  }

  @override
  void write(BinaryWriter writer, WatchProvidersResponse obj) {
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
      other is WatchProvidersResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchProvider _$WatchProviderFromJson(Map<String, dynamic> json) =>
    _WatchProvider(
      providerId: (json['providerId'] as num).toInt(),
      providerName: json['providerName'] as String,
      logoPath: json['logo_path'] as String?,
      displayPriority: (json['display_priority'] as num?)?.toInt(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$WatchProviderToJson(_WatchProvider instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'logo_path': instance.logoPath,
      'display_priority': instance.displayPriority,
      'type': instance.type,
    };

_WatchProviderCountry _$WatchProviderCountryFromJson(
  Map<String, dynamic> json,
) => _WatchProviderCountry(
  link: json['link'] as String?,
  flatrate: (json['flatrate'] as List<dynamic>?)
      ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
      .toList(),
  rent: (json['rent'] as List<dynamic>?)
      ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
      .toList(),
  buy: (json['buy'] as List<dynamic>?)
      ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
      .toList(),
  ads: (json['ads'] as List<dynamic>?)
      ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WatchProviderCountryToJson(
  _WatchProviderCountry instance,
) => <String, dynamic>{
  'link': instance.link,
  'flatrate': instance.flatrate?.map((e) => e.toJson()).toList(),
  'rent': instance.rent?.map((e) => e.toJson()).toList(),
  'buy': instance.buy?.map((e) => e.toJson()).toList(),
  'ads': instance.ads?.map((e) => e.toJson()).toList(),
};

_WatchProvidersResponse _$WatchProvidersResponseFromJson(
  Map<String, dynamic> json,
) => _WatchProvidersResponse(
  id: (json['id'] as num).toInt(),
  results: (json['results'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, WatchProviderCountry.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$WatchProvidersResponseToJson(
  _WatchProvidersResponse instance,
) => <String, dynamic>{'id': instance.id, 'results': instance.results};
