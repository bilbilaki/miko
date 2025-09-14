// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadTask {

 String get id; String get url; Map<String, String> get urlQueryParameters; String get filename; Map<String, String> get headers; String get directory; Updates get updates; bool get requiresWiFi; int get retries; bool get allowPause; String? get metaData; DateTime? get createdAt;
/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadTaskCopyWith<DownloadTask> get copyWith => _$DownloadTaskCopyWithImpl<DownloadTask>(this as DownloadTask, _$identity);

  /// Serializes this DownloadTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadTask&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.urlQueryParameters, urlQueryParameters)&&(identical(other.filename, filename) || other.filename == filename)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.directory, directory) || other.directory == directory)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.requiresWiFi, requiresWiFi) || other.requiresWiFi == requiresWiFi)&&(identical(other.retries, retries) || other.retries == retries)&&(identical(other.allowPause, allowPause) || other.allowPause == allowPause)&&(identical(other.metaData, metaData) || other.metaData == metaData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,const DeepCollectionEquality().hash(urlQueryParameters),filename,const DeepCollectionEquality().hash(headers),directory,updates,requiresWiFi,retries,allowPause,metaData,createdAt);



}

/// @nodoc
abstract mixin class $DownloadTaskCopyWith<$Res>  {
  factory $DownloadTaskCopyWith(DownloadTask value, $Res Function(DownloadTask) _then) = _$DownloadTaskCopyWithImpl;
@useResult
$Res call({
 String id, String url, Map<String, String> urlQueryParameters, String filename, Map<String, String> headers, String directory, Updates updates, bool requiresWiFi, int retries, bool allowPause, String? metaData, DateTime? createdAt
});




}
/// @nodoc
class _$DownloadTaskCopyWithImpl<$Res>
    implements $DownloadTaskCopyWith<$Res> {
  _$DownloadTaskCopyWithImpl(this._self, this._then);

  final DownloadTask _self;
  final $Res Function(DownloadTask) _then;

/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? urlQueryParameters = null,Object? filename = null,Object? headers = null,Object? directory = null,Object? updates = null,Object? requiresWiFi = null,Object? retries = null,Object? allowPause = null,Object? metaData = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,urlQueryParameters: null == urlQueryParameters ? _self.urlQueryParameters : urlQueryParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,directory: null == directory ? _self.directory : directory // ignore: cast_nullable_to_non_nullable
as String,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as Updates,requiresWiFi: null == requiresWiFi ? _self.requiresWiFi : requiresWiFi // ignore: cast_nullable_to_non_nullable
as bool,retries: null == retries ? _self.retries : retries // ignore: cast_nullable_to_non_nullable
as int,allowPause: null == allowPause ? _self.allowPause : allowPause // ignore: cast_nullable_to_non_nullable
as bool,metaData: freezed == metaData ? _self.metaData : metaData // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadTask].
extension DownloadTaskPatterns on DownloadTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadTask value)  $default,){
final _that = this;
switch (_that) {
case _DownloadTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadTask value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  Map<String, String> urlQueryParameters,  String filename,  Map<String, String> headers,  String directory,  Updates updates,  bool requiresWiFi,  int retries,  bool allowPause,  String? metaData,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
return $default(_that.id,_that.url,_that.urlQueryParameters,_that.filename,_that.headers,_that.directory,_that.updates,_that.requiresWiFi,_that.retries,_that.allowPause,_that.metaData,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  Map<String, String> urlQueryParameters,  String filename,  Map<String, String> headers,  String directory,  Updates updates,  bool requiresWiFi,  int retries,  bool allowPause,  String? metaData,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DownloadTask():
return $default(_that.id,_that.url,_that.urlQueryParameters,_that.filename,_that.headers,_that.directory,_that.updates,_that.requiresWiFi,_that.retries,_that.allowPause,_that.metaData,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  Map<String, String> urlQueryParameters,  String filename,  Map<String, String> headers,  String directory,  Updates updates,  bool requiresWiFi,  int retries,  bool allowPause,  String? metaData,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
return $default(_that.id,_that.url,_that.urlQueryParameters,_that.filename,_that.headers,_that.directory,_that.updates,_that.requiresWiFi,_that.retries,_that.allowPause,_that.metaData,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadTask extends DownloadTask {
  const _DownloadTask({this.id = '', required this.url, final  Map<String, String> urlQueryParameters = const <String, String>{}, this.filename = '', final  Map<String, String> headers = const <String, String>{}, this.directory = '', this.updates = Updates.statusAndProgress, this.requiresWiFi = false, this.retries = 0, this.allowPause = false, this.metaData, this.createdAt}): _urlQueryParameters = urlQueryParameters,_headers = headers,super._();
  factory _DownloadTask.fromJson(Map<String, dynamic> json) => _$DownloadTaskFromJson(json);

@override@JsonKey() final  String id;
@override final  String url;
 final  Map<String, String> _urlQueryParameters;
@override@JsonKey() Map<String, String> get urlQueryParameters {
  if (_urlQueryParameters is EqualUnmodifiableMapView) return _urlQueryParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_urlQueryParameters);
}

@override@JsonKey() final  String filename;
 final  Map<String, String> _headers;
@override@JsonKey() Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

@override@JsonKey() final  String directory;
@override@JsonKey() final  Updates updates;
@override@JsonKey() final  bool requiresWiFi;
@override@JsonKey() final  int retries;
@override@JsonKey() final  bool allowPause;
@override final  String? metaData;
@override final  DateTime? createdAt;

/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadTaskCopyWith<_DownloadTask> get copyWith => __$DownloadTaskCopyWithImpl<_DownloadTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadTask&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._urlQueryParameters, _urlQueryParameters)&&(identical(other.filename, filename) || other.filename == filename)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.directory, directory) || other.directory == directory)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.requiresWiFi, requiresWiFi) || other.requiresWiFi == requiresWiFi)&&(identical(other.retries, retries) || other.retries == retries)&&(identical(other.allowPause, allowPause) || other.allowPause == allowPause)&&(identical(other.metaData, metaData) || other.metaData == metaData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,const DeepCollectionEquality().hash(_urlQueryParameters),filename,const DeepCollectionEquality().hash(_headers),directory,updates,requiresWiFi,retries,allowPause,metaData,createdAt);



}

/// @nodoc
abstract mixin class _$DownloadTaskCopyWith<$Res> implements $DownloadTaskCopyWith<$Res> {
  factory _$DownloadTaskCopyWith(_DownloadTask value, $Res Function(_DownloadTask) _then) = __$DownloadTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, Map<String, String> urlQueryParameters, String filename, Map<String, String> headers, String directory, Updates updates, bool requiresWiFi, int retries, bool allowPause, String? metaData, DateTime? createdAt
});




}
/// @nodoc
class __$DownloadTaskCopyWithImpl<$Res>
    implements _$DownloadTaskCopyWith<$Res> {
  __$DownloadTaskCopyWithImpl(this._self, this._then);

  final _DownloadTask _self;
  final $Res Function(_DownloadTask) _then;

/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? urlQueryParameters = null,Object? filename = null,Object? headers = null,Object? directory = null,Object? updates = null,Object? requiresWiFi = null,Object? retries = null,Object? allowPause = null,Object? metaData = freezed,Object? createdAt = freezed,}) {
  return _then(_DownloadTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,urlQueryParameters: null == urlQueryParameters ? _self._urlQueryParameters : urlQueryParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,directory: null == directory ? _self.directory : directory // ignore: cast_nullable_to_non_nullable
as String,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as Updates,requiresWiFi: null == requiresWiFi ? _self.requiresWiFi : requiresWiFi // ignore: cast_nullable_to_non_nullable
as bool,retries: null == retries ? _self.retries : retries // ignore: cast_nullable_to_non_nullable
as int,allowPause: null == allowPause ? _self.allowPause : allowPause // ignore: cast_nullable_to_non_nullable
as bool,metaData: freezed == metaData ? _self.metaData : metaData // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DownloadResult {

 TaskStatus get status; double get progress; String? get filePath; String? get error; String? get taskId;
/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadResultCopyWith<DownloadResult> get copyWith => _$DownloadResultCopyWithImpl<DownloadResult>(this as DownloadResult, _$identity);

  /// Serializes this DownloadResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadResult&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.error, error) || other.error == error)&&(identical(other.taskId, taskId) || other.taskId == taskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,progress,filePath,error,taskId);



}

/// @nodoc
abstract mixin class $DownloadResultCopyWith<$Res>  {
  factory $DownloadResultCopyWith(DownloadResult value, $Res Function(DownloadResult) _then) = _$DownloadResultCopyWithImpl;
@useResult
$Res call({
 TaskStatus status, double progress, String? filePath, String? error, String? taskId
});




}
/// @nodoc
class _$DownloadResultCopyWithImpl<$Res>
    implements $DownloadResultCopyWith<$Res> {
  _$DownloadResultCopyWithImpl(this._self, this._then);

  final DownloadResult _self;
  final $Res Function(DownloadResult) _then;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? progress = null,Object? filePath = freezed,Object? error = freezed,Object? taskId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadResult].
extension DownloadResultPatterns on DownloadResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadResult value)  $default,){
final _that = this;
switch (_that) {
case _DownloadResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadResult value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskStatus status,  double progress,  String? filePath,  String? error,  String? taskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadResult() when $default != null:
return $default(_that.status,_that.progress,_that.filePath,_that.error,_that.taskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskStatus status,  double progress,  String? filePath,  String? error,  String? taskId)  $default,) {final _that = this;
switch (_that) {
case _DownloadResult():
return $default(_that.status,_that.progress,_that.filePath,_that.error,_that.taskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskStatus status,  double progress,  String? filePath,  String? error,  String? taskId)?  $default,) {final _that = this;
switch (_that) {
case _DownloadResult() when $default != null:
return $default(_that.status,_that.progress,_that.filePath,_that.error,_that.taskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadResult extends DownloadResult {
  const _DownloadResult({this.status = TaskStatus.queued, this.progress = 0.0, this.filePath, this.error, this.taskId}): super._();
  factory _DownloadResult.fromJson(Map<String, dynamic> json) => _$DownloadResultFromJson(json);

@override@JsonKey() final  TaskStatus status;
@override@JsonKey() final  double progress;
@override final  String? filePath;
@override final  String? error;
@override final  String? taskId;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadResultCopyWith<_DownloadResult> get copyWith => __$DownloadResultCopyWithImpl<_DownloadResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadResult&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.error, error) || other.error == error)&&(identical(other.taskId, taskId) || other.taskId == taskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,progress,filePath,error,taskId);



}

/// @nodoc
abstract mixin class _$DownloadResultCopyWith<$Res> implements $DownloadResultCopyWith<$Res> {
  factory _$DownloadResultCopyWith(_DownloadResult value, $Res Function(_DownloadResult) _then) = __$DownloadResultCopyWithImpl;
@override @useResult
$Res call({
 TaskStatus status, double progress, String? filePath, String? error, String? taskId
});




}
/// @nodoc
class __$DownloadResultCopyWithImpl<$Res>
    implements _$DownloadResultCopyWith<$Res> {
  __$DownloadResultCopyWithImpl(this._self, this._then);

  final _DownloadResult _self;
  final $Res Function(_DownloadResult) _then;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? progress = null,Object? filePath = freezed,Object? error = freezed,Object? taskId = freezed,}) {
  return _then(_DownloadResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
