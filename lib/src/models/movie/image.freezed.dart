// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieImage {

@HiveField(0)@JsonKey(name: 'file_path') String get filePath;@HiveField(1) int get width;@HiveField(2) int get height;@HiveField(3)@JsonKey(name: 'iso_639_1') String? get iso6391;@HiveField(4)@JsonKey(name: 'aspect_ratio') double get aspectRatio;@HiveField(5)@JsonKey(name: 'vote_average') double? get voteAverage;@HiveField(6)@JsonKey(name: 'vote_count') int? get voteCount;
/// Create a copy of MovieImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieImageCopyWith<MovieImage> get copyWith => _$MovieImageCopyWithImpl<MovieImage>(this as MovieImage, _$identity);

  /// Serializes this MovieImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieImage&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filePath,width,height,iso6391,aspectRatio,voteAverage,voteCount);

@override
String toString() {
  return 'MovieImage(filePath: $filePath, width: $width, height: $height, iso6391: $iso6391, aspectRatio: $aspectRatio, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class $MovieImageCopyWith<$Res>  {
  factory $MovieImageCopyWith(MovieImage value, $Res Function(MovieImage) _then) = _$MovieImageCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'file_path') String filePath,@HiveField(1) int width,@HiveField(2) int height,@HiveField(3)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(4)@JsonKey(name: 'aspect_ratio') double aspectRatio,@HiveField(5)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(6)@JsonKey(name: 'vote_count') int? voteCount
});




}
/// @nodoc
class _$MovieImageCopyWithImpl<$Res>
    implements $MovieImageCopyWith<$Res> {
  _$MovieImageCopyWithImpl(this._self, this._then);

  final MovieImage _self;
  final $Res Function(MovieImage) _then;

/// Create a copy of MovieImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filePath = null,Object? width = null,Object? height = null,Object? iso6391 = freezed,Object? aspectRatio = null,Object? voteAverage = freezed,Object? voteCount = freezed,}) {
  return _then(_self.copyWith(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieImage].
extension MovieImagePatterns on MovieImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieImage value)  $default,){
final _that = this;
switch (_that) {
case _MovieImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieImage value)?  $default,){
final _that = this;
switch (_that) {
case _MovieImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'file_path')  String filePath, @HiveField(1)  int width, @HiveField(2)  int height, @HiveField(3)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(4)@JsonKey(name: 'aspect_ratio')  double aspectRatio, @HiveField(5)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(6)@JsonKey(name: 'vote_count')  int? voteCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieImage() when $default != null:
return $default(_that.filePath,_that.width,_that.height,_that.iso6391,_that.aspectRatio,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'file_path')  String filePath, @HiveField(1)  int width, @HiveField(2)  int height, @HiveField(3)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(4)@JsonKey(name: 'aspect_ratio')  double aspectRatio, @HiveField(5)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(6)@JsonKey(name: 'vote_count')  int? voteCount)  $default,) {final _that = this;
switch (_that) {
case _MovieImage():
return $default(_that.filePath,_that.width,_that.height,_that.iso6391,_that.aspectRatio,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'file_path')  String filePath, @HiveField(1)  int width, @HiveField(2)  int height, @HiveField(3)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(4)@JsonKey(name: 'aspect_ratio')  double aspectRatio, @HiveField(5)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(6)@JsonKey(name: 'vote_count')  int? voteCount)?  $default,) {final _that = this;
switch (_that) {
case _MovieImage() when $default != null:
return $default(_that.filePath,_that.width,_that.height,_that.iso6391,_that.aspectRatio,_that.voteAverage,_that.voteCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieImage implements MovieImage {
  const _MovieImage({@HiveField(0)@JsonKey(name: 'file_path') required this.filePath, @HiveField(1) required this.width, @HiveField(2) required this.height, @HiveField(3)@JsonKey(name: 'iso_639_1') this.iso6391, @HiveField(4)@JsonKey(name: 'aspect_ratio') required this.aspectRatio, @HiveField(5)@JsonKey(name: 'vote_average') this.voteAverage, @HiveField(6)@JsonKey(name: 'vote_count') this.voteCount});
  factory _MovieImage.fromJson(Map<String, dynamic> json) => _$MovieImageFromJson(json);

@override@HiveField(0)@JsonKey(name: 'file_path') final  String filePath;
@override@HiveField(1) final  int width;
@override@HiveField(2) final  int height;
@override@HiveField(3)@JsonKey(name: 'iso_639_1') final  String? iso6391;
@override@HiveField(4)@JsonKey(name: 'aspect_ratio') final  double aspectRatio;
@override@HiveField(5)@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@HiveField(6)@JsonKey(name: 'vote_count') final  int? voteCount;

/// Create a copy of MovieImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieImageCopyWith<_MovieImage> get copyWith => __$MovieImageCopyWithImpl<_MovieImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieImage&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filePath,width,height,iso6391,aspectRatio,voteAverage,voteCount);

@override
String toString() {
  return 'MovieImage(filePath: $filePath, width: $width, height: $height, iso6391: $iso6391, aspectRatio: $aspectRatio, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class _$MovieImageCopyWith<$Res> implements $MovieImageCopyWith<$Res> {
  factory _$MovieImageCopyWith(_MovieImage value, $Res Function(_MovieImage) _then) = __$MovieImageCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'file_path') String filePath,@HiveField(1) int width,@HiveField(2) int height,@HiveField(3)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(4)@JsonKey(name: 'aspect_ratio') double aspectRatio,@HiveField(5)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(6)@JsonKey(name: 'vote_count') int? voteCount
});




}
/// @nodoc
class __$MovieImageCopyWithImpl<$Res>
    implements _$MovieImageCopyWith<$Res> {
  __$MovieImageCopyWithImpl(this._self, this._then);

  final _MovieImage _self;
  final $Res Function(_MovieImage) _then;

/// Create a copy of MovieImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filePath = null,Object? width = null,Object? height = null,Object? iso6391 = freezed,Object? aspectRatio = null,Object? voteAverage = freezed,Object? voteCount = freezed,}) {
  return _then(_MovieImage(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MovieImagesResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'backdrops') List<MovieImage> get backdrops;@HiveField(2)@JsonKey(name: 'posters') List<MovieImage> get posters;
/// Create a copy of MovieImagesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieImagesResponseCopyWith<MovieImagesResponse> get copyWith => _$MovieImagesResponseCopyWithImpl<MovieImagesResponse>(this as MovieImagesResponse, _$identity);

  /// Serializes this MovieImagesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieImagesResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.backdrops, backdrops)&&const DeepCollectionEquality().equals(other.posters, posters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(backdrops),const DeepCollectionEquality().hash(posters));

@override
String toString() {
  return 'MovieImagesResponse(id: $id, backdrops: $backdrops, posters: $posters)';
}


}

/// @nodoc
abstract mixin class $MovieImagesResponseCopyWith<$Res>  {
  factory $MovieImagesResponseCopyWith(MovieImagesResponse value, $Res Function(MovieImagesResponse) _then) = _$MovieImagesResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'backdrops') List<MovieImage> backdrops,@HiveField(2)@JsonKey(name: 'posters') List<MovieImage> posters
});




}
/// @nodoc
class _$MovieImagesResponseCopyWithImpl<$Res>
    implements $MovieImagesResponseCopyWith<$Res> {
  _$MovieImagesResponseCopyWithImpl(this._self, this._then);

  final MovieImagesResponse _self;
  final $Res Function(MovieImagesResponse) _then;

/// Create a copy of MovieImagesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? backdrops = null,Object? posters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,backdrops: null == backdrops ? _self.backdrops : backdrops // ignore: cast_nullable_to_non_nullable
as List<MovieImage>,posters: null == posters ? _self.posters : posters // ignore: cast_nullable_to_non_nullable
as List<MovieImage>,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieImagesResponse].
extension MovieImagesResponsePatterns on MovieImagesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieImagesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieImagesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieImagesResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovieImagesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieImagesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovieImagesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'backdrops')  List<MovieImage> backdrops, @HiveField(2)@JsonKey(name: 'posters')  List<MovieImage> posters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieImagesResponse() when $default != null:
return $default(_that.id,_that.backdrops,_that.posters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'backdrops')  List<MovieImage> backdrops, @HiveField(2)@JsonKey(name: 'posters')  List<MovieImage> posters)  $default,) {final _that = this;
switch (_that) {
case _MovieImagesResponse():
return $default(_that.id,_that.backdrops,_that.posters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'backdrops')  List<MovieImage> backdrops, @HiveField(2)@JsonKey(name: 'posters')  List<MovieImage> posters)?  $default,) {final _that = this;
switch (_that) {
case _MovieImagesResponse() when $default != null:
return $default(_that.id,_that.backdrops,_that.posters);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieImagesResponse implements MovieImagesResponse {
  const _MovieImagesResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'backdrops') required final  List<MovieImage> backdrops, @HiveField(2)@JsonKey(name: 'posters') required final  List<MovieImage> posters}): _backdrops = backdrops,_posters = posters;
  factory _MovieImagesResponse.fromJson(Map<String, dynamic> json) => _$MovieImagesResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<MovieImage> _backdrops;
@override@HiveField(1)@JsonKey(name: 'backdrops') List<MovieImage> get backdrops {
  if (_backdrops is EqualUnmodifiableListView) return _backdrops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backdrops);
}

 final  List<MovieImage> _posters;
@override@HiveField(2)@JsonKey(name: 'posters') List<MovieImage> get posters {
  if (_posters is EqualUnmodifiableListView) return _posters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posters);
}


/// Create a copy of MovieImagesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieImagesResponseCopyWith<_MovieImagesResponse> get copyWith => __$MovieImagesResponseCopyWithImpl<_MovieImagesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieImagesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieImagesResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._backdrops, _backdrops)&&const DeepCollectionEquality().equals(other._posters, _posters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_backdrops),const DeepCollectionEquality().hash(_posters));

@override
String toString() {
  return 'MovieImagesResponse(id: $id, backdrops: $backdrops, posters: $posters)';
}


}

/// @nodoc
abstract mixin class _$MovieImagesResponseCopyWith<$Res> implements $MovieImagesResponseCopyWith<$Res> {
  factory _$MovieImagesResponseCopyWith(_MovieImagesResponse value, $Res Function(_MovieImagesResponse) _then) = __$MovieImagesResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'backdrops') List<MovieImage> backdrops,@HiveField(2)@JsonKey(name: 'posters') List<MovieImage> posters
});




}
/// @nodoc
class __$MovieImagesResponseCopyWithImpl<$Res>
    implements _$MovieImagesResponseCopyWith<$Res> {
  __$MovieImagesResponseCopyWithImpl(this._self, this._then);

  final _MovieImagesResponse _self;
  final $Res Function(_MovieImagesResponse) _then;

/// Create a copy of MovieImagesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? backdrops = null,Object? posters = null,}) {
  return _then(_MovieImagesResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,backdrops: null == backdrops ? _self._backdrops : backdrops // ignore: cast_nullable_to_non_nullable
as List<MovieImage>,posters: null == posters ? _self._posters : posters // ignore: cast_nullable_to_non_nullable
as List<MovieImage>,
  ));
}


}

// dart format on
