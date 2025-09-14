// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieDetail {

@HiveField(0) bool get adult;@HiveField(1)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(2)@JsonKey(name: 'belongs_to_collection') String? get belongsToCollection;@HiveField(3) int get budget;@HiveField(4)@JsonKey(name: 'genres') List<Genre>? get genres;@HiveField(5) String? get homepage;@HiveField(6) int get id;@HiveField(7)@JsonKey(name: 'imdb_id') String? get imdbId;@HiveField(8)@JsonKey(name: 'original_language') String? get originalLanguage;@HiveField(9)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(10) String? get overview;@HiveField(11) double get popularity;@HiveField(12)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(13)@JsonKey(name: 'production_companies') List<ProductionCompany>? get productionCompanies;@HiveField(14)@JsonKey(name: 'production_countries') List<ProductionCountry>? get productionCountries;@HiveField(15)@JsonKey(name: 'release_date') String? get releaseDate;@HiveField(16) int get revenue;@HiveField(17) int get runtime;@HiveField(18)@JsonKey(name: 'spoken_languages') List<SpokenLanguage>? get spokenLanguages;@HiveField(19) String? get status;@HiveField(20) String? get tagline;@HiveField(21) String get title;@HiveField(22) bool get video;@HiveField(23)@JsonKey(name: 'vote_average') double get voteAverage;@HiveField(24)@JsonKey(name: 'vote_count') int get voteCount;
/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailCopyWith<MovieDetail> get copyWith => _$MovieDetailCopyWithImpl<MovieDetail>(this as MovieDetail, _$identity);

  /// Serializes this MovieDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetail&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.belongsToCollection, belongsToCollection) || other.belongsToCollection == belongsToCollection)&&(identical(other.budget, budget) || other.budget == budget)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.id, id) || other.id == id)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&const DeepCollectionEquality().equals(other.productionCompanies, productionCompanies)&&const DeepCollectionEquality().equals(other.productionCountries, productionCountries)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other.spokenLanguages, spokenLanguages)&&(identical(other.status, status) || other.status == status)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.title, title) || other.title == title)&&(identical(other.video, video) || other.video == video)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,adult,backdropPath,belongsToCollection,budget,const DeepCollectionEquality().hash(genres),homepage,id,imdbId,originalLanguage,originalTitle,overview,popularity,posterPath,const DeepCollectionEquality().hash(productionCompanies),const DeepCollectionEquality().hash(productionCountries),releaseDate,revenue,runtime,const DeepCollectionEquality().hash(spokenLanguages),status,tagline,title,video,voteAverage,voteCount]);

@override
String toString() {
  return 'MovieDetail(adult: $adult, backdropPath: $backdropPath, belongsToCollection: $belongsToCollection, budget: $budget, genres: $genres, homepage: $homepage, id: $id, imdbId: $imdbId, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, productionCompanies: $productionCompanies, productionCountries: $productionCountries, releaseDate: $releaseDate, revenue: $revenue, runtime: $runtime, spokenLanguages: $spokenLanguages, status: $status, tagline: $tagline, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class $MovieDetailCopyWith<$Res>  {
  factory $MovieDetailCopyWith(MovieDetail value, $Res Function(MovieDetail) _then) = _$MovieDetailCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(2)@JsonKey(name: 'belongs_to_collection') String? belongsToCollection,@HiveField(3) int budget,@HiveField(4)@JsonKey(name: 'genres') List<Genre>? genres,@HiveField(5) String? homepage,@HiveField(6) int id,@HiveField(7)@JsonKey(name: 'imdb_id') String? imdbId,@HiveField(8)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(9)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(10) String? overview,@HiveField(11) double popularity,@HiveField(12)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(13)@JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,@HiveField(14)@JsonKey(name: 'production_countries') List<ProductionCountry>? productionCountries,@HiveField(15)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(16) int revenue,@HiveField(17) int runtime,@HiveField(18)@JsonKey(name: 'spoken_languages') List<SpokenLanguage>? spokenLanguages,@HiveField(19) String? status,@HiveField(20) String? tagline,@HiveField(21) String title,@HiveField(22) bool video,@HiveField(23)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(24)@JsonKey(name: 'vote_count') int voteCount
});




}
/// @nodoc
class _$MovieDetailCopyWithImpl<$Res>
    implements $MovieDetailCopyWith<$Res> {
  _$MovieDetailCopyWithImpl(this._self, this._then);

  final MovieDetail _self;
  final $Res Function(MovieDetail) _then;

/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adult = null,Object? backdropPath = freezed,Object? belongsToCollection = freezed,Object? budget = null,Object? genres = freezed,Object? homepage = freezed,Object? id = null,Object? imdbId = freezed,Object? originalLanguage = freezed,Object? originalTitle = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? productionCompanies = freezed,Object? productionCountries = freezed,Object? releaseDate = freezed,Object? revenue = null,Object? runtime = null,Object? spokenLanguages = freezed,Object? status = freezed,Object? tagline = freezed,Object? title = null,Object? video = null,Object? voteAverage = null,Object? voteCount = null,}) {
  return _then(_self.copyWith(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,belongsToCollection: freezed == belongsToCollection ? _self.belongsToCollection : belongsToCollection // ignore: cast_nullable_to_non_nullable
as String?,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,productionCompanies: freezed == productionCompanies ? _self.productionCompanies : productionCompanies // ignore: cast_nullable_to_non_nullable
as List<ProductionCompany>?,productionCountries: freezed == productionCountries ? _self.productionCountries : productionCountries // ignore: cast_nullable_to_non_nullable
as List<ProductionCountry>?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,runtime: null == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int,spokenLanguages: freezed == spokenLanguages ? _self.spokenLanguages : spokenLanguages // ignore: cast_nullable_to_non_nullable
as List<SpokenLanguage>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieDetail].
extension MovieDetailPatterns on MovieDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieDetail value)  $default,){
final _that = this;
switch (_that) {
case _MovieDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'belongs_to_collection')  String? belongsToCollection, @HiveField(3)  int budget, @HiveField(4)@JsonKey(name: 'genres')  List<Genre>? genres, @HiveField(5)  String? homepage, @HiveField(6)  int id, @HiveField(7)@JsonKey(name: 'imdb_id')  String? imdbId, @HiveField(8)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(9)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(10)  String? overview, @HiveField(11)  double popularity, @HiveField(12)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(13)@JsonKey(name: 'production_companies')  List<ProductionCompany>? productionCompanies, @HiveField(14)@JsonKey(name: 'production_countries')  List<ProductionCountry>? productionCountries, @HiveField(15)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(16)  int revenue, @HiveField(17)  int runtime, @HiveField(18)@JsonKey(name: 'spoken_languages')  List<SpokenLanguage>? spokenLanguages, @HiveField(19)  String? status, @HiveField(20)  String? tagline, @HiveField(21)  String title, @HiveField(22)  bool video, @HiveField(23)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(24)@JsonKey(name: 'vote_count')  int voteCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
return $default(_that.adult,_that.backdropPath,_that.belongsToCollection,_that.budget,_that.genres,_that.homepage,_that.id,_that.imdbId,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.productionCompanies,_that.productionCountries,_that.releaseDate,_that.revenue,_that.runtime,_that.spokenLanguages,_that.status,_that.tagline,_that.title,_that.video,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'belongs_to_collection')  String? belongsToCollection, @HiveField(3)  int budget, @HiveField(4)@JsonKey(name: 'genres')  List<Genre>? genres, @HiveField(5)  String? homepage, @HiveField(6)  int id, @HiveField(7)@JsonKey(name: 'imdb_id')  String? imdbId, @HiveField(8)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(9)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(10)  String? overview, @HiveField(11)  double popularity, @HiveField(12)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(13)@JsonKey(name: 'production_companies')  List<ProductionCompany>? productionCompanies, @HiveField(14)@JsonKey(name: 'production_countries')  List<ProductionCountry>? productionCountries, @HiveField(15)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(16)  int revenue, @HiveField(17)  int runtime, @HiveField(18)@JsonKey(name: 'spoken_languages')  List<SpokenLanguage>? spokenLanguages, @HiveField(19)  String? status, @HiveField(20)  String? tagline, @HiveField(21)  String title, @HiveField(22)  bool video, @HiveField(23)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(24)@JsonKey(name: 'vote_count')  int voteCount)  $default,) {final _that = this;
switch (_that) {
case _MovieDetail():
return $default(_that.adult,_that.backdropPath,_that.belongsToCollection,_that.budget,_that.genres,_that.homepage,_that.id,_that.imdbId,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.productionCompanies,_that.productionCountries,_that.releaseDate,_that.revenue,_that.runtime,_that.spokenLanguages,_that.status,_that.tagline,_that.title,_that.video,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'belongs_to_collection')  String? belongsToCollection, @HiveField(3)  int budget, @HiveField(4)@JsonKey(name: 'genres')  List<Genre>? genres, @HiveField(5)  String? homepage, @HiveField(6)  int id, @HiveField(7)@JsonKey(name: 'imdb_id')  String? imdbId, @HiveField(8)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(9)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(10)  String? overview, @HiveField(11)  double popularity, @HiveField(12)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(13)@JsonKey(name: 'production_companies')  List<ProductionCompany>? productionCompanies, @HiveField(14)@JsonKey(name: 'production_countries')  List<ProductionCountry>? productionCountries, @HiveField(15)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(16)  int revenue, @HiveField(17)  int runtime, @HiveField(18)@JsonKey(name: 'spoken_languages')  List<SpokenLanguage>? spokenLanguages, @HiveField(19)  String? status, @HiveField(20)  String? tagline, @HiveField(21)  String title, @HiveField(22)  bool video, @HiveField(23)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(24)@JsonKey(name: 'vote_count')  int voteCount)?  $default,) {final _that = this;
switch (_that) {
case _MovieDetail() when $default != null:
return $default(_that.adult,_that.backdropPath,_that.belongsToCollection,_that.budget,_that.genres,_that.homepage,_that.id,_that.imdbId,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.productionCompanies,_that.productionCountries,_that.releaseDate,_that.revenue,_that.runtime,_that.spokenLanguages,_that.status,_that.tagline,_that.title,_that.video,_that.voteAverage,_that.voteCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieDetail implements MovieDetail {
   _MovieDetail({@HiveField(0) this.adult = true, @HiveField(1)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(2)@JsonKey(name: 'belongs_to_collection') this.belongsToCollection, @HiveField(3) this.budget = 0, @HiveField(4)@JsonKey(name: 'genres') final  List<Genre>? genres, @HiveField(5) this.homepage, @HiveField(6) required this.id, @HiveField(7)@JsonKey(name: 'imdb_id') this.imdbId, @HiveField(8)@JsonKey(name: 'original_language') this.originalLanguage, @HiveField(9)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(10) this.overview, @HiveField(11) this.popularity = 0.0, @HiveField(12)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(13)@JsonKey(name: 'production_companies') final  List<ProductionCompany>? productionCompanies, @HiveField(14)@JsonKey(name: 'production_countries') final  List<ProductionCountry>? productionCountries, @HiveField(15)@JsonKey(name: 'release_date') this.releaseDate, @HiveField(16) this.revenue = 0, @HiveField(17) this.runtime = 0, @HiveField(18)@JsonKey(name: 'spoken_languages') final  List<SpokenLanguage>? spokenLanguages, @HiveField(19) this.status, @HiveField(20) this.tagline, @HiveField(21) required this.title, @HiveField(22) this.video = true, @HiveField(23)@JsonKey(name: 'vote_average') this.voteAverage = 0.0, @HiveField(24)@JsonKey(name: 'vote_count') this.voteCount = 0}): _genres = genres,_productionCompanies = productionCompanies,_productionCountries = productionCountries,_spokenLanguages = spokenLanguages;
  factory _MovieDetail.fromJson(Map<String, dynamic> json) => _$MovieDetailFromJson(json);

@override@JsonKey()@HiveField(0) final  bool adult;
@override@HiveField(1)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(2)@JsonKey(name: 'belongs_to_collection') final  String? belongsToCollection;
@override@JsonKey()@HiveField(3) final  int budget;
 final  List<Genre>? _genres;
@override@HiveField(4)@JsonKey(name: 'genres') List<Genre>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(5) final  String? homepage;
@override@HiveField(6) final  int id;
@override@HiveField(7)@JsonKey(name: 'imdb_id') final  String? imdbId;
@override@HiveField(8)@JsonKey(name: 'original_language') final  String? originalLanguage;
@override@HiveField(9)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(10) final  String? overview;
@override@JsonKey()@HiveField(11) final  double popularity;
@override@HiveField(12)@JsonKey(name: 'poster_path') final  String? posterPath;
 final  List<ProductionCompany>? _productionCompanies;
@override@HiveField(13)@JsonKey(name: 'production_companies') List<ProductionCompany>? get productionCompanies {
  final value = _productionCompanies;
  if (value == null) return null;
  if (_productionCompanies is EqualUnmodifiableListView) return _productionCompanies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ProductionCountry>? _productionCountries;
@override@HiveField(14)@JsonKey(name: 'production_countries') List<ProductionCountry>? get productionCountries {
  final value = _productionCountries;
  if (value == null) return null;
  if (_productionCountries is EqualUnmodifiableListView) return _productionCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(15)@JsonKey(name: 'release_date') final  String? releaseDate;
@override@JsonKey()@HiveField(16) final  int revenue;
@override@JsonKey()@HiveField(17) final  int runtime;
 final  List<SpokenLanguage>? _spokenLanguages;
@override@HiveField(18)@JsonKey(name: 'spoken_languages') List<SpokenLanguage>? get spokenLanguages {
  final value = _spokenLanguages;
  if (value == null) return null;
  if (_spokenLanguages is EqualUnmodifiableListView) return _spokenLanguages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(19) final  String? status;
@override@HiveField(20) final  String? tagline;
@override@HiveField(21) final  String title;
@override@JsonKey()@HiveField(22) final  bool video;
@override@HiveField(23)@JsonKey(name: 'vote_average') final  double voteAverage;
@override@HiveField(24)@JsonKey(name: 'vote_count') final  int voteCount;

/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailCopyWith<_MovieDetail> get copyWith => __$MovieDetailCopyWithImpl<_MovieDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetail&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.belongsToCollection, belongsToCollection) || other.belongsToCollection == belongsToCollection)&&(identical(other.budget, budget) || other.budget == budget)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.id, id) || other.id == id)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&const DeepCollectionEquality().equals(other._productionCompanies, _productionCompanies)&&const DeepCollectionEquality().equals(other._productionCountries, _productionCountries)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other._spokenLanguages, _spokenLanguages)&&(identical(other.status, status) || other.status == status)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.title, title) || other.title == title)&&(identical(other.video, video) || other.video == video)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,adult,backdropPath,belongsToCollection,budget,const DeepCollectionEquality().hash(_genres),homepage,id,imdbId,originalLanguage,originalTitle,overview,popularity,posterPath,const DeepCollectionEquality().hash(_productionCompanies),const DeepCollectionEquality().hash(_productionCountries),releaseDate,revenue,runtime,const DeepCollectionEquality().hash(_spokenLanguages),status,tagline,title,video,voteAverage,voteCount]);

@override
String toString() {
  return 'MovieDetail(adult: $adult, backdropPath: $backdropPath, belongsToCollection: $belongsToCollection, budget: $budget, genres: $genres, homepage: $homepage, id: $id, imdbId: $imdbId, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, productionCompanies: $productionCompanies, productionCountries: $productionCountries, releaseDate: $releaseDate, revenue: $revenue, runtime: $runtime, spokenLanguages: $spokenLanguages, status: $status, tagline: $tagline, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailCopyWith<$Res> implements $MovieDetailCopyWith<$Res> {
  factory _$MovieDetailCopyWith(_MovieDetail value, $Res Function(_MovieDetail) _then) = __$MovieDetailCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(2)@JsonKey(name: 'belongs_to_collection') String? belongsToCollection,@HiveField(3) int budget,@HiveField(4)@JsonKey(name: 'genres') List<Genre>? genres,@HiveField(5) String? homepage,@HiveField(6) int id,@HiveField(7)@JsonKey(name: 'imdb_id') String? imdbId,@HiveField(8)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(9)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(10) String? overview,@HiveField(11) double popularity,@HiveField(12)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(13)@JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,@HiveField(14)@JsonKey(name: 'production_countries') List<ProductionCountry>? productionCountries,@HiveField(15)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(16) int revenue,@HiveField(17) int runtime,@HiveField(18)@JsonKey(name: 'spoken_languages') List<SpokenLanguage>? spokenLanguages,@HiveField(19) String? status,@HiveField(20) String? tagline,@HiveField(21) String title,@HiveField(22) bool video,@HiveField(23)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(24)@JsonKey(name: 'vote_count') int voteCount
});




}
/// @nodoc
class __$MovieDetailCopyWithImpl<$Res>
    implements _$MovieDetailCopyWith<$Res> {
  __$MovieDetailCopyWithImpl(this._self, this._then);

  final _MovieDetail _self;
  final $Res Function(_MovieDetail) _then;

/// Create a copy of MovieDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adult = null,Object? backdropPath = freezed,Object? belongsToCollection = freezed,Object? budget = null,Object? genres = freezed,Object? homepage = freezed,Object? id = null,Object? imdbId = freezed,Object? originalLanguage = freezed,Object? originalTitle = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? productionCompanies = freezed,Object? productionCountries = freezed,Object? releaseDate = freezed,Object? revenue = null,Object? runtime = null,Object? spokenLanguages = freezed,Object? status = freezed,Object? tagline = freezed,Object? title = null,Object? video = null,Object? voteAverage = null,Object? voteCount = null,}) {
  return _then(_MovieDetail(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,belongsToCollection: freezed == belongsToCollection ? _self.belongsToCollection : belongsToCollection // ignore: cast_nullable_to_non_nullable
as String?,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,productionCompanies: freezed == productionCompanies ? _self._productionCompanies : productionCompanies // ignore: cast_nullable_to_non_nullable
as List<ProductionCompany>?,productionCountries: freezed == productionCountries ? _self._productionCountries : productionCountries // ignore: cast_nullable_to_non_nullable
as List<ProductionCountry>?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,runtime: null == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int,spokenLanguages: freezed == spokenLanguages ? _self._spokenLanguages : spokenLanguages // ignore: cast_nullable_to_non_nullable
as List<SpokenLanguage>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Genre {

@HiveField(0) int get id;@HiveField(1) String get name;
/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreCopyWith<Genre> get copyWith => _$GenreCopyWithImpl<Genre>(this as Genre, _$identity);

  /// Serializes this Genre to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Genre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Genre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $GenreCopyWith<$Res>  {
  factory $GenreCopyWith(Genre value, $Res Function(Genre) _then) = _$GenreCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class _$GenreCopyWithImpl<$Res>
    implements $GenreCopyWith<$Res> {
  _$GenreCopyWithImpl(this._self, this._then);

  final Genre _self;
  final $Res Function(Genre) _then;

/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Genre].
extension GenrePatterns on Genre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Genre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Genre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Genre value)  $default,){
final _that = this;
switch (_that) {
case _Genre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Genre value)?  $default,){
final _that = this;
switch (_that) {
case _Genre() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Genre() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name)  $default,) {final _that = this;
switch (_that) {
case _Genre():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String name)?  $default,) {final _that = this;
switch (_that) {
case _Genre() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _Genre implements Genre {
   _Genre({@HiveField(0) this.id = 0, @HiveField(1) required this.name});
  factory _Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

@override@JsonKey()@HiveField(0) final  int id;
@override@HiveField(1) final  String name;

/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreCopyWith<_Genre> get copyWith => __$GenreCopyWithImpl<_Genre>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Genre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Genre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$GenreCopyWith<$Res> implements $GenreCopyWith<$Res> {
  factory _$GenreCopyWith(_Genre value, $Res Function(_Genre) _then) = __$GenreCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class __$GenreCopyWithImpl<$Res>
    implements _$GenreCopyWith<$Res> {
  __$GenreCopyWithImpl(this._self, this._then);

  final _Genre _self;
  final $Res Function(_Genre) _then;

/// Create a copy of Genre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_Genre(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SpokenLanguage {

@HiveField(0)@JsonKey(name: 'english_name') String? get englishName;@HiveField(1)@JsonKey(name: 'iso_639_1') String? get iso6391;@HiveField(2) String get name;
/// Create a copy of SpokenLanguage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpokenLanguageCopyWith<SpokenLanguage> get copyWith => _$SpokenLanguageCopyWithImpl<SpokenLanguage>(this as SpokenLanguage, _$identity);

  /// Serializes this SpokenLanguage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpokenLanguage&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,englishName,iso6391,name);

@override
String toString() {
  return 'SpokenLanguage(englishName: $englishName, iso6391: $iso6391, name: $name)';
}


}

/// @nodoc
abstract mixin class $SpokenLanguageCopyWith<$Res>  {
  factory $SpokenLanguageCopyWith(SpokenLanguage value, $Res Function(SpokenLanguage) _then) = _$SpokenLanguageCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'english_name') String? englishName,@HiveField(1)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(2) String name
});




}
/// @nodoc
class _$SpokenLanguageCopyWithImpl<$Res>
    implements $SpokenLanguageCopyWith<$Res> {
  _$SpokenLanguageCopyWithImpl(this._self, this._then);

  final SpokenLanguage _self;
  final $Res Function(SpokenLanguage) _then;

/// Create a copy of SpokenLanguage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? englishName = freezed,Object? iso6391 = freezed,Object? name = null,}) {
  return _then(_self.copyWith(
englishName: freezed == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String?,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpokenLanguage].
extension SpokenLanguagePatterns on SpokenLanguage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpokenLanguage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpokenLanguage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpokenLanguage value)  $default,){
final _that = this;
switch (_that) {
case _SpokenLanguage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpokenLanguage value)?  $default,){
final _that = this;
switch (_that) {
case _SpokenLanguage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'english_name')  String? englishName, @HiveField(1)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(2)  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpokenLanguage() when $default != null:
return $default(_that.englishName,_that.iso6391,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'english_name')  String? englishName, @HiveField(1)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(2)  String name)  $default,) {final _that = this;
switch (_that) {
case _SpokenLanguage():
return $default(_that.englishName,_that.iso6391,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'english_name')  String? englishName, @HiveField(1)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(2)  String name)?  $default,) {final _that = this;
switch (_that) {
case _SpokenLanguage() when $default != null:
return $default(_that.englishName,_that.iso6391,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _SpokenLanguage implements SpokenLanguage {
   _SpokenLanguage({@HiveField(0)@JsonKey(name: 'english_name') this.englishName, @HiveField(1)@JsonKey(name: 'iso_639_1') this.iso6391, @HiveField(2) required this.name});
  factory _SpokenLanguage.fromJson(Map<String, dynamic> json) => _$SpokenLanguageFromJson(json);

@override@HiveField(0)@JsonKey(name: 'english_name') final  String? englishName;
@override@HiveField(1)@JsonKey(name: 'iso_639_1') final  String? iso6391;
@override@HiveField(2) final  String name;

/// Create a copy of SpokenLanguage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpokenLanguageCopyWith<_SpokenLanguage> get copyWith => __$SpokenLanguageCopyWithImpl<_SpokenLanguage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpokenLanguageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpokenLanguage&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,englishName,iso6391,name);

@override
String toString() {
  return 'SpokenLanguage(englishName: $englishName, iso6391: $iso6391, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SpokenLanguageCopyWith<$Res> implements $SpokenLanguageCopyWith<$Res> {
  factory _$SpokenLanguageCopyWith(_SpokenLanguage value, $Res Function(_SpokenLanguage) _then) = __$SpokenLanguageCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'english_name') String? englishName,@HiveField(1)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(2) String name
});




}
/// @nodoc
class __$SpokenLanguageCopyWithImpl<$Res>
    implements _$SpokenLanguageCopyWith<$Res> {
  __$SpokenLanguageCopyWithImpl(this._self, this._then);

  final _SpokenLanguage _self;
  final $Res Function(_SpokenLanguage) _then;

/// Create a copy of SpokenLanguage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? englishName = freezed,Object? iso6391 = freezed,Object? name = null,}) {
  return _then(_SpokenLanguage(
englishName: freezed == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String?,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
