// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watched_tracker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
WatchedTracker _$WatchedTrackerFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'movie':
          return WatchedTrackerMovie.fromJson(
            json
          );
                case 'seriesEpisode':
          return WatchedTrackerSeriesEpisode.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'WatchedTracker',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$WatchedTracker {



  /// Serializes this WatchedTracker to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedTracker);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WatchedTracker()';
}


}

/// @nodoc
class $WatchedTrackerCopyWith<$Res>  {
$WatchedTrackerCopyWith(WatchedTracker _, $Res Function(WatchedTracker) __);
}


/// Adds pattern-matching-related methods to [WatchedTracker].
extension WatchedTrackerPatterns on WatchedTracker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WatchedTrackerMovie value)?  movie,TResult Function( WatchedTrackerSeriesEpisode value)?  seriesEpisode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WatchedTrackerMovie() when movie != null:
return movie(_that);case WatchedTrackerSeriesEpisode() when seriesEpisode != null:
return seriesEpisode(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WatchedTrackerMovie value)  movie,required TResult Function( WatchedTrackerSeriesEpisode value)  seriesEpisode,}){
final _that = this;
switch (_that) {
case WatchedTrackerMovie():
return movie(_that);case WatchedTrackerSeriesEpisode():
return seriesEpisode(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WatchedTrackerMovie value)?  movie,TResult? Function( WatchedTrackerSeriesEpisode value)?  seriesEpisode,}){
final _that = this;
switch (_that) {
case WatchedTrackerMovie() when movie != null:
return movie(_that);case WatchedTrackerSeriesEpisode() when seriesEpisode != null:
return seriesEpisode(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@HiveField(0)  String id, @HiveField(1)  String? playedUrl)?  movie,TResult Function(@HiveField(0)  WatchedTrackerType type, @HiveField(1)  String seriesId, @HiveField(2)  String seriesName, @HiveField(3)  int itemId, @HiveField(4)  int seasonNumber)?  seriesEpisode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WatchedTrackerMovie() when movie != null:
return movie(_that.id,_that.playedUrl);case WatchedTrackerSeriesEpisode() when seriesEpisode != null:
return seriesEpisode(_that.type,_that.seriesId,_that.seriesName,_that.itemId,_that.seasonNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@HiveField(0)  String id, @HiveField(1)  String? playedUrl)  movie,required TResult Function(@HiveField(0)  WatchedTrackerType type, @HiveField(1)  String seriesId, @HiveField(2)  String seriesName, @HiveField(3)  int itemId, @HiveField(4)  int seasonNumber)  seriesEpisode,}) {final _that = this;
switch (_that) {
case WatchedTrackerMovie():
return movie(_that.id,_that.playedUrl);case WatchedTrackerSeriesEpisode():
return seriesEpisode(_that.type,_that.seriesId,_that.seriesName,_that.itemId,_that.seasonNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@HiveField(0)  String id, @HiveField(1)  String? playedUrl)?  movie,TResult? Function(@HiveField(0)  WatchedTrackerType type, @HiveField(1)  String seriesId, @HiveField(2)  String seriesName, @HiveField(3)  int itemId, @HiveField(4)  int seasonNumber)?  seriesEpisode,}) {final _that = this;
switch (_that) {
case WatchedTrackerMovie() when movie != null:
return movie(_that.id,_that.playedUrl);case WatchedTrackerSeriesEpisode() when seriesEpisode != null:
return seriesEpisode(_that.type,_that.seriesId,_that.seriesName,_that.itemId,_that.seasonNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 221, adapterName: 'WatchedTrackerMovieAdapter')
class WatchedTrackerMovie extends WatchedTracker {
  const WatchedTrackerMovie({@HiveField(0) required this.id, @HiveField(1) this.playedUrl, final  String? $type}): $type = $type ?? 'movie',super._();
  factory WatchedTrackerMovie.fromJson(Map<String, dynamic> json) => _$WatchedTrackerMovieFromJson(json);

@HiveField(0) final  String id;
@HiveField(1) final  String? playedUrl;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchedTracker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedTrackerMovieCopyWith<WatchedTrackerMovie> get copyWith => _$WatchedTrackerMovieCopyWithImpl<WatchedTrackerMovie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchedTrackerMovieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedTrackerMovie&&(identical(other.id, id) || other.id == id)&&(identical(other.playedUrl, playedUrl) || other.playedUrl == playedUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,playedUrl);

@override
String toString() {
  return 'WatchedTracker.movie(id: $id, playedUrl: $playedUrl)';
}


}

/// @nodoc
abstract mixin class $WatchedTrackerMovieCopyWith<$Res> implements $WatchedTrackerCopyWith<$Res> {
  factory $WatchedTrackerMovieCopyWith(WatchedTrackerMovie value, $Res Function(WatchedTrackerMovie) _then) = _$WatchedTrackerMovieCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String? playedUrl
});




}
/// @nodoc
class _$WatchedTrackerMovieCopyWithImpl<$Res>
    implements $WatchedTrackerMovieCopyWith<$Res> {
  _$WatchedTrackerMovieCopyWithImpl(this._self, this._then);

  final WatchedTrackerMovie _self;
  final $Res Function(WatchedTrackerMovie) _then;

/// Create a copy of WatchedTracker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playedUrl = freezed,}) {
  return _then(WatchedTrackerMovie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playedUrl: freezed == playedUrl ? _self.playedUrl : playedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 222, adapterName: 'WatchedTrackerSeriesEpisodeAdapter')
class WatchedTrackerSeriesEpisode extends WatchedTracker {
  const WatchedTrackerSeriesEpisode({@HiveField(0) required this.type, @HiveField(1) required this.seriesId, @HiveField(2) required this.seriesName, @HiveField(3) required this.itemId, @HiveField(4) required this.seasonNumber, final  String? $type}): $type = $type ?? 'seriesEpisode',super._();
  factory WatchedTrackerSeriesEpisode.fromJson(Map<String, dynamic> json) => _$WatchedTrackerSeriesEpisodeFromJson(json);

@HiveField(0) final  WatchedTrackerType type;
// tvSeries or anime
@HiveField(1) final  String seriesId;
@HiveField(2) final  String seriesName;
@HiveField(3) final  int itemId;
// episode id/number
@HiveField(4) final  int seasonNumber;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchedTracker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedTrackerSeriesEpisodeCopyWith<WatchedTrackerSeriesEpisode> get copyWith => _$WatchedTrackerSeriesEpisodeCopyWithImpl<WatchedTrackerSeriesEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchedTrackerSeriesEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedTrackerSeriesEpisode&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,seriesId,seriesName,itemId,seasonNumber);

@override
String toString() {
  return 'WatchedTracker.seriesEpisode(type: $type, seriesId: $seriesId, seriesName: $seriesName, itemId: $itemId, seasonNumber: $seasonNumber)';
}


}

/// @nodoc
abstract mixin class $WatchedTrackerSeriesEpisodeCopyWith<$Res> implements $WatchedTrackerCopyWith<$Res> {
  factory $WatchedTrackerSeriesEpisodeCopyWith(WatchedTrackerSeriesEpisode value, $Res Function(WatchedTrackerSeriesEpisode) _then) = _$WatchedTrackerSeriesEpisodeCopyWithImpl;
@useResult
$Res call({
@HiveField(0) WatchedTrackerType type,@HiveField(1) String seriesId,@HiveField(2) String seriesName,@HiveField(3) int itemId,@HiveField(4) int seasonNumber
});




}
/// @nodoc
class _$WatchedTrackerSeriesEpisodeCopyWithImpl<$Res>
    implements $WatchedTrackerSeriesEpisodeCopyWith<$Res> {
  _$WatchedTrackerSeriesEpisodeCopyWithImpl(this._self, this._then);

  final WatchedTrackerSeriesEpisode _self;
  final $Res Function(WatchedTrackerSeriesEpisode) _then;

/// Create a copy of WatchedTracker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seriesId = null,Object? seriesName = null,Object? itemId = null,Object? seasonNumber = null,}) {
  return _then(WatchedTrackerSeriesEpisode(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WatchedTrackerType,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seriesName: null == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
