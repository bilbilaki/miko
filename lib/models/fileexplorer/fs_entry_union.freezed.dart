// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fs_entry_union.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FsEntry _$FsEntryFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'file':
      return FsFile.fromJson(json);
    case 'folder':
      return FsFolder.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'FsEntry',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$FsEntry {
  FsEntryBase get base => throw _privateConstructorUsedError;
  Object get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FsEntryBase base, FsFileData data) file,
    required TResult Function(FsEntryBase base, FsFolderData data) folder,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FsEntryBase base, FsFileData data)? file,
    TResult? Function(FsEntryBase base, FsFolderData data)? folder,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FsEntryBase base, FsFileData data)? file,
    TResult Function(FsEntryBase base, FsFolderData data)? folder,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FsFile value) file,
    required TResult Function(FsFolder value) folder,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FsFile value)? file,
    TResult? Function(FsFolder value)? folder,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FsFile value)? file,
    TResult Function(FsFolder value)? folder,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this FsEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FsEntryCopyWith<FsEntry> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FsEntryCopyWith<$Res> {
  factory $FsEntryCopyWith(FsEntry value, $Res Function(FsEntry) then) =
      _$FsEntryCopyWithImpl<$Res, FsEntry>;
  @useResult
  $Res call({FsEntryBase base});

  $FsEntryBaseCopyWith<$Res> get base;
}

/// @nodoc
class _$FsEntryCopyWithImpl<$Res, $Val extends FsEntry>
    implements $FsEntryCopyWith<$Res> {
  _$FsEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? base = null}) {
    return _then(
      _value.copyWith(
            base: null == base
                ? _value.base
                : base // ignore: cast_nullable_to_non_nullable
                      as FsEntryBase,
          )
          as $Val,
    );
  }

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FsEntryBaseCopyWith<$Res> get base {
    return $FsEntryBaseCopyWith<$Res>(_value.base, (value) {
      return _then(_value.copyWith(base: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FsFileImplCopyWith<$Res> implements $FsEntryCopyWith<$Res> {
  factory _$$FsFileImplCopyWith(
    _$FsFileImpl value,
    $Res Function(_$FsFileImpl) then,
  ) = __$$FsFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FsEntryBase base, FsFileData data});

  @override
  $FsEntryBaseCopyWith<$Res> get base;
  $FsFileDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$FsFileImplCopyWithImpl<$Res>
    extends _$FsEntryCopyWithImpl<$Res, _$FsFileImpl>
    implements _$$FsFileImplCopyWith<$Res> {
  __$$FsFileImplCopyWithImpl(
    _$FsFileImpl _value,
    $Res Function(_$FsFileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? base = null, Object? data = null}) {
    return _then(
      _$FsFileImpl(
        base: null == base
            ? _value.base
            : base // ignore: cast_nullable_to_non_nullable
                  as FsEntryBase,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as FsFileData,
      ),
    );
  }

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FsFileDataCopyWith<$Res> get data {
    return $FsFileDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FsFileImpl extends FsFile {
  const _$FsFileImpl({
    required this.base,
    required this.data,
    final String? $type,
  }) : $type = $type ?? 'file',
       super._();

  factory _$FsFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$FsFileImplFromJson(json);

  @override
  final FsEntryBase base;
  @override
  final FsFileData data;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FsEntry.file(base: $base, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FsFileImpl &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, base, data);

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FsFileImplCopyWith<_$FsFileImpl> get copyWith =>
      __$$FsFileImplCopyWithImpl<_$FsFileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FsEntryBase base, FsFileData data) file,
    required TResult Function(FsEntryBase base, FsFolderData data) folder,
  }) {
    return file(base, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FsEntryBase base, FsFileData data)? file,
    TResult? Function(FsEntryBase base, FsFolderData data)? folder,
  }) {
    return file?.call(base, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FsEntryBase base, FsFileData data)? file,
    TResult Function(FsEntryBase base, FsFolderData data)? folder,
    required TResult orElse(),
  }) {
    if (file != null) {
      return file(base, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FsFile value) file,
    required TResult Function(FsFolder value) folder,
  }) {
    return file(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FsFile value)? file,
    TResult? Function(FsFolder value)? folder,
  }) {
    return file?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FsFile value)? file,
    TResult Function(FsFolder value)? folder,
    required TResult orElse(),
  }) {
    if (file != null) {
      return file(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FsFileImplToJson(this);
  }
}

abstract class FsFile extends FsEntry {
  const factory FsFile({
    required final FsEntryBase base,
    required final FsFileData data,
  }) = _$FsFileImpl;
  const FsFile._() : super._();

  factory FsFile.fromJson(Map<String, dynamic> json) = _$FsFileImpl.fromJson;

  @override
  FsEntryBase get base;
  @override
  FsFileData get data;

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FsFileImplCopyWith<_$FsFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FsFolderImplCopyWith<$Res> implements $FsEntryCopyWith<$Res> {
  factory _$$FsFolderImplCopyWith(
    _$FsFolderImpl value,
    $Res Function(_$FsFolderImpl) then,
  ) = __$$FsFolderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FsEntryBase base, FsFolderData data});

  @override
  $FsEntryBaseCopyWith<$Res> get base;
  $FsFolderDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$FsFolderImplCopyWithImpl<$Res>
    extends _$FsEntryCopyWithImpl<$Res, _$FsFolderImpl>
    implements _$$FsFolderImplCopyWith<$Res> {
  __$$FsFolderImplCopyWithImpl(
    _$FsFolderImpl _value,
    $Res Function(_$FsFolderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? base = null, Object? data = null}) {
    return _then(
      _$FsFolderImpl(
        base: null == base
            ? _value.base
            : base // ignore: cast_nullable_to_non_nullable
                  as FsEntryBase,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as FsFolderData,
      ),
    );
  }

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FsFolderDataCopyWith<$Res> get data {
    return $FsFolderDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$FsFolderImpl extends FsFolder {
  const _$FsFolderImpl({
    required this.base,
    required this.data,
    final String? $type,
  }) : $type = $type ?? 'folder',
       super._();

  factory _$FsFolderImpl.fromJson(Map<String, dynamic> json) =>
      _$$FsFolderImplFromJson(json);

  @override
  final FsEntryBase base;
  @override
  final FsFolderData data;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FsEntry.folder(base: $base, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FsFolderImpl &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, base, data);

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FsFolderImplCopyWith<_$FsFolderImpl> get copyWith =>
      __$$FsFolderImplCopyWithImpl<_$FsFolderImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FsEntryBase base, FsFileData data) file,
    required TResult Function(FsEntryBase base, FsFolderData data) folder,
  }) {
    return folder(base, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FsEntryBase base, FsFileData data)? file,
    TResult? Function(FsEntryBase base, FsFolderData data)? folder,
  }) {
    return folder?.call(base, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FsEntryBase base, FsFileData data)? file,
    TResult Function(FsEntryBase base, FsFolderData data)? folder,
    required TResult orElse(),
  }) {
    if (folder != null) {
      return folder(base, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FsFile value) file,
    required TResult Function(FsFolder value) folder,
  }) {
    return folder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FsFile value)? file,
    TResult? Function(FsFolder value)? folder,
  }) {
    return folder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FsFile value)? file,
    TResult Function(FsFolder value)? folder,
    required TResult orElse(),
  }) {
    if (folder != null) {
      return folder(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FsFolderImplToJson(this);
  }
}

abstract class FsFolder extends FsEntry {
  const factory FsFolder({
    required final FsEntryBase base,
    required final FsFolderData data,
  }) = _$FsFolderImpl;
  const FsFolder._() : super._();

  factory FsFolder.fromJson(Map<String, dynamic> json) =
      _$FsFolderImpl.fromJson;

  @override
  FsEntryBase get base;
  @override
  FsFolderData get data;

  /// Create a copy of FsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FsFolderImplCopyWith<_$FsFolderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
