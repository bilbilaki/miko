// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchProvider {

@HiveField(0) int get providerId;@HiveField(1) String get providerName;@HiveField(2)@JsonKey(name: 'logo_path') String? get logoPath;@HiveField(3)@JsonKey(name: 'display_priority') int? get displayPriority;@HiveField(4) String? get type;
/// Create a copy of WatchProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProviderCopyWith<WatchProvider> get copyWith => _$WatchProviderCopyWithImpl<WatchProvider>(this as WatchProvider, _$identity);

  /// Serializes this WatchProvider to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProvider&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.logoPath, logoPath) || other.logoPath == logoPath)&&(identical(other.displayPriority, displayPriority) || other.displayPriority == displayPriority)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerId,providerName,logoPath,displayPriority,type);

@override
String toString() {
  return 'WatchProvider(providerId: $providerId, providerName: $providerName, logoPath: $logoPath, displayPriority: $displayPriority, type: $type)';
}


}

/// @nodoc
abstract mixin class $WatchProviderCopyWith<$Res>  {
  factory $WatchProviderCopyWith(WatchProvider value, $Res Function(WatchProvider) _then) = _$WatchProviderCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int providerId,@HiveField(1) String providerName,@HiveField(2)@JsonKey(name: 'logo_path') String? logoPath,@HiveField(3)@JsonKey(name: 'display_priority') int? displayPriority,@HiveField(4) String? type
});




}
/// @nodoc
class _$WatchProviderCopyWithImpl<$Res>
    implements $WatchProviderCopyWith<$Res> {
  _$WatchProviderCopyWithImpl(this._self, this._then);

  final WatchProvider _self;
  final $Res Function(WatchProvider) _then;

/// Create a copy of WatchProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providerId = null,Object? providerName = null,Object? logoPath = freezed,Object? displayPriority = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as int,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,displayPriority: freezed == displayPriority ? _self.displayPriority : displayPriority // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchProvider].
extension WatchProviderPatterns on WatchProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchProvider value)  $default,){
final _that = this;
switch (_that) {
case _WatchProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchProvider value)?  $default,){
final _that = this;
switch (_that) {
case _WatchProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int providerId, @HiveField(1)  String providerName, @HiveField(2)@JsonKey(name: 'logo_path')  String? logoPath, @HiveField(3)@JsonKey(name: 'display_priority')  int? displayPriority, @HiveField(4)  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchProvider() when $default != null:
return $default(_that.providerId,_that.providerName,_that.logoPath,_that.displayPriority,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int providerId, @HiveField(1)  String providerName, @HiveField(2)@JsonKey(name: 'logo_path')  String? logoPath, @HiveField(3)@JsonKey(name: 'display_priority')  int? displayPriority, @HiveField(4)  String? type)  $default,) {final _that = this;
switch (_that) {
case _WatchProvider():
return $default(_that.providerId,_that.providerName,_that.logoPath,_that.displayPriority,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int providerId, @HiveField(1)  String providerName, @HiveField(2)@JsonKey(name: 'logo_path')  String? logoPath, @HiveField(3)@JsonKey(name: 'display_priority')  int? displayPriority, @HiveField(4)  String? type)?  $default,) {final _that = this;
switch (_that) {
case _WatchProvider() when $default != null:
return $default(_that.providerId,_that.providerName,_that.logoPath,_that.displayPriority,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _WatchProvider implements WatchProvider {
  const _WatchProvider({@HiveField(0) required this.providerId, @HiveField(1) required this.providerName, @HiveField(2)@JsonKey(name: 'logo_path') this.logoPath, @HiveField(3)@JsonKey(name: 'display_priority') this.displayPriority, @HiveField(4) this.type});
  factory _WatchProvider.fromJson(Map<String, dynamic> json) => _$WatchProviderFromJson(json);

@override@HiveField(0) final  int providerId;
@override@HiveField(1) final  String providerName;
@override@HiveField(2)@JsonKey(name: 'logo_path') final  String? logoPath;
@override@HiveField(3)@JsonKey(name: 'display_priority') final  int? displayPriority;
@override@HiveField(4) final  String? type;

/// Create a copy of WatchProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchProviderCopyWith<_WatchProvider> get copyWith => __$WatchProviderCopyWithImpl<_WatchProvider>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchProviderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchProvider&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.logoPath, logoPath) || other.logoPath == logoPath)&&(identical(other.displayPriority, displayPriority) || other.displayPriority == displayPriority)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerId,providerName,logoPath,displayPriority,type);

@override
String toString() {
  return 'WatchProvider(providerId: $providerId, providerName: $providerName, logoPath: $logoPath, displayPriority: $displayPriority, type: $type)';
}


}

/// @nodoc
abstract mixin class _$WatchProviderCopyWith<$Res> implements $WatchProviderCopyWith<$Res> {
  factory _$WatchProviderCopyWith(_WatchProvider value, $Res Function(_WatchProvider) _then) = __$WatchProviderCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int providerId,@HiveField(1) String providerName,@HiveField(2)@JsonKey(name: 'logo_path') String? logoPath,@HiveField(3)@JsonKey(name: 'display_priority') int? displayPriority,@HiveField(4) String? type
});




}
/// @nodoc
class __$WatchProviderCopyWithImpl<$Res>
    implements _$WatchProviderCopyWith<$Res> {
  __$WatchProviderCopyWithImpl(this._self, this._then);

  final _WatchProvider _self;
  final $Res Function(_WatchProvider) _then;

/// Create a copy of WatchProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providerId = null,Object? providerName = null,Object? logoPath = freezed,Object? displayPriority = freezed,Object? type = freezed,}) {
  return _then(_WatchProvider(
providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as int,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,displayPriority: freezed == displayPriority ? _self.displayPriority : displayPriority // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WatchProviderCountry {

@HiveField(0)@JsonKey(name: 'link') String? get link;@HiveField(1)@JsonKey(name: 'flatrate') List<WatchProvider>? get flatrate;@HiveField(2)@JsonKey(name: 'rent') List<WatchProvider>? get rent;@HiveField(3)@JsonKey(name: 'buy') List<WatchProvider>? get buy;@HiveField(4)@JsonKey(name: 'ads') List<WatchProvider>? get ads;
/// Create a copy of WatchProviderCountry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProviderCountryCopyWith<WatchProviderCountry> get copyWith => _$WatchProviderCountryCopyWithImpl<WatchProviderCountry>(this as WatchProviderCountry, _$identity);

  /// Serializes this WatchProviderCountry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProviderCountry&&(identical(other.link, link) || other.link == link)&&const DeepCollectionEquality().equals(other.flatrate, flatrate)&&const DeepCollectionEquality().equals(other.rent, rent)&&const DeepCollectionEquality().equals(other.buy, buy)&&const DeepCollectionEquality().equals(other.ads, ads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,link,const DeepCollectionEquality().hash(flatrate),const DeepCollectionEquality().hash(rent),const DeepCollectionEquality().hash(buy),const DeepCollectionEquality().hash(ads));

@override
String toString() {
  return 'WatchProviderCountry(link: $link, flatrate: $flatrate, rent: $rent, buy: $buy, ads: $ads)';
}


}

/// @nodoc
abstract mixin class $WatchProviderCountryCopyWith<$Res>  {
  factory $WatchProviderCountryCopyWith(WatchProviderCountry value, $Res Function(WatchProviderCountry) _then) = _$WatchProviderCountryCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@JsonKey(name: 'link') String? link,@HiveField(1)@JsonKey(name: 'flatrate') List<WatchProvider>? flatrate,@HiveField(2)@JsonKey(name: 'rent') List<WatchProvider>? rent,@HiveField(3)@JsonKey(name: 'buy') List<WatchProvider>? buy,@HiveField(4)@JsonKey(name: 'ads') List<WatchProvider>? ads
});




}
/// @nodoc
class _$WatchProviderCountryCopyWithImpl<$Res>
    implements $WatchProviderCountryCopyWith<$Res> {
  _$WatchProviderCountryCopyWithImpl(this._self, this._then);

  final WatchProviderCountry _self;
  final $Res Function(WatchProviderCountry) _then;

/// Create a copy of WatchProviderCountry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? link = freezed,Object? flatrate = freezed,Object? rent = freezed,Object? buy = freezed,Object? ads = freezed,}) {
  return _then(_self.copyWith(
link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,flatrate: freezed == flatrate ? _self.flatrate : flatrate // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,rent: freezed == rent ? _self.rent : rent // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,buy: freezed == buy ? _self.buy : buy // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,ads: freezed == ads ? _self.ads : ads // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchProviderCountry].
extension WatchProviderCountryPatterns on WatchProviderCountry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchProviderCountry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchProviderCountry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchProviderCountry value)  $default,){
final _that = this;
switch (_that) {
case _WatchProviderCountry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchProviderCountry value)?  $default,){
final _that = this;
switch (_that) {
case _WatchProviderCountry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'link')  String? link, @HiveField(1)@JsonKey(name: 'flatrate')  List<WatchProvider>? flatrate, @HiveField(2)@JsonKey(name: 'rent')  List<WatchProvider>? rent, @HiveField(3)@JsonKey(name: 'buy')  List<WatchProvider>? buy, @HiveField(4)@JsonKey(name: 'ads')  List<WatchProvider>? ads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchProviderCountry() when $default != null:
return $default(_that.link,_that.flatrate,_that.rent,_that.buy,_that.ads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@JsonKey(name: 'link')  String? link, @HiveField(1)@JsonKey(name: 'flatrate')  List<WatchProvider>? flatrate, @HiveField(2)@JsonKey(name: 'rent')  List<WatchProvider>? rent, @HiveField(3)@JsonKey(name: 'buy')  List<WatchProvider>? buy, @HiveField(4)@JsonKey(name: 'ads')  List<WatchProvider>? ads)  $default,) {final _that = this;
switch (_that) {
case _WatchProviderCountry():
return $default(_that.link,_that.flatrate,_that.rent,_that.buy,_that.ads);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@JsonKey(name: 'link')  String? link, @HiveField(1)@JsonKey(name: 'flatrate')  List<WatchProvider>? flatrate, @HiveField(2)@JsonKey(name: 'rent')  List<WatchProvider>? rent, @HiveField(3)@JsonKey(name: 'buy')  List<WatchProvider>? buy, @HiveField(4)@JsonKey(name: 'ads')  List<WatchProvider>? ads)?  $default,) {final _that = this;
switch (_that) {
case _WatchProviderCountry() when $default != null:
return $default(_that.link,_that.flatrate,_that.rent,_that.buy,_that.ads);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WatchProviderCountry implements WatchProviderCountry {
  const _WatchProviderCountry({@HiveField(0)@JsonKey(name: 'link') this.link, @HiveField(1)@JsonKey(name: 'flatrate') final  List<WatchProvider>? flatrate, @HiveField(2)@JsonKey(name: 'rent') final  List<WatchProvider>? rent, @HiveField(3)@JsonKey(name: 'buy') final  List<WatchProvider>? buy, @HiveField(4)@JsonKey(name: 'ads') final  List<WatchProvider>? ads}): _flatrate = flatrate,_rent = rent,_buy = buy,_ads = ads;
  factory _WatchProviderCountry.fromJson(Map<String, dynamic> json) => _$WatchProviderCountryFromJson(json);

@override@HiveField(0)@JsonKey(name: 'link') final  String? link;
 final  List<WatchProvider>? _flatrate;
@override@HiveField(1)@JsonKey(name: 'flatrate') List<WatchProvider>? get flatrate {
  final value = _flatrate;
  if (value == null) return null;
  if (_flatrate is EqualUnmodifiableListView) return _flatrate;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<WatchProvider>? _rent;
@override@HiveField(2)@JsonKey(name: 'rent') List<WatchProvider>? get rent {
  final value = _rent;
  if (value == null) return null;
  if (_rent is EqualUnmodifiableListView) return _rent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<WatchProvider>? _buy;
@override@HiveField(3)@JsonKey(name: 'buy') List<WatchProvider>? get buy {
  final value = _buy;
  if (value == null) return null;
  if (_buy is EqualUnmodifiableListView) return _buy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<WatchProvider>? _ads;
@override@HiveField(4)@JsonKey(name: 'ads') List<WatchProvider>? get ads {
  final value = _ads;
  if (value == null) return null;
  if (_ads is EqualUnmodifiableListView) return _ads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of WatchProviderCountry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchProviderCountryCopyWith<_WatchProviderCountry> get copyWith => __$WatchProviderCountryCopyWithImpl<_WatchProviderCountry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchProviderCountryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchProviderCountry&&(identical(other.link, link) || other.link == link)&&const DeepCollectionEquality().equals(other._flatrate, _flatrate)&&const DeepCollectionEquality().equals(other._rent, _rent)&&const DeepCollectionEquality().equals(other._buy, _buy)&&const DeepCollectionEquality().equals(other._ads, _ads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,link,const DeepCollectionEquality().hash(_flatrate),const DeepCollectionEquality().hash(_rent),const DeepCollectionEquality().hash(_buy),const DeepCollectionEquality().hash(_ads));

@override
String toString() {
  return 'WatchProviderCountry(link: $link, flatrate: $flatrate, rent: $rent, buy: $buy, ads: $ads)';
}


}

/// @nodoc
abstract mixin class _$WatchProviderCountryCopyWith<$Res> implements $WatchProviderCountryCopyWith<$Res> {
  factory _$WatchProviderCountryCopyWith(_WatchProviderCountry value, $Res Function(_WatchProviderCountry) _then) = __$WatchProviderCountryCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@JsonKey(name: 'link') String? link,@HiveField(1)@JsonKey(name: 'flatrate') List<WatchProvider>? flatrate,@HiveField(2)@JsonKey(name: 'rent') List<WatchProvider>? rent,@HiveField(3)@JsonKey(name: 'buy') List<WatchProvider>? buy,@HiveField(4)@JsonKey(name: 'ads') List<WatchProvider>? ads
});




}
/// @nodoc
class __$WatchProviderCountryCopyWithImpl<$Res>
    implements _$WatchProviderCountryCopyWith<$Res> {
  __$WatchProviderCountryCopyWithImpl(this._self, this._then);

  final _WatchProviderCountry _self;
  final $Res Function(_WatchProviderCountry) _then;

/// Create a copy of WatchProviderCountry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? link = freezed,Object? flatrate = freezed,Object? rent = freezed,Object? buy = freezed,Object? ads = freezed,}) {
  return _then(_WatchProviderCountry(
link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,flatrate: freezed == flatrate ? _self._flatrate : flatrate // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,rent: freezed == rent ? _self._rent : rent // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,buy: freezed == buy ? _self._buy : buy // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,ads: freezed == ads ? _self._ads : ads // ignore: cast_nullable_to_non_nullable
as List<WatchProvider>?,
  ));
}


}


/// @nodoc
mixin _$WatchProvidersResponse {

@HiveField(0) int get id;// Map of country code to WatchProviderCountry
@HiveField(1)@JsonKey(name: 'results') Map<String, WatchProviderCountry> get results;
/// Create a copy of WatchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProvidersResponseCopyWith<WatchProvidersResponse> get copyWith => _$WatchProvidersResponseCopyWithImpl<WatchProvidersResponse>(this as WatchProvidersResponse, _$identity);

  /// Serializes this WatchProvidersResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProvidersResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'WatchProvidersResponse(id: $id, results: $results)';
}


}

/// @nodoc
abstract mixin class $WatchProvidersResponseCopyWith<$Res>  {
  factory $WatchProvidersResponseCopyWith(WatchProvidersResponse value, $Res Function(WatchProvidersResponse) _then) = _$WatchProvidersResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'results') Map<String, WatchProviderCountry> results
});




}
/// @nodoc
class _$WatchProvidersResponseCopyWithImpl<$Res>
    implements $WatchProvidersResponseCopyWith<$Res> {
  _$WatchProvidersResponseCopyWithImpl(this._self, this._then);

  final WatchProvidersResponse _self;
  final $Res Function(WatchProvidersResponse) _then;

/// Create a copy of WatchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? results = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as Map<String, WatchProviderCountry>,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchProvidersResponse].
extension WatchProvidersResponsePatterns on WatchProvidersResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchProvidersResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchProvidersResponse value)  $default,){
final _that = this;
switch (_that) {
case _WatchProvidersResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchProvidersResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WatchProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  Map<String, WatchProviderCountry> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  Map<String, WatchProviderCountry> results)  $default,) {final _that = this;
switch (_that) {
case _WatchProvidersResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'results')  Map<String, WatchProviderCountry> results)?  $default,) {final _that = this;
switch (_that) {
case _WatchProvidersResponse() when $default != null:
return $default(_that.id,_that.results);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _WatchProvidersResponse implements WatchProvidersResponse {
  const _WatchProvidersResponse({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'results') required final  Map<String, WatchProviderCountry> results}): _results = results;
  factory _WatchProvidersResponse.fromJson(Map<String, dynamic> json) => _$WatchProvidersResponseFromJson(json);

@override@HiveField(0) final  int id;
// Map of country code to WatchProviderCountry
 final  Map<String, WatchProviderCountry> _results;
// Map of country code to WatchProviderCountry
@override@HiveField(1)@JsonKey(name: 'results') Map<String, WatchProviderCountry> get results {
  if (_results is EqualUnmodifiableMapView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_results);
}


/// Create a copy of WatchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchProvidersResponseCopyWith<_WatchProvidersResponse> get copyWith => __$WatchProvidersResponseCopyWithImpl<_WatchProvidersResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchProvidersResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchProvidersResponse&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'WatchProvidersResponse(id: $id, results: $results)';
}


}

/// @nodoc
abstract mixin class _$WatchProvidersResponseCopyWith<$Res> implements $WatchProvidersResponseCopyWith<$Res> {
  factory _$WatchProvidersResponseCopyWith(_WatchProvidersResponse value, $Res Function(_WatchProvidersResponse) _then) = __$WatchProvidersResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'results') Map<String, WatchProviderCountry> results
});




}
/// @nodoc
class __$WatchProvidersResponseCopyWithImpl<$Res>
    implements _$WatchProvidersResponseCopyWith<$Res> {
  __$WatchProvidersResponseCopyWithImpl(this._self, this._then);

  final _WatchProvidersResponse _self;
  final $Res Function(_WatchProvidersResponse) _then;

/// Create a copy of WatchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? results = null,}) {
  return _then(_WatchProvidersResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as Map<String, WatchProviderCountry>,
  ));
}


}

// dart format on
