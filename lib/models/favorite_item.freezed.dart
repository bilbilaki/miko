// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
FavoriteItem _$FavoriteItemFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'movie':
          return FavoriteMovieItem.fromJson(
            json
          );
                case 'tvSeries':
          return FavoriteTvSeriesItem.fromJson(
            json
          );
                case 'anime':
          return FavoriteAnimeItem.fromJson(
            json
          );
                case 'season':
          return FavoriteSeasonItem.fromJson(
            json
          );
                case 'episode':
          return FavoriteEpisodeItem.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'FavoriteItem',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$FavoriteItem {



  /// Serializes this FavoriteItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteItem);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoriteItem()';
}


}

/// @nodoc
class $FavoriteItemCopyWith<$Res>  {
$FavoriteItemCopyWith(FavoriteItem _, $Res Function(FavoriteItem) __);
}


/// Adds pattern-matching-related methods to [FavoriteItem].
extension FavoriteItemPatterns on FavoriteItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FavoriteMovieItem value)?  movie,TResult Function( FavoriteTvSeriesItem value)?  tvSeries,TResult Function( FavoriteAnimeItem value)?  anime,TResult Function( FavoriteSeasonItem value)?  season,TResult Function( FavoriteEpisodeItem value)?  episode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FavoriteMovieItem() when movie != null:
return movie(_that);case FavoriteTvSeriesItem() when tvSeries != null:
return tvSeries(_that);case FavoriteAnimeItem() when anime != null:
return anime(_that);case FavoriteSeasonItem() when season != null:
return season(_that);case FavoriteEpisodeItem() when episode != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FavoriteMovieItem value)  movie,required TResult Function( FavoriteTvSeriesItem value)  tvSeries,required TResult Function( FavoriteAnimeItem value)  anime,required TResult Function( FavoriteSeasonItem value)  season,required TResult Function( FavoriteEpisodeItem value)  episode,}){
final _that = this;
switch (_that) {
case FavoriteMovieItem():
return movie(_that);case FavoriteTvSeriesItem():
return tvSeries(_that);case FavoriteAnimeItem():
return anime(_that);case FavoriteSeasonItem():
return season(_that);case FavoriteEpisodeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FavoriteMovieItem value)?  movie,TResult? Function( FavoriteTvSeriesItem value)?  tvSeries,TResult? Function( FavoriteAnimeItem value)?  anime,TResult? Function( FavoriteSeasonItem value)?  season,TResult? Function( FavoriteEpisodeItem value)?  episode,}){
final _that = this;
switch (_that) {
case FavoriteMovieItem() when movie != null:
return movie(_that);case FavoriteTvSeriesItem() when tvSeries != null:
return tvSeries(_that);case FavoriteAnimeItem() when anime != null:
return anime(_that);case FavoriteSeasonItem() when season != null:
return season(_that);case FavoriteEpisodeItem() when episode != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@HiveField(0)  String id)?  movie,TResult Function(@HiveField(0)  String id)?  tvSeries,TResult Function(@HiveField(0)  String id)?  anime,TResult Function(@HiveField(0)  FavoriteItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber)?  season,TResult Function(@HiveField(0)  FavoriteItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber, @HiveField(3)  int episodeNumber)?  episode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FavoriteMovieItem() when movie != null:
return movie(_that.id);case FavoriteTvSeriesItem() when tvSeries != null:
return tvSeries(_that.id);case FavoriteAnimeItem() when anime != null:
return anime(_that.id);case FavoriteSeasonItem() when season != null:
return season(_that.type,_that.seriesId,_that.seasonNumber);case FavoriteEpisodeItem() when episode != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@HiveField(0)  String id)  movie,required TResult Function(@HiveField(0)  String id)  tvSeries,required TResult Function(@HiveField(0)  String id)  anime,required TResult Function(@HiveField(0)  FavoriteItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber)  season,required TResult Function(@HiveField(0)  FavoriteItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber, @HiveField(3)  int episodeNumber)  episode,}) {final _that = this;
switch (_that) {
case FavoriteMovieItem():
return movie(_that.id);case FavoriteTvSeriesItem():
return tvSeries(_that.id);case FavoriteAnimeItem():
return anime(_that.id);case FavoriteSeasonItem():
return season(_that.type,_that.seriesId,_that.seasonNumber);case FavoriteEpisodeItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@HiveField(0)  String id)?  movie,TResult? Function(@HiveField(0)  String id)?  tvSeries,TResult? Function(@HiveField(0)  String id)?  anime,TResult? Function(@HiveField(0)  FavoriteItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber)?  season,TResult? Function(@HiveField(0)  FavoriteItemType type, @HiveField(1)  String seriesId, @HiveField(2)  int seasonNumber, @HiveField(3)  int episodeNumber)?  episode,}) {final _that = this;
switch (_that) {
case FavoriteMovieItem() when movie != null:
return movie(_that.id);case FavoriteTvSeriesItem() when tvSeries != null:
return tvSeries(_that.id);case FavoriteAnimeItem() when anime != null:
return anime(_that.id);case FavoriteSeasonItem() when season != null:
return season(_that.type,_that.seriesId,_that.seasonNumber);case FavoriteEpisodeItem() when episode != null:
return episode(_that.type,_that.seriesId,_that.seasonNumber,_that.episodeNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 201, adapterName: 'FavoriteMovieItemAdapter')
class FavoriteMovieItem extends FavoriteItem {
  const FavoriteMovieItem({@HiveField(0) required this.id, final  String? $type}): $type = $type ?? 'movie',super._();
  factory FavoriteMovieItem.fromJson(Map<String, dynamic> json) => _$FavoriteMovieItemFromJson(json);

@HiveField(0) final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteMovieItemCopyWith<FavoriteMovieItem> get copyWith => _$FavoriteMovieItemCopyWithImpl<FavoriteMovieItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteMovieItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteMovieItem&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FavoriteItem.movie(id: $id)';
}


}

/// @nodoc
abstract mixin class $FavoriteMovieItemCopyWith<$Res> implements $FavoriteItemCopyWith<$Res> {
  factory $FavoriteMovieItemCopyWith(FavoriteMovieItem value, $Res Function(FavoriteMovieItem) _then) = _$FavoriteMovieItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id
});




}
/// @nodoc
class _$FavoriteMovieItemCopyWithImpl<$Res>
    implements $FavoriteMovieItemCopyWith<$Res> {
  _$FavoriteMovieItemCopyWithImpl(this._self, this._then);

  final FavoriteMovieItem _self;
  final $Res Function(FavoriteMovieItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(FavoriteMovieItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 202, adapterName: 'FavoriteTvSeriesItemAdapter')
class FavoriteTvSeriesItem extends FavoriteItem {
  const FavoriteTvSeriesItem({@HiveField(0) required this.id, final  String? $type}): $type = $type ?? 'tvSeries',super._();
  factory FavoriteTvSeriesItem.fromJson(Map<String, dynamic> json) => _$FavoriteTvSeriesItemFromJson(json);

@HiveField(0) final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteTvSeriesItemCopyWith<FavoriteTvSeriesItem> get copyWith => _$FavoriteTvSeriesItemCopyWithImpl<FavoriteTvSeriesItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteTvSeriesItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteTvSeriesItem&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FavoriteItem.tvSeries(id: $id)';
}


}

/// @nodoc
abstract mixin class $FavoriteTvSeriesItemCopyWith<$Res> implements $FavoriteItemCopyWith<$Res> {
  factory $FavoriteTvSeriesItemCopyWith(FavoriteTvSeriesItem value, $Res Function(FavoriteTvSeriesItem) _then) = _$FavoriteTvSeriesItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id
});




}
/// @nodoc
class _$FavoriteTvSeriesItemCopyWithImpl<$Res>
    implements $FavoriteTvSeriesItemCopyWith<$Res> {
  _$FavoriteTvSeriesItemCopyWithImpl(this._self, this._then);

  final FavoriteTvSeriesItem _self;
  final $Res Function(FavoriteTvSeriesItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(FavoriteTvSeriesItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 203, adapterName: 'FavoriteAnimeItemAdapter')
class FavoriteAnimeItem extends FavoriteItem {
  const FavoriteAnimeItem({@HiveField(0) required this.id, final  String? $type}): $type = $type ?? 'anime',super._();
  factory FavoriteAnimeItem.fromJson(Map<String, dynamic> json) => _$FavoriteAnimeItemFromJson(json);

@HiveField(0) final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteAnimeItemCopyWith<FavoriteAnimeItem> get copyWith => _$FavoriteAnimeItemCopyWithImpl<FavoriteAnimeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteAnimeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteAnimeItem&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FavoriteItem.anime(id: $id)';
}


}

/// @nodoc
abstract mixin class $FavoriteAnimeItemCopyWith<$Res> implements $FavoriteItemCopyWith<$Res> {
  factory $FavoriteAnimeItemCopyWith(FavoriteAnimeItem value, $Res Function(FavoriteAnimeItem) _then) = _$FavoriteAnimeItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id
});




}
/// @nodoc
class _$FavoriteAnimeItemCopyWithImpl<$Res>
    implements $FavoriteAnimeItemCopyWith<$Res> {
  _$FavoriteAnimeItemCopyWithImpl(this._self, this._then);

  final FavoriteAnimeItem _self;
  final $Res Function(FavoriteAnimeItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(FavoriteAnimeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 204, adapterName: 'FavoriteSeasonItemAdapter')
class FavoriteSeasonItem extends FavoriteItem {
  const FavoriteSeasonItem({@HiveField(0) required this.type, @HiveField(1) required this.seriesId, @HiveField(2) required this.seasonNumber, final  String? $type}): $type = $type ?? 'season',super._();
  factory FavoriteSeasonItem.fromJson(Map<String, dynamic> json) => _$FavoriteSeasonItemFromJson(json);

// Only use tvSeries or anime here
@HiveField(0) final  FavoriteItemType type;
@HiveField(1) final  String seriesId;
@HiveField(2) final  int seasonNumber;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteSeasonItemCopyWith<FavoriteSeasonItem> get copyWith => _$FavoriteSeasonItemCopyWithImpl<FavoriteSeasonItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteSeasonItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteSeasonItem&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,seriesId,seasonNumber);

@override
String toString() {
  return 'FavoriteItem.season(type: $type, seriesId: $seriesId, seasonNumber: $seasonNumber)';
}


}

/// @nodoc
abstract mixin class $FavoriteSeasonItemCopyWith<$Res> implements $FavoriteItemCopyWith<$Res> {
  factory $FavoriteSeasonItemCopyWith(FavoriteSeasonItem value, $Res Function(FavoriteSeasonItem) _then) = _$FavoriteSeasonItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) FavoriteItemType type,@HiveField(1) String seriesId,@HiveField(2) int seasonNumber
});




}
/// @nodoc
class _$FavoriteSeasonItemCopyWithImpl<$Res>
    implements $FavoriteSeasonItemCopyWith<$Res> {
  _$FavoriteSeasonItemCopyWithImpl(this._self, this._then);

  final FavoriteSeasonItem _self;
  final $Res Function(FavoriteSeasonItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seriesId = null,Object? seasonNumber = null,}) {
  return _then(FavoriteSeasonItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FavoriteItemType,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 205, adapterName: 'FavoriteEpisodeItemAdapter')
class FavoriteEpisodeItem extends FavoriteItem {
  const FavoriteEpisodeItem({@HiveField(0) required this.type, @HiveField(1) required this.seriesId, @HiveField(2) required this.seasonNumber, @HiveField(3) required this.episodeNumber, final  String? $type}): $type = $type ?? 'episode',super._();
  factory FavoriteEpisodeItem.fromJson(Map<String, dynamic> json) => _$FavoriteEpisodeItemFromJson(json);

// Only use tvSeries or anime here
@HiveField(0) final  FavoriteItemType type;
@HiveField(1) final  String seriesId;
@HiveField(2) final  int seasonNumber;
@HiveField(3) final  int episodeNumber;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteEpisodeItemCopyWith<FavoriteEpisodeItem> get copyWith => _$FavoriteEpisodeItemCopyWithImpl<FavoriteEpisodeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteEpisodeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteEpisodeItem&&(identical(other.type, type) || other.type == type)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,seriesId,seasonNumber,episodeNumber);

@override
String toString() {
  return 'FavoriteItem.episode(type: $type, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber)';
}


}

/// @nodoc
abstract mixin class $FavoriteEpisodeItemCopyWith<$Res> implements $FavoriteItemCopyWith<$Res> {
  factory $FavoriteEpisodeItemCopyWith(FavoriteEpisodeItem value, $Res Function(FavoriteEpisodeItem) _then) = _$FavoriteEpisodeItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) FavoriteItemType type,@HiveField(1) String seriesId,@HiveField(2) int seasonNumber,@HiveField(3) int episodeNumber
});




}
/// @nodoc
class _$FavoriteEpisodeItemCopyWithImpl<$Res>
    implements $FavoriteEpisodeItemCopyWith<$Res> {
  _$FavoriteEpisodeItemCopyWithImpl(this._self, this._then);

  final FavoriteEpisodeItem _self;
  final $Res Function(FavoriteEpisodeItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? seriesId = null,Object? seasonNumber = null,Object? episodeNumber = null,}) {
  return _then(FavoriteEpisodeItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FavoriteItemType,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
