// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fs_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EntryAccess _$EntryAccessFromJson(Map<String, dynamic> json) {
  return _EntryAccess.fromJson(json);
}

/// @nodoc
mixin _$EntryAccess {
  bool get readable => throw _privateConstructorUsedError;
  bool get writable => throw _privateConstructorUsedError;
  bool get executable => throw _privateConstructorUsedError;
  String? get ownerUserId => throw _privateConstructorUsedError;
  String? get ownerGroupId => throw _privateConstructorUsedError;

  /// Serializes this EntryAccess to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntryAccess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryAccessCopyWith<EntryAccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryAccessCopyWith<$Res> {
  factory $EntryAccessCopyWith(
    EntryAccess value,
    $Res Function(EntryAccess) then,
  ) = _$EntryAccessCopyWithImpl<$Res, EntryAccess>;
  @useResult
  $Res call({
    bool readable,
    bool writable,
    bool executable,
    String? ownerUserId,
    String? ownerGroupId,
  });
}

/// @nodoc
class _$EntryAccessCopyWithImpl<$Res, $Val extends EntryAccess>
    implements $EntryAccessCopyWith<$Res> {
  _$EntryAccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntryAccess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readable = null,
    Object? writable = null,
    Object? executable = null,
    Object? ownerUserId = freezed,
    Object? ownerGroupId = freezed,
  }) {
    return _then(
      _value.copyWith(
            readable: null == readable
                ? _value.readable
                : readable // ignore: cast_nullable_to_non_nullable
                      as bool,
            writable: null == writable
                ? _value.writable
                : writable // ignore: cast_nullable_to_non_nullable
                      as bool,
            executable: null == executable
                ? _value.executable
                : executable // ignore: cast_nullable_to_non_nullable
                      as bool,
            ownerUserId: freezed == ownerUserId
                ? _value.ownerUserId
                : ownerUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerGroupId: freezed == ownerGroupId
                ? _value.ownerGroupId
                : ownerGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EntryAccessImplCopyWith<$Res>
    implements $EntryAccessCopyWith<$Res> {
  factory _$$EntryAccessImplCopyWith(
    _$EntryAccessImpl value,
    $Res Function(_$EntryAccessImpl) then,
  ) = __$$EntryAccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool readable,
    bool writable,
    bool executable,
    String? ownerUserId,
    String? ownerGroupId,
  });
}

/// @nodoc
class __$$EntryAccessImplCopyWithImpl<$Res>
    extends _$EntryAccessCopyWithImpl<$Res, _$EntryAccessImpl>
    implements _$$EntryAccessImplCopyWith<$Res> {
  __$$EntryAccessImplCopyWithImpl(
    _$EntryAccessImpl _value,
    $Res Function(_$EntryAccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EntryAccess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readable = null,
    Object? writable = null,
    Object? executable = null,
    Object? ownerUserId = freezed,
    Object? ownerGroupId = freezed,
  }) {
    return _then(
      _$EntryAccessImpl(
        readable: null == readable
            ? _value.readable
            : readable // ignore: cast_nullable_to_non_nullable
                  as bool,
        writable: null == writable
            ? _value.writable
            : writable // ignore: cast_nullable_to_non_nullable
                  as bool,
        executable: null == executable
            ? _value.executable
            : executable // ignore: cast_nullable_to_non_nullable
                  as bool,
        ownerUserId: freezed == ownerUserId
            ? _value.ownerUserId
            : ownerUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerGroupId: freezed == ownerGroupId
            ? _value.ownerGroupId
            : ownerGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EntryAccessImpl implements _EntryAccess {
  const _$EntryAccessImpl({
    this.readable = false,
    this.writable = false,
    this.executable = false,
    this.ownerUserId,
    this.ownerGroupId,
  });

  factory _$EntryAccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryAccessImplFromJson(json);

  @override
  @JsonKey()
  final bool readable;
  @override
  @JsonKey()
  final bool writable;
  @override
  @JsonKey()
  final bool executable;
  @override
  final String? ownerUserId;
  @override
  final String? ownerGroupId;

  @override
  String toString() {
    return 'EntryAccess(readable: $readable, writable: $writable, executable: $executable, ownerUserId: $ownerUserId, ownerGroupId: $ownerGroupId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryAccessImpl &&
            (identical(other.readable, readable) ||
                other.readable == readable) &&
            (identical(other.writable, writable) ||
                other.writable == writable) &&
            (identical(other.executable, executable) ||
                other.executable == executable) &&
            (identical(other.ownerUserId, ownerUserId) ||
                other.ownerUserId == ownerUserId) &&
            (identical(other.ownerGroupId, ownerGroupId) ||
                other.ownerGroupId == ownerGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    readable,
    writable,
    executable,
    ownerUserId,
    ownerGroupId,
  );

  /// Create a copy of EntryAccess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryAccessImplCopyWith<_$EntryAccessImpl> get copyWith =>
      __$$EntryAccessImplCopyWithImpl<_$EntryAccessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryAccessImplToJson(this);
  }
}

abstract class _EntryAccess implements EntryAccess {
  const factory _EntryAccess({
    final bool readable,
    final bool writable,
    final bool executable,
    final String? ownerUserId,
    final String? ownerGroupId,
  }) = _$EntryAccessImpl;

  factory _EntryAccess.fromJson(Map<String, dynamic> json) =
      _$EntryAccessImpl.fromJson;

  @override
  bool get readable;
  @override
  bool get writable;
  @override
  bool get executable;
  @override
  String? get ownerUserId;
  @override
  String? get ownerGroupId;

  /// Create a copy of EntryAccess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryAccessImplCopyWith<_$EntryAccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EntryTimestamps _$EntryTimestampsFromJson(Map<String, dynamic> json) {
  return _EntryTimestamps.fromJson(json);
}

/// @nodoc
mixin _$EntryTimestamps {
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get accessedAt => throw _privateConstructorUsedError;

  /// Serializes this EntryTimestamps to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntryTimestamps
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryTimestampsCopyWith<EntryTimestamps> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryTimestampsCopyWith<$Res> {
  factory $EntryTimestampsCopyWith(
    EntryTimestamps value,
    $Res Function(EntryTimestamps) then,
  ) = _$EntryTimestampsCopyWithImpl<$Res, EntryTimestamps>;
  @useResult
  $Res call({DateTime? createdAt, DateTime? updatedAt, DateTime? accessedAt});
}

/// @nodoc
class _$EntryTimestampsCopyWithImpl<$Res, $Val extends EntryTimestamps>
    implements $EntryTimestampsCopyWith<$Res> {
  _$EntryTimestampsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntryTimestamps
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? accessedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            accessedAt: freezed == accessedAt
                ? _value.accessedAt
                : accessedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EntryTimestampsImplCopyWith<$Res>
    implements $EntryTimestampsCopyWith<$Res> {
  factory _$$EntryTimestampsImplCopyWith(
    _$EntryTimestampsImpl value,
    $Res Function(_$EntryTimestampsImpl) then,
  ) = __$$EntryTimestampsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? createdAt, DateTime? updatedAt, DateTime? accessedAt});
}

/// @nodoc
class __$$EntryTimestampsImplCopyWithImpl<$Res>
    extends _$EntryTimestampsCopyWithImpl<$Res, _$EntryTimestampsImpl>
    implements _$$EntryTimestampsImplCopyWith<$Res> {
  __$$EntryTimestampsImplCopyWithImpl(
    _$EntryTimestampsImpl _value,
    $Res Function(_$EntryTimestampsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EntryTimestamps
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? accessedAt = freezed,
  }) {
    return _then(
      _$EntryTimestampsImpl(
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        accessedAt: freezed == accessedAt
            ? _value.accessedAt
            : accessedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EntryTimestampsImpl implements _EntryTimestamps {
  const _$EntryTimestampsImpl({
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
  });

  factory _$EntryTimestampsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryTimestampsImplFromJson(json);

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? accessedAt;

  @override
  String toString() {
    return 'EntryTimestamps(createdAt: $createdAt, updatedAt: $updatedAt, accessedAt: $accessedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryTimestampsImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.accessedAt, accessedAt) ||
                other.accessedAt == accessedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, createdAt, updatedAt, accessedAt);

  /// Create a copy of EntryTimestamps
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryTimestampsImplCopyWith<_$EntryTimestampsImpl> get copyWith =>
      __$$EntryTimestampsImplCopyWithImpl<_$EntryTimestampsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryTimestampsImplToJson(this);
  }
}

abstract class _EntryTimestamps implements EntryTimestamps {
  const factory _EntryTimestamps({
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? accessedAt,
  }) = _$EntryTimestampsImpl;

  factory _EntryTimestamps.fromJson(Map<String, dynamic> json) =
      _$EntryTimestampsImpl.fromJson;

  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get accessedAt;

  /// Create a copy of EntryTimestamps
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryTimestampsImplCopyWith<_$EntryTimestampsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EntryMeta _$EntryMetaFromJson(Map<String, dynamic> json) {
  return _EntryMeta.fromJson(json);
}

/// @nodoc
mixin _$EntryMeta {
  /// Display name (may differ from actual filesystem name).
  String? get displayName => throw _privateConstructorUsedError;

  /// Freeform tags (e.g., "favorite", "important", AI labels).
  List<String> get tags => throw _privateConstructorUsedError;

  /// Arbitrary KV store for future extensions (safe forward compatibility).
  Map<String, dynamic> get custom => throw _privateConstructorUsedError;

  /// Serializes this EntryMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntryMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryMetaCopyWith<EntryMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryMetaCopyWith<$Res> {
  factory $EntryMetaCopyWith(EntryMeta value, $Res Function(EntryMeta) then) =
      _$EntryMetaCopyWithImpl<$Res, EntryMeta>;
  @useResult
  $Res call({
    String? displayName,
    List<String> tags,
    Map<String, dynamic> custom,
  });
}

/// @nodoc
class _$EntryMetaCopyWithImpl<$Res, $Val extends EntryMeta>
    implements $EntryMetaCopyWith<$Res> {
  _$EntryMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntryMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? tags = null,
    Object? custom = null,
  }) {
    return _then(
      _value.copyWith(
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            custom: null == custom
                ? _value.custom
                : custom // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EntryMetaImplCopyWith<$Res>
    implements $EntryMetaCopyWith<$Res> {
  factory _$$EntryMetaImplCopyWith(
    _$EntryMetaImpl value,
    $Res Function(_$EntryMetaImpl) then,
  ) = __$$EntryMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? displayName,
    List<String> tags,
    Map<String, dynamic> custom,
  });
}

/// @nodoc
class __$$EntryMetaImplCopyWithImpl<$Res>
    extends _$EntryMetaCopyWithImpl<$Res, _$EntryMetaImpl>
    implements _$$EntryMetaImplCopyWith<$Res> {
  __$$EntryMetaImplCopyWithImpl(
    _$EntryMetaImpl _value,
    $Res Function(_$EntryMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EntryMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? tags = null,
    Object? custom = null,
  }) {
    return _then(
      _$EntryMetaImpl(
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        custom: null == custom
            ? _value._custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EntryMetaImpl implements _EntryMeta {
  const _$EntryMetaImpl({
    this.displayName,
    final List<String> tags = const <String>[],
    final Map<String, dynamic> custom = const <String, dynamic>{},
  }) : _tags = tags,
       _custom = custom;

  factory _$EntryMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryMetaImplFromJson(json);

  /// Display name (may differ from actual filesystem name).
  @override
  final String? displayName;

  /// Freeform tags (e.g., "favorite", "important", AI labels).
  final List<String> _tags;

  /// Freeform tags (e.g., "favorite", "important", AI labels).
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Arbitrary KV store for future extensions (safe forward compatibility).
  final Map<String, dynamic> _custom;

  /// Arbitrary KV store for future extensions (safe forward compatibility).
  @override
  @JsonKey()
  Map<String, dynamic> get custom {
    if (_custom is EqualUnmodifiableMapView) return _custom;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_custom);
  }

  @override
  String toString() {
    return 'EntryMeta(displayName: $displayName, tags: $tags, custom: $custom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryMetaImpl &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._custom, _custom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    displayName,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_custom),
  );

  /// Create a copy of EntryMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryMetaImplCopyWith<_$EntryMetaImpl> get copyWith =>
      __$$EntryMetaImplCopyWithImpl<_$EntryMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryMetaImplToJson(this);
  }
}

abstract class _EntryMeta implements EntryMeta {
  const factory _EntryMeta({
    final String? displayName,
    final List<String> tags,
    final Map<String, dynamic> custom,
  }) = _$EntryMetaImpl;

  factory _EntryMeta.fromJson(Map<String, dynamic> json) =
      _$EntryMetaImpl.fromJson;

  /// Display name (may differ from actual filesystem name).
  @override
  String? get displayName;

  /// Freeform tags (e.g., "favorite", "important", AI labels).
  @override
  List<String> get tags;

  /// Arbitrary KV store for future extensions (safe forward compatibility).
  @override
  Map<String, dynamic> get custom;

  /// Create a copy of EntryMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryMetaImplCopyWith<_$EntryMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FsEntryBase _$FsEntryBaseFromJson(Map<String, dynamic> json) {
  return _FsEntryBase.fromJson(json);
}

/// @nodoc
mixin _$FsEntryBase {
  /// Stable, global unique ID (never changes).
  String get id => throw _privateConstructorUsedError;

  /// The path in the virtual filesystem, e.g. `/home/user/file.txt`.
  String get path => throw _privateConstructorUsedError;

  /// Pure name without path, e.g. `file.txt`.
  String get name => throw _privateConstructorUsedError;

  /// Human-readable kind, e.g. "image", "audio", "folder".
  FileKind get kind => throw _privateConstructorUsedError;

  /// File extension WITHOUT the dot (`txt`, `png`, etc.). For folders, `null`.
  String? get extension => throw _privateConstructorUsedError;

  /// Approximate size in bytes (for folders can be sum or null).
  int? get sizeBytes => throw _privateConstructorUsedError;

  /// Status (normal, deleted, locked, etc.).
  EntryStatus get status => throw _privateConstructorUsedError;

  /// Access rights & ownership.
  EntryAccess? get access => throw _privateConstructorUsedError;

  /// Timestamps.
  EntryTimestamps? get timestamps => throw _privateConstructorUsedError;

  /// Generic metadata.
  EntryMeta? get meta => throw _privateConstructorUsedError;

  /// Serializes this FsEntryBase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FsEntryBaseCopyWith<FsEntryBase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FsEntryBaseCopyWith<$Res> {
  factory $FsEntryBaseCopyWith(
    FsEntryBase value,
    $Res Function(FsEntryBase) then,
  ) = _$FsEntryBaseCopyWithImpl<$Res, FsEntryBase>;
  @useResult
  $Res call({
    String id,
    String path,
    String name,
    FileKind kind,
    String? extension,
    int? sizeBytes,
    EntryStatus status,
    EntryAccess? access,
    EntryTimestamps? timestamps,
    EntryMeta? meta,
  });

  $EntryAccessCopyWith<$Res>? get access;
  $EntryTimestampsCopyWith<$Res>? get timestamps;
  $EntryMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class _$FsEntryBaseCopyWithImpl<$Res, $Val extends FsEntryBase>
    implements $FsEntryBaseCopyWith<$Res> {
  _$FsEntryBaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? kind = null,
    Object? extension = freezed,
    Object? sizeBytes = freezed,
    Object? status = null,
    Object? access = freezed,
    Object? timestamps = freezed,
    Object? meta = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as FileKind,
            extension: freezed == extension
                ? _value.extension
                : extension // ignore: cast_nullable_to_non_nullable
                      as String?,
            sizeBytes: freezed == sizeBytes
                ? _value.sizeBytes
                : sizeBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EntryStatus,
            access: freezed == access
                ? _value.access
                : access // ignore: cast_nullable_to_non_nullable
                      as EntryAccess?,
            timestamps: freezed == timestamps
                ? _value.timestamps
                : timestamps // ignore: cast_nullable_to_non_nullable
                      as EntryTimestamps?,
            meta: freezed == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as EntryMeta?,
          )
          as $Val,
    );
  }

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EntryAccessCopyWith<$Res>? get access {
    if (_value.access == null) {
      return null;
    }

    return $EntryAccessCopyWith<$Res>(_value.access!, (value) {
      return _then(_value.copyWith(access: value) as $Val);
    });
  }

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EntryTimestampsCopyWith<$Res>? get timestamps {
    if (_value.timestamps == null) {
      return null;
    }

    return $EntryTimestampsCopyWith<$Res>(_value.timestamps!, (value) {
      return _then(_value.copyWith(timestamps: value) as $Val);
    });
  }

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EntryMetaCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $EntryMetaCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FsEntryBaseImplCopyWith<$Res>
    implements $FsEntryBaseCopyWith<$Res> {
  factory _$$FsEntryBaseImplCopyWith(
    _$FsEntryBaseImpl value,
    $Res Function(_$FsEntryBaseImpl) then,
  ) = __$$FsEntryBaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String path,
    String name,
    FileKind kind,
    String? extension,
    int? sizeBytes,
    EntryStatus status,
    EntryAccess? access,
    EntryTimestamps? timestamps,
    EntryMeta? meta,
  });

  @override
  $EntryAccessCopyWith<$Res>? get access;
  @override
  $EntryTimestampsCopyWith<$Res>? get timestamps;
  @override
  $EntryMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$FsEntryBaseImplCopyWithImpl<$Res>
    extends _$FsEntryBaseCopyWithImpl<$Res, _$FsEntryBaseImpl>
    implements _$$FsEntryBaseImplCopyWith<$Res> {
  __$$FsEntryBaseImplCopyWithImpl(
    _$FsEntryBaseImpl _value,
    $Res Function(_$FsEntryBaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? kind = null,
    Object? extension = freezed,
    Object? sizeBytes = freezed,
    Object? status = null,
    Object? access = freezed,
    Object? timestamps = freezed,
    Object? meta = freezed,
  }) {
    return _then(
      _$FsEntryBaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as FileKind,
        extension: freezed == extension
            ? _value.extension
            : extension // ignore: cast_nullable_to_non_nullable
                  as String?,
        sizeBytes: freezed == sizeBytes
            ? _value.sizeBytes
            : sizeBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EntryStatus,
        access: freezed == access
            ? _value.access
            : access // ignore: cast_nullable_to_non_nullable
                  as EntryAccess?,
        timestamps: freezed == timestamps
            ? _value.timestamps
            : timestamps // ignore: cast_nullable_to_non_nullable
                  as EntryTimestamps?,
        meta: freezed == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as EntryMeta?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FsEntryBaseImpl implements _FsEntryBase {
  const _$FsEntryBaseImpl({
    required this.id,
    required this.path,
    required this.name,
    required this.kind,
    this.extension,
    this.sizeBytes,
    this.status = EntryStatus.normal,
    this.access,
    this.timestamps,
    this.meta,
  });

  factory _$FsEntryBaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FsEntryBaseImplFromJson(json);

  /// Stable, global unique ID (never changes).
  @override
  final String id;

  /// The path in the virtual filesystem, e.g. `/home/user/file.txt`.
  @override
  final String path;

  /// Pure name without path, e.g. `file.txt`.
  @override
  final String name;

  /// Human-readable kind, e.g. "image", "audio", "folder".
  @override
  final FileKind kind;

  /// File extension WITHOUT the dot (`txt`, `png`, etc.). For folders, `null`.
  @override
  final String? extension;

  /// Approximate size in bytes (for folders can be sum or null).
  @override
  final int? sizeBytes;

  /// Status (normal, deleted, locked, etc.).
  @override
  @JsonKey()
  final EntryStatus status;

  /// Access rights & ownership.
  @override
  final EntryAccess? access;

  /// Timestamps.
  @override
  final EntryTimestamps? timestamps;

  /// Generic metadata.
  @override
  final EntryMeta? meta;

  @override
  String toString() {
    return 'FsEntryBase(id: $id, path: $path, name: $name, kind: $kind, extension: $extension, sizeBytes: $sizeBytes, status: $status, access: $access, timestamps: $timestamps, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FsEntryBaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.extension, extension) ||
                other.extension == extension) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.timestamps, timestamps) ||
                other.timestamps == timestamps) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    path,
    name,
    kind,
    extension,
    sizeBytes,
    status,
    access,
    timestamps,
    meta,
  );

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FsEntryBaseImplCopyWith<_$FsEntryBaseImpl> get copyWith =>
      __$$FsEntryBaseImplCopyWithImpl<_$FsEntryBaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FsEntryBaseImplToJson(this);
  }
}

abstract class _FsEntryBase implements FsEntryBase {
  const factory _FsEntryBase({
    required final String id,
    required final String path,
    required final String name,
    required final FileKind kind,
    final String? extension,
    final int? sizeBytes,
    final EntryStatus status,
    final EntryAccess? access,
    final EntryTimestamps? timestamps,
    final EntryMeta? meta,
  }) = _$FsEntryBaseImpl;

  factory _FsEntryBase.fromJson(Map<String, dynamic> json) =
      _$FsEntryBaseImpl.fromJson;

  /// Stable, global unique ID (never changes).
  @override
  String get id;

  /// The path in the virtual filesystem, e.g. `/home/user/file.txt`.
  @override
  String get path;

  /// Pure name without path, e.g. `file.txt`.
  @override
  String get name;

  /// Human-readable kind, e.g. "image", "audio", "folder".
  @override
  FileKind get kind;

  /// File extension WITHOUT the dot (`txt`, `png`, etc.). For folders, `null`.
  @override
  String? get extension;

  /// Approximate size in bytes (for folders can be sum or null).
  @override
  int? get sizeBytes;

  /// Status (normal, deleted, locked, etc.).
  @override
  EntryStatus get status;

  /// Access rights & ownership.
  @override
  EntryAccess? get access;

  /// Timestamps.
  @override
  EntryTimestamps? get timestamps;

  /// Generic metadata.
  @override
  EntryMeta? get meta;

  /// Create a copy of FsEntryBase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FsEntryBaseImplCopyWith<_$FsEntryBaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
