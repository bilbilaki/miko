// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieGenre {

@HiveField(0) int get id;@HiveField(1) String get name;
/// Create a copy of MovieGenre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieGenreCopyWith<MovieGenre> get copyWith => _$MovieGenreCopyWithImpl<MovieGenre>(this as MovieGenre, _$identity);

  /// Serializes this MovieGenre to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieGenre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MovieGenre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MovieGenreCopyWith<$Res>  {
  factory $MovieGenreCopyWith(MovieGenre value, $Res Function(MovieGenre) _then) = _$MovieGenreCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class _$MovieGenreCopyWithImpl<$Res>
    implements $MovieGenreCopyWith<$Res> {
  _$MovieGenreCopyWithImpl(this._self, this._then);

  final MovieGenre _self;
  final $Res Function(MovieGenre) _then;

/// Create a copy of MovieGenre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieGenre].
extension MovieGenrePatterns on MovieGenre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieGenre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieGenre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieGenre value)  $default,){
final _that = this;
switch (_that) {
case _MovieGenre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieGenre value)?  $default,){
final _that = this;
switch (_that) {
case _MovieGenre() when $default != null:
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
case _MovieGenre() when $default != null:
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
case _MovieGenre():
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
case _MovieGenre() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieGenre implements MovieGenre {
  const _MovieGenre({@HiveField(0) required this.id, @HiveField(1) required this.name});
  factory _MovieGenre.fromJson(Map<String, dynamic> json) => _$MovieGenreFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String name;

/// Create a copy of MovieGenre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieGenreCopyWith<_MovieGenre> get copyWith => __$MovieGenreCopyWithImpl<_MovieGenre>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieGenreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieGenre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MovieGenre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MovieGenreCopyWith<$Res> implements $MovieGenreCopyWith<$Res> {
  factory _$MovieGenreCopyWith(_MovieGenre value, $Res Function(_MovieGenre) _then) = __$MovieGenreCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class __$MovieGenreCopyWithImpl<$Res>
    implements _$MovieGenreCopyWith<$Res> {
  __$MovieGenreCopyWithImpl(this._self, this._then);

  final _MovieGenre _self;
  final $Res Function(_MovieGenre) _then;

/// Create a copy of MovieGenre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MovieGenre(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GenreListResponse {

@HiveField(0) List<MovieGenre> get genres;
/// Create a copy of GenreListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreListResponseCopyWith<GenreListResponse> get copyWith => _$GenreListResponseCopyWithImpl<GenreListResponse>(this as GenreListResponse, _$identity);

  /// Serializes this GenreListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreListResponse&&const DeepCollectionEquality().equals(other.genres, genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'GenreListResponse(genres: $genres)';
}


}

/// @nodoc
abstract mixin class $GenreListResponseCopyWith<$Res>  {
  factory $GenreListResponseCopyWith(GenreListResponse value, $Res Function(GenreListResponse) _then) = _$GenreListResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) List<MovieGenre> genres
});




}
/// @nodoc
class _$GenreListResponseCopyWithImpl<$Res>
    implements $GenreListResponseCopyWith<$Res> {
  _$GenreListResponseCopyWithImpl(this._self, this._then);

  final GenreListResponse _self;
  final $Res Function(GenreListResponse) _then;

/// Create a copy of GenreListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genres = null,}) {
  return _then(_self.copyWith(
genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<MovieGenre>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenreListResponse].
extension GenreListResponsePatterns on GenreListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenreListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenreListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenreListResponse value)  $default,){
final _that = this;
switch (_that) {
case _GenreListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenreListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GenreListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  List<MovieGenre> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenreListResponse() when $default != null:
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  List<MovieGenre> genres)  $default,) {final _that = this;
switch (_that) {
case _GenreListResponse():
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  List<MovieGenre> genres)?  $default,) {final _that = this;
switch (_that) {
case _GenreListResponse() when $default != null:
return $default(_that.genres);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GenreListResponse implements GenreListResponse {
  const _GenreListResponse({@HiveField(0) required final  List<MovieGenre> genres}): _genres = genres;
  factory _GenreListResponse.fromJson(Map<String, dynamic> json) => _$GenreListResponseFromJson(json);

 final  List<MovieGenre> _genres;
@override@HiveField(0) List<MovieGenre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of GenreListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreListResponseCopyWith<_GenreListResponse> get copyWith => __$GenreListResponseCopyWithImpl<_GenreListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreListResponse&&const DeepCollectionEquality().equals(other._genres, _genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'GenreListResponse(genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$GenreListResponseCopyWith<$Res> implements $GenreListResponseCopyWith<$Res> {
  factory _$GenreListResponseCopyWith(_GenreListResponse value, $Res Function(_GenreListResponse) _then) = __$GenreListResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) List<MovieGenre> genres
});




}
/// @nodoc
class __$GenreListResponseCopyWithImpl<$Res>
    implements _$GenreListResponseCopyWith<$Res> {
  __$GenreListResponseCopyWithImpl(this._self, this._then);

  final _GenreListResponse _self;
  final $Res Function(_GenreListResponse) _then;

/// Create a copy of GenreListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genres = null,}) {
  return _then(_GenreListResponse(
genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<MovieGenre>,
  ));
}


}

// dart format on
