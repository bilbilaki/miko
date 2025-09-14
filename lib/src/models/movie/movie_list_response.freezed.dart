// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieListResponse {

@HiveField(0) int get page;@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> get results;@HiveField(2)@JsonKey(name: 'total_results') int get totalResults;@HiveField(3)@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of MovieListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListResponseCopyWith<MovieListResponse> get copyWith => _$MovieListResponseCopyWithImpl<MovieListResponse>(this as MovieListResponse, _$identity);

  /// Serializes this MovieListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalResults,totalPages);

@override
String toString() {
  return 'MovieListResponse(page: $page, results: $results, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $MovieListResponseCopyWith<$Res>  {
  factory $MovieListResponseCopyWith(MovieListResponse value, $Res Function(MovieListResponse) _then) = _$MovieListResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> results,@HiveField(2)@JsonKey(name: 'total_results') int totalResults,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$MovieListResponseCopyWithImpl<$Res>
    implements $MovieListResponseCopyWith<$Res> {
  _$MovieListResponseCopyWithImpl(this._self, this._then);

  final MovieListResponse _self;
  final $Res Function(MovieListResponse) _then;

/// Create a copy of MovieListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MovieListItem>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListResponse].
extension MovieListResponsePatterns on MovieListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieListResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovieListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovieListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieListResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _MovieListResponse():
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _MovieListResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieListResponse implements MovieListResponse {
  const _MovieListResponse({@HiveField(0) required this.page, @HiveField(1)@JsonKey(name: 'results') required final  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results') required this.totalResults, @HiveField(3)@JsonKey(name: 'total_pages') required this.totalPages}): _results = results;
  factory _MovieListResponse.fromJson(Map<String, dynamic> json) => _$MovieListResponseFromJson(json);

@override@HiveField(0) final  int page;
 final  List<MovieListItem> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(2)@JsonKey(name: 'total_results') final  int totalResults;
@override@HiveField(3)@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of MovieListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieListResponseCopyWith<_MovieListResponse> get copyWith => __$MovieListResponseCopyWithImpl<_MovieListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieListResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalResults,totalPages);

@override
String toString() {
  return 'MovieListResponse(page: $page, results: $results, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$MovieListResponseCopyWith<$Res> implements $MovieListResponseCopyWith<$Res> {
  factory _$MovieListResponseCopyWith(_MovieListResponse value, $Res Function(_MovieListResponse) _then) = __$MovieListResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> results,@HiveField(2)@JsonKey(name: 'total_results') int totalResults,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$MovieListResponseCopyWithImpl<$Res>
    implements _$MovieListResponseCopyWith<$Res> {
  __$MovieListResponseCopyWithImpl(this._self, this._then);

  final _MovieListResponse _self;
  final $Res Function(_MovieListResponse) _then;

/// Create a copy of MovieListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_MovieListResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MovieListItem>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MovieListItem {

@HiveField(0) int get id;@HiveField(1) String get title;@HiveField(2)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(3)@JsonKey(name: 'overview') String? get overview;@HiveField(4)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(5)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(6)@JsonKey(name: 'release_date') String? get releaseDate;@HiveField(7)@JsonKey(name: 'vote_average') double? get voteAverage;@HiveField(8)@JsonKey(name: 'vote_count') int? get voteCount;@HiveField(9) double? get popularity;@HiveField(10) bool? get adult;@HiveField(11)@JsonKey(name: 'genre_ids') List<int>? get genreIds;@HiveField(12) bool? get video;@HiveField(13)@JsonKey(name: 'original_language') String? get originalLanguage;
/// Create a copy of MovieListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListItemCopyWith<MovieListItem> get copyWith => _$MovieListItemCopyWithImpl<MovieListItem>(this as MovieListItem, _$identity);

  /// Serializes this MovieListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.adult, adult) || other.adult == adult)&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&(identical(other.video, video) || other.video == video)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,overview,posterPath,backdropPath,releaseDate,voteAverage,voteCount,popularity,adult,const DeepCollectionEquality().hash(genreIds),video,originalLanguage);

@override
String toString() {
  return 'MovieListItem(id: $id, title: $title, originalTitle: $originalTitle, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, adult: $adult, genreIds: $genreIds, video: $video, originalLanguage: $originalLanguage)';
}


}

/// @nodoc
abstract mixin class $MovieListItemCopyWith<$Res>  {
  factory $MovieListItemCopyWith(MovieListItem value, $Res Function(MovieListItem) _then) = _$MovieListItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(3)@JsonKey(name: 'overview') String? overview,@HiveField(4)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(5)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(6)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(7)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(8)@JsonKey(name: 'vote_count') int? voteCount,@HiveField(9) double? popularity,@HiveField(10) bool? adult,@HiveField(11)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(12) bool? video,@HiveField(13)@JsonKey(name: 'original_language') String? originalLanguage
});




}
/// @nodoc
class _$MovieListItemCopyWithImpl<$Res>
    implements $MovieListItemCopyWith<$Res> {
  _$MovieListItemCopyWithImpl(this._self, this._then);

  final MovieListItem _self;
  final $Res Function(MovieListItem) _then;

/// Create a copy of MovieListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? originalTitle = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? popularity = freezed,Object? adult = freezed,Object? genreIds = freezed,Object? video = freezed,Object? originalLanguage = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,genreIds: freezed == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListItem].
extension MovieListItemPatterns on MovieListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieListItem value)  $default,){
final _that = this;
switch (_that) {
case _MovieListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieListItem value)?  $default,){
final _that = this;
switch (_that) {
case _MovieListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(3)@JsonKey(name: 'overview')  String? overview, @HiveField(4)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(5)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(6)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(7)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(8)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(9)  double? popularity, @HiveField(10)  bool? adult, @HiveField(11)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(12)  bool? video, @HiveField(13)@JsonKey(name: 'original_language')  String? originalLanguage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieListItem() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.overview,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.voteAverage,_that.voteCount,_that.popularity,_that.adult,_that.genreIds,_that.video,_that.originalLanguage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(3)@JsonKey(name: 'overview')  String? overview, @HiveField(4)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(5)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(6)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(7)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(8)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(9)  double? popularity, @HiveField(10)  bool? adult, @HiveField(11)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(12)  bool? video, @HiveField(13)@JsonKey(name: 'original_language')  String? originalLanguage)  $default,) {final _that = this;
switch (_that) {
case _MovieListItem():
return $default(_that.id,_that.title,_that.originalTitle,_that.overview,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.voteAverage,_that.voteCount,_that.popularity,_that.adult,_that.genreIds,_that.video,_that.originalLanguage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(3)@JsonKey(name: 'overview')  String? overview, @HiveField(4)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(5)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(6)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(7)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(8)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(9)  double? popularity, @HiveField(10)  bool? adult, @HiveField(11)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(12)  bool? video, @HiveField(13)@JsonKey(name: 'original_language')  String? originalLanguage)?  $default,) {final _that = this;
switch (_that) {
case _MovieListItem() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.overview,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.voteAverage,_that.voteCount,_that.popularity,_that.adult,_that.genreIds,_that.video,_that.originalLanguage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieListItem implements MovieListItem {
  const _MovieListItem({@HiveField(0) required this.id, @HiveField(1) required this.title, @HiveField(2)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(3)@JsonKey(name: 'overview') this.overview, @HiveField(4)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(5)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(6)@JsonKey(name: 'release_date') this.releaseDate, @HiveField(7)@JsonKey(name: 'vote_average') this.voteAverage, @HiveField(8)@JsonKey(name: 'vote_count') this.voteCount, @HiveField(9) this.popularity, @HiveField(10) this.adult, @HiveField(11)@JsonKey(name: 'genre_ids') final  List<int>? genreIds, @HiveField(12) this.video, @HiveField(13)@JsonKey(name: 'original_language') this.originalLanguage}): _genreIds = genreIds;
  factory _MovieListItem.fromJson(Map<String, dynamic> json) => _$MovieListItemFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String title;
@override@HiveField(2)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(3)@JsonKey(name: 'overview') final  String? overview;
@override@HiveField(4)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(5)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(6)@JsonKey(name: 'release_date') final  String? releaseDate;
@override@HiveField(7)@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@HiveField(8)@JsonKey(name: 'vote_count') final  int? voteCount;
@override@HiveField(9) final  double? popularity;
@override@HiveField(10) final  bool? adult;
 final  List<int>? _genreIds;
@override@HiveField(11)@JsonKey(name: 'genre_ids') List<int>? get genreIds {
  final value = _genreIds;
  if (value == null) return null;
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(12) final  bool? video;
@override@HiveField(13)@JsonKey(name: 'original_language') final  String? originalLanguage;

/// Create a copy of MovieListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieListItemCopyWith<_MovieListItem> get copyWith => __$MovieListItemCopyWithImpl<_MovieListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.adult, adult) || other.adult == adult)&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&(identical(other.video, video) || other.video == video)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,overview,posterPath,backdropPath,releaseDate,voteAverage,voteCount,popularity,adult,const DeepCollectionEquality().hash(_genreIds),video,originalLanguage);

@override
String toString() {
  return 'MovieListItem(id: $id, title: $title, originalTitle: $originalTitle, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, adult: $adult, genreIds: $genreIds, video: $video, originalLanguage: $originalLanguage)';
}


}

/// @nodoc
abstract mixin class _$MovieListItemCopyWith<$Res> implements $MovieListItemCopyWith<$Res> {
  factory _$MovieListItemCopyWith(_MovieListItem value, $Res Function(_MovieListItem) _then) = __$MovieListItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(3)@JsonKey(name: 'overview') String? overview,@HiveField(4)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(5)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(6)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(7)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(8)@JsonKey(name: 'vote_count') int? voteCount,@HiveField(9) double? popularity,@HiveField(10) bool? adult,@HiveField(11)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(12) bool? video,@HiveField(13)@JsonKey(name: 'original_language') String? originalLanguage
});




}
/// @nodoc
class __$MovieListItemCopyWithImpl<$Res>
    implements _$MovieListItemCopyWith<$Res> {
  __$MovieListItemCopyWithImpl(this._self, this._then);

  final _MovieListItem _self;
  final $Res Function(_MovieListItem) _then;

/// Create a copy of MovieListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? originalTitle = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? popularity = freezed,Object? adult = freezed,Object? genreIds = freezed,Object? video = freezed,Object? originalLanguage = freezed,}) {
  return _then(_MovieListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,genreIds: freezed == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
