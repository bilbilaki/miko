// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_lists.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvListResponse {

@HiveField(0) int get page;@HiveField(1)@JsonKey(name: 'results') List<TvSummary> get results;@HiveField(2)@JsonKey(name: 'total_pages') int get totalPages;@HiveField(3)@JsonKey(name: 'total_results') int get totalResults;
/// Create a copy of TvListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvListResponseCopyWith<TvListResponse> get copyWith => _$TvListResponseCopyWithImpl<TvListResponse>(this as TvListResponse, _$identity);

  /// Serializes this TvListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvListResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalPages,totalResults);

@override
String toString() {
  return 'TvListResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $TvListResponseCopyWith<$Res>  {
  factory $TvListResponseCopyWith(TvListResponse value, $Res Function(TvListResponse) _then) = _$TvListResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<TvSummary> results,@HiveField(2)@JsonKey(name: 'total_pages') int totalPages,@HiveField(3)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class _$TvListResponseCopyWithImpl<$Res>
    implements $TvListResponseCopyWith<$Res> {
  _$TvListResponseCopyWithImpl(this._self, this._then);

  final TvListResponse _self;
  final $Res Function(TvListResponse) _then;

/// Create a copy of TvListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<TvSummary>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TvListResponse].
extension TvListResponsePatterns on TvListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvListResponse value)  $default,){
final _that = this;
switch (_that) {
case _TvListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TvListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<TvSummary> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvListResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<TvSummary> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _TvListResponse():
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<TvSummary> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _TvListResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TvListResponse implements TvListResponse {
   _TvListResponse({@HiveField(0) required this.page, @HiveField(1)@JsonKey(name: 'results') required final  List<TvSummary> results, @HiveField(2)@JsonKey(name: 'total_pages') this.totalPages = 0, @HiveField(3)@JsonKey(name: 'total_results') this.totalResults = 0}): _results = results;
  factory _TvListResponse.fromJson(Map<String, dynamic> json) => _$TvListResponseFromJson(json);

@override@HiveField(0) final  int page;
 final  List<TvSummary> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<TvSummary> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(2)@JsonKey(name: 'total_pages') final  int totalPages;
@override@HiveField(3)@JsonKey(name: 'total_results') final  int totalResults;

/// Create a copy of TvListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvListResponseCopyWith<_TvListResponse> get copyWith => __$TvListResponseCopyWithImpl<_TvListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvListResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalPages,totalResults);

@override
String toString() {
  return 'TvListResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$TvListResponseCopyWith<$Res> implements $TvListResponseCopyWith<$Res> {
  factory _$TvListResponseCopyWith(_TvListResponse value, $Res Function(_TvListResponse) _then) = __$TvListResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<TvSummary> results,@HiveField(2)@JsonKey(name: 'total_pages') int totalPages,@HiveField(3)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class __$TvListResponseCopyWithImpl<$Res>
    implements _$TvListResponseCopyWith<$Res> {
  __$TvListResponseCopyWithImpl(this._self, this._then);

  final _TvListResponse _self;
  final $Res Function(_TvListResponse) _then;

/// Create a copy of TvListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_TvListResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<TvSummary>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TvSummary {

@HiveField(0)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(1)@JsonKey(name: 'first_air_date') String? get firstAirDate;@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? get genreIds;@HiveField(3) int get id;@HiveField(4) String get name;@HiveField(5)@JsonKey(name: 'origin_country') List<String>? get originCountry;@HiveField(6)@JsonKey(name: 'original_language') String? get originalLanguage;@HiveField(7)@JsonKey(name: 'original_name') String? get originalName;@HiveField(8) String? get overview;@HiveField(9) double get popularity;@HiveField(10)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(11)@JsonKey(name: 'vote_average') double get voteAverage;@HiveField(12)@JsonKey(name: 'vote_count') int get voteCount;
/// Create a copy of TvSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvSummaryCopyWith<TvSummary> get copyWith => _$TvSummaryCopyWithImpl<TvSummary>(this as TvSummary, _$identity);

  /// Serializes this TvSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvSummary&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.originCountry, originCountry)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,backdropPath,firstAirDate,const DeepCollectionEquality().hash(genreIds),id,name,const DeepCollectionEquality().hash(originCountry),originalLanguage,originalName,overview,popularity,posterPath,voteAverage,voteCount);

@override
String toString() {
  return 'TvSummary(backdropPath: $backdropPath, firstAirDate: $firstAirDate, genreIds: $genreIds, id: $id, name: $name, originCountry: $originCountry, originalLanguage: $originalLanguage, originalName: $originalName, overview: $overview, popularity: $popularity, posterPath: $posterPath, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class $TvSummaryCopyWith<$Res>  {
  factory $TvSummaryCopyWith(TvSummary value, $Res Function(TvSummary) _then) = _$TvSummaryCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(1)@JsonKey(name: 'first_air_date') String? firstAirDate,@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(3) int id,@HiveField(4) String name,@HiveField(5)@JsonKey(name: 'origin_country') List<String>? originCountry,@HiveField(6)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(7)@JsonKey(name: 'original_name') String? originalName,@HiveField(8) String? overview,@HiveField(9) double popularity,@HiveField(10)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(11)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(12)@JsonKey(name: 'vote_count') int voteCount
});




}
/// @nodoc
class _$TvSummaryCopyWithImpl<$Res>
    implements $TvSummaryCopyWith<$Res> {
  _$TvSummaryCopyWithImpl(this._self, this._then);

  final TvSummary _self;
  final $Res Function(TvSummary) _then;

/// Create a copy of TvSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? genreIds = freezed,Object? id = null,Object? name = null,Object? originCountry = freezed,Object? originalLanguage = freezed,Object? originalName = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? voteAverage = null,Object? voteCount = null,}) {
  return _then(_self.copyWith(
backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originCountry: freezed == originCountry ? _self.originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as List<String>?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TvSummary].
extension TvSummaryPatterns on TvSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvSummary value)  $default,){
final _that = this;
switch (_that) {
case _TvSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TvSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(1)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'origin_country')  List<String>? originCountry, @HiveField(6)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(7)@JsonKey(name: 'original_name')  String? originalName, @HiveField(8)  String? overview, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(11)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(12)@JsonKey(name: 'vote_count')  int voteCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvSummary() when $default != null:
return $default(_that.backdropPath,_that.firstAirDate,_that.genreIds,_that.id,_that.name,_that.originCountry,_that.originalLanguage,_that.originalName,_that.overview,_that.popularity,_that.posterPath,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(1)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'origin_country')  List<String>? originCountry, @HiveField(6)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(7)@JsonKey(name: 'original_name')  String? originalName, @HiveField(8)  String? overview, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(11)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(12)@JsonKey(name: 'vote_count')  int voteCount)  $default,) {final _that = this;
switch (_that) {
case _TvSummary():
return $default(_that.backdropPath,_that.firstAirDate,_that.genreIds,_that.id,_that.name,_that.originCountry,_that.originalLanguage,_that.originalName,_that.overview,_that.popularity,_that.posterPath,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(1)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'origin_country')  List<String>? originCountry, @HiveField(6)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(7)@JsonKey(name: 'original_name')  String? originalName, @HiveField(8)  String? overview, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(11)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(12)@JsonKey(name: 'vote_count')  int voteCount)?  $default,) {final _that = this;
switch (_that) {
case _TvSummary() when $default != null:
return $default(_that.backdropPath,_that.firstAirDate,_that.genreIds,_that.id,_that.name,_that.originCountry,_that.originalLanguage,_that.originalName,_that.overview,_that.popularity,_that.posterPath,_that.voteAverage,_that.voteCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TvSummary implements TvSummary {
   _TvSummary({@HiveField(0)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(1)@JsonKey(name: 'first_air_date') this.firstAirDate, @HiveField(2)@JsonKey(name: 'genre_ids') final  List<int>? genreIds, @HiveField(3) required this.id, @HiveField(4) required this.name, @HiveField(5)@JsonKey(name: 'origin_country') final  List<String>? originCountry, @HiveField(6)@JsonKey(name: 'original_language') this.originalLanguage, @HiveField(7)@JsonKey(name: 'original_name') this.originalName, @HiveField(8) this.overview, @HiveField(9) this.popularity = 0.0, @HiveField(10)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(11)@JsonKey(name: 'vote_average') this.voteAverage = 0.0, @HiveField(12)@JsonKey(name: 'vote_count') this.voteCount = 0}): _genreIds = genreIds,_originCountry = originCountry;
  factory _TvSummary.fromJson(Map<String, dynamic> json) => _$TvSummaryFromJson(json);

@override@HiveField(0)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(1)@JsonKey(name: 'first_air_date') final  String? firstAirDate;
 final  List<int>? _genreIds;
@override@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? get genreIds {
  final value = _genreIds;
  if (value == null) return null;
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(3) final  int id;
@override@HiveField(4) final  String name;
 final  List<String>? _originCountry;
@override@HiveField(5)@JsonKey(name: 'origin_country') List<String>? get originCountry {
  final value = _originCountry;
  if (value == null) return null;
  if (_originCountry is EqualUnmodifiableListView) return _originCountry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(6)@JsonKey(name: 'original_language') final  String? originalLanguage;
@override@HiveField(7)@JsonKey(name: 'original_name') final  String? originalName;
@override@HiveField(8) final  String? overview;
@override@JsonKey()@HiveField(9) final  double popularity;
@override@HiveField(10)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(11)@JsonKey(name: 'vote_average') final  double voteAverage;
@override@HiveField(12)@JsonKey(name: 'vote_count') final  int voteCount;

/// Create a copy of TvSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvSummaryCopyWith<_TvSummary> get copyWith => __$TvSummaryCopyWithImpl<_TvSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvSummary&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._originCountry, _originCountry)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,backdropPath,firstAirDate,const DeepCollectionEquality().hash(_genreIds),id,name,const DeepCollectionEquality().hash(_originCountry),originalLanguage,originalName,overview,popularity,posterPath,voteAverage,voteCount);

@override
String toString() {
  return 'TvSummary(backdropPath: $backdropPath, firstAirDate: $firstAirDate, genreIds: $genreIds, id: $id, name: $name, originCountry: $originCountry, originalLanguage: $originalLanguage, originalName: $originalName, overview: $overview, popularity: $popularity, posterPath: $posterPath, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class _$TvSummaryCopyWith<$Res> implements $TvSummaryCopyWith<$Res> {
  factory _$TvSummaryCopyWith(_TvSummary value, $Res Function(_TvSummary) _then) = __$TvSummaryCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(1)@JsonKey(name: 'first_air_date') String? firstAirDate,@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(3) int id,@HiveField(4) String name,@HiveField(5)@JsonKey(name: 'origin_country') List<String>? originCountry,@HiveField(6)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(7)@JsonKey(name: 'original_name') String? originalName,@HiveField(8) String? overview,@HiveField(9) double popularity,@HiveField(10)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(11)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(12)@JsonKey(name: 'vote_count') int voteCount
});




}
/// @nodoc
class __$TvSummaryCopyWithImpl<$Res>
    implements _$TvSummaryCopyWith<$Res> {
  __$TvSummaryCopyWithImpl(this._self, this._then);

  final _TvSummary _self;
  final $Res Function(_TvSummary) _then;

/// Create a copy of TvSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? genreIds = freezed,Object? id = null,Object? name = null,Object? originCountry = freezed,Object? originalLanguage = freezed,Object? originalName = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? voteAverage = null,Object? voteCount = null,}) {
  return _then(_TvSummary(
backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originCountry: freezed == originCountry ? _self._originCountry : originCountry // ignore: cast_nullable_to_non_nullable
as List<String>?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
