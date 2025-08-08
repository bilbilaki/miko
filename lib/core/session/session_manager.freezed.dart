// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionStateData {
  SessionState get session => throw _privateConstructorUsedError;

  /// Create a copy of SessionStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionStateDataCopyWith<SessionStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateDataCopyWith<$Res> {
  factory $SessionStateDataCopyWith(
          SessionStateData value, $Res Function(SessionStateData) then) =
      _$SessionStateDataCopyWithImpl<$Res, SessionStateData>;
  @useResult
  $Res call({SessionState session});

  $SessionStateCopyWith<$Res> get session;
}

/// @nodoc
class _$SessionStateDataCopyWithImpl<$Res, $Val extends SessionStateData>
    implements $SessionStateDataCopyWith<$Res> {
  _$SessionStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
  }) {
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as SessionState,
    ) as $Val);
  }

  /// Create a copy of SessionStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<$Res> get session {
    return $SessionStateCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionStateDataImplCopyWith<$Res>
    implements $SessionStateDataCopyWith<$Res> {
  factory _$$SessionStateDataImplCopyWith(_$SessionStateDataImpl value,
          $Res Function(_$SessionStateDataImpl) then) =
      __$$SessionStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SessionState session});

  @override
  $SessionStateCopyWith<$Res> get session;
}

/// @nodoc
class __$$SessionStateDataImplCopyWithImpl<$Res>
    extends _$SessionStateDataCopyWithImpl<$Res, _$SessionStateDataImpl>
    implements _$$SessionStateDataImplCopyWith<$Res> {
  __$$SessionStateDataImplCopyWithImpl(_$SessionStateDataImpl _value,
      $Res Function(_$SessionStateDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
  }) {
    return _then(_$SessionStateDataImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as SessionState,
    ));
  }
}

/// @nodoc

class _$SessionStateDataImpl implements _SessionStateData {
  const _$SessionStateDataImpl({required this.session});

  @override
  final SessionState session;

  @override
  String toString() {
    return 'SessionStateData(session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateDataImpl &&
            (identical(other.session, session) || other.session == session));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session);

  /// Create a copy of SessionStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionStateDataImplCopyWith<_$SessionStateDataImpl> get copyWith =>
      __$$SessionStateDataImplCopyWithImpl<_$SessionStateDataImpl>(
          this, _$identity);
}

abstract class _SessionStateData implements SessionStateData {
  const factory _SessionStateData({required final SessionState session}) =
      _$SessionStateDataImpl;

  @override
  SessionState get session;

  /// Create a copy of SessionStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionStateDataImplCopyWith<_$SessionStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
