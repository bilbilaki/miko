// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeasonSummary {

@HiveField(0)@JsonKey(name: 'air_date') String? get airDate;@HiveField(1)@JsonKey(name: 'episode_count') int get episodeCount;@HiveField(2) int get id;@HiveField(3) String get name;@HiveField(4)@JsonKey(name: 'overview') String? get overview;@HiveField(5)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(6)@JsonKey(name: 'season_number') int get seasonNumber;
/// Create a copy of SeasonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonSummaryCopyWith<SeasonSummary> get copyWith => _$SeasonSummaryCopyWithImpl<SeasonSummary>(this as SeasonSummary, _$identity);

  /// Serializes this SeasonSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonSummary&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,airDate,episodeCount,id,name,overview,posterPath,seasonNumber);

@override
String toString() {
  return 'SeasonSummary(airDate: $airDate, episodeCount: $episodeCount, id: $id, name: $name, overview: $overview, posterPath: $posterPath, seasonNumber: $seasonNumber)';
}


}

/// @nodoc
abstract mixin class $SeasonSummaryCopyWith<$Res>  {
  factory $SeasonSummaryCopyWith(SeasonSummary value, $Res Function(SeasonSummary) _then) = _$SeasonSummaryCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'air_date') String? airDate,@HiveField(1)@JsonKey(name: 'episode_count') int episodeCount,@HiveField(2) int id,@HiveField(3) String name,@HiveField(4)@JsonKey(name: 'overview') String? overview,@HiveField(5)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(6)@JsonKey(name: 'season_number') int seasonNumber
});




}
/// @nodoc
class _$SeasonSummaryCopyWithImpl<$Res>
    implements $SeasonSummaryCopyWith<$Res> {
  _$SeasonSummaryCopyWithImpl(this._self, this._then);

  final SeasonSummary _self;
  final $Res Function(SeasonSummary) _then;

/// Create a copy of SeasonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? airDate = freezed,Object? episodeCount = null,Object? id = null,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? seasonNumber = null,}) {
  return _then(_self.copyWith(
airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonSummary].
extension SeasonSummaryPatterns on SeasonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonSummary value)  $default,){
final _that = this;
switch (_that) {
case _SeasonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'air_date')  String? airDate, @HiveField(1)@JsonKey(name: 'episode_count')  int episodeCount, @HiveField(2)  int id, @HiveField(3)  String name, @HiveField(4)@JsonKey(name: 'overview')  String? overview, @HiveField(5)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(6)@JsonKey(name: 'season_number')  int seasonNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonSummary() when $default != null:
return $default(_that.airDate,_that.episodeCount,_that.id,_that.name,_that.overview,_that.posterPath,_that.seasonNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'air_date')  String? airDate, @HiveField(1)@JsonKey(name: 'episode_count')  int episodeCount, @HiveField(2)  int id, @HiveField(3)  String name, @HiveField(4)@JsonKey(name: 'overview')  String? overview, @HiveField(5)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(6)@JsonKey(name: 'season_number')  int seasonNumber)  $default,) {final _that = this;
switch (_that) {
case _SeasonSummary():
return $default(_that.airDate,_that.episodeCount,_that.id,_that.name,_that.overview,_that.posterPath,_that.seasonNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'air_date')  String? airDate, @HiveField(1)@JsonKey(name: 'episode_count')  int episodeCount, @HiveField(2)  int id, @HiveField(3)  String name, @HiveField(4)@JsonKey(name: 'overview')  String? overview, @HiveField(5)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(6)@JsonKey(name: 'season_number')  int seasonNumber)?  $default,) {final _that = this;
switch (_that) {
case _SeasonSummary() when $default != null:
return $default(_that.airDate,_that.episodeCount,_that.id,_that.name,_that.overview,_that.posterPath,_that.seasonNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _SeasonSummary implements SeasonSummary {
  const _SeasonSummary({@HiveField(0)@JsonKey(name: 'air_date') this.airDate, @HiveField(1)@JsonKey(name: 'episode_count') required this.episodeCount, @HiveField(2) required this.id, @HiveField(3) required this.name, @HiveField(4)@JsonKey(name: 'overview') this.overview, @HiveField(5)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(6)@JsonKey(name: 'season_number') required this.seasonNumber});
  factory _SeasonSummary.fromJson(Map<String, dynamic> json) => _$SeasonSummaryFromJson(json);

@override@HiveField(0)@JsonKey(name: 'air_date') final  String? airDate;
@override@HiveField(1)@JsonKey(name: 'episode_count') final  int episodeCount;
@override@HiveField(2) final  int id;
@override@HiveField(3) final  String name;
@override@HiveField(4)@JsonKey(name: 'overview') final  String? overview;
@override@HiveField(5)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(6)@JsonKey(name: 'season_number') final  int seasonNumber;

/// Create a copy of SeasonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonSummaryCopyWith<_SeasonSummary> get copyWith => __$SeasonSummaryCopyWithImpl<_SeasonSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonSummary&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,airDate,episodeCount,id,name,overview,posterPath,seasonNumber);

@override
String toString() {
  return 'SeasonSummary(airDate: $airDate, episodeCount: $episodeCount, id: $id, name: $name, overview: $overview, posterPath: $posterPath, seasonNumber: $seasonNumber)';
}


}

/// @nodoc
abstract mixin class _$SeasonSummaryCopyWith<$Res> implements $SeasonSummaryCopyWith<$Res> {
  factory _$SeasonSummaryCopyWith(_SeasonSummary value, $Res Function(_SeasonSummary) _then) = __$SeasonSummaryCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'air_date') String? airDate,@HiveField(1)@JsonKey(name: 'episode_count') int episodeCount,@HiveField(2) int id,@HiveField(3) String name,@HiveField(4)@JsonKey(name: 'overview') String? overview,@HiveField(5)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(6)@JsonKey(name: 'season_number') int seasonNumber
});




}
/// @nodoc
class __$SeasonSummaryCopyWithImpl<$Res>
    implements _$SeasonSummaryCopyWith<$Res> {
  __$SeasonSummaryCopyWithImpl(this._self, this._then);

  final _SeasonSummary _self;
  final $Res Function(_SeasonSummary) _then;

/// Create a copy of SeasonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? airDate = freezed,Object? episodeCount = null,Object? id = null,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? seasonNumber = null,}) {
  return _then(_SeasonSummary(
airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
