// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_core_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'image':
      return ImageAttachment.fromJson(json);
    case 'audio':
      return AudioAttachment.fromJson(json);
    case 'file':
      return FileAttachment.fromJson(json);
    case 'chunk':
      return ChunkAttachment.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Attachment',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Attachment {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)
        image,
    required TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)
        audio,
    required TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)
        file,
    required TResult Function(String text, String? sourceName) chunk,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult? Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult? Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult? Function(String text, String? sourceName)? chunk,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult Function(String text, String? sourceName)? chunk,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageAttachment value) image,
    required TResult Function(AudioAttachment value) audio,
    required TResult Function(FileAttachment value) file,
    required TResult Function(ChunkAttachment value) chunk,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageAttachment value)? image,
    TResult? Function(AudioAttachment value)? audio,
    TResult? Function(FileAttachment value)? file,
    TResult? Function(ChunkAttachment value)? chunk,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageAttachment value)? image,
    TResult Function(AudioAttachment value)? audio,
    TResult Function(FileAttachment value)? file,
    TResult Function(ChunkAttachment value)? chunk,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentCopyWith<$Res> {
  factory $AttachmentCopyWith(
          Attachment value, $Res Function(Attachment) then) =
      _$AttachmentCopyWithImpl<$Res, Attachment>;
}

/// @nodoc
class _$AttachmentCopyWithImpl<$Res, $Val extends Attachment>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ImageAttachmentImplCopyWith<$Res> {
  factory _$$ImageAttachmentImplCopyWith(_$ImageAttachmentImpl value,
          $Res Function(_$ImageAttachmentImpl) then) =
      __$$ImageAttachmentImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String base64Data,
      String mimeType,
      int? width,
      int? height,
      String? description});
}

/// @nodoc
class __$$ImageAttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$ImageAttachmentImpl>
    implements _$$ImageAttachmentImplCopyWith<$Res> {
  __$$ImageAttachmentImplCopyWithImpl(
      _$ImageAttachmentImpl _value, $Res Function(_$ImageAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base64Data = null,
    Object? mimeType = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? description = freezed,
  }) {
    return _then(_$ImageAttachmentImpl(
      base64Data: null == base64Data
          ? _value.base64Data
          : base64Data // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageAttachmentImpl extends ImageAttachment {
  const _$ImageAttachmentImpl(
      {required this.base64Data,
      this.mimeType = 'image/jpeg',
      this.width,
      this.height,
      this.description,
      final String? $type})
      : $type = $type ?? 'image',
        super._();

  factory _$ImageAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageAttachmentImplFromJson(json);

  @override
  final String base64Data;
  @override
  @JsonKey()
  final String mimeType;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final String? description;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Attachment.image(base64Data: $base64Data, mimeType: $mimeType, width: $width, height: $height, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageAttachmentImpl &&
            (identical(other.base64Data, base64Data) ||
                other.base64Data == base64Data) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, base64Data, mimeType, width, height, description);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageAttachmentImplCopyWith<_$ImageAttachmentImpl> get copyWith =>
      __$$ImageAttachmentImplCopyWithImpl<_$ImageAttachmentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)
        image,
    required TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)
        audio,
    required TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)
        file,
    required TResult Function(String text, String? sourceName) chunk,
  }) {
    return image(base64Data, mimeType, width, height, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult? Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult? Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult? Function(String text, String? sourceName)? chunk,
  }) {
    return image?.call(base64Data, mimeType, width, height, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult Function(String text, String? sourceName)? chunk,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(base64Data, mimeType, width, height, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageAttachment value) image,
    required TResult Function(AudioAttachment value) audio,
    required TResult Function(FileAttachment value) file,
    required TResult Function(ChunkAttachment value) chunk,
  }) {
    return image(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageAttachment value)? image,
    TResult? Function(AudioAttachment value)? audio,
    TResult? Function(FileAttachment value)? file,
    TResult? Function(ChunkAttachment value)? chunk,
  }) {
    return image?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageAttachment value)? image,
    TResult Function(AudioAttachment value)? audio,
    TResult Function(FileAttachment value)? file,
    TResult Function(ChunkAttachment value)? chunk,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageAttachmentImplToJson(
      this,
    );
  }
}

abstract class ImageAttachment extends Attachment {
  const factory ImageAttachment(
      {required final String base64Data,
      final String mimeType,
      final int? width,
      final int? height,
      final String? description}) = _$ImageAttachmentImpl;
  const ImageAttachment._() : super._();

  factory ImageAttachment.fromJson(Map<String, dynamic> json) =
      _$ImageAttachmentImpl.fromJson;

  String get base64Data;
  String get mimeType;
  int? get width;
  int? get height;
  String? get description;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageAttachmentImplCopyWith<_$ImageAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AudioAttachmentImplCopyWith<$Res> {
  factory _$$AudioAttachmentImplCopyWith(_$AudioAttachmentImpl value,
          $Res Function(_$AudioAttachmentImpl) then) =
      __$$AudioAttachmentImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {@Uint8ListBase64Converter() Uint8List bytes,
      @DurationMsConverter() Duration duration,
      AudioSourceType sourceType,
      AudioFormat format});
}

/// @nodoc
class __$$AudioAttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$AudioAttachmentImpl>
    implements _$$AudioAttachmentImplCopyWith<$Res> {
  __$$AudioAttachmentImplCopyWithImpl(
      _$AudioAttachmentImpl _value, $Res Function(_$AudioAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bytes = null,
    Object? duration = null,
    Object? sourceType = null,
    Object? format = null,
  }) {
    return _then(_$AudioAttachmentImpl(
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      sourceType: null == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as AudioSourceType,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as AudioFormat,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioAttachmentImpl extends AudioAttachment {
  const _$AudioAttachmentImpl(
      {@Uint8ListBase64Converter() required this.bytes,
      @DurationMsConverter() required this.duration,
      required this.sourceType,
      this.format = AudioFormat.wav,
      final String? $type})
      : $type = $type ?? 'audio',
        super._();

  factory _$AudioAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioAttachmentImplFromJson(json);

  @override
  @Uint8ListBase64Converter()
  final Uint8List bytes;
  @override
  @DurationMsConverter()
  final Duration duration;
  @override
  final AudioSourceType sourceType;
  @override
  @JsonKey()
  final AudioFormat format;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Attachment.audio(bytes: $bytes, duration: $duration, sourceType: $sourceType, format: $format)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioAttachmentImpl &&
            const DeepCollectionEquality().equals(other.bytes, bytes) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.format, format) || other.format == format));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(bytes), duration, sourceType, format);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioAttachmentImplCopyWith<_$AudioAttachmentImpl> get copyWith =>
      __$$AudioAttachmentImplCopyWithImpl<_$AudioAttachmentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)
        image,
    required TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)
        audio,
    required TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)
        file,
    required TResult Function(String text, String? sourceName) chunk,
  }) {
    return audio(bytes, duration, sourceType, format);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult? Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult? Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult? Function(String text, String? sourceName)? chunk,
  }) {
    return audio?.call(bytes, duration, sourceType, format);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult Function(String text, String? sourceName)? chunk,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(bytes, duration, sourceType, format);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageAttachment value) image,
    required TResult Function(AudioAttachment value) audio,
    required TResult Function(FileAttachment value) file,
    required TResult Function(ChunkAttachment value) chunk,
  }) {
    return audio(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageAttachment value)? image,
    TResult? Function(AudioAttachment value)? audio,
    TResult? Function(FileAttachment value)? file,
    TResult? Function(ChunkAttachment value)? chunk,
  }) {
    return audio?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageAttachment value)? image,
    TResult Function(AudioAttachment value)? audio,
    TResult Function(FileAttachment value)? file,
    TResult Function(ChunkAttachment value)? chunk,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioAttachmentImplToJson(
      this,
    );
  }
}

abstract class AudioAttachment extends Attachment {
  const factory AudioAttachment(
      {@Uint8ListBase64Converter() required final Uint8List bytes,
      @DurationMsConverter() required final Duration duration,
      required final AudioSourceType sourceType,
      final AudioFormat format}) = _$AudioAttachmentImpl;
  const AudioAttachment._() : super._();

  factory AudioAttachment.fromJson(Map<String, dynamic> json) =
      _$AudioAttachmentImpl.fromJson;

  @Uint8ListBase64Converter()
  Uint8List get bytes;
  @DurationMsConverter()
  Duration get duration;
  AudioSourceType get sourceType;
  AudioFormat get format;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioAttachmentImplCopyWith<_$AudioAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileAttachmentImplCopyWith<$Res> {
  factory _$$FileAttachmentImplCopyWith(_$FileAttachmentImpl value,
          $Res Function(_$FileAttachmentImpl) then) =
      __$$FileAttachmentImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String fileName,
      @Uint8ListBase64Converter() Uint8List bytes,
      String mimeType,
      int? size});
}

/// @nodoc
class __$$FileAttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$FileAttachmentImpl>
    implements _$$FileAttachmentImplCopyWith<$Res> {
  __$$FileAttachmentImplCopyWithImpl(
      _$FileAttachmentImpl _value, $Res Function(_$FileAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? bytes = null,
    Object? mimeType = null,
    Object? size = freezed,
  }) {
    return _then(_$FileAttachmentImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileAttachmentImpl extends FileAttachment {
  const _$FileAttachmentImpl(
      {required this.fileName,
      @Uint8ListBase64Converter() required this.bytes,
      this.mimeType = 'application/octet-stream',
      this.size,
      final String? $type})
      : $type = $type ?? 'file',
        super._();

  factory _$FileAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileAttachmentImplFromJson(json);

  @override
  final String fileName;
  @override
  @Uint8ListBase64Converter()
  final Uint8List bytes;
  @override
  @JsonKey()
  final String mimeType;
  @override
  final int? size;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Attachment.file(fileName: $fileName, bytes: $bytes, mimeType: $mimeType, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileAttachmentImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.bytes, bytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileName,
      const DeepCollectionEquality().hash(bytes), mimeType, size);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileAttachmentImplCopyWith<_$FileAttachmentImpl> get copyWith =>
      __$$FileAttachmentImplCopyWithImpl<_$FileAttachmentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)
        image,
    required TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)
        audio,
    required TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)
        file,
    required TResult Function(String text, String? sourceName) chunk,
  }) {
    return file(fileName, bytes, mimeType, size);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult? Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult? Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult? Function(String text, String? sourceName)? chunk,
  }) {
    return file?.call(fileName, bytes, mimeType, size);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult Function(String text, String? sourceName)? chunk,
    required TResult orElse(),
  }) {
    if (file != null) {
      return file(fileName, bytes, mimeType, size);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageAttachment value) image,
    required TResult Function(AudioAttachment value) audio,
    required TResult Function(FileAttachment value) file,
    required TResult Function(ChunkAttachment value) chunk,
  }) {
    return file(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageAttachment value)? image,
    TResult? Function(AudioAttachment value)? audio,
    TResult? Function(FileAttachment value)? file,
    TResult? Function(ChunkAttachment value)? chunk,
  }) {
    return file?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageAttachment value)? image,
    TResult Function(AudioAttachment value)? audio,
    TResult Function(FileAttachment value)? file,
    TResult Function(ChunkAttachment value)? chunk,
    required TResult orElse(),
  }) {
    if (file != null) {
      return file(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileAttachmentImplToJson(
      this,
    );
  }
}

abstract class FileAttachment extends Attachment {
  const factory FileAttachment(
      {required final String fileName,
      @Uint8ListBase64Converter() required final Uint8List bytes,
      final String mimeType,
      final int? size}) = _$FileAttachmentImpl;
  const FileAttachment._() : super._();

  factory FileAttachment.fromJson(Map<String, dynamic> json) =
      _$FileAttachmentImpl.fromJson;

  String get fileName;
  @Uint8ListBase64Converter()
  Uint8List get bytes;
  String get mimeType;
  int? get size;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileAttachmentImplCopyWith<_$FileAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChunkAttachmentImplCopyWith<$Res> {
  factory _$$ChunkAttachmentImplCopyWith(_$ChunkAttachmentImpl value,
          $Res Function(_$ChunkAttachmentImpl) then) =
      __$$ChunkAttachmentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String text, String? sourceName});
}

/// @nodoc
class __$$ChunkAttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$ChunkAttachmentImpl>
    implements _$$ChunkAttachmentImplCopyWith<$Res> {
  __$$ChunkAttachmentImplCopyWithImpl(
      _$ChunkAttachmentImpl _value, $Res Function(_$ChunkAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? sourceName = freezed,
  }) {
    return _then(_$ChunkAttachmentImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      sourceName: freezed == sourceName
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChunkAttachmentImpl extends ChunkAttachment {
  const _$ChunkAttachmentImpl(
      {required this.text, this.sourceName, final String? $type})
      : $type = $type ?? 'chunk',
        super._();

  factory _$ChunkAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChunkAttachmentImplFromJson(json);

  @override
  final String text;
  @override
  final String? sourceName;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Attachment.chunk(text: $text, sourceName: $sourceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChunkAttachmentImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.sourceName, sourceName) ||
                other.sourceName == sourceName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, sourceName);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChunkAttachmentImplCopyWith<_$ChunkAttachmentImpl> get copyWith =>
      __$$ChunkAttachmentImplCopyWithImpl<_$ChunkAttachmentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)
        image,
    required TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)
        audio,
    required TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)
        file,
    required TResult Function(String text, String? sourceName) chunk,
  }) {
    return chunk(text, sourceName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult? Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult? Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult? Function(String text, String? sourceName)? chunk,
  }) {
    return chunk?.call(text, sourceName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String base64Data, String mimeType, int? width,
            int? height, String? description)?
        image,
    TResult Function(
            @Uint8ListBase64Converter() Uint8List bytes,
            @DurationMsConverter() Duration duration,
            AudioSourceType sourceType,
            AudioFormat format)?
        audio,
    TResult Function(
            String fileName,
            @Uint8ListBase64Converter() Uint8List bytes,
            String mimeType,
            int? size)?
        file,
    TResult Function(String text, String? sourceName)? chunk,
    required TResult orElse(),
  }) {
    if (chunk != null) {
      return chunk(text, sourceName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageAttachment value) image,
    required TResult Function(AudioAttachment value) audio,
    required TResult Function(FileAttachment value) file,
    required TResult Function(ChunkAttachment value) chunk,
  }) {
    return chunk(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageAttachment value)? image,
    TResult? Function(AudioAttachment value)? audio,
    TResult? Function(FileAttachment value)? file,
    TResult? Function(ChunkAttachment value)? chunk,
  }) {
    return chunk?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageAttachment value)? image,
    TResult Function(AudioAttachment value)? audio,
    TResult Function(FileAttachment value)? file,
    TResult Function(ChunkAttachment value)? chunk,
    required TResult orElse(),
  }) {
    if (chunk != null) {
      return chunk(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ChunkAttachmentImplToJson(
      this,
    );
  }
}

abstract class ChunkAttachment extends Attachment {
  const factory ChunkAttachment(
      {required final String text,
      final String? sourceName}) = _$ChunkAttachmentImpl;
  const ChunkAttachment._() : super._();

  factory ChunkAttachment.fromJson(Map<String, dynamic> json) =
      _$ChunkAttachmentImpl.fromJson;

  String get text;
  String? get sourceName;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChunkAttachmentImplCopyWith<_$ChunkAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnifiedMessage _$UnifiedMessageFromJson(Map<String, dynamic> json) {
  return _UnifiedMessage.fromJson(json);
}

/// @nodoc
mixin _$UnifiedMessage {
  String get id => throw _privateConstructorUsedError;
  MessageRole get role => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<Attachment> get attachments => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UnifiedMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnifiedMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnifiedMessageCopyWith<UnifiedMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedMessageCopyWith<$Res> {
  factory $UnifiedMessageCopyWith(
          UnifiedMessage value, $Res Function(UnifiedMessage) then) =
      _$UnifiedMessageCopyWithImpl<$Res, UnifiedMessage>;
  @useResult
  $Res call(
      {String id,
      MessageRole role,
      String? text,
      List<Attachment> attachments,
      Map<String, dynamic> metadata,
      bool isEdited,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UnifiedMessageCopyWithImpl<$Res, $Val extends UnifiedMessage>
    implements $UnifiedMessageCopyWith<$Res> {
  _$UnifiedMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnifiedMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = freezed,
    Object? attachments = null,
    Object? metadata = null,
    Object? isEdited = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedMessageImplCopyWith<$Res>
    implements $UnifiedMessageCopyWith<$Res> {
  factory _$$UnifiedMessageImplCopyWith(_$UnifiedMessageImpl value,
          $Res Function(_$UnifiedMessageImpl) then) =
      __$$UnifiedMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MessageRole role,
      String? text,
      List<Attachment> attachments,
      Map<String, dynamic> metadata,
      bool isEdited,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UnifiedMessageImplCopyWithImpl<$Res>
    extends _$UnifiedMessageCopyWithImpl<$Res, _$UnifiedMessageImpl>
    implements _$$UnifiedMessageImplCopyWith<$Res> {
  __$$UnifiedMessageImplCopyWithImpl(
      _$UnifiedMessageImpl _value, $Res Function(_$UnifiedMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of UnifiedMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = freezed,
    Object? attachments = null,
    Object? metadata = null,
    Object? isEdited = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UnifiedMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedMessageImpl extends _UnifiedMessage {
  const _$UnifiedMessageImpl(
      {required this.id,
      required this.role,
      this.text,
      final List<Attachment> attachments = const <Attachment>[],
      final Map<String, dynamic> metadata = const {},
      this.isEdited = false,
      required this.createdAt,
      this.updatedAt})
      : _attachments = attachments,
        _metadata = metadata,
        super._();

  factory _$UnifiedMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedMessageImplFromJson(json);

  @override
  final String id;
  @override
  final MessageRole role;
  @override
  final String? text;
  final List<Attachment> _attachments;
  @override
  @JsonKey()
  List<Attachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @JsonKey()
  final bool isEdited;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UnifiedMessage(id: $id, role: $role, text: $text, attachments: $attachments, metadata: $metadata, isEdited: $isEdited, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      role,
      text,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_metadata),
      isEdited,
      createdAt,
      updatedAt);

  /// Create a copy of UnifiedMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedMessageImplCopyWith<_$UnifiedMessageImpl> get copyWith =>
      __$$UnifiedMessageImplCopyWithImpl<_$UnifiedMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedMessageImplToJson(
      this,
    );
  }
}

abstract class _UnifiedMessage extends UnifiedMessage {
  const factory _UnifiedMessage(
      {required final String id,
      required final MessageRole role,
      final String? text,
      final List<Attachment> attachments,
      final Map<String, dynamic> metadata,
      final bool isEdited,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$UnifiedMessageImpl;
  const _UnifiedMessage._() : super._();

  factory _UnifiedMessage.fromJson(Map<String, dynamic> json) =
      _$UnifiedMessageImpl.fromJson;

  @override
  String get id;
  @override
  MessageRole get role;
  @override
  String? get text;
  @override
  List<Attachment> get attachments;
  @override
  Map<String, dynamic> get metadata;
  @override
  bool get isEdited;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UnifiedMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnifiedMessageImplCopyWith<_$UnifiedMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Session _$SessionFromJson(Map<String, dynamic> json) {
  return _Session.fromJson(json);
}

/// @nodoc
mixin _$Session {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<UnifiedMessage> get messages =>
      throw _privateConstructorUsedError; // Optional per-session config surface
  Map<String, dynamic> get config => throw _privateConstructorUsedError;

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      DateTime createdAt,
      DateTime? updatedAt,
      List<UnifiedMessage> messages,
      Map<String, dynamic> config});
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? messages = null,
    Object? config = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<UnifiedMessage>,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      DateTime createdAt,
      DateTime? updatedAt,
      List<UnifiedMessage> messages,
      Map<String, dynamic> config});
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? messages = null,
    Object? config = null,
  }) {
    return _then(_$SessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<UnifiedMessage>,
      config: null == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionImpl extends _Session {
  const _$SessionImpl(
      {required this.id,
      this.title = 'New Chat',
      this.description,
      required this.createdAt,
      this.updatedAt,
      final List<UnifiedMessage> messages = const <UnifiedMessage>[],
      final Map<String, dynamic> config = const {}})
      : _messages = messages,
        _config = config,
        super._();

  factory _$SessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String title;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<UnifiedMessage> _messages;
  @override
  @JsonKey()
  List<UnifiedMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

// Optional per-session config surface
  final Map<String, dynamic> _config;
// Optional per-session config surface
  @override
  @JsonKey()
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  @override
  String toString() {
    return 'Session(id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, messages: $messages, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_config));

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionImplToJson(
      this,
    );
  }
}

abstract class _Session extends Session {
  const factory _Session(
      {required final String id,
      final String title,
      final String? description,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final List<UnifiedMessage> messages,
      final Map<String, dynamic> config}) = _$SessionImpl;
  const _Session._() : super._();

  factory _Session.fromJson(Map<String, dynamic> json) = _$SessionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<UnifiedMessage> get messages; // Optional per-session config surface
  @override
  Map<String, dynamic> get config;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
