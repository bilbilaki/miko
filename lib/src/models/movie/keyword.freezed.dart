// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyword.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieKeyword {

@HiveField(0) int get id;@HiveField(1) String get name;
/// Create a copy of MovieKeyword
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieKeywordCopyWith<MovieKeyword> get copyWith => _$MovieKeywordCopyWithImpl<MovieKeyword>(this as MovieKeyword, _$identity);

  /// Serializes this MovieKeyword to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieKeyword&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MovieKeyword(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MovieKeywordCopyWith<$Res>  {
  factory $MovieKeywordCopyWith(MovieKeyword value, $Res Function(MovieKeyword) _then) = _$MovieKeywordCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class _$MovieKeywordCopyWithImpl<$Res>
    implements $MovieKeywordCopyWith<$Res> {
  _$MovieKeywordCopyWithImpl(this._self, this._then);

  final MovieKeyword _self;
  final $Res Function(MovieKeyword) _then;

/// Create a copy of MovieKeyword
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieKeyword].
extension MovieKeywordPatterns on MovieKeyword {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieKeyword value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieKeyword() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieKeyword value)  $default,){
final _that = this;
switch (_that) {
case _MovieKeyword():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieKeyword value)?  $default,){
final _that = this;
switch (_that) {
case _MovieKeyword() when $default != null:
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
case _MovieKeyword() when $default != null:
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
case _MovieKeyword():
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
case _MovieKeyword() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieKeyword implements MovieKeyword {
  const _MovieKeyword({@HiveField(0) required this.id, @HiveField(1) required this.name});
  factory _MovieKeyword.fromJson(Map<String, dynamic> json) => _$MovieKeywordFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String name;

/// Create a copy of MovieKeyword
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieKeywordCopyWith<_MovieKeyword> get copyWith => __$MovieKeywordCopyWithImpl<_MovieKeyword>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieKeywordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieKeyword&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MovieKeyword(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MovieKeywordCopyWith<$Res> implements $MovieKeywordCopyWith<$Res> {
  factory _$MovieKeywordCopyWith(_MovieKeyword value, $Res Function(_MovieKeyword) _then) = __$MovieKeywordCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name
});




}
/// @nodoc
class __$MovieKeywordCopyWithImpl<$Res>
    implements _$MovieKeywordCopyWith<$Res> {
  __$MovieKeywordCopyWithImpl(this._self, this._then);

  final _MovieKeyword _self;
  final $Res Function(_MovieKeyword) _then;

/// Create a copy of MovieKeyword
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MovieKeyword(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MovieKeywordsResponse {

@HiveField(0) int get id;@HiveField(1) List<MovieKeyword> get keywords;
/// Create a copy of MovieKeywordsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieKeywordsResponseCopyWith<MovieKeywordsResponse> get copyWith => _$MovieKeywordsResponseCopyWithImpl<MovieKeywordsResponse>(this as MovieKeywordsResponse, _$identity);

  /// Serializes this MovieKeywordsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieKeywordsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.keywords, keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(keywords));

@override
String toString() {
  return 'MovieKeywordsResponse(id: $id, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class $MovieKeywordsResponseCopyWith<$Res>  {
  factory $MovieKeywordsResponseCopyWith(MovieKeywordsResponse value, $Res Function(MovieKeywordsResponse) _then) = _$MovieKeywordsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) List<MovieKeyword> keywords
});




}
/// @nodoc
class _$MovieKeywordsResponseCopyWithImpl<$Res>
    implements $MovieKeywordsResponseCopyWith<$Res> {
  _$MovieKeywordsResponseCopyWithImpl(this._self, this._then);

  final MovieKeywordsResponse _self;
  final $Res Function(MovieKeywordsResponse) _then;

/// Create a copy of MovieKeywordsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? keywords = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<MovieKeyword>,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieKeywordsResponse].
extension MovieKeywordsResponsePatterns on MovieKeywordsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieKeywordsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieKeywordsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieKeywordsResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovieKeywordsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieKeywordsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovieKeywordsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  List<MovieKeyword> keywords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieKeywordsResponse() when $default != null:
return $default(_that.id,_that.keywords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  List<MovieKeyword> keywords)  $default,) {final _that = this;
switch (_that) {
case _MovieKeywordsResponse():
return $default(_that.id,_that.keywords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  List<MovieKeyword> keywords)?  $default,) {final _that = this;
switch (_that) {
case _MovieKeywordsResponse() when $default != null:
return $default(_that.id,_that.keywords);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieKeywordsResponse implements MovieKeywordsResponse {
  const _MovieKeywordsResponse({@HiveField(0) required this.id, @HiveField(1) required final  List<MovieKeyword> keywords}): _keywords = keywords;
  factory _MovieKeywordsResponse.fromJson(Map<String, dynamic> json) => _$MovieKeywordsResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<MovieKeyword> _keywords;
@override@HiveField(1) List<MovieKeyword> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}


/// Create a copy of MovieKeywordsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieKeywordsResponseCopyWith<_MovieKeywordsResponse> get copyWith => __$MovieKeywordsResponseCopyWithImpl<_MovieKeywordsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieKeywordsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieKeywordsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._keywords, _keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_keywords));

@override
String toString() {
  return 'MovieKeywordsResponse(id: $id, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class _$MovieKeywordsResponseCopyWith<$Res> implements $MovieKeywordsResponseCopyWith<$Res> {
  factory _$MovieKeywordsResponseCopyWith(_MovieKeywordsResponse value, $Res Function(_MovieKeywordsResponse) _then) = __$MovieKeywordsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) List<MovieKeyword> keywords
});




}
/// @nodoc
class __$MovieKeywordsResponseCopyWithImpl<$Res>
    implements _$MovieKeywordsResponseCopyWith<$Res> {
  __$MovieKeywordsResponseCopyWithImpl(this._self, this._then);

  final _MovieKeywordsResponse _self;
  final $Res Function(_MovieKeywordsResponse) _then;

/// Create a copy of MovieKeywordsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? keywords = null,}) {
  return _then(_MovieKeywordsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<MovieKeyword>,
  ));
}


}

// dart format on
