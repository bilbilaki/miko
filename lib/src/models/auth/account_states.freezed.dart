// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountStates {

@HiveField(0) int get id;@HiveField(1) bool get favorite;@HiveField(2) bool get watchlist;// rated can be either false or an object { value: x }
// use Object? to avoid type-checking issues in code generators
@HiveField(3) Object? get rated;@HiveField(4)@JsonKey(name: 'media_type') String? get mediaType;
/// Create a copy of AccountStates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountStatesCopyWith<AccountStates> get copyWith => _$AccountStatesCopyWithImpl<AccountStates>(this as AccountStates, _$identity);

  /// Serializes this AccountStates to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountStates&&(identical(other.id, id) || other.id == id)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.watchlist, watchlist) || other.watchlist == watchlist)&&const DeepCollectionEquality().equals(other.rated, rated)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,favorite,watchlist,const DeepCollectionEquality().hash(rated),mediaType);

@override
String toString() {
  return 'AccountStates(id: $id, favorite: $favorite, watchlist: $watchlist, rated: $rated, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $AccountStatesCopyWith<$Res>  {
  factory $AccountStatesCopyWith(AccountStates value, $Res Function(AccountStates) _then) = _$AccountStatesCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) bool favorite,@HiveField(2) bool watchlist,@HiveField(3) Object? rated,@HiveField(4)@JsonKey(name: 'media_type') String? mediaType
});




}
/// @nodoc
class _$AccountStatesCopyWithImpl<$Res>
    implements $AccountStatesCopyWith<$Res> {
  _$AccountStatesCopyWithImpl(this._self, this._then);

  final AccountStates _self;
  final $Res Function(AccountStates) _then;

/// Create a copy of AccountStates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? favorite = null,Object? watchlist = null,Object? rated = freezed,Object? mediaType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,watchlist: null == watchlist ? _self.watchlist : watchlist // ignore: cast_nullable_to_non_nullable
as bool,rated: freezed == rated ? _self.rated : rated ,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountStates].
extension AccountStatesPatterns on AccountStates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountStates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountStates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountStates value)  $default,){
final _that = this;
switch (_that) {
case _AccountStates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountStates value)?  $default,){
final _that = this;
switch (_that) {
case _AccountStates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  bool favorite, @HiveField(2)  bool watchlist, @HiveField(3)  Object? rated, @HiveField(4)@JsonKey(name: 'media_type')  String? mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountStates() when $default != null:
return $default(_that.id,_that.favorite,_that.watchlist,_that.rated,_that.mediaType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  bool favorite, @HiveField(2)  bool watchlist, @HiveField(3)  Object? rated, @HiveField(4)@JsonKey(name: 'media_type')  String? mediaType)  $default,) {final _that = this;
switch (_that) {
case _AccountStates():
return $default(_that.id,_that.favorite,_that.watchlist,_that.rated,_that.mediaType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  bool favorite, @HiveField(2)  bool watchlist, @HiveField(3)  Object? rated, @HiveField(4)@JsonKey(name: 'media_type')  String? mediaType)?  $default,) {final _that = this;
switch (_that) {
case _AccountStates() when $default != null:
return $default(_that.id,_that.favorite,_that.watchlist,_that.rated,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _AccountStates implements AccountStates {
  const _AccountStates({@HiveField(0) required this.id, @HiveField(1) required this.favorite, @HiveField(2) required this.watchlist, @HiveField(3) this.rated, @HiveField(4)@JsonKey(name: 'media_type') this.mediaType});
  factory _AccountStates.fromJson(Map<String, dynamic> json) => _$AccountStatesFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  bool favorite;
@override@HiveField(2) final  bool watchlist;
// rated can be either false or an object { value: x }
// use Object? to avoid type-checking issues in code generators
@override@HiveField(3) final  Object? rated;
@override@HiveField(4)@JsonKey(name: 'media_type') final  String? mediaType;

/// Create a copy of AccountStates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountStatesCopyWith<_AccountStates> get copyWith => __$AccountStatesCopyWithImpl<_AccountStates>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountStatesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountStates&&(identical(other.id, id) || other.id == id)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.watchlist, watchlist) || other.watchlist == watchlist)&&const DeepCollectionEquality().equals(other.rated, rated)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,favorite,watchlist,const DeepCollectionEquality().hash(rated),mediaType);

@override
String toString() {
  return 'AccountStates(id: $id, favorite: $favorite, watchlist: $watchlist, rated: $rated, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$AccountStatesCopyWith<$Res> implements $AccountStatesCopyWith<$Res> {
  factory _$AccountStatesCopyWith(_AccountStates value, $Res Function(_AccountStates) _then) = __$AccountStatesCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) bool favorite,@HiveField(2) bool watchlist,@HiveField(3) Object? rated,@HiveField(4)@JsonKey(name: 'media_type') String? mediaType
});




}
/// @nodoc
class __$AccountStatesCopyWithImpl<$Res>
    implements _$AccountStatesCopyWith<$Res> {
  __$AccountStatesCopyWithImpl(this._self, this._then);

  final _AccountStates _self;
  final $Res Function(_AccountStates) _then;

/// Create a copy of AccountStates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? favorite = null,Object? watchlist = null,Object? rated = freezed,Object? mediaType = freezed,}) {
  return _then(_AccountStates(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,watchlist: null == watchlist ? _self.watchlist : watchlist // ignore: cast_nullable_to_non_nullable
as bool,rated: freezed == rated ? _self.rated : rated ,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
