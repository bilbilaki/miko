// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_credits.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieCredits {

@HiveField(0) int get id;@HiveField(1) List<MovieCastMember> get cast;@HiveField(2) List<MovieCrewMember> get crew;
/// Create a copy of MovieCredits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieCreditsCopyWith<MovieCredits> get copyWith => _$MovieCreditsCopyWithImpl<MovieCredits>(this as MovieCredits, _$identity);

  /// Serializes this MovieCredits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieCredits&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.cast, cast)&&const DeepCollectionEquality().equals(other.crew, crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(cast),const DeepCollectionEquality().hash(crew));

@override
String toString() {
  return 'MovieCredits(id: $id, cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class $MovieCreditsCopyWith<$Res>  {
  factory $MovieCreditsCopyWith(MovieCredits value, $Res Function(MovieCredits) _then) = _$MovieCreditsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) List<MovieCastMember> cast,@HiveField(2) List<MovieCrewMember> crew
});




}
/// @nodoc
class _$MovieCreditsCopyWithImpl<$Res>
    implements $MovieCreditsCopyWith<$Res> {
  _$MovieCreditsCopyWithImpl(this._self, this._then);

  final MovieCredits _self;
  final $Res Function(MovieCredits) _then;

/// Create a copy of MovieCredits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cast = null,Object? crew = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<MovieCastMember>,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as List<MovieCrewMember>,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieCredits].
extension MovieCreditsPatterns on MovieCredits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieCredits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieCredits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieCredits value)  $default,){
final _that = this;
switch (_that) {
case _MovieCredits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieCredits value)?  $default,){
final _that = this;
switch (_that) {
case _MovieCredits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  List<MovieCastMember> cast, @HiveField(2)  List<MovieCrewMember> crew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieCredits() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  List<MovieCastMember> cast, @HiveField(2)  List<MovieCrewMember> crew)  $default,) {final _that = this;
switch (_that) {
case _MovieCredits():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  List<MovieCastMember> cast, @HiveField(2)  List<MovieCrewMember> crew)?  $default,) {final _that = this;
switch (_that) {
case _MovieCredits() when $default != null:
return $default(_that.id,_that.cast,_that.crew);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieCredits implements MovieCredits {
   _MovieCredits({@HiveField(0) required this.id, @HiveField(1) required final  List<MovieCastMember> cast, @HiveField(2) required final  List<MovieCrewMember> crew}): _cast = cast,_crew = crew;
  factory _MovieCredits.fromJson(Map<String, dynamic> json) => _$MovieCreditsFromJson(json);

@override@HiveField(0) final  int id;
 final  List<MovieCastMember> _cast;
@override@HiveField(1) List<MovieCastMember> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

 final  List<MovieCrewMember> _crew;
@override@HiveField(2) List<MovieCrewMember> get crew {
  if (_crew is EqualUnmodifiableListView) return _crew;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crew);
}


/// Create a copy of MovieCredits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieCreditsCopyWith<_MovieCredits> get copyWith => __$MovieCreditsCopyWithImpl<_MovieCredits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieCreditsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieCredits&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._cast, _cast)&&const DeepCollectionEquality().equals(other._crew, _crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_cast),const DeepCollectionEquality().hash(_crew));

@override
String toString() {
  return 'MovieCredits(id: $id, cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class _$MovieCreditsCopyWith<$Res> implements $MovieCreditsCopyWith<$Res> {
  factory _$MovieCreditsCopyWith(_MovieCredits value, $Res Function(_MovieCredits) _then) = __$MovieCreditsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) List<MovieCastMember> cast,@HiveField(2) List<MovieCrewMember> crew
});




}
/// @nodoc
class __$MovieCreditsCopyWithImpl<$Res>
    implements _$MovieCreditsCopyWith<$Res> {
  __$MovieCreditsCopyWithImpl(this._self, this._then);

  final _MovieCredits _self;
  final $Res Function(_MovieCredits) _then;

/// Create a copy of MovieCredits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cast = null,Object? crew = null,}) {
  return _then(_MovieCredits(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<MovieCastMember>,crew: null == crew ? _self._crew : crew // ignore: cast_nullable_to_non_nullable
as List<MovieCrewMember>,
  ));
}


}


/// @nodoc
mixin _$MovieCastMember {

@HiveField(0) bool get adult;@HiveField(1) int get gender;@HiveField(2) int get id;@HiveField(3)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(4) String get name;@HiveField(5)@JsonKey(name: 'original_name') String? get originalName;@HiveField(6) double get popularity;@HiveField(7)@JsonKey(name: 'profile_path') String? get profilePath;@HiveField(8)@JsonKey(name: 'cast_id') int get castId;@HiveField(9) String? get character;@HiveField(10)@JsonKey(name: 'credit_id') String? get creditId;@HiveField(11) int get order;
/// Create a copy of MovieCastMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieCastMemberCopyWith<MovieCastMember> get copyWith => _$MovieCastMemberCopyWithImpl<MovieCastMember>(this as MovieCastMember, _$identity);

  /// Serializes this MovieCastMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieCastMember&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.castId, castId) || other.castId == castId)&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath,castId,character,creditId,order);

@override
String toString() {
  return 'MovieCastMember(adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath, castId: $castId, character: $character, creditId: $creditId, order: $order)';
}


}

/// @nodoc
abstract mixin class $MovieCastMemberCopyWith<$Res>  {
  factory $MovieCastMemberCopyWith(MovieCastMember value, $Res Function(MovieCastMember) _then) = _$MovieCastMemberCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1) int gender,@HiveField(2) int id,@HiveField(3)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(4) String name,@HiveField(5)@JsonKey(name: 'original_name') String? originalName,@HiveField(6) double popularity,@HiveField(7)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(8)@JsonKey(name: 'cast_id') int castId,@HiveField(9) String? character,@HiveField(10)@JsonKey(name: 'credit_id') String? creditId,@HiveField(11) int order
});




}
/// @nodoc
class _$MovieCastMemberCopyWithImpl<$Res>
    implements $MovieCastMemberCopyWith<$Res> {
  _$MovieCastMemberCopyWithImpl(this._self, this._then);

  final MovieCastMember _self;
  final $Res Function(MovieCastMember) _then;

/// Create a copy of MovieCastMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,Object? castId = null,Object? character = freezed,Object? creditId = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,castId: null == castId ? _self.castId : castId // ignore: cast_nullable_to_non_nullable
as int,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieCastMember].
extension MovieCastMemberPatterns on MovieCastMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieCastMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieCastMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieCastMember value)  $default,){
final _that = this;
switch (_that) {
case _MovieCastMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieCastMember value)?  $default,){
final _that = this;
switch (_that) {
case _MovieCastMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)  int gender, @HiveField(2)  int id, @HiveField(3)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)  double popularity, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'cast_id')  int castId, @HiveField(9)  String? character, @HiveField(10)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(11)  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieCastMember() when $default != null:
return $default(_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath,_that.castId,_that.character,_that.creditId,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)  int gender, @HiveField(2)  int id, @HiveField(3)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)  double popularity, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'cast_id')  int castId, @HiveField(9)  String? character, @HiveField(10)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(11)  int order)  $default,) {final _that = this;
switch (_that) {
case _MovieCastMember():
return $default(_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath,_that.castId,_that.character,_that.creditId,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool adult, @HiveField(1)  int gender, @HiveField(2)  int id, @HiveField(3)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)  double popularity, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'cast_id')  int castId, @HiveField(9)  String? character, @HiveField(10)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(11)  int order)?  $default,) {final _that = this;
switch (_that) {
case _MovieCastMember() when $default != null:
return $default(_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath,_that.castId,_that.character,_that.creditId,_that.order);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieCastMember implements MovieCastMember {
   _MovieCastMember({@HiveField(0) this.adult = true, @HiveField(1) this.gender = 0, @HiveField(2) this.id = 0, @HiveField(3)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(4) required this.name, @HiveField(5)@JsonKey(name: 'original_name') this.originalName, @HiveField(6) this.popularity = 0.0, @HiveField(7)@JsonKey(name: 'profile_path') this.profilePath, @HiveField(8)@JsonKey(name: 'cast_id') this.castId = 0, @HiveField(9) this.character, @HiveField(10)@JsonKey(name: 'credit_id') this.creditId, @HiveField(11) this.order = 0});
  factory _MovieCastMember.fromJson(Map<String, dynamic> json) => _$MovieCastMemberFromJson(json);

@override@JsonKey()@HiveField(0) final  bool adult;
@override@JsonKey()@HiveField(1) final  int gender;
@override@JsonKey()@HiveField(2) final  int id;
@override@HiveField(3)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(4) final  String name;
@override@HiveField(5)@JsonKey(name: 'original_name') final  String? originalName;
@override@JsonKey()@HiveField(6) final  double popularity;
@override@HiveField(7)@JsonKey(name: 'profile_path') final  String? profilePath;
@override@HiveField(8)@JsonKey(name: 'cast_id') final  int castId;
@override@HiveField(9) final  String? character;
@override@HiveField(10)@JsonKey(name: 'credit_id') final  String? creditId;
@override@JsonKey()@HiveField(11) final  int order;

/// Create a copy of MovieCastMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieCastMemberCopyWith<_MovieCastMember> get copyWith => __$MovieCastMemberCopyWithImpl<_MovieCastMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieCastMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieCastMember&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.castId, castId) || other.castId == castId)&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath,castId,character,creditId,order);

@override
String toString() {
  return 'MovieCastMember(adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath, castId: $castId, character: $character, creditId: $creditId, order: $order)';
}


}

/// @nodoc
abstract mixin class _$MovieCastMemberCopyWith<$Res> implements $MovieCastMemberCopyWith<$Res> {
  factory _$MovieCastMemberCopyWith(_MovieCastMember value, $Res Function(_MovieCastMember) _then) = __$MovieCastMemberCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1) int gender,@HiveField(2) int id,@HiveField(3)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(4) String name,@HiveField(5)@JsonKey(name: 'original_name') String? originalName,@HiveField(6) double popularity,@HiveField(7)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(8)@JsonKey(name: 'cast_id') int castId,@HiveField(9) String? character,@HiveField(10)@JsonKey(name: 'credit_id') String? creditId,@HiveField(11) int order
});




}
/// @nodoc
class __$MovieCastMemberCopyWithImpl<$Res>
    implements _$MovieCastMemberCopyWith<$Res> {
  __$MovieCastMemberCopyWithImpl(this._self, this._then);

  final _MovieCastMember _self;
  final $Res Function(_MovieCastMember) _then;

/// Create a copy of MovieCastMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,Object? castId = null,Object? character = freezed,Object? creditId = freezed,Object? order = null,}) {
  return _then(_MovieCastMember(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,castId: null == castId ? _self.castId : castId // ignore: cast_nullable_to_non_nullable
as int,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MovieCrewMember {

@HiveField(0) bool get adult;@HiveField(1) int get gender;@HiveField(2) int get id;@HiveField(3)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(4) String get name;@HiveField(5)@JsonKey(name: 'original_name') String? get originalName;@HiveField(6) double get popularity;@HiveField(7)@JsonKey(name: 'profile_path') String? get profilePath;@HiveField(8)@JsonKey(name: 'credit_id') String? get creditId;@HiveField(9) String? get department;@HiveField(10) String? get job;
/// Create a copy of MovieCrewMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieCrewMemberCopyWith<MovieCrewMember> get copyWith => _$MovieCrewMemberCopyWithImpl<MovieCrewMember>(this as MovieCrewMember, _$identity);

  /// Serializes this MovieCrewMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieCrewMember&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath,creditId,department,job);

@override
String toString() {
  return 'MovieCrewMember(adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath, creditId: $creditId, department: $department, job: $job)';
}


}

/// @nodoc
abstract mixin class $MovieCrewMemberCopyWith<$Res>  {
  factory $MovieCrewMemberCopyWith(MovieCrewMember value, $Res Function(MovieCrewMember) _then) = _$MovieCrewMemberCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1) int gender,@HiveField(2) int id,@HiveField(3)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(4) String name,@HiveField(5)@JsonKey(name: 'original_name') String? originalName,@HiveField(6) double popularity,@HiveField(7)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(8)@JsonKey(name: 'credit_id') String? creditId,@HiveField(9) String? department,@HiveField(10) String? job
});




}
/// @nodoc
class _$MovieCrewMemberCopyWithImpl<$Res>
    implements $MovieCrewMemberCopyWith<$Res> {
  _$MovieCrewMemberCopyWithImpl(this._self, this._then);

  final MovieCrewMember _self;
  final $Res Function(MovieCrewMember) _then;

/// Create a copy of MovieCrewMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,Object? creditId = freezed,Object? department = freezed,Object? job = freezed,}) {
  return _then(_self.copyWith(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieCrewMember].
extension MovieCrewMemberPatterns on MovieCrewMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieCrewMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieCrewMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieCrewMember value)  $default,){
final _that = this;
switch (_that) {
case _MovieCrewMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieCrewMember value)?  $default,){
final _that = this;
switch (_that) {
case _MovieCrewMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)  int gender, @HiveField(2)  int id, @HiveField(3)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)  double popularity, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(9)  String? department, @HiveField(10)  String? job)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieCrewMember() when $default != null:
return $default(_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath,_that.creditId,_that.department,_that.job);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool adult, @HiveField(1)  int gender, @HiveField(2)  int id, @HiveField(3)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)  double popularity, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(9)  String? department, @HiveField(10)  String? job)  $default,) {final _that = this;
switch (_that) {
case _MovieCrewMember():
return $default(_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath,_that.creditId,_that.department,_that.job);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool adult, @HiveField(1)  int gender, @HiveField(2)  int id, @HiveField(3)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(4)  String name, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)  double popularity, @HiveField(7)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(8)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(9)  String? department, @HiveField(10)  String? job)?  $default,) {final _that = this;
switch (_that) {
case _MovieCrewMember() when $default != null:
return $default(_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath,_that.creditId,_that.department,_that.job);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieCrewMember implements MovieCrewMember {
   _MovieCrewMember({@HiveField(0) this.adult = true, @HiveField(1) this.gender = 0, @HiveField(2) this.id = 0, @HiveField(3)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(4) required this.name, @HiveField(5)@JsonKey(name: 'original_name') this.originalName, @HiveField(6) this.popularity = 0.0, @HiveField(7)@JsonKey(name: 'profile_path') this.profilePath, @HiveField(8)@JsonKey(name: 'credit_id') this.creditId, @HiveField(9) this.department, @HiveField(10) this.job});
  factory _MovieCrewMember.fromJson(Map<String, dynamic> json) => _$MovieCrewMemberFromJson(json);

@override@JsonKey()@HiveField(0) final  bool adult;
@override@JsonKey()@HiveField(1) final  int gender;
@override@JsonKey()@HiveField(2) final  int id;
@override@HiveField(3)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(4) final  String name;
@override@HiveField(5)@JsonKey(name: 'original_name') final  String? originalName;
@override@JsonKey()@HiveField(6) final  double popularity;
@override@HiveField(7)@JsonKey(name: 'profile_path') final  String? profilePath;
@override@HiveField(8)@JsonKey(name: 'credit_id') final  String? creditId;
@override@HiveField(9) final  String? department;
@override@HiveField(10) final  String? job;

/// Create a copy of MovieCrewMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieCrewMemberCopyWith<_MovieCrewMember> get copyWith => __$MovieCrewMemberCopyWithImpl<_MovieCrewMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieCrewMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieCrewMember&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath,creditId,department,job);

@override
String toString() {
  return 'MovieCrewMember(adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath, creditId: $creditId, department: $department, job: $job)';
}


}

/// @nodoc
abstract mixin class _$MovieCrewMemberCopyWith<$Res> implements $MovieCrewMemberCopyWith<$Res> {
  factory _$MovieCrewMemberCopyWith(_MovieCrewMember value, $Res Function(_MovieCrewMember) _then) = __$MovieCrewMemberCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool adult,@HiveField(1) int gender,@HiveField(2) int id,@HiveField(3)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(4) String name,@HiveField(5)@JsonKey(name: 'original_name') String? originalName,@HiveField(6) double popularity,@HiveField(7)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(8)@JsonKey(name: 'credit_id') String? creditId,@HiveField(9) String? department,@HiveField(10) String? job
});




}
/// @nodoc
class __$MovieCrewMemberCopyWithImpl<$Res>
    implements _$MovieCrewMemberCopyWith<$Res> {
  __$MovieCrewMemberCopyWithImpl(this._self, this._then);

  final _MovieCrewMember _self;
  final $Res Function(_MovieCrewMember) _then;

/// Create a copy of MovieCrewMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,Object? creditId = freezed,Object? department = freezed,Object? job = freezed,}) {
  return _then(_MovieCrewMember(
adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
