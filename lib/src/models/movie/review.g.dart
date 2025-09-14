// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieReviewAdapter extends TypeAdapter<MovieReview> {
  @override
  final typeId = 111;

  @override
  MovieReview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieReview(
      id: fields[0] as String,
      author: fields[1] as String,
      authorDetails: (fields[2] as Map).cast<String, Object?>(),
      content: fields[3] as String,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
      url: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieReview obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.authorDetails)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieReviewsResponseAdapter extends TypeAdapter<MovieReviewsResponse> {
  @override
  final typeId = 112;

  @override
  MovieReviewsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieReviewsResponse(
      id: (fields[0] as num).toInt(),
      page: (fields[1] as num).toInt(),
      results: (fields[2] as List).cast<MovieReview>(),
      totalPages: (fields[3] as num).toInt(),
      totalResults: (fields[4] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieReviewsResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.page)
      ..writeByte(2)
      ..write(obj.results)
      ..writeByte(3)
      ..write(obj.totalPages)
      ..writeByte(4)
      ..write(obj.totalResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieReviewsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieReview _$MovieReviewFromJson(Map<String, dynamic> json) => _MovieReview(
  id: json['id'] as String,
  author: json['author'] as String,
  authorDetails: json['author_details'] as Map<String, dynamic>,
  content: json['content'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  url: json['url'] as String?,
);

Map<String, dynamic> _$MovieReviewToJson(_MovieReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'author_details': instance.authorDetails,
      'content': instance.content,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'url': instance.url,
    };

_MovieReviewsResponse _$MovieReviewsResponseFromJson(
  Map<String, dynamic> json,
) => _MovieReviewsResponse(
  id: (json['id'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => MovieReview.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPages: (json['total_pages'] as num).toInt(),
  totalResults: (json['total_results'] as num).toInt(),
);

Map<String, dynamic> _$MovieReviewsResponseToJson(
  _MovieReviewsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'page': instance.page,
  'results': instance.results.map((e) => e.toJson()).toList(),
  'total_pages': instance.totalPages,
  'total_results': instance.totalResults,
};
