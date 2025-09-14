// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuestSession {

@HiveField(0) bool get success;@HiveField(1)@JsonKey(name: 'guest_session_id') String get guestSessionId;@HiveField(2)@JsonKey(name: 'expires_at') String get expiresAt;
/// Create a copy of GuestSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestSessionCopyWith<GuestSession> get copyWith => _$GuestSessionCopyWithImpl<GuestSession>(this as GuestSession, _$identity);

  /// Serializes this GuestSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuestSession&&(identical(other.success, success) || other.success == success)&&(identical(other.guestSessionId, guestSessionId) || other.guestSessionId == guestSessionId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,guestSessionId,expiresAt);

@override
String toString() {
  return 'GuestSession(success: $success, guestSessionId: $guestSessionId, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $GuestSessionCopyWith<$Res>  {
  factory $GuestSessionCopyWith(GuestSession value, $Res Function(GuestSession) _then) = _$GuestSessionCopyWithImpl;
@useResult
$Res call({
@HiveField(0) bool success,@HiveField(1)@JsonKey(name: 'guest_session_id') String guestSessionId,@HiveField(2)@JsonKey(name: 'expires_at') String expiresAt
});




}
/// @nodoc
class _$GuestSessionCopyWithImpl<$Res>
    implements $GuestSessionCopyWith<$Res> {
  _$GuestSessionCopyWithImpl(this._self, this._then);

  final GuestSession _self;
  final $Res Function(GuestSession) _then;

/// Create a copy of GuestSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? guestSessionId = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,guestSessionId: null == guestSessionId ? _self.guestSessionId : guestSessionId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GuestSession].
extension GuestSessionPatterns on GuestSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuestSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuestSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuestSession value)  $default,){
final _that = this;
switch (_that) {
case _GuestSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuestSession value)?  $default,){
final _that = this;
switch (_that) {
case _GuestSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'guest_session_id')  String guestSessionId, @HiveField(2)@JsonKey(name: 'expires_at')  String expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuestSession() when $default != null:
return $default(_that.success,_that.guestSessionId,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'guest_session_id')  String guestSessionId, @HiveField(2)@JsonKey(name: 'expires_at')  String expiresAt)  $default,) {final _that = this;
switch (_that) {
case _GuestSession():
return $default(_that.success,_that.guestSessionId,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  bool success, @HiveField(1)@JsonKey(name: 'guest_session_id')  String guestSessionId, @HiveField(2)@JsonKey(name: 'expires_at')  String expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _GuestSession() when $default != null:
return $default(_that.success,_that.guestSessionId,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _GuestSession implements GuestSession {
  const _GuestSession({@HiveField(0) required this.success, @HiveField(1)@JsonKey(name: 'guest_session_id') required this.guestSessionId, @HiveField(2)@JsonKey(name: 'expires_at') required this.expiresAt});
  factory _GuestSession.fromJson(Map<String, dynamic> json) => _$GuestSessionFromJson(json);

@override@HiveField(0) final  bool success;
@override@HiveField(1)@JsonKey(name: 'guest_session_id') final  String guestSessionId;
@override@HiveField(2)@JsonKey(name: 'expires_at') final  String expiresAt;

/// Create a copy of GuestSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuestSessionCopyWith<_GuestSession> get copyWith => __$GuestSessionCopyWithImpl<_GuestSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuestSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuestSession&&(identical(other.success, success) || other.success == success)&&(identical(other.guestSessionId, guestSessionId) || other.guestSessionId == guestSessionId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,guestSessionId,expiresAt);

@override
String toString() {
  return 'GuestSession(success: $success, guestSessionId: $guestSessionId, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$GuestSessionCopyWith<$Res> implements $GuestSessionCopyWith<$Res> {
  factory _$GuestSessionCopyWith(_GuestSession value, $Res Function(_GuestSession) _then) = __$GuestSessionCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) bool success,@HiveField(1)@JsonKey(name: 'guest_session_id') String guestSessionId,@HiveField(2)@JsonKey(name: 'expires_at') String expiresAt
});




}
/// @nodoc
class __$GuestSessionCopyWithImpl<$Res>
    implements _$GuestSessionCopyWith<$Res> {
  __$GuestSessionCopyWithImpl(this._self, this._then);

  final _GuestSession _self;
  final $Res Function(_GuestSession) _then;

/// Create a copy of GuestSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? guestSessionId = null,Object? expiresAt = null,}) {
  return _then(_GuestSession(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,guestSessionId: null == guestSessionId ? _self.guestSessionId : guestSessionId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
