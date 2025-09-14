// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_genre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvGenre {

@HiveField(0) int get id;@HiveField(1) String get name;
/// Create a copy of TvGenre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvGenreCopyWith<TvGenre> get copyWith => _$TvGenreCopyWithImpl<TvGenre>(this as TvGenre, _$identity);

  /// Serializes this TvGenre to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvGenre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'TvGenre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $TvGenreCopyWith<$Res>  {
  factory $TvGenreCopyWith(TvGenre value, $Res Function(TvGenre) _then) = _$TvGenreCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class _$TvGenreCopyWithImpl<$Res>
    implements $TvGenreCopyWith<$Res> {
  _$TvGenreCopyWithImpl(this._self, this._then);

  final TvGenre _self;
  final $Res Function(TvGenre) _then;

/// Create a copy of TvGenre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TvGenre].
extension TvGenrePatterns on TvGenre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvGenre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvGenre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvGenre value)  $default,){
final _that = this;
switch (_that) {
case _TvGenre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvGenre value)?  $default,){
final _that = this;
switch (_that) {
case _TvGenre() when $default != null:
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
case _TvGenre() when $default != null:
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
case _TvGenre():
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
case _TvGenre() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TvGenre implements TvGenre {
  const _TvGenre({@HiveField(0) required this.id, @HiveField(1) required this.name});
  factory _TvGenre.fromJson(Map<String, dynamic> json) => _$TvGenreFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String name;

/// Create a copy of TvGenre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvGenreCopyWith<_TvGenre> get copyWith => __$TvGenreCopyWithImpl<_TvGenre>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvGenreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvGenre&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'TvGenre(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TvGenreCopyWith<$Res> implements $TvGenreCopyWith<$Res> {
  factory _$TvGenreCopyWith(_TvGenre value, $Res Function(_TvGenre) _then) = __$TvGenreCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class __$TvGenreCopyWithImpl<$Res>
    implements _$TvGenreCopyWith<$Res> {
  __$TvGenreCopyWithImpl(this._self, this._then);

  final _TvGenre _self;
  final $Res Function(_TvGenre) _then;

/// Create a copy of TvGenre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_TvGenre(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
