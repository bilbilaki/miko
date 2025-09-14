// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieListItemDetail {

@HiveField(0) int get id;@HiveField(1) String get title;@HiveField(2)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(3)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(4)@JsonKey(name: 'media_type') String? get mediaType;@HiveField(5)@JsonKey(name: 'release_date') String? get releaseDate;@HiveField(6)@JsonKey(name: 'original_title') String? get originalTitle;
/// Create a copy of MovieListItemDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListItemDetailCopyWith<MovieListItemDetail> get copyWith => _$MovieListItemDetailCopyWithImpl<MovieListItemDetail>(this as MovieListItemDetail, _$identity);

  /// Serializes this MovieListItemDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListItemDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,posterPath,backdropPath,mediaType,releaseDate,originalTitle);

@override
String toString() {
  return 'MovieListItemDetail(id: $id, title: $title, posterPath: $posterPath, backdropPath: $backdropPath, mediaType: $mediaType, releaseDate: $releaseDate, originalTitle: $originalTitle)';
}


}

/// @nodoc
abstract mixin class $MovieListItemDetailCopyWith<$Res>  {
  factory $MovieListItemDetailCopyWith(MovieListItemDetail value, $Res Function(MovieListItemDetail) _then) = _$MovieListItemDetailCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(3)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(4)@JsonKey(name: 'media_type') String? mediaType,@HiveField(5)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(6)@JsonKey(name: 'original_title') String? originalTitle
});




}
/// @nodoc
class _$MovieListItemDetailCopyWithImpl<$Res>
    implements $MovieListItemDetailCopyWith<$Res> {
  _$MovieListItemDetailCopyWithImpl(this._self, this._then);

  final MovieListItemDetail _self;
  final $Res Function(MovieListItemDetail) _then;

/// Create a copy of MovieListItemDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? mediaType = freezed,Object? releaseDate = freezed,Object? originalTitle = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListItemDetail].
extension MovieListItemDetailPatterns on MovieListItemDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieListItemDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieListItemDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieListItemDetail value)  $default,){
final _that = this;
switch (_that) {
case _MovieListItemDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieListItemDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MovieListItemDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(3)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(4)@JsonKey(name: 'media_type')  String? mediaType, @HiveField(5)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(6)@JsonKey(name: 'original_title')  String? originalTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieListItemDetail() when $default != null:
return $default(_that.id,_that.title,_that.posterPath,_that.backdropPath,_that.mediaType,_that.releaseDate,_that.originalTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(3)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(4)@JsonKey(name: 'media_type')  String? mediaType, @HiveField(5)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(6)@JsonKey(name: 'original_title')  String? originalTitle)  $default,) {final _that = this;
switch (_that) {
case _MovieListItemDetail():
return $default(_that.id,_that.title,_that.posterPath,_that.backdropPath,_that.mediaType,_that.releaseDate,_that.originalTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(3)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(4)@JsonKey(name: 'media_type')  String? mediaType, @HiveField(5)@JsonKey(name: 'release_date')  String? releaseDate, @HiveField(6)@JsonKey(name: 'original_title')  String? originalTitle)?  $default,) {final _that = this;
switch (_that) {
case _MovieListItemDetail() when $default != null:
return $default(_that.id,_that.title,_that.posterPath,_that.backdropPath,_that.mediaType,_that.releaseDate,_that.originalTitle);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieListItemDetail implements MovieListItemDetail {
  const _MovieListItemDetail({@HiveField(0) required this.id, @HiveField(1) required this.title, @HiveField(2)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(3)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(4)@JsonKey(name: 'media_type') this.mediaType, @HiveField(5)@JsonKey(name: 'release_date') this.releaseDate, @HiveField(6)@JsonKey(name: 'original_title') this.originalTitle});
  factory _MovieListItemDetail.fromJson(Map<String, dynamic> json) => _$MovieListItemDetailFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String title;
@override@HiveField(2)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(3)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(4)@JsonKey(name: 'media_type') final  String? mediaType;
@override@HiveField(5)@JsonKey(name: 'release_date') final  String? releaseDate;
@override@HiveField(6)@JsonKey(name: 'original_title') final  String? originalTitle;

/// Create a copy of MovieListItemDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieListItemDetailCopyWith<_MovieListItemDetail> get copyWith => __$MovieListItemDetailCopyWithImpl<_MovieListItemDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieListItemDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieListItemDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,posterPath,backdropPath,mediaType,releaseDate,originalTitle);

@override
String toString() {
  return 'MovieListItemDetail(id: $id, title: $title, posterPath: $posterPath, backdropPath: $backdropPath, mediaType: $mediaType, releaseDate: $releaseDate, originalTitle: $originalTitle)';
}


}

/// @nodoc
abstract mixin class _$MovieListItemDetailCopyWith<$Res> implements $MovieListItemDetailCopyWith<$Res> {
  factory _$MovieListItemDetailCopyWith(_MovieListItemDetail value, $Res Function(_MovieListItemDetail) _then) = __$MovieListItemDetailCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(3)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(4)@JsonKey(name: 'media_type') String? mediaType,@HiveField(5)@JsonKey(name: 'release_date') String? releaseDate,@HiveField(6)@JsonKey(name: 'original_title') String? originalTitle
});




}
/// @nodoc
class __$MovieListItemDetailCopyWithImpl<$Res>
    implements _$MovieListItemDetailCopyWith<$Res> {
  __$MovieListItemDetailCopyWithImpl(this._self, this._then);

  final _MovieListItemDetail _self;
  final $Res Function(_MovieListItemDetail) _then;

/// Create a copy of MovieListItemDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? mediaType = freezed,Object? releaseDate = freezed,Object? originalTitle = freezed,}) {
  return _then(_MovieListItemDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MovieListDetails {

@HiveField(0) String get createdBy;@HiveField(1) String get description;@HiveField(2) int get favoriteCount;@HiveField(3) int get id;@HiveField(4) String get iso6391;@HiveField(5) String get itemCount;@HiveField(6) String get name;@HiveField(7)@JsonKey(name: 'items') List<MovieListItemDetail> get items;
/// Create a copy of MovieListDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListDetailsCopyWith<MovieListDetails> get copyWith => _$MovieListDetailsCopyWithImpl<MovieListDetails>(this as MovieListDetails, _$identity);

  /// Serializes this MovieListDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListDetails&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.description, description) || other.description == description)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.id, id) || other.id == id)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,createdBy,description,favoriteCount,id,iso6391,itemCount,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MovieListDetails(createdBy: $createdBy, description: $description, favoriteCount: $favoriteCount, id: $id, iso6391: $iso6391, itemCount: $itemCount, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $MovieListDetailsCopyWith<$Res>  {
  factory $MovieListDetailsCopyWith(MovieListDetails value, $Res Function(MovieListDetails) _then) = _$MovieListDetailsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String createdBy,@HiveField(1) String description,@HiveField(2) int favoriteCount,@HiveField(3) int id,@HiveField(4) String iso6391,@HiveField(5) String itemCount,@HiveField(6) String name,@HiveField(7)@JsonKey(name: 'items') List<MovieListItemDetail> items
});




}
/// @nodoc
class _$MovieListDetailsCopyWithImpl<$Res>
    implements $MovieListDetailsCopyWith<$Res> {
  _$MovieListDetailsCopyWithImpl(this._self, this._then);

  final MovieListDetails _self;
  final $Res Function(MovieListDetails) _then;

/// Create a copy of MovieListDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdBy = null,Object? description = null,Object? favoriteCount = null,Object? id = null,Object? iso6391 = null,Object? itemCount = null,Object? name = null,Object? items = null,}) {
  return _then(_self.copyWith(
createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,iso6391: null == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MovieListItemDetail>,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListDetails].
extension MovieListDetailsPatterns on MovieListDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieListDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieListDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieListDetails value)  $default,){
final _that = this;
switch (_that) {
case _MovieListDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieListDetails value)?  $default,){
final _that = this;
switch (_that) {
case _MovieListDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String createdBy, @HiveField(1)  String description, @HiveField(2)  int favoriteCount, @HiveField(3)  int id, @HiveField(4)  String iso6391, @HiveField(5)  String itemCount, @HiveField(6)  String name, @HiveField(7)@JsonKey(name: 'items')  List<MovieListItemDetail> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieListDetails() when $default != null:
return $default(_that.createdBy,_that.description,_that.favoriteCount,_that.id,_that.iso6391,_that.itemCount,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String createdBy, @HiveField(1)  String description, @HiveField(2)  int favoriteCount, @HiveField(3)  int id, @HiveField(4)  String iso6391, @HiveField(5)  String itemCount, @HiveField(6)  String name, @HiveField(7)@JsonKey(name: 'items')  List<MovieListItemDetail> items)  $default,) {final _that = this;
switch (_that) {
case _MovieListDetails():
return $default(_that.createdBy,_that.description,_that.favoriteCount,_that.id,_that.iso6391,_that.itemCount,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String createdBy, @HiveField(1)  String description, @HiveField(2)  int favoriteCount, @HiveField(3)  int id, @HiveField(4)  String iso6391, @HiveField(5)  String itemCount, @HiveField(6)  String name, @HiveField(7)@JsonKey(name: 'items')  List<MovieListItemDetail> items)?  $default,) {final _that = this;
switch (_that) {
case _MovieListDetails() when $default != null:
return $default(_that.createdBy,_that.description,_that.favoriteCount,_that.id,_that.iso6391,_that.itemCount,_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieListDetails implements MovieListDetails {
  const _MovieListDetails({@HiveField(0) required this.createdBy, @HiveField(1) required this.description, @HiveField(2) required this.favoriteCount, @HiveField(3) required this.id, @HiveField(4) required this.iso6391, @HiveField(5) required this.itemCount, @HiveField(6) required this.name, @HiveField(7)@JsonKey(name: 'items') required final  List<MovieListItemDetail> items}): _items = items;
  factory _MovieListDetails.fromJson(Map<String, dynamic> json) => _$MovieListDetailsFromJson(json);

@override@HiveField(0) final  String createdBy;
@override@HiveField(1) final  String description;
@override@HiveField(2) final  int favoriteCount;
@override@HiveField(3) final  int id;
@override@HiveField(4) final  String iso6391;
@override@HiveField(5) final  String itemCount;
@override@HiveField(6) final  String name;
 final  List<MovieListItemDetail> _items;
@override@HiveField(7)@JsonKey(name: 'items') List<MovieListItemDetail> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MovieListDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieListDetailsCopyWith<_MovieListDetails> get copyWith => __$MovieListDetailsCopyWithImpl<_MovieListDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieListDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieListDetails&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.description, description) || other.description == description)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.id, id) || other.id == id)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,createdBy,description,favoriteCount,id,iso6391,itemCount,name,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MovieListDetails(createdBy: $createdBy, description: $description, favoriteCount: $favoriteCount, id: $id, iso6391: $iso6391, itemCount: $itemCount, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$MovieListDetailsCopyWith<$Res> implements $MovieListDetailsCopyWith<$Res> {
  factory _$MovieListDetailsCopyWith(_MovieListDetails value, $Res Function(_MovieListDetails) _then) = __$MovieListDetailsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String createdBy,@HiveField(1) String description,@HiveField(2) int favoriteCount,@HiveField(3) int id,@HiveField(4) String iso6391,@HiveField(5) String itemCount,@HiveField(6) String name,@HiveField(7)@JsonKey(name: 'items') List<MovieListItemDetail> items
});




}
/// @nodoc
class __$MovieListDetailsCopyWithImpl<$Res>
    implements _$MovieListDetailsCopyWith<$Res> {
  __$MovieListDetailsCopyWithImpl(this._self, this._then);

  final _MovieListDetails _self;
  final $Res Function(_MovieListDetails) _then;

/// Create a copy of MovieListDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? createdBy = null,Object? description = null,Object? favoriteCount = null,Object? id = null,Object? iso6391 = null,Object? itemCount = null,Object? name = null,Object? items = null,}) {
  return _then(_MovieListDetails(
createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,iso6391: null == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MovieListItemDetail>,
  ));
}


}

// dart format on
