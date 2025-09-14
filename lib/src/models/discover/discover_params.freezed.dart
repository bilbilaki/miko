// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiscoverParams {

@HiveField(0) int? get page;@HiveField(1)@JsonKey(name: 'sort_by') String? get sortBy;@HiveField(2)@JsonKey(name: 'include_adult') bool? get includeAdult;@HiveField(3)@JsonKey(name: 'with_genres') List<int>? get withGenres;@HiveField(4) int? get year;@HiveField(5)@JsonKey(name: 'primary_release_year') int? get primaryReleaseYear;@HiveField(6)@JsonKey(name: 'vote_count.gte') int? get voteCountGte;@HiveField(7)@JsonKey(name: 'vote_average.gte') double? get voteAverageGte;@HiveField(8)@JsonKey(name: 'with_companies') List<int>? get withCompanies;@HiveField(9)@JsonKey(name: 'with_watch_providers') List<int>? get withWatchProviders;@HiveField(10)@JsonKey(name: 'with_original_language') String? get withOriginalLanguage;@HiveField(11)@JsonKey(name: 'with_runtime.gte') int? get runtimeGte;@HiveField(12)@JsonKey(name: 'with_runtime.lte') int? get runtimeLte;
/// Create a copy of DiscoverParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverParamsCopyWith<DiscoverParams> get copyWith => _$DiscoverParamsCopyWithImpl<DiscoverParams>(this as DiscoverParams, _$identity);

  /// Serializes this DiscoverParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverParams&&(identical(other.page, page) || other.page == page)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.includeAdult, includeAdult) || other.includeAdult == includeAdult)&&const DeepCollectionEquality().equals(other.withGenres, withGenres)&&(identical(other.year, year) || other.year == year)&&(identical(other.primaryReleaseYear, primaryReleaseYear) || other.primaryReleaseYear == primaryReleaseYear)&&(identical(other.voteCountGte, voteCountGte) || other.voteCountGte == voteCountGte)&&(identical(other.voteAverageGte, voteAverageGte) || other.voteAverageGte == voteAverageGte)&&const DeepCollectionEquality().equals(other.withCompanies, withCompanies)&&const DeepCollectionEquality().equals(other.withWatchProviders, withWatchProviders)&&(identical(other.withOriginalLanguage, withOriginalLanguage) || other.withOriginalLanguage == withOriginalLanguage)&&(identical(other.runtimeGte, runtimeGte) || other.runtimeGte == runtimeGte)&&(identical(other.runtimeLte, runtimeLte) || other.runtimeLte == runtimeLte));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,sortBy,includeAdult,const DeepCollectionEquality().hash(withGenres),year,primaryReleaseYear,voteCountGte,voteAverageGte,const DeepCollectionEquality().hash(withCompanies),const DeepCollectionEquality().hash(withWatchProviders),withOriginalLanguage,runtimeGte,runtimeLte);

@override
String toString() {
  return 'DiscoverParams(page: $page, sortBy: $sortBy, includeAdult: $includeAdult, withGenres: $withGenres, year: $year, primaryReleaseYear: $primaryReleaseYear, voteCountGte: $voteCountGte, voteAverageGte: $voteAverageGte, withCompanies: $withCompanies, withWatchProviders: $withWatchProviders, withOriginalLanguage: $withOriginalLanguage, runtimeGte: $runtimeGte, runtimeLte: $runtimeLte)';
}


}

/// @nodoc
abstract mixin class $DiscoverParamsCopyWith<$Res>  {
  factory $DiscoverParamsCopyWith(DiscoverParams value, $Res Function(DiscoverParams) _then) = _$DiscoverParamsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int? page,@HiveField(1)@JsonKey(name: 'sort_by') String? sortBy,@HiveField(2)@JsonKey(name: 'include_adult') bool? includeAdult,@HiveField(3)@JsonKey(name: 'with_genres') List<int>? withGenres,@HiveField(4) int? year,@HiveField(5)@JsonKey(name: 'primary_release_year') int? primaryReleaseYear,@HiveField(6)@JsonKey(name: 'vote_count.gte') int? voteCountGte,@HiveField(7)@JsonKey(name: 'vote_average.gte') double? voteAverageGte,@HiveField(8)@JsonKey(name: 'with_companies') List<int>? withCompanies,@HiveField(9)@JsonKey(name: 'with_watch_providers') List<int>? withWatchProviders,@HiveField(10)@JsonKey(name: 'with_original_language') String? withOriginalLanguage,@HiveField(11)@JsonKey(name: 'with_runtime.gte') int? runtimeGte,@HiveField(12)@JsonKey(name: 'with_runtime.lte') int? runtimeLte
});




}
/// @nodoc
class _$DiscoverParamsCopyWithImpl<$Res>
    implements $DiscoverParamsCopyWith<$Res> {
  _$DiscoverParamsCopyWithImpl(this._self, this._then);

  final DiscoverParams _self;
  final $Res Function(DiscoverParams) _then;

/// Create a copy of DiscoverParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = freezed,Object? sortBy = freezed,Object? includeAdult = freezed,Object? withGenres = freezed,Object? year = freezed,Object? primaryReleaseYear = freezed,Object? voteCountGte = freezed,Object? voteAverageGte = freezed,Object? withCompanies = freezed,Object? withWatchProviders = freezed,Object? withOriginalLanguage = freezed,Object? runtimeGte = freezed,Object? runtimeLte = freezed,}) {
  return _then(_self.copyWith(
page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,includeAdult: freezed == includeAdult ? _self.includeAdult : includeAdult // ignore: cast_nullable_to_non_nullable
as bool?,withGenres: freezed == withGenres ? _self.withGenres : withGenres // ignore: cast_nullable_to_non_nullable
as List<int>?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,primaryReleaseYear: freezed == primaryReleaseYear ? _self.primaryReleaseYear : primaryReleaseYear // ignore: cast_nullable_to_non_nullable
as int?,voteCountGte: freezed == voteCountGte ? _self.voteCountGte : voteCountGte // ignore: cast_nullable_to_non_nullable
as int?,voteAverageGte: freezed == voteAverageGte ? _self.voteAverageGte : voteAverageGte // ignore: cast_nullable_to_non_nullable
as double?,withCompanies: freezed == withCompanies ? _self.withCompanies : withCompanies // ignore: cast_nullable_to_non_nullable
as List<int>?,withWatchProviders: freezed == withWatchProviders ? _self.withWatchProviders : withWatchProviders // ignore: cast_nullable_to_non_nullable
as List<int>?,withOriginalLanguage: freezed == withOriginalLanguage ? _self.withOriginalLanguage : withOriginalLanguage // ignore: cast_nullable_to_non_nullable
as String?,runtimeGte: freezed == runtimeGte ? _self.runtimeGte : runtimeGte // ignore: cast_nullable_to_non_nullable
as int?,runtimeLte: freezed == runtimeLte ? _self.runtimeLte : runtimeLte // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverParams].
extension DiscoverParamsPatterns on DiscoverParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverParams value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverParams value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int? page, @HiveField(1)@JsonKey(name: 'sort_by')  String? sortBy, @HiveField(2)@JsonKey(name: 'include_adult')  bool? includeAdult, @HiveField(3)@JsonKey(name: 'with_genres')  List<int>? withGenres, @HiveField(4)  int? year, @HiveField(5)@JsonKey(name: 'primary_release_year')  int? primaryReleaseYear, @HiveField(6)@JsonKey(name: 'vote_count.gte')  int? voteCountGte, @HiveField(7)@JsonKey(name: 'vote_average.gte')  double? voteAverageGte, @HiveField(8)@JsonKey(name: 'with_companies')  List<int>? withCompanies, @HiveField(9)@JsonKey(name: 'with_watch_providers')  List<int>? withWatchProviders, @HiveField(10)@JsonKey(name: 'with_original_language')  String? withOriginalLanguage, @HiveField(11)@JsonKey(name: 'with_runtime.gte')  int? runtimeGte, @HiveField(12)@JsonKey(name: 'with_runtime.lte')  int? runtimeLte)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverParams() when $default != null:
return $default(_that.page,_that.sortBy,_that.includeAdult,_that.withGenres,_that.year,_that.primaryReleaseYear,_that.voteCountGte,_that.voteAverageGte,_that.withCompanies,_that.withWatchProviders,_that.withOriginalLanguage,_that.runtimeGte,_that.runtimeLte);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int? page, @HiveField(1)@JsonKey(name: 'sort_by')  String? sortBy, @HiveField(2)@JsonKey(name: 'include_adult')  bool? includeAdult, @HiveField(3)@JsonKey(name: 'with_genres')  List<int>? withGenres, @HiveField(4)  int? year, @HiveField(5)@JsonKey(name: 'primary_release_year')  int? primaryReleaseYear, @HiveField(6)@JsonKey(name: 'vote_count.gte')  int? voteCountGte, @HiveField(7)@JsonKey(name: 'vote_average.gte')  double? voteAverageGte, @HiveField(8)@JsonKey(name: 'with_companies')  List<int>? withCompanies, @HiveField(9)@JsonKey(name: 'with_watch_providers')  List<int>? withWatchProviders, @HiveField(10)@JsonKey(name: 'with_original_language')  String? withOriginalLanguage, @HiveField(11)@JsonKey(name: 'with_runtime.gte')  int? runtimeGte, @HiveField(12)@JsonKey(name: 'with_runtime.lte')  int? runtimeLte)  $default,) {final _that = this;
switch (_that) {
case _DiscoverParams():
return $default(_that.page,_that.sortBy,_that.includeAdult,_that.withGenres,_that.year,_that.primaryReleaseYear,_that.voteCountGte,_that.voteAverageGte,_that.withCompanies,_that.withWatchProviders,_that.withOriginalLanguage,_that.runtimeGte,_that.runtimeLte);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int? page, @HiveField(1)@JsonKey(name: 'sort_by')  String? sortBy, @HiveField(2)@JsonKey(name: 'include_adult')  bool? includeAdult, @HiveField(3)@JsonKey(name: 'with_genres')  List<int>? withGenres, @HiveField(4)  int? year, @HiveField(5)@JsonKey(name: 'primary_release_year')  int? primaryReleaseYear, @HiveField(6)@JsonKey(name: 'vote_count.gte')  int? voteCountGte, @HiveField(7)@JsonKey(name: 'vote_average.gte')  double? voteAverageGte, @HiveField(8)@JsonKey(name: 'with_companies')  List<int>? withCompanies, @HiveField(9)@JsonKey(name: 'with_watch_providers')  List<int>? withWatchProviders, @HiveField(10)@JsonKey(name: 'with_original_language')  String? withOriginalLanguage, @HiveField(11)@JsonKey(name: 'with_runtime.gte')  int? runtimeGte, @HiveField(12)@JsonKey(name: 'with_runtime.lte')  int? runtimeLte)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverParams() when $default != null:
return $default(_that.page,_that.sortBy,_that.includeAdult,_that.withGenres,_that.year,_that.primaryReleaseYear,_that.voteCountGte,_that.voteAverageGte,_that.withCompanies,_that.withWatchProviders,_that.withOriginalLanguage,_that.runtimeGte,_that.runtimeLte);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscoverParams implements DiscoverParams {
  const _DiscoverParams({@HiveField(0) this.page, @HiveField(1)@JsonKey(name: 'sort_by') this.sortBy, @HiveField(2)@JsonKey(name: 'include_adult') this.includeAdult, @HiveField(3)@JsonKey(name: 'with_genres') final  List<int>? withGenres, @HiveField(4) this.year, @HiveField(5)@JsonKey(name: 'primary_release_year') this.primaryReleaseYear, @HiveField(6)@JsonKey(name: 'vote_count.gte') this.voteCountGte, @HiveField(7)@JsonKey(name: 'vote_average.gte') this.voteAverageGte, @HiveField(8)@JsonKey(name: 'with_companies') final  List<int>? withCompanies, @HiveField(9)@JsonKey(name: 'with_watch_providers') final  List<int>? withWatchProviders, @HiveField(10)@JsonKey(name: 'with_original_language') this.withOriginalLanguage, @HiveField(11)@JsonKey(name: 'with_runtime.gte') this.runtimeGte, @HiveField(12)@JsonKey(name: 'with_runtime.lte') this.runtimeLte}): _withGenres = withGenres,_withCompanies = withCompanies,_withWatchProviders = withWatchProviders;
  factory _DiscoverParams.fromJson(Map<String, dynamic> json) => _$DiscoverParamsFromJson(json);

@override@HiveField(0) final  int? page;
@override@HiveField(1)@JsonKey(name: 'sort_by') final  String? sortBy;
@override@HiveField(2)@JsonKey(name: 'include_adult') final  bool? includeAdult;
 final  List<int>? _withGenres;
@override@HiveField(3)@JsonKey(name: 'with_genres') List<int>? get withGenres {
  final value = _withGenres;
  if (value == null) return null;
  if (_withGenres is EqualUnmodifiableListView) return _withGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(4) final  int? year;
@override@HiveField(5)@JsonKey(name: 'primary_release_year') final  int? primaryReleaseYear;
@override@HiveField(6)@JsonKey(name: 'vote_count.gte') final  int? voteCountGte;
@override@HiveField(7)@JsonKey(name: 'vote_average.gte') final  double? voteAverageGte;
 final  List<int>? _withCompanies;
@override@HiveField(8)@JsonKey(name: 'with_companies') List<int>? get withCompanies {
  final value = _withCompanies;
  if (value == null) return null;
  if (_withCompanies is EqualUnmodifiableListView) return _withCompanies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _withWatchProviders;
@override@HiveField(9)@JsonKey(name: 'with_watch_providers') List<int>? get withWatchProviders {
  final value = _withWatchProviders;
  if (value == null) return null;
  if (_withWatchProviders is EqualUnmodifiableListView) return _withWatchProviders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(10)@JsonKey(name: 'with_original_language') final  String? withOriginalLanguage;
@override@HiveField(11)@JsonKey(name: 'with_runtime.gte') final  int? runtimeGte;
@override@HiveField(12)@JsonKey(name: 'with_runtime.lte') final  int? runtimeLte;

/// Create a copy of DiscoverParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverParamsCopyWith<_DiscoverParams> get copyWith => __$DiscoverParamsCopyWithImpl<_DiscoverParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscoverParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverParams&&(identical(other.page, page) || other.page == page)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.includeAdult, includeAdult) || other.includeAdult == includeAdult)&&const DeepCollectionEquality().equals(other._withGenres, _withGenres)&&(identical(other.year, year) || other.year == year)&&(identical(other.primaryReleaseYear, primaryReleaseYear) || other.primaryReleaseYear == primaryReleaseYear)&&(identical(other.voteCountGte, voteCountGte) || other.voteCountGte == voteCountGte)&&(identical(other.voteAverageGte, voteAverageGte) || other.voteAverageGte == voteAverageGte)&&const DeepCollectionEquality().equals(other._withCompanies, _withCompanies)&&const DeepCollectionEquality().equals(other._withWatchProviders, _withWatchProviders)&&(identical(other.withOriginalLanguage, withOriginalLanguage) || other.withOriginalLanguage == withOriginalLanguage)&&(identical(other.runtimeGte, runtimeGte) || other.runtimeGte == runtimeGte)&&(identical(other.runtimeLte, runtimeLte) || other.runtimeLte == runtimeLte));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,sortBy,includeAdult,const DeepCollectionEquality().hash(_withGenres),year,primaryReleaseYear,voteCountGte,voteAverageGte,const DeepCollectionEquality().hash(_withCompanies),const DeepCollectionEquality().hash(_withWatchProviders),withOriginalLanguage,runtimeGte,runtimeLte);

@override
String toString() {
  return 'DiscoverParams(page: $page, sortBy: $sortBy, includeAdult: $includeAdult, withGenres: $withGenres, year: $year, primaryReleaseYear: $primaryReleaseYear, voteCountGte: $voteCountGte, voteAverageGte: $voteAverageGte, withCompanies: $withCompanies, withWatchProviders: $withWatchProviders, withOriginalLanguage: $withOriginalLanguage, runtimeGte: $runtimeGte, runtimeLte: $runtimeLte)';
}


}

/// @nodoc
abstract mixin class _$DiscoverParamsCopyWith<$Res> implements $DiscoverParamsCopyWith<$Res> {
  factory _$DiscoverParamsCopyWith(_DiscoverParams value, $Res Function(_DiscoverParams) _then) = __$DiscoverParamsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int? page,@HiveField(1)@JsonKey(name: 'sort_by') String? sortBy,@HiveField(2)@JsonKey(name: 'include_adult') bool? includeAdult,@HiveField(3)@JsonKey(name: 'with_genres') List<int>? withGenres,@HiveField(4) int? year,@HiveField(5)@JsonKey(name: 'primary_release_year') int? primaryReleaseYear,@HiveField(6)@JsonKey(name: 'vote_count.gte') int? voteCountGte,@HiveField(7)@JsonKey(name: 'vote_average.gte') double? voteAverageGte,@HiveField(8)@JsonKey(name: 'with_companies') List<int>? withCompanies,@HiveField(9)@JsonKey(name: 'with_watch_providers') List<int>? withWatchProviders,@HiveField(10)@JsonKey(name: 'with_original_language') String? withOriginalLanguage,@HiveField(11)@JsonKey(name: 'with_runtime.gte') int? runtimeGte,@HiveField(12)@JsonKey(name: 'with_runtime.lte') int? runtimeLte
});




}
/// @nodoc
class __$DiscoverParamsCopyWithImpl<$Res>
    implements _$DiscoverParamsCopyWith<$Res> {
  __$DiscoverParamsCopyWithImpl(this._self, this._then);

  final _DiscoverParams _self;
  final $Res Function(_DiscoverParams) _then;

/// Create a copy of DiscoverParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = freezed,Object? sortBy = freezed,Object? includeAdult = freezed,Object? withGenres = freezed,Object? year = freezed,Object? primaryReleaseYear = freezed,Object? voteCountGte = freezed,Object? voteAverageGte = freezed,Object? withCompanies = freezed,Object? withWatchProviders = freezed,Object? withOriginalLanguage = freezed,Object? runtimeGte = freezed,Object? runtimeLte = freezed,}) {
  return _then(_DiscoverParams(
page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,includeAdult: freezed == includeAdult ? _self.includeAdult : includeAdult // ignore: cast_nullable_to_non_nullable
as bool?,withGenres: freezed == withGenres ? _self._withGenres : withGenres // ignore: cast_nullable_to_non_nullable
as List<int>?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,primaryReleaseYear: freezed == primaryReleaseYear ? _self.primaryReleaseYear : primaryReleaseYear // ignore: cast_nullable_to_non_nullable
as int?,voteCountGte: freezed == voteCountGte ? _self.voteCountGte : voteCountGte // ignore: cast_nullable_to_non_nullable
as int?,voteAverageGte: freezed == voteAverageGte ? _self.voteAverageGte : voteAverageGte // ignore: cast_nullable_to_non_nullable
as double?,withCompanies: freezed == withCompanies ? _self._withCompanies : withCompanies // ignore: cast_nullable_to_non_nullable
as List<int>?,withWatchProviders: freezed == withWatchProviders ? _self._withWatchProviders : withWatchProviders // ignore: cast_nullable_to_non_nullable
as List<int>?,withOriginalLanguage: freezed == withOriginalLanguage ? _self.withOriginalLanguage : withOriginalLanguage // ignore: cast_nullable_to_non_nullable
as String?,runtimeGte: freezed == runtimeGte ? _self.runtimeGte : runtimeGte // ignore: cast_nullable_to_non_nullable
as int?,runtimeLte: freezed == runtimeLte ? _self.runtimeLte : runtimeLte // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
