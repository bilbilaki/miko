// lib/models/tmdb/series_model.dart (Adjust path if different)
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'dart:convert'; // For json.decode and json.encode

// IMPORTANT: Adjust this import path if your tmdb_models.dart is in a different location.
// Assuming your tmdb_m.dart is at lib/models/tmdb_m.dart or similar
import 'tmdb_m.dart'; // <<<--- Replace 'your_app_name' with your actual package name

part 'series_model.freezed.dart';
part 'series_model.g.dart';

// --- TOP-LEVEL CUSTOM JSON CONVERTER FUNCTIONS ---
// These functions are now visible to the generated code.

List<GenreObject> genresFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => GenreObject.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing genres from CSV: "$jsonString" - $e');
 return [];
 }
}

String? genresToJson(List<GenreObject> genres) => json.encode(genres.map((e) => e.toJson()).toList());

List<KeywordObject> keywordsFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => KeywordObject.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing keywords from CSV: "$jsonString" - $e');
 return [];
 }
}

String? keywordsToJson(List<KeywordObject> keywords) => json.encode(keywords.map((e) => e.toJson()).toList());

List<CastMember> castFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => CastMember.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing cast from CSV: "$jsonString" - $e');
 return [];
 }
}

String? castToJson(List<CastMember> cast) => json.encode(cast.map((e) => e.toJson()).toList());

List<EpisodeCrew> crewFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => EpisodeCrew.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing crew from CSV: "$jsonString" - $e');
 return [];
 }
}

String? crewToJson(List<EpisodeCrew> crew) => json.encode(crew.map((e) => e.toJson()).toList());

List<VideoObject> videosFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => VideoObject.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing videos from CSV: "$jsonString" - $e');
 return [];
 }
}

String? videosToJson(List<VideoObject> videos) => json.encode(videos.map((e) => e.toJson()).toList());


@freezed
class Series with _$Series {
 const factory Series({
 required int id,
 required String title,
 @Default('') String status,
 @JsonKey(name: 'release_date') DateTime? releaseDate,
 int? runtime,
 @Default('') String overview,
 @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
 @JsonKey(name: 'vote_count') @Default(0) int voteCount,
 // Now referencing the top-level functions
 @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
 @Default([]) List<GenreObject> genres,
 @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
 @Default([]) List<KeywordObject> keywords,
 @JsonKey(name: 'original_name') @Default('') String originalName,
 @JsonKey(name: 'poster_path') String? posterPath,
 @JsonKey(name: 'backdrop_path') String? backdropPath,
 @Default(0.0) double popularity,
 @JsonKey(name: 'original_language') @Default('') String originalLanguage,
 @Default('') String type, // e.g., "TV Series", "Movie"
 @JsonKey(name: 'episodes_number') int? episodesNumber,
 @JsonKey(name: 'seasons_number') int? seasonsNumber,
 String? homepage,
 @JsonKey(fromJson: castFromJson, toJson: castToJson)
 @Default([]) List<CastMember> cast,
 @JsonKey(fromJson: crewFromJson, toJson: crewToJson)
 @Default([]) List<EpisodeCrew> crew,
 @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
 @Default([]) List<VideoObject> videos,
 }) = _Series;

 factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);
}