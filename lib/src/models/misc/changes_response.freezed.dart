// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'changes_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangesResponse {

@HiveField(0) int get page;@HiveField(1)@JsonKey(name: 'results') List<ChangeItem> get results;@HiveField(2)@JsonKey(name: 'total_pages') int get totalPages;@HiveField(3)@JsonKey(name: 'total_results') int get totalResults;
/// Create a copy of ChangesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangesResponseCopyWith<ChangesResponse> get copyWith => _$ChangesResponseCopyWithImpl<ChangesResponse>(this as ChangesResponse, _$identity);

  /// Serializes this ChangesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangesResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalPages,totalResults);

@override
String toString() {
  return 'ChangesResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $ChangesResponseCopyWith<$Res>  {
  factory $ChangesResponseCopyWith(ChangesResponse value, $Res Function(ChangesResponse) _then) = _$ChangesResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<ChangeItem> results,@HiveField(2)@JsonKey(name: 'total_pages') int totalPages,@HiveField(3)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class _$ChangesResponseCopyWithImpl<$Res>
    implements $ChangesResponseCopyWith<$Res> {
  _$ChangesResponseCopyWithImpl(this._self, this._then);

  final ChangesResponse _self;
  final $Res Function(ChangesResponse) _then;

/// Create a copy of ChangesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ChangeItem>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangesResponse].
extension ChangesResponsePatterns on ChangesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangesResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChangesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChangesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<ChangeItem> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangesResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<ChangeItem> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _ChangesResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int page, @HiveField(1)@JsonKey(name: 'results')  List<ChangeItem> results, @HiveField(2)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(3)@JsonKey(name: 'total_results')  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _ChangesResponse() when $default != null:
return $default(_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangesResponse implements ChangesResponse {
  const _ChangesResponse({@HiveField(0) required this.page, @HiveField(1)@JsonKey(name: 'results') required final  List<ChangeItem> results, @HiveField(2)@JsonKey(name: 'total_pages') required this.totalPages, @HiveField(3)@JsonKey(name: 'total_results') required this.totalResults}): _results = results;
  factory _ChangesResponse.fromJson(Map<String, dynamic> json) => _$ChangesResponseFromJson(json);

@override@HiveField(0) final  int page;
 final  List<ChangeItem> _results;
@override@HiveField(1)@JsonKey(name: 'results') List<ChangeItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(2)@JsonKey(name: 'total_pages') final  int totalPages;
@override@HiveField(3)@JsonKey(name: 'total_results') final  int totalResults;

/// Create a copy of ChangesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangesResponseCopyWith<_ChangesResponse> get copyWith => __$ChangesResponseCopyWithImpl<_ChangesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangesResponse&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalPages,totalResults);

@override
String toString() {
  return 'ChangesResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$ChangesResponseCopyWith<$Res> implements $ChangesResponseCopyWith<$Res> {
  factory _$ChangesResponseCopyWith(_ChangesResponse value, $Res Function(_ChangesResponse) _then) = __$ChangesResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int page,@HiveField(1)@JsonKey(name: 'results') List<ChangeItem> results,@HiveField(2)@JsonKey(name: 'total_pages') int totalPages,@HiveField(3)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class __$ChangesResponseCopyWithImpl<$Res>
    implements _$ChangesResponseCopyWith<$Res> {
  __$ChangesResponseCopyWithImpl(this._self, this._then);

  final _ChangesResponse _self;
  final $Res Function(_ChangesResponse) _then;

/// Create a copy of ChangesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_ChangesResponse(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ChangeItem>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
