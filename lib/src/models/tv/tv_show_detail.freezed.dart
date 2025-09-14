// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_show_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvShowDetail {

@HiveField(0) int get id;@HiveField(1) String get name;@HiveField(2)@JsonKey(name: 'original_name') String? get originalName;@HiveField(3)@JsonKey(name: 'overview') String? get overview;@HiveField(4)@JsonKey(name: 'first_air_date') String? get firstAirDate;@HiveField(5)@JsonKey(name: 'last_air_date') String? get lastAirDate;@HiveField(6)@JsonKey(name: 'number_of_seasons') int? get numberOfSeasons;@HiveField(7)@JsonKey(name: 'number_of_episodes') int? get numberOfEpisodes;@HiveField(8) String? get status;@HiveField(9) String? get type;@HiveField(10) String? get homepage;@HiveField(11)@JsonKey(name: 'in_production') bool? get inProduction;@HiveField(12)@JsonKey(name: 'languages') List<String>? get languages;@HiveField(13)@JsonKey(name: 'origin_country') List<String>? get originCountry;@HiveField(14)@JsonKey(name: 'original_language') String? get originalLanguage;@HiveField(15)@JsonKey(name: 'episode_run_time') List<int>? get episodeRunTime;@HiveField(16)@JsonKey(name: 'genres') List<TvGenre>? get genres;@HiveField(17)@JsonKey(name: 'networks') List<Network>? get networks;@HiveField(18)@JsonKey(name: 'created_by') List<Creator>? get createdBy;@HiveField(19)@JsonKey(name: 'seasons') List<SeasonSummary>? get seasons;@HiveField(20)@JsonKey(name: 'production_companies') List<ProductionCompany>? get productionCompanies;@HiveField(21)@JsonKey(name: 'production_countries') List<ProductionCountry>? get productionCountries;@HiveField(22)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(23)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(24)@JsonKey(name: 'vote_average') double? get voteAverage;@HiveField(25)@JsonKey(name: 'vote_count') int? get voteCount;@HiveField(26) double? get popularity;@HiveField(27)@JsonKey(name: 'tagline') String? get tagline;@HiveField(28)@JsonKey(name: 'created_by_ids') List<int>? get createdByIds;
/// Create a copy of TvShowDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvShowDetailCopyWith<TvShowDetail> get copyWith => _$TvShowDetailCopyWithImpl<TvShowDetail>(this as TvShowDetail, _$identity);

  /// Serializes this TvShowDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvShowDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.lastAirDate, lastAirDate) || other.lastAirDate == lastAirDate)&&(identical(other.numberOfSeasons, numberOfSeasons) || other.numberOfSeasons == numberOfSeasons)&&(identical(other.numberOfEpisodes, numberOfEpisodes) || other.numberOfEpisodes == numberOfEpisodes)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.inProduction, inProduction) || other.inProduction == inProduction)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.originCountry, originCountry)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&const DeepCollectionEquality().equals(other.episodeRunTime, episodeRunTime)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.networks, networks)&&const DeepCollectionEquality().equals(other.createdBy, createdBy)&&const DeepCollectionEquality().equals(other.seasons, seasons)&&const DeepCollectionEquality().equals(other.productionCompanies, productionCompanies)&&const DeepCollectionEquality().equals(other.productionCountries, productionCountries)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&const DeepCollectionEquality().equals(other.createdByIds, createdByIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,originalName,overview,firstAirDate,lastAirDate,numberOfSeasons,numberOfEpisodes,status,type,homepage,inProduction,const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(originCountry),originalLanguage,const DeepCollectionEquality().hash(episodeRunTime),const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(networks),const DeepCollectionEquality().hash(createdBy),const DeepCollectionEquality().hash(seasons),const DeepCollectionEquality().hash(productionCompanies),const DeepCollectionEquality().hash(productionCountries),posterPath,backdropPath,voteAverage,voteCount,popularity,tagline,const DeepCollectionEquality().hash(createdByIds)]);

@override
String toString() {
  return 'TvShowDetail(id: $id, name: $name, originalName: $originalName, overview: $overview, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, status: $status, type: $type, homepage: $homepage, inProduction: $inProduction, languages: $languages, originCountry: $originCountry, originalLanguage: $originalLanguage, episodeRunTime: $episodeRunTime, genres: $genres, networks: $networks, createdBy: $createdBy, seasons: $seasons, productionCompanies: $productionCompanies, productionCountries: $productionCountries, posterPath: $posterPath, backdropPath: $backdropPath, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, tagline: $tagline, createdByIds: $createdByIds)';
}


}

/// @nodoc
abstract mixin class $TvShowDetailCopyWith<$Res>  {
  factory $TvShowDetailCopyWith(TvShowDetail value, $Res Function(TvShowDetail) _then) = _$TvShowDetailCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name,@HiveField(2)@JsonKey(name: 'original_name') String? originalName,@HiveField(3)@JsonKey(name: 'overview') String? overview,@HiveField(4)@JsonKey(name: 'first_air_date') String? firstAirDate,@HiveField(5)@JsonKey(name: 'last_air_date') String? lastAirDate,@HiveField(6)@JsonKey(name: 'number_of_seasons') int? numberOfSeasons,@HiveField(7)@JsonKey(name: 'number_of_episodes') int? numberOfEpisodes,@HiveField(8) String? status,@HiveField(9) String? type,@HiveField(10) String? homepage,@HiveField(11)@JsonKey(name: 'in_production') bool? inProduction,@HiveField(12)@JsonKey(name: 'languages') List<String>? languages,@HiveField(13)@JsonKey(name: 'origin_country') List<String>? originCountry,@HiveField(14)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(15)@JsonKey(name: 'episode_run_time') List<int>? episodeRunTime,@HiveField(16)@JsonKey(name: 'genres') List<TvGenre>? genres,@HiveField(17)@JsonKey(name: 'networks') List<Network>? networks,@HiveField(18)@JsonKey(name: 'created_by') List<Creator>? createdBy,@HiveField(19)@JsonKey(name: 'seasons') List<SeasonSummary>? seasons,@HiveField(20)@JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,@HiveField(21)@JsonKey(name: 'production_countries') List<ProductionCountry>? productionCountries,@HiveField(22)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(23)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(24)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(25)@JsonKey(name: 'vote_count') int? voteCount,@HiveField(26) double? popularity,@HiveField(27)@JsonKey(name: 'tagline') String? tagline,@HiveField(28)@JsonKey(name: 'created_by_ids') List<int>? createdByIds
});




}
/// @nodoc
class _$TvShowDetailCopyWithImpl<$Res>
    implements $TvShowDetailCopyWith<$Res> {
  _$TvShowDetailCopyWithImpl(this._self, this._then);

  final TvShowDetail _self;
  final $Res Function(TvShowDetail) _then;

/// Create a copy of TvShowDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? originalName = freezed,Object? overview = freezed,Object? firstAirDate = freezed,Object? lastAirDate = freezed,Object? numberOfSeasons = freezed,Object? numberOfEpisodes = freezed,Object? status = freezed,Object? type = freezed,Object? homepage = freezed,Object? inProduction = freezed,Object? languages = freezed,Object? originCountry = freezed,Object? originalLanguage = freezed,Object? episodeRunTime = freezed,Object? genres = freezed,Object? networks = freezed,Object? createdBy = freezed,Object? seasons = freezed,Object? productionCompanies = freezed,Object? productionCountries = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? popularity = freezed,Object? tagline = freezed,Object? createdByIds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,lastAirDate: freezed == lastAirDate ? _self.lastAirDate : lastAirDate // ignore: cast_nullable_to_non_nullable
as String?,numberOfSeasons: freezed == numberOfSeasons ? _self.numberOfSeasons : numberOfSeasons // ignore: cast_nullable_to_non_nullable
as int?,numberOfEpisodes: freezed == numberOfEpisodes ? _self.numberOfEpisodes : numberOfEpisodes // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,inProduction: freezed == inProduction ? _self.inProduction : inProduction // ignore: cast_nullable_to_non_nullable
as bool?,languages: freezed == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>?,originCountry: freezed == originCountry ? _self.originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as List<String>?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,episodeRunTime: freezed == episodeRunTime ? _self.episodeRunTime : episodeRunTime // ignore: cast_nullable_to_non_nullable
as List<int>?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<TvGenre>?,networks: freezed == networks ? _self.networks : networks // ignore: cast_nullable_to_non_nullable
as List<Network>?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as List<Creator>?,seasons: freezed == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SeasonSummary>?,productionCompanies: freezed == productionCompanies ? _self.productionCompanies : productionCompanies // ignore: cast_nullable_to_non_nullable
as List<ProductionCompany>?,productionCountries: freezed == productionCountries ? _self.productionCountries : productionCountries // ignore: cast_nullable_to_non_nullable
as List<ProductionCountry>?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,createdByIds: freezed == createdByIds ? _self.createdByIds : createdByIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvShowDetail].
extension TvShowDetailPatterns on TvShowDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvShowDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvShowDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvShowDetail value)  $default,){
final _that = this;
switch (_that) {
case _TvShowDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvShowDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TvShowDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'original_name')  String? originalName, @HiveField(3)@JsonKey(name: 'overview')  String? overview, @HiveField(4)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(5)@JsonKey(name: 'last_air_date')  String? lastAirDate, @HiveField(6)@JsonKey(name: 'number_of_seasons')  int? numberOfSeasons, @HiveField(7)@JsonKey(name: 'number_of_episodes')  int? numberOfEpisodes, @HiveField(8)  String? status, @HiveField(9)  String? type, @HiveField(10)  String? homepage, @HiveField(11)@JsonKey(name: 'in_production')  bool? inProduction, @HiveField(12)@JsonKey(name: 'languages')  List<String>? languages, @HiveField(13)@JsonKey(name: 'origin_country')  List<String>? originCountry, @HiveField(14)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(15)@JsonKey(name: 'episode_run_time')  List<int>? episodeRunTime, @HiveField(16)@JsonKey(name: 'genres')  List<TvGenre>? genres, @HiveField(17)@JsonKey(name: 'networks')  List<Network>? networks, @HiveField(18)@JsonKey(name: 'created_by')  List<Creator>? createdBy, @HiveField(19)@JsonKey(name: 'seasons')  List<SeasonSummary>? seasons, @HiveField(20)@JsonKey(name: 'production_companies')  List<ProductionCompany>? productionCompanies, @HiveField(21)@JsonKey(name: 'production_countries')  List<ProductionCountry>? productionCountries, @HiveField(22)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(23)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(24)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(25)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(26)  double? popularity, @HiveField(27)@JsonKey(name: 'tagline')  String? tagline, @HiveField(28)@JsonKey(name: 'created_by_ids')  List<int>? createdByIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvShowDetail() when $default != null:
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.numberOfEpisodes,_that.status,_that.type,_that.homepage,_that.inProduction,_that.languages,_that.originCountry,_that.originalLanguage,_that.episodeRunTime,_that.genres,_that.networks,_that.createdBy,_that.seasons,_that.productionCompanies,_that.productionCountries,_that.posterPath,_that.backdropPath,_that.voteAverage,_that.voteCount,_that.popularity,_that.tagline,_that.createdByIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'original_name')  String? originalName, @HiveField(3)@JsonKey(name: 'overview')  String? overview, @HiveField(4)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(5)@JsonKey(name: 'last_air_date')  String? lastAirDate, @HiveField(6)@JsonKey(name: 'number_of_seasons')  int? numberOfSeasons, @HiveField(7)@JsonKey(name: 'number_of_episodes')  int? numberOfEpisodes, @HiveField(8)  String? status, @HiveField(9)  String? type, @HiveField(10)  String? homepage, @HiveField(11)@JsonKey(name: 'in_production')  bool? inProduction, @HiveField(12)@JsonKey(name: 'languages')  List<String>? languages, @HiveField(13)@JsonKey(name: 'origin_country')  List<String>? originCountry, @HiveField(14)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(15)@JsonKey(name: 'episode_run_time')  List<int>? episodeRunTime, @HiveField(16)@JsonKey(name: 'genres')  List<TvGenre>? genres, @HiveField(17)@JsonKey(name: 'networks')  List<Network>? networks, @HiveField(18)@JsonKey(name: 'created_by')  List<Creator>? createdBy, @HiveField(19)@JsonKey(name: 'seasons')  List<SeasonSummary>? seasons, @HiveField(20)@JsonKey(name: 'production_companies')  List<ProductionCompany>? productionCompanies, @HiveField(21)@JsonKey(name: 'production_countries')  List<ProductionCountry>? productionCountries, @HiveField(22)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(23)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(24)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(25)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(26)  double? popularity, @HiveField(27)@JsonKey(name: 'tagline')  String? tagline, @HiveField(28)@JsonKey(name: 'created_by_ids')  List<int>? createdByIds)  $default,) {final _that = this;
switch (_that) {
case _TvShowDetail():
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.numberOfEpisodes,_that.status,_that.type,_that.homepage,_that.inProduction,_that.languages,_that.originCountry,_that.originalLanguage,_that.episodeRunTime,_that.genres,_that.networks,_that.createdBy,_that.seasons,_that.productionCompanies,_that.productionCountries,_that.posterPath,_that.backdropPath,_that.voteAverage,_that.voteCount,_that.popularity,_that.tagline,_that.createdByIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'original_name')  String? originalName, @HiveField(3)@JsonKey(name: 'overview')  String? overview, @HiveField(4)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(5)@JsonKey(name: 'last_air_date')  String? lastAirDate, @HiveField(6)@JsonKey(name: 'number_of_seasons')  int? numberOfSeasons, @HiveField(7)@JsonKey(name: 'number_of_episodes')  int? numberOfEpisodes, @HiveField(8)  String? status, @HiveField(9)  String? type, @HiveField(10)  String? homepage, @HiveField(11)@JsonKey(name: 'in_production')  bool? inProduction, @HiveField(12)@JsonKey(name: 'languages')  List<String>? languages, @HiveField(13)@JsonKey(name: 'origin_country')  List<String>? originCountry, @HiveField(14)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(15)@JsonKey(name: 'episode_run_time')  List<int>? episodeRunTime, @HiveField(16)@JsonKey(name: 'genres')  List<TvGenre>? genres, @HiveField(17)@JsonKey(name: 'networks')  List<Network>? networks, @HiveField(18)@JsonKey(name: 'created_by')  List<Creator>? createdBy, @HiveField(19)@JsonKey(name: 'seasons')  List<SeasonSummary>? seasons, @HiveField(20)@JsonKey(name: 'production_companies')  List<ProductionCompany>? productionCompanies, @HiveField(21)@JsonKey(name: 'production_countries')  List<ProductionCountry>? productionCountries, @HiveField(22)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(23)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(24)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(25)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(26)  double? popularity, @HiveField(27)@JsonKey(name: 'tagline')  String? tagline, @HiveField(28)@JsonKey(name: 'created_by_ids')  List<int>? createdByIds)?  $default,) {final _that = this;
switch (_that) {
case _TvShowDetail() when $default != null:
return $default(_that.id,_that.name,_that.originalName,_that.overview,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.numberOfEpisodes,_that.status,_that.type,_that.homepage,_that.inProduction,_that.languages,_that.originCountry,_that.originalLanguage,_that.episodeRunTime,_that.genres,_that.networks,_that.createdBy,_that.seasons,_that.productionCompanies,_that.productionCountries,_that.posterPath,_that.backdropPath,_that.voteAverage,_that.voteCount,_that.popularity,_that.tagline,_that.createdByIds);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TvShowDetail implements TvShowDetail {
  const _TvShowDetail({@HiveField(0) required this.id, @HiveField(1) required this.name, @HiveField(2)@JsonKey(name: 'original_name') this.originalName, @HiveField(3)@JsonKey(name: 'overview') this.overview, @HiveField(4)@JsonKey(name: 'first_air_date') this.firstAirDate, @HiveField(5)@JsonKey(name: 'last_air_date') this.lastAirDate, @HiveField(6)@JsonKey(name: 'number_of_seasons') this.numberOfSeasons, @HiveField(7)@JsonKey(name: 'number_of_episodes') this.numberOfEpisodes, @HiveField(8) this.status, @HiveField(9) this.type, @HiveField(10) this.homepage, @HiveField(11)@JsonKey(name: 'in_production') this.inProduction, @HiveField(12)@JsonKey(name: 'languages') final  List<String>? languages, @HiveField(13)@JsonKey(name: 'origin_country') final  List<String>? originCountry, @HiveField(14)@JsonKey(name: 'original_language') this.originalLanguage, @HiveField(15)@JsonKey(name: 'episode_run_time') final  List<int>? episodeRunTime, @HiveField(16)@JsonKey(name: 'genres') final  List<TvGenre>? genres, @HiveField(17)@JsonKey(name: 'networks') final  List<Network>? networks, @HiveField(18)@JsonKey(name: 'created_by') final  List<Creator>? createdBy, @HiveField(19)@JsonKey(name: 'seasons') final  List<SeasonSummary>? seasons, @HiveField(20)@JsonKey(name: 'production_companies') final  List<ProductionCompany>? productionCompanies, @HiveField(21)@JsonKey(name: 'production_countries') final  List<ProductionCountry>? productionCountries, @HiveField(22)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(23)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(24)@JsonKey(name: 'vote_average') this.voteAverage, @HiveField(25)@JsonKey(name: 'vote_count') this.voteCount, @HiveField(26) this.popularity, @HiveField(27)@JsonKey(name: 'tagline') this.tagline, @HiveField(28)@JsonKey(name: 'created_by_ids') final  List<int>? createdByIds}): _languages = languages,_originCountry = originCountry,_episodeRunTime = episodeRunTime,_genres = genres,_networks = networks,_createdBy = createdBy,_seasons = seasons,_productionCompanies = productionCompanies,_productionCountries = productionCountries,_createdByIds = createdByIds;
  factory _TvShowDetail.fromJson(Map<String, dynamic> json) => _$TvShowDetailFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String name;
@override@HiveField(2)@JsonKey(name: 'original_name') final  String? originalName;
@override@HiveField(3)@JsonKey(name: 'overview') final  String? overview;
@override@HiveField(4)@JsonKey(name: 'first_air_date') final  String? firstAirDate;
@override@HiveField(5)@JsonKey(name: 'last_air_date') final  String? lastAirDate;
@override@HiveField(6)@JsonKey(name: 'number_of_seasons') final  int? numberOfSeasons;
@override@HiveField(7)@JsonKey(name: 'number_of_episodes') final  int? numberOfEpisodes;
@override@HiveField(8) final  String? status;
@override@HiveField(9) final  String? type;
@override@HiveField(10) final  String? homepage;
@override@HiveField(11)@JsonKey(name: 'in_production') final  bool? inProduction;
 final  List<String>? _languages;
@override@HiveField(12)@JsonKey(name: 'languages') List<String>? get languages {
  final value = _languages;
  if (value == null) return null;
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _originCountry;
@override@HiveField(13)@JsonKey(name: 'origin_country') List<String>? get originCountry {
  final value = _originCountry;
  if (value == null) return null;
  if (_originCountry is EqualUnmodifiableListView) return _originCountry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(14)@JsonKey(name: 'original_language') final  String? originalLanguage;
 final  List<int>? _episodeRunTime;
@override@HiveField(15)@JsonKey(name: 'episode_run_time') List<int>? get episodeRunTime {
  final value = _episodeRunTime;
  if (value == null) return null;
  if (_episodeRunTime is EqualUnmodifiableListView) return _episodeRunTime;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<TvGenre>? _genres;
@override@HiveField(16)@JsonKey(name: 'genres') List<TvGenre>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Network>? _networks;
@override@HiveField(17)@JsonKey(name: 'networks') List<Network>? get networks {
  final value = _networks;
  if (value == null) return null;
  if (_networks is EqualUnmodifiableListView) return _networks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Creator>? _createdBy;
@override@HiveField(18)@JsonKey(name: 'created_by') List<Creator>? get createdBy {
  final value = _createdBy;
  if (value == null) return null;
  if (_createdBy is EqualUnmodifiableListView) return _createdBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SeasonSummary>? _seasons;
@override@HiveField(19)@JsonKey(name: 'seasons') List<SeasonSummary>? get seasons {
  final value = _seasons;
  if (value == null) return null;
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ProductionCompany>? _productionCompanies;
@override@HiveField(20)@JsonKey(name: 'production_companies') List<ProductionCompany>? get productionCompanies {
  final value = _productionCompanies;
  if (value == null) return null;
  if (_productionCompanies is EqualUnmodifiableListView) return _productionCompanies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ProductionCountry>? _productionCountries;
@override@HiveField(21)@JsonKey(name: 'production_countries') List<ProductionCountry>? get productionCountries {
  final value = _productionCountries;
  if (value == null) return null;
  if (_productionCountries is EqualUnmodifiableListView) return _productionCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(22)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(23)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(24)@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@HiveField(25)@JsonKey(name: 'vote_count') final  int? voteCount;
@override@HiveField(26) final  double? popularity;
@override@HiveField(27)@JsonKey(name: 'tagline') final  String? tagline;
 final  List<int>? _createdByIds;
@override@HiveField(28)@JsonKey(name: 'created_by_ids') List<int>? get createdByIds {
  final value = _createdByIds;
  if (value == null) return null;
  if (_createdByIds is EqualUnmodifiableListView) return _createdByIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TvShowDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvShowDetailCopyWith<_TvShowDetail> get copyWith => __$TvShowDetailCopyWithImpl<_TvShowDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvShowDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvShowDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.lastAirDate, lastAirDate) || other.lastAirDate == lastAirDate)&&(identical(other.numberOfSeasons, numberOfSeasons) || other.numberOfSeasons == numberOfSeasons)&&(identical(other.numberOfEpisodes, numberOfEpisodes) || other.numberOfEpisodes == numberOfEpisodes)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.inProduction, inProduction) || other.inProduction == inProduction)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._originCountry, _originCountry)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&const DeepCollectionEquality().equals(other._episodeRunTime, _episodeRunTime)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._networks, _networks)&&const DeepCollectionEquality().equals(other._createdBy, _createdBy)&&const DeepCollectionEquality().equals(other._seasons, _seasons)&&const DeepCollectionEquality().equals(other._productionCompanies, _productionCompanies)&&const DeepCollectionEquality().equals(other._productionCountries, _productionCountries)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&const DeepCollectionEquality().equals(other._createdByIds, _createdByIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,originalName,overview,firstAirDate,lastAirDate,numberOfSeasons,numberOfEpisodes,status,type,homepage,inProduction,const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_originCountry),originalLanguage,const DeepCollectionEquality().hash(_episodeRunTime),const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_networks),const DeepCollectionEquality().hash(_createdBy),const DeepCollectionEquality().hash(_seasons),const DeepCollectionEquality().hash(_productionCompanies),const DeepCollectionEquality().hash(_productionCountries),posterPath,backdropPath,voteAverage,voteCount,popularity,tagline,const DeepCollectionEquality().hash(_createdByIds)]);

@override
String toString() {
  return 'TvShowDetail(id: $id, name: $name, originalName: $originalName, overview: $overview, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, status: $status, type: $type, homepage: $homepage, inProduction: $inProduction, languages: $languages, originCountry: $originCountry, originalLanguage: $originalLanguage, episodeRunTime: $episodeRunTime, genres: $genres, networks: $networks, createdBy: $createdBy, seasons: $seasons, productionCompanies: $productionCompanies, productionCountries: $productionCountries, posterPath: $posterPath, backdropPath: $backdropPath, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, tagline: $tagline, createdByIds: $createdByIds)';
}


}

/// @nodoc
abstract mixin class _$TvShowDetailCopyWith<$Res> implements $TvShowDetailCopyWith<$Res> {
  factory _$TvShowDetailCopyWith(_TvShowDetail value, $Res Function(_TvShowDetail) _then) = __$TvShowDetailCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name,@HiveField(2)@JsonKey(name: 'original_name') String? originalName,@HiveField(3)@JsonKey(name: 'overview') String? overview,@HiveField(4)@JsonKey(name: 'first_air_date') String? firstAirDate,@HiveField(5)@JsonKey(name: 'last_air_date') String? lastAirDate,@HiveField(6)@JsonKey(name: 'number_of_seasons') int? numberOfSeasons,@HiveField(7)@JsonKey(name: 'number_of_episodes') int? numberOfEpisodes,@HiveField(8) String? status,@HiveField(9) String? type,@HiveField(10) String? homepage,@HiveField(11)@JsonKey(name: 'in_production') bool? inProduction,@HiveField(12)@JsonKey(name: 'languages') List<String>? languages,@HiveField(13)@JsonKey(name: 'origin_country') List<String>? originCountry,@HiveField(14)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(15)@JsonKey(name: 'episode_run_time') List<int>? episodeRunTime,@HiveField(16)@JsonKey(name: 'genres') List<TvGenre>? genres,@HiveField(17)@JsonKey(name: 'networks') List<Network>? networks,@HiveField(18)@JsonKey(name: 'created_by') List<Creator>? createdBy,@HiveField(19)@JsonKey(name: 'seasons') List<SeasonSummary>? seasons,@HiveField(20)@JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,@HiveField(21)@JsonKey(name: 'production_countries') List<ProductionCountry>? productionCountries,@HiveField(22)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(23)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(24)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(25)@JsonKey(name: 'vote_count') int? voteCount,@HiveField(26) double? popularity,@HiveField(27)@JsonKey(name: 'tagline') String? tagline,@HiveField(28)@JsonKey(name: 'created_by_ids') List<int>? createdByIds
});




}
/// @nodoc
class __$TvShowDetailCopyWithImpl<$Res>
    implements _$TvShowDetailCopyWith<$Res> {
  __$TvShowDetailCopyWithImpl(this._self, this._then);

  final _TvShowDetail _self;
  final $Res Function(_TvShowDetail) _then;

/// Create a copy of TvShowDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? originalName = freezed,Object? overview = freezed,Object? firstAirDate = freezed,Object? lastAirDate = freezed,Object? numberOfSeasons = freezed,Object? numberOfEpisodes = freezed,Object? status = freezed,Object? type = freezed,Object? homepage = freezed,Object? inProduction = freezed,Object? languages = freezed,Object? originCountry = freezed,Object? originalLanguage = freezed,Object? episodeRunTime = freezed,Object? genres = freezed,Object? networks = freezed,Object? createdBy = freezed,Object? seasons = freezed,Object? productionCompanies = freezed,Object? productionCountries = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? popularity = freezed,Object? tagline = freezed,Object? createdByIds = freezed,}) {
  return _then(_TvShowDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,lastAirDate: freezed == lastAirDate ? _self.lastAirDate : lastAirDate // ignore: cast_nullable_to_non_nullable
as String?,numberOfSeasons: freezed == numberOfSeasons ? _self.numberOfSeasons : numberOfSeasons // ignore: cast_nullable_to_non_nullable
as int?,numberOfEpisodes: freezed == numberOfEpisodes ? _self.numberOfEpisodes : numberOfEpisodes // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,inProduction: freezed == inProduction ? _self.inProduction : inProduction // ignore: cast_nullable_to_non_nullable
as bool?,languages: freezed == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>?,originCountry: freezed == originCountry ? _self._originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as List<String>?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,episodeRunTime: freezed == episodeRunTime ? _self._episodeRunTime : episodeRunTime // ignore: cast_nullable_to_non_nullable
as List<int>?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<TvGenre>?,networks: freezed == networks ? _self._networks : networks // ignore: cast_nullable_to_non_nullable
as List<Network>?,createdBy: freezed == createdBy ? _self._createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as List<Creator>?,seasons: freezed == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<SeasonSummary>?,productionCompanies: freezed == productionCompanies ? _self._productionCompanies : productionCompanies // ignore: cast_nullable_to_non_nullable
as List<ProductionCompany>?,productionCountries: freezed == productionCountries ? _self._productionCountries : productionCountries // ignore: cast_nullable_to_non_nullable
as List<ProductionCountry>?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,createdByIds: freezed == createdByIds ? _self._createdByIds : createdByIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

// dart format on
