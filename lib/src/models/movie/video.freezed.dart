// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieVideo {

@HiveField(0) String get id;@HiveField(1)@JsonKey(name: 'iso_639_1') String? get iso6391;@HiveField(2)@JsonKey(name: 'iso_3166_1') String? get iso31661;@HiveField(3) String get key;@HiveField(4) String get name;@HiveField(5) String get site;@HiveField(6) int? get size;@HiveField(7) String get type;@HiveField(8) bool? get official;@HiveField(9)@JsonKey(name: 'published_at') String? get publishedAt;
/// Create a copy of MovieVideo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieVideoCopyWith<MovieVideo> get copyWith => _$MovieVideoCopyWithImpl<MovieVideo>(this as MovieVideo, _$identity);

  /// Serializes this MovieVideo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieVideo&&(identical(other.id, id) || other.id == id)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.site, site) || other.site == site)&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type)&&(identical(other.official, official) || other.official == official)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,iso6391,iso31661,key,name,site,size,type,official,publishedAt);

@override
String toString() {
  return 'MovieVideo(id: $id, iso6391: $iso6391, iso31661: $iso31661, key: $key, name: $name, site: $site, size: $size, type: $type, official: $official, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $MovieVideoCopyWith<$Res>  {
  factory $MovieVideoCopyWith(MovieVideo value, $Res Function(MovieVideo) _then) = _$MovieVideoCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(2)@JsonKey(name: 'iso_3166_1') String? iso31661,@HiveField(3) String key,@HiveField(4) String name,@HiveField(5) String site,@HiveField(6) int? size,@HiveField(7) String type,@HiveField(8) bool? official,@HiveField(9)@JsonKey(name: 'published_at') String? publishedAt
});




}
/// @nodoc
class _$MovieVideoCopyWithImpl<$Res>
    implements $MovieVideoCopyWith<$Res> {
  _$MovieVideoCopyWithImpl(this._self, this._then);

  final MovieVideo _self;
  final $Res Function(MovieVideo) _then;

/// Create a copy of MovieVideo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? iso6391 = freezed,Object? iso31661 = freezed,Object? key = null,Object? name = null,Object? site = null,Object? size = freezed,Object? type = null,Object? official = freezed,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,iso31661: freezed == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String?,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,official: freezed == official ? _self.official : official // ignore: cast_nullable_to_non_nullable
as bool?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieVideo].
extension MovieVideoPatterns on MovieVideo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieVideo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieVideo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieVideo value)  $default,){
final _that = this;
switch (_that) {
case _MovieVideo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieVideo value)?  $default,){
final _that = this;
switch (_that) {
case _MovieVideo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(2)@JsonKey(name: 'iso_3166_1')  String? iso31661, @HiveField(3)  String key, @HiveField(4)  String name, @HiveField(5)  String site, @HiveField(6)  int? size, @HiveField(7)  String type, @HiveField(8)  bool? official, @HiveField(9)@JsonKey(name: 'published_at')  String? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieVideo() when $default != null:
return $default(_that.id,_that.iso6391,_that.iso31661,_that.key,_that.name,_that.site,_that.size,_that.type,_that.official,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(2)@JsonKey(name: 'iso_3166_1')  String? iso31661, @HiveField(3)  String key, @HiveField(4)  String name, @HiveField(5)  String site, @HiveField(6)  int? size, @HiveField(7)  String type, @HiveField(8)  bool? official, @HiveField(9)@JsonKey(name: 'published_at')  String? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _MovieVideo():
return $default(_that.id,_that.iso6391,_that.iso31661,_that.key,_that.name,_that.site,_that.size,_that.type,_that.official,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(2)@JsonKey(name: 'iso_3166_1')  String? iso31661, @HiveField(3)  String key, @HiveField(4)  String name, @HiveField(5)  String site, @HiveField(6)  int? size, @HiveField(7)  String type, @HiveField(8)  bool? official, @HiveField(9)@JsonKey(name: 'published_at')  String? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _MovieVideo() when $default != null:
return $default(_that.id,_that.iso6391,_that.iso31661,_that.key,_that.name,_that.site,_that.size,_that.type,_that.official,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieVideo implements MovieVideo {
  const _MovieVideo({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'iso_639_1') this.iso6391, @HiveField(2)@JsonKey(name: 'iso_3166_1') this.iso31661, @HiveField(3) required this.key, @HiveField(4) required this.name, @HiveField(5) required this.site, @HiveField(6) this.size, @HiveField(7) required this.type, @HiveField(8) this.official, @HiveField(9)@JsonKey(name: 'published_at') this.publishedAt});
  factory _MovieVideo.fromJson(Map<String, dynamic> json) => _$MovieVideoFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1)@JsonKey(name: 'iso_639_1') final  String? iso6391;
@override@HiveField(2)@JsonKey(name: 'iso_3166_1') final  String? iso31661;
@override@HiveField(3) final  String key;
@override@HiveField(4) final  String name;
@override@HiveField(5) final  String site;
@override@HiveField(6) final  int? size;
@override@HiveField(7) final  String type;
@override@HiveField(8) final  bool? official;
@override@HiveField(9)@JsonKey(name: 'published_at') final  String? publishedAt;

/// Create a copy of MovieVideo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieVideoCopyWith<_MovieVideo> get copyWith => __$MovieVideoCopyWithImpl<_MovieVideo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieVideoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieVideo&&(identical(other.id, id) || other.id == id)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.site, site) || other.site == site)&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type)&&(identical(other.official, official) || other.official == official)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,iso6391,iso31661,key,name,site,size,type,official,publishedAt);

@override
String toString() {
  return 'MovieVideo(id: $id, iso6391: $iso6391, iso31661: $iso31661, key: $key, name: $name, site: $site, size: $size, type: $type, official: $official, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$MovieVideoCopyWith<$Res> implements $MovieVideoCopyWith<$Res> {
  factory _$MovieVideoCopyWith(_MovieVideo value, $Res Function(_MovieVideo) _then) = __$MovieVideoCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(2)@JsonKey(name: 'iso_3166_1') String? iso31661,@HiveField(3) String key,@HiveField(4) String name,@HiveField(5) String site,@HiveField(6) int? size,@HiveField(7) String type,@HiveField(8) bool? official,@HiveField(9)@JsonKey(name: 'published_at') String? publishedAt
});




}
/// @nodoc
class __$MovieVideoCopyWithImpl<$Res>
    implements _$MovieVideoCopyWith<$Res> {
  __$MovieVideoCopyWithImpl(this._self, this._then);

  final _MovieVideo _self;
  final $Res Function(_MovieVideo) _then;

/// Create a copy of MovieVideo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? iso6391 = freezed,Object? iso31661 = freezed,Object? key = null,Object? name = null,Object? site = null,Object? size = freezed,Object? type = null,Object? official = freezed,Object? publishedAt = freezed,}) {
  return _then(_MovieVideo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,iso31661: freezed == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String?,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,official: freezed == official ? _self.official : official // ignore: cast_nullable_to_non_nullable
as bool?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MovieVideosResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'results') List<MovieVideo> get results;
/// Create a copy of MovieVideosResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieVideosResponseCopyWith<MovieVideosResponse> get copyWith => _$MovieVideosResponseCopyWithImpl<MovieVideosResponse>(this as MovieVideosResponse, _$identity);

  /// Serializes this MovieVideosResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieVideosResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'MovieVideosResponse(id: $id, results: $results)';
}


}

/// @nodoc
abstract mixin class $MovieVideosResponseCopyWith<$Res>  {
  factory $MovieVideosResponseCopyWith(MovieVideosResponse value, $Res Function(MovieVideosResponse) _then) = _$MovieVideosResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'results') List<MovieVideo> results
});




}
/// @nodoc
class _$MovieVideosResponseCopyWithImpl<$Res>
    implements $MovieVideosResponseCopyWith<$Res> {
  _$MovieVideosResponseCopyWithImpl(this._self, this._then);

  final MovieVideosResponse _self;
  final $Res Function(MovieVideosResponse) _then;

/// Create a copy of MovieVideosResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? results = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MovieVideo>,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieVideosResponse].
extension MovieVideosResponsePatterns on MovieVideosResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieVideosResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieVideosResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieVideosResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovieVideosResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieVideosResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovieVideosResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  List<MovieVideo> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieVideosResponse() when $default != null:
return $default(_that.id,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  List<MovieVideo> results)  $default,) {final _that = this;
switch (_that) {
case _MovieVideosResponse():
return $default(_that.id,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  List<MovieVideo> results)?  $default,) {final _that = this;
switch (_that) {
case _MovieVideosResponse() when $default != null:
return $default(_that.id,_that.results);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieVideosResponse implements MovieVideosResponse {
  const _MovieVideosResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'results') required final  List<MovieVideo> results}): _results = results;
  factory _MovieVideosResponse.fromJson(Map<String, dynamic> json) => _$MovieVideosResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<MovieVideo> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<MovieVideo> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of MovieVideosResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieVideosResponseCopyWith<_MovieVideosResponse> get copyWith => __$MovieVideosResponseCopyWithImpl<_MovieVideosResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieVideosResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieVideosResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'MovieVideosResponse(id: $id, results: $results)';
}


}

/// @nodoc
abstract mixin class _$MovieVideosResponseCopyWith<$Res> implements $MovieVideosResponseCopyWith<$Res> {
  factory _$MovieVideosResponseCopyWith(_MovieVideosResponse value, $Res Function(_MovieVideosResponse) _then) = __$MovieVideosResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'results') List<MovieVideo> results
});




}
/// @nodoc
class __$MovieVideosResponseCopyWithImpl<$Res>
    implements _$MovieVideosResponseCopyWith<$Res> {
  __$MovieVideosResponseCopyWithImpl(this._self, this._then);

  final _MovieVideosResponse _self;
  final $Res Function(_MovieVideosResponse) _then;

/// Create a copy of MovieVideosResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? results = null,}) {
  return _then(_MovieVideosResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MovieVideo>,
  ));
}


}

// dart format on
