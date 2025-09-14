// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RatingResponse {

@HiveField(0) bool get success;@HiveField(1)@JsonKey(name: 'status_code') int get statusCode;@HiveField(2)@JsonKey(name: 'status_message') String get statusMessage;
/// Create a copy of RatingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingResponseCopyWith<RatingResponse> get copyWith => _$RatingResponseCopyWithImpl<RatingResponse>(this as RatingResponse, _$identity);

  /// Serializes this RatingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,statusCode,statusMessage);

@override
String toString() {
  return 'RatingResponse(success: $success, statusCode: $statusCode, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class $RatingResponseCopyWith<$Res>  {
  factory $RatingResponseCopyWith(RatingResponse value, $Res Function(RatingResponse) _then) = _$RatingResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool success,@HiveField(1)@JsonKey(name: 'status_code') int statusCode,@HiveField(2)@JsonKey(name: 'status_message') String statusMessage
});




}
/// @nodoc
class _$RatingResponseCopyWithImpl<$Res>
    implements $RatingResponseCopyWith<$Res> {
  _$RatingResponseCopyWithImpl(this._self, this._then);

  final RatingResponse _self;
  final $Res Function(RatingResponse) _then;

/// Create a copy of RatingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? statusCode = null,Object? statusMessage = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RatingResponse].
extension RatingResponsePatterns on RatingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RatingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RatingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RatingResponse value)  $default,){
final _that = this;
switch (_that) {
case _RatingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RatingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RatingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'status_code')  int statusCode, @HiveField(2)@JsonKey(name: 'status_message')  String statusMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RatingResponse() when $default != null:
return $default(_that.success,_that.statusCode,_that.statusMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'status_code')  int statusCode, @HiveField(2)@JsonKey(name: 'status_message')  String statusMessage)  $default,) {final _that = this;
switch (_that) {
case _RatingResponse():
return $default(_that.success,_that.statusCode,_that.statusMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'status_code')  int statusCode, @HiveField(2)@JsonKey(name: 'status_message')  String statusMessage)?  $default,) {final _that = this;
switch (_that) {
case _RatingResponse() when $default != null:
return $default(_that.success,_that.statusCode,_that.statusMessage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _RatingResponse implements RatingResponse {
  const _RatingResponse({@HiveField(0) required this.success, @HiveField(1)@JsonKey(name: 'status_code') required this.statusCode, @HiveField(2)@JsonKey(name: 'status_message') required this.statusMessage});
  factory _RatingResponse.fromJson(Map<String, dynamic> json) => _$RatingResponseFromJson(json);

@override@HiveField(0) final  bool success;
@override@HiveField(1)@JsonKey(name: 'status_code') final  int statusCode;
@override@HiveField(2)@JsonKey(name: 'status_message') final  String statusMessage;

/// Create a copy of RatingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingResponseCopyWith<_RatingResponse> get copyWith => __$RatingResponseCopyWithImpl<_RatingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatingResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,statusCode,statusMessage);

@override
String toString() {
  return 'RatingResponse(success: $success, statusCode: $statusCode, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$RatingResponseCopyWith<$Res> implements $RatingResponseCopyWith<$Res> {
  factory _$RatingResponseCopyWith(_RatingResponse value, $Res Function(_RatingResponse) _then) = __$RatingResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool success,@HiveField(1)@JsonKey(name: 'status_code') int statusCode,@HiveField(2)@JsonKey(name: 'status_message') String statusMessage
});




}
/// @nodoc
class __$RatingResponseCopyWithImpl<$Res>
    implements _$RatingResponseCopyWith<$Res> {
  __$RatingResponseCopyWithImpl(this._self, this._then);

  final _RatingResponse _self;
  final $Res Function(_RatingResponse) _then;

/// Create a copy of RatingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? statusCode = null,Object? statusMessage = null,}) {
  return _then(_RatingResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
