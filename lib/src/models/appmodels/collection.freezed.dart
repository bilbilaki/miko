// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Collection {

@HiveField(0) String get id;// unique id (e.g., uuid)
@HiveField(1) String get name;@HiveField(2) String? get coverPath;@HiveField(3) List<CollectionItem> get items;@HiveField(4) int get createdAt;// epoch ms UTC
@HiveField(5) int get updatedAt;
/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionCopyWith<Collection> get copyWith => _$CollectionCopyWithImpl<Collection>(this as Collection, _$identity);

  /// Serializes this Collection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Collection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coverPath,const DeepCollectionEquality().hash(items),createdAt,updatedAt);

@override
String toString() {
  return 'Collection(id: $id, name: $name, coverPath: $coverPath, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CollectionCopyWith<$Res>  {
  factory $CollectionCopyWith(Collection value, $Res Function(Collection) _then) = _$CollectionCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@HiveField(2) String? coverPath,@HiveField(3) List<CollectionItem> items,@HiveField(4) int createdAt,@HiveField(5) int updatedAt
});




}
/// @nodoc
class _$CollectionCopyWithImpl<$Res>
    implements $CollectionCopyWith<$Res> {
  _$CollectionCopyWithImpl(this._self, this._then);

  final Collection _self;
  final $Res Function(Collection) _then;

/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? coverPath = freezed,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CollectionItem>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Collection].
extension CollectionPatterns on Collection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Collection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Collection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Collection value)  $default,){
final _that = this;
switch (_that) {
case _Collection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Collection value)?  $default,){
final _that = this;
switch (_that) {
case _Collection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String? coverPath, @HiveField(3)  List<CollectionItem> items, @HiveField(4)  int createdAt, @HiveField(5)  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Collection() when $default != null:
return $default(_that.id,_that.name,_that.coverPath,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String? coverPath, @HiveField(3)  List<CollectionItem> items, @HiveField(4)  int createdAt, @HiveField(5)  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Collection():
return $default(_that.id,_that.name,_that.coverPath,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String? coverPath, @HiveField(3)  List<CollectionItem> items, @HiveField(4)  int createdAt, @HiveField(5)  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Collection() when $default != null:
return $default(_that.id,_that.name,_that.coverPath,_that.items,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Collection implements Collection {
   _Collection({@HiveField(0) required this.id, @HiveField(1) required this.name, @HiveField(2) this.coverPath, @HiveField(3) final  List<CollectionItem> items = const <CollectionItem>[], @HiveField(4) required this.createdAt, @HiveField(5) required this.updatedAt}): _items = items;
  factory _Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

@override@HiveField(0) final  String id;
// unique id (e.g., uuid)
@override@HiveField(1) final  String name;
@override@HiveField(2) final  String? coverPath;
 final  List<CollectionItem> _items;
@override@JsonKey()@HiveField(3) List<CollectionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@HiveField(4) final  int createdAt;
// epoch ms UTC
@override@HiveField(5) final  int updatedAt;

/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionCopyWith<_Collection> get copyWith => __$CollectionCopyWithImpl<_Collection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Collection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coverPath,const DeepCollectionEquality().hash(_items),createdAt,updatedAt);

@override
String toString() {
  return 'Collection(id: $id, name: $name, coverPath: $coverPath, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CollectionCopyWith<$Res> implements $CollectionCopyWith<$Res> {
  factory _$CollectionCopyWith(_Collection value, $Res Function(_Collection) _then) = __$CollectionCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@HiveField(2) String? coverPath,@HiveField(3) List<CollectionItem> items,@HiveField(4) int createdAt,@HiveField(5) int updatedAt
});




}
/// @nodoc
class __$CollectionCopyWithImpl<$Res>
    implements _$CollectionCopyWith<$Res> {
  __$CollectionCopyWithImpl(this._self, this._then);

  final _Collection _self;
  final $Res Function(_Collection) _then;

/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? coverPath = freezed,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Collection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CollectionItem>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CollectionItem {

@HiveField(0) int get id;// movie/tv id
@HiveField(1) String get name;@HiveField(2) String? get posterPath;@HiveField(3) int get voteCount;@HiveField(4) String? get overview;
/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionItemCopyWith<CollectionItem> get copyWith => _$CollectionItemCopyWithImpl<CollectionItem>(this as CollectionItem, _$identity);

  /// Serializes this CollectionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.overview, overview) || other.overview == overview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,posterPath,voteCount,overview);

@override
String toString() {
  return 'CollectionItem(id: $id, name: $name, posterPath: $posterPath, voteCount: $voteCount, overview: $overview)';
}


}

/// @nodoc
abstract mixin class $CollectionItemCopyWith<$Res>  {
  factory $CollectionItemCopyWith(CollectionItem value, $Res Function(CollectionItem) _then) = _$CollectionItemCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name,@HiveField(2) String? posterPath,@HiveField(3) int voteCount,@HiveField(4) String? overview
});




}
/// @nodoc
class _$CollectionItemCopyWithImpl<$Res>
    implements $CollectionItemCopyWith<$Res> {
  _$CollectionItemCopyWithImpl(this._self, this._then);

  final CollectionItem _self;
  final $Res Function(CollectionItem) _then;

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? posterPath = freezed,Object? voteCount = null,Object? overview = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionItem].
extension CollectionItemPatterns on CollectionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionItem value)  $default,){
final _that = this;
switch (_that) {
case _CollectionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionItem value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)  String? posterPath, @HiveField(3)  int voteCount, @HiveField(4)  String? overview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
return $default(_that.id,_that.name,_that.posterPath,_that.voteCount,_that.overview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)  String? posterPath, @HiveField(3)  int voteCount, @HiveField(4)  String? overview)  $default,) {final _that = this;
switch (_that) {
case _CollectionItem():
return $default(_that.id,_that.name,_that.posterPath,_that.voteCount,_that.overview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  String name, @HiveField(2)  String? posterPath, @HiveField(3)  int voteCount, @HiveField(4)  String? overview)?  $default,) {final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
return $default(_that.id,_that.name,_that.posterPath,_that.voteCount,_that.overview);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _CollectionItem implements CollectionItem {
   _CollectionItem({@HiveField(0) required this.id, @HiveField(1) required this.name, @HiveField(2) this.posterPath, @HiveField(3) this.voteCount = 0, @HiveField(4) this.overview});
  factory _CollectionItem.fromJson(Map<String, dynamic> json) => _$CollectionItemFromJson(json);

@override@HiveField(0) final  int id;
// movie/tv id
@override@HiveField(1) final  String name;
@override@HiveField(2) final  String? posterPath;
@override@JsonKey()@HiveField(3) final  int voteCount;
@override@HiveField(4) final  String? overview;

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionItemCopyWith<_CollectionItem> get copyWith => __$CollectionItemCopyWithImpl<_CollectionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.overview, overview) || other.overview == overview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,posterPath,voteCount,overview);

@override
String toString() {
  return 'CollectionItem(id: $id, name: $name, posterPath: $posterPath, voteCount: $voteCount, overview: $overview)';
}


}

/// @nodoc
abstract mixin class _$CollectionItemCopyWith<$Res> implements $CollectionItemCopyWith<$Res> {
  factory _$CollectionItemCopyWith(_CollectionItem value, $Res Function(_CollectionItem) _then) = __$CollectionItemCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) String name,@HiveField(2) String? posterPath,@HiveField(3) int voteCount,@HiveField(4) String? overview
});




}
/// @nodoc
class __$CollectionItemCopyWithImpl<$Res>
    implements _$CollectionItemCopyWith<$Res> {
  __$CollectionItemCopyWithImpl(this._self, this._then);

  final _CollectionItem _self;
  final $Res Function(_CollectionItem) _then;

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? posterPath = freezed,Object? voteCount = null,Object? overview = freezed,}) {
  return _then(_CollectionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
