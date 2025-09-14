// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingResponse {

@HiveField(0) int get page;@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> get results;@HiveField(2)@JsonKey(name: 'total_pages') int get totalPages;@HiveField(3)@JsonKey(name: 'total_results') int get totalResults;
/// Create a copy of TrendingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingResponseCopyWith<TrendingResponse> get copyWith => _$TrendingResponseCopyWithImpl<TrendingResponse>(this as TrendingResponse, _$identity);

  /// Serializes this TrendingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalPages,totalResults);

@override
String toString() {
  return 'TrendingResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $TrendingResponseCopyWith<$Res>  {
  factory $TrendingResponseCopyWith(TrendingResponse value, $Res Function(TrendingResponse) _then) = _$TrendingResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> results,@HiveField(2)@JsonKey(name: 'total_pages') int totalPages,@HiveField(3)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class _$TrendingResponseCopyWithImpl<$Res>
    implements $TrendingResponseCopyWith<$Res> {
  _$TrendingResponseCopyWithImpl(this._self, this._then);

  final TrendingResponse _self;
  final $Res Function(TrendingResponse) _then;

/// Create a copy of TrendingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendingResponse].
extension TrendingResponsePatterns on TrendingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingResponse value)  $default,){
final _that = this;
switch (_that) {
case _TrendingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _TrendingResponse():
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _TrendingResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TrendingResponse implements TrendingResponse {
  const _TrendingResponse({@HiveField(0) required this.page, @HiveField(1)@JsonKey(name: 'results') required final  List<SearchResultItem> results, @HiveField(2)@JsonKey(name: 'total_pages') required this.totalPages, @HiveField(3)@JsonKey(name: 'total_results') required this.totalResults}): _results = results;
  factory _TrendingResponse.fromJson(Map<String, dynamic> json) => _$TrendingResponseFromJson(json);

@override@HiveField(0) final  int page;
 final  List<SearchResultItem> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(2)@JsonKey(name: 'total_pages') final  int totalPages;
@override@HiveField(3)@JsonKey(name: 'total_results') final  int totalResults;

/// Create a copy of TrendingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingResponseCopyWith<_TrendingResponse> get copyWith => __$TrendingResponseCopyWithImpl<_TrendingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalPages,totalResults);

@override
String toString() {
  return 'TrendingResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$TrendingResponseCopyWith<$Res> implements $TrendingResponseCopyWith<$Res> {
  factory _$TrendingResponseCopyWith(_TrendingResponse value, $Res Function(_TrendingResponse) _then) = __$TrendingResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<SearchResultItem> results,@HiveField(2)@JsonKey(name: 'total_pages') int totalPages,@HiveField(3)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class __$TrendingResponseCopyWithImpl<$Res>
    implements _$TrendingResponseCopyWith<$Res> {
  __$TrendingResponseCopyWithImpl(this._self, this._then);

  final _TrendingResponse _self;
  final $Res Function(_TrendingResponse) _then;

/// Create a copy of TrendingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_TrendingResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
