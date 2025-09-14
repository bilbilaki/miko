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
mixin _$TranslationData {

@HiveField(0) String? get title;@HiveField(1) String? get overview;@HiveField(2) String? get homepage;@HiveField(3) String? get tagline;@HiveField(4) String? get runtime;
/// Create a copy of TranslationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationDataCopyWith<TranslationData> get copyWith => _$TranslationDataCopyWithImpl<TranslationData>(this as TranslationData, _$identity);

  /// Serializes this TranslationData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationData&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,overview,homepage,tagline,runtime);

@override
String toString() {
  return 'TranslationData(title: $title, overview: $overview, homepage: $homepage, tagline: $tagline, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class $TranslationDataCopyWith<$Res>  {
  factory $TranslationDataCopyWith(TranslationData value, $Res Function(TranslationData) _then) = _$TranslationDataCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String? title,@HiveField(1) String? overview,@HiveField(2) String? homepage,@HiveField(3) String? tagline,@HiveField(4) String? runtime
});




}
/// @nodoc
class _$TranslationDataCopyWithImpl<$Res>
    implements $TranslationDataCopyWith<$Res> {
  _$TranslationDataCopyWithImpl(this._self, this._then);

  final TranslationData _self;
  final $Res Function(TranslationData) _then;

/// Create a copy of TranslationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? overview = freezed,Object? homepage = freezed,Object? tagline = freezed,Object? runtime = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationData].
extension TranslationDataPatterns on TranslationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationData value)  $default,){
final _that = this;
switch (_that) {
case _TranslationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationData value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String? title, @HiveField(1)  String? overview, @HiveField(2)  String? homepage, @HiveField(3)  String? tagline, @HiveField(4)  String? runtime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationData() when $default != null:
return $default(_that.title,_that.overview,_that.homepage,_that.tagline,_that.runtime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String? title, @HiveField(1)  String? overview, @HiveField(2)  String? homepage, @HiveField(3)  String? tagline, @HiveField(4)  String? runtime)  $default,) {final _that = this;
switch (_that) {
case _TranslationData():
return $default(_that.title,_that.overview,_that.homepage,_that.tagline,_that.runtime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String? title, @HiveField(1)  String? overview, @HiveField(2)  String? homepage, @HiveField(3)  String? tagline, @HiveField(4)  String? runtime)?  $default,) {final _that = this;
switch (_that) {
case _TranslationData() when $default != null:
return $default(_that.title,_that.overview,_that.homepage,_that.tagline,_that.runtime);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _TranslationData implements TranslationData {
  const _TranslationData({@HiveField(0) this.title, @HiveField(1) this.overview, @HiveField(2) this.homepage, @HiveField(3) this.tagline, @HiveField(4) this.runtime});
  factory _TranslationData.fromJson(Map<String, dynamic> json) => _$TranslationDataFromJson(json);

@override@HiveField(0) final  String? title;
@override@HiveField(1) final  String? overview;
@override@HiveField(2) final  String? homepage;
@override@HiveField(3) final  String? tagline;
@override@HiveField(4) final  String? runtime;

/// Create a copy of TranslationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationDataCopyWith<_TranslationData> get copyWith => __$TranslationDataCopyWithImpl<_TranslationData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationData&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.homepage, homepage) || other.homepage == homepage)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,overview,homepage,tagline,runtime);

@override
String toString() {
  return 'TranslationData(title: $title, overview: $overview, homepage: $homepage, tagline: $tagline, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class _$TranslationDataCopyWith<$Res> implements $TranslationDataCopyWith<$Res> {
  factory _$TranslationDataCopyWith(_TranslationData value, $Res Function(_TranslationData) _then) = __$TranslationDataCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String? title,@HiveField(1) String? overview,@HiveField(2) String? homepage,@HiveField(3) String? tagline,@HiveField(4) String? runtime
});




}
/// @nodoc
class __$TranslationDataCopyWithImpl<$Res>
    implements _$TranslationDataCopyWith<$Res> {
  __$TranslationDataCopyWithImpl(this._self, this._then);

  final _TranslationData _self;
  final $Res Function(_TranslationData) _then;

/// Create a copy of TranslationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? overview = freezed,Object? homepage = freezed,Object? tagline = freezed,Object? runtime = freezed,}) {
  return _then(_TranslationData(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,homepage: freezed == homepage ? _self.homepage : homepage // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TranslationItem {

@HiveField(0)@JsonKey(name: 'iso_639_1') String get iso6391;@HiveField(1) String get name;@HiveField(2)@JsonKey(name: 'english_name') String get englishName;@HiveField(3) TranslationData get data;
/// Create a copy of TranslationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationItemCopyWith<TranslationItem> get copyWith => _$TranslationItemCopyWithImpl<TranslationItem>(this as TranslationItem, _$identity);

  /// Serializes this TranslationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationItem&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.name, name) || other.name == name)&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso6391,name,englishName,data);

@override
String toString() {
  return 'TranslationItem(iso6391: $iso6391, name: $name, englishName: $englishName, data: $data)';
}


}

/// @nodoc
abstract mixin class $TranslationItemCopyWith<$Res>  {
  factory $TranslationItemCopyWith(TranslationItem value, $Res Function(TranslationItem) _then) = _$TranslationItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'iso_639_1') String iso6391,@HiveField(1) String name,@HiveField(2)@JsonKey(name: 'english_name') String englishName,@HiveField(3) TranslationData data
});


$TranslationDataCopyWith<$Res> get data;

}
/// @nodoc
class _$TranslationItemCopyWithImpl<$Res>
    implements $TranslationItemCopyWith<$Res> {
  _$TranslationItemCopyWithImpl(this._self, this._then);

  final TranslationItem _self;
  final $Res Function(TranslationItem) _then;

/// Create a copy of TranslationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iso6391 = null,Object? name = null,Object? englishName = null,Object? data = null,}) {
  return _then(_self.copyWith(
iso6391: null == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,englishName: null == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TranslationData,
  ));
}
/// Create a copy of TranslationItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TranslationDataCopyWith<$Res> get data {
  
  return $TranslationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TranslationItem].
extension TranslationItemPatterns on TranslationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationItem value)  $default,){
final _that = this;
switch (_that) {
case _TranslationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationItem value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'iso_639_1')  String iso6391, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'english_name')  String englishName, @HiveField(3)  TranslationData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'iso_639_1')  String iso6391, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'english_name')  String englishName, @HiveField(3)  TranslationData data)  $default,) {final _that = this;
switch (_that) {
case _TranslationItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'iso_639_1')  String iso6391, @HiveField(1)  String name, @HiveField(2)@JsonKey(name: 'english_name')  String englishName, @HiveField(3)  TranslationData data)?  $default,) {final _that = this;
switch (_that) {
case _TranslationItem() when $default != null:
return $default(_that.iso6391,_that.name,_that.englishName,_that.data);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TranslationItem implements TranslationItem {
  const _TranslationItem({@HiveField(0)@JsonKey(name: 'iso_639_1') required this.iso6391, @HiveField(1) required this.name, @HiveField(2)@JsonKey(name: 'english_name') required this.englishName, @HiveField(3) required this.data});
  factory _TranslationItem.fromJson(Map<String, dynamic> json) => _$TranslationItemFromJson(json);

@override@HiveField(0)@JsonKey(name: 'iso_639_1') final  String iso6391;
@override@HiveField(1) final  String name;
@override@HiveField(2)@JsonKey(name: 'english_name') final  String englishName;
@override@HiveField(3) final  TranslationData data;

/// Create a copy of TranslationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationItemCopyWith<_TranslationItem> get copyWith => __$TranslationItemCopyWithImpl<_TranslationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationItem&&(identical(other.iso6391, iso6391) || other.iso6391 == iso6391)&&(identical(other.name, name) || other.name == name)&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso6391,name,englishName,data);

@override
String toString() {
  return 'TranslationItem(iso6391: $iso6391, name: $name, englishName: $englishName, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TranslationItemCopyWith<$Res> implements $TranslationItemCopyWith<$Res> {
  factory _$TranslationItemCopyWith(_TranslationItem value, $Res Function(_TranslationItem) _then) = __$TranslationItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'iso_639_1') String iso6391,@HiveField(1) String name,@HiveField(2)@JsonKey(name: 'english_name') String englishName,@HiveField(3) TranslationData data
});


@override $TranslationDataCopyWith<$Res> get data;

}
/// @nodoc
class __$TranslationItemCopyWithImpl<$Res>
    implements _$TranslationItemCopyWith<$Res> {
  __$TranslationItemCopyWithImpl(this._self, this._then);

  final _TranslationItem _self;
  final $Res Function(_TranslationItem) _then;

/// Create a copy of TranslationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iso6391 = null,Object? name = null,Object? englishName = null,Object? data = null,}) {
  return _then(_TranslationItem(
iso6391: null == iso6391 ? _self.iso6391 : iso6391 // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,englishName: null == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TranslationData,
  ));
}

/// Create a copy of TranslationItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TranslationDataCopyWith<$Res> get data {
  
  return $TranslationDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$TranslationsResponse {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'translations') List<TranslationItem> get translations;
/// Create a copy of TranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationsResponseCopyWith<TranslationsResponse> get copyWith => _$TranslationsResponseCopyWithImpl<TranslationsResponse>(this as TranslationsResponse, _$identity);

  /// Serializes this TranslationsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.translations, translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(translations));

@override
String toString() {
  return 'TranslationsResponse(id: $id, translations: $translations)';
}


}

/// @nodoc
abstract mixin class $TranslationsResponseCopyWith<$Res>  {
  factory $TranslationsResponseCopyWith(TranslationsResponse value, $Res Function(TranslationsResponse) _then) = _$TranslationsResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'translations') List<TranslationItem> translations
});




}
/// @nodoc
class _$TranslationsResponseCopyWithImpl<$Res>
    implements $TranslationsResponseCopyWith<$Res> {
  _$TranslationsResponseCopyWithImpl(this._self, this._then);

  final TranslationsResponse _self;
  final $Res Function(TranslationsResponse) _then;

/// Create a copy of TranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? translations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<TranslationItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationsResponse].
extension TranslationsResponsePatterns on TranslationsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TranslationsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'translations')  List<TranslationItem> translations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationsResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'translations')  List<TranslationItem> translations)  $default,) {final _that = this;
switch (_that) {
case _TranslationsResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'translations')  List<TranslationItem> translations)?  $default,) {final _that = this;
switch (_that) {
case _TranslationsResponse() when $default != null:
return $default(_that.id,_that.translations);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TranslationsResponse implements TranslationsResponse {
  const _TranslationsResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'translations') required final  List<TranslationItem> translations}): _translations = translations;
  factory _TranslationsResponse.fromJson(Map<String, dynamic> json) => _$TranslationsResponseFromJson(json);

@override@HiveField(0) final  int id;
 final  List<TranslationItem> _translations;
@override@HiveField(1)@JsonKey(name: 'translations') List<TranslationItem> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}


/// Create a copy of TranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationsResponseCopyWith<_TranslationsResponse> get copyWith => __$TranslationsResponseCopyWithImpl<_TranslationsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationsResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._translations, _translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_translations));

@override
String toString() {
  return 'TranslationsResponse(id: $id, translations: $translations)';
}


}

/// @nodoc
abstract mixin class _$TranslationsResponseCopyWith<$Res> implements $TranslationsResponseCopyWith<$Res> {
  factory _$TranslationsResponseCopyWith(_TranslationsResponse value, $Res Function(_TranslationsResponse) _then) = __$TranslationsResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'translations') List<TranslationItem> translations
});




}
/// @nodoc
class __$TranslationsResponseCopyWithImpl<$Res>
    implements _$TranslationsResponseCopyWith<$Res> {
  __$TranslationsResponseCopyWithImpl(this._self, this._then);

  final _TranslationsResponse _self;
  final $Res Function(_TranslationsResponse) _then;

/// Create a copy of TranslationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? translations = null,}) {
  return _then(_TranslationsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<TranslationItem>,
  ));
}


}

// dart format on
