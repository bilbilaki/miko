// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
WatchProgress _$WatchProgressFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'movie':
          return WatchProgressMovie.fromJson(
            json
          );
                case 'episode':
          return WatchProgressEpisode.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'WatchProgress',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$WatchProgress {

// Store Duration directly; requires registering DurationAdapter
@HiveField(2)@HiveField(5) Duration get duration;
/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProgressCopyWith<WatchProgress> get copyWith => _$WatchProgressCopyWithImpl<WatchProgress>(this as WatchProgress, _$identity);

  /// Serializes this WatchProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProgress&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,duration);

@override
String toString() {
  return 'WatchProgress(duration: $duration)';
}


}

/// @nodoc
abstract mixin class $WatchProgressCopyWith<$Res>  {
  factory $WatchProgressCopyWith(WatchProgress value, $Res Function(WatchProgress) _then) = _$WatchProgressCopyWithImpl;
@useResult
$Res call({
@HiveField(2) Duration duration
});




}
/// @nodoc
class _$WatchProgressCopyWithImpl<$Res>
    implements $WatchProgressCopyWith<$Res> {
  _$WatchProgressCopyWithImpl(this._self, this._then);

  final WatchProgress _self;
  final $Res Function(WatchProgress) _then;

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,}) {
  return _then(_self.copyWith(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchProgress].
extension WatchProgressPatterns on WatchProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WatchProgressMovie value)?  movie,TResult Function( WatchProgressEpisode value)?  episode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WatchProgressMovie() when movie != null:
return movie(_that);case WatchProgressEpisode() when episode != null:
return episode(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WatchProgressMovie value)  movie,required TResult Function( WatchProgressEpisode value)  episode,}){
final _that = this;
switch (_that) {
case WatchProgressMovie():
return movie(_that);case WatchProgressEpisode():
return episode(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WatchProgressMovie value)?  movie,TResult? Function( WatchProgressEpisode value)?  episode,}){
final _that = this;
switch (_that) {
case WatchProgressMovie() when movie != null:
return movie(_that);case WatchProgressEpisode() when episode != null:
return episode(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@HiveField(0)  String id, @HiveField(1)  String? playedUrl, @HiveField(2)  Duration duration)?  movie,TResult Function(@HiveField(0)  WatchProgressType type, @HiveField(1)  String seriesId, @HiveField(2)  String seriesName, @HiveField(3)  int itemId, @HiveField(4)  int seasonNumber, @HiveField(5)  Duration duration)?  episode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WatchProgressMovie() when movie != null:
return movie(_that.id,_that.playedUrl,_that.duration);case WatchProgressEpisode() when episode != null:
return episode(_that.type,_that.seriesId,_that.seriesName,_that.itemId,_that.seasonNumber,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@HiveField(0)  String id, @HiveField(1)  String? playedUrl, @HiveField(2)  Duration duration)  movie,required TResult Function(@HiveField(0)  WatchProgressType type, @HiveField(1)  String seriesId, @HiveField(2)  String seriesName, @HiveField(3)  int itemId, @HiveField(4)  int seasonNumber, @HiveField(5)  Duration duration)  episode,}) {final _that = this;
switch (_that) {
case WatchProgressMovie():
return movie(_that.id,_that.playedUrl,_that.duration);case WatchProgressEpisode():
return episode(_that.type,_that.seriesId,_that.seriesName,_that.itemId,_that.seasonNumber,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@HiveField(0)  String id, @HiveField(1)  String? playedUrl, @HiveField(2)  Duration duration)?  movie,TResult? Function(@HiveField(0)  WatchProgressType type, @HiveField(1)  String seriesId, @HiveField(2)  String seriesName, @HiveField(3)  int itemId, @HiveField(4)  int seasonNumber, @HiveField(5)  Duration duration)?  episode,}) {final _that = this;
switch (_that) {
case WatchProgressMovie() when movie != null:
return movie(_that.id,_that.playedUrl,_that.duration);case WatchProgressEpisode() when episode != null:
return episode(_that.type,_that.seriesId,_that.seriesName,_that.itemId,_that.seasonNumber,_that.duration);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 231, adapterName: 'WatchProgressMovieAdapter')
class WatchProgressMovie extends WatchProgress {
  const WatchProgressMovie({@HiveField(0) required this.id, @HiveField(1) this.playedUrl, @HiveField(2) required this.duration, final  String? $type}): $type = $type ?? 'movie',super._();
  factory WatchProgressMovie.fromJson(Map<String, dynamic> json) => _$WatchProgressMovieFromJson(json);

@HiveField(0) final  String id;
@HiveField(1) final  String? playedUrl;
// Store Duration directly; requires registering DurationAdapter
@override@HiveField(2) final  Duration duration;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProgressMovieCopyWith<WatchProgressMovie> get copyWith => _$WatchProgressMovieCopyWithImpl<WatchProgressMovie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchProgressMovieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProgressMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.playedUrl, playedUrl) || other.playedUrl == playedUrl)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,playedUrl,duration);

@override
String toString() {
  return 'WatchProgress.movie(id: $id, playedUrl: $playedUrl, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $WatchProgressMovieCopyWith<$Res> implements $WatchProgressCopyWith<$Res> {
  factory $WatchProgressMovieCopyWith(WatchProgressMovie value, $Res Function(WatchProgressMovie) _then) = _$WatchProgressMovieCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String? playedUrl,@HiveField(2) Duration duration
});




}
/// @nodoc
class _$WatchProgressMovieCopyWithImpl<$Res>
    implements $WatchProgressMovieCopyWith<$Res> {
  _$WatchProgressMovieCopyWithImpl(this._self, this._then);

  final WatchProgressMovie _self;
  final $Res Function(WatchProgressMovie) _then;

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playedUrl = freezed,Object? duration = null,}) {
  return _then(WatchProgressMovie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playedUrl: freezed == playedUrl ? _self.playedUrl : playedUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 232, adapterName: 'WatchProgressEpisodeAdapter')
class WatchProgressEpisode extends WatchProgress {
  const WatchProgressEpisode({@HiveField(0) required this.type, @HiveField(1) required this.seriesId, @HiveField(2) required this.seriesName, @HiveField(3) required this.itemId, @HiveField(4) required this.seasonNumber, @HiveField(5) required this.duration, final  String? $type}): $type = $type ?? 'episode',super._();
  factory WatchProgressEpisode.fromJson(Map<String, dynamic> json) => _$WatchProgressEpisodeFromJson(json);

// tvSeries or anime
@HiveField(0) final  WatchProgressType type;
@HiveField(1) final  String seriesId;
@HiveField(2) final  String seriesName;
@HiveField(3) final  int itemId;
@HiveField(4) final  int seasonNumber;
// Store Duration directly; requires registering DurationAdapter
@override@HiveField(5) final  Duration duration;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProgressEpisodeCopyWith<WatchProgressEpisode> get copyWith => _$WatchProgressEpisodeCopyWithImpl<WatchProgressEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchProgressEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProgressEpisode&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,seriesId,seriesName,itemId,seasonNumber,duration);

@override
String toString() {
  return 'WatchProgress.episode(type: $type, seriesId: $seriesId, seriesName: $seriesName, itemId: $itemId, seasonNumber: $seasonNumber, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $WatchProgressEpisodeCopyWith<$Res> implements $WatchProgressCopyWith<$Res> {
  factory $WatchProgressEpisodeCopyWith(WatchProgressEpisode value, $Res Function(WatchProgressEpisode) _then) = _$WatchProgressEpisodeCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) WatchProgressType type,@HiveField(1) String seriesId,@HiveField(2) String seriesName,@HiveField(3) int itemId,@HiveField(4) int seasonNumber,@HiveField(5) Duration duration
});




}
/// @nodoc
class _$WatchProgressEpisodeCopyWithImpl<$Res>
    implements $WatchProgressEpisodeCopyWith<$Res> {
  _$WatchProgressEpisodeCopyWithImpl(this._self, this._then);

  final WatchProgressEpisode _self;
  final $Res Function(WatchProgressEpisode) _then;

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seriesId = null,Object? seriesName = null,Object? itemId = null,Object? seasonNumber = null,Object? duration = null,}) {
  return _then(WatchProgressEpisode(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WatchProgressType,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seriesName: null == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
