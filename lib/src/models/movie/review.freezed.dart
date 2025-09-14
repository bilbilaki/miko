// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieReview {

@HiveField(0) String get id;@HiveField(1) String get author;@HiveField(2)@JsonKey(name: 'author_details') Map<String, Object?> get authorDetails;@HiveField(3) String get content;@HiveField(4)@JsonKey(name: 'created_at') String get createdAt;@HiveField(5)@JsonKey(name: 'updated_at') String get updatedAt;@HiveField(6)@JsonKey(name: 'url') String? get url;
/// Create a copy of MovieReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieReviewCopyWith<MovieReview> get copyWith => _$MovieReviewCopyWithImpl<MovieReview>(this as MovieReview, _$identity);

  /// Serializes this MovieReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieReview&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.authorDetails, authorDetails)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,const DeepCollectionEquality().hash(authorDetails),content,createdAt,updatedAt,url);

@override
String toString() {
  return 'MovieReview(id: $id, author: $author, authorDetails: $authorDetails, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, url: $url)';
}


}

/// @nodoc
abstract mixin class $MovieReviewCopyWith<$Res>  {
  factory $MovieReviewCopyWith(MovieReview value, $Res Function(MovieReview) _then) = _$MovieReviewCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String author,@HiveField(2)@JsonKey(name: 'author_details') Map<String, Object?> authorDetails,@HiveField(3) String content,@HiveField(4)@JsonKey(name: 'created_at') String createdAt,@HiveField(5)@JsonKey(name: 'updated_at') String updatedAt,@HiveField(6)@JsonKey(name: 'url') String? url
});




}
/// @nodoc
class _$MovieReviewCopyWithImpl<$Res>
    implements $MovieReviewCopyWith<$Res> {
  _$MovieReviewCopyWithImpl(this._self, this._then);

  final MovieReview _self;
  final $Res Function(MovieReview) _then;

/// Create a copy of MovieReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? authorDetails = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,Object? url = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,authorDetails: null == authorDetails ? _self.authorDetails : authorDetails // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieReview].
extension MovieReviewPatterns on MovieReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieReview value)  $default,){
final _that = this;
switch (_that) {
case _MovieReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieReview value)?  $default,){
final _that = this;
switch (_that) {
case _MovieReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String author, @HiveField(2)@JsonKey(name: 'author_details')  Map<String, Object?> authorDetails, @HiveField(3)  String content, @HiveField(4)@JsonKey(name: 'created_at')  String createdAt, @HiveField(5)@JsonKey(name: 'updated_at')  String updatedAt, @HiveField(6)@JsonKey(name: 'url')  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieReview() when $default != null:
return $default(_that.id,_that.author,_that.authorDetails,_that.content,_that.createdAt,_that.updatedAt,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String author, @HiveField(2)@JsonKey(name: 'author_details')  Map<String, Object?> authorDetails, @HiveField(3)  String content, @HiveField(4)@JsonKey(name: 'created_at')  String createdAt, @HiveField(5)@JsonKey(name: 'updated_at')  String updatedAt, @HiveField(6)@JsonKey(name: 'url')  String? url)  $default,) {final _that = this;
switch (_that) {
case _MovieReview():
return $default(_that.id,_that.author,_that.authorDetails,_that.content,_that.createdAt,_that.updatedAt,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String author, @HiveField(2)@JsonKey(name: 'author_details')  Map<String, Object?> authorDetails, @HiveField(3)  String content, @HiveField(4)@JsonKey(name: 'created_at')  String createdAt, @HiveField(5)@JsonKey(name: 'updated_at')  String updatedAt, @HiveField(6)@JsonKey(name: 'url')  String? url)?  $default,) {final _that = this;
switch (_that) {
case _MovieReview() when $default != null:
return $default(_that.id,_that.author,_that.authorDetails,_that.content,_that.createdAt,_that.updatedAt,_that.url);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _MovieReview implements MovieReview {
  const _MovieReview({@HiveField(0) required this.id, @HiveField(1) required this.author, @HiveField(2)@JsonKey(name: 'author_details') required final  Map<String, Object?> authorDetails, @HiveField(3) required this.content, @HiveField(4)@JsonKey(name: 'created_at') required this.createdAt, @HiveField(5)@JsonKey(name: 'updated_at') required this.updatedAt, @HiveField(6)@JsonKey(name: 'url') this.url}): _authorDetails = authorDetails;
  factory _MovieReview.fromJson(Map<String, dynamic> json) => _$MovieReviewFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String author;
 final  Map<String, Object?> _authorDetails;
@override@HiveField(2)@JsonKey(name: 'author_details') Map<String, Object?> get authorDetails {
  if (_authorDetails is EqualUnmodifiableMapView) return _authorDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_authorDetails);
}

@override@HiveField(3) final  String content;
@override@HiveField(4)@JsonKey(name: 'created_at') final  String createdAt;
@override@HiveField(5)@JsonKey(name: 'updated_at') final  String updatedAt;
@override@HiveField(6)@JsonKey(name: 'url') final  String? url;

/// Create a copy of MovieReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieReviewCopyWith<_MovieReview> get copyWith => __$MovieReviewCopyWithImpl<_MovieReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieReview&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._authorDetails, _authorDetails)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,const DeepCollectionEquality().hash(_authorDetails),content,createdAt,updatedAt,url);

@override
String toString() {
  return 'MovieReview(id: $id, author: $author, authorDetails: $authorDetails, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, url: $url)';
}


}

/// @nodoc
abstract mixin class _$MovieReviewCopyWith<$Res> implements $MovieReviewCopyWith<$Res> {
  factory _$MovieReviewCopyWith(_MovieReview value, $Res Function(_MovieReview) _then) = __$MovieReviewCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String author,@HiveField(2)@JsonKey(name: 'author_details') Map<String, Object?> authorDetails,@HiveField(3) String content,@HiveField(4)@JsonKey(name: 'created_at') String createdAt,@HiveField(5)@JsonKey(name: 'updated_at') String updatedAt,@HiveField(6)@JsonKey(name: 'url') String? url
});




}
/// @nodoc
class __$MovieReviewCopyWithImpl<$Res>
    implements _$MovieReviewCopyWith<$Res> {
  __$MovieReviewCopyWithImpl(this._self, this._then);

  final _MovieReview _self;
  final $Res Function(_MovieReview) _then;

/// Create a copy of MovieReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? authorDetails = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,Object? url = freezed,}) {
  return _then(_MovieReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,authorDetails: null == authorDetails ? _self._authorDetails : authorDetails // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MovieReviewsResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'page') int get page;@HiveField(2)@JsonKey(name: 'results') List<MovieReview> get results;@HiveField(3)@JsonKey(name: 'total_pages') int get totalPages;@HiveField(4)@JsonKey(name: 'total_results') int get totalResults;
/// Create a copy of MovieReviewsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieReviewsResponseCopyWith<MovieReviewsResponse> get copyWith => _$MovieReviewsResponseCopyWithImpl<MovieReviewsResponse>(this as MovieReviewsResponse, _$identity);

  /// Serializes this MovieReviewsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieReviewsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,page,const DeepCollectionEquality().hash(results),totalPages,totalResults);

@override
String toString() {
  return 'MovieReviewsResponse(id: $id, page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $MovieReviewsResponseCopyWith<$Res>  {
  factory $MovieReviewsResponseCopyWith(MovieReviewsResponse value, $Res Function(MovieReviewsResponse) _then) = _$MovieReviewsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'page') int page,@HiveField(2)@JsonKey(name: 'results') List<MovieReview> results,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages,@HiveField(4)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class _$MovieReviewsResponseCopyWithImpl<$Res>
    implements $MovieReviewsResponseCopyWith<$Res> {
  _$MovieReviewsResponseCopyWithImpl(this._self, this._then);

  final MovieReviewsResponse _self;
  final $Res Function(MovieReviewsResponse) _then;

/// Create a copy of MovieReviewsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MovieReview>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieReviewsResponse].
extension MovieReviewsResponsePatterns on MovieReviewsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieReviewsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieReviewsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieReviewsResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovieReviewsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieReviewsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovieReviewsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'page')  int page, @HiveField(2)@JsonKey(name: 'results')  List<MovieReview> results, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(4)@JsonKey(name: 'total_results')  int totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieReviewsResponse() when $default != null:
return $default(_that.id,_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'page')  int page, @HiveField(2)@JsonKey(name: 'results')  List<MovieReview> results, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(4)@JsonKey(name: 'total_results')  int totalResults)  $default,) {final _that = this;
switch (_that) {
case _MovieReviewsResponse():
return $default(_that.id,_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'page')  int page, @HiveField(2)@JsonKey(name: 'results')  List<MovieReview> results, @HiveField(3)@JsonKey(name: 'total_pages')  int totalPages, @HiveField(4)@JsonKey(name: 'total_results')  int totalResults)?  $default,) {final _that = this;
switch (_that) {
case _MovieReviewsResponse() when $default != null:
return $default(_that.id,_that.page,_that.results,_that.totalPages,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MovieReviewsResponse implements MovieReviewsResponse {
  const _MovieReviewsResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'page') required this.page, @HiveField(2)@JsonKey(name: 'results') required final  List<MovieReview> results, @HiveField(3)@JsonKey(name: 'total_pages') required this.totalPages, @HiveField(4)@JsonKey(name: 'total_results') required this.totalResults}): _results = results;
  factory _MovieReviewsResponse.fromJson(Map<String, dynamic> json) => _$MovieReviewsResponseFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1)@JsonKey(name: 'page') final  int page;
 final  List<MovieReview> _results;
@override@HiveField(2)@JsonKey(name: 'results') List<MovieReview> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@HiveField(3)@JsonKey(name: 'total_pages') final  int totalPages;
@override@HiveField(4)@JsonKey(name: 'total_results') final  int totalResults;

/// Create a copy of MovieReviewsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieReviewsResponseCopyWith<_MovieReviewsResponse> get copyWith => __$MovieReviewsResponseCopyWithImpl<_MovieReviewsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieReviewsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieReviewsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,page,const DeepCollectionEquality().hash(_results),totalPages,totalResults);

@override
String toString() {
  return 'MovieReviewsResponse(id: $id, page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$MovieReviewsResponseCopyWith<$Res> implements $MovieReviewsResponseCopyWith<$Res> {
  factory _$MovieReviewsResponseCopyWith(_MovieReviewsResponse value, $Res Function(_MovieReviewsResponse) _then) = __$MovieReviewsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'page') int page,@HiveField(2)@JsonKey(name: 'results') List<MovieReview> results,@HiveField(3)@JsonKey(name: 'total_pages') int totalPages,@HiveField(4)@JsonKey(name: 'total_results') int totalResults
});




}
/// @nodoc
class __$MovieReviewsResponseCopyWithImpl<$Res>
    implements _$MovieReviewsResponseCopyWith<$Res> {
  __$MovieReviewsResponseCopyWithImpl(this._self, this._then);

  final _MovieReviewsResponse _self;
  final $Res Function(_MovieReviewsResponse) _then;

/// Create a copy of MovieReviewsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? page = null,Object? results = null,Object? totalPages = null,Object? totalResults = null,}) {
  return _then(_MovieReviewsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MovieReview>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
