// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_action_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListActionResponse {

@HiveField(0) bool get success;@HiveField(1)@JsonKey(name: 'status_code') int get statusCode;@HiveField(2)@JsonKey(name: 'status_message') String get statusMessage;@HiveField(3)@JsonKey(name: 'list_id') int? get listId;
/// Create a copy of ListActionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListActionResponseCopyWith<ListActionResponse> get copyWith => _$ListActionResponseCopyWithImpl<ListActionResponse>(this as ListActionResponse, _$identity);

  /// Serializes this ListActionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListActionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage)&&(identical(other.listId, listId) || other.listId == listId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,statusCode,statusMessage,listId);

@override
String toString() {
  return 'ListActionResponse(success: $success, statusCode: $statusCode, statusMessage: $statusMessage, listId: $listId)';
}


}

/// @nodoc
abstract mixin class $ListActionResponseCopyWith<$Res>  {
  factory $ListActionResponseCopyWith(ListActionResponse value, $Res Function(ListActionResponse) _then) = _$ListActionResponseCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool success,@HiveField(1)@JsonKey(name: 'status_code') int statusCode,@HiveField(2)@JsonKey(name: 'status_message') String statusMessage,@HiveField(3)@JsonKey(name: 'list_id') int? listId
});




}
/// @nodoc
class _$ListActionResponseCopyWithImpl<$Res>
    implements $ListActionResponseCopyWith<$Res> {
  _$ListActionResponseCopyWithImpl(this._self, this._then);

  final ListActionResponse _self;
  final $Res Function(ListActionResponse) _then;

/// Create a copy of ListActionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? statusCode = null,Object? statusMessage = null,Object? listId = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ListActionResponse].
extension ListActionResponsePatterns on ListActionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListActionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListActionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListActionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ListActionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListActionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ListActionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'status_code')  int statusCode, @HiveField(2)@JsonKey(name: 'status_message')  String statusMessage, @HiveField(3)@JsonKey(name: 'list_id')  int? listId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListActionResponse() when $default != null:
return $default(_that.success,_that.statusCode,_that.statusMessage,_that.listId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'status_code')  int statusCode, @HiveField(2)@JsonKey(name: 'status_message')  String statusMessage, @HiveField(3)@JsonKey(name: 'list_id')  int? listId)  $default,) {final _that = this;
switch (_that) {
case _ListActionResponse():
return $default(_that.success,_that.statusCode,_that.statusMessage,_that.listId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'status_code')  int statusCode, @HiveField(2)@JsonKey(name: 'status_message')  String statusMessage, @HiveField(3)@JsonKey(name: 'list_id')  int? listId)?  $default,) {final _that = this;
switch (_that) {
case _ListActionResponse() when $default != null:
return $default(_that.success,_that.statusCode,_that.statusMessage,_that.listId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _ListActionResponse implements ListActionResponse {
  const _ListActionResponse({@HiveField(0) required this.success, @HiveField(1)@JsonKey(name: 'status_code') required this.statusCode, @HiveField(2)@JsonKey(name: 'status_message') required this.statusMessage, @HiveField(3)@JsonKey(name: 'list_id') this.listId});
  factory _ListActionResponse.fromJson(Map<String, dynamic> json) => _$ListActionResponseFromJson(json);

@override@HiveField(0) final  bool success;
@override@HiveField(1)@JsonKey(name: 'status_code') final  int statusCode;
@override@HiveField(2)@JsonKey(name: 'status_message') final  String statusMessage;
@override@HiveField(3)@JsonKey(name: 'list_id') final  int? listId;

/// Create a copy of ListActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListActionResponseCopyWith<_ListActionResponse> get copyWith => __$ListActionResponseCopyWithImpl<_ListActionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListActionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListActionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage)&&(identical(other.listId, listId) || other.listId == listId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,statusCode,statusMessage,listId);

@override
String toString() {
  return 'ListActionResponse(success: $success, statusCode: $statusCode, statusMessage: $statusMessage, listId: $listId)';
}


}

/// @nodoc
abstract mixin class _$ListActionResponseCopyWith<$Res> implements $ListActionResponseCopyWith<$Res> {
  factory _$ListActionResponseCopyWith(_ListActionResponse value, $Res Function(_ListActionResponse) _then) = __$ListActionResponseCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool success,@HiveField(1)@JsonKey(name: 'status_code') int statusCode,@HiveField(2)@JsonKey(name: 'status_message') String statusMessage,@HiveField(3)@JsonKey(name: 'list_id') int? listId
});




}
/// @nodoc
class __$ListActionResponseCopyWithImpl<$Res>
    implements _$ListActionResponseCopyWith<$Res> {
  __$ListActionResponseCopyWithImpl(this._self, this._then);

  final _ListActionResponse _self;
  final $Res Function(_ListActionResponse) _then;

/// Create a copy of ListActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? statusCode = null,Object? statusMessage = null,Object? listId = freezed,}) {
  return _then(_ListActionResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
