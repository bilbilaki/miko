// lib/models/tmdb/movies_model.dart  <-- This file name should match this
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'dart:convert'; // For json.decode and json.encode

// IMPORTANT: Adjust this import path. 'oshio' is assumed to be your package name.
import 'tmdb_m.dart'; // <<<--- Ensure tmdb_m.dart exists and this path is correct
part 'movies_model.freezed.dart'; // <--- Corrected
part 'movies_model.g.dart';       // <--- Corrected
// --- TOP-LEVEL CUSTOM JSON CONVERTER FUNCTIONS for Movie Model ---
// These functions are now visible to the generated code.
// They are specific to parsing CSV string fields into Freezed models.

// Converters for List<GenreObject>
List<GenreObject> _movieGenresFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => GenreObject.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing movie genres from CSV: "$jsonString" - $e');
 return [];
 }
}
String? _movieGenresToJson(List<GenreObject> genres) => json.encode(genres.map((e) => e.toJson()).toList());

// Converters for List<KeywordObject>
List<KeywordObject> _movieKeywordsFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => KeywordObject.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing movie keywords from CSV: "$jsonString" - $e');
 return [];
 }
}
String? _movieKeywordsToJson(List<KeywordObject> keywords) => json.encode(keywords.map((e) => e.toJson()).toList());

// Converters for List<ProductionCompany>
List<ProductionCompany> _movieProductionCompaniesFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing movie production companies from CSV: "$jsonString" - $e');
 return [];
 }
}
String? _movieProductionCompaniesToJson(List<ProductionCompany> companies) => json.encode(companies.map((e) => e.toJson()).toList());

// Converters for List<ProductionCountry>
List<ProductionCountry> _movieProductionCountriesFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>)).toList();
 } catch (e) {
 debugPrint('Error parsing movie production countries from CSV: "$jsonString" - $e');
 return [];
 }
}
String? _movieProductionCountriesToJson(List<ProductionCountry> countries) => json.encode(countries.map((e) => e.toJson()).toList());

// Converters for List<SpokenLanguage>
List<SpokenLanguage> _movieSpokenLanguagesFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
   if (jsonString is String) {
     final dynamic parsed = json.decode(jsonString.toString());
     if (parsed is List) {
       return parsed.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>)).toList();
     } else if (parsed is Map) {
       final List<dynamic> jsonList = (parsed['spoken_languages'] as List?) ?? [];
       return jsonList.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>)).toList();
     }
   }
   return [];
 } catch (e) {
   debugPrint('Error parsing movie spoken languages from CSV: "$jsonString" - $e');
   return [];
 }
}
String? _movieSpokenLanguagesToJson(List<SpokenLanguage> languages) => json.encode(languages.map((e) => e.toJson()).toList());

// Converters for List<String> (for download_links)
List<String> _movieStringListFromJson(dynamic jsonString) {
 if (jsonString == null || jsonString == 'null' || jsonString == '') return [];
 try {
 final List<dynamic> jsonList = json.decode(jsonString.toString());
 return jsonList.map((e) => e.toString()).toList();
 } catch (e) {
 debugPrint('Error parsing movie string list from CSV: "$jsonString" - $e');
 return [];
 }
}
String? _movieStringListToJson(List<String> stringList) => json.encode(stringList);

// Converter for boolean fields (adult) which might be "TRUE"/"FALSE" or "1"/"0" in CSV
bool _boolFromJson(dynamic value) {
 if (value == null) return false;
 if (value is bool) return value;
 if (value is int) return value != 0;
 if (value is String) {
 final lowerCaseValue = value.toLowerCase();
 return lowerCaseValue == 'true' || lowerCaseValue == '1';
 }
 return false;
}
dynamic _boolToJson(bool value) => value;

// Corrected `part` directives to match the plural file name `lib/models/tmdb/movies_model.dart`


@freezed
class Movie with _$Movie {
 const factory Movie({
 required int id,
 required String title,
 @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
 @JsonKey(name: 'vote_count') @Default(0) int voteCount,
 @Default('') String status,
 @JsonKey(name: 'release_date') DateTime? releaseDate,
 int? revenue,
 int? runtime,
 @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson) @Default(false) bool adult,
 @JsonKey(name: 'backdrop_path') String? backdropPath,
 int? budget,
 String? homepage,
 @JsonKey(name: 'imdb_id') String? imdbId,
 @JsonKey(name: 'original_language') @Default('') String originalLanguage,
 @JsonKey(name: 'original_title') @Default('') String originalTitle,
 @Default('') String overview,
 @Default(0.0) double popularity,
 @JsonKey(name: 'poster_path') String? posterPath,
 String? tagline,
 @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
 @Default([]) List<GenreObject> genres,
 @JsonKey(name: 'production_companies', fromJson: _movieProductionCompaniesFromJson, toJson: _movieProductionCompaniesToJson)
 @Default([]) List<ProductionCompany> productionCompanies,
 @JsonKey(name: 'production_countries', fromJson: _movieProductionCountriesFromJson, toJson: _movieProductionCountriesToJson)
 @Default([]) List<ProductionCountry> productionCountries,
 @JsonKey(name: 'spoken_languages', fromJson: _movieSpokenLanguagesFromJson, toJson: _movieSpokenLanguagesToJson)
 @Default([]) List<SpokenLanguage> spokenLanguages, // Use SpokenLanguage from tmdb_m.dart
 @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
 @Default([]) List<KeywordObject> keywords,
 String? source,
 @JsonKey(name: 'download_links', fromJson: _movieStringListFromJson, toJson: _movieStringListToJson)
 @Default([]) List<String> downloadLinks,
 }) = _Movie; // This is correct, _Movie is generated

 // This is correct, _$MovieFromJson is generated
 factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}