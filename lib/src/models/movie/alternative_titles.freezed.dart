// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alternative_titles.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlternativeTitle {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'iso_3166_1') String get iso31661;@HiveField(2) String get title;@HiveField(3) String? get type;
/// Create a copy of AlternativeTitle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlternativeTitleCopyWith<AlternativeTitle> get copyWith => _$AlternativeTitleCopyWithImpl<AlternativeTitle>(this as AlternativeTitle, _$identity);

  /// Serializes this AlternativeTitle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlternativeTitle&&(identical(other.id, id) || other.id == id)&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,iso31661,title,type);

@override
String toString() {
  return 'AlternativeTitle(id: $id, iso31661: $iso31661, title: $title, type: $type)';
}


}

/// @nodoc
abstract mixin class $AlternativeTitleCopyWith<$Res>  {
  factory $AlternativeTitleCopyWith(AlternativeTitle value, $Res Function(AlternativeTitle) _then) = _$AlternativeTitleCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'iso_3166_1') String iso31661,@HiveField(2) String title,@HiveField(3) String? type
});




}
/// @nodoc
class _$AlternativeTitleCopyWithImpl<$Res>
    implements $AlternativeTitleCopyWith<$Res> {
  _$AlternativeTitleCopyWithImpl(this._self, this._then);

  final AlternativeTitle _self;
  final $Res Function(AlternativeTitle) _then;

/// Create a copy of AlternativeTitle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? iso31661 = null,Object? title = null,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,iso31661: null == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlternativeTitle].
extension AlternativeTitlePatterns on AlternativeTitle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlternativeTitle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlternativeTitle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlternativeTitle value)  $default,){
final _that = this;
switch (_that) {
case _AlternativeTitle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlternativeTitle value)?  $default,){
final _that = this;
switch (_that) {
case _AlternativeTitle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'iso_3166_1')  String iso31661, @HiveField(2)  String title, @HiveField(3)  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlternativeTitle() when $default != null:
return $default(_that.id,_that.iso31661,_that.title,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'iso_3166_1')  String iso31661, @HiveField(2)  String title, @HiveField(3)  String? type)  $default,) {final _that = this;
switch (_that) {
case _AlternativeTitle():
return $default(_that.id,_that.iso31661,_that.title,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'iso_3166_1')  String iso31661, @HiveField(2)  String title, @HiveField(3)  String? type)?  $default,) {final _that = this;
switch (_that) {
case _AlternativeTitle() when $default != null:
return $default(_that.id,_that.iso31661,_that.title,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _AlternativeTitle implements AlternativeTitle {
  const _AlternativeTitle({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'iso_3166_1') required this.iso31661, @HiveField(2) required this.title, @HiveField(3) this.type});
  factory _AlternativeTitle.fromJson(Map<String, dynamic> json) => _$AlternativeTitleFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1)@JsonKey(name: 'iso_3166_1') final  String iso31661;
@override@HiveField(2) final  String title;
@override@HiveField(3) final  String? type;

/// Create a copy of AlternativeTitle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlternativeTitleCopyWith<_AlternativeTitle> get copyWith => __$AlternativeTitleCopyWithImpl<_AlternativeTitle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlternativeTitleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlternativeTitle&&(identical(other.id, id) || other.id == id)&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,iso31661,title,type);

@override
String toString() {
  return 'AlternativeTitle(id: $id, iso31661: $iso31661, title: $title, type: $type)';
}


}

/// @nodoc
abstract mixin class _$AlternativeTitleCopyWith<$Res> implements $AlternativeTitleCopyWith<$Res> {
  factory _$AlternativeTitleCopyWith(_AlternativeTitle value, $Res Function(_AlternativeTitle) _then) = __$AlternativeTitleCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'iso_3166_1') String iso31661,@HiveField(2) String title,@HiveField(3) String? type
});




}
/// @nodoc
class __$AlternativeTitleCopyWithImpl<$Res>
    implements _$AlternativeTitleCopyWith<$Res> {
  __$AlternativeTitleCopyWithImpl(this._self, this._then);

  final _AlternativeTitle _self;
  final $Res Function(_AlternativeTitle) _then;

/// Create a copy of AlternativeTitle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? iso31661 = null,Object? title = null,Object? type = freezed,}) {
  return _then(_AlternativeTitle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,iso31661: null == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AlternativeTitlesResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'titles') List<AlternativeTitle> get titles;
/// Create a copy of AlternativeTitlesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlternativeTitlesResponseCopyWith<AlternativeTitlesResponse> get copyWith => _$AlternativeTitlesResponseCopyWithImpl<AlternativeTitlesResponse>(this as AlternativeTitlesResponse, _$identity);

  /// Serializes this AlternativeTitlesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlternativeTitlesResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.titles, titles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(titles));

@override
String toString() {
  return 'AlternativeTitlesResponse(id: $id, titles: $titles)';
}


}

/// @nodoc
abstract mixin class $AlternativeTitlesResponseCopyWith<$Res>  {
  factory $AlternativeTitlesResponseCopyWith(AlternativeTitlesResponse value, $Res Function(AlternativeTitlesResponse) _then) = _$AlternativeTitlesResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'titles') List<AlternativeTitle> titles
});




}
/// @nodoc
class _$AlternativeTitlesResponseCopyWithImpl<$Res>
    implements $AlternativeTitlesResponseCopyWith<$Res> {
  _$AlternativeTitlesResponseCopyWithImpl(this._self, this._then);

  final AlternativeTitlesResponse _self;
  final $Res Function(AlternativeTitlesResponse) _then;

/// Create a copy of AlternativeTitlesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titles = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,titles: null == titles ? _self.titles : titles // ignore: cast_nullable_to_non_nullable
as List<AlternativeTitle>,
  ));
}

}


/// Adds pattern-matching-related methods to [AlternativeTitlesResponse].
extension AlternativeTitlesResponsePatterns on AlternativeTitlesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlternativeTitlesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlternativeTitlesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlternativeTitlesResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlternativeTitlesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlternativeTitlesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlternativeTitlesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'titles')  List<AlternativeTitle> titles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlternativeTitlesResponse() when $default != null:
return $default(_that.id,_that.titles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'titles')  List<AlternativeTitle> titles)  $default,) {final _that = this;
switch (_that) {
case _AlternativeTitlesResponse():
return $default(_that.id,_that.titles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'titles')  List<AlternativeTitle> titles)?  $default,) {final _that = this;
switch (_that) {
case _AlternativeTitlesResponse() when $default != null:
return $default(_that.id,_that.titles);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AlternativeTitlesResponse implements AlternativeTitlesResponse {
  const _AlternativeTitlesResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'titles') required final  List<AlternativeTitle> titles}): _titles = titles;
  factory _AlternativeTitlesResponse.fromJson(Map<String, dynamic> json) => _$AlternativeTitlesResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<AlternativeTitle> _titles;
@override@HiveField(1)@JsonKey(name: 'titles') List<AlternativeTitle> get titles {
  if (_titles is EqualUnmodifiableListView) return _titles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_titles);
}


/// Create a copy of AlternativeTitlesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlternativeTitlesResponseCopyWith<_AlternativeTitlesResponse> get copyWith => __$AlternativeTitlesResponseCopyWithImpl<_AlternativeTitlesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlternativeTitlesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlternativeTitlesResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._titles, _titles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_titles));

@override
String toString() {
  return 'AlternativeTitlesResponse(id: $id, titles: $titles)';
}


}

/// @nodoc
abstract mixin class _$AlternativeTitlesResponseCopyWith<$Res> implements $AlternativeTitlesResponseCopyWith<$Res> {
  factory _$AlternativeTitlesResponseCopyWith(_AlternativeTitlesResponse value, $Res Function(_AlternativeTitlesResponse) _then) = __$AlternativeTitlesResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'titles') List<AlternativeTitle> titles
});




}
/// @nodoc
class __$AlternativeTitlesResponseCopyWithImpl<$Res>
    implements _$AlternativeTitlesResponseCopyWith<$Res> {
  __$AlternativeTitlesResponseCopyWithImpl(this._self, this._then);

  final _AlternativeTitlesResponse _self;
  final $Res Function(_AlternativeTitlesResponse) _then;

/// Create a copy of AlternativeTitlesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titles = null,}) {
  return _then(_AlternativeTitlesResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,titles: null == titles ? _self._titles : titles // ignore: cast_nullable_to_non_nullable
as List<AlternativeTitle>,
  ));
}


}

// dart format on
