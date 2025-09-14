// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_credits.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvCast {

@HiveField(0) int? get castId;@HiveField(1)@JsonKey(name: 'character') String? get character;@HiveField(2)@JsonKey(name: 'credit_id') String get creditId;@HiveField(3) int? get gender;@HiveField(4) int get id;@HiveField(5) String get name;@HiveField(6) int? get order;@HiveField(7)@JsonKey(name: 'profile_path') String? get profilePath;@HiveField(8)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(9) double? get popularity;
/// Create a copy of TvCast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvCastCopyWith<TvCast> get copyWith => _$TvCastCopyWithImpl<TvCast>(this as TvCast, _$identity);

  /// Serializes this TvCast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvCast&&(identical(other.castId, castId) || other.castId == castId)&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.popularity, popularity) || other.popularity == popularity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,castId,character,creditId,gender,id,name,order,profilePath,knownForDepartment,popularity);

@override
String toString() {
  return 'TvCast(castId: $castId, character: $character, creditId: $creditId, gender: $gender, id: $id, name: $name, order: $order, profilePath: $profilePath, knownForDepartment: $knownForDepartment, popularity: $popularity)';
}


}

/// @nodoc
abstract mixin class $TvCastCopyWith<$Res>  {
  factory $TvCastCopyWith(TvCast value, $Res Function(TvCast) _then) = _$TvCastCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int? castId,@HiveField(1)@JsonKey(name: 'character') String? character,@HiveField(2)@JsonKey(name: 'credit_id') String creditId,@HiveField(3) int? gender,@HiveField(4) int id,@HiveField(5) String name,@HiveField(6) int? order,@HiveField(7)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(8)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(9) double? popularity
});




}
/// @nodoc
class _$TvCastCopyWithImpl<$Res>
    implements $TvCastCopyWith<$Res> {
  _$TvCastCopyWithImpl(this._self, this._then);

  final TvCast _self;
  final $Res Function(TvCast) _then;

/// Create a copy of TvCast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? castId = freezed,Object? character = freezed,Object? creditId = null,Object? gender = freezed,Object? id = null,Object? name = null,Object? order = freezed,Object? profilePath = freezed,Object? knownForDepartment = freezed,Object? popularity = freezed,}) {
  return _then(_self.copyWith(
castId: freezed == castId ? _self.castId : castId // ignore: cast_nullable_to_non_nullable
as int?,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: null == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvCast].
extension TvCastPatterns on TvCast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvCast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvCast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvCast value)  $default,){
final _that = this;
switch (_that) {
case _TvCast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvCast value)?  $default,){
final _that = this;
switch (_that) {
case _TvCast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int? castId, @HiveField(1)@JsonKey(name: 'character')  String? character, @HiveField(2)@JsonKey(name: 'credit_id')  String creditId, @HiveField(3)  int? gender, @HiveField(4)  int id, @HiveField(5)  String name, @HiveField(6)  int? order, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(9)  double? popularity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvCast() when $default != null:
return $default(_that.castId,_that.character,_that.creditId,_that.gender,_that.id,_that.name,_that.order,_that.profilePath,_that.knownForDepartment,_that.popularity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int? castId, @HiveField(1)@JsonKey(name: 'character')  String? character, @HiveField(2)@JsonKey(name: 'credit_id')  String creditId, @HiveField(3)  int? gender, @HiveField(4)  int id, @HiveField(5)  String name, @HiveField(6)  int? order, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(9)  double? popularity)  $default,) {final _that = this;
switch (_that) {
case _TvCast():
return $default(_that.castId,_that.character,_that.creditId,_that.gender,_that.id,_that.name,_that.order,_that.profilePath,_that.knownForDepartment,_that.popularity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int? castId, @HiveField(1)@JsonKey(name: 'character')  String? character, @HiveField(2)@JsonKey(name: 'credit_id')  String creditId, @HiveField(3)  int? gender, @HiveField(4)  int id, @HiveField(5)  String name, @HiveField(6)  int? order, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(9)  double? popularity)?  $default,) {final _that = this;
switch (_that) {
case _TvCast() when $default != null:
return $default(_that.castId,_that.character,_that.creditId,_that.gender,_that.id,_that.name,_that.order,_that.profilePath,_that.knownForDepartment,_that.popularity);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TvCast implements TvCast {
  const _TvCast({@HiveField(0) this.castId, @HiveField(1)@JsonKey(name: 'character') this.character, @HiveField(2)@JsonKey(name: 'credit_id') required this.creditId, @HiveField(3) this.gender, @HiveField(4) required this.id, @HiveField(5) required this.name, @HiveField(6) this.order, @HiveField(7)@JsonKey(name: 'profile_path') this.profilePath, @HiveField(8)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(9) this.popularity});
  factory _TvCast.fromJson(Map<String, dynamic> json) => _$TvCastFromJson(json);

@override@HiveField(0) final  int? castId;
@override@HiveField(1)@JsonKey(name: 'character') final  String? character;
@override@HiveField(2)@JsonKey(name: 'credit_id') final  String creditId;
@override@HiveField(3) final  int? gender;
@override@HiveField(4) final  int id;
@override@HiveField(5) final  String name;
@override@HiveField(6) final  int? order;
@override@HiveField(7)@JsonKey(name: 'profile_path') final  String? profilePath;
@override@HiveField(8)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(9) final  double? popularity;

/// Create a copy of TvCast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvCastCopyWith<_TvCast> get copyWith => __$TvCastCopyWithImpl<_TvCast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvCastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvCast&&(identical(other.castId, castId) || other.castId == castId)&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.popularity, popularity) || other.popularity == popularity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,castId,character,creditId,gender,id,name,order,profilePath,knownForDepartment,popularity);

@override
String toString() {
  return 'TvCast(castId: $castId, character: $character, creditId: $creditId, gender: $gender, id: $id, name: $name, order: $order, profilePath: $profilePath, knownForDepartment: $knownForDepartment, popularity: $popularity)';
}


}

/// @nodoc
abstract mixin class _$TvCastCopyWith<$Res> implements $TvCastCopyWith<$Res> {
  factory _$TvCastCopyWith(_TvCast value, $Res Function(_TvCast) _then) = __$TvCastCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int? castId,@HiveField(1)@JsonKey(name: 'character') String? character,@HiveField(2)@JsonKey(name: 'credit_id') String creditId,@HiveField(3) int? gender,@HiveField(4) int id,@HiveField(5) String name,@HiveField(6) int? order,@HiveField(7)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(8)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(9) double? popularity
});




}
/// @nodoc
class __$TvCastCopyWithImpl<$Res>
    implements _$TvCastCopyWith<$Res> {
  __$TvCastCopyWithImpl(this._self, this._then);

  final _TvCast _self;
  final $Res Function(_TvCast) _then;

/// Create a copy of TvCast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? castId = freezed,Object? character = freezed,Object? creditId = null,Object? gender = freezed,Object? id = null,Object? name = null,Object? order = freezed,Object? profilePath = freezed,Object? knownForDepartment = freezed,Object? popularity = freezed,}) {
  return _then(_TvCast(
castId: freezed == castId ? _self.castId : castId // ignore: cast_nullable_to_non_nullable
as int?,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: null == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$TvCrew {

@HiveField(0)@JsonKey(name: 'credit_id') String get creditId;@HiveField(1) String? get department;@HiveField(2) String? get job;@HiveField(3) int? get gender;@HiveField(4) int get id;@HiveField(5) String get name;@HiveField(6)@JsonKey(name: 'profile_path') String? get profilePath;@HiveField(7)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(8) double? get popularity;
/// Create a copy of TvCrew
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvCrewCopyWith<TvCrew> get copyWith => _$TvCrewCopyWithImpl<TvCrew>(this as TvCrew, _$identity);

  /// Serializes this TvCrew to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvCrew&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.popularity, popularity) || other.popularity == popularity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,creditId,department,job,gender,id,name,profilePath,knownForDepartment,popularity);

@override
String toString() {
  return 'TvCrew(creditId: $creditId, department: $department, job: $job, gender: $gender, id: $id, name: $name, profilePath: $profilePath, knownForDepartment: $knownForDepartment, popularity: $popularity)';
}


}

/// @nodoc
abstract mixin class $TvCrewCopyWith<$Res>  {
  factory $TvCrewCopyWith(TvCrew value, $Res Function(TvCrew) _then) = _$TvCrewCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'credit_id') String creditId,@HiveField(1) String? department,@HiveField(2) String? job,@HiveField(3) int? gender,@HiveField(4) int id,@HiveField(5) String name,@HiveField(6)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(7)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(8) double? popularity
});




}
/// @nodoc
class _$TvCrewCopyWithImpl<$Res>
    implements $TvCrewCopyWith<$Res> {
  _$TvCrewCopyWithImpl(this._self, this._then);

  final TvCrew _self;
  final $Res Function(TvCrew) _then;

/// Create a copy of TvCrew
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? creditId = null,Object? department = freezed,Object? job = freezed,Object? gender = freezed,Object? id = null,Object? name = null,Object? profilePath = freezed,Object? knownForDepartment = freezed,Object? popularity = freezed,}) {
  return _then(_self.copyWith(
creditId: null == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvCrew].
extension TvCrewPatterns on TvCrew {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvCrew value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvCrew() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvCrew value)  $default,){
final _that = this;
switch (_that) {
case _TvCrew():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvCrew value)?  $default,){
final _that = this;
switch (_that) {
case _TvCrew() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'credit_id')  String creditId, @HiveField(1)  String? department, @HiveField(2)  String? job, @HiveField(3)  int? gender, @HiveField(4)  int id, @HiveField(5)  String name, @HiveField(6)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(7)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(8)  double? popularity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvCrew() when $default != null:
return $default(_that.creditId,_that.department,_that.job,_that.gender,_that.id,_that.name,_that.profilePath,_that.knownForDepartment,_that.popularity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'credit_id')  String creditId, @HiveField(1)  String? department, @HiveField(2)  String? job, @HiveField(3)  int? gender, @HiveField(4)  int id, @HiveField(5)  String name, @HiveField(6)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(7)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(8)  double? popularity)  $default,) {final _that = this;
switch (_that) {
case _TvCrew():
return $default(_that.creditId,_that.department,_that.job,_that.gender,_that.id,_that.name,_that.profilePath,_that.knownForDepartment,_that.popularity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'credit_id')  String creditId, @HiveField(1)  String? department, @HiveField(2)  String? job, @HiveField(3)  int? gender, @HiveField(4)  int id, @HiveField(5)  String name, @HiveField(6)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(7)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(8)  double? popularity)?  $default,) {final _that = this;
switch (_that) {
case _TvCrew() when $default != null:
return $default(_that.creditId,_that.department,_that.job,_that.gender,_that.id,_that.name,_that.profilePath,_that.knownForDepartment,_that.popularity);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TvCrew implements TvCrew {
  const _TvCrew({@HiveField(0)@JsonKey(name: 'credit_id') required this.creditId, @HiveField(1) this.department, @HiveField(2) this.job, @HiveField(3) this.gender, @HiveField(4) required this.id, @HiveField(5) required this.name, @HiveField(6)@JsonKey(name: 'profile_path') this.profilePath, @HiveField(7)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(8) this.popularity});
  factory _TvCrew.fromJson(Map<String, dynamic> json) => _$TvCrewFromJson(json);

@override@HiveField(0)@JsonKey(name: 'credit_id') final  String creditId;
@override@HiveField(1) final  String? department;
@override@HiveField(2) final  String? job;
@override@HiveField(3) final  int? gender;
@override@HiveField(4) final  int id;
@override@HiveField(5) final  String name;
@override@HiveField(6)@JsonKey(name: 'profile_path') final  String? profilePath;
@override@HiveField(7)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(8) final  double? popularity;

/// Create a copy of TvCrew
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvCrewCopyWith<_TvCrew> get copyWith => __$TvCrewCopyWithImpl<_TvCrew>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvCrewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvCrew&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.popularity, popularity) || other.popularity == popularity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,creditId,department,job,gender,id,name,profilePath,knownForDepartment,popularity);

@override
String toString() {
  return 'TvCrew(creditId: $creditId, department: $department, job: $job, gender: $gender, id: $id, name: $name, profilePath: $profilePath, knownForDepartment: $knownForDepartment, popularity: $popularity)';
}


}

/// @nodoc
abstract mixin class _$TvCrewCopyWith<$Res> implements $TvCrewCopyWith<$Res> {
  factory _$TvCrewCopyWith(_TvCrew value, $Res Function(_TvCrew) _then) = __$TvCrewCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'credit_id') String creditId,@HiveField(1) String? department,@HiveField(2) String? job,@HiveField(3) int? gender,@HiveField(4) int id,@HiveField(5) String name,@HiveField(6)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(7)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(8) double? popularity
});




}
/// @nodoc
class __$TvCrewCopyWithImpl<$Res>
    implements _$TvCrewCopyWith<$Res> {
  __$TvCrewCopyWithImpl(this._self, this._then);

  final _TvCrew _self;
  final $Res Function(_TvCrew) _then;

/// Create a copy of TvCrew
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? creditId = null,Object? department = freezed,Object? job = freezed,Object? gender = freezed,Object? id = null,Object? name = null,Object? profilePath = freezed,Object? knownForDepartment = freezed,Object? popularity = freezed,}) {
  return _then(_TvCrew(
creditId: null == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$TvCreditsResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'cast') List<TvCast> get cast;@HiveField(2)@JsonKey(name: 'crew') List<TvCrew> get crew;
/// Create a copy of TvCreditsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvCreditsResponseCopyWith<TvCreditsResponse> get copyWith => _$TvCreditsResponseCopyWithImpl<TvCreditsResponse>(this as TvCreditsResponse, _$identity);

  /// Serializes this TvCreditsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvCreditsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.cast, cast)&&const DeepCollectionEquality().equals(other.crew, crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(cast),const DeepCollectionEquality().hash(crew));

@override
String toString() {
  return 'TvCreditsResponse(id: $id, cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class $TvCreditsResponseCopyWith<$Res>  {
  factory $TvCreditsResponseCopyWith(TvCreditsResponse value, $Res Function(TvCreditsResponse) _then) = _$TvCreditsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'cast') List<TvCast> cast,@HiveField(2)@JsonKey(name: 'crew') List<TvCrew> crew
});




}
/// @nodoc
class _$TvCreditsResponseCopyWithImpl<$Res>
    implements $TvCreditsResponseCopyWith<$Res> {
  _$TvCreditsResponseCopyWithImpl(this._self, this._then);

  final TvCreditsResponse _self;
  final $Res Function(TvCreditsResponse) _then;

/// Create a copy of TvCreditsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cast = null,Object? crew = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<TvCast>,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as List<TvCrew>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvCreditsResponse].
extension TvCreditsResponsePatterns on TvCreditsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvCreditsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvCreditsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvCreditsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TvCreditsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvCreditsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TvCreditsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'cast')  List<TvCast> cast, @HiveField(2)@JsonKey(name: 'crew')  List<TvCrew> crew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvCreditsResponse() when $default != null:
return $default(_that.id,_that.cast,_that.crew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'cast')  List<TvCast> cast, @HiveField(2)@JsonKey(name: 'crew')  List<TvCrew> crew)  $default,) {final _that = this;
switch (_that) {
case _TvCreditsResponse():
return $default(_that.id,_that.cast,_that.crew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'cast')  List<TvCast> cast, @HiveField(2)@JsonKey(name: 'crew')  List<TvCrew> crew)?  $default,) {final _that = this;
switch (_that) {
case _TvCreditsResponse() when $default != null:
return $default(_that.id,_that.cast,_that.crew);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TvCreditsResponse implements TvCreditsResponse {
  const _TvCreditsResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'cast') required final  List<TvCast> cast, @HiveField(2)@JsonKey(name: 'crew') required final  List<TvCrew> crew}): _cast = cast,_crew = crew;
  factory _TvCreditsResponse.fromJson(Map<String, dynamic> json) => _$TvCreditsResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<TvCast> _cast;
@override@HiveField(1)@JsonKey(name: 'cast') List<TvCast> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

 final  List<TvCrew> _crew;
@override@HiveField(2)@JsonKey(name: 'crew') List<TvCrew> get crew {
  if (_crew is EqualUnmodifiableListView) return _crew;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crew);
}


/// Create a copy of TvCreditsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvCreditsResponseCopyWith<_TvCreditsResponse> get copyWith => __$TvCreditsResponseCopyWithImpl<_TvCreditsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvCreditsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvCreditsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._cast, _cast)&&const DeepCollectionEquality().equals(other._crew, _crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_cast),const DeepCollectionEquality().hash(_crew));

@override
String toString() {
  return 'TvCreditsResponse(id: $id, cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class _$TvCreditsResponseCopyWith<$Res> implements $TvCreditsResponseCopyWith<$Res> {
  factory _$TvCreditsResponseCopyWith(_TvCreditsResponse value, $Res Function(_TvCreditsResponse) _then) = __$TvCreditsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'cast') List<TvCast> cast,@HiveField(2)@JsonKey(name: 'crew') List<TvCrew> crew
});




}
/// @nodoc
class __$TvCreditsResponseCopyWithImpl<$Res>
    implements _$TvCreditsResponseCopyWith<$Res> {
  __$TvCreditsResponseCopyWithImpl(this._self, this._then);

  final _TvCreditsResponse _self;
  final $Res Function(_TvCreditsResponse) _then;

/// Create a copy of TvCreditsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cast = null,Object? crew = null,}) {
  return _then(_TvCreditsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<TvCast>,crew: null == crew ? _self._crew : crew // ignore: cast_nullable_to_non_nullable
as List<TvCrew>,
  ));
}


}

// dart format on
