// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_ratings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentRatingItem {

@HiveField(0)@JsonKey(name: 'iso_3166_1') String get iso31661;@HiveField(1) String get rating;
/// Create a copy of ContentRatingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentRatingItemCopyWith<ContentRatingItem> get copyWith => _$ContentRatingItemCopyWithImpl<ContentRatingItem>(this as ContentRatingItem, _$identity);

  /// Serializes this ContentRatingItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentRatingItem&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso31661,rating);

@override
String toString() {
  return 'ContentRatingItem(iso31661: $iso31661, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $ContentRatingItemCopyWith<$Res>  {
  factory $ContentRatingItemCopyWith(ContentRatingItem value, $Res Function(ContentRatingItem) _then) = _$ContentRatingItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'iso_3166_1') String iso31661,@HiveField(1) String rating
});




}
/// @nodoc
class _$ContentRatingItemCopyWithImpl<$Res>
    implements $ContentRatingItemCopyWith<$Res> {
  _$ContentRatingItemCopyWithImpl(this._self, this._then);

  final ContentRatingItem _self;
  final $Res Function(ContentRatingItem) _then;

/// Create a copy of ContentRatingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iso31661 = null,Object? rating = null,}) {
  return _then(_self.copyWith(
iso31661: null == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentRatingItem].
extension ContentRatingItemPatterns on ContentRatingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentRatingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentRatingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentRatingItem value)  $default,){
final _that = this;
switch (_that) {
case _ContentRatingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentRatingItem value)?  $default,){
final _that = this;
switch (_that) {
case _ContentRatingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'iso_3166_1')  String iso31661, @HiveField(1)  String rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentRatingItem() when $default != null:
return $default(_that.iso31661,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'iso_3166_1')  String iso31661, @HiveField(1)  String rating)  $default,) {final _that = this;
switch (_that) {
case _ContentRatingItem():
return $default(_that.iso31661,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'iso_3166_1')  String iso31661, @HiveField(1)  String rating)?  $default,) {final _that = this;
switch (_that) {
case _ContentRatingItem() when $default != null:
return $default(_that.iso31661,_that.rating);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _ContentRatingItem implements ContentRatingItem {
  const _ContentRatingItem({@HiveField(0)@JsonKey(name: 'iso_3166_1') required this.iso31661, @HiveField(1) required this.rating});
  factory _ContentRatingItem.fromJson(Map<String, dynamic> json) => _$ContentRatingItemFromJson(json);

@override@HiveField(0)@JsonKey(name: 'iso_3166_1') final  String iso31661;
@override@HiveField(1) final  String rating;

/// Create a copy of ContentRatingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentRatingItemCopyWith<_ContentRatingItem> get copyWith => __$ContentRatingItemCopyWithImpl<_ContentRatingItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentRatingItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentRatingItem&&(identical(other.iso31661, iso31661) || other.iso31661 == iso31661)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso31661,rating);

@override
String toString() {
  return 'ContentRatingItem(iso31661: $iso31661, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$ContentRatingItemCopyWith<$Res> implements $ContentRatingItemCopyWith<$Res> {
  factory _$ContentRatingItemCopyWith(_ContentRatingItem value, $Res Function(_ContentRatingItem) _then) = __$ContentRatingItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'iso_3166_1') String iso31661,@HiveField(1) String rating
});




}
/// @nodoc
class __$ContentRatingItemCopyWithImpl<$Res>
    implements _$ContentRatingItemCopyWith<$Res> {
  __$ContentRatingItemCopyWithImpl(this._self, this._then);

  final _ContentRatingItem _self;
  final $Res Function(_ContentRatingItem) _then;

/// Create a copy of ContentRatingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iso31661 = null,Object? rating = null,}) {
  return _then(_ContentRatingItem(
iso31661: null == iso31661 ? _self.iso31661 : iso31661 // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TvContentRatingsResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'results') List<ContentRatingItem> get results;
/// Create a copy of TvContentRatingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvContentRatingsResponseCopyWith<TvContentRatingsResponse> get copyWith => _$TvContentRatingsResponseCopyWithImpl<TvContentRatingsResponse>(this as TvContentRatingsResponse, _$identity);

  /// Serializes this TvContentRatingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvContentRatingsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'TvContentRatingsResponse(id: $id, results: $results)';
}


}

/// @nodoc
abstract mixin class $TvContentRatingsResponseCopyWith<$Res>  {
  factory $TvContentRatingsResponseCopyWith(TvContentRatingsResponse value, $Res Function(TvContentRatingsResponse) _then) = _$TvContentRatingsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'results') List<ContentRatingItem> results
});




}
/// @nodoc
class _$TvContentRatingsResponseCopyWithImpl<$Res>
    implements $TvContentRatingsResponseCopyWith<$Res> {
  _$TvContentRatingsResponseCopyWithImpl(this._self, this._then);

  final TvContentRatingsResponse _self;
  final $Res Function(TvContentRatingsResponse) _then;

/// Create a copy of TvContentRatingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? results = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ContentRatingItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvContentRatingsResponse].
extension TvContentRatingsResponsePatterns on TvContentRatingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvContentRatingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvContentRatingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvContentRatingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TvContentRatingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvContentRatingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TvContentRatingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  List<ContentRatingItem> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvContentRatingsResponse() when $default != null:
return $default(_that.id,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  List<ContentRatingItem> results)  $default,) {final _that = this;
switch (_that) {
case _TvContentRatingsResponse():
return $default(_that.id,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  List<ContentRatingItem> results)?  $default,) {final _that = this;
switch (_that) {
case _TvContentRatingsResponse() when $default != null:
return $default(_that.id,_that.results);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TvContentRatingsResponse implements TvContentRatingsResponse {
  const _TvContentRatingsResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'results') required final  List<ContentRatingItem> results}): _results = results;
  factory _TvContentRatingsResponse.fromJson(Map<String, dynamic> json) => _$TvContentRatingsResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<ContentRatingItem> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<ContentRatingItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of TvContentRatingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvContentRatingsResponseCopyWith<_TvContentRatingsResponse> get copyWith => __$TvContentRatingsResponseCopyWithImpl<_TvContentRatingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvContentRatingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvContentRatingsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'TvContentRatingsResponse(id: $id, results: $results)';
}


}

/// @nodoc
abstract mixin class _$TvContentRatingsResponseCopyWith<$Res> implements $TvContentRatingsResponseCopyWith<$Res> {
  factory _$TvContentRatingsResponseCopyWith(_TvContentRatingsResponse value, $Res Function(_TvContentRatingsResponse) _then) = __$TvContentRatingsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'results') List<ContentRatingItem> results
});




}
/// @nodoc
class __$TvContentRatingsResponseCopyWithImpl<$Res>
    implements _$TvContentRatingsResponseCopyWith<$Res> {
  __$TvContentRatingsResponseCopyWithImpl(this._self, this._then);

  final _TvContentRatingsResponse _self;
  final $Res Function(_TvContentRatingsResponse) _then;

/// Create a copy of TvContentRatingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? results = null,}) {
  return _then(_TvContentRatingsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ContentRatingItem>,
  ));
}


}

// dart format on
