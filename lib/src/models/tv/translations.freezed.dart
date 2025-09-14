// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translations.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TvTranslationData {

@HiveField(0) String? get name;@HiveField(1) String? get overview;@HiveField(2) String? get homepage;@HiveField(3) String? get tagline;
/// Create a copy of TvTranslationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTranslationDataCopyWith<TvTranslationData> get copyWith => _$TvTranslationDataCopyWithImpl<TvTranslationData>(this as TvTranslationData, _$identity);

  /// Serializes this TvTranslationData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTranslationData&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.tagline, tagline) || other.tagline == tagline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,overview,homepage,tagline);

@override
String toString() {
  return 'TvTranslationData(name: $name, overview: $overview, homepage: $homepage, tagline: $tagline)';
}


}

/// @nodoc
abstract mixin class $TvTranslationDataCopyWith<$Res>  {
  factory $TvTranslationDataCopyWith(TvTranslationData value, $Res Function(TvTranslationData) _then) = _$TvTranslationDataCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String? name,@HiveField(1) String? overview,@HiveField(2) String? homepage,@HiveField(3) String? tagline
});




}
/// @nodoc
class _$TvTranslationDataCopyWithImpl<$Res>
    implements $TvTranslationDataCopyWith<$Res> {
  _$TvTranslationDataCopyWithImpl(this._self, this._then);

  final TvTranslationData _self;
  final $Res Function(TvTranslationData) _then;

/// Create a copy of TvTranslationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? overview = freezed,Object? homepage = freezed,Object? tagline = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTranslationData].
extension TvTranslationDataPatterns on TvTranslationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTranslationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTranslationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTranslationData value)  $default,){
final _that = this;
switch (_that) {
case _TvTranslationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTranslationData value)?  $default,){
final _that = this;
switch (_that) {
case _TvTranslationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String? name, @HiveField(1)  String? overview, @HiveField(2)  String? homepage, @HiveField(3)  String? tagline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTranslationData() when $default != null:
return $default(_that.name,_that.overview,_that.homepage,_that.tagline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String? name, @HiveField(1)  String? overview, @HiveField(2)  String? homepage, @HiveField(3)  String? tagline)  $default,) {final _that = this;
switch (_that) {
case _TvTranslationData():
return $default(_that.name,_that.overview,_that.homepage,_that.tagline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String? name, @HiveField(1)  String? overview, @HiveField(2)  String? homepage, @HiveField(3)  String? tagline)?  $default,) {final _that = this;
switch (_that) {
case _TvTranslationData() when $default != null:
return $default(_that.name,_that.overview,_that.homepage,_that.tagline);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TvTranslationData implements TvTranslationData {
  const _TvTranslationData({@HiveField(0) this.name, @HiveField(1) this.overview, @HiveField(2) this.homepage, @HiveField(3) this.tagline});
  factory _TvTranslationData.fromJson(Map<String, dynamic> json) => _$TvTranslationDataFromJson(json);

@override@HiveField(0) final  String? name;
@override@HiveField(1) final  String? overview;
@override@HiveField(2) final  String? homepage;
@override@HiveField(3) final  String? tagline;

/// Create a copy of TvTranslationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTranslationDataCopyWith<_TvTranslationData> get copyWith => __$TvTranslationDataCopyWithImpl<_TvTranslationData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvTranslationDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTranslationData&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.tagline, tagline) || other.tagline == tagline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,overview,homepage,tagline);

@override
String toString() {
  return 'TvTranslationData(name: $name, overview: $overview, homepage: $homepage, tagline: $tagline)';
}


}

/// @nodoc
abstract mixin class _$TvTranslationDataCopyWith<$Res> implements $TvTranslationDataCopyWith<$Res> {
  factory _$TvTranslationDataCopyWith(_TvTranslationData value, $Res Function(_TvTranslationData) _then) = __$TvTranslationDataCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String? name,@HiveField(1) String? overview,@HiveField(2) String? homepage,@HiveField(3) String? tagline
});




}
/// @nodoc
class __$TvTranslationDataCopyWithImpl<$Res>
    implements _$TvTranslationDataCopyWith<$Res> {
  __$TvTranslationDataCopyWithImpl(this._self, this._then);

  final _TvTranslationData _self;
  final $Res Function(_TvTranslationData) _then;

/// Create a copy of TvTranslationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? overview = freezed,Object? homepage = freezed,Object? tagline = freezed,}) {
  return _then(_TvTranslationData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TvTranslationItem {

@HiveField(0)@JsonKey(name: 'iso_639_1') String get iso6391;@HiveField(1) String get name;@HiveField(2)@JsonKey(name: 'english_name') String get englishName;@HiveField(3) TvTranslationData get data;
/// Create a copy of TvTranslationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTranslationItemCopyWith<TvTranslationItem> get copyWith => _$TvTranslationItemCopyWithImpl<TvTranslationItem>(this as TvTranslationItem, _$identity);

  /// Serializes this TvTranslationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTranslationItem&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.name, name) || other.name == name)&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso6391,name,englishName,data);

@override
String toString() {
  return 'TvTranslationItem(iso6391: $iso6391, name: $name, englishName: $englishName, data: $data)';
}


}

/// @nodoc
abstract mixin class $TvTranslationItemCopyWith<$Res>  {
  factory $TvTranslationItemCopyWith(TvTranslationItem value, $Res Function(TvTranslationItem) _then) = _$TvTranslationItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'iso_639_1') String iso6391,@HiveField(1) String name,@HiveField(2)@JsonKey(name: 'english_name') String englishName,@HiveField(3) TvTranslationData data
});


$TvTranslationDataCopyWith<$Res> get data;

}
/// @nodoc
class _$TvTranslationItemCopyWithImpl<$Res>
    implements $TvTranslationItemCopyWith<$Res> {
  _$TvTranslationItemCopyWithImpl(this._self, this._then);

  final TvTranslationItem _self;
  final $Res Function(TvTranslationItem) _then;

/// Create a copy of TvTranslationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iso6391 = null,Object? name = null,Object? englishName = null,Object? data = null,}) {
  return _then(_self.copyWith(
iso6391: null == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,englishName: null == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TvTranslationData,
  ));
}
/// Create a copy of TvTranslationItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TvTranslationDataCopyWith<$Res> get data {
  
  return $TvTranslationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TvTranslationItem].
extension TvTranslationItemPatterns on TvTranslationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTranslationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTranslationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTranslationItem value)  $default,){
final _that = this;
switch (_that) {
case _TvTranslationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTranslationItem value)?  $default,){
final _that = this;
switch (_that) {
case _TvTranslationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'iso_639_1')  String iso6391, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'english_name')  String englishName, @HiveField(3)  TvTranslationData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTranslationItem() when $default != null:
return $default(_that.iso6391,_that.name,_that.englishName,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'iso_639_1')  String iso6391, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'english_name')  String englishName, @HiveField(3)  TvTranslationData data)  $default,) {final _that = this;
switch (_that) {
case _TvTranslationItem():
return $default(_that.iso6391,_that.name,_that.englishName,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'iso_639_1')  String iso6391, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'english_name')  String englishName, @HiveField(3)  TvTranslationData data)?  $default,) {final _that = this;
switch (_that) {
case _TvTranslationItem() when $default != null:
return $default(_that.iso6391,_that.name,_that.englishName,_that.data);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TvTranslationItem implements TvTranslationItem {
  const _TvTranslationItem({@HiveField(0)@JsonKey(name: 'iso_639_1') required this.iso6391, @HiveField(1) required this.name, @HiveField(2)@JsonKey(name: 'english_name') required this.englishName, @HiveField(3) required this.data});
  factory _TvTranslationItem.fromJson(Map<String, dynamic> json) => _$TvTranslationItemFromJson(json);

@override@HiveField(0)@JsonKey(name: 'iso_639_1') final  String iso6391;
@override@HiveField(1) final  String name;
@override@HiveField(2)@JsonKey(name: 'english_name') final  String englishName;
@override@HiveField(3) final  TvTranslationData data;

/// Create a copy of TvTranslationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTranslationItemCopyWith<_TvTranslationItem> get copyWith => __$TvTranslationItemCopyWithImpl<_TvTranslationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvTranslationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTranslationItem&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.name, name) || other.name == name)&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso6391,name,englishName,data);

@override
String toString() {
  return 'TvTranslationItem(iso6391: $iso6391, name: $name, englishName: $englishName, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TvTranslationItemCopyWith<$Res> implements $TvTranslationItemCopyWith<$Res> {
  factory _$TvTranslationItemCopyWith(_TvTranslationItem value, $Res Function(_TvTranslationItem) _then) = __$TvTranslationItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'iso_639_1') String iso6391,@HiveField(1) String name,@HiveField(2)@JsonKey(name: 'english_name') String englishName,@HiveField(3) TvTranslationData data
});


@override $TvTranslationDataCopyWith<$Res> get data;

}
/// @nodoc
class __$TvTranslationItemCopyWithImpl<$Res>
    implements _$TvTranslationItemCopyWith<$Res> {
  __$TvTranslationItemCopyWithImpl(this._self, this._then);

  final _TvTranslationItem _self;
  final $Res Function(_TvTranslationItem) _then;

/// Create a copy of TvTranslationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iso6391 = null,Object? name = null,Object? englishName = null,Object? data = null,}) {
  return _then(_TvTranslationItem(
iso6391: null == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,englishName: null == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TvTranslationData,
  ));
}

/// Create a copy of TvTranslationItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TvTranslationDataCopyWith<$Res> get data {
  
  return $TvTranslationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$TvTranslationsResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'translations') List<TvTranslationItem> get translations;
/// Create a copy of TvTranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTranslationsResponseCopyWith<TvTranslationsResponse> get copyWith => _$TvTranslationsResponseCopyWithImpl<TvTranslationsResponse>(this as TvTranslationsResponse, _$identity);

  /// Serializes this TvTranslationsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTranslationsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.translations, translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(translations));

@override
String toString() {
  return 'TvTranslationsResponse(id: $id, translations: $translations)';
}


}

/// @nodoc
abstract mixin class $TvTranslationsResponseCopyWith<$Res>  {
  factory $TvTranslationsResponseCopyWith(TvTranslationsResponse value, $Res Function(TvTranslationsResponse) _then) = _$TvTranslationsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'translations') List<TvTranslationItem> translations
});




}
/// @nodoc
class _$TvTranslationsResponseCopyWithImpl<$Res>
    implements $TvTranslationsResponseCopyWith<$Res> {
  _$TvTranslationsResponseCopyWithImpl(this._self, this._then);

  final TvTranslationsResponse _self;
  final $Res Function(TvTranslationsResponse) _then;

/// Create a copy of TvTranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? translations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<TvTranslationItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTranslationsResponse].
extension TvTranslationsResponsePatterns on TvTranslationsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTranslationsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTranslationsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTranslationsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TvTranslationsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTranslationsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TvTranslationsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'translations')  List<TvTranslationItem> translations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTranslationsResponse() when $default != null:
return $default(_that.id,_that.translations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'translations')  List<TvTranslationItem> translations)  $default,) {final _that = this;
switch (_that) {
case _TvTranslationsResponse():
return $default(_that.id,_that.translations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'translations')  List<TvTranslationItem> translations)?  $default,) {final _that = this;
switch (_that) {
case _TvTranslationsResponse() when $default != null:
return $default(_that.id,_that.translations);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TvTranslationsResponse implements TvTranslationsResponse {
  const _TvTranslationsResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'translations') required final  List<TvTranslationItem> translations}): _translations = translations;
  factory _TvTranslationsResponse.fromJson(Map<String, dynamic> json) => _$TvTranslationsResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<TvTranslationItem> _translations;
@override@HiveField(1)@JsonKey(name: 'translations') List<TvTranslationItem> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}


/// Create a copy of TvTranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTranslationsResponseCopyWith<_TvTranslationsResponse> get copyWith => __$TvTranslationsResponseCopyWithImpl<_TvTranslationsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TvTranslationsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTranslationsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._translations, _translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_translations));

@override
String toString() {
  return 'TvTranslationsResponse(id: $id, translations: $translations)';
}


}

/// @nodoc
abstract mixin class _$TvTranslationsResponseCopyWith<$Res> implements $TvTranslationsResponseCopyWith<$Res> {
  factory _$TvTranslationsResponseCopyWith(_TvTranslationsResponse value, $Res Function(_TvTranslationsResponse) _then) = __$TvTranslationsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'translations') List<TvTranslationItem> translations
});




}
/// @nodoc
class __$TvTranslationsResponseCopyWithImpl<$Res>
    implements _$TvTranslationsResponseCopyWith<$Res> {
  __$TvTranslationsResponseCopyWithImpl(this._self, this._then);

  final _TvTranslationsResponse _self;
  final $Res Function(_TvTranslationsResponse) _then;

/// Create a copy of TvTranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? translations = null,}) {
  return _then(_TvTranslationsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<TvTranslationItem>,
  ));
}


}

// dart format on
