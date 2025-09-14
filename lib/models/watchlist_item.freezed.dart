// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
WatchlistItem _$WatchlistItemFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'movie':
          return WatchlistMovieItem.fromJson(
            json
          );
                case 'tvSeries':
          return WatchlistTvSeriesItem.fromJson(
            json
          );
                case 'anime':
          return WatchlistAnimeItem.fromJson(
            json
          );
                case 'season':
          return WatchlistSeasonItem.fromJson(
            json
          );
                case 'episode':
          return WatchlistEpisodeItem.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'WatchlistItem',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$WatchlistItem {



  /// Serializes this WatchlistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistItem);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WatchlistItem()';
}


}

/// @nodoc
class $WatchlistItemCopyWith<$Res>  {
$WatchlistItemCopyWith(WatchlistItem _, $Res Function(WatchlistItem) __);
}


/// Adds pattern-matching-related methods to [WatchlistItem].
extension WatchlistItemPatterns on WatchlistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WatchlistMovieItem value)?  movie,TResult Function( WatchlistTvSeriesItem value)?  tvSeries,TResult Function( WatchlistAnimeItem value)?  anime,TResult Function( WatchlistSeasonItem value)?  season,TResult Function( WatchlistEpisodeItem value)?  episode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WatchlistMovieItem() when movie != null:
return movie(_that);case WatchlistTvSeriesItem() when tvSeries != null:
return tvSeries(_that);case WatchlistAnimeItem() when anime != null:
return anime(_that);case WatchlistSeasonItem() when season != null:
return season(_that);case WatchlistEpisodeItem() when episode != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WatchlistMovieItem value)  movie,required TResult Function( WatchlistTvSeriesItem value)  tvSeries,required TResult Function( WatchlistAnimeItem value)  anime,required TResult Function( WatchlistSeasonItem value)  season,required TResult Function( WatchlistEpisodeItem value)  episode,}){
final _that = this;
switch (_that) {
case WatchlistMovieItem():
return movie(_that);case WatchlistTvSeriesItem():
return tvSeries(_that);case WatchlistAnimeItem():
return anime(_that);case WatchlistSeasonItem():
return season(_that);case WatchlistEpisodeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WatchlistMovieItem value)?  movie,TResult? Function( WatchlistTvSeriesItem value)?  tvSeries,TResult? Function( WatchlistAnimeItem value)?  anime,TResult? Function( WatchlistSeasonItem value)?  season,TResult? Function( WatchlistEpisodeItem value)?  episode,}){
final _that = this;
switch (_that) {
case WatchlistMovieItem() when movie != null:
return movie(_that);case WatchlistTvSeriesItem() when tvSeries != null:
return tvSeries(_that);case WatchlistAnimeItem() when anime != null:
return anime(_that);case WatchlistSeasonItem() when season != null:
return season(_that);case WatchlistEpisodeItem() when episode != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@HiveField(0)  String id)?  movie,TResult Function(@HiveField(0)  String id)?  tvSeries,TResult Function(@HiveField(0)  String id)?  anime,TResult Function(@HiveField(0)  WatchlistItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber)?  season,TResult Function(@HiveField(0)  WatchlistItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber, @HiveField(3)  int episodeNumber)?  episode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WatchlistMovieItem() when movie != null:
return movie(_that.id);case WatchlistTvSeriesItem() when tvSeries != null:
return tvSeries(_that.id);case WatchlistAnimeItem() when anime != null:
return anime(_that.id);case WatchlistSeasonItem() when season != null:
return season(_that.type,_that.seriesId,_that.seasonNumber);case WatchlistEpisodeItem() when episode != null:
return episode(_that.type,_that.seriesId,_that.seasonNumber,_that.episodeNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@HiveField(0)  String id)  movie,required TResult Function(@HiveField(0)  String id)  tvSeries,required TResult Function(@HiveField(0)  String id)  anime,required TResult Function(@HiveField(0)  WatchlistItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber)  season,required TResult Function(@HiveField(0)  WatchlistItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber, @HiveField(3)  int episodeNumber)  episode,}) {final _that = this;
switch (_that) {
case WatchlistMovieItem():
return movie(_that.id);case WatchlistTvSeriesItem():
return tvSeries(_that.id);case WatchlistAnimeItem():
return anime(_that.id);case WatchlistSeasonItem():
return season(_that.type,_that.seriesId,_that.seasonNumber);case WatchlistEpisodeItem():
return episode(_that.type,_that.seriesId,_that.seasonNumber,_that.episodeNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@HiveField(0)  String id)?  movie,TResult? Function(@HiveField(0)  String id)?  tvSeries,TResult? Function(@HiveField(0)  String id)?  anime,TResult? Function(@HiveField(0)  WatchlistItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber)?  season,TResult? Function(@HiveField(0)  WatchlistItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber, @HiveField(3)  int episodeNumber)?  episode,}) {final _that = this;
switch (_that) {
case WatchlistMovieItem() when movie != null:
return movie(_that.id);case WatchlistTvSeriesItem() when tvSeries != null:
return tvSeries(_that.id);case WatchlistAnimeItem() when anime != null:
return anime(_that.id);case WatchlistSeasonItem() when season != null:
return season(_that.type,_that.seriesId,_that.seasonNumber);case WatchlistEpisodeItem() when episode != null:
return episode(_that.type,_that.seriesId,_that.seasonNumber,_that.episodeNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 211, adapterName: 'WatchlistMovieItemAdapter')
class WatchlistMovieItem extends WatchlistItem {
  const WatchlistMovieItem({@HiveField(0) required this.id, final  String? $type}): $type = $type ?? 'movie',super._();
  factory WatchlistMovieItem.fromJson(Map<String, dynamic> json) => _$WatchlistMovieItemFromJson(json);

@HiveField(0) final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistMovieItemCopyWith<WatchlistMovieItem> get copyWith => _$WatchlistMovieItemCopyWithImpl<WatchlistMovieItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistMovieItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistMovieItem&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'WatchlistItem.movie(id: $id)';
}


}

/// @nodoc
abstract mixin class $WatchlistMovieItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory $WatchlistMovieItemCopyWith(WatchlistMovieItem value, $Res Function(WatchlistMovieItem) _then) = _$WatchlistMovieItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id
});




}
/// @nodoc
class _$WatchlistMovieItemCopyWithImpl<$Res>
    implements $WatchlistMovieItemCopyWith<$Res> {
  _$WatchlistMovieItemCopyWithImpl(this._self, this._then);

  final WatchlistMovieItem _self;
  final $Res Function(WatchlistMovieItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(WatchlistMovieItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 212, adapterName: 'WatchlistTvSeriesItemAdapter')
class WatchlistTvSeriesItem extends WatchlistItem {
  const WatchlistTvSeriesItem({@HiveField(0) required this.id, final  String? $type}): $type = $type ?? 'tvSeries',super._();
  factory WatchlistTvSeriesItem.fromJson(Map<String, dynamic> json) => _$WatchlistTvSeriesItemFromJson(json);

@HiveField(0) final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistTvSeriesItemCopyWith<WatchlistTvSeriesItem> get copyWith => _$WatchlistTvSeriesItemCopyWithImpl<WatchlistTvSeriesItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistTvSeriesItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistTvSeriesItem&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'WatchlistItem.tvSeries(id: $id)';
}


}

/// @nodoc
abstract mixin class $WatchlistTvSeriesItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory $WatchlistTvSeriesItemCopyWith(WatchlistTvSeriesItem value, $Res Function(WatchlistTvSeriesItem) _then) = _$WatchlistTvSeriesItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id
});




}
/// @nodoc
class _$WatchlistTvSeriesItemCopyWithImpl<$Res>
    implements $WatchlistTvSeriesItemCopyWith<$Res> {
  _$WatchlistTvSeriesItemCopyWithImpl(this._self, this._then);

  final WatchlistTvSeriesItem _self;
  final $Res Function(WatchlistTvSeriesItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(WatchlistTvSeriesItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 213, adapterName: 'WatchlistAnimeItemAdapter')
class WatchlistAnimeItem extends WatchlistItem {
  const WatchlistAnimeItem({@HiveField(0) required this.id, final  String? $type}): $type = $type ?? 'anime',super._();
  factory WatchlistAnimeItem.fromJson(Map<String, dynamic> json) => _$WatchlistAnimeItemFromJson(json);

@HiveField(0) final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistAnimeItemCopyWith<WatchlistAnimeItem> get copyWith => _$WatchlistAnimeItemCopyWithImpl<WatchlistAnimeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistAnimeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistAnimeItem&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'WatchlistItem.anime(id: $id)';
}


}

/// @nodoc
abstract mixin class $WatchlistAnimeItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory $WatchlistAnimeItemCopyWith(WatchlistAnimeItem value, $Res Function(WatchlistAnimeItem) _then) = _$WatchlistAnimeItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id
});




}
/// @nodoc
class _$WatchlistAnimeItemCopyWithImpl<$Res>
    implements $WatchlistAnimeItemCopyWith<$Res> {
  _$WatchlistAnimeItemCopyWithImpl(this._self, this._then);

  final WatchlistAnimeItem _self;
  final $Res Function(WatchlistAnimeItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(WatchlistAnimeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 214, adapterName: 'WatchlistSeasonItemAdapter')
class WatchlistSeasonItem extends WatchlistItem {
  const WatchlistSeasonItem({@HiveField(0) required this.type, @HiveField(1) required this.seriesId, @HiveField(2) required this.seasonNumber, final  String? $type}): $type = $type ?? 'season',super._();
  factory WatchlistSeasonItem.fromJson(Map<String, dynamic> json) => _$WatchlistSeasonItemFromJson(json);

// Only use tvSeries or anime here
@HiveField(0) final  WatchlistItemType type;
@HiveField(1) final  String seriesId;
@HiveField(2) final  int seasonNumber;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistSeasonItemCopyWith<WatchlistSeasonItem> get copyWith => _$WatchlistSeasonItemCopyWithImpl<WatchlistSeasonItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistSeasonItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistSeasonItem&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,seriesId,seasonNumber);

@override
String toString() {
  return 'WatchlistItem.season(type: $type, seriesId: $seriesId, seasonNumber: $seasonNumber)';
}


}

/// @nodoc
abstract mixin class $WatchlistSeasonItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory $WatchlistSeasonItemCopyWith(WatchlistSeasonItem value, $Res Function(WatchlistSeasonItem) _then) = _$WatchlistSeasonItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) WatchlistItemType type,@HiveField(1) String seriesId,@HiveField(2) int seasonNumber
});




}
/// @nodoc
class _$WatchlistSeasonItemCopyWithImpl<$Res>
    implements $WatchlistSeasonItemCopyWith<$Res> {
  _$WatchlistSeasonItemCopyWithImpl(this._self, this._then);

  final WatchlistSeasonItem _self;
  final $Res Function(WatchlistSeasonItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seriesId = null,Object? seasonNumber = null,}) {
  return _then(WatchlistSeasonItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WatchlistItemType,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 215, adapterName: 'WatchlistEpisodeItemAdapter')
class WatchlistEpisodeItem extends WatchlistItem {
  const WatchlistEpisodeItem({@HiveField(0) required this.type, @HiveField(1) required this.seriesId, @HiveField(2) required this.seasonNumber, @HiveField(3) required this.episodeNumber, final  String? $type}): $type = $type ?? 'episode',super._();
  factory WatchlistEpisodeItem.fromJson(Map<String, dynamic> json) => _$WatchlistEpisodeItemFromJson(json);

// Only use tvSeries or anime here
@HiveField(0) final  WatchlistItemType type;
@HiveField(1) final  String seriesId;
@HiveField(2) final  int seasonNumber;
@HiveField(3) final  int episodeNumber;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistEpisodeItemCopyWith<WatchlistEpisodeItem> get copyWith => _$WatchlistEpisodeItemCopyWithImpl<WatchlistEpisodeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistEpisodeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistEpisodeItem&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,seriesId,seasonNumber,episodeNumber);

@override
String toString() {
  return 'WatchlistItem.episode(type: $type, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber)';
}


}

/// @nodoc
abstract mixin class $WatchlistEpisodeItemCopyWith<$Res> implements $WatchlistItemCopyWith<$Res> {
  factory $WatchlistEpisodeItemCopyWith(WatchlistEpisodeItem value, $Res Function(WatchlistEpisodeItem) _then) = _$WatchlistEpisodeItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) WatchlistItemType type,@HiveField(1) String seriesId,@HiveField(2) int seasonNumber,@HiveField(3) int episodeNumber
});




}
/// @nodoc
class _$WatchlistEpisodeItemCopyWithImpl<$Res>
    implements $WatchlistEpisodeItemCopyWith<$Res> {
  _$WatchlistEpisodeItemCopyWithImpl(this._self, this._then);

  final WatchlistEpisodeItem _self;
  final $Res Function(WatchlistEpisodeItem) _then;

/// Create a copy of WatchlistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seriesId = null,Object? seasonNumber = null,Object? episodeNumber = null,}) {
  return _then(WatchlistEpisodeItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WatchlistItemType,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
