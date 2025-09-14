// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_ids.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvExternalIds {

@HiveField(0) int get id;@HiveField(1) String? get imdbId;@HiveField(2) String? get freebaseMid;@HiveField(3) String? get freebaseId;@HiveField(4) String? get tvdbId;@HiveField(5) String? get tvrageId;@HiveField(6)@JsonKey(name: 'facebook_id') String? get facebookId;@HiveField(7)@JsonKey(name: 'instagram_id') String? get instagramId;@HiveField(8)@JsonKey(name: 'twitter_id') String? get twitterId;
/// Create a copy of TvExternalIds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvExternalIdsCopyWith<TvExternalIds> get copyWith => _$TvExternalIdsCopyWithImpl<TvExternalIds>(this as TvExternalIds, _$identity);

  /// Serializes this TvExternalIds to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvExternalIds&&(identical(other.id, id) || other.id == id)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.freebaseMid, freebaseMid) || other.freebaseMid == freebaseMid)&&(identical(other.freebaseId, freebaseId) || other.freebaseId == freebaseId)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.tvrageId, tvrageId) || other.tvrageId == tvrageId)&&(identical(other.facebookId, facebookId) || other.facebookId == facebookId)&&(identical(other.instagramId, instagramId) || other.instagramId == instagramId)&&(identical(other.twitterId, twitterId) || other.twitterId == twitterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,imdbId,freebaseMid,freebaseId,tvdbId,tvrageId,facebookId,instagramId,twitterId);

@override
String toString() {
  return 'TvExternalIds(id: $id, imdbId: $imdbId, freebaseMid: $freebaseMid, freebaseId: $freebaseId, tvdbId: $tvdbId, tvrageId: $tvrageId, facebookId: $facebookId, instagramId: $instagramId, twitterId: $twitterId)';
}


}

/// @nodoc
abstract mixin class $TvExternalIdsCopyWith<$Res>  {
  factory $TvExternalIdsCopyWith(TvExternalIds value, $Res Function(TvExternalIds) _then) = _$TvExternalIdsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String? imdbId,@HiveField(2) String? freebaseMid,@HiveField(3) String? freebaseId,@HiveField(4) String? tvdbId,@HiveField(5) String? tvrageId,@HiveField(6)@JsonKey(name: 'facebook_id') String? facebookId,@HiveField(7)@JsonKey(name: 'instagram_id') String? instagramId,@HiveField(8)@JsonKey(name: 'twitter_id') String? twitterId
});




}
/// @nodoc
class _$TvExternalIdsCopyWithImpl<$Res>
    implements $TvExternalIdsCopyWith<$Res> {
  _$TvExternalIdsCopyWithImpl(this._self, this._then);

  final TvExternalIds _self;
  final $Res Function(TvExternalIds) _then;

/// Create a copy of TvExternalIds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imdbId = freezed,Object? freebaseMid = freezed,Object? freebaseId = freezed,Object? tvdbId = freezed,Object? tvrageId = freezed,Object? facebookId = freezed,Object? instagramId = freezed,Object? twitterId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,freebaseMid: freezed == freebaseMid ? _self.freebaseMid : freebaseMid // ignore: cast_nullable_to_non_nullable
as String?,freebaseId: freezed == freebaseId ? _self.freebaseId : freebaseId // ignore: cast_nullable_to_non_nullable
as String?,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String?,tvrageId: freezed == tvrageId ? _self.tvrageId : tvrageId // ignore: cast_nullable_to_non_nullable
as String?,facebookId: freezed == facebookId ? _self.facebookId : facebookId // ignore: cast_nullable_to_non_nullable
as String?,instagramId: freezed == instagramId ? _self.instagramId : instagramId // ignore: cast_nullable_to_non_nullable
as String?,twitterId: freezed == twitterId ? _self.twitterId : twitterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvExternalIds].
extension TvExternalIdsPatterns on TvExternalIds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvExternalIds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvExternalIds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvExternalIds value)  $default,){
final _that = this;
switch (_that) {
case _TvExternalIds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvExternalIds value)?  $default,){
final _that = this;
switch (_that) {
case _TvExternalIds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String? imdbId, @HiveField(2)  String? freebaseMid, @HiveField(3)  String? freebaseId, @HiveField(4)  String? tvdbId, @HiveField(5)  String? tvrageId, @HiveField(6)@JsonKey(name: 'facebook_id')  String? facebookId, @HiveField(7)@JsonKey(name: 'instagram_id')  String? instagramId, @HiveField(8)@JsonKey(name: 'twitter_id')  String? twitterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvExternalIds() when $default != null:
return $default(_that.id,_that.imdbId,_that.freebaseMid,_that.freebaseId,_that.tvdbId,_that.tvrageId,_that.facebookId,_that.instagramId,_that.twitterId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String? imdbId, @HiveField(2)  String? freebaseMid, @HiveField(3)  String? freebaseId, @HiveField(4)  String? tvdbId, @HiveField(5)  String? tvrageId, @HiveField(6)@JsonKey(name: 'facebook_id')  String? facebookId, @HiveField(7)@JsonKey(name: 'instagram_id')  String? instagramId, @HiveField(8)@JsonKey(name: 'twitter_id')  String? twitterId)  $default,) {final _that = this;
switch (_that) {
case _TvExternalIds():
return $default(_that.id,_that.imdbId,_that.freebaseMid,_that.freebaseId,_that.tvdbId,_that.tvrageId,_that.facebookId,_that.instagramId,_that.twitterId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String? imdbId, @HiveField(2)  String? freebaseMid, @HiveField(3)  String? freebaseId, @HiveField(4)  String? tvdbId, @HiveField(5)  String? tvrageId, @HiveField(6)@JsonKey(name: 'facebook_id')  String? facebookId, @HiveField(7)@JsonKey(name: 'instagram_id')  String? instagramId, @HiveField(8)@JsonKey(name: 'twitter_id')  String? twitterId)?  $default,) {final _that = this;
switch (_that) {
case _TvExternalIds() when $default != null:
return $default(_that.id,_that.imdbId,_that.freebaseMid,_that.freebaseId,_that.tvdbId,_that.tvrageId,_that.facebookId,_that.instagramId,_that.twitterId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TvExternalIds implements TvExternalIds {
  const _TvExternalIds({@HiveField(0) required this.id, @HiveField(1) this.imdbId, @HiveField(2) this.freebaseMid, @HiveField(3) this.freebaseId, @HiveField(4) this.tvdbId, @HiveField(5) this.tvrageId, @HiveField(6)@JsonKey(name: 'facebook_id') this.facebookId, @HiveField(7)@JsonKey(name: 'instagram_id') this.instagramId, @HiveField(8)@JsonKey(name: 'twitter_id') this.twitterId});
  factory _TvExternalIds.fromJson(Map<String, dynamic> json) => _$TvExternalIdsFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String? imdbId;
@override@HiveField(2) final  String? freebaseMid;
@override@HiveField(3) final  String? freebaseId;
@override@HiveField(4) final  String? tvdbId;
@override@HiveField(5) final  String? tvrageId;
@override@HiveField(6)@JsonKey(name: 'facebook_id') final  String? facebookId;
@override@HiveField(7)@JsonKey(name: 'instagram_id') final  String? instagramId;
@override@HiveField(8)@JsonKey(name: 'twitter_id') final  String? twitterId;

/// Create a copy of TvExternalIds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvExternalIdsCopyWith<_TvExternalIds> get copyWith => __$TvExternalIdsCopyWithImpl<_TvExternalIds>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvExternalIdsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvExternalIds&&(identical(other.id, id) || other.id == id)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.freebaseMid, freebaseMid) || other.freebaseMid == freebaseMid)&&(identical(other.freebaseId, freebaseId) || other.freebaseId == freebaseId)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.tvrageId, tvrageId) || other.tvrageId == tvrageId)&&(identical(other.facebookId, facebookId) || other.facebookId == facebookId)&&(identical(other.instagramId, instagramId) || other.instagramId == instagramId)&&(identical(other.twitterId, twitterId) || other.twitterId == twitterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,imdbId,freebaseMid,freebaseId,tvdbId,tvrageId,facebookId,instagramId,twitterId);

@override
String toString() {
  return 'TvExternalIds(id: $id, imdbId: $imdbId, freebaseMid: $freebaseMid, freebaseId: $freebaseId, tvdbId: $tvdbId, tvrageId: $tvrageId, facebookId: $facebookId, instagramId: $instagramId, twitterId: $twitterId)';
}


}

/// @nodoc
abstract mixin class _$TvExternalIdsCopyWith<$Res> implements $TvExternalIdsCopyWith<$Res> {
  factory _$TvExternalIdsCopyWith(_TvExternalIds value, $Res Function(_TvExternalIds) _then) = __$TvExternalIdsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String? imdbId,@HiveField(2) String? freebaseMid,@HiveField(3) String? freebaseId,@HiveField(4) String? tvdbId,@HiveField(5) String? tvrageId,@HiveField(6)@JsonKey(name: 'facebook_id') String? facebookId,@HiveField(7)@JsonKey(name: 'instagram_id') String? instagramId,@HiveField(8)@JsonKey(name: 'twitter_id') String? twitterId
});




}
/// @nodoc
class __$TvExternalIdsCopyWithImpl<$Res>
    implements _$TvExternalIdsCopyWith<$Res> {
  __$TvExternalIdsCopyWithImpl(this._self, this._then);

  final _TvExternalIds _self;
  final $Res Function(_TvExternalIds) _then;

/// Create a copy of TvExternalIds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imdbId = freezed,Object? freebaseMid = freezed,Object? freebaseId = freezed,Object? tvdbId = freezed,Object? tvrageId = freezed,Object? facebookId = freezed,Object? instagramId = freezed,Object? twitterId = freezed,}) {
  return _then(_TvExternalIds(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imdbId: freezed == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String?,freebaseMid: freezed == freebaseMid ? _self.freebaseMid : freebaseMid // ignore: cast_nullable_to_non_nullable
as String?,freebaseId: freezed == freebaseId ? _self.freebaseId : freebaseId // ignore: cast_nullable_to_non_nullable
as String?,tvdbId: freezed == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String?,tvrageId: freezed == tvrageId ? _self.tvrageId : tvrageId // ignore: cast_nullable_to_non_nullable
as String?,facebookId: freezed == facebookId ? _self.facebookId : facebookId // ignore: cast_nullable_to_non_nullable
as String?,instagramId: freezed == instagramId ? _self.instagramId : instagramId // ignore: cast_nullable_to_non_nullable
as String?,twitterId: freezed == twitterId ? _self.twitterId : twitterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
