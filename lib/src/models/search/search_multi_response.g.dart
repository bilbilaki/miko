// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_multi_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchResultItemAdapter extends TypeAdapter<SearchResultItem> {
  @override
  final typeId = 141;

  @override
  SearchResultItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchResultItem(
      id: (fields[0] as num).toInt(),
      mediaType: fields[1] as String,
      title: fields[2] as String?,
      originalTitle: fields[3] as String?,
      releaseDate: fields[4] as String?,
      name: fields[5] as String?,
      originalName: fields[6] as String?,
      firstAirDate: fields[7] as String?,
      overview: fields[8] as String?,
      posterPath: fields[9] as String?,
      backdropPath: fields[10] as String?,
      profilePath: fields[11] as String?,
      popularity: (fields[12] as num?)?.toDouble(),
      voteAverage: (fields[13] as num?)?.toDouble(),
      voteCount: (fields[14] as num?)?.toInt(),
      knownFor: (fields[15] as List?)?.cast<MovieListItemDetail>(),
      knownForDepartment: fields[16] as String?,
      gender: (fields[17] as num?)?.toInt(),
      adult: fields[18] as bool?,
      originalLanguage: fields[19] as String?,
      genreIds: (fields[20] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, SearchResultItem obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mediaType)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.originalTitle)
      ..writeByte(4)
      ..write(obj.releaseDate)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.originalName)
      ..writeByte(7)
      ..write(obj.firstAirDate)
      ..writeByte(8)
      ..write(obj.overview)
      ..writeByte(9)
      ..write(obj.posterPath)
      ..writeByte(10)
      ..write(obj.backdropPath)
      ..writeByte(11)
      ..write(obj.profilePath)
      ..writeByte(12)
      ..write(obj.popularity)
      ..writeByte(13)
      ..write(obj.voteAverage)
      ..writeByte(14)
      ..write(obj.voteCount)
      ..writeByte(15)
      ..write(obj.knownFor)
      ..writeByte(16)
      ..write(obj.knownForDepartment)
      ..writeByte(17)
      ..write(obj.gender)
      ..writeByte(18)
      ..write(obj.adult)
      ..writeByte(19)
      ..write(obj.originalLanguage)
      ..writeByte(20)
      ..write(obj.genreIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SearchMultiResponseAdapter extends TypeAdapter<SearchMultiResponse> {
  @override
  final typeId = 142;

  @override
  SearchMultiResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchMultiResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<SearchResultItem>(),
      totalResults: (fields[2] as num).toInt(),
      totalPages: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SearchMultiResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.totalResults)
      ..writeByte(3)
      ..write(obj.totalPages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchMultiResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResultItem _$SearchResultItemFromJson(Map<String, dynamic> json) =>
    _SearchResultItem(
      id: (json['id'] as num).toInt(),
      mediaType: json['media_type'] as String,
      title: json['title'] as String?,
      originalTitle: json['original_title'] as String?,
      releaseDate: json['release_date'] as String?,
      name: json['name'] as String?,
      originalName: json['original_name'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      profilePath: json['profile_path'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      knownFor: (json['knownFor'] as List<dynamic>?)
          ?.map((e) => MovieListItemDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      knownForDepartment: json['known_for_department'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      adult: json['adult'] as bool?,
      originalLanguage: json['original_language'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$SearchResultItemToJson(_SearchResultItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_type': instance.mediaType,
      'title': instance.title,
      'original_title': instance.originalTitle,
      'release_date': instance.releaseDate,
      'name': instance.name,
      'original_name': instance.originalName,
      'first_air_date': instance.firstAirDate,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'profile_path': instance.profilePath,
      'popularity': instance.popularity,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'knownFor': instance.knownFor?.map((e) => e.toJson()).toList(),
      'known_for_department': instance.knownForDepartment,
      'gender': instance.gender,
      'adult': instance.adult,
      'original_language': instance.originalLanguage,
      'genre_ids': instance.genreIds,
    };

_SearchMultiResponse _$SearchMultiResponseFromJson(Map<String, dynamic> json) =>
    _SearchMultiResponse(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: (json['total_results'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$SearchMultiResponseToJson(
  _SearchMultiResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results.map((e) => e.toJson()).toList(),
  'total_results': instance.totalResults,
  'total_pages': instance.totalPages,
};
