// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combined_credit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonCredits {

@HiveField(0) List<CastCredit> get cast;@HiveField(1) List<CrewCredit> get crew;
/// Create a copy of PersonCredits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonCreditsCopyWith<PersonCredits> get copyWith => _$PersonCreditsCopyWithImpl<PersonCredits>(this as PersonCredits, _$identity);

  /// Serializes this PersonCredits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonCredits&&const DeepCollectionEquality().equals(other.cast, cast)&&const DeepCollectionEquality().equals(other.crew, crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cast),const DeepCollectionEquality().hash(crew));

@override
String toString() {
  return 'PersonCredits(cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class $PersonCreditsCopyWith<$Res>  {
  factory $PersonCreditsCopyWith(PersonCredits value, $Res Function(PersonCredits) _then) = _$PersonCreditsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) List<CastCredit> cast,@HiveField(1) List<CrewCredit> crew
});




}
/// @nodoc
class _$PersonCreditsCopyWithImpl<$Res>
    implements $PersonCreditsCopyWith<$Res> {
  _$PersonCreditsCopyWithImpl(this._self, this._then);

  final PersonCredits _self;
  final $Res Function(PersonCredits) _then;

/// Create a copy of PersonCredits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cast = null,Object? crew = null,}) {
  return _then(_self.copyWith(
cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastCredit>,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as List<CrewCredit>,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonCredits].
extension PersonCreditsPatterns on PersonCredits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonCredits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonCredits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonCredits value)  $default,){
final _that = this;
switch (_that) {
case _PersonCredits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonCredits value)?  $default,){
final _that = this;
switch (_that) {
case _PersonCredits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  List<CastCredit> cast, @HiveField(1)  List<CrewCredit> crew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonCredits() when $default != null:
return $default(_that.cast,_that.crew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  List<CastCredit> cast, @HiveField(1)  List<CrewCredit> crew)  $default,) {final _that = this;
switch (_that) {
case _PersonCredits():
return $default(_that.cast,_that.crew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  List<CastCredit> cast, @HiveField(1)  List<CrewCredit> crew)?  $default,) {final _that = this;
switch (_that) {
case _PersonCredits() when $default != null:
return $default(_that.cast,_that.crew);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PersonCredits implements PersonCredits {
   _PersonCredits({@HiveField(0) required final  List<CastCredit> cast, @HiveField(1) required final  List<CrewCredit> crew}): _cast = cast,_crew = crew;
  factory _PersonCredits.fromJson(Map<String, dynamic> json) => _$PersonCreditsFromJson(json);

 final  List<CastCredit> _cast;
@override@HiveField(0) List<CastCredit> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

 final  List<CrewCredit> _crew;
@override@HiveField(1) List<CrewCredit> get crew {
  if (_crew is EqualUnmodifiableListView) return _crew;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crew);
}


/// Create a copy of PersonCredits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonCreditsCopyWith<_PersonCredits> get copyWith => __$PersonCreditsCopyWithImpl<_PersonCredits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonCreditsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonCredits&&const DeepCollectionEquality().equals(other._cast, _cast)&&const DeepCollectionEquality().equals(other._crew, _crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cast),const DeepCollectionEquality().hash(_crew));

@override
String toString() {
  return 'PersonCredits(cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class _$PersonCreditsCopyWith<$Res> implements $PersonCreditsCopyWith<$Res> {
  factory _$PersonCreditsCopyWith(_PersonCredits value, $Res Function(_PersonCredits) _then) = __$PersonCreditsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) List<CastCredit> cast,@HiveField(1) List<CrewCredit> crew
});




}
/// @nodoc
class __$PersonCreditsCopyWithImpl<$Res>
    implements _$PersonCreditsCopyWith<$Res> {
  __$PersonCreditsCopyWithImpl(this._self, this._then);

  final _PersonCredits _self;
  final $Res Function(_PersonCredits) _then;

/// Create a copy of PersonCredits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cast = null,Object? crew = null,}) {
  return _then(_PersonCredits(
cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastCredit>,crew: null == crew ? _self._crew : crew // ignore: cast_nullable_to_non_nullable
as List<CrewCredit>,
  ));
}


}


/// @nodoc
mixin _$CastCredit {

@HiveField(0) bool get adult;@HiveField(1)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? get genreIds;@HiveField(3) int get id;@HiveField(4)@JsonKey(name: 'original_language') String? get originalLanguage;@HiveField(5)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(6) String? get overview;@HiveField(7) double get popularity;@HiveField(8)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(9)@JsonKey(name: 'release_date') String? get releaseDate;@HiveField(10) String? get title;@HiveField(11) bool get video;@HiveField(12)@JsonKey(name: 'vote_average') double get voteAverage;@HiveField(13)@JsonKey(name: 'vote_count') int get voteCount;@HiveField(14) String? get character;@HiveField(15)@JsonKey(name: 'credit_id') String? get creditId;@HiveField(16) int get order;@HiveField(17)@JsonKey(name: 'media_type') String? get mediaType;
/// Create a copy of CastCredit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CastCreditCopyWith<CastCredit> get copyWith => _$CastCreditCopyWithImpl<CastCredit>(this as CastCredit, _$identity);

  /// Serializes this CastCredit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CastCredit&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.video, video) || other.video == video)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.order, order) || other.order == order)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,backdropPath,const DeepCollectionEquality().hash(genreIds),id,originalLanguage,originalTitle,overview,popularity,posterPath,releaseDate,title,video,voteAverage,voteCount,character,creditId,order,mediaType);

@override
String toString() {
  return 'CastCredit(adult: $adult, backdropPath: $backdropPath, genreIds: $genreIds, id: $id, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount, character: $character, creditId: $creditId, order: $order, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $CastCreditCopyWith<$Res>  {
  factory $CastCreditCopyWith(CastCredit value, $Res Function(CastCredit) _then) = _$CastCreditCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(3) int id,@HiveField(4)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(5)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(6) String? overview,@HiveField(7) double popularity,@HiveField(8)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(9)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(10) String? title,@HiveField(11) bool video,@HiveField(12)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(13)@JsonKey(name: 'vote_count') int voteCount,@HiveField(14) String? character,@HiveField(15)@JsonKey(name: 'credit_id') String? creditId,@HiveField(16) int order,@HiveField(17)@JsonKey(name: 'media_type') String? mediaType
});




}
/// @nodoc
class _$CastCreditCopyWithImpl<$Res>
    implements $CastCreditCopyWith<$Res> {
  _$CastCreditCopyWithImpl(this._self, this._then);

  final CastCredit _self;
  final $Res Function(CastCredit) _then;

/// Create a copy of CastCredit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adult = null,Object? backdropPath = freezed,Object? genreIds = freezed,Object? id = null,Object? originalLanguage = freezed,Object? originalTitle = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? releaseDate = freezed,Object? title = freezed,Object? video = null,Object? voteAverage = null,Object? voteCount = null,Object? character = freezed,Object? creditId = freezed,Object? order = null,Object? mediaType = freezed,}) {
  return _then(_self.copyWith(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CastCredit].
extension CastCreditPatterns on CastCredit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CastCredit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CastCredit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CastCredit value)  $default,){
final _that = this;
switch (_that) {
case _CastCredit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CastCredit value)?  $default,){
final _that = this;
switch (_that) {
case _CastCredit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(5)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(6)  String? overview, @HiveField(7)  double popularity, @HiveField(8)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(9)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(10)  String? title, @HiveField(11)  bool video, @HiveField(12)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(13)@JsonKey(name: 'vote_count')  int voteCount, @HiveField(14)  String? character, @HiveField(15)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(16)  int order, @HiveField(17)@JsonKey(name: 'media_type')  String? mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CastCredit() when $default != null:
return $default(_that.adult,_that.backdropPath,_that.genreIds,_that.id,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.releaseDate,_that.title,_that.video,_that.voteAverage,_that.voteCount,_that.character,_that.creditId,_that.order,_that.mediaType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(5)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(6)  String? overview, @HiveField(7)  double popularity, @HiveField(8)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(9)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(10)  String? title, @HiveField(11)  bool video, @HiveField(12)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(13)@JsonKey(name: 'vote_count')  int voteCount, @HiveField(14)  String? character, @HiveField(15)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(16)  int order, @HiveField(17)@JsonKey(name: 'media_type')  String? mediaType)  $default,) {final _that = this;
switch (_that) {
case _CastCredit():
return $default(_that.adult,_that.backdropPath,_that.genreIds,_that.id,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.releaseDate,_that.title,_that.video,_that.voteAverage,_that.voteCount,_that.character,_that.creditId,_that.order,_that.mediaType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(5)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(6)  String? overview, @HiveField(7)  double popularity, @HiveField(8)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(9)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(10)  String? title, @HiveField(11)  bool video, @HiveField(12)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(13)@JsonKey(name: 'vote_count')  int voteCount, @HiveField(14)  String? character, @HiveField(15)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(16)  int order, @HiveField(17)@JsonKey(name: 'media_type')  String? mediaType)?  $default,) {final _that = this;
switch (_that) {
case _CastCredit() when $default != null:
return $default(_that.adult,_that.backdropPath,_that.genreIds,_that.id,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.releaseDate,_that.title,_that.video,_that.voteAverage,_that.voteCount,_that.character,_that.creditId,_that.order,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _CastCredit implements CastCredit {
   _CastCredit({@HiveField(0) this.adult = true, @HiveField(1)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids') final  List<int>? genreIds, @HiveField(3) this.id = 0, @HiveField(4)@JsonKey(name: 'original_language') this.originalLanguage, @HiveField(5)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(6) this.overview, @HiveField(7) this.popularity = 0.0, @HiveField(8)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(9)@JsonKey(name: 'release_date') this.releaseDate, @HiveField(10) this.title, @HiveField(11) this.video = true, @HiveField(12)@JsonKey(name: 'vote_average') this.voteAverage = 0.0, @HiveField(13)@JsonKey(name: 'vote_count') this.voteCount = 0, @HiveField(14) this.character, @HiveField(15)@JsonKey(name: 'credit_id') this.creditId, @HiveField(16) this.order = 0, @HiveField(17)@JsonKey(name: 'media_type') this.mediaType}): _genreIds = genreIds;
  factory _CastCredit.fromJson(Map<String, dynamic> json) => _$CastCreditFromJson(json);

@override@JsonKey()@HiveField(0) final  bool adult;
@override@HiveField(1)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
 final  List<int>? _genreIds;
@override@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? get genreIds {
  final value = _genreIds;
  if (value == null) return null;
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey()@HiveField(3) final  int id;
@override@HiveField(4)@JsonKey(name: 'original_language') final  String? originalLanguage;
@override@HiveField(5)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(6) final  String? overview;
@override@JsonKey()@HiveField(7) final  double popularity;
@override@HiveField(8)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(9)@JsonKey(name: 'release_date') final  String? releaseDate;
@override@HiveField(10) final  String? title;
@override@JsonKey()@HiveField(11) final  bool video;
@override@HiveField(12)@JsonKey(name: 'vote_average') final  double voteAverage;
@override@HiveField(13)@JsonKey(name: 'vote_count') final  int voteCount;
@override@HiveField(14) final  String? character;
@override@HiveField(15)@JsonKey(name: 'credit_id') final  String? creditId;
@override@JsonKey()@HiveField(16) final  int order;
@override@HiveField(17)@JsonKey(name: 'media_type') final  String? mediaType;

/// Create a copy of CastCredit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CastCreditCopyWith<_CastCredit> get copyWith => __$CastCreditCopyWithImpl<_CastCredit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CastCreditToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CastCredit&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.video, video) || other.video == video)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.order, order) || other.order == order)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,backdropPath,const DeepCollectionEquality().hash(_genreIds),id,originalLanguage,originalTitle,overview,popularity,posterPath,releaseDate,title,video,voteAverage,voteCount,character,creditId,order,mediaType);

@override
String toString() {
  return 'CastCredit(adult: $adult, backdropPath: $backdropPath, genreIds: $genreIds, id: $id, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount, character: $character, creditId: $creditId, order: $order, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$CastCreditCopyWith<$Res> implements $CastCreditCopyWith<$Res> {
  factory _$CastCreditCopyWith(_CastCredit value, $Res Function(_CastCredit) _then) = __$CastCreditCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(3) int id,@HiveField(4)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(5)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(6) String? overview,@HiveField(7) double popularity,@HiveField(8)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(9)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(10) String? title,@HiveField(11) bool video,@HiveField(12)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(13)@JsonKey(name: 'vote_count') int voteCount,@HiveField(14) String? character,@HiveField(15)@JsonKey(name: 'credit_id') String? creditId,@HiveField(16) int order,@HiveField(17)@JsonKey(name: 'media_type') String? mediaType
});




}
/// @nodoc
class __$CastCreditCopyWithImpl<$Res>
    implements _$CastCreditCopyWith<$Res> {
  __$CastCreditCopyWithImpl(this._self, this._then);

  final _CastCredit _self;
  final $Res Function(_CastCredit) _then;

/// Create a copy of CastCredit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adult = null,Object? backdropPath = freezed,Object? genreIds = freezed,Object? id = null,Object? originalLanguage = freezed,Object? originalTitle = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? releaseDate = freezed,Object? title = freezed,Object? video = null,Object? voteAverage = null,Object? voteCount = null,Object? character = freezed,Object? creditId = freezed,Object? order = null,Object? mediaType = freezed,}) {
  return _then(_CastCredit(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CrewCredit {

@HiveField(0) bool get adult;@HiveField(1)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? get genreIds;@HiveField(3) int get id;@HiveField(4)@JsonKey(name: 'original_language') String? get originalLanguage;@HiveField(5)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(6) String? get overview;@HiveField(7) double get popularity;@HiveField(8)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(9)@JsonKey(name: 'release_date') String? get releaseDate;@HiveField(10) String? get title;@HiveField(11) bool get video;@HiveField(12)@JsonKey(name: 'vote_average') double get voteAverage;@HiveField(13)@JsonKey(name: 'vote_count') int get voteCount;@HiveField(14)@JsonKey(name: 'credit_id') String? get creditId;@HiveField(15) String? get department;@HiveField(16) String? get job;@HiveField(17)@JsonKey(name: 'media_type') String? get mediaType;
/// Create a copy of CrewCredit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewCreditCopyWith<CrewCredit> get copyWith => _$CrewCreditCopyWithImpl<CrewCredit>(this as CrewCredit, _$identity);

  /// Serializes this CrewCredit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewCredit&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.video, video) || other.video == video)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,backdropPath,const DeepCollectionEquality().hash(genreIds),id,originalLanguage,originalTitle,overview,popularity,posterPath,releaseDate,title,video,voteAverage,voteCount,creditId,department,job,mediaType);

@override
String toString() {
  return 'CrewCredit(adult: $adult, backdropPath: $backdropPath, genreIds: $genreIds, id: $id, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount, creditId: $creditId, department: $department, job: $job, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $CrewCreditCopyWith<$Res>  {
  factory $CrewCreditCopyWith(CrewCredit value, $Res Function(CrewCredit) _then) = _$CrewCreditCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(3) int id,@HiveField(4)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(5)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(6) String? overview,@HiveField(7) double popularity,@HiveField(8)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(9)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(10) String? title,@HiveField(11) bool video,@HiveField(12)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(13)@JsonKey(name: 'vote_count') int voteCount,@HiveField(14)@JsonKey(name: 'credit_id') String? creditId,@HiveField(15) String? department,@HiveField(16) String? job,@HiveField(17)@JsonKey(name: 'media_type') String? mediaType
});




}
/// @nodoc
class _$CrewCreditCopyWithImpl<$Res>
    implements $CrewCreditCopyWith<$Res> {
  _$CrewCreditCopyWithImpl(this._self, this._then);

  final CrewCredit _self;
  final $Res Function(CrewCredit) _then;

/// Create a copy of CrewCredit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adult = null,Object? backdropPath = freezed,Object? genreIds = freezed,Object? id = null,Object? originalLanguage = freezed,Object? originalTitle = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? releaseDate = freezed,Object? title = freezed,Object? video = null,Object? voteAverage = null,Object? voteCount = null,Object? creditId = freezed,Object? department = freezed,Object? job = freezed,Object? mediaType = freezed,}) {
  return _then(_self.copyWith(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewCredit].
extension CrewCreditPatterns on CrewCredit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewCredit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewCredit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewCredit value)  $default,){
final _that = this;
switch (_that) {
case _CrewCredit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewCredit value)?  $default,){
final _that = this;
switch (_that) {
case _CrewCredit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(5)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(6)  String? overview, @HiveField(7)  double popularity, @HiveField(8)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(9)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(10)  String? title, @HiveField(11)  bool video, @HiveField(12)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(13)@JsonKey(name: 'vote_count')  int voteCount, @HiveField(14)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(15)  String? department, @HiveField(16)  String? job, @HiveField(17)@JsonKey(name: 'media_type')  String? mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewCredit() when $default != null:
return $default(_that.adult,_that.backdropPath,_that.genreIds,_that.id,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.releaseDate,_that.title,_that.video,_that.voteAverage,_that.voteCount,_that.creditId,_that.department,_that.job,_that.mediaType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(5)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(6)  String? overview, @HiveField(7)  double popularity, @HiveField(8)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(9)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(10)  String? title, @HiveField(11)  bool video, @HiveField(12)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(13)@JsonKey(name: 'vote_count')  int voteCount, @HiveField(14)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(15)  String? department, @HiveField(16)  String? job, @HiveField(17)@JsonKey(name: 'media_type')  String? mediaType)  $default,) {final _that = this;
switch (_that) {
case _CrewCredit():
return $default(_that.adult,_that.backdropPath,_that.genreIds,_that.id,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.releaseDate,_that.title,_that.video,_that.voteAverage,_that.voteCount,_that.creditId,_that.department,_that.job,_that.mediaType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids')  List<int>? genreIds, @HiveField(3)  int id, @HiveField(4)@JsonKey(name: 'original_language')  String? originalLanguage, @HiveField(5)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(6)  String? overview, @HiveField(7)  double popularity, @HiveField(8)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(9)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(10)  String? title, @HiveField(11)  bool video, @HiveField(12)@JsonKey(name: 'vote_average')  double voteAverage, @HiveField(13)@JsonKey(name: 'vote_count')  int voteCount, @HiveField(14)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(15)  String? department, @HiveField(16)  String? job, @HiveField(17)@JsonKey(name: 'media_type')  String? mediaType)?  $default,) {final _that = this;
switch (_that) {
case _CrewCredit() when $default != null:
return $default(_that.adult,_that.backdropPath,_that.genreIds,_that.id,_that.originalLanguage,_that.originalTitle,_that.overview,_that.popularity,_that.posterPath,_that.releaseDate,_that.title,_that.video,_that.voteAverage,_that.voteCount,_that.creditId,_that.department,_that.job,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _CrewCredit implements CrewCredit {
   _CrewCredit({@HiveField(0) this.adult = true, @HiveField(1)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(2)@JsonKey(name: 'genre_ids') final  List<int>? genreIds, @HiveField(3) this.id = 0, @HiveField(4)@JsonKey(name: 'original_language') this.originalLanguage, @HiveField(5)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(6) this.overview, @HiveField(7) this.popularity = 0.0, @HiveField(8)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(9)@JsonKey(name: 'release_date') this.releaseDate, @HiveField(10) this.title, @HiveField(11) this.video = true, @HiveField(12)@JsonKey(name: 'vote_average') this.voteAverage = 0.0, @HiveField(13)@JsonKey(name: 'vote_count') this.voteCount = 0, @HiveField(14)@JsonKey(name: 'credit_id') this.creditId, @HiveField(15) this.department, @HiveField(16) this.job, @HiveField(17)@JsonKey(name: 'media_type') this.mediaType}): _genreIds = genreIds;
  factory _CrewCredit.fromJson(Map<String, dynamic> json) => _$CrewCreditFromJson(json);

@override@JsonKey()@HiveField(0) final  bool adult;
@override@HiveField(1)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
 final  List<int>? _genreIds;
@override@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? get genreIds {
  final value = _genreIds;
  if (value == null) return null;
  if (_genreIds is EqualUnmodifiableListView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey()@HiveField(3) final  int id;
@override@HiveField(4)@JsonKey(name: 'original_language') final  String? originalLanguage;
@override@HiveField(5)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(6) final  String? overview;
@override@JsonKey()@HiveField(7) final  double popularity;
@override@HiveField(8)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(9)@JsonKey(name: 'release_date') final  String? releaseDate;
@override@HiveField(10) final  String? title;
@override@JsonKey()@HiveField(11) final  bool video;
@override@HiveField(12)@JsonKey(name: 'vote_average') final  double voteAverage;
@override@HiveField(13)@JsonKey(name: 'vote_count') final  int voteCount;
@override@HiveField(14)@JsonKey(name: 'credit_id') final  String? creditId;
@override@HiveField(15) final  String? department;
@override@HiveField(16) final  String? job;
@override@HiveField(17)@JsonKey(name: 'media_type') final  String? mediaType;

/// Create a copy of CrewCredit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewCreditCopyWith<_CrewCredit> get copyWith => __$CrewCreditCopyWithImpl<_CrewCredit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewCreditToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewCredit&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.video, video) || other.video == video)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,backdropPath,const DeepCollectionEquality().hash(_genreIds),id,originalLanguage,originalTitle,overview,popularity,posterPath,releaseDate,title,video,voteAverage,voteCount,creditId,department,job,mediaType);

@override
String toString() {
  return 'CrewCredit(adult: $adult, backdropPath: $backdropPath, genreIds: $genreIds, id: $id, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount, creditId: $creditId, department: $department, job: $job, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$CrewCreditCopyWith<$Res> implements $CrewCreditCopyWith<$Res> {
  factory _$CrewCreditCopyWith(_CrewCredit value, $Res Function(_CrewCredit) _then) = __$CrewCreditCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(2)@JsonKey(name: 'genre_ids') List<int>? genreIds,@HiveField(3) int id,@HiveField(4)@JsonKey(name: 'original_language') String? originalLanguage,@HiveField(5)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(6) String? overview,@HiveField(7) double popularity,@HiveField(8)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(9)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(10) String? title,@HiveField(11) bool video,@HiveField(12)@JsonKey(name: 'vote_average') double voteAverage,@HiveField(13)@JsonKey(name: 'vote_count') int voteCount,@HiveField(14)@JsonKey(name: 'credit_id') String? creditId,@HiveField(15) String? department,@HiveField(16) String? job,@HiveField(17)@JsonKey(name: 'media_type') String? mediaType
});




}
/// @nodoc
class __$CrewCreditCopyWithImpl<$Res>
    implements _$CrewCreditCopyWith<$Res> {
  __$CrewCreditCopyWithImpl(this._self, this._then);

  final _CrewCredit _self;
  final $Res Function(_CrewCredit) _then;

/// Create a copy of CrewCredit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adult = null,Object? backdropPath = freezed,Object? genreIds = freezed,Object? id = null,Object? originalLanguage = freezed,Object? originalTitle = freezed,Object? overview = freezed,Object? popularity = null,Object? posterPath = freezed,Object? releaseDate = freezed,Object? title = freezed,Object? video = null,Object? voteAverage = null,Object? voteCount = null,Object? creditId = freezed,Object? department = freezed,Object? job = freezed,Object? mediaType = freezed,}) {
  return _then(_CrewCredit(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,genreIds: freezed == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as List<int>?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
