// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fs_folder_children.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FolderChildRef _$FolderChildRefFromJson(Map<String, dynamic> json) {
  return _FolderChildRef.fromJson(json);
}

/// @nodoc
mixin _$FolderChildRef {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isFolder => throw _privateConstructorUsedError;

  /// Serializes this FolderChildRef to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FolderChildRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FolderChildRefCopyWith<FolderChildRef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FolderChildRefCopyWith<$Res> {
  factory $FolderChildRefCopyWith(
    FolderChildRef value,
    $Res Function(FolderChildRef) then,
  ) = _$FolderChildRefCopyWithImpl<$Res, FolderChildRef>;
  @useResult
  $Res call({String id, String name, bool isFolder});
}

/// @nodoc
class _$FolderChildRefCopyWithImpl<$Res, $Val extends FolderChildRef>
    implements $FolderChildRefCopyWith<$Res> {
  _$FolderChildRefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FolderChildRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? isFolder = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isFolder: null == isFolder
                ? _value.isFolder
                : isFolder // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FolderChildRefImplCopyWith<$Res>
    implements $FolderChildRefCopyWith<$Res> {
  factory _$$FolderChildRefImplCopyWith(
    _$FolderChildRefImpl value,
    $Res Function(_$FolderChildRefImpl) then,
  ) = __$$FolderChildRefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, bool isFolder});
}

/// @nodoc
class __$$FolderChildRefImplCopyWithImpl<$Res>
    extends _$FolderChildRefCopyWithImpl<$Res, _$FolderChildRefImpl>
    implements _$$FolderChildRefImplCopyWith<$Res> {
  __$$FolderChildRefImplCopyWithImpl(
    _$FolderChildRefImpl _value,
    $Res Function(_$FolderChildRefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FolderChildRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? isFolder = null}) {
    return _then(
      _$FolderChildRefImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isFolder: null == isFolder
            ? _value.isFolder
            : isFolder // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FolderChildRefImpl implements _FolderChildRef {
  const _$FolderChildRefImpl({
    required this.id,
    required this.name,
    required this.isFolder,
  });

  factory _$FolderChildRefImpl.fromJson(Map<String, dynamic> json) =>
      _$$FolderChildRefImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final bool isFolder;

  @override
  String toString() {
    return 'FolderChildRef(id: $id, name: $name, isFolder: $isFolder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FolderChildRefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isFolder, isFolder) ||
                other.isFolder == isFolder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isFolder);

  /// Create a copy of FolderChildRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FolderChildRefImplCopyWith<_$FolderChildRefImpl> get copyWith =>
      __$$FolderChildRefImplCopyWithImpl<_$FolderChildRefImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FolderChildRefImplToJson(this);
  }
}

abstract class _FolderChildRef implements FolderChildRef {
  const factory _FolderChildRef({
    required final String id,
    required final String name,
    required final bool isFolder,
  }) = _$FolderChildRefImpl;

  factory _FolderChildRef.fromJson(Map<String, dynamic> json) =
      _$FolderChildRefImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  bool get isFolder;

  /// Create a copy of FolderChildRef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FolderChildRefImplCopyWith<_$FolderChildRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FsFolderData _$FsFolderDataFromJson(Map<String, dynamic> json) {
  return _FsFolderData.fromJson(json);
}

/// @nodoc
mixin _$FsFolderData {
  /// IDs of children in this folder, for quick navigation.
  List<FolderChildRef> get children => throw _privateConstructorUsedError;

  /// If true, children list might be incomplete until fully scanned.
  bool get isPartial => throw _privateConstructorUsedError;

  /// Serializes this FsFolderData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FsFolderData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FsFolderDataCopyWith<FsFolderData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FsFolderDataCopyWith<$Res> {
  factory $FsFolderDataCopyWith(
    FsFolderData value,
    $Res Function(FsFolderData) then,
  ) = _$FsFolderDataCopyWithImpl<$Res, FsFolderData>;
  @useResult
  $Res call({List<FolderChildRef> children, bool isPartial});
}

/// @nodoc
class _$FsFolderDataCopyWithImpl<$Res, $Val extends FsFolderData>
    implements $FsFolderDataCopyWith<$Res> {
  _$FsFolderDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FsFolderData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? children = null, Object? isPartial = null}) {
    return _then(
      _value.copyWith(
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<FolderChildRef>,
            isPartial: null == isPartial
                ? _value.isPartial
                : isPartial // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FsFolderDataImplCopyWith<$Res>
    implements $FsFolderDataCopyWith<$Res> {
  factory _$$FsFolderDataImplCopyWith(
    _$FsFolderDataImpl value,
    $Res Function(_$FsFolderDataImpl) then,
  ) = __$$FsFolderDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FolderChildRef> children, bool isPartial});
}

/// @nodoc
class __$$FsFolderDataImplCopyWithImpl<$Res>
    extends _$FsFolderDataCopyWithImpl<$Res, _$FsFolderDataImpl>
    implements _$$FsFolderDataImplCopyWith<$Res> {
  __$$FsFolderDataImplCopyWithImpl(
    _$FsFolderDataImpl _value,
    $Res Function(_$FsFolderDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FsFolderData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? children = null, Object? isPartial = null}) {
    return _then(
      _$FsFolderDataImpl(
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<FolderChildRef>,
        isPartial: null == isPartial
            ? _value.isPartial
            : isPartial // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FsFolderDataImpl implements _FsFolderData {
  const _$FsFolderDataImpl({
    final List<FolderChildRef> children = const <FolderChildRef>[],
    this.isPartial = false,
  }) : _children = children;

  factory _$FsFolderDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FsFolderDataImplFromJson(json);

  /// IDs of children in this folder, for quick navigation.
  final List<FolderChildRef> _children;

  /// IDs of children in this folder, for quick navigation.
  @override
  @JsonKey()
  List<FolderChildRef> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  /// If true, children list might be incomplete until fully scanned.
  @override
  @JsonKey()
  final bool isPartial;

  @override
  String toString() {
    return 'FsFolderData(children: $children, isPartial: $isPartial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FsFolderDataImpl &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.isPartial, isPartial) ||
                other.isPartial == isPartial));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_children),
    isPartial,
  );

  /// Create a copy of FsFolderData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FsFolderDataImplCopyWith<_$FsFolderDataImpl> get copyWith =>
      __$$FsFolderDataImplCopyWithImpl<_$FsFolderDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FsFolderDataImplToJson(this);
  }
}

abstract class _FsFolderData implements FsFolderData {
  const factory _FsFolderData({
    final List<FolderChildRef> children,
    final bool isPartial,
  }) = _$FsFolderDataImpl;

  factory _FsFolderData.fromJson(Map<String, dynamic> json) =
      _$FsFolderDataImpl.fromJson;

  /// IDs of children in this folder, for quick navigation.
  @override
  List<FolderChildRef> get children;

  /// If true, children list might be incomplete until fully scanned.
  @override
  bool get isPartial;

  /// Create a copy of FsFolderData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FsFolderDataImplCopyWith<_$FsFolderDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
