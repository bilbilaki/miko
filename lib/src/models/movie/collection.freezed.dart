// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionPart {

@HiveField(0) int get id;@HiveField(1) String get title;@HiveField(2)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(3)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(4)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(5)@JsonKey(name: 'release_date') String? get releaseDate;
/// Create a copy of CollectionPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionPartCopyWith<CollectionPart> get copyWith => _$CollectionPartCopyWithImpl<CollectionPart>(this as CollectionPart, _$identity);

  /// Serializes this CollectionPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionPart&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,posterPath,backdropPath,releaseDate);

@override
String toString() {
  return 'CollectionPart(id: $id, title: $title, originalTitle: $originalTitle, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class $CollectionPartCopyWith<$Res>  {
  factory $CollectionPartCopyWith(CollectionPart value, $Res Function(CollectionPart) _then) = _$CollectionPartCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(3)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(4)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(5)@JsonKey(name: 'release_date') String? releaseDate
});




}
/// @nodoc
class _$CollectionPartCopyWithImpl<$Res>
    implements $CollectionPartCopyWith<$Res> {
  _$CollectionPartCopyWithImpl(this._self, this._then);

  final CollectionPart _self;
  final $Res Function(CollectionPart) _then;

/// Create a copy of CollectionPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? originalTitle = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionPart].
extension CollectionPartPatterns on CollectionPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionPart value)  $default,){
final _that = this;
switch (_that) {
case _CollectionPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionPart value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(3)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(5)@JsonKey(name: 'release_date')  String? releaseDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionPart() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.posterPath,_that.backdropPath,_that.releaseDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(3)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(5)@JsonKey(name: 'release_date')  String? releaseDate)  $default,) {final _that = this;
switch (_that) {
case _CollectionPart():
return $default(_that.id,_that.title,_that.originalTitle,_that.posterPath,_that.backdropPath,_that.releaseDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String title, @HiveField(2)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(3)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(5)@JsonKey(name: 'release_date')  String? releaseDate)?  $default,) {final _that = this;
switch (_that) {
case _CollectionPart() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.posterPath,_that.backdropPath,_that.releaseDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _CollectionPart implements CollectionPart {
  const _CollectionPart({@HiveField(0) required this.id, @HiveField(1) required this.title, @HiveField(2)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(3)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(5)@JsonKey(name: 'release_date') this.releaseDate});
  factory _CollectionPart.fromJson(Map<String, dynamic> json) => _$CollectionPartFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String title;
@override@HiveField(2)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(3)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(4)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@HiveField(5)@JsonKey(name: 'release_date') final  String? releaseDate;

/// Create a copy of CollectionPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionPartCopyWith<_CollectionPart> get copyWith => __$CollectionPartCopyWithImpl<_CollectionPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionPart&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,posterPath,backdropPath,releaseDate);

@override
String toString() {
  return 'CollectionPart(id: $id, title: $title, originalTitle: $originalTitle, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class _$CollectionPartCopyWith<$Res> implements $CollectionPartCopyWith<$Res> {
  factory _$CollectionPartCopyWith(_CollectionPart value, $Res Function(_CollectionPart) _then) = __$CollectionPartCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String title,@HiveField(2)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(3)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(4)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(5)@JsonKey(name: 'release_date') String? releaseDate
});




}
/// @nodoc
class __$CollectionPartCopyWithImpl<$Res>
    implements _$CollectionPartCopyWith<$Res> {
  __$CollectionPartCopyWithImpl(this._self, this._then);

  final _CollectionPart _self;
  final $Res Function(_CollectionPart) _then;

/// Create a copy of CollectionPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? originalTitle = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,}) {
  return _then(_CollectionPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CollectionDetails {

@HiveField(0) int get id;@HiveField(1) String get name;@HiveField(2) String? get overview;@HiveField(3)@JsonKey(name: 'poster_path') String? get posterPath;@HiveField(4)@JsonKey(name: 'backdrop_path') String? get backdropPath;@HiveField(5)@JsonKey(name: 'parts') List<CollectionPart> get parts;
/// Create a copy of CollectionDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionDetailsCopyWith<CollectionDetails> get copyWith => _$CollectionDetailsCopyWithImpl<CollectionDetails>(this as CollectionDetails, _$identity);

  /// Serializes this CollectionDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other.parts, parts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,overview,posterPath,backdropPath,const DeepCollectionEquality().hash(parts));

@override
String toString() {
  return 'CollectionDetails(id: $id, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, parts: $parts)';
}


}

/// @nodoc
abstract mixin class $CollectionDetailsCopyWith<$Res>  {
  factory $CollectionDetailsCopyWith(CollectionDetails value, $Res Function(CollectionDetails) _then) = _$CollectionDetailsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name,@HiveField(2) String? overview,@HiveField(3)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(4)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(5)@JsonKey(name: 'parts') List<CollectionPart> parts
});




}
/// @nodoc
class _$CollectionDetailsCopyWithImpl<$Res>
    implements $CollectionDetailsCopyWith<$Res> {
  _$CollectionDetailsCopyWithImpl(this._self, this._then);

  final CollectionDetails _self;
  final $Res Function(CollectionDetails) _then;

/// Create a copy of CollectionDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? parts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<CollectionPart>,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionDetails].
extension CollectionDetailsPatterns on CollectionDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionDetails value)  $default,){
final _that = this;
switch (_that) {
case _CollectionDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)  String? overview, @HiveField(3)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(5)@JsonKey(name: 'parts')  List<CollectionPart> parts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionDetails() when $default != null:
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.parts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)  String? overview, @HiveField(3)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(5)@JsonKey(name: 'parts')  List<CollectionPart> parts)  $default,) {final _that = this;
switch (_that) {
case _CollectionDetails():
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.parts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)  String? overview, @HiveField(3)@JsonKey(name: 'poster_path')  String? posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path')  String? backdropPath, @HiveField(5)@JsonKey(name: 'parts')  List<CollectionPart> parts)?  $default,) {final _that = this;
switch (_that) {
case _CollectionDetails() when $default != null:
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.parts);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CollectionDetails implements CollectionDetails {
  const _CollectionDetails({@HiveField(0) required this.id, @HiveField(1) required this.name, @HiveField(2) this.overview, @HiveField(3)@JsonKey(name: 'poster_path') this.posterPath, @HiveField(4)@JsonKey(name: 'backdrop_path') this.backdropPath, @HiveField(5)@JsonKey(name: 'parts') required final  List<CollectionPart> parts}): _parts = parts;
  factory _CollectionDetails.fromJson(Map<String, dynamic> json) => _$CollectionDetailsFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  String name;
@override@HiveField(2) final  String? overview;
@override@HiveField(3)@JsonKey(name: 'poster_path') final  String? posterPath;
@override@HiveField(4)@JsonKey(name: 'backdrop_path') final  String? backdropPath;
 final  List<CollectionPart> _parts;
@override@HiveField(5)@JsonKey(name: 'parts') List<CollectionPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}


/// Create a copy of CollectionDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionDetailsCopyWith<_CollectionDetails> get copyWith => __$CollectionDetailsCopyWithImpl<_CollectionDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other._parts, _parts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,overview,posterPath,backdropPath,const DeepCollectionEquality().hash(_parts));

@override
String toString() {
  return 'CollectionDetails(id: $id, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, parts: $parts)';
}


}

/// @nodoc
abstract mixin class _$CollectionDetailsCopyWith<$Res> implements $CollectionDetailsCopyWith<$Res> {
  factory _$CollectionDetailsCopyWith(_CollectionDetails value, $Res Function(_CollectionDetails) _then) = __$CollectionDetailsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name,@HiveField(2) String? overview,@HiveField(3)@JsonKey(name: 'poster_path') String? posterPath,@HiveField(4)@JsonKey(name: 'backdrop_path') String? backdropPath,@HiveField(5)@JsonKey(name: 'parts') List<CollectionPart> parts
});




}
/// @nodoc
class __$CollectionDetailsCopyWithImpl<$Res>
    implements _$CollectionDetailsCopyWith<$Res> {
  __$CollectionDetailsCopyWithImpl(this._self, this._then);

  final _CollectionDetails _self;
  final $Res Function(_CollectionDetails) _then;

/// Create a copy of CollectionDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? parts = null,}) {
  return _then(_CollectionDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<CollectionPart>,
  ));
}


}

// dart format on
