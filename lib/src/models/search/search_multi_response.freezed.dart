// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_multi_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResultItem {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'media_type') String get mediaType;// Movie fields
@HiveField(2) String? get title;@HiveField(3)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(4)@JsonKey(name: 'release_date') String? get releaseDate;// TV fields
@HiveField(5) String? get name;@HiveField(6)@JsonKey(name: 'original_name') String? get originalName;@HiveField(7)@JsonKey(name: 'first_air_date') String? get firstAirDate;// Common
@HiveField(8) String? get overview;@HiveField(9)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(10)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(11)@JsonKey(name: 'profile_path') String? get profilePath;@HiveField(12) double? get popularity;@HiveField(13)@JsonKey(name: 'vote_average') double? get voteAverage;@HiveField(14)@JsonKey(name: 'vote_count') int? get voteCount;@HiveField(15) List<MovieListItemDetail>? get knownFor;// for people search results
@HiveField(16)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(17) int? get gender;@HiveField(18)@JsonKey(name: 'adult') bool? get adult;@HiveField(19)@JsonKey(name: 'original_language') String? get originalLanguage;@HiveField(20)@JsonKey(name: 'genre_ids') List<int>? get genreIds;
/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultItemCopyWith<SearchResultItem> get copyWith => _$SearchResultItemCopyWithImpl<SearchResultItem>(this as SearchResultItem, _$identity);

  /// Serializes this SearchResultItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultItem&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&const DeepCollectionEquality().equals(other.knownFor, knownFor)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&const DeepCollectionEquality().equals(other.genreIds, genreIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mediaType,title,originalTitle,releaseDate,name,originalName,firstAirDate,overview,posterPath,backdropPath,profilePath,popularity,voteAverage,voteCount,const DeepCollectionEquality().hash(knownFor),knownForDepartment,gender,adult,originalLanguage,const DeepCollectionEquality().hash(genreIds)]);

@override
String toString() {
  return 'SearchResultItem(id: $id, mediaType: $mediaType, title: $title, originalTitle: $originalTitle, releaseDate: $releaseDate, name: $name, originalName: $originalName, firstAirDate: $firstAirDate, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, profilePath: $profilePath, popularity: $popularity, voteAverage: $voteAverage, voteCount: $voteCount, knownFor: $knownFor, knownForDepartment: $knownForDepartment, gender: $gender, adult: $adult, originalLanguage: $originalLanguage, genreIds: $genreIds)';
}


}

/// @nodoc
abstract mixin class $SearchResultItemCopyWith<$Res>  {
  factory $SearchResultItemCopyWith(SearchResultItem value, $Res Function(SearchResultItem) _then) = _$SearchResultItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'media_type') String mediaType,@HiveField(2) String? title,@HiveField(3)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(4)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(5) String? name,@HiveField(6)@JsonKey(name: 'original_name') String? originalName,@HiveField(7)@JsonKey(name: 'first_air_date') String? firstAirDate,@HiveField(8) String? overview,@HiveField(9)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(10)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(11)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(12) double? popularity,@HiveField(13)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(14)@JsonKey(name: 'vote_count') int? voteCount,@HiveField(15) List<MovieListItemDetail>? knownFor,@HiveField(16)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(17) int? gender,@HiveField(18)@JsonKey(name: 'adult') bool? adult,@HiveField(19)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(20)@JsonKey(name: 'genre_ids') List<int>? genreIds
});




}
/// @nodoc
class _$SearchResultItemCopyWithImpl<$Res>
    implements $SearchResultItemCopyWith<$Res> {
  _$SearchResultItemCopyWithImpl(this._self, this._then);

  final SearchResultItem _self;
  final $Res Function(SearchResultItem) _then;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaType = null,Object? title = freezed,Object? originalTitle = freezed,Object? releaseDate = freezed,Object? name = freezed,Object? originalName = freezed,Object? firstAirDate = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? profilePath = freezed,Object? popularity = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? knownFor = freezed,Object? knownForDepartment = freezed,Object? gender = freezed,Object? adult = freezed,Object? originalLanguage = freezed,Object? genreIds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,knownFor: freezed == knownFor ? _self.knownFor : knownFor // ignore: cast_nullable_to_non_nullable
as List<MovieListItemDetail>?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResultItem].
extension SearchResultItemPatterns on SearchResultItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResultItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResultItem value)  $default,){
final _that = this;
switch (_that) {
case _SearchResultItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResultItem value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'media_type')  String mediaType, @HiveField(2)  String? title, @HiveField(3)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(4)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(5)  String? name, @HiveField(6)@JsonKey(name: 'original_name')  String? originalName, @HiveField(7)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(8)  String? overview, @HiveField(9)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(10)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(11)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(12)  double? popularity, @HiveField(13)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(14)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(15)  List<MovieListItemDetail>? knownFor, @HiveField(16)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(17)  int? gender, @HiveField(18)@JsonKey(name: 'adult')  bool? adult, @HiveField(19)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(20)@JsonKey(name: 'genre_ids')  List<int>? genreIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
return $default(_that.id,_that.mediaType,_that.title,_that.originalTitle,_that.releaseDate,_that.name,_that.originalName,_that.firstAirDate,_that.overview,_that.posterPath,_that.backdropPath,_that.profilePath,_that.popularity,_that.voteAverage,_that.voteCount,_that.knownFor,_that.knownForDepartment,_that.gender,_that.adult,_that.originalLanguage,_that.genreIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'media_type')  String mediaType, @HiveField(2)  String? title, @HiveField(3)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(4)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(5)  String? name, @HiveField(6)@JsonKey(name: 'original_name')  String? originalName, @HiveField(7)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(8)  String? overview, @HiveField(9)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(10)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(11)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(12)  double? popularity, @HiveField(13)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(14)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(15)  List<MovieListItemDetail>? knownFor, @HiveField(16)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(17)  int? gender, @HiveField(18)@JsonKey(name: 'adult')  bool? adult, @HiveField(19)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(20)@JsonKey(name: 'genre_ids')  List<int>? genreIds)  $default,) {final _that = this;
switch (_that) {
case _SearchResultItem():
return $default(_that.id,_that.mediaType,_that.title,_that.originalTitle,_that.releaseDate,_that.name,_that.originalName,_that.firstAirDate,_that.overview,_that.posterPath,_that.backdropPath,_that.profilePath,_that.popularity,_that.voteAverage,_that.voteCount,_that.knownFor,_that.knownForDepartment,_that.gender,_that.adult,_that.originalLanguage,_that.genreIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'media_type')  String mediaType, @HiveField(2)  String? title, @HiveField(3)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(4)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(5)  String? name, @HiveField(6)@JsonKey(name: 'original_name')  String? originalName, @HiveField(7)@JsonKey(name: 'first_air_date')  String? firstAirDate, @HiveField(8)  String? overview, @HiveField(9)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(10)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(11)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(12)  double? popularity, @HiveField(13)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(14)@JsonKey(name: 'vote_count')  int? voteCount, @HiveField(15)  List<MovieListItemDetail>? knownFor, @HiveField(16)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(17)  int? gender, @HiveField(18)@JsonKey(name: 'adult')  bool? adult, @HiveField(19)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(20)@JsonKey(name: 'genre_ids')  List<int>? genreIds)?  $default,) {final _that = this;
switch (_that) {
case _SearchResultItem() when $default != null:
return $default(_that.id,_that.mediaType,_that.title,_that.originalTitle,_that.releaseDate,_that.name,_that.originalName,_that.firstAirDate,_that.overview,_that.posterPath,_that.backdropPath,_that.profilePath,_that.popularity,_that.voteAverage,_that.voteCount,_that.knownFor,_that.knownForDepartment,_that.gender,_that.adult,_that.originalLanguage,_that.genreIds);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SearchResultItem implements SearchResultItem {
  const _SearchResultItem({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'media_type') required this.mediaType, @HiveField(2) this.title, @HiveField(3)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(4)@JsonKey(name: 'release_date') this.releaseDate, @HiveField(5) this.name, @HiveField(6)@JsonKey(name: 'original_name') this.originalName, @HiveField(7)@JsonKey(name: 'first_air_date') this.firstAirDate, @HiveField(8) this.overview, @HiveField(9)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(10)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(11)@JsonKey(name: 'profile_path') this.profilePath, @HiveField(12) this.popularity, @HiveField(13)@JsonKey(name: 'vote_average') this.voteAverage, @HiveField(14)@JsonKey(name: 'vote_count') this.voteCount, @HiveField(15) final  List<MovieListItemDetail>? knownFor, @HiveField(16)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(17) this.gender, @HiveField(18)@JsonKey(name: 'adult') this.adult, @HiveField(19)@JsonKey(name: 'original_language') this.originalLanguage, @HiveField(20)@JsonKey(name: 'genre_ids') final  List<int>? genreIds}): _knownFor = knownFor,_genreIds = genreIds;
  factory _SearchResultItem.fromJson(Map<String, dynamic> json) => _$SearchResultItemFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1)@JsonKey(name: 'media_type') final  String mediaType;
// Movie fields
@override@HiveField(2) final  String? title;
@override@HiveField(3)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(4)@JsonKey(name: 'release_date') final  String? releaseDate;
// TV fields
@override@HiveField(5) final  String? name;
@override@HiveField(6)@JsonKey(name: 'original_name') final  String? originalName;
@override@HiveField(7)@JsonKey(name: 'first_air_date') final  String? firstAirDate;
// Common
@override@HiveField(8) final  String? overview;
@override@HiveField(9)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(10)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(11)@JsonKey(name: 'profile_path') final  String? profilePath;
@override@HiveField(12) final  double? popularity;
@override@HiveField(13)@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@HiveField(14)@JsonKey(name: 'vote_count') final  int? voteCount;
 final  List<MovieListItemDetail>? _knownFor;
@override@HiveField(15) List<MovieListItemDetail>? get knownFor {
  final value = _knownFor;
  if (value == null) return null;
  if (_knownFor is EqualUnmodifiableListView) return _knownFor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// for people search results
@override@HiveField(16)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(17) final  int? gender;
@override@HiveField(18)@JsonKey(name: 'adult') final  bool? adult;
@override@HiveField(19)@JsonKey(name: 'original_language') final  String? originalLanguage;
 final  List<int>? _genreIds;
@override@HiveField(20)@JsonKey(name: 'genre_ids') List<int>? get genreIds {
  final value = _genreIds;
  if (value == null) return null;
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultItemCopyWith<_SearchResultItem> get copyWith => __$SearchResultItemCopyWithImpl<_SearchResultItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultItem&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&const DeepCollectionEquality().equals(other._knownFor, _knownFor)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&const DeepCollectionEquality().equals(other._genreIds, _genreIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mediaType,title,originalTitle,releaseDate,name,originalName,firstAirDate,overview,posterPath,backdropPath,profilePath,popularity,voteAverage,voteCount,const DeepCollectionEquality().hash(_knownFor),knownForDepartment,gender,adult,originalLanguage,const DeepCollectionEquality().hash(_genreIds)]);

@override
String toString() {
  return 'SearchResultItem(id: $id, mediaType: $mediaType, title: $title, originalTitle: $originalTitle, releaseDate: $releaseDate, name: $name, originalName: $originalName, firstAirDate: $firstAirDate, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, profilePath: $profilePath, popularity: $popularity, voteAverage: $voteAverage, voteCount: $voteCount, knownFor: $knownFor, knownForDepartment: $knownForDepartment, gender: $gender, adult: $adult, originalLanguage: $originalLanguage, genreIds: $genreIds)';
}


}

/// @nodoc
abstract mixin class _$SearchResultItemCopyWith<$Res> implements $SearchResultItemCopyWith<$Res> {
  factory _$SearchResultItemCopyWith(_SearchResultItem value, $Res Function(_SearchResultItem) _then) = __$SearchResultItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'media_type') String mediaType,@HiveField(2) String? title,@HiveField(3)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(4)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(5) String? name,@HiveField(6)@JsonKey(name: 'original_name') String? originalName,@HiveField(7)@JsonKey(name: 'first_air_date') String? firstAirDate,@HiveField(8) String? overview,@HiveField(9)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(10)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(11)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(12) double? popularity,@HiveField(13)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(14)@JsonKey(name: 'vote_count') int? voteCount,@HiveField(15) List<MovieListItemDetail>? knownFor,@HiveField(16)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(17) int? gender,@HiveField(18)@JsonKey(name: 'adult') bool? adult,@HiveField(19)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(20)@JsonKey(name: 'genre_ids') List<int>? genreIds
});




}
/// @nodoc
class __$SearchResultItemCopyWithImpl<$Res>
    implements _$SearchResultItemCopyWith<$Res> {
  __$SearchResultItemCopyWithImpl(this._self, this._then);

  final _SearchResultItem _self;
  final $Res Function(_SearchResultItem) _then;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaType = null,Object? title = freezed,Object? originalTitle = freezed,Object? releaseDate = freezed,Object? name = freezed,Object? originalName = freezed,Object? firstAirDate = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? profilePath = freezed,Object? popularity = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? knownFor = freezed,Object? knownForDepartment = freezed,Object? gender = freezed,Object? adult = freezed,Object? originalLanguage = freezed,Object? genreIds = freezed,}) {
  return _then(_SearchResultItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,knownFor: freezed == knownFor ? _self._knownFor : knownFor // ignore: cast_nullable_to_non_nullable
as List<MovieListItemDetail>?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}


/// @nodoc
mixin _$SearchMultiResponse {

@HiveField(0) int get page;@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> get results;@HiveField(2)@JsonKey(name: 'total_results') int get totalResults;@HiveField(3)@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of SearchMultiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchMultiResponseCopyWith<SearchMultiResponse> get copyWith => _$SearchMultiResponseCopyWithImpl<SearchMultiResponse>(this as SearchMultiResponse, _$identity);

  /// Serializes this SearchMultiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchMultiResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalResults,totalPages);

@override
String toString() {
  return 'SearchMultiResponse(page: $page, results: $results, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $SearchMultiResponseCopyWith<$Res>  {
  factory $SearchMultiResponseCopyWith(SearchMultiResponse value, $Res Function(SearchMultiResponse) _then) = _$SearchMultiResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> results,@HiveField(2)@JsonKey(name: 'total_results') int totalResults,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$SearchMultiResponseCopyWithImpl<$Res>
    implements $SearchMultiResponseCopyWith<$Res> {
  _$SearchMultiResponseCopyWithImpl(this._self, this._then);

  final SearchMultiResponse _self;
  final $Res Function(SearchMultiResponse) _then;

/// Create a copy of SearchMultiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchMultiResponse].
extension SearchMultiResponsePatterns on SearchMultiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchMultiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchMultiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchMultiResponse value)  $default,){
final _that = this;
switch (_that) {
case _SearchMultiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchMultiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SearchMultiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchMultiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _SearchMultiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _SearchMultiResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SearchMultiResponse implements SearchMultiResponse {
  const _SearchMultiResponse({@HiveField(0) required this.page, @HiveField(1)@JsonKey(name: 'results') required final  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_results') required this.totalResults, @HiveField(3)@JsonKey(name: 'total_pages') required this.totalPages}): _results = results;
  factory _SearchMultiResponse.fromJson(Map<String, dynamic> json) => _$SearchMultiResponseFromJson(json);

@override@HiveField(0) final  int page;
 final  List<SearchResultItem> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(2)@JsonKey(name: 'total_results') final  int totalResults;
@override@HiveField(3)@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of SearchMultiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchMultiResponseCopyWith<_SearchMultiResponse> get copyWith => __$SearchMultiResponseCopyWithImpl<_SearchMultiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchMultiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchMultiResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalResults,totalPages);

@override
String toString() {
  return 'SearchMultiResponse(page: $page, results: $results, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$SearchMultiResponseCopyWith<$Res> implements $SearchMultiResponseCopyWith<$Res> {
  factory _$SearchMultiResponseCopyWith(_SearchMultiResponse value, $Res Function(_SearchMultiResponse) _then) = __$SearchMultiResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> results,@HiveField(2)@JsonKey(name: 'total_results') int totalResults,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$SearchMultiResponseCopyWithImpl<$Res>
    implements _$SearchMultiResponseCopyWith<$Res> {
  __$SearchMultiResponseCopyWithImpl(this._self, this._then);

  final _SearchMultiResponse _self;
  final $Res Function(_SearchMultiResponse) _then;

/// Create a copy of SearchMultiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_SearchMultiResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
