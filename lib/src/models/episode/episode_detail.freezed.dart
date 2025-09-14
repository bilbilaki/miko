// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpisodeDetail {

@HiveField(0)@JsonKey(name: 'air_date') String? get airDate;@HiveField(1)@JsonKey(name: 'crew') List<CrewMember>? get crew;@HiveField(2)@JsonKey(name: 'guest_stars') List<GuestStar>? get guestStars;@HiveField(3) String get name;@HiveField(4) String? get overview;@HiveField(5) int get id;@HiveField(6)@JsonKey(name: 'production_code') String? get productionCode;@HiveField(7)@JsonKey(name: 'runtime') int? get runtime;@HiveField(8)@JsonKey(name: 'season_number') int? get seasonNumber;@HiveField(9)@JsonKey(name: 'episode_number') int? get episodeNumber;@HiveField(10)@JsonKey(name: 'still_path') String? get stillPath;@HiveField(11)@JsonKey(name: 'vote_average') double? get voteAverage;@HiveField(12)@JsonKey(name: 'vote_count') int? get voteCount;
/// Create a copy of EpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeDetailCopyWith<EpisodeDetail> get copyWith => _$EpisodeDetailCopyWithImpl<EpisodeDetail>(this as EpisodeDetail, _$identity);

  /// Serializes this EpisodeDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeDetail&&(identical(other.airDate, airDate) || other.airDate == airDate)&&const DeepCollectionEquality().equals(other.crew, crew)&&const DeepCollectionEquality().equals(other.guestStars, guestStars)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.id, id) || other.id == id)&&(identical(other.productionCode, productionCode) || other.productionCode == productionCode)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,airDate,const DeepCollectionEquality().hash(crew),const DeepCollectionEquality().hash(guestStars),name,overview,id,productionCode,runtime,seasonNumber,episodeNumber,stillPath,voteAverage,voteCount);

@override
String toString() {
  return 'EpisodeDetail(airDate: $airDate, crew: $crew, guestStars: $guestStars, name: $name, overview: $overview, id: $id, productionCode: $productionCode, runtime: $runtime, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, stillPath: $stillPath, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class $EpisodeDetailCopyWith<$Res>  {
  factory $EpisodeDetailCopyWith(EpisodeDetail value, $Res Function(EpisodeDetail) _then) = _$EpisodeDetailCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'air_date') String? airDate,@HiveField(1)@JsonKey(name: 'crew') List<CrewMember>? crew,@HiveField(2)@JsonKey(name: 'guest_stars') List<GuestStar>? guestStars,@HiveField(3) String name,@HiveField(4) String? overview,@HiveField(5) int id,@HiveField(6)@JsonKey(name: 'production_code') String? productionCode,@HiveField(7)@JsonKey(name: 'runtime') int? runtime,@HiveField(8)@JsonKey(name: 'season_number') int? seasonNumber,@HiveField(9)@JsonKey(name: 'episode_number') int? episodeNumber,@HiveField(10)@JsonKey(name: 'still_path') String? stillPath,@HiveField(11)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(12)@JsonKey(name: 'vote_count') int? voteCount
});




}
/// @nodoc
class _$EpisodeDetailCopyWithImpl<$Res>
    implements $EpisodeDetailCopyWith<$Res> {
  _$EpisodeDetailCopyWithImpl(this._self, this._then);

  final EpisodeDetail _self;
  final $Res Function(EpisodeDetail) _then;

/// Create a copy of EpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? airDate = freezed,Object? crew = freezed,Object? guestStars = freezed,Object? name = null,Object? overview = freezed,Object? id = null,Object? productionCode = freezed,Object? runtime = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? stillPath = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,}) {
  return _then(_self.copyWith(
airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,crew: freezed == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as List<CrewMember>?,guestStars: freezed == guestStars ? _self.guestStars : guestStars // ignore: cast_nullable_to_non_nullable
as List<GuestStar>?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productionCode: freezed == productionCode ? _self.productionCode : productionCode // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeDetail].
extension EpisodeDetailPatterns on EpisodeDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeDetail value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'air_date')  String? airDate, @HiveField(1)@JsonKey(name: 'crew')  List<CrewMember>? crew, @HiveField(2)@JsonKey(name: 'guest_stars')  List<GuestStar>? guestStars, @HiveField(3)  String name, @HiveField(4)  String? overview, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'production_code')  String? productionCode, @HiveField(7)@JsonKey(name: 'runtime')  int? runtime, @HiveField(8)@JsonKey(name: 'season_number')  int? seasonNumber, @HiveField(9)@JsonKey(name: 'episode_number')  int? episodeNumber, @HiveField(10)@JsonKey(name: 'still_path')  String? stillPath, @HiveField(11)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(12)@JsonKey(name: 'vote_count')  int? voteCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeDetail() when $default != null:
return $default(_that.airDate,_that.crew,_that.guestStars,_that.name,_that.overview,_that.id,_that.productionCode,_that.runtime,_that.seasonNumber,_that.episodeNumber,_that.stillPath,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'air_date')  String? airDate, @HiveField(1)@JsonKey(name: 'crew')  List<CrewMember>? crew, @HiveField(2)@JsonKey(name: 'guest_stars')  List<GuestStar>? guestStars, @HiveField(3)  String name, @HiveField(4)  String? overview, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'production_code')  String? productionCode, @HiveField(7)@JsonKey(name: 'runtime')  int? runtime, @HiveField(8)@JsonKey(name: 'season_number')  int? seasonNumber, @HiveField(9)@JsonKey(name: 'episode_number')  int? episodeNumber, @HiveField(10)@JsonKey(name: 'still_path')  String? stillPath, @HiveField(11)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(12)@JsonKey(name: 'vote_count')  int? voteCount)  $default,) {final _that = this;
switch (_that) {
case _EpisodeDetail():
return $default(_that.airDate,_that.crew,_that.guestStars,_that.name,_that.overview,_that.id,_that.productionCode,_that.runtime,_that.seasonNumber,_that.episodeNumber,_that.stillPath,_that.voteAverage,_that.voteCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'air_date')  String? airDate, @HiveField(1)@JsonKey(name: 'crew')  List<CrewMember>? crew, @HiveField(2)@JsonKey(name: 'guest_stars')  List<GuestStar>? guestStars, @HiveField(3)  String name, @HiveField(4)  String? overview, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'production_code')  String? productionCode, @HiveField(7)@JsonKey(name: 'runtime')  int? runtime, @HiveField(8)@JsonKey(name: 'season_number')  int? seasonNumber, @HiveField(9)@JsonKey(name: 'episode_number')  int? episodeNumber, @HiveField(10)@JsonKey(name: 'still_path')  String? stillPath, @HiveField(11)@JsonKey(name: 'vote_average')  double? voteAverage, @HiveField(12)@JsonKey(name: 'vote_count')  int? voteCount)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeDetail() when $default != null:
return $default(_that.airDate,_that.crew,_that.guestStars,_that.name,_that.overview,_that.id,_that.productionCode,_that.runtime,_that.seasonNumber,_that.episodeNumber,_that.stillPath,_that.voteAverage,_that.voteCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EpisodeDetail implements EpisodeDetail {
   _EpisodeDetail({@HiveField(0)@JsonKey(name: 'air_date') this.airDate, @HiveField(1)@JsonKey(name: 'crew') final  List<CrewMember>? crew, @HiveField(2)@JsonKey(name: 'guest_stars') final  List<GuestStar>? guestStars, @HiveField(3) required this.name, @HiveField(4) this.overview, @HiveField(5) required this.id, @HiveField(6)@JsonKey(name: 'production_code') this.productionCode, @HiveField(7)@JsonKey(name: 'runtime') this.runtime, @HiveField(8)@JsonKey(name: 'season_number') this.seasonNumber, @HiveField(9)@JsonKey(name: 'episode_number') this.episodeNumber, @HiveField(10)@JsonKey(name: 'still_path') this.stillPath, @HiveField(11)@JsonKey(name: 'vote_average') this.voteAverage, @HiveField(12)@JsonKey(name: 'vote_count') this.voteCount}): _crew = crew,_guestStars = guestStars;
  factory _EpisodeDetail.fromJson(Map<String, dynamic> json) => _$EpisodeDetailFromJson(json);

@override@HiveField(0)@JsonKey(name: 'air_date') final  String? airDate;
 final  List<CrewMember>? _crew;
@override@HiveField(1)@JsonKey(name: 'crew') List<CrewMember>? get crew {
  final value = _crew;
  if (value == null) return null;
  if (_crew is EqualUnmodifiableListView) return _crew;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<GuestStar>? _guestStars;
@override@HiveField(2)@JsonKey(name: 'guest_stars') List<GuestStar>? get guestStars {
  final value = _guestStars;
  if (value == null) return null;
  if (_guestStars is EqualUnmodifiableListView) return _guestStars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(3) final  String name;
@override@HiveField(4) final  String? overview;
@override@HiveField(5) final  int id;
@override@HiveField(6)@JsonKey(name: 'production_code') final  String? productionCode;
@override@HiveField(7)@JsonKey(name: 'runtime') final  int? runtime;
@override@HiveField(8)@JsonKey(name: 'season_number') final  int? seasonNumber;
@override@HiveField(9)@JsonKey(name: 'episode_number') final  int? episodeNumber;
@override@HiveField(10)@JsonKey(name: 'still_path') final  String? stillPath;
@override@HiveField(11)@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@HiveField(12)@JsonKey(name: 'vote_count') final  int? voteCount;

/// Create a copy of EpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeDetailCopyWith<_EpisodeDetail> get copyWith => __$EpisodeDetailCopyWithImpl<_EpisodeDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeDetail&&(identical(other.airDate, airDate) || other.airDate == airDate)&&const DeepCollectionEquality().equals(other._crew, _crew)&&const DeepCollectionEquality().equals(other._guestStars, _guestStars)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.id, id) || other.id == id)&&(identical(other.productionCode, productionCode) || other.productionCode == productionCode)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,airDate,const DeepCollectionEquality().hash(_crew),const DeepCollectionEquality().hash(_guestStars),name,overview,id,productionCode,runtime,seasonNumber,episodeNumber,stillPath,voteAverage,voteCount);

@override
String toString() {
  return 'EpisodeDetail(airDate: $airDate, crew: $crew, guestStars: $guestStars, name: $name, overview: $overview, id: $id, productionCode: $productionCode, runtime: $runtime, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, stillPath: $stillPath, voteAverage: $voteAverage, voteCount: $voteCount)';
}


}

/// @nodoc
abstract mixin class _$EpisodeDetailCopyWith<$Res> implements $EpisodeDetailCopyWith<$Res> {
  factory _$EpisodeDetailCopyWith(_EpisodeDetail value, $Res Function(_EpisodeDetail) _then) = __$EpisodeDetailCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'air_date') String? airDate,@HiveField(1)@JsonKey(name: 'crew') List<CrewMember>? crew,@HiveField(2)@JsonKey(name: 'guest_stars') List<GuestStar>? guestStars,@HiveField(3) String name,@HiveField(4) String? overview,@HiveField(5) int id,@HiveField(6)@JsonKey(name: 'production_code') String? productionCode,@HiveField(7)@JsonKey(name: 'runtime') int? runtime,@HiveField(8)@JsonKey(name: 'season_number') int? seasonNumber,@HiveField(9)@JsonKey(name: 'episode_number') int? episodeNumber,@HiveField(10)@JsonKey(name: 'still_path') String? stillPath,@HiveField(11)@JsonKey(name: 'vote_average') double? voteAverage,@HiveField(12)@JsonKey(name: 'vote_count') int? voteCount
});




}
/// @nodoc
class __$EpisodeDetailCopyWithImpl<$Res>
    implements _$EpisodeDetailCopyWith<$Res> {
  __$EpisodeDetailCopyWithImpl(this._self, this._then);

  final _EpisodeDetail _self;
  final $Res Function(_EpisodeDetail) _then;

/// Create a copy of EpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? airDate = freezed,Object? crew = freezed,Object? guestStars = freezed,Object? name = null,Object? overview = freezed,Object? id = null,Object? productionCode = freezed,Object? runtime = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? stillPath = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,}) {
  return _then(_EpisodeDetail(
airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,crew: freezed == crew ? _self._crew : crew // ignore: cast_nullable_to_non_nullable
as List<CrewMember>?,guestStars: freezed == guestStars ? _self._guestStars : guestStars // ignore: cast_nullable_to_non_nullable
as List<GuestStar>?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productionCode: freezed == productionCode ? _self.productionCode : productionCode // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CrewMember {

@HiveField(0) String? get department;@HiveField(1) String? get job;@HiveField(2)@JsonKey(name: 'credit_id') String? get creditId;@HiveField(3) bool get adult;@HiveField(4) int get gender;@HiveField(5) int get id;@HiveField(6)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(7) String get name;@HiveField(8)@JsonKey(name: 'original_name') String? get originalName;@HiveField(9) double get popularity;@HiveField(10)@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewMemberCopyWith<CrewMember> get copyWith => _$CrewMemberCopyWithImpl<CrewMember>(this as CrewMember, _$identity);

  /// Serializes this CrewMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewMember&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,department,job,creditId,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath);

@override
String toString() {
  return 'CrewMember(department: $department, job: $job, creditId: $creditId, adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $CrewMemberCopyWith<$Res>  {
  factory $CrewMemberCopyWith(CrewMember value, $Res Function(CrewMember) _then) = _$CrewMemberCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String? department,@HiveField(1) String? job,@HiveField(2)@JsonKey(name: 'credit_id') String? creditId,@HiveField(3) bool adult,@HiveField(4) int gender,@HiveField(5) int id,@HiveField(6)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(7) String name,@HiveField(8)@JsonKey(name: 'original_name') String? originalName,@HiveField(9) double popularity,@HiveField(10)@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$CrewMemberCopyWithImpl<$Res>
    implements $CrewMemberCopyWith<$Res> {
  _$CrewMemberCopyWithImpl(this._self, this._then);

  final CrewMember _self;
  final $Res Function(CrewMember) _then;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? department = freezed,Object? job = freezed,Object? creditId = freezed,Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,}) {
  return _then(_self.copyWith(
department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewMember].
extension CrewMemberPatterns on CrewMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewMember value)  $default,){
final _that = this;
switch (_that) {
case _CrewMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewMember value)?  $default,){
final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String? department, @HiveField(1)  String? job, @HiveField(2)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(3)  bool adult, @HiveField(4)  int gender, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(7)  String name, @HiveField(8)@JsonKey(name: 'original_name')  String? originalName, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
return $default(_that.department,_that.job,_that.creditId,_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String? department, @HiveField(1)  String? job, @HiveField(2)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(3)  bool adult, @HiveField(4)  int gender, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(7)  String name, @HiveField(8)@JsonKey(name: 'original_name')  String? originalName, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _CrewMember():
return $default(_that.department,_that.job,_that.creditId,_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String? department, @HiveField(1)  String? job, @HiveField(2)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(3)  bool adult, @HiveField(4)  int gender, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(7)  String name, @HiveField(8)@JsonKey(name: 'original_name')  String? originalName, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
return $default(_that.department,_that.job,_that.creditId,_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _CrewMember implements CrewMember {
   _CrewMember({@HiveField(0) this.department, @HiveField(1) this.job, @HiveField(2)@JsonKey(name: 'credit_id') this.creditId, @HiveField(3) this.adult = true, @HiveField(4) this.gender = 0, @HiveField(5) this.id = 0, @HiveField(6)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(7) required this.name, @HiveField(8)@JsonKey(name: 'original_name') this.originalName, @HiveField(9) this.popularity = 0.0, @HiveField(10)@JsonKey(name: 'profile_path') this.profilePath});
  factory _CrewMember.fromJson(Map<String, dynamic> json) => _$CrewMemberFromJson(json);

@override@HiveField(0) final  String? department;
@override@HiveField(1) final  String? job;
@override@HiveField(2)@JsonKey(name: 'credit_id') final  String? creditId;
@override@JsonKey()@HiveField(3) final  bool adult;
@override@JsonKey()@HiveField(4) final  int gender;
@override@JsonKey()@HiveField(5) final  int id;
@override@HiveField(6)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(7) final  String name;
@override@HiveField(8)@JsonKey(name: 'original_name') final  String? originalName;
@override@JsonKey()@HiveField(9) final  double popularity;
@override@HiveField(10)@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewMemberCopyWith<_CrewMember> get copyWith => __$CrewMemberCopyWithImpl<_CrewMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewMember&&(identical(other.department, department) || other.department == department)&&(identical(other.job, job) || other.job == job)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,department,job,creditId,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath);

@override
String toString() {
  return 'CrewMember(department: $department, job: $job, creditId: $creditId, adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$CrewMemberCopyWith<$Res> implements $CrewMemberCopyWith<$Res> {
  factory _$CrewMemberCopyWith(_CrewMember value, $Res Function(_CrewMember) _then) = __$CrewMemberCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String? department,@HiveField(1) String? job,@HiveField(2)@JsonKey(name: 'credit_id') String? creditId,@HiveField(3) bool adult,@HiveField(4) int gender,@HiveField(5) int id,@HiveField(6)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(7) String name,@HiveField(8)@JsonKey(name: 'original_name') String? originalName,@HiveField(9) double popularity,@HiveField(10)@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$CrewMemberCopyWithImpl<$Res>
    implements _$CrewMemberCopyWith<$Res> {
  __$CrewMemberCopyWithImpl(this._self, this._then);

  final _CrewMember _self;
  final $Res Function(_CrewMember) _then;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? department = freezed,Object? job = freezed,Object? creditId = freezed,Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,}) {
  return _then(_CrewMember(
department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GuestStar {

@HiveField(0) String? get character;@HiveField(1)@JsonKey(name: 'credit_id') String? get creditId;@HiveField(2) int get order;@HiveField(3) bool get adult;@HiveField(4) int get gender;@HiveField(5) int get id;@HiveField(6)@JsonKey(name: 'known_for_department') String? get knownForDepartment;@HiveField(7) String get name;@HiveField(8)@JsonKey(name: 'original_name') String? get originalName;@HiveField(9) double get popularity;@HiveField(10)@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of GuestStar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestStarCopyWith<GuestStar> get copyWith => _$GuestStarCopyWithImpl<GuestStar>(this as GuestStar, _$identity);

  /// Serializes this GuestStar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuestStar&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.order, order) || other.order == order)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,creditId,order,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath);

@override
String toString() {
  return 'GuestStar(character: $character, creditId: $creditId, order: $order, adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $GuestStarCopyWith<$Res>  {
  factory $GuestStarCopyWith(GuestStar value, $Res Function(GuestStar) _then) = _$GuestStarCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String? character,@HiveField(1)@JsonKey(name: 'credit_id') String? creditId,@HiveField(2) int order,@HiveField(3) bool adult,@HiveField(4) int gender,@HiveField(5) int id,@HiveField(6)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(7) String name,@HiveField(8)@JsonKey(name: 'original_name') String? originalName,@HiveField(9) double popularity,@HiveField(10)@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$GuestStarCopyWithImpl<$Res>
    implements $GuestStarCopyWith<$Res> {
  _$GuestStarCopyWithImpl(this._self, this._then);

  final GuestStar _self;
  final $Res Function(GuestStar) _then;

/// Create a copy of GuestStar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = freezed,Object? creditId = freezed,Object? order = null,Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,}) {
  return _then(_self.copyWith(
character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuestStar].
extension GuestStarPatterns on GuestStar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuestStar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuestStar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuestStar value)  $default,){
final _that = this;
switch (_that) {
case _GuestStar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuestStar value)?  $default,){
final _that = this;
switch (_that) {
case _GuestStar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String? character, @HiveField(1)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(2)  int order, @HiveField(3)  bool adult, @HiveField(4)  int gender, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(7)  String name, @HiveField(8)@JsonKey(name: 'original_name')  String? originalName, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuestStar() when $default != null:
return $default(_that.character,_that.creditId,_that.order,_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String? character, @HiveField(1)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(2)  int order, @HiveField(3)  bool adult, @HiveField(4)  int gender, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(7)  String name, @HiveField(8)@JsonKey(name: 'original_name')  String? originalName, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _GuestStar():
return $default(_that.character,_that.creditId,_that.order,_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String? character, @HiveField(1)@JsonKey(name: 'credit_id')  String? creditId, @HiveField(2)  int order, @HiveField(3)  bool adult, @HiveField(4)  int gender, @HiveField(5)  int id, @HiveField(6)@JsonKey(name: 'known_for_department')  String? knownForDepartment, @HiveField(7)  String name, @HiveField(8)@JsonKey(name: 'original_name')  String? originalName, @HiveField(9)  double popularity, @HiveField(10)@JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _GuestStar() when $default != null:
return $default(_that.character,_that.creditId,_that.order,_that.adult,_that.gender,_that.id,_that.knownForDepartment,_that.name,_that.originalName,_that.popularity,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _GuestStar implements GuestStar {
   _GuestStar({@HiveField(0) this.character, @HiveField(1)@JsonKey(name: 'credit_id') this.creditId, @HiveField(2) this.order = 0, @HiveField(3) this.adult = true, @HiveField(4) this.gender = 0, @HiveField(5) this.id = 0, @HiveField(6)@JsonKey(name: 'known_for_department') this.knownForDepartment, @HiveField(7) required this.name, @HiveField(8)@JsonKey(name: 'original_name') this.originalName, @HiveField(9) this.popularity = 0.0, @HiveField(10)@JsonKey(name: 'profile_path') this.profilePath});
  factory _GuestStar.fromJson(Map<String, dynamic> json) => _$GuestStarFromJson(json);

@override@HiveField(0) final  String? character;
@override@HiveField(1)@JsonKey(name: 'credit_id') final  String? creditId;
@override@JsonKey()@HiveField(2) final  int order;
@override@JsonKey()@HiveField(3) final  bool adult;
@override@JsonKey()@HiveField(4) final  int gender;
@override@JsonKey()@HiveField(5) final  int id;
@override@HiveField(6)@JsonKey(name: 'known_for_department') final  String? knownForDepartment;
@override@HiveField(7) final  String name;
@override@HiveField(8)@JsonKey(name: 'original_name') final  String? originalName;
@override@JsonKey()@HiveField(9) final  double popularity;
@override@HiveField(10)@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of GuestStar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuestStarCopyWith<_GuestStar> get copyWith => __$GuestStarCopyWithImpl<_GuestStar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuestStarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuestStar&&(identical(other.character, character) || other.character == character)&&(identical(other.creditId, creditId) || other.creditId == creditId)&&(identical(other.order, order) || other.order == order)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.id, id) || other.id == id)&&(identical(other.knownForDepartment, knownForDepartment) || other.knownForDepartment == knownForDepartment)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,character,creditId,order,adult,gender,id,knownForDepartment,name,originalName,popularity,profilePath);

@override
String toString() {
  return 'GuestStar(character: $character, creditId: $creditId, order: $order, adult: $adult, gender: $gender, id: $id, knownForDepartment: $knownForDepartment, name: $name, originalName: $originalName, popularity: $popularity, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$GuestStarCopyWith<$Res> implements $GuestStarCopyWith<$Res> {
  factory _$GuestStarCopyWith(_GuestStar value, $Res Function(_GuestStar) _then) = __$GuestStarCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String? character,@HiveField(1)@JsonKey(name: 'credit_id') String? creditId,@HiveField(2) int order,@HiveField(3) bool adult,@HiveField(4) int gender,@HiveField(5) int id,@HiveField(6)@JsonKey(name: 'known_for_department') String? knownForDepartment,@HiveField(7) String name,@HiveField(8)@JsonKey(name: 'original_name') String? originalName,@HiveField(9) double popularity,@HiveField(10)@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$GuestStarCopyWithImpl<$Res>
    implements _$GuestStarCopyWith<$Res> {
  __$GuestStarCopyWithImpl(this._self, this._then);

  final _GuestStar _self;
  final $Res Function(_GuestStar) _then;

/// Create a copy of GuestStar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = freezed,Object? creditId = freezed,Object? order = null,Object? adult = null,Object? gender = null,Object? id = null,Object? knownForDepartment = freezed,Object? name = null,Object? originalName = freezed,Object? popularity = null,Object? profilePath = freezed,}) {
  return _then(_GuestStar(
character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,creditId: freezed == creditId ? _self.creditId : creditId // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,adult: null == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,knownForDepartment: freezed == knownForDepartment ? _self.knownForDepartment : knownForDepartment // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
