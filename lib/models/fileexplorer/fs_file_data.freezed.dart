// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fs_file_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StorageLocation _$StorageLocationFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'local':
      return LocalStorageLocation.fromJson(json);
    case 'remote':
      return RemoteStorageLocation.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'StorageLocation',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$StorageLocation {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String localPath) local,
    required TResult Function(String uri, String? backend) remote,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String localPath)? local,
    TResult? Function(String uri, String? backend)? remote,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String localPath)? local,
    TResult Function(String uri, String? backend)? remote,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalStorageLocation value) local,
    required TResult Function(RemoteStorageLocation value) remote,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalStorageLocation value)? local,
    TResult? Function(RemoteStorageLocation value)? remote,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalStorageLocation value)? local,
    TResult Function(RemoteStorageLocation value)? remote,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this StorageLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorageLocationCopyWith<$Res> {
  factory $StorageLocationCopyWith(
    StorageLocation value,
    $Res Function(StorageLocation) then,
  ) = _$StorageLocationCopyWithImpl<$Res, StorageLocation>;
}

/// @nodoc
class _$StorageLocationCopyWithImpl<$Res, $Val extends StorageLocation>
    implements $StorageLocationCopyWith<$Res> {
  _$StorageLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LocalStorageLocationImplCopyWith<$Res> {
  factory _$$LocalStorageLocationImplCopyWith(
    _$LocalStorageLocationImpl value,
    $Res Function(_$LocalStorageLocationImpl) then,
  ) = __$$LocalStorageLocationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String localPath});
}

/// @nodoc
class __$$LocalStorageLocationImplCopyWithImpl<$Res>
    extends _$StorageLocationCopyWithImpl<$Res, _$LocalStorageLocationImpl>
    implements _$$LocalStorageLocationImplCopyWith<$Res> {
  __$$LocalStorageLocationImplCopyWithImpl(
    _$LocalStorageLocationImpl _value,
    $Res Function(_$LocalStorageLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? localPath = null}) {
    return _then(
      _$LocalStorageLocationImpl(
        localPath: null == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalStorageLocationImpl implements LocalStorageLocation {
  const _$LocalStorageLocationImpl({
    required this.localPath,
    final String? $type,
  }) : $type = $type ?? 'local';

  factory _$LocalStorageLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalStorageLocationImplFromJson(json);

  /// Absolute local path.
  @override
  final String localPath;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StorageLocation.local(localPath: $localPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalStorageLocationImpl &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, localPath);

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalStorageLocationImplCopyWith<_$LocalStorageLocationImpl>
  get copyWith =>
      __$$LocalStorageLocationImplCopyWithImpl<_$LocalStorageLocationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String localPath) local,
    required TResult Function(String uri, String? backend) remote,
  }) {
    return local(localPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String localPath)? local,
    TResult? Function(String uri, String? backend)? remote,
  }) {
    return local?.call(localPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String localPath)? local,
    TResult Function(String uri, String? backend)? remote,
    required TResult orElse(),
  }) {
    if (local != null) {
      return local(localPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalStorageLocation value) local,
    required TResult Function(RemoteStorageLocation value) remote,
  }) {
    return local(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalStorageLocation value)? local,
    TResult? Function(RemoteStorageLocation value)? remote,
  }) {
    return local?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalStorageLocation value)? local,
    TResult Function(RemoteStorageLocation value)? remote,
    required TResult orElse(),
  }) {
    if (local != null) {
      return local(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalStorageLocationImplToJson(this);
  }
}

abstract class LocalStorageLocation implements StorageLocation {
  const factory LocalStorageLocation({required final String localPath}) =
      _$LocalStorageLocationImpl;

  factory LocalStorageLocation.fromJson(Map<String, dynamic> json) =
      _$LocalStorageLocationImpl.fromJson;

  /// Absolute local path.
  String get localPath;

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalStorageLocationImplCopyWith<_$LocalStorageLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RemoteStorageLocationImplCopyWith<$Res> {
  factory _$$RemoteStorageLocationImplCopyWith(
    _$RemoteStorageLocationImpl value,
    $Res Function(_$RemoteStorageLocationImpl) then,
  ) = __$$RemoteStorageLocationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String uri, String? backend});
}

/// @nodoc
class __$$RemoteStorageLocationImplCopyWithImpl<$Res>
    extends _$StorageLocationCopyWithImpl<$Res, _$RemoteStorageLocationImpl>
    implements _$$RemoteStorageLocationImplCopyWith<$Res> {
  __$$RemoteStorageLocationImplCopyWithImpl(
    _$RemoteStorageLocationImpl _value,
    $Res Function(_$RemoteStorageLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? uri = null, Object? backend = freezed}) {
    return _then(
      _$RemoteStorageLocationImpl(
        uri: null == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String,
        backend: freezed == backend
            ? _value.backend
            : backend // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteStorageLocationImpl implements RemoteStorageLocation {
  const _$RemoteStorageLocationImpl({
    required this.uri,
    this.backend,
    final String? $type,
  }) : $type = $type ?? 'remote';

  factory _$RemoteStorageLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteStorageLocationImplFromJson(json);

  /// URL or remote key.
  @override
  final String uri;

  /// Optional storage backend type (ftp, http, s3, etc.)
  @override
  final String? backend;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StorageLocation.remote(uri: $uri, backend: $backend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteStorageLocationImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.backend, backend) || other.backend == backend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uri, backend);

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteStorageLocationImplCopyWith<_$RemoteStorageLocationImpl>
  get copyWith =>
      __$$RemoteStorageLocationImplCopyWithImpl<_$RemoteStorageLocationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String localPath) local,
    required TResult Function(String uri, String? backend) remote,
  }) {
    return remote(uri, backend);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String localPath)? local,
    TResult? Function(String uri, String? backend)? remote,
  }) {
    return remote?.call(uri, backend);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String localPath)? local,
    TResult Function(String uri, String? backend)? remote,
    required TResult orElse(),
  }) {
    if (remote != null) {
      return remote(uri, backend);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalStorageLocation value) local,
    required TResult Function(RemoteStorageLocation value) remote,
  }) {
    return remote(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalStorageLocation value)? local,
    TResult? Function(RemoteStorageLocation value)? remote,
  }) {
    return remote?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalStorageLocation value)? local,
    TResult Function(RemoteStorageLocation value)? remote,
    required TResult orElse(),
  }) {
    if (remote != null) {
      return remote(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteStorageLocationImplToJson(this);
  }
}

abstract class RemoteStorageLocation implements StorageLocation {
  const factory RemoteStorageLocation({
    required final String uri,
    final String? backend,
  }) = _$RemoteStorageLocationImpl;

  factory RemoteStorageLocation.fromJson(Map<String, dynamic> json) =
      _$RemoteStorageLocationImpl.fromJson;

  /// URL or remote key.
  String get uri;

  /// Optional storage backend type (ftp, http, s3, etc.)
  String? get backend;

  /// Create a copy of StorageLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteStorageLocationImplCopyWith<_$RemoteStorageLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FileConversionCapability _$FileConversionCapabilityFromJson(
  Map<String, dynamic> json,
) {
  return _FileConversionCapability.fromJson(json);
}

/// @nodoc
mixin _$FileConversionCapability {
  /// Target kind (e.g., image -> archive, text -> markdown).
  FileKind get targetKind => throw _privateConstructorUsedError;

  /// Target extension(s), e.g., ["jpg", "webp"].
  List<String> get targetExtensions => throw _privateConstructorUsedError;

  /// Optional description for UI.
  String? get description => throw _privateConstructorUsedError;

  /// Additional fixed parameters for a default conversion.
  Map<String, dynamic> get defaultParams => throw _privateConstructorUsedError;

  /// Serializes this FileConversionCapability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileConversionCapability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileConversionCapabilityCopyWith<FileConversionCapability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileConversionCapabilityCopyWith<$Res> {
  factory $FileConversionCapabilityCopyWith(
    FileConversionCapability value,
    $Res Function(FileConversionCapability) then,
  ) = _$FileConversionCapabilityCopyWithImpl<$Res, FileConversionCapability>;
  @useResult
  $Res call({
    FileKind targetKind,
    List<String> targetExtensions,
    String? description,
    Map<String, dynamic> defaultParams,
  });
}

/// @nodoc
class _$FileConversionCapabilityCopyWithImpl<
  $Res,
  $Val extends FileConversionCapability
>
    implements $FileConversionCapabilityCopyWith<$Res> {
  _$FileConversionCapabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileConversionCapability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetKind = null,
    Object? targetExtensions = null,
    Object? description = freezed,
    Object? defaultParams = null,
  }) {
    return _then(
      _value.copyWith(
            targetKind: null == targetKind
                ? _value.targetKind
                : targetKind // ignore: cast_nullable_to_non_nullable
                      as FileKind,
            targetExtensions: null == targetExtensions
                ? _value.targetExtensions
                : targetExtensions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultParams: null == defaultParams
                ? _value.defaultParams
                : defaultParams // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FileConversionCapabilityImplCopyWith<$Res>
    implements $FileConversionCapabilityCopyWith<$Res> {
  factory _$$FileConversionCapabilityImplCopyWith(
    _$FileConversionCapabilityImpl value,
    $Res Function(_$FileConversionCapabilityImpl) then,
  ) = __$$FileConversionCapabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    FileKind targetKind,
    List<String> targetExtensions,
    String? description,
    Map<String, dynamic> defaultParams,
  });
}

/// @nodoc
class __$$FileConversionCapabilityImplCopyWithImpl<$Res>
    extends
        _$FileConversionCapabilityCopyWithImpl<
          $Res,
          _$FileConversionCapabilityImpl
        >
    implements _$$FileConversionCapabilityImplCopyWith<$Res> {
  __$$FileConversionCapabilityImplCopyWithImpl(
    _$FileConversionCapabilityImpl _value,
    $Res Function(_$FileConversionCapabilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileConversionCapability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetKind = null,
    Object? targetExtensions = null,
    Object? description = freezed,
    Object? defaultParams = null,
  }) {
    return _then(
      _$FileConversionCapabilityImpl(
        targetKind: null == targetKind
            ? _value.targetKind
            : targetKind // ignore: cast_nullable_to_non_nullable
                  as FileKind,
        targetExtensions: null == targetExtensions
            ? _value._targetExtensions
            : targetExtensions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultParams: null == defaultParams
            ? _value._defaultParams
            : defaultParams // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FileConversionCapabilityImpl implements _FileConversionCapability {
  const _$FileConversionCapabilityImpl({
    required this.targetKind,
    final List<String> targetExtensions = const <String>[],
    this.description,
    final Map<String, dynamic> defaultParams = const <String, dynamic>{},
  }) : _targetExtensions = targetExtensions,
       _defaultParams = defaultParams;

  factory _$FileConversionCapabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileConversionCapabilityImplFromJson(json);

  /// Target kind (e.g., image -> archive, text -> markdown).
  @override
  final FileKind targetKind;

  /// Target extension(s), e.g., ["jpg", "webp"].
  final List<String> _targetExtensions;

  /// Target extension(s), e.g., ["jpg", "webp"].
  @override
  @JsonKey()
  List<String> get targetExtensions {
    if (_targetExtensions is EqualUnmodifiableListView)
      return _targetExtensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetExtensions);
  }

  /// Optional description for UI.
  @override
  final String? description;

  /// Additional fixed parameters for a default conversion.
  final Map<String, dynamic> _defaultParams;

  /// Additional fixed parameters for a default conversion.
  @override
  @JsonKey()
  Map<String, dynamic> get defaultParams {
    if (_defaultParams is EqualUnmodifiableMapView) return _defaultParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_defaultParams);
  }

  @override
  String toString() {
    return 'FileConversionCapability(targetKind: $targetKind, targetExtensions: $targetExtensions, description: $description, defaultParams: $defaultParams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileConversionCapabilityImpl &&
            (identical(other.targetKind, targetKind) ||
                other.targetKind == targetKind) &&
            const DeepCollectionEquality().equals(
              other._targetExtensions,
              _targetExtensions,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._defaultParams,
              _defaultParams,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    targetKind,
    const DeepCollectionEquality().hash(_targetExtensions),
    description,
    const DeepCollectionEquality().hash(_defaultParams),
  );

  /// Create a copy of FileConversionCapability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileConversionCapabilityImplCopyWith<_$FileConversionCapabilityImpl>
  get copyWith =>
      __$$FileConversionCapabilityImplCopyWithImpl<
        _$FileConversionCapabilityImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileConversionCapabilityImplToJson(this);
  }
}

abstract class _FileConversionCapability implements FileConversionCapability {
  const factory _FileConversionCapability({
    required final FileKind targetKind,
    final List<String> targetExtensions,
    final String? description,
    final Map<String, dynamic> defaultParams,
  }) = _$FileConversionCapabilityImpl;

  factory _FileConversionCapability.fromJson(Map<String, dynamic> json) =
      _$FileConversionCapabilityImpl.fromJson;

  /// Target kind (e.g., image -> archive, text -> markdown).
  @override
  FileKind get targetKind;

  /// Target extension(s), e.g., ["jpg", "webp"].
  @override
  List<String> get targetExtensions;

  /// Optional description for UI.
  @override
  String? get description;

  /// Additional fixed parameters for a default conversion.
  @override
  Map<String, dynamic> get defaultParams;

  /// Create a copy of FileConversionCapability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileConversionCapabilityImplCopyWith<_$FileConversionCapabilityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ImageMeta _$ImageMetaFromJson(Map<String, dynamic> json) {
  return _ImageMeta.fromJson(json);
}

/// @nodoc
mixin _$ImageMeta {
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  String? get colorSpace => throw _privateConstructorUsedError;
  int? get dpi => throw _privateConstructorUsedError;

  /// Serializes this ImageMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageMetaCopyWith<ImageMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageMetaCopyWith<$Res> {
  factory $ImageMetaCopyWith(ImageMeta value, $Res Function(ImageMeta) then) =
      _$ImageMetaCopyWithImpl<$Res, ImageMeta>;
  @useResult
  $Res call({int? width, int? height, String? colorSpace, int? dpi});
}

/// @nodoc
class _$ImageMetaCopyWithImpl<$Res, $Val extends ImageMeta>
    implements $ImageMetaCopyWith<$Res> {
  _$ImageMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = freezed,
    Object? height = freezed,
    Object? colorSpace = freezed,
    Object? dpi = freezed,
  }) {
    return _then(
      _value.copyWith(
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            colorSpace: freezed == colorSpace
                ? _value.colorSpace
                : colorSpace // ignore: cast_nullable_to_non_nullable
                      as String?,
            dpi: freezed == dpi
                ? _value.dpi
                : dpi // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImageMetaImplCopyWith<$Res>
    implements $ImageMetaCopyWith<$Res> {
  factory _$$ImageMetaImplCopyWith(
    _$ImageMetaImpl value,
    $Res Function(_$ImageMetaImpl) then,
  ) = __$$ImageMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? width, int? height, String? colorSpace, int? dpi});
}

/// @nodoc
class __$$ImageMetaImplCopyWithImpl<$Res>
    extends _$ImageMetaCopyWithImpl<$Res, _$ImageMetaImpl>
    implements _$$ImageMetaImplCopyWith<$Res> {
  __$$ImageMetaImplCopyWithImpl(
    _$ImageMetaImpl _value,
    $Res Function(_$ImageMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = freezed,
    Object? height = freezed,
    Object? colorSpace = freezed,
    Object? dpi = freezed,
  }) {
    return _then(
      _$ImageMetaImpl(
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        colorSpace: freezed == colorSpace
            ? _value.colorSpace
            : colorSpace // ignore: cast_nullable_to_non_nullable
                  as String?,
        dpi: freezed == dpi
            ? _value.dpi
            : dpi // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageMetaImpl implements _ImageMeta {
  const _$ImageMetaImpl({this.width, this.height, this.colorSpace, this.dpi});

  factory _$ImageMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageMetaImplFromJson(json);

  @override
  final int? width;
  @override
  final int? height;
  @override
  final String? colorSpace;
  @override
  final int? dpi;

  @override
  String toString() {
    return 'ImageMeta(width: $width, height: $height, colorSpace: $colorSpace, dpi: $dpi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMetaImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.colorSpace, colorSpace) ||
                other.colorSpace == colorSpace) &&
            (identical(other.dpi, dpi) || other.dpi == dpi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, width, height, colorSpace, dpi);

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMetaImplCopyWith<_$ImageMetaImpl> get copyWith =>
      __$$ImageMetaImplCopyWithImpl<_$ImageMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageMetaImplToJson(this);
  }
}

abstract class _ImageMeta implements ImageMeta {
  const factory _ImageMeta({
    final int? width,
    final int? height,
    final String? colorSpace,
    final int? dpi,
  }) = _$ImageMetaImpl;

  factory _ImageMeta.fromJson(Map<String, dynamic> json) =
      _$ImageMetaImpl.fromJson;

  @override
  int? get width;
  @override
  int? get height;
  @override
  String? get colorSpace;
  @override
  int? get dpi;

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageMetaImplCopyWith<_$ImageMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AudioMeta _$AudioMetaFromJson(Map<String, dynamic> json) {
  return _AudioMeta.fromJson(json);
}

/// @nodoc
mixin _$AudioMeta {
  double? get durationSeconds => throw _privateConstructorUsedError;
  int? get bitrateKbps => throw _privateConstructorUsedError;
  int? get sampleRateHz => throw _privateConstructorUsedError;
  int? get channels => throw _privateConstructorUsedError;

  /// Serializes this AudioMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioMetaCopyWith<AudioMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioMetaCopyWith<$Res> {
  factory $AudioMetaCopyWith(AudioMeta value, $Res Function(AudioMeta) then) =
      _$AudioMetaCopyWithImpl<$Res, AudioMeta>;
  @useResult
  $Res call({
    double? durationSeconds,
    int? bitrateKbps,
    int? sampleRateHz,
    int? channels,
  });
}

/// @nodoc
class _$AudioMetaCopyWithImpl<$Res, $Val extends AudioMeta>
    implements $AudioMetaCopyWith<$Res> {
  _$AudioMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationSeconds = freezed,
    Object? bitrateKbps = freezed,
    Object? sampleRateHz = freezed,
    Object? channels = freezed,
  }) {
    return _then(
      _value.copyWith(
            durationSeconds: freezed == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as double?,
            bitrateKbps: freezed == bitrateKbps
                ? _value.bitrateKbps
                : bitrateKbps // ignore: cast_nullable_to_non_nullable
                      as int?,
            sampleRateHz: freezed == sampleRateHz
                ? _value.sampleRateHz
                : sampleRateHz // ignore: cast_nullable_to_non_nullable
                      as int?,
            channels: freezed == channels
                ? _value.channels
                : channels // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioMetaImplCopyWith<$Res>
    implements $AudioMetaCopyWith<$Res> {
  factory _$$AudioMetaImplCopyWith(
    _$AudioMetaImpl value,
    $Res Function(_$AudioMetaImpl) then,
  ) = __$$AudioMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? durationSeconds,
    int? bitrateKbps,
    int? sampleRateHz,
    int? channels,
  });
}

/// @nodoc
class __$$AudioMetaImplCopyWithImpl<$Res>
    extends _$AudioMetaCopyWithImpl<$Res, _$AudioMetaImpl>
    implements _$$AudioMetaImplCopyWith<$Res> {
  __$$AudioMetaImplCopyWithImpl(
    _$AudioMetaImpl _value,
    $Res Function(_$AudioMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationSeconds = freezed,
    Object? bitrateKbps = freezed,
    Object? sampleRateHz = freezed,
    Object? channels = freezed,
  }) {
    return _then(
      _$AudioMetaImpl(
        durationSeconds: freezed == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as double?,
        bitrateKbps: freezed == bitrateKbps
            ? _value.bitrateKbps
            : bitrateKbps // ignore: cast_nullable_to_non_nullable
                  as int?,
        sampleRateHz: freezed == sampleRateHz
            ? _value.sampleRateHz
            : sampleRateHz // ignore: cast_nullable_to_non_nullable
                  as int?,
        channels: freezed == channels
            ? _value.channels
            : channels // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioMetaImpl implements _AudioMeta {
  const _$AudioMetaImpl({
    this.durationSeconds,
    this.bitrateKbps,
    this.sampleRateHz,
    this.channels,
  });

  factory _$AudioMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioMetaImplFromJson(json);

  @override
  final double? durationSeconds;
  @override
  final int? bitrateKbps;
  @override
  final int? sampleRateHz;
  @override
  final int? channels;

  @override
  String toString() {
    return 'AudioMeta(durationSeconds: $durationSeconds, bitrateKbps: $bitrateKbps, sampleRateHz: $sampleRateHz, channels: $channels)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioMetaImpl &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.bitrateKbps, bitrateKbps) ||
                other.bitrateKbps == bitrateKbps) &&
            (identical(other.sampleRateHz, sampleRateHz) ||
                other.sampleRateHz == sampleRateHz) &&
            (identical(other.channels, channels) ||
                other.channels == channels));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    durationSeconds,
    bitrateKbps,
    sampleRateHz,
    channels,
  );

  /// Create a copy of AudioMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioMetaImplCopyWith<_$AudioMetaImpl> get copyWith =>
      __$$AudioMetaImplCopyWithImpl<_$AudioMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioMetaImplToJson(this);
  }
}

abstract class _AudioMeta implements AudioMeta {
  const factory _AudioMeta({
    final double? durationSeconds,
    final int? bitrateKbps,
    final int? sampleRateHz,
    final int? channels,
  }) = _$AudioMetaImpl;

  factory _AudioMeta.fromJson(Map<String, dynamic> json) =
      _$AudioMetaImpl.fromJson;

  @override
  double? get durationSeconds;
  @override
  int? get bitrateKbps;
  @override
  int? get sampleRateHz;
  @override
  int? get channels;

  /// Create a copy of AudioMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioMetaImplCopyWith<_$AudioMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoMeta _$VideoMetaFromJson(Map<String, dynamic> json) {
  return _VideoMeta.fromJson(json);
}

/// @nodoc
mixin _$VideoMeta {
  double? get durationSeconds => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  double? get fps => throw _privateConstructorUsedError;

  /// Serializes this VideoMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoMetaCopyWith<VideoMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoMetaCopyWith<$Res> {
  factory $VideoMetaCopyWith(VideoMeta value, $Res Function(VideoMeta) then) =
      _$VideoMetaCopyWithImpl<$Res, VideoMeta>;
  @useResult
  $Res call({double? durationSeconds, int? width, int? height, double? fps});
}

/// @nodoc
class _$VideoMetaCopyWithImpl<$Res, $Val extends VideoMeta>
    implements $VideoMetaCopyWith<$Res> {
  _$VideoMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationSeconds = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? fps = freezed,
  }) {
    return _then(
      _value.copyWith(
            durationSeconds: freezed == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as double?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            fps: freezed == fps
                ? _value.fps
                : fps // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VideoMetaImplCopyWith<$Res>
    implements $VideoMetaCopyWith<$Res> {
  factory _$$VideoMetaImplCopyWith(
    _$VideoMetaImpl value,
    $Res Function(_$VideoMetaImpl) then,
  ) = __$$VideoMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? durationSeconds, int? width, int? height, double? fps});
}

/// @nodoc
class __$$VideoMetaImplCopyWithImpl<$Res>
    extends _$VideoMetaCopyWithImpl<$Res, _$VideoMetaImpl>
    implements _$$VideoMetaImplCopyWith<$Res> {
  __$$VideoMetaImplCopyWithImpl(
    _$VideoMetaImpl _value,
    $Res Function(_$VideoMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationSeconds = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? fps = freezed,
  }) {
    return _then(
      _$VideoMetaImpl(
        durationSeconds: freezed == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as double?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        fps: freezed == fps
            ? _value.fps
            : fps // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoMetaImpl implements _VideoMeta {
  const _$VideoMetaImpl({
    this.durationSeconds,
    this.width,
    this.height,
    this.fps,
  });

  factory _$VideoMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoMetaImplFromJson(json);

  @override
  final double? durationSeconds;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final double? fps;

  @override
  String toString() {
    return 'VideoMeta(durationSeconds: $durationSeconds, width: $width, height: $height, fps: $fps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoMetaImpl &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.fps, fps) || other.fps == fps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, durationSeconds, width, height, fps);

  /// Create a copy of VideoMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoMetaImplCopyWith<_$VideoMetaImpl> get copyWith =>
      __$$VideoMetaImplCopyWithImpl<_$VideoMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoMetaImplToJson(this);
  }
}

abstract class _VideoMeta implements VideoMeta {
  const factory _VideoMeta({
    final double? durationSeconds,
    final int? width,
    final int? height,
    final double? fps,
  }) = _$VideoMetaImpl;

  factory _VideoMeta.fromJson(Map<String, dynamic> json) =
      _$VideoMetaImpl.fromJson;

  @override
  double? get durationSeconds;
  @override
  int? get width;
  @override
  int? get height;
  @override
  double? get fps;

  /// Create a copy of VideoMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoMetaImplCopyWith<_$VideoMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentMeta _$DocumentMetaFromJson(Map<String, dynamic> json) {
  return _DocumentMeta.fromJson(json);
}

/// @nodoc
mixin _$DocumentMeta {
  int? get pageCount => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  bool? get searchableText => throw _privateConstructorUsedError;

  /// Serializes this DocumentMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentMetaCopyWith<DocumentMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentMetaCopyWith<$Res> {
  factory $DocumentMetaCopyWith(
    DocumentMeta value,
    $Res Function(DocumentMeta) then,
  ) = _$DocumentMetaCopyWithImpl<$Res, DocumentMeta>;
  @useResult
  $Res call({int? pageCount, String? language, bool? searchableText});
}

/// @nodoc
class _$DocumentMetaCopyWithImpl<$Res, $Val extends DocumentMeta>
    implements $DocumentMetaCopyWith<$Res> {
  _$DocumentMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageCount = freezed,
    Object? language = freezed,
    Object? searchableText = freezed,
  }) {
    return _then(
      _value.copyWith(
            pageCount: freezed == pageCount
                ? _value.pageCount
                : pageCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            language: freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String?,
            searchableText: freezed == searchableText
                ? _value.searchableText
                : searchableText // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentMetaImplCopyWith<$Res>
    implements $DocumentMetaCopyWith<$Res> {
  factory _$$DocumentMetaImplCopyWith(
    _$DocumentMetaImpl value,
    $Res Function(_$DocumentMetaImpl) then,
  ) = __$$DocumentMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? pageCount, String? language, bool? searchableText});
}

/// @nodoc
class __$$DocumentMetaImplCopyWithImpl<$Res>
    extends _$DocumentMetaCopyWithImpl<$Res, _$DocumentMetaImpl>
    implements _$$DocumentMetaImplCopyWith<$Res> {
  __$$DocumentMetaImplCopyWithImpl(
    _$DocumentMetaImpl _value,
    $Res Function(_$DocumentMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageCount = freezed,
    Object? language = freezed,
    Object? searchableText = freezed,
  }) {
    return _then(
      _$DocumentMetaImpl(
        pageCount: freezed == pageCount
            ? _value.pageCount
            : pageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        language: freezed == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchableText: freezed == searchableText
            ? _value.searchableText
            : searchableText // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentMetaImpl implements _DocumentMeta {
  const _$DocumentMetaImpl({
    this.pageCount,
    this.language,
    this.searchableText,
  });

  factory _$DocumentMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentMetaImplFromJson(json);

  @override
  final int? pageCount;
  @override
  final String? language;
  @override
  final bool? searchableText;

  @override
  String toString() {
    return 'DocumentMeta(pageCount: $pageCount, language: $language, searchableText: $searchableText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentMetaImpl &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.searchableText, searchableText) ||
                other.searchableText == searchableText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, pageCount, language, searchableText);

  /// Create a copy of DocumentMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentMetaImplCopyWith<_$DocumentMetaImpl> get copyWith =>
      __$$DocumentMetaImplCopyWithImpl<_$DocumentMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentMetaImplToJson(this);
  }
}

abstract class _DocumentMeta implements DocumentMeta {
  const factory _DocumentMeta({
    final int? pageCount,
    final String? language,
    final bool? searchableText,
  }) = _$DocumentMetaImpl;

  factory _DocumentMeta.fromJson(Map<String, dynamic> json) =
      _$DocumentMetaImpl.fromJson;

  @override
  int? get pageCount;
  @override
  String? get language;
  @override
  bool? get searchableText;

  /// Create a copy of DocumentMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentMetaImplCopyWith<_$DocumentMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiMeta _$AiMetaFromJson(Map<String, dynamic> json) {
  return _AiMeta.fromJson(json);
}

/// @nodoc
mixin _$AiMeta {
  /// Which AI tool produced or consumes this file.
  String? get toolName =>
      throw _privateConstructorUsedError; // e.g. "text_generation", "translate", etc.
  /// ID of the request that produced this file (if result).
  String? get requestId => throw _privateConstructorUsedError;

  /// ID of related source file, if any.
  String? get sourceEntryId => throw _privateConstructorUsedError;

  /// Model/provider info.
  String? get modelName => throw _privateConstructorUsedError;
  String? get providerName => throw _privateConstructorUsedError;

  /// Serializes this AiMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiMetaCopyWith<AiMeta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiMetaCopyWith<$Res> {
  factory $AiMetaCopyWith(AiMeta value, $Res Function(AiMeta) then) =
      _$AiMetaCopyWithImpl<$Res, AiMeta>;
  @useResult
  $Res call({
    String? toolName,
    String? requestId,
    String? sourceEntryId,
    String? modelName,
    String? providerName,
  });
}

/// @nodoc
class _$AiMetaCopyWithImpl<$Res, $Val extends AiMeta>
    implements $AiMetaCopyWith<$Res> {
  _$AiMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolName = freezed,
    Object? requestId = freezed,
    Object? sourceEntryId = freezed,
    Object? modelName = freezed,
    Object? providerName = freezed,
  }) {
    return _then(
      _value.copyWith(
            toolName: freezed == toolName
                ? _value.toolName
                : toolName // ignore: cast_nullable_to_non_nullable
                      as String?,
            requestId: freezed == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sourceEntryId: freezed == sourceEntryId
                ? _value.sourceEntryId
                : sourceEntryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            modelName: freezed == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                      as String?,
            providerName: freezed == providerName
                ? _value.providerName
                : providerName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiMetaImplCopyWith<$Res> implements $AiMetaCopyWith<$Res> {
  factory _$$AiMetaImplCopyWith(
    _$AiMetaImpl value,
    $Res Function(_$AiMetaImpl) then,
  ) = __$$AiMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? toolName,
    String? requestId,
    String? sourceEntryId,
    String? modelName,
    String? providerName,
  });
}

/// @nodoc
class __$$AiMetaImplCopyWithImpl<$Res>
    extends _$AiMetaCopyWithImpl<$Res, _$AiMetaImpl>
    implements _$$AiMetaImplCopyWith<$Res> {
  __$$AiMetaImplCopyWithImpl(
    _$AiMetaImpl _value,
    $Res Function(_$AiMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolName = freezed,
    Object? requestId = freezed,
    Object? sourceEntryId = freezed,
    Object? modelName = freezed,
    Object? providerName = freezed,
  }) {
    return _then(
      _$AiMetaImpl(
        toolName: freezed == toolName
            ? _value.toolName
            : toolName // ignore: cast_nullable_to_non_nullable
                  as String?,
        requestId: freezed == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceEntryId: freezed == sourceEntryId
            ? _value.sourceEntryId
            : sourceEntryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        modelName: freezed == modelName
            ? _value.modelName
            : modelName // ignore: cast_nullable_to_non_nullable
                  as String?,
        providerName: freezed == providerName
            ? _value.providerName
            : providerName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiMetaImpl implements _AiMeta {
  const _$AiMetaImpl({
    this.toolName,
    this.requestId,
    this.sourceEntryId,
    this.modelName,
    this.providerName,
  });

  factory _$AiMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiMetaImplFromJson(json);

  /// Which AI tool produced or consumes this file.
  @override
  final String? toolName;
  // e.g. "text_generation", "translate", etc.
  /// ID of the request that produced this file (if result).
  @override
  final String? requestId;

  /// ID of related source file, if any.
  @override
  final String? sourceEntryId;

  /// Model/provider info.
  @override
  final String? modelName;
  @override
  final String? providerName;

  @override
  String toString() {
    return 'AiMeta(toolName: $toolName, requestId: $requestId, sourceEntryId: $sourceEntryId, modelName: $modelName, providerName: $providerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiMetaImpl &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.sourceEntryId, sourceEntryId) ||
                other.sourceEntryId == sourceEntryId) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.providerName, providerName) ||
                other.providerName == providerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    toolName,
    requestId,
    sourceEntryId,
    modelName,
    providerName,
  );

  /// Create a copy of AiMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiMetaImplCopyWith<_$AiMetaImpl> get copyWith =>
      __$$AiMetaImplCopyWithImpl<_$AiMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiMetaImplToJson(this);
  }
}

abstract class _AiMeta implements AiMeta {
  const factory _AiMeta({
    final String? toolName,
    final String? requestId,
    final String? sourceEntryId,
    final String? modelName,
    final String? providerName,
  }) = _$AiMetaImpl;

  factory _AiMeta.fromJson(Map<String, dynamic> json) = _$AiMetaImpl.fromJson;

  /// Which AI tool produced or consumes this file.
  @override
  String? get toolName; // e.g. "text_generation", "translate", etc.
  /// ID of the request that produced this file (if result).
  @override
  String? get requestId;

  /// ID of related source file, if any.
  @override
  String? get sourceEntryId;

  /// Model/provider info.
  @override
  String? get modelName;
  @override
  String? get providerName;

  /// Create a copy of AiMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiMetaImplCopyWith<_$AiMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FileTypeMeta _$FileTypeMetaFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'image':
      return FileTypeMetaImage.fromJson(json);
    case 'audio':
      return FileTypeMetaAudio.fromJson(json);
    case 'video':
      return FileTypeMetaVideo.fromJson(json);
    case 'document':
      return FileTypeMetaDocument.fromJson(json);
    case 'ai':
      return FileTypeMetaAi.fromJson(json);
    case 'unknown':
      return FileTypeMetaUnknown.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'FileTypeMeta',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$FileTypeMeta {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this FileTypeMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileTypeMetaCopyWith<$Res> {
  factory $FileTypeMetaCopyWith(
    FileTypeMeta value,
    $Res Function(FileTypeMeta) then,
  ) = _$FileTypeMetaCopyWithImpl<$Res, FileTypeMeta>;
}

/// @nodoc
class _$FileTypeMetaCopyWithImpl<$Res, $Val extends FileTypeMeta>
    implements $FileTypeMetaCopyWith<$Res> {
  _$FileTypeMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FileTypeMetaImageImplCopyWith<$Res> {
  factory _$$FileTypeMetaImageImplCopyWith(
    _$FileTypeMetaImageImpl value,
    $Res Function(_$FileTypeMetaImageImpl) then,
  ) = __$$FileTypeMetaImageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ImageMeta image});

  $ImageMetaCopyWith<$Res> get image;
}

/// @nodoc
class __$$FileTypeMetaImageImplCopyWithImpl<$Res>
    extends _$FileTypeMetaCopyWithImpl<$Res, _$FileTypeMetaImageImpl>
    implements _$$FileTypeMetaImageImplCopyWith<$Res> {
  __$$FileTypeMetaImageImplCopyWithImpl(
    _$FileTypeMetaImageImpl _value,
    $Res Function(_$FileTypeMetaImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? image = null}) {
    return _then(
      _$FileTypeMetaImageImpl(
        null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as ImageMeta,
      ),
    );
  }

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMetaCopyWith<$Res> get image {
    return $ImageMetaCopyWith<$Res>(_value.image, (value) {
      return _then(_value.copyWith(image: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FileTypeMetaImageImpl implements FileTypeMetaImage {
  const _$FileTypeMetaImageImpl(this.image, {final String? $type})
    : $type = $type ?? 'image';

  factory _$FileTypeMetaImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileTypeMetaImageImplFromJson(json);

  @override
  final ImageMeta image;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FileTypeMeta.image(image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileTypeMetaImageImpl &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, image);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileTypeMetaImageImplCopyWith<_$FileTypeMetaImageImpl> get copyWith =>
      __$$FileTypeMetaImageImplCopyWithImpl<_$FileTypeMetaImageImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return image(this.image);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return image?.call(this.image);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(this.image);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) {
    return image(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) {
    return image?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileTypeMetaImageImplToJson(this);
  }
}

abstract class FileTypeMetaImage implements FileTypeMeta {
  const factory FileTypeMetaImage(final ImageMeta image) =
      _$FileTypeMetaImageImpl;

  factory FileTypeMetaImage.fromJson(Map<String, dynamic> json) =
      _$FileTypeMetaImageImpl.fromJson;

  ImageMeta get image;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileTypeMetaImageImplCopyWith<_$FileTypeMetaImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileTypeMetaAudioImplCopyWith<$Res> {
  factory _$$FileTypeMetaAudioImplCopyWith(
    _$FileTypeMetaAudioImpl value,
    $Res Function(_$FileTypeMetaAudioImpl) then,
  ) = __$$FileTypeMetaAudioImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AudioMeta audio});

  $AudioMetaCopyWith<$Res> get audio;
}

/// @nodoc
class __$$FileTypeMetaAudioImplCopyWithImpl<$Res>
    extends _$FileTypeMetaCopyWithImpl<$Res, _$FileTypeMetaAudioImpl>
    implements _$$FileTypeMetaAudioImplCopyWith<$Res> {
  __$$FileTypeMetaAudioImplCopyWithImpl(
    _$FileTypeMetaAudioImpl _value,
    $Res Function(_$FileTypeMetaAudioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? audio = null}) {
    return _then(
      _$FileTypeMetaAudioImpl(
        null == audio
            ? _value.audio
            : audio // ignore: cast_nullable_to_non_nullable
                  as AudioMeta,
      ),
    );
  }

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AudioMetaCopyWith<$Res> get audio {
    return $AudioMetaCopyWith<$Res>(_value.audio, (value) {
      return _then(_value.copyWith(audio: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FileTypeMetaAudioImpl implements FileTypeMetaAudio {
  const _$FileTypeMetaAudioImpl(this.audio, {final String? $type})
    : $type = $type ?? 'audio';

  factory _$FileTypeMetaAudioImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileTypeMetaAudioImplFromJson(json);

  @override
  final AudioMeta audio;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FileTypeMeta.audio(audio: $audio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileTypeMetaAudioImpl &&
            (identical(other.audio, audio) || other.audio == audio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, audio);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileTypeMetaAudioImplCopyWith<_$FileTypeMetaAudioImpl> get copyWith =>
      __$$FileTypeMetaAudioImplCopyWithImpl<_$FileTypeMetaAudioImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return audio(this.audio);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return audio?.call(this.audio);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(this.audio);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) {
    return audio(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) {
    return audio?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileTypeMetaAudioImplToJson(this);
  }
}

abstract class FileTypeMetaAudio implements FileTypeMeta {
  const factory FileTypeMetaAudio(final AudioMeta audio) =
      _$FileTypeMetaAudioImpl;

  factory FileTypeMetaAudio.fromJson(Map<String, dynamic> json) =
      _$FileTypeMetaAudioImpl.fromJson;

  AudioMeta get audio;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileTypeMetaAudioImplCopyWith<_$FileTypeMetaAudioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileTypeMetaVideoImplCopyWith<$Res> {
  factory _$$FileTypeMetaVideoImplCopyWith(
    _$FileTypeMetaVideoImpl value,
    $Res Function(_$FileTypeMetaVideoImpl) then,
  ) = __$$FileTypeMetaVideoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({VideoMeta video});

  $VideoMetaCopyWith<$Res> get video;
}

/// @nodoc
class __$$FileTypeMetaVideoImplCopyWithImpl<$Res>
    extends _$FileTypeMetaCopyWithImpl<$Res, _$FileTypeMetaVideoImpl>
    implements _$$FileTypeMetaVideoImplCopyWith<$Res> {
  __$$FileTypeMetaVideoImplCopyWithImpl(
    _$FileTypeMetaVideoImpl _value,
    $Res Function(_$FileTypeMetaVideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? video = null}) {
    return _then(
      _$FileTypeMetaVideoImpl(
        null == video
            ? _value.video
            : video // ignore: cast_nullable_to_non_nullable
                  as VideoMeta,
      ),
    );
  }

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoMetaCopyWith<$Res> get video {
    return $VideoMetaCopyWith<$Res>(_value.video, (value) {
      return _then(_value.copyWith(video: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FileTypeMetaVideoImpl implements FileTypeMetaVideo {
  const _$FileTypeMetaVideoImpl(this.video, {final String? $type})
    : $type = $type ?? 'video';

  factory _$FileTypeMetaVideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileTypeMetaVideoImplFromJson(json);

  @override
  final VideoMeta video;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FileTypeMeta.video(video: $video)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileTypeMetaVideoImpl &&
            (identical(other.video, video) || other.video == video));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, video);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileTypeMetaVideoImplCopyWith<_$FileTypeMetaVideoImpl> get copyWith =>
      __$$FileTypeMetaVideoImplCopyWithImpl<_$FileTypeMetaVideoImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return video(this.video);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return video?.call(this.video);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (video != null) {
      return video(this.video);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) {
    return video(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) {
    return video?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (video != null) {
      return video(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileTypeMetaVideoImplToJson(this);
  }
}

abstract class FileTypeMetaVideo implements FileTypeMeta {
  const factory FileTypeMetaVideo(final VideoMeta video) =
      _$FileTypeMetaVideoImpl;

  factory FileTypeMetaVideo.fromJson(Map<String, dynamic> json) =
      _$FileTypeMetaVideoImpl.fromJson;

  VideoMeta get video;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileTypeMetaVideoImplCopyWith<_$FileTypeMetaVideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileTypeMetaDocumentImplCopyWith<$Res> {
  factory _$$FileTypeMetaDocumentImplCopyWith(
    _$FileTypeMetaDocumentImpl value,
    $Res Function(_$FileTypeMetaDocumentImpl) then,
  ) = __$$FileTypeMetaDocumentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DocumentMeta document});

  $DocumentMetaCopyWith<$Res> get document;
}

/// @nodoc
class __$$FileTypeMetaDocumentImplCopyWithImpl<$Res>
    extends _$FileTypeMetaCopyWithImpl<$Res, _$FileTypeMetaDocumentImpl>
    implements _$$FileTypeMetaDocumentImplCopyWith<$Res> {
  __$$FileTypeMetaDocumentImplCopyWithImpl(
    _$FileTypeMetaDocumentImpl _value,
    $Res Function(_$FileTypeMetaDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? document = null}) {
    return _then(
      _$FileTypeMetaDocumentImpl(
        null == document
            ? _value.document
            : document // ignore: cast_nullable_to_non_nullable
                  as DocumentMeta,
      ),
    );
  }

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentMetaCopyWith<$Res> get document {
    return $DocumentMetaCopyWith<$Res>(_value.document, (value) {
      return _then(_value.copyWith(document: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FileTypeMetaDocumentImpl implements FileTypeMetaDocument {
  const _$FileTypeMetaDocumentImpl(this.document, {final String? $type})
    : $type = $type ?? 'document';

  factory _$FileTypeMetaDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileTypeMetaDocumentImplFromJson(json);

  @override
  final DocumentMeta document;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FileTypeMeta.document(document: $document)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileTypeMetaDocumentImpl &&
            (identical(other.document, document) ||
                other.document == document));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, document);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileTypeMetaDocumentImplCopyWith<_$FileTypeMetaDocumentImpl>
  get copyWith =>
      __$$FileTypeMetaDocumentImplCopyWithImpl<_$FileTypeMetaDocumentImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return document(this.document);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return document?.call(this.document);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (document != null) {
      return document(this.document);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) {
    return document(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) {
    return document?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (document != null) {
      return document(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileTypeMetaDocumentImplToJson(this);
  }
}

abstract class FileTypeMetaDocument implements FileTypeMeta {
  const factory FileTypeMetaDocument(final DocumentMeta document) =
      _$FileTypeMetaDocumentImpl;

  factory FileTypeMetaDocument.fromJson(Map<String, dynamic> json) =
      _$FileTypeMetaDocumentImpl.fromJson;

  DocumentMeta get document;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileTypeMetaDocumentImplCopyWith<_$FileTypeMetaDocumentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileTypeMetaAiImplCopyWith<$Res> {
  factory _$$FileTypeMetaAiImplCopyWith(
    _$FileTypeMetaAiImpl value,
    $Res Function(_$FileTypeMetaAiImpl) then,
  ) = __$$FileTypeMetaAiImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AiMeta ai});

  $AiMetaCopyWith<$Res> get ai;
}

/// @nodoc
class __$$FileTypeMetaAiImplCopyWithImpl<$Res>
    extends _$FileTypeMetaCopyWithImpl<$Res, _$FileTypeMetaAiImpl>
    implements _$$FileTypeMetaAiImplCopyWith<$Res> {
  __$$FileTypeMetaAiImplCopyWithImpl(
    _$FileTypeMetaAiImpl _value,
    $Res Function(_$FileTypeMetaAiImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ai = null}) {
    return _then(
      _$FileTypeMetaAiImpl(
        null == ai
            ? _value.ai
            : ai // ignore: cast_nullable_to_non_nullable
                  as AiMeta,
      ),
    );
  }

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiMetaCopyWith<$Res> get ai {
    return $AiMetaCopyWith<$Res>(_value.ai, (value) {
      return _then(_value.copyWith(ai: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FileTypeMetaAiImpl implements FileTypeMetaAi {
  const _$FileTypeMetaAiImpl(this.ai, {final String? $type})
    : $type = $type ?? 'ai';

  factory _$FileTypeMetaAiImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileTypeMetaAiImplFromJson(json);

  @override
  final AiMeta ai;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FileTypeMeta.ai(ai: $ai)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileTypeMetaAiImpl &&
            (identical(other.ai, ai) || other.ai == ai));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ai);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileTypeMetaAiImplCopyWith<_$FileTypeMetaAiImpl> get copyWith =>
      __$$FileTypeMetaAiImplCopyWithImpl<_$FileTypeMetaAiImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return ai(this.ai);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return ai?.call(this.ai);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (ai != null) {
      return ai(this.ai);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) {
    return ai(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) {
    return ai?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (ai != null) {
      return ai(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileTypeMetaAiImplToJson(this);
  }
}

abstract class FileTypeMetaAi implements FileTypeMeta {
  const factory FileTypeMetaAi(final AiMeta ai) = _$FileTypeMetaAiImpl;

  factory FileTypeMetaAi.fromJson(Map<String, dynamic> json) =
      _$FileTypeMetaAiImpl.fromJson;

  AiMeta get ai;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileTypeMetaAiImplCopyWith<_$FileTypeMetaAiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileTypeMetaUnknownImplCopyWith<$Res> {
  factory _$$FileTypeMetaUnknownImplCopyWith(
    _$FileTypeMetaUnknownImpl value,
    $Res Function(_$FileTypeMetaUnknownImpl) then,
  ) = __$$FileTypeMetaUnknownImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> data});
}

/// @nodoc
class __$$FileTypeMetaUnknownImplCopyWithImpl<$Res>
    extends _$FileTypeMetaCopyWithImpl<$Res, _$FileTypeMetaUnknownImpl>
    implements _$$FileTypeMetaUnknownImplCopyWith<$Res> {
  __$$FileTypeMetaUnknownImplCopyWithImpl(
    _$FileTypeMetaUnknownImpl _value,
    $Res Function(_$FileTypeMetaUnknownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$FileTypeMetaUnknownImpl(
        null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FileTypeMetaUnknownImpl implements FileTypeMetaUnknown {
  const _$FileTypeMetaUnknownImpl(
    final Map<String, dynamic> data, {
    final String? $type,
  }) : _data = data,
       $type = $type ?? 'unknown';

  factory _$FileTypeMetaUnknownImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileTypeMetaUnknownImplFromJson(json);

  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FileTypeMeta.unknown(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileTypeMetaUnknownImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileTypeMetaUnknownImplCopyWith<_$FileTypeMetaUnknownImpl> get copyWith =>
      __$$FileTypeMetaUnknownImplCopyWithImpl<_$FileTypeMetaUnknownImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageMeta image) image,
    required TResult Function(AudioMeta audio) audio,
    required TResult Function(VideoMeta video) video,
    required TResult Function(DocumentMeta document) document,
    required TResult Function(AiMeta ai) ai,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return unknown(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageMeta image)? image,
    TResult? Function(AudioMeta audio)? audio,
    TResult? Function(VideoMeta video)? video,
    TResult? Function(DocumentMeta document)? document,
    TResult? Function(AiMeta ai)? ai,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return unknown?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageMeta image)? image,
    TResult Function(AudioMeta audio)? audio,
    TResult Function(VideoMeta video)? video,
    TResult Function(DocumentMeta document)? document,
    TResult Function(AiMeta ai)? ai,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileTypeMetaImage value) image,
    required TResult Function(FileTypeMetaAudio value) audio,
    required TResult Function(FileTypeMetaVideo value) video,
    required TResult Function(FileTypeMetaDocument value) document,
    required TResult Function(FileTypeMetaAi value) ai,
    required TResult Function(FileTypeMetaUnknown value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileTypeMetaImage value)? image,
    TResult? Function(FileTypeMetaAudio value)? audio,
    TResult? Function(FileTypeMetaVideo value)? video,
    TResult? Function(FileTypeMetaDocument value)? document,
    TResult? Function(FileTypeMetaAi value)? ai,
    TResult? Function(FileTypeMetaUnknown value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileTypeMetaImage value)? image,
    TResult Function(FileTypeMetaAudio value)? audio,
    TResult Function(FileTypeMetaVideo value)? video,
    TResult Function(FileTypeMetaDocument value)? document,
    TResult Function(FileTypeMetaAi value)? ai,
    TResult Function(FileTypeMetaUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileTypeMetaUnknownImplToJson(this);
  }
}

abstract class FileTypeMetaUnknown implements FileTypeMeta {
  const factory FileTypeMetaUnknown(final Map<String, dynamic> data) =
      _$FileTypeMetaUnknownImpl;

  factory FileTypeMetaUnknown.fromJson(Map<String, dynamic> json) =
      _$FileTypeMetaUnknownImpl.fromJson;

  Map<String, dynamic> get data;

  /// Create a copy of FileTypeMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileTypeMetaUnknownImplCopyWith<_$FileTypeMetaUnknownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FsFileData _$FsFileDataFromJson(Map<String, dynamic> json) {
  return _FsFileData.fromJson(json);
}

/// @nodoc
mixin _$FsFileData {
  /// How the file is stored.
  StorageLocation get location => throw _privateConstructorUsedError;

  /// Low-level mime type, e.g. `image/png`, `text/markdown`.
  String? get mime => throw _privateConstructorUsedError;

  /// Optional typed metadata for the specific content.
  FileTypeMeta? get typeMeta => throw _privateConstructorUsedError;

  /// Whether content is fully available (vs. stub).
  bool get isContentAvailable => throw _privateConstructorUsedError;

  /// Which conversions this file supports.
  List<FileConversionCapability> get convertibleTo =>
      throw _privateConstructorUsedError;

  /// Serializes this FsFileData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FsFileDataCopyWith<FsFileData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FsFileDataCopyWith<$Res> {
  factory $FsFileDataCopyWith(
    FsFileData value,
    $Res Function(FsFileData) then,
  ) = _$FsFileDataCopyWithImpl<$Res, FsFileData>;
  @useResult
  $Res call({
    StorageLocation location,
    String? mime,
    FileTypeMeta? typeMeta,
    bool isContentAvailable,
    List<FileConversionCapability> convertibleTo,
  });

  $StorageLocationCopyWith<$Res> get location;
  $FileTypeMetaCopyWith<$Res>? get typeMeta;
}

/// @nodoc
class _$FsFileDataCopyWithImpl<$Res, $Val extends FsFileData>
    implements $FsFileDataCopyWith<$Res> {
  _$FsFileDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? mime = freezed,
    Object? typeMeta = freezed,
    Object? isContentAvailable = null,
    Object? convertibleTo = null,
  }) {
    return _then(
      _value.copyWith(
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as StorageLocation,
            mime: freezed == mime
                ? _value.mime
                : mime // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeMeta: freezed == typeMeta
                ? _value.typeMeta
                : typeMeta // ignore: cast_nullable_to_non_nullable
                      as FileTypeMeta?,
            isContentAvailable: null == isContentAvailable
                ? _value.isContentAvailable
                : isContentAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            convertibleTo: null == convertibleTo
                ? _value.convertibleTo
                : convertibleTo // ignore: cast_nullable_to_non_nullable
                      as List<FileConversionCapability>,
          )
          as $Val,
    );
  }

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StorageLocationCopyWith<$Res> get location {
    return $StorageLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileTypeMetaCopyWith<$Res>? get typeMeta {
    if (_value.typeMeta == null) {
      return null;
    }

    return $FileTypeMetaCopyWith<$Res>(_value.typeMeta!, (value) {
      return _then(_value.copyWith(typeMeta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FsFileDataImplCopyWith<$Res>
    implements $FsFileDataCopyWith<$Res> {
  factory _$$FsFileDataImplCopyWith(
    _$FsFileDataImpl value,
    $Res Function(_$FsFileDataImpl) then,
  ) = __$$FsFileDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    StorageLocation location,
    String? mime,
    FileTypeMeta? typeMeta,
    bool isContentAvailable,
    List<FileConversionCapability> convertibleTo,
  });

  @override
  $StorageLocationCopyWith<$Res> get location;
  @override
  $FileTypeMetaCopyWith<$Res>? get typeMeta;
}

/// @nodoc
class __$$FsFileDataImplCopyWithImpl<$Res>
    extends _$FsFileDataCopyWithImpl<$Res, _$FsFileDataImpl>
    implements _$$FsFileDataImplCopyWith<$Res> {
  __$$FsFileDataImplCopyWithImpl(
    _$FsFileDataImpl _value,
    $Res Function(_$FsFileDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? mime = freezed,
    Object? typeMeta = freezed,
    Object? isContentAvailable = null,
    Object? convertibleTo = null,
  }) {
    return _then(
      _$FsFileDataImpl(
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as StorageLocation,
        mime: freezed == mime
            ? _value.mime
            : mime // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeMeta: freezed == typeMeta
            ? _value.typeMeta
            : typeMeta // ignore: cast_nullable_to_non_nullable
                  as FileTypeMeta?,
        isContentAvailable: null == isContentAvailable
            ? _value.isContentAvailable
            : isContentAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        convertibleTo: null == convertibleTo
            ? _value._convertibleTo
            : convertibleTo // ignore: cast_nullable_to_non_nullable
                  as List<FileConversionCapability>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FsFileDataImpl implements _FsFileData {
  const _$FsFileDataImpl({
    required this.location,
    this.mime,
    this.typeMeta,
    this.isContentAvailable = true,
    final List<FileConversionCapability> convertibleTo =
        const <FileConversionCapability>[],
  }) : _convertibleTo = convertibleTo;

  factory _$FsFileDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FsFileDataImplFromJson(json);

  /// How the file is stored.
  @override
  final StorageLocation location;

  /// Low-level mime type, e.g. `image/png`, `text/markdown`.
  @override
  final String? mime;

  /// Optional typed metadata for the specific content.
  @override
  final FileTypeMeta? typeMeta;

  /// Whether content is fully available (vs. stub).
  @override
  @JsonKey()
  final bool isContentAvailable;

  /// Which conversions this file supports.
  final List<FileConversionCapability> _convertibleTo;

  /// Which conversions this file supports.
  @override
  @JsonKey()
  List<FileConversionCapability> get convertibleTo {
    if (_convertibleTo is EqualUnmodifiableListView) return _convertibleTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_convertibleTo);
  }

  @override
  String toString() {
    return 'FsFileData(location: $location, mime: $mime, typeMeta: $typeMeta, isContentAvailable: $isContentAvailable, convertibleTo: $convertibleTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FsFileDataImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.mime, mime) || other.mime == mime) &&
            (identical(other.typeMeta, typeMeta) ||
                other.typeMeta == typeMeta) &&
            (identical(other.isContentAvailable, isContentAvailable) ||
                other.isContentAvailable == isContentAvailable) &&
            const DeepCollectionEquality().equals(
              other._convertibleTo,
              _convertibleTo,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    location,
    mime,
    typeMeta,
    isContentAvailable,
    const DeepCollectionEquality().hash(_convertibleTo),
  );

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FsFileDataImplCopyWith<_$FsFileDataImpl> get copyWith =>
      __$$FsFileDataImplCopyWithImpl<_$FsFileDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FsFileDataImplToJson(this);
  }
}

abstract class _FsFileData implements FsFileData {
  const factory _FsFileData({
    required final StorageLocation location,
    final String? mime,
    final FileTypeMeta? typeMeta,
    final bool isContentAvailable,
    final List<FileConversionCapability> convertibleTo,
  }) = _$FsFileDataImpl;

  factory _FsFileData.fromJson(Map<String, dynamic> json) =
      _$FsFileDataImpl.fromJson;

  /// How the file is stored.
  @override
  StorageLocation get location;

  /// Low-level mime type, e.g. `image/png`, `text/markdown`.
  @override
  String? get mime;

  /// Optional typed metadata for the specific content.
  @override
  FileTypeMeta? get typeMeta;

  /// Whether content is fully available (vs. stub).
  @override
  bool get isContentAvailable;

  /// Which conversions this file supports.
  @override
  List<FileConversionCapability> get convertibleTo;

  /// Create a copy of FsFileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FsFileDataImplCopyWith<_$FsFileDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
