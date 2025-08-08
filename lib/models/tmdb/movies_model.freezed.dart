// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movies_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return _Movie.fromJson(json);
}

/// @nodoc
mixin _$Movie {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'vote_average')
  double get voteAverage => throw _privateConstructorUsedError;
  @JsonKey(name: 'vote_count')
  int get voteCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  int? get revenue => throw _privateConstructorUsedError;
  int? get runtime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  bool get adult => throw _privateConstructorUsedError;
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath => throw _privateConstructorUsedError;
  int? get budget => throw _privateConstructorUsedError;
  String? get homepage => throw _privateConstructorUsedError;
  @JsonKey(name: 'imdb_id')
  String? get imdbId => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_language')
  String get originalLanguage => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_title')
  String get originalTitle => throw _privateConstructorUsedError;
  String get overview => throw _privateConstructorUsedError;
  double get popularity => throw _privateConstructorUsedError;
  @JsonKey(name: 'poster_path')
  String? get posterPath => throw _privateConstructorUsedError;
  String? get tagline => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
  List<GenreObject> get genres => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'production_companies',
      fromJson: _movieProductionCompaniesFromJson,
      toJson: _movieProductionCompaniesToJson)
  List<ProductionCompany> get productionCompanies =>
      throw _privateConstructorUsedError;
  @JsonKey(
      name: 'production_countries',
      fromJson: _movieProductionCountriesFromJson,
      toJson: _movieProductionCountriesToJson)
  List<ProductionCountry> get productionCountries =>
      throw _privateConstructorUsedError;
  @JsonKey(
      name: 'spoken_languages',
      fromJson: _movieSpokenLanguagesFromJson,
      toJson: _movieSpokenLanguagesToJson)
  List<SpokenLanguage> get spokenLanguages =>
      throw _privateConstructorUsedError; // Use SpokenLanguage from tmdb_m.dart
  @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
  List<KeywordObject> get keywords => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'download_links',
      fromJson: _movieStringListFromJson,
      toJson: _movieStringListToJson)
  List<String> get downloadLinks => throw _privateConstructorUsedError;

  /// Serializes this Movie to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieCopyWith<Movie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieCopyWith<$Res> {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) then) =
      _$MovieCopyWithImpl<$Res, Movie>;
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'vote_average') double voteAverage,
      @JsonKey(name: 'vote_count') int voteCount,
      String status,
      @JsonKey(name: 'release_date') DateTime? releaseDate,
      int? revenue,
      int? runtime,
      @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson) bool adult,
      @JsonKey(name: 'backdrop_path') String? backdropPath,
      int? budget,
      String? homepage,
      @JsonKey(name: 'imdb_id') String? imdbId,
      @JsonKey(name: 'original_language') String originalLanguage,
      @JsonKey(name: 'original_title') String originalTitle,
      String overview,
      double popularity,
      @JsonKey(name: 'poster_path') String? posterPath,
      String? tagline,
      @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
      List<GenreObject> genres,
      @JsonKey(
          name: 'production_companies',
          fromJson: _movieProductionCompaniesFromJson,
          toJson: _movieProductionCompaniesToJson)
      List<ProductionCompany> productionCompanies,
      @JsonKey(
          name: 'production_countries',
          fromJson: _movieProductionCountriesFromJson,
          toJson: _movieProductionCountriesToJson)
      List<ProductionCountry> productionCountries,
      @JsonKey(
          name: 'spoken_languages',
          fromJson: _movieSpokenLanguagesFromJson,
          toJson: _movieSpokenLanguagesToJson)
      List<SpokenLanguage> spokenLanguages,
      @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
      List<KeywordObject> keywords,
      String? source,
      @JsonKey(
          name: 'download_links',
          fromJson: _movieStringListFromJson,
          toJson: _movieStringListToJson)
      List<String> downloadLinks});
}

/// @nodoc
class _$MovieCopyWithImpl<$Res, $Val extends Movie>
    implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? voteAverage = null,
    Object? voteCount = null,
    Object? status = null,
    Object? releaseDate = freezed,
    Object? revenue = freezed,
    Object? runtime = freezed,
    Object? adult = null,
    Object? backdropPath = freezed,
    Object? budget = freezed,
    Object? homepage = freezed,
    Object? imdbId = freezed,
    Object? originalLanguage = null,
    Object? originalTitle = null,
    Object? overview = null,
    Object? popularity = null,
    Object? posterPath = freezed,
    Object? tagline = freezed,
    Object? genres = null,
    Object? productionCompanies = null,
    Object? productionCountries = null,
    Object? spokenLanguages = null,
    Object? keywords = null,
    Object? source = freezed,
    Object? downloadLinks = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      voteAverage: null == voteAverage
          ? _value.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double,
      voteCount: null == voteCount
          ? _value.voteCount
          : voteCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revenue: freezed == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as int?,
      runtime: freezed == runtime
          ? _value.runtime
          : runtime // ignore: cast_nullable_to_non_nullable
              as int?,
      adult: null == adult
          ? _value.adult
          : adult // ignore: cast_nullable_to_non_nullable
              as bool,
      backdropPath: freezed == backdropPath
          ? _value.backdropPath
          : backdropPath // ignore: cast_nullable_to_non_nullable
              as String?,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
      homepage: freezed == homepage
          ? _value.homepage
          : homepage // ignore: cast_nullable_to_non_nullable
              as String?,
      imdbId: freezed == imdbId
          ? _value.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalLanguage: null == originalLanguage
          ? _value.originalLanguage
          : originalLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      originalTitle: null == originalTitle
          ? _value.originalTitle
          : originalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as double,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      tagline: freezed == tagline
          ? _value.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String?,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<GenreObject>,
      productionCompanies: null == productionCompanies
          ? _value.productionCompanies
          : productionCompanies // ignore: cast_nullable_to_non_nullable
              as List<ProductionCompany>,
      productionCountries: null == productionCountries
          ? _value.productionCountries
          : productionCountries // ignore: cast_nullable_to_non_nullable
              as List<ProductionCountry>,
      spokenLanguages: null == spokenLanguages
          ? _value.spokenLanguages
          : spokenLanguages // ignore: cast_nullable_to_non_nullable
              as List<SpokenLanguage>,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<KeywordObject>,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadLinks: null == downloadLinks
          ? _value.downloadLinks
          : downloadLinks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovieImplCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$$MovieImplCopyWith(
          _$MovieImpl value, $Res Function(_$MovieImpl) then) =
      __$$MovieImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'vote_average') double voteAverage,
      @JsonKey(name: 'vote_count') int voteCount,
      String status,
      @JsonKey(name: 'release_date') DateTime? releaseDate,
      int? revenue,
      int? runtime,
      @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson) bool adult,
      @JsonKey(name: 'backdrop_path') String? backdropPath,
      int? budget,
      String? homepage,
      @JsonKey(name: 'imdb_id') String? imdbId,
      @JsonKey(name: 'original_language') String originalLanguage,
      @JsonKey(name: 'original_title') String originalTitle,
      String overview,
      double popularity,
      @JsonKey(name: 'poster_path') String? posterPath,
      String? tagline,
      @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
      List<GenreObject> genres,
      @JsonKey(
          name: 'production_companies',
          fromJson: _movieProductionCompaniesFromJson,
          toJson: _movieProductionCompaniesToJson)
      List<ProductionCompany> productionCompanies,
      @JsonKey(
          name: 'production_countries',
          fromJson: _movieProductionCountriesFromJson,
          toJson: _movieProductionCountriesToJson)
      List<ProductionCountry> productionCountries,
      @JsonKey(
          name: 'spoken_languages',
          fromJson: _movieSpokenLanguagesFromJson,
          toJson: _movieSpokenLanguagesToJson)
      List<SpokenLanguage> spokenLanguages,
      @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
      List<KeywordObject> keywords,
      String? source,
      @JsonKey(
          name: 'download_links',
          fromJson: _movieStringListFromJson,
          toJson: _movieStringListToJson)
      List<String> downloadLinks});
}

/// @nodoc
class __$$MovieImplCopyWithImpl<$Res>
    extends _$MovieCopyWithImpl<$Res, _$MovieImpl>
    implements _$$MovieImplCopyWith<$Res> {
  __$$MovieImplCopyWithImpl(
      _$MovieImpl _value, $Res Function(_$MovieImpl) _then)
      : super(_value, _then);

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? voteAverage = null,
    Object? voteCount = null,
    Object? status = null,
    Object? releaseDate = freezed,
    Object? revenue = freezed,
    Object? runtime = freezed,
    Object? adult = null,
    Object? backdropPath = freezed,
    Object? budget = freezed,
    Object? homepage = freezed,
    Object? imdbId = freezed,
    Object? originalLanguage = null,
    Object? originalTitle = null,
    Object? overview = null,
    Object? popularity = null,
    Object? posterPath = freezed,
    Object? tagline = freezed,
    Object? genres = null,
    Object? productionCompanies = null,
    Object? productionCountries = null,
    Object? spokenLanguages = null,
    Object? keywords = null,
    Object? source = freezed,
    Object? downloadLinks = null,
  }) {
    return _then(_$MovieImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      voteAverage: null == voteAverage
          ? _value.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double,
      voteCount: null == voteCount
          ? _value.voteCount
          : voteCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revenue: freezed == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as int?,
      runtime: freezed == runtime
          ? _value.runtime
          : runtime // ignore: cast_nullable_to_non_nullable
              as int?,
      adult: null == adult
          ? _value.adult
          : adult // ignore: cast_nullable_to_non_nullable
              as bool,
      backdropPath: freezed == backdropPath
          ? _value.backdropPath
          : backdropPath // ignore: cast_nullable_to_non_nullable
              as String?,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
      homepage: freezed == homepage
          ? _value.homepage
          : homepage // ignore: cast_nullable_to_non_nullable
              as String?,
      imdbId: freezed == imdbId
          ? _value.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalLanguage: null == originalLanguage
          ? _value.originalLanguage
          : originalLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      originalTitle: null == originalTitle
          ? _value.originalTitle
          : originalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as double,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      tagline: freezed == tagline
          ? _value.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String?,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<GenreObject>,
      productionCompanies: null == productionCompanies
          ? _value._productionCompanies
          : productionCompanies // ignore: cast_nullable_to_non_nullable
              as List<ProductionCompany>,
      productionCountries: null == productionCountries
          ? _value._productionCountries
          : productionCountries // ignore: cast_nullable_to_non_nullable
              as List<ProductionCountry>,
      spokenLanguages: null == spokenLanguages
          ? _value._spokenLanguages
          : spokenLanguages // ignore: cast_nullable_to_non_nullable
              as List<SpokenLanguage>,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<KeywordObject>,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadLinks: null == downloadLinks
          ? _value._downloadLinks
          : downloadLinks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieImpl with DiagnosticableTreeMixin implements _Movie {
  const _$MovieImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'vote_average') this.voteAverage = 0.0,
      @JsonKey(name: 'vote_count') this.voteCount = 0,
      this.status = '',
      @JsonKey(name: 'release_date') this.releaseDate,
      this.revenue,
      this.runtime,
      @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson) this.adult = false,
      @JsonKey(name: 'backdrop_path') this.backdropPath,
      this.budget,
      this.homepage,
      @JsonKey(name: 'imdb_id') this.imdbId,
      @JsonKey(name: 'original_language') this.originalLanguage = '',
      @JsonKey(name: 'original_title') this.originalTitle = '',
      this.overview = '',
      this.popularity = 0.0,
      @JsonKey(name: 'poster_path') this.posterPath,
      this.tagline,
      @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
      final List<GenreObject> genres = const [],
      @JsonKey(
          name: 'production_companies',
          fromJson: _movieProductionCompaniesFromJson,
          toJson: _movieProductionCompaniesToJson)
      final List<ProductionCompany> productionCompanies = const [],
      @JsonKey(
          name: 'production_countries',
          fromJson: _movieProductionCountriesFromJson,
          toJson: _movieProductionCountriesToJson)
      final List<ProductionCountry> productionCountries = const [],
      @JsonKey(
          name: 'spoken_languages',
          fromJson: _movieSpokenLanguagesFromJson,
          toJson: _movieSpokenLanguagesToJson)
      final List<SpokenLanguage> spokenLanguages = const [],
      @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
      final List<KeywordObject> keywords = const [],
      this.source,
      @JsonKey(
          name: 'download_links',
          fromJson: _movieStringListFromJson,
          toJson: _movieStringListToJson)
      final List<String> downloadLinks = const []})
      : _genres = genres,
        _productionCompanies = productionCompanies,
        _productionCountries = productionCountries,
        _spokenLanguages = spokenLanguages,
        _keywords = keywords,
        _downloadLinks = downloadLinks;

  factory _$MovieImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @override
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'release_date')
  final DateTime? releaseDate;
  @override
  final int? revenue;
  @override
  final int? runtime;
  @override
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool adult;
  @override
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @override
  final int? budget;
  @override
  final String? homepage;
  @override
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @override
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @override
  @JsonKey(name: 'original_title')
  final String originalTitle;
  @override
  @JsonKey()
  final String overview;
  @override
  @JsonKey()
  final double popularity;
  @override
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @override
  final String? tagline;
  final List<GenreObject> _genres;
  @override
  @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
  List<GenreObject> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  final List<ProductionCompany> _productionCompanies;
  @override
  @JsonKey(
      name: 'production_companies',
      fromJson: _movieProductionCompaniesFromJson,
      toJson: _movieProductionCompaniesToJson)
  List<ProductionCompany> get productionCompanies {
    if (_productionCompanies is EqualUnmodifiableListView)
      return _productionCompanies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productionCompanies);
  }

  final List<ProductionCountry> _productionCountries;
  @override
  @JsonKey(
      name: 'production_countries',
      fromJson: _movieProductionCountriesFromJson,
      toJson: _movieProductionCountriesToJson)
  List<ProductionCountry> get productionCountries {
    if (_productionCountries is EqualUnmodifiableListView)
      return _productionCountries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productionCountries);
  }

  final List<SpokenLanguage> _spokenLanguages;
  @override
  @JsonKey(
      name: 'spoken_languages',
      fromJson: _movieSpokenLanguagesFromJson,
      toJson: _movieSpokenLanguagesToJson)
  List<SpokenLanguage> get spokenLanguages {
    if (_spokenLanguages is EqualUnmodifiableListView) return _spokenLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spokenLanguages);
  }

// Use SpokenLanguage from tmdb_m.dart
  final List<KeywordObject> _keywords;
// Use SpokenLanguage from tmdb_m.dart
  @override
  @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
  List<KeywordObject> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  final String? source;
  final List<String> _downloadLinks;
  @override
  @JsonKey(
      name: 'download_links',
      fromJson: _movieStringListFromJson,
      toJson: _movieStringListToJson)
  List<String> get downloadLinks {
    if (_downloadLinks is EqualUnmodifiableListView) return _downloadLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_downloadLinks);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Movie(id: $id, title: $title, voteAverage: $voteAverage, voteCount: $voteCount, status: $status, releaseDate: $releaseDate, revenue: $revenue, runtime: $runtime, adult: $adult, backdropPath: $backdropPath, budget: $budget, homepage: $homepage, imdbId: $imdbId, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, tagline: $tagline, genres: $genres, productionCompanies: $productionCompanies, productionCountries: $productionCountries, spokenLanguages: $spokenLanguages, keywords: $keywords, source: $source, downloadLinks: $downloadLinks)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Movie'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('voteAverage', voteAverage))
      ..add(DiagnosticsProperty('voteCount', voteCount))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('releaseDate', releaseDate))
      ..add(DiagnosticsProperty('revenue', revenue))
      ..add(DiagnosticsProperty('runtime', runtime))
      ..add(DiagnosticsProperty('adult', adult))
      ..add(DiagnosticsProperty('backdropPath', backdropPath))
      ..add(DiagnosticsProperty('budget', budget))
      ..add(DiagnosticsProperty('homepage', homepage))
      ..add(DiagnosticsProperty('imdbId', imdbId))
      ..add(DiagnosticsProperty('originalLanguage', originalLanguage))
      ..add(DiagnosticsProperty('originalTitle', originalTitle))
      ..add(DiagnosticsProperty('overview', overview))
      ..add(DiagnosticsProperty('popularity', popularity))
      ..add(DiagnosticsProperty('posterPath', posterPath))
      ..add(DiagnosticsProperty('tagline', tagline))
      ..add(DiagnosticsProperty('genres', genres))
      ..add(DiagnosticsProperty('productionCompanies', productionCompanies))
      ..add(DiagnosticsProperty('productionCountries', productionCountries))
      ..add(DiagnosticsProperty('spokenLanguages', spokenLanguages))
      ..add(DiagnosticsProperty('keywords', keywords))
      ..add(DiagnosticsProperty('source', source))
      ..add(DiagnosticsProperty('downloadLinks', downloadLinks));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.voteAverage, voteAverage) ||
                other.voteAverage == voteAverage) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.runtime, runtime) || other.runtime == runtime) &&
            (identical(other.adult, adult) || other.adult == adult) &&
            (identical(other.backdropPath, backdropPath) ||
                other.backdropPath == backdropPath) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.homepage, homepage) ||
                other.homepage == homepage) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.originalLanguage, originalLanguage) ||
                other.originalLanguage == originalLanguage) &&
            (identical(other.originalTitle, originalTitle) ||
                other.originalTitle == originalTitle) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.tagline, tagline) || other.tagline == tagline) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality()
                .equals(other._productionCompanies, _productionCompanies) &&
            const DeepCollectionEquality()
                .equals(other._productionCountries, _productionCountries) &&
            const DeepCollectionEquality()
                .equals(other._spokenLanguages, _spokenLanguages) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other._downloadLinks, _downloadLinks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        voteAverage,
        voteCount,
        status,
        releaseDate,
        revenue,
        runtime,
        adult,
        backdropPath,
        budget,
        homepage,
        imdbId,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        tagline,
        const DeepCollectionEquality().hash(_genres),
        const DeepCollectionEquality().hash(_productionCompanies),
        const DeepCollectionEquality().hash(_productionCountries),
        const DeepCollectionEquality().hash(_spokenLanguages),
        const DeepCollectionEquality().hash(_keywords),
        source,
        const DeepCollectionEquality().hash(_downloadLinks)
      ]);

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      __$$MovieImplCopyWithImpl<_$MovieImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieImplToJson(
      this,
    );
  }
}

abstract class _Movie implements Movie {
  const factory _Movie(
      {required final int id,
      required final String title,
      @JsonKey(name: 'vote_average') final double voteAverage,
      @JsonKey(name: 'vote_count') final int voteCount,
      final String status,
      @JsonKey(name: 'release_date') final DateTime? releaseDate,
      final int? revenue,
      final int? runtime,
      @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson) final bool adult,
      @JsonKey(name: 'backdrop_path') final String? backdropPath,
      final int? budget,
      final String? homepage,
      @JsonKey(name: 'imdb_id') final String? imdbId,
      @JsonKey(name: 'original_language') final String originalLanguage,
      @JsonKey(name: 'original_title') final String originalTitle,
      final String overview,
      final double popularity,
      @JsonKey(name: 'poster_path') final String? posterPath,
      final String? tagline,
      @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
      final List<GenreObject> genres,
      @JsonKey(
          name: 'production_companies',
          fromJson: _movieProductionCompaniesFromJson,
          toJson: _movieProductionCompaniesToJson)
      final List<ProductionCompany> productionCompanies,
      @JsonKey(
          name: 'production_countries',
          fromJson: _movieProductionCountriesFromJson,
          toJson: _movieProductionCountriesToJson)
      final List<ProductionCountry> productionCountries,
      @JsonKey(
          name: 'spoken_languages',
          fromJson: _movieSpokenLanguagesFromJson,
          toJson: _movieSpokenLanguagesToJson)
      final List<SpokenLanguage> spokenLanguages,
      @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
      final List<KeywordObject> keywords,
      final String? source,
      @JsonKey(
          name: 'download_links',
          fromJson: _movieStringListFromJson,
          toJson: _movieStringListToJson)
      final List<String> downloadLinks}) = _$MovieImpl;

  factory _Movie.fromJson(Map<String, dynamic> json) = _$MovieImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'vote_average')
  double get voteAverage;
  @override
  @JsonKey(name: 'vote_count')
  int get voteCount;
  @override
  String get status;
  @override
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate;
  @override
  int? get revenue;
  @override
  int? get runtime;
  @override
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  bool get adult;
  @override
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath;
  @override
  int? get budget;
  @override
  String? get homepage;
  @override
  @JsonKey(name: 'imdb_id')
  String? get imdbId;
  @override
  @JsonKey(name: 'original_language')
  String get originalLanguage;
  @override
  @JsonKey(name: 'original_title')
  String get originalTitle;
  @override
  String get overview;
  @override
  double get popularity;
  @override
  @JsonKey(name: 'poster_path')
  String? get posterPath;
  @override
  String? get tagline;
  @override
  @JsonKey(fromJson: _movieGenresFromJson, toJson: _movieGenresToJson)
  List<GenreObject> get genres;
  @override
  @JsonKey(
      name: 'production_companies',
      fromJson: _movieProductionCompaniesFromJson,
      toJson: _movieProductionCompaniesToJson)
  List<ProductionCompany> get productionCompanies;
  @override
  @JsonKey(
      name: 'production_countries',
      fromJson: _movieProductionCountriesFromJson,
      toJson: _movieProductionCountriesToJson)
  List<ProductionCountry> get productionCountries;
  @override
  @JsonKey(
      name: 'spoken_languages',
      fromJson: _movieSpokenLanguagesFromJson,
      toJson: _movieSpokenLanguagesToJson)
  List<SpokenLanguage>
      get spokenLanguages; // Use SpokenLanguage from tmdb_m.dart
  @override
  @JsonKey(fromJson: _movieKeywordsFromJson, toJson: _movieKeywordsToJson)
  List<KeywordObject> get keywords;
  @override
  String? get source;
  @override
  @JsonKey(
      name: 'download_links',
      fromJson: _movieStringListFromJson,
      toJson: _movieStringListToJson)
  List<String> get downloadLinks;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
