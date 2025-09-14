// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendations_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieRecommendationsResponse {

@HiveField(0) int get page;@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> get results;@HiveField(2)@JsonKey(name: 'total_results') int get totalResults;@HiveField(3)@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of MovieRecommendationsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieRecommendationsResponseCopyWith<MovieRecommendationsResponse> get copyWith => _$MovieRecommendationsResponseCopyWithImpl<MovieRecommendationsResponse>(this as MovieRecommendationsResponse, _$identity);

  /// Serializes this MovieRecommendationsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieRecommendationsResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalResults,totalPages);

@override
String toString() {
  return 'MovieRecommendationsResponse(page: $page, results: $results, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $MovieRecommendationsResponseCopyWith<$Res>  {
  factory $MovieRecommendationsResponseCopyWith(MovieRecommendationsResponse value, $Res Function(MovieRecommendationsResponse) _then) = _$MovieRecommendationsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> results,@HiveField(2)@JsonKey(name: 'total_results') int totalResults,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$MovieRecommendationsResponseCopyWithImpl<$Res>
    implements $MovieRecommendationsResponseCopyWith<$Res> {
  _$MovieRecommendationsResponseCopyWithImpl(this._self, this._then);

  final MovieRecommendationsResponse _self;
  final $Res Function(MovieRecommendationsResponse) _then;

/// Create a copy of MovieRecommendationsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MovieListItem>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieRecommendationsResponse].
extension MovieRecommendationsResponsePatterns on MovieRecommendationsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieRecommendationsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieRecommendationsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieRecommendationsResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovieRecommendationsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieRecommendationsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovieRecommendationsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieRecommendationsResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _MovieRecommendationsResponse():
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results')  int totalResults, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _MovieRecommendationsResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalResults,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieRecommendationsResponse implements MovieRecommendationsResponse {
  const _MovieRecommendationsResponse({@HiveField(0) required this.page, @HiveField(1)@JsonKey(name: 'results') required final  List<MovieListItem> results, @HiveField(2)@JsonKey(name: 'total_results') required this.totalResults, @HiveField(3)@JsonKey(name: 'total_pages') required this.totalPages}): _results = results;
  factory _MovieRecommendationsResponse.fromJson(Map<String, dynamic> json) => _$MovieRecommendationsResponseFromJson(json);

@override@HiveField(0) final  int page;
 final  List<MovieListItem> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(2)@JsonKey(name: 'total_results') final  int totalResults;
@override@HiveField(3)@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of MovieRecommendationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieRecommendationsResponseCopyWith<_MovieRecommendationsResponse> get copyWith => __$MovieRecommendationsResponseCopyWithImpl<_MovieRecommendationsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieRecommendationsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieRecommendationsResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalResults,totalPages);

@override
String toString() {
  return 'MovieRecommendationsResponse(page: $page, results: $results, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$MovieRecommendationsResponseCopyWith<$Res> implements $MovieRecommendationsResponseCopyWith<$Res> {
  factory _$MovieRecommendationsResponseCopyWith(_MovieRecommendationsResponse value, $Res Function(_MovieRecommendationsResponse) _then) = __$MovieRecommendationsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<MovieListItem> results,@HiveField(2)@JsonKey(name: 'total_results') int totalResults,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$MovieRecommendationsResponseCopyWithImpl<$Res>
    implements _$MovieRecommendationsResponseCopyWith<$Res> {
  __$MovieRecommendationsResponseCopyWithImpl(this._self, this._then);

  final _MovieRecommendationsResponse _self;
  final $Res Function(_MovieRecommendationsResponse) _then;

/// Create a copy of MovieRecommendationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_MovieRecommendationsResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MovieListItem>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
