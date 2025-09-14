// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonDetail {

@HiveField(0) bool get adult;@HiveField(1)@JsonKey(name: 'also_known_as') List<String>? get alsoKnownAs;@HiveField(2) String? get biography;@HiveField(3) String? get birthday;@HiveField(4) String? get deathday;@HiveField(5) int get gender;@HiveField(6) String? get homepage;@HiveField(7) int get id;@HiveField(8)@JsonKey(name: 'imdb_id') String? get imdbId;@HiveField(9)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(10) String get name;@HiveField(11)@JsonKey(name: 'place_of_birth') String? get placeOfBirth;@HiveField(12) double get popularity;@HiveField(13)@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonDetailCopyWith<PersonDetail> get copyWith => _$PersonDetailCopyWithImpl<PersonDetail>(this as PersonDetail, _$identity);

  /// Serializes this PersonDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonDetail&&(identical(other.adult, adult) || other.adult == adult)&&const DeepCollectionEquality().equals(other.alsoKnownAs, alsoKnownAs)&&(identical(other.biography, biography) || other.biography == biography)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.deathday, deathday) || other.deathday == deathday)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.id, id) || other.id == id)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,const DeepCollectionEquality().hash(alsoKnownAs),biography,birthday,deathday,gender,homepage,id,imdbId,knownForDepartment,name,placeOfBirth,popularity,profilePath);

@override
String toString() {
  return 'PersonDetail(adult: $adult, alsoKnownAs: $alsoKnownAs, biography: $biography, birthday: $birthday, deathday: $deathday, gender: $gender, homepage: $homepage, id: $id, imdbId: $imdbId, knownForDepartment: $knownForDepartment, name: $name, placeOfBirth: $placeOfBirth, popularity: $popularity, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $PersonDetailCopyWith<$Res>  {
  factory $PersonDetailCopyWith(PersonDetail value, $Res Function(PersonDetail) _then) = _$PersonDetailCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'also_known_as') List<String>? alsoKnownAs,@HiveField(2) String? biography,@HiveField(3) String? birthday,@HiveField(4) String? deathday,@HiveField(5) int gender,@HiveField(6) String? homepage,@HiveField(7) int id,@HiveField(8)@JsonKey(name: 'imdb_id') String? imdbId,@HiveField(9)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(10) String name,@HiveField(11)@JsonKey(name: 'place_of_birth') String? placeOfBirth,@HiveField(12) double popularity,@HiveField(13)@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$PersonDetailCopyWithImpl<$Res>
    implements $PersonDetailCopyWith<$Res> {
  _$PersonDetailCopyWithImpl(this._self, this._then);

  final PersonDetail _self;
  final $Res Function(PersonDetail) _then;

/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adult = null,Object? alsoKnownAs = freezed,Object? biography = freezed,Object? birthday = freezed,Object? deathday = freezed,Object? gender = null,Object? homepage = freezed,Object? id = null,Object? imdbId = freezed,Object? knownForDepartment = freezed,Object? name = null,Object? placeOfBirth = freezed,Object? popularity = null,Object? profilePath = freezed,}) {
  return _then(_self.copyWith(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,alsoKnownAs: freezed == alsoKnownAs ? _self.alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as List<String>?,biography: freezed == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,deathday: freezed == deathday ? _self.deathday : deathday // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonDetail].
extension PersonDetailPatterns on PersonDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonDetail value)  $default,){
final _that = this;
switch (_that) {
case _PersonDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'also_known_as')  List<String>? alsoKnownAs, @HiveField(2)  String? biography, @HiveField(3)  String? birthday, @HiveField(4)  String? deathday, @HiveField(5)  int gender, @HiveField(6)  String? homepage, @HiveField(7)  int id, @HiveField(8)@JsonKey(name: 'imdb_id')  String? imdbId, @HiveField(9)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(10)  String name, @HiveField(11)@JsonKey(name: 'place_of_birth')  String? placeOfBirth, @HiveField(12)  double popularity, @HiveField(13)@JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
return $default(_that.adult,_that.alsoKnownAs,_that.biography,_that.birthday,_that.deathday,_that.gender,_that.homepage,_that.id,_that.imdbId,_that.knownForDepartment,_that.name,_that.placeOfBirth,_that.popularity,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'also_known_as')  List<String>? alsoKnownAs, @HiveField(2)  String? biography, @HiveField(3)  String? birthday, @HiveField(4)  String? deathday, @HiveField(5)  int gender, @HiveField(6)  String? homepage, @HiveField(7)  int id, @HiveField(8)@JsonKey(name: 'imdb_id')  String? imdbId, @HiveField(9)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(10)  String name, @HiveField(11)@JsonKey(name: 'place_of_birth')  String? placeOfBirth, @HiveField(12)  double popularity, @HiveField(13)@JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _PersonDetail():
return $default(_that.adult,_that.alsoKnownAs,_that.biography,_that.birthday,_that.deathday,_that.gender,_that.homepage,_that.id,_that.imdbId,_that.knownForDepartment,_that.name,_that.placeOfBirth,_that.popularity,_that.profilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool adult, @HiveField(1)@JsonKey(name: 'also_known_as')  List<String>? alsoKnownAs, @HiveField(2)  String? biography, @HiveField(3)  String? birthday, @HiveField(4)  String? deathday, @HiveField(5)  int gender, @HiveField(6)  String? homepage, @HiveField(7)  int id, @HiveField(8)@JsonKey(name: 'imdb_id')  String? imdbId, @HiveField(9)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(10)  String name, @HiveField(11)@JsonKey(name: 'place_of_birth')  String? placeOfBirth, @HiveField(12)  double popularity, @HiveField(13)@JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
return $default(_that.adult,_that.alsoKnownAs,_that.biography,_that.birthday,_that.deathday,_that.gender,_that.homepage,_that.id,_that.imdbId,_that.knownForDepartment,_that.name,_that.placeOfBirth,_that.popularity,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PersonDetail implements PersonDetail {
   _PersonDetail({@HiveField(0) this.adult = true, @HiveField(1)@JsonKey(name: 'also_known_as') final  List<String>? alsoKnownAs, @HiveField(2) this.biography, @HiveField(3) this.birthday, @HiveField(4) this.deathday, @HiveField(5) this.gender = 0, @HiveField(6) this.homepage, @HiveField(7) required this.id, @HiveField(8)@JsonKey(name: 'imdb_id') this.imdbId, @HiveField(9)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(10) required this.name, @HiveField(11)@JsonKey(name: 'place_of_birth') this.placeOfBirth, @HiveField(12) this.popularity = 0.0, @HiveField(13)@JsonKey(name: 'profile_path') this.profilePath}): _alsoKnownAs = alsoKnownAs;
  factory _PersonDetail.fromJson(Map<String, dynamic> json) => _$PersonDetailFromJson(json);

@override@JsonKey()@HiveField(0) final  bool adult;
 final  List<String>? _alsoKnownAs;
@override@HiveField(1)@JsonKey(name: 'also_known_as') List<String>? get alsoKnownAs {
  final value = _alsoKnownAs;
  if (value == null) return null;
  if (_alsoKnownAs is EqualUnmodifiableListView) return _alsoKnownAs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(2) final  String? biography;
@override@HiveField(3) final  String? birthday;
@override@HiveField(4) final  String? deathday;
@override@JsonKey()@HiveField(5) final  int gender;
@override@HiveField(6) final  String? homepage;
@override@HiveField(7) final  int id;
@override@HiveField(8)@JsonKey(name: 'imdb_id') final  String? imdbId;
@override@HiveField(9)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(10) final  String name;
@override@HiveField(11)@JsonKey(name: 'place_of_birth') final  String? placeOfBirth;
@override@JsonKey()@HiveField(12) final  double popularity;
@override@HiveField(13)@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonDetailCopyWith<_PersonDetail> get copyWith => __$PersonDetailCopyWithImpl<_PersonDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonDetail&&(identical(other.adult, adult) || other.adult == adult)&&const DeepCollectionEquality().equals(other._alsoKnownAs, _alsoKnownAs)&&(identical(other.biography, biography) || other.biography == biography)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.deathday, deathday) || other.deathday == deathday)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.id, id) || other.id == id)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,const DeepCollectionEquality().hash(_alsoKnownAs),biography,birthday,deathday,gender,homepage,id,imdbId,knownForDepartment,name,placeOfBirth,popularity,profilePath);

@override
String toString() {
  return 'PersonDetail(adult: $adult, alsoKnownAs: $alsoKnownAs, biography: $biography, birthday: $birthday, deathday: $deathday, gender: $gender, homepage: $homepage, id: $id, imdbId: $imdbId, knownForDepartment: $knownForDepartment, name: $name, placeOfBirth: $placeOfBirth, popularity: $popularity, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$PersonDetailCopyWith<$Res> implements $PersonDetailCopyWith<$Res> {
  factory _$PersonDetailCopyWith(_PersonDetail value, $Res Function(_PersonDetail) _then) = __$PersonDetailCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1)@JsonKey(name: 'also_known_as') List<String>? alsoKnownAs,@HiveField(2) String? biography,@HiveField(3) String? birthday,@HiveField(4) String? deathday,@HiveField(5) int gender,@HiveField(6) String? homepage,@HiveField(7) int id,@HiveField(8)@JsonKey(name: 'imdb_id') String? imdbId,@HiveField(9)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(10) String name,@HiveField(11)@JsonKey(name: 'place_of_birth') String? placeOfBirth,@HiveField(12) double popularity,@HiveField(13)@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$PersonDetailCopyWithImpl<$Res>
    implements _$PersonDetailCopyWith<$Res> {
  __$PersonDetailCopyWithImpl(this._self, this._then);

  final _PersonDetail _self;
  final $Res Function(_PersonDetail) _then;

/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adult = null,Object? alsoKnownAs = freezed,Object? biography = freezed,Object? birthday = freezed,Object? deathday = freezed,Object? gender = null,Object? homepage = freezed,Object? id = null,Object? imdbId = freezed,Object? knownForDepartment = freezed,Object? name = null,Object? placeOfBirth = freezed,Object? popularity = null,Object? profilePath = freezed,}) {
  return _then(_PersonDetail(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,alsoKnownAs: freezed == alsoKnownAs ? _self._alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as List<String>?,biography: freezed == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,deathday: freezed == deathday ? _self.deathday : deathday // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
