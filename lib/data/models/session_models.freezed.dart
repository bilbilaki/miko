// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionEvent _$SessionEventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'userMessage':
      return UserMessageEvent.fromJson(json);
    case 'aiResponse':
      return AiResponseMessageEvent.fromJson(json);
    case 'fileAttachment':
      return FileAttachmentEvent.fromJson(json);
    case 'toolCall':
      return ToolCallEvent.fromJson(json);
    case 'toolResult':
      return ToolResultEvent.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'SessionEvent',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$SessionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) userMessage,
    required TResult Function(String markdownText, bool isError) aiResponse,
    required TResult Function(String fileName, String filePath) fileAttachment,
    required TResult Function(String toolName, Map<String, dynamic> args)
        toolCall,
    required TResult Function(String toolName, String result) toolResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? userMessage,
    TResult? Function(String markdownText, bool isError)? aiResponse,
    TResult? Function(String fileName, String filePath)? fileAttachment,
    TResult? Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult? Function(String toolName, String result)? toolResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? userMessage,
    TResult Function(String markdownText, bool isError)? aiResponse,
    TResult Function(String fileName, String filePath)? fileAttachment,
    TResult Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult Function(String toolName, String result)? toolResult,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserMessageEvent value) userMessage,
    required TResult Function(AiResponseMessageEvent value) aiResponse,
    required TResult Function(FileAttachmentEvent value) fileAttachment,
    required TResult Function(ToolCallEvent value) toolCall,
    required TResult Function(ToolResultEvent value) toolResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserMessageEvent value)? userMessage,
    TResult? Function(AiResponseMessageEvent value)? aiResponse,
    TResult? Function(FileAttachmentEvent value)? fileAttachment,
    TResult? Function(ToolCallEvent value)? toolCall,
    TResult? Function(ToolResultEvent value)? toolResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserMessageEvent value)? userMessage,
    TResult Function(AiResponseMessageEvent value)? aiResponse,
    TResult Function(FileAttachmentEvent value)? fileAttachment,
    TResult Function(ToolCallEvent value)? toolCall,
    TResult Function(ToolResultEvent value)? toolResult,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SessionEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionEventCopyWith<$Res> {
  factory $SessionEventCopyWith(
          SessionEvent value, $Res Function(SessionEvent) then) =
      _$SessionEventCopyWithImpl<$Res, SessionEvent>;
}

/// @nodoc
class _$SessionEventCopyWithImpl<$Res, $Val extends SessionEvent>
    implements $SessionEventCopyWith<$Res> {
  _$SessionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserMessageEventImplCopyWith<$Res> {
  factory _$$UserMessageEventImplCopyWith(_$UserMessageEventImpl value,
          $Res Function(_$UserMessageEventImpl) then) =
      __$$UserMessageEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$UserMessageEventImplCopyWithImpl<$Res>
    extends _$SessionEventCopyWithImpl<$Res, _$UserMessageEventImpl>
    implements _$$UserMessageEventImplCopyWith<$Res> {
  __$$UserMessageEventImplCopyWithImpl(_$UserMessageEventImpl _value,
      $Res Function(_$UserMessageEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_$UserMessageEventImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMessageEventImpl implements UserMessageEvent {
  const _$UserMessageEventImpl({required this.text, final String? $type})
      : $type = $type ?? 'userMessage';

  factory _$UserMessageEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMessageEventImplFromJson(json);

  @override
  final String text;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SessionEvent.userMessage(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMessageEventImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMessageEventImplCopyWith<_$UserMessageEventImpl> get copyWith =>
      __$$UserMessageEventImplCopyWithImpl<_$UserMessageEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) userMessage,
    required TResult Function(String markdownText, bool isError) aiResponse,
    required TResult Function(String fileName, String filePath) fileAttachment,
    required TResult Function(String toolName, Map<String, dynamic> args)
        toolCall,
    required TResult Function(String toolName, String result) toolResult,
  }) {
    return userMessage(text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? userMessage,
    TResult? Function(String markdownText, bool isError)? aiResponse,
    TResult? Function(String fileName, String filePath)? fileAttachment,
    TResult? Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult? Function(String toolName, String result)? toolResult,
  }) {
    return userMessage?.call(text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? userMessage,
    TResult Function(String markdownText, bool isError)? aiResponse,
    TResult Function(String fileName, String filePath)? fileAttachment,
    TResult Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult Function(String toolName, String result)? toolResult,
    required TResult orElse(),
  }) {
    if (userMessage != null) {
      return userMessage(text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserMessageEvent value) userMessage,
    required TResult Function(AiResponseMessageEvent value) aiResponse,
    required TResult Function(FileAttachmentEvent value) fileAttachment,
    required TResult Function(ToolCallEvent value) toolCall,
    required TResult Function(ToolResultEvent value) toolResult,
  }) {
    return userMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserMessageEvent value)? userMessage,
    TResult? Function(AiResponseMessageEvent value)? aiResponse,
    TResult? Function(FileAttachmentEvent value)? fileAttachment,
    TResult? Function(ToolCallEvent value)? toolCall,
    TResult? Function(ToolResultEvent value)? toolResult,
  }) {
    return userMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserMessageEvent value)? userMessage,
    TResult Function(AiResponseMessageEvent value)? aiResponse,
    TResult Function(FileAttachmentEvent value)? fileAttachment,
    TResult Function(ToolCallEvent value)? toolCall,
    TResult Function(ToolResultEvent value)? toolResult,
    required TResult orElse(),
  }) {
    if (userMessage != null) {
      return userMessage(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMessageEventImplToJson(
      this,
    );
  }
}

abstract class UserMessageEvent implements SessionEvent {
  const factory UserMessageEvent({required final String text}) =
      _$UserMessageEventImpl;

  factory UserMessageEvent.fromJson(Map<String, dynamic> json) =
      _$UserMessageEventImpl.fromJson;

  String get text;

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserMessageEventImplCopyWith<_$UserMessageEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AiResponseMessageEventImplCopyWith<$Res> {
  factory _$$AiResponseMessageEventImplCopyWith(
          _$AiResponseMessageEventImpl value,
          $Res Function(_$AiResponseMessageEventImpl) then) =
      __$$AiResponseMessageEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String markdownText, bool isError});
}

/// @nodoc
class __$$AiResponseMessageEventImplCopyWithImpl<$Res>
    extends _$SessionEventCopyWithImpl<$Res, _$AiResponseMessageEventImpl>
    implements _$$AiResponseMessageEventImplCopyWith<$Res> {
  __$$AiResponseMessageEventImplCopyWithImpl(
      _$AiResponseMessageEventImpl _value,
      $Res Function(_$AiResponseMessageEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markdownText = null,
    Object? isError = null,
  }) {
    return _then(_$AiResponseMessageEventImpl(
      markdownText: null == markdownText
          ? _value.markdownText
          : markdownText // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiResponseMessageEventImpl implements AiResponseMessageEvent {
  const _$AiResponseMessageEventImpl(
      {required this.markdownText, this.isError = false, final String? $type})
      : $type = $type ?? 'aiResponse';

  factory _$AiResponseMessageEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiResponseMessageEventImplFromJson(json);

  @override
  final String markdownText;
  @override
  @JsonKey()
  final bool isError;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SessionEvent.aiResponse(markdownText: $markdownText, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiResponseMessageEventImpl &&
            (identical(other.markdownText, markdownText) ||
                other.markdownText == markdownText) &&
            (identical(other.isError, isError) || other.isError == isError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, markdownText, isError);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiResponseMessageEventImplCopyWith<_$AiResponseMessageEventImpl>
      get copyWith => __$$AiResponseMessageEventImplCopyWithImpl<
          _$AiResponseMessageEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) userMessage,
    required TResult Function(String markdownText, bool isError) aiResponse,
    required TResult Function(String fileName, String filePath) fileAttachment,
    required TResult Function(String toolName, Map<String, dynamic> args)
        toolCall,
    required TResult Function(String toolName, String result) toolResult,
  }) {
    return aiResponse(markdownText, isError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? userMessage,
    TResult? Function(String markdownText, bool isError)? aiResponse,
    TResult? Function(String fileName, String filePath)? fileAttachment,
    TResult? Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult? Function(String toolName, String result)? toolResult,
  }) {
    return aiResponse?.call(markdownText, isError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? userMessage,
    TResult Function(String markdownText, bool isError)? aiResponse,
    TResult Function(String fileName, String filePath)? fileAttachment,
    TResult Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult Function(String toolName, String result)? toolResult,
    required TResult orElse(),
  }) {
    if (aiResponse != null) {
      return aiResponse(markdownText, isError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserMessageEvent value) userMessage,
    required TResult Function(AiResponseMessageEvent value) aiResponse,
    required TResult Function(FileAttachmentEvent value) fileAttachment,
    required TResult Function(ToolCallEvent value) toolCall,
    required TResult Function(ToolResultEvent value) toolResult,
  }) {
    return aiResponse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserMessageEvent value)? userMessage,
    TResult? Function(AiResponseMessageEvent value)? aiResponse,
    TResult? Function(FileAttachmentEvent value)? fileAttachment,
    TResult? Function(ToolCallEvent value)? toolCall,
    TResult? Function(ToolResultEvent value)? toolResult,
  }) {
    return aiResponse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserMessageEvent value)? userMessage,
    TResult Function(AiResponseMessageEvent value)? aiResponse,
    TResult Function(FileAttachmentEvent value)? fileAttachment,
    TResult Function(ToolCallEvent value)? toolCall,
    TResult Function(ToolResultEvent value)? toolResult,
    required TResult orElse(),
  }) {
    if (aiResponse != null) {
      return aiResponse(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AiResponseMessageEventImplToJson(
      this,
    );
  }
}

abstract class AiResponseMessageEvent implements SessionEvent {
  const factory AiResponseMessageEvent(
      {required final String markdownText,
      final bool isError}) = _$AiResponseMessageEventImpl;

  factory AiResponseMessageEvent.fromJson(Map<String, dynamic> json) =
      _$AiResponseMessageEventImpl.fromJson;

  String get markdownText;
  bool get isError;

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiResponseMessageEventImplCopyWith<_$AiResponseMessageEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileAttachmentEventImplCopyWith<$Res> {
  factory _$$FileAttachmentEventImplCopyWith(_$FileAttachmentEventImpl value,
          $Res Function(_$FileAttachmentEventImpl) then) =
      __$$FileAttachmentEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileName, String filePath});
}

/// @nodoc
class __$$FileAttachmentEventImplCopyWithImpl<$Res>
    extends _$SessionEventCopyWithImpl<$Res, _$FileAttachmentEventImpl>
    implements _$$FileAttachmentEventImplCopyWith<$Res> {
  __$$FileAttachmentEventImplCopyWithImpl(_$FileAttachmentEventImpl _value,
      $Res Function(_$FileAttachmentEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? filePath = null,
  }) {
    return _then(_$FileAttachmentEventImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileAttachmentEventImpl implements FileAttachmentEvent {
  const _$FileAttachmentEventImpl(
      {required this.fileName, required this.filePath, final String? $type})
      : $type = $type ?? 'fileAttachment';

  factory _$FileAttachmentEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileAttachmentEventImplFromJson(json);

  @override
  final String fileName;
  @override
  final String filePath;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SessionEvent.fileAttachment(fileName: $fileName, filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileAttachmentEventImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileName, filePath);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileAttachmentEventImplCopyWith<_$FileAttachmentEventImpl> get copyWith =>
      __$$FileAttachmentEventImplCopyWithImpl<_$FileAttachmentEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) userMessage,
    required TResult Function(String markdownText, bool isError) aiResponse,
    required TResult Function(String fileName, String filePath) fileAttachment,
    required TResult Function(String toolName, Map<String, dynamic> args)
        toolCall,
    required TResult Function(String toolName, String result) toolResult,
  }) {
    return fileAttachment(fileName, filePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? userMessage,
    TResult? Function(String markdownText, bool isError)? aiResponse,
    TResult? Function(String fileName, String filePath)? fileAttachment,
    TResult? Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult? Function(String toolName, String result)? toolResult,
  }) {
    return fileAttachment?.call(fileName, filePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? userMessage,
    TResult Function(String markdownText, bool isError)? aiResponse,
    TResult Function(String fileName, String filePath)? fileAttachment,
    TResult Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult Function(String toolName, String result)? toolResult,
    required TResult orElse(),
  }) {
    if (fileAttachment != null) {
      return fileAttachment(fileName, filePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserMessageEvent value) userMessage,
    required TResult Function(AiResponseMessageEvent value) aiResponse,
    required TResult Function(FileAttachmentEvent value) fileAttachment,
    required TResult Function(ToolCallEvent value) toolCall,
    required TResult Function(ToolResultEvent value) toolResult,
  }) {
    return fileAttachment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserMessageEvent value)? userMessage,
    TResult? Function(AiResponseMessageEvent value)? aiResponse,
    TResult? Function(FileAttachmentEvent value)? fileAttachment,
    TResult? Function(ToolCallEvent value)? toolCall,
    TResult? Function(ToolResultEvent value)? toolResult,
  }) {
    return fileAttachment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserMessageEvent value)? userMessage,
    TResult Function(AiResponseMessageEvent value)? aiResponse,
    TResult Function(FileAttachmentEvent value)? fileAttachment,
    TResult Function(ToolCallEvent value)? toolCall,
    TResult Function(ToolResultEvent value)? toolResult,
    required TResult orElse(),
  }) {
    if (fileAttachment != null) {
      return fileAttachment(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FileAttachmentEventImplToJson(
      this,
    );
  }
}

abstract class FileAttachmentEvent implements SessionEvent {
  const factory FileAttachmentEvent(
      {required final String fileName,
      required final String filePath}) = _$FileAttachmentEventImpl;

  factory FileAttachmentEvent.fromJson(Map<String, dynamic> json) =
      _$FileAttachmentEventImpl.fromJson;

  String get fileName;
  String get filePath;

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileAttachmentEventImplCopyWith<_$FileAttachmentEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToolCallEventImplCopyWith<$Res> {
  factory _$$ToolCallEventImplCopyWith(
          _$ToolCallEventImpl value, $Res Function(_$ToolCallEventImpl) then) =
      __$$ToolCallEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String toolName, Map<String, dynamic> args});
}

/// @nodoc
class __$$ToolCallEventImplCopyWithImpl<$Res>
    extends _$SessionEventCopyWithImpl<$Res, _$ToolCallEventImpl>
    implements _$$ToolCallEventImplCopyWith<$Res> {
  __$$ToolCallEventImplCopyWithImpl(
      _$ToolCallEventImpl _value, $Res Function(_$ToolCallEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolName = null,
    Object? args = null,
  }) {
    return _then(_$ToolCallEventImpl(
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      args: null == args
          ? _value._args
          : args // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolCallEventImpl implements ToolCallEvent {
  const _$ToolCallEventImpl(
      {required this.toolName,
      required final Map<String, dynamic> args,
      final String? $type})
      : _args = args,
        $type = $type ?? 'toolCall';

  factory _$ToolCallEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolCallEventImplFromJson(json);

  @override
  final String toolName;
  final Map<String, dynamic> _args;
  @override
  Map<String, dynamic> get args {
    if (_args is EqualUnmodifiableMapView) return _args;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_args);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SessionEvent.toolCall(toolName: $toolName, args: $args)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolCallEventImpl &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            const DeepCollectionEquality().equals(other._args, _args));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, toolName, const DeepCollectionEquality().hash(_args));

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolCallEventImplCopyWith<_$ToolCallEventImpl> get copyWith =>
      __$$ToolCallEventImplCopyWithImpl<_$ToolCallEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) userMessage,
    required TResult Function(String markdownText, bool isError) aiResponse,
    required TResult Function(String fileName, String filePath) fileAttachment,
    required TResult Function(String toolName, Map<String, dynamic> args)
        toolCall,
    required TResult Function(String toolName, String result) toolResult,
  }) {
    return toolCall(toolName, args);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? userMessage,
    TResult? Function(String markdownText, bool isError)? aiResponse,
    TResult? Function(String fileName, String filePath)? fileAttachment,
    TResult? Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult? Function(String toolName, String result)? toolResult,
  }) {
    return toolCall?.call(toolName, args);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? userMessage,
    TResult Function(String markdownText, bool isError)? aiResponse,
    TResult Function(String fileName, String filePath)? fileAttachment,
    TResult Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult Function(String toolName, String result)? toolResult,
    required TResult orElse(),
  }) {
    if (toolCall != null) {
      return toolCall(toolName, args);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserMessageEvent value) userMessage,
    required TResult Function(AiResponseMessageEvent value) aiResponse,
    required TResult Function(FileAttachmentEvent value) fileAttachment,
    required TResult Function(ToolCallEvent value) toolCall,
    required TResult Function(ToolResultEvent value) toolResult,
  }) {
    return toolCall(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserMessageEvent value)? userMessage,
    TResult? Function(AiResponseMessageEvent value)? aiResponse,
    TResult? Function(FileAttachmentEvent value)? fileAttachment,
    TResult? Function(ToolCallEvent value)? toolCall,
    TResult? Function(ToolResultEvent value)? toolResult,
  }) {
    return toolCall?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserMessageEvent value)? userMessage,
    TResult Function(AiResponseMessageEvent value)? aiResponse,
    TResult Function(FileAttachmentEvent value)? fileAttachment,
    TResult Function(ToolCallEvent value)? toolCall,
    TResult Function(ToolResultEvent value)? toolResult,
    required TResult orElse(),
  }) {
    if (toolCall != null) {
      return toolCall(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolCallEventImplToJson(
      this,
    );
  }
}

abstract class ToolCallEvent implements SessionEvent {
  const factory ToolCallEvent(
      {required final String toolName,
      required final Map<String, dynamic> args}) = _$ToolCallEventImpl;

  factory ToolCallEvent.fromJson(Map<String, dynamic> json) =
      _$ToolCallEventImpl.fromJson;

  String get toolName;
  Map<String, dynamic> get args;

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToolCallEventImplCopyWith<_$ToolCallEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToolResultEventImplCopyWith<$Res> {
  factory _$$ToolResultEventImplCopyWith(_$ToolResultEventImpl value,
          $Res Function(_$ToolResultEventImpl) then) =
      __$$ToolResultEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String toolName, String result});
}

/// @nodoc
class __$$ToolResultEventImplCopyWithImpl<$Res>
    extends _$SessionEventCopyWithImpl<$Res, _$ToolResultEventImpl>
    implements _$$ToolResultEventImplCopyWith<$Res> {
  __$$ToolResultEventImplCopyWithImpl(
      _$ToolResultEventImpl _value, $Res Function(_$ToolResultEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolName = null,
    Object? result = null,
  }) {
    return _then(_$ToolResultEventImpl(
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolResultEventImpl implements ToolResultEvent {
  const _$ToolResultEventImpl(
      {required this.toolName, required this.result, final String? $type})
      : $type = $type ?? 'toolResult';

  factory _$ToolResultEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolResultEventImplFromJson(json);

  @override
  final String toolName;
  @override
  final String result;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SessionEvent.toolResult(toolName: $toolName, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolResultEventImpl &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, toolName, result);

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolResultEventImplCopyWith<_$ToolResultEventImpl> get copyWith =>
      __$$ToolResultEventImplCopyWithImpl<_$ToolResultEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) userMessage,
    required TResult Function(String markdownText, bool isError) aiResponse,
    required TResult Function(String fileName, String filePath) fileAttachment,
    required TResult Function(String toolName, Map<String, dynamic> args)
        toolCall,
    required TResult Function(String toolName, String result) toolResult,
  }) {
    return toolResult(toolName, result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? userMessage,
    TResult? Function(String markdownText, bool isError)? aiResponse,
    TResult? Function(String fileName, String filePath)? fileAttachment,
    TResult? Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult? Function(String toolName, String result)? toolResult,
  }) {
    return toolResult?.call(toolName, result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? userMessage,
    TResult Function(String markdownText, bool isError)? aiResponse,
    TResult Function(String fileName, String filePath)? fileAttachment,
    TResult Function(String toolName, Map<String, dynamic> args)? toolCall,
    TResult Function(String toolName, String result)? toolResult,
    required TResult orElse(),
  }) {
    if (toolResult != null) {
      return toolResult(toolName, result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserMessageEvent value) userMessage,
    required TResult Function(AiResponseMessageEvent value) aiResponse,
    required TResult Function(FileAttachmentEvent value) fileAttachment,
    required TResult Function(ToolCallEvent value) toolCall,
    required TResult Function(ToolResultEvent value) toolResult,
  }) {
    return toolResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserMessageEvent value)? userMessage,
    TResult? Function(AiResponseMessageEvent value)? aiResponse,
    TResult? Function(FileAttachmentEvent value)? fileAttachment,
    TResult? Function(ToolCallEvent value)? toolCall,
    TResult? Function(ToolResultEvent value)? toolResult,
  }) {
    return toolResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserMessageEvent value)? userMessage,
    TResult Function(AiResponseMessageEvent value)? aiResponse,
    TResult Function(FileAttachmentEvent value)? fileAttachment,
    TResult Function(ToolCallEvent value)? toolCall,
    TResult Function(ToolResultEvent value)? toolResult,
    required TResult orElse(),
  }) {
    if (toolResult != null) {
      return toolResult(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolResultEventImplToJson(
      this,
    );
  }
}

abstract class ToolResultEvent implements SessionEvent {
  const factory ToolResultEvent(
      {required final String toolName,
      required final String result}) = _$ToolResultEventImpl;

  factory ToolResultEvent.fromJson(Map<String, dynamic> json) =
      _$ToolResultEventImpl.fromJson;

  String get toolName;
  String get result;

  /// Create a copy of SessionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToolResultEventImplCopyWith<_$ToolResultEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionState _$SessionStateFromJson(Map<String, dynamic> json) {
  return _SessionState.fromJson(json);
}

/// @nodoc
mixin _$SessionState {
  String get sessionId => throw _privateConstructorUsedError;
  String get associatedProjectId => throw _privateConstructorUsedError;
  List<SessionEvent> get displayHistory =>
      throw _privateConstructorUsedError; // Use the custom converter for JSON serialization/deserialization of chat history
  @ContentConverter()
  List<Content> get apiHistory => throw _privateConstructorUsedError;
  Map<String, String> get attachedFilePaths =>
      throw _privateConstructorUsedError; // Store paths, not bytes
  String get customKnowledge => throw _privateConstructorUsedError;

  /// Serializes this SessionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionStateCopyWith<SessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) then) =
      _$SessionStateCopyWithImpl<$Res, SessionState>;
  @useResult
  $Res call(
      {String sessionId,
      String associatedProjectId,
      List<SessionEvent> displayHistory,
      @ContentConverter() List<Content> apiHistory,
      Map<String, String> attachedFilePaths,
      String customKnowledge});
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? associatedProjectId = null,
    Object? displayHistory = null,
    Object? apiHistory = null,
    Object? attachedFilePaths = null,
    Object? customKnowledge = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      associatedProjectId: null == associatedProjectId
          ? _value.associatedProjectId
          : associatedProjectId // ignore: cast_nullable_to_non_nullable
              as String,
      displayHistory: null == displayHistory
          ? _value.displayHistory
          : displayHistory // ignore: cast_nullable_to_non_nullable
              as List<SessionEvent>,
      apiHistory: null == apiHistory
          ? _value.apiHistory
          : apiHistory // ignore: cast_nullable_to_non_nullable
              as List<Content>,
      attachedFilePaths: null == attachedFilePaths
          ? _value.attachedFilePaths
          : attachedFilePaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      customKnowledge: null == customKnowledge
          ? _value.customKnowledge
          : customKnowledge // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionStateImplCopyWith<$Res>
    implements $SessionStateCopyWith<$Res> {
  factory _$$SessionStateImplCopyWith(
          _$SessionStateImpl value, $Res Function(_$SessionStateImpl) then) =
      __$$SessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String associatedProjectId,
      List<SessionEvent> displayHistory,
      @ContentConverter() List<Content> apiHistory,
      Map<String, String> attachedFilePaths,
      String customKnowledge});
}

/// @nodoc
class __$$SessionStateImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateImpl>
    implements _$$SessionStateImplCopyWith<$Res> {
  __$$SessionStateImplCopyWithImpl(
      _$SessionStateImpl _value, $Res Function(_$SessionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? associatedProjectId = null,
    Object? displayHistory = null,
    Object? apiHistory = null,
    Object? attachedFilePaths = null,
    Object? customKnowledge = null,
  }) {
    return _then(_$SessionStateImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      associatedProjectId: null == associatedProjectId
          ? _value.associatedProjectId
          : associatedProjectId // ignore: cast_nullable_to_non_nullable
              as String,
      displayHistory: null == displayHistory
          ? _value._displayHistory
          : displayHistory // ignore: cast_nullable_to_non_nullable
              as List<SessionEvent>,
      apiHistory: null == apiHistory
          ? _value._apiHistory
          : apiHistory // ignore: cast_nullable_to_non_nullable
              as List<Content>,
      attachedFilePaths: null == attachedFilePaths
          ? _value._attachedFilePaths
          : attachedFilePaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      customKnowledge: null == customKnowledge
          ? _value.customKnowledge
          : customKnowledge // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionStateImpl implements _SessionState {
  const _$SessionStateImpl(
      {required this.sessionId,
      required this.associatedProjectId,
      required final List<SessionEvent> displayHistory,
      @ContentConverter() final List<Content> apiHistory = const [],
      final Map<String, String> attachedFilePaths = const {},
      this.customKnowledge = ''})
      : _displayHistory = displayHistory,
        _apiHistory = apiHistory,
        _attachedFilePaths = attachedFilePaths;

  factory _$SessionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionStateImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String associatedProjectId;
  final List<SessionEvent> _displayHistory;
  @override
  List<SessionEvent> get displayHistory {
    if (_displayHistory is EqualUnmodifiableListView) return _displayHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_displayHistory);
  }

// Use the custom converter for JSON serialization/deserialization of chat history
  final List<Content> _apiHistory;
// Use the custom converter for JSON serialization/deserialization of chat history
  @override
  @JsonKey()
  @ContentConverter()
  List<Content> get apiHistory {
    if (_apiHistory is EqualUnmodifiableListView) return _apiHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apiHistory);
  }

  final Map<String, String> _attachedFilePaths;
  @override
  @JsonKey()
  Map<String, String> get attachedFilePaths {
    if (_attachedFilePaths is EqualUnmodifiableMapView)
      return _attachedFilePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_attachedFilePaths);
  }

// Store paths, not bytes
  @override
  @JsonKey()
  final String customKnowledge;

  @override
  String toString() {
    return 'SessionState(sessionId: $sessionId, associatedProjectId: $associatedProjectId, displayHistory: $displayHistory, apiHistory: $apiHistory, attachedFilePaths: $attachedFilePaths, customKnowledge: $customKnowledge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.associatedProjectId, associatedProjectId) ||
                other.associatedProjectId == associatedProjectId) &&
            const DeepCollectionEquality()
                .equals(other._displayHistory, _displayHistory) &&
            const DeepCollectionEquality()
                .equals(other._apiHistory, _apiHistory) &&
            const DeepCollectionEquality()
                .equals(other._attachedFilePaths, _attachedFilePaths) &&
            (identical(other.customKnowledge, customKnowledge) ||
                other.customKnowledge == customKnowledge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      associatedProjectId,
      const DeepCollectionEquality().hash(_displayHistory),
      const DeepCollectionEquality().hash(_apiHistory),
      const DeepCollectionEquality().hash(_attachedFilePaths),
      customKnowledge);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionStateImplCopyWith<_$SessionStateImpl> get copyWith =>
      __$$SessionStateImplCopyWithImpl<_$SessionStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionStateImplToJson(
      this,
    );
  }
}

abstract class _SessionState implements SessionState {
  const factory _SessionState(
      {required final String sessionId,
      required final String associatedProjectId,
      required final List<SessionEvent> displayHistory,
      @ContentConverter() final List<Content> apiHistory,
      final Map<String, String> attachedFilePaths,
      final String customKnowledge}) = _$SessionStateImpl;

  factory _SessionState.fromJson(Map<String, dynamic> json) =
      _$SessionStateImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get associatedProjectId;
  @override
  List<SessionEvent>
      get displayHistory; // Use the custom converter for JSON serialization/deserialization of chat history
  @override
  @ContentConverter()
  List<Content> get apiHistory;
  @override
  Map<String, String> get attachedFilePaths; // Store paths, not bytes
  @override
  String get customKnowledge;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionStateImplCopyWith<_$SessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
