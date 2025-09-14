// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangeItem {

@HiveField(0) int get id;@HiveField(1)@JsonKey(name: 'adult') bool? get adult;@HiveField(2) String? get mediaType;@HiveField(3) String? get description;@HiveField(4)@JsonKey(name: 'original_title') String? get originalTitle;@HiveField(5)@JsonKey(name: 'original_name') String? get originalName;@HiveField(6)@JsonKey(name: 'title') String? get title;@HiveField(7)@JsonKey(name: 'name') String? get name;@HiveField(8)@JsonKey(name: 'profile_path') String? get profilePath;@HiveField(9)@JsonKey(name: 'change_type') String? get changeType;@HiveField(10)@JsonKey(name: 'changes') List<Object?>? get changes;
/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeItemCopyWith<ChangeItem> get copyWith => _$ChangeItemCopyWithImpl<ChangeItem>(this as ChangeItem, _$identity);

  /// Serializes this ChangeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.description, description) || other.description == description)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&const DeepCollectionEquality().equals(other.changes, changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,adult,mediaType,description,originalTitle,originalName,title,name,profilePath,changeType,const DeepCollectionEquality().hash(changes));

@override
String toString() {
  return 'ChangeItem(id: $id, adult: $adult, mediaType: $mediaType, description: $description, originalTitle: $originalTitle, originalName: $originalName, title: $title, name: $name, profilePath: $profilePath, changeType: $changeType, changes: $changes)';
}


}

/// @nodoc
abstract mixin class $ChangeItemCopyWith<$Res>  {
  factory $ChangeItemCopyWith(ChangeItem value, $Res Function(ChangeItem) _then) = _$ChangeItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'adult') bool? adult,@HiveField(2) String? mediaType,@HiveField(3) String? description,@HiveField(4)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(5)@JsonKey(name: 'original_name') String? originalName,@HiveField(6)@JsonKey(name: 'title') String? title,@HiveField(7)@JsonKey(name: 'name') String? name,@HiveField(8)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(9)@JsonKey(name: 'change_type') String? changeType,@HiveField(10)@JsonKey(name: 'changes') List<Object?>? changes
});




}
/// @nodoc
class _$ChangeItemCopyWithImpl<$Res>
    implements $ChangeItemCopyWith<$Res> {
  _$ChangeItemCopyWithImpl(this._self, this._then);

  final ChangeItem _self;
  final $Res Function(ChangeItem) _then;

/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? adult = freezed,Object? mediaType = freezed,Object? description = freezed,Object? originalTitle = freezed,Object? originalName = freezed,Object? title = freezed,Object? name = freezed,Object? profilePath = freezed,Object? changeType = freezed,Object? changes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,changeType: freezed == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String?,changes: freezed == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeItem].
extension ChangeItemPatterns on ChangeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeItem value)  $default,){
final _that = this;
switch (_that) {
case _ChangeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeItem value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'adult')  bool? adult, @HiveField(2)  String? mediaType, @HiveField(3)  String? description, @HiveField(4)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)@JsonKey(name: 'title')  String? title, @HiveField(7)@JsonKey(name: 'name')  String? name, @HiveField(8)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(9)@JsonKey(name: 'change_type')  String? changeType, @HiveField(10)@JsonKey(name: 'changes')  List<Object?>? changes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeItem() when $default != null:
return $default(_that.id,_that.adult,_that.mediaType,_that.description,_that.originalTitle,_that.originalName,_that.title,_that.name,_that.profilePath,_that.changeType,_that.changes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'adult')  bool? adult, @HiveField(2)  String? mediaType, @HiveField(3)  String? description, @HiveField(4)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)@JsonKey(name: 'title')  String? title, @HiveField(7)@JsonKey(name: 'name')  String? name, @HiveField(8)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(9)@JsonKey(name: 'change_type')  String? changeType, @HiveField(10)@JsonKey(name: 'changes')  List<Object?>? changes)  $default,) {final _that = this;
switch (_that) {
case _ChangeItem():
return $default(_that.id,_that.adult,_that.mediaType,_that.description,_that.originalTitle,_that.originalName,_that.title,_that.name,_that.profilePath,_that.changeType,_that.changes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)@JsonKey(name: 'adult')  bool? adult, @HiveField(2)  String? mediaType, @HiveField(3)  String? description, @HiveField(4)@JsonKey(name: 'original_title')  String? originalTitle, @HiveField(5)@JsonKey(name: 'original_name')  String? originalName, @HiveField(6)@JsonKey(name: 'title')  String? title, @HiveField(7)@JsonKey(name: 'name')  String? name, @HiveField(8)@JsonKey(name: 'profile_path')  String? profilePath, @HiveField(9)@JsonKey(name: 'change_type')  String? changeType, @HiveField(10)@JsonKey(name: 'changes')  List<Object?>? changes)?  $default,) {final _that = this;
switch (_that) {
case _ChangeItem() when $default != null:
return $default(_that.id,_that.adult,_that.mediaType,_that.description,_that.originalTitle,_that.originalName,_that.title,_that.name,_that.profilePath,_that.changeType,_that.changes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _ChangeItem implements ChangeItem {
  const _ChangeItem({@HiveField(0) required this.id, @HiveField(1)@JsonKey(name: 'adult') this.adult, @HiveField(2) this.mediaType, @HiveField(3) this.description, @HiveField(4)@JsonKey(name: 'original_title') this.originalTitle, @HiveField(5)@JsonKey(name: 'original_name') this.originalName, @HiveField(6)@JsonKey(name: 'title') this.title, @HiveField(7)@JsonKey(name: 'name') this.name, @HiveField(8)@JsonKey(name: 'profile_path') this.profilePath, @HiveField(9)@JsonKey(name: 'change_type') this.changeType, @HiveField(10)@JsonKey(name: 'changes') final  List<Object?>? changes}): _changes = changes;
  factory _ChangeItem.fromJson(Map<String, dynamic> json) => _$ChangeItemFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1)@JsonKey(name: 'adult') final  bool? adult;
@override@HiveField(2) final  String? mediaType;
@override@HiveField(3) final  String? description;
@override@HiveField(4)@JsonKey(name: 'original_title') final  String? originalTitle;
@override@HiveField(5)@JsonKey(name: 'original_name') final  String? originalName;
@override@HiveField(6)@JsonKey(name: 'title') final  String? title;
@override@HiveField(7)@JsonKey(name: 'name') final  String? name;
@override@HiveField(8)@JsonKey(name: 'profile_path') final  String? profilePath;
@override@HiveField(9)@JsonKey(name: 'change_type') final  String? changeType;
 final  List<Object?>? _changes;
@override@HiveField(10)@JsonKey(name: 'changes') List<Object?>? get changes {
  final value = _changes;
  if (value == null) return null;
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeItemCopyWith<_ChangeItem> get copyWith => __$ChangeItemCopyWithImpl<_ChangeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.description, description) || other.description == description)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&const DeepCollectionEquality().equals(other._changes, _changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,adult,mediaType,description,originalTitle,originalName,title,name,profilePath,changeType,const DeepCollectionEquality().hash(_changes));

@override
String toString() {
  return 'ChangeItem(id: $id, adult: $adult, mediaType: $mediaType, description: $description, originalTitle: $originalTitle, originalName: $originalName, title: $title, name: $name, profilePath: $profilePath, changeType: $changeType, changes: $changes)';
}


}

/// @nodoc
abstract mixin class _$ChangeItemCopyWith<$Res> implements $ChangeItemCopyWith<$Res> {
  factory _$ChangeItemCopyWith(_ChangeItem value, $Res Function(_ChangeItem) _then) = __$ChangeItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1)@JsonKey(name: 'adult') bool? adult,@HiveField(2) String? mediaType,@HiveField(3) String? description,@HiveField(4)@JsonKey(name: 'original_title') String? originalTitle,@HiveField(5)@JsonKey(name: 'original_name') String? originalName,@HiveField(6)@JsonKey(name: 'title') String? title,@HiveField(7)@JsonKey(name: 'name') String? name,@HiveField(8)@JsonKey(name: 'profile_path') String? profilePath,@HiveField(9)@JsonKey(name: 'change_type') String? changeType,@HiveField(10)@JsonKey(name: 'changes') List<Object?>? changes
});




}
/// @nodoc
class __$ChangeItemCopyWithImpl<$Res>
    implements _$ChangeItemCopyWith<$Res> {
  __$ChangeItemCopyWithImpl(this._self, this._then);

  final _ChangeItem _self;
  final $Res Function(_ChangeItem) _then;

/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? adult = freezed,Object? mediaType = freezed,Object? description = freezed,Object? originalTitle = freezed,Object? originalName = freezed,Object? title = freezed,Object? name = freezed,Object? profilePath = freezed,Object? changeType = freezed,Object? changes = freezed,}) {
  return _then(_ChangeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,changeType: freezed == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String?,changes: freezed == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<Object?>?,
  ));
}


}

// dart format on
