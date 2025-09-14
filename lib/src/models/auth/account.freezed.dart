// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountDetails {

@HiveField(0) int get id;@HiveField(1) String? get name;@HiveField(2) String get username;@HiveField(3)@JsonKey(name: 'include_adult') bool? get includeAdult;@HiveField(4)@JsonKey(name: 'iso_639_1') String? get iso6391;@HiveField(5)@JsonKey(name: 'iso_3166_1') String? get iso31661;
/// Create a copy of AccountDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountDetailsCopyWith<AccountDetails> get copyWith => _$AccountDetailsCopyWithImpl<AccountDetails>(this as AccountDetails, _$identity);

  /// Serializes this AccountDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.username, username) || other.username == username)&&(identical(other.includeAdult, includeAdult) || other.includeAdult == includeAdult)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,username,includeAdult,iso6391,iso31661);

@override
String toString() {
  return 'AccountDetails(id: $id, name: $name, username: $username, includeAdult: $includeAdult, iso6391: $iso6391, iso31661: $iso31661)';
}


}

/// @nodoc
abstract mixin class $AccountDetailsCopyWith<$Res>  {
  factory $AccountDetailsCopyWith(AccountDetails value, $Res Function(AccountDetails) _then) = _$AccountDetailsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String? name,@HiveField(2) String username,@HiveField(3)@JsonKey(name: 'include_adult') bool? includeAdult,@HiveField(4)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(5)@JsonKey(name: 'iso_3166_1') String? iso31661
});




}
/// @nodoc
class _$AccountDetailsCopyWithImpl<$Res>
    implements $AccountDetailsCopyWith<$Res> {
  _$AccountDetailsCopyWithImpl(this._self, this._then);

  final AccountDetails _self;
  final $Res Function(AccountDetails) _then;

/// Create a copy of AccountDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? username = null,Object? includeAdult = freezed,Object? iso6391 = freezed,Object? iso31661 = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,includeAdult: freezed == includeAdult ? _self.includeAdult : includeAdult // ignore: cast_nullable_to_non_nullable
as bool?,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,iso31661: freezed == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountDetails].
extension AccountDetailsPatterns on AccountDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountDetails value)  $default,){
final _that = this;
switch (_that) {
case _AccountDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountDetails value)?  $default,){
final _that = this;
switch (_that) {
case _AccountDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String? name, @HiveField(2)  String username, @HiveField(3)@JsonKey(name: 'include_adult')  bool? includeAdult, @HiveField(4)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(5)@JsonKey(name: 'iso_3166_1')  String? iso31661)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountDetails() when $default != null:
return $default(_that.id,_that.name,_that.username,_that.includeAdult,_that.iso6391,_that.iso31661);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String? name, @HiveField(2)  String username, @HiveField(3)@JsonKey(name: 'include_adult')  bool? includeAdult, @HiveField(4)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(5)@JsonKey(name: 'iso_3166_1')  String? iso31661)  $default,) {final _that = this;
switch (_that) {
case _AccountDetails():
return $default(_that.id,_that.name,_that.username,_that.includeAdult,_that.iso6391,_that.iso31661);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String? name, @HiveField(2)  String username, @HiveField(3)@JsonKey(name: 'include_adult')  bool? includeAdult, @HiveField(4)@JsonKey(name: 'iso_639_1')  String? iso6391, @HiveField(5)@JsonKey(name: 'iso_3166_1')  String? iso31661)?  $default,) {final _that = this;
switch (_that) {
case _AccountDetails() when $default != null:
return $default(_that.id,_that.name,_that.username,_that.includeAdult,_that.iso6391,_that.iso31661);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _AccountDetails implements AccountDetails {
  const _AccountDetails({@HiveField(0) required this.id, @HiveField(1) this.name, @HiveField(2) required this.username, @HiveField(3)@JsonKey(name: 'include_adult') this.includeAdult, @HiveField(4)@JsonKey(name: 'iso_639_1') this.iso6391, @HiveField(5)@JsonKey(name: 'iso_3166_1') this.iso31661});
  factory _AccountDetails.fromJson(Map<String, dynamic> json) => _$AccountDetailsFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String? name;
@override@HiveField(2) final  String username;
@override@HiveField(3)@JsonKey(name: 'include_adult') final  bool? includeAdult;
@override@HiveField(4)@JsonKey(name: 'iso_639_1') final  String? iso6391;
@override@HiveField(5)@JsonKey(name: 'iso_3166_1') final  String? iso31661;

/// Create a copy of AccountDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountDetailsCopyWith<_AccountDetails> get copyWith => __$AccountDetailsCopyWithImpl<_AccountDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.username, username) || other.username == username)&&(identical(other.includeAdult, includeAdult) || other.includeAdult == includeAdult)&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,username,includeAdult,iso6391,iso31661);

@override
String toString() {
  return 'AccountDetails(id: $id, name: $name, username: $username, includeAdult: $includeAdult, iso6391: $iso6391, iso31661: $iso31661)';
}


}

/// @nodoc
abstract mixin class _$AccountDetailsCopyWith<$Res> implements $AccountDetailsCopyWith<$Res> {
  factory _$AccountDetailsCopyWith(_AccountDetails value, $Res Function(_AccountDetails) _then) = __$AccountDetailsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String? name,@HiveField(2) String username,@HiveField(3)@JsonKey(name: 'include_adult') bool? includeAdult,@HiveField(4)@JsonKey(name: 'iso_639_1') String? iso6391,@HiveField(5)@JsonKey(name: 'iso_3166_1') String? iso31661
});




}
/// @nodoc
class __$AccountDetailsCopyWithImpl<$Res>
    implements _$AccountDetailsCopyWith<$Res> {
  __$AccountDetailsCopyWithImpl(this._self, this._then);

  final _AccountDetails _self;
  final $Res Function(_AccountDetails) _then;

/// Create a copy of AccountDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? username = null,Object? includeAdult = freezed,Object? iso6391 = freezed,Object? iso31661 = freezed,}) {
  return _then(_AccountDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,includeAdult: freezed == includeAdult ? _self.includeAdult : includeAdult // ignore: cast_nullable_to_non_nullable
as bool?,iso6391: freezed == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String?,iso31661: freezed == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
