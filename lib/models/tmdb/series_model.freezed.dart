// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Series _$SeriesFromJson(Map<String, dynamic> json) {
  return _Series.fromJson(json);
}

/// @nodoc
mixin _$Series {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  int? get runtime => throw _privateConstructorUsedError;
  String get overview => throw _privateConstructorUsedError;
  @JsonKey(name: 'vote_average')
  double get voteAverage => throw _privateConstructorUsedError;
  @JsonKey(name: 'vote_count')
  int get voteCount => throw _privateConstructorUsedError; // Now referencing the top-level functions
  @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
  List<GenreObject> get genres => throw _privateConstructorUsedError;
  @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
  List<KeywordObject> get keywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_name')
  String get originalName => throw _privateConstructorUsedError;
  @JsonKey(name: 'poster_path')
  String? get posterPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath => throw _privateConstructorUsedError;
  double get popularity => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_language')
  String get originalLanguage => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // e.g., "TV Series", "Movie"
  @JsonKey(name: 'episodes_number')
  int? get episodesNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'seasons_number')
  int? get seasonsNumber => throw _privateConstructorUsedError;
  String? get homepage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: castFromJson, toJson: castToJson)
  List<CastMember> get cast => throw _privateConstructorUsedError;
  @JsonKey(fromJson: crewFromJson, toJson: crewToJson)
  List<EpisodeCrew> get crew => throw _privateConstructorUsedError;
  @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
  List<VideoObject> get videos => throw _privateConstructorUsedError;

  /// Serializes this Series to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Series
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeriesCopyWith<Series> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeriesCopyWith<$Res> {
  factory $SeriesCopyWith(Series value, $Res Function(Series) then) =
      _$SeriesCopyWithImpl<$Res, Series>;
  @useResult
  $Res call({
    int id,
    String title,
    String status,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    int? runtime,
    String overview,
    @JsonKey(name: 'vote_average') double voteAverage,
    @JsonKey(name: 'vote_count') int voteCount,
    @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
    List<GenreObject> genres,
    @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
    List<KeywordObject> keywords,
    @JsonKey(name: 'original_name') String originalName,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    double popularity,
    @JsonKey(name: 'original_language') String originalLanguage,
    String type,
    @JsonKey(name: 'episodes_number') int? episodesNumber,
    @JsonKey(name: 'seasons_number') int? seasonsNumber,
    String? homepage,
    @JsonKey(fromJson: castFromJson, toJson: castToJson) List<CastMember> cast,
    @JsonKey(fromJson: crewFromJson, toJson: crewToJson) List<EpisodeCrew> crew,
    @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
    List<VideoObject> videos,
  });
}

/// @nodoc
class _$SeriesCopyWithImpl<$Res, $Val extends Series>
    implements $SeriesCopyWith<$Res> {
  _$SeriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Series
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? releaseDate = freezed,
    Object? runtime = freezed,
    Object? overview = null,
    Object? voteAverage = null,
    Object? voteCount = null,
    Object? genres = null,
    Object? keywords = null,
    Object? originalName = null,
    Object? posterPath = freezed,
    Object? backdropPath = freezed,
    Object? popularity = null,
    Object? originalLanguage = null,
    Object? type = null,
    Object? episodesNumber = freezed,
    Object? seasonsNumber = freezed,
    Object? homepage = freezed,
    Object? cast = null,
    Object? crew = null,
    Object? videos = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            runtime: freezed == runtime
                ? _value.runtime
                : runtime // ignore: cast_nullable_to_non_nullable
                      as int?,
            overview: null == overview
                ? _value.overview
                : overview // ignore: cast_nullable_to_non_nullable
                      as String,
            voteAverage: null == voteAverage
                ? _value.voteAverage
                : voteAverage // ignore: cast_nullable_to_non_nullable
                      as double,
            voteCount: null == voteCount
                ? _value.voteCount
                : voteCount // ignore: cast_nullable_to_non_nullable
                      as int,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<GenreObject>,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as List<KeywordObject>,
            originalName: null == originalName
                ? _value.originalName
                : originalName // ignore: cast_nullable_to_non_nullable
                      as String,
            posterPath: freezed == posterPath
                ? _value.posterPath
                : posterPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            backdropPath: freezed == backdropPath
                ? _value.backdropPath
                : backdropPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            popularity: null == popularity
                ? _value.popularity
                : popularity // ignore: cast_nullable_to_non_nullable
                      as double,
            originalLanguage: null == originalLanguage
                ? _value.originalLanguage
                : originalLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            episodesNumber: freezed == episodesNumber
                ? _value.episodesNumber
                : episodesNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            seasonsNumber: freezed == seasonsNumber
                ? _value.seasonsNumber
                : seasonsNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            homepage: freezed == homepage
                ? _value.homepage
                : homepage // ignore: cast_nullable_to_non_nullable
                      as String?,
            cast: null == cast
                ? _value.cast
                : cast // ignore: cast_nullable_to_non_nullable
                      as List<CastMember>,
            crew: null == crew
                ? _value.crew
                : crew // ignore: cast_nullable_to_non_nullable
                      as List<EpisodeCrew>,
            videos: null == videos
                ? _value.videos
                : videos // ignore: cast_nullable_to_non_nullable
                      as List<VideoObject>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeriesImplCopyWith<$Res> implements $SeriesCopyWith<$Res> {
  factory _$$SeriesImplCopyWith(
    _$SeriesImpl value,
    $Res Function(_$SeriesImpl) then,
  ) = __$$SeriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String status,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    int? runtime,
    String overview,
    @JsonKey(name: 'vote_average') double voteAverage,
    @JsonKey(name: 'vote_count') int voteCount,
    @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
    List<GenreObject> genres,
    @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
    List<KeywordObject> keywords,
    @JsonKey(name: 'original_name') String originalName,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    double popularity,
    @JsonKey(name: 'original_language') String originalLanguage,
    String type,
    @JsonKey(name: 'episodes_number') int? episodesNumber,
    @JsonKey(name: 'seasons_number') int? seasonsNumber,
    String? homepage,
    @JsonKey(fromJson: castFromJson, toJson: castToJson) List<CastMember> cast,
    @JsonKey(fromJson: crewFromJson, toJson: crewToJson) List<EpisodeCrew> crew,
    @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
    List<VideoObject> videos,
  });
}

/// @nodoc
class __$$SeriesImplCopyWithImpl<$Res>
    extends _$SeriesCopyWithImpl<$Res, _$SeriesImpl>
    implements _$$SeriesImplCopyWith<$Res> {
  __$$SeriesImplCopyWithImpl(
    _$SeriesImpl _value,
    $Res Function(_$SeriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Series
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? releaseDate = freezed,
    Object? runtime = freezed,
    Object? overview = null,
    Object? voteAverage = null,
    Object? voteCount = null,
    Object? genres = null,
    Object? keywords = null,
    Object? originalName = null,
    Object? posterPath = freezed,
    Object? backdropPath = freezed,
    Object? popularity = null,
    Object? originalLanguage = null,
    Object? type = null,
    Object? episodesNumber = freezed,
    Object? seasonsNumber = freezed,
    Object? homepage = freezed,
    Object? cast = null,
    Object? crew = null,
    Object? videos = null,
  }) {
    return _then(
      _$SeriesImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        runtime: freezed == runtime
            ? _value.runtime
            : runtime // ignore: cast_nullable_to_non_nullable
                  as int?,
        overview: null == overview
            ? _value.overview
            : overview // ignore: cast_nullable_to_non_nullable
                  as String,
        voteAverage: null == voteAverage
            ? _value.voteAverage
            : voteAverage // ignore: cast_nullable_to_non_nullable
                  as double,
        voteCount: null == voteCount
            ? _value.voteCount
            : voteCount // ignore: cast_nullable_to_non_nullable
                  as int,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<GenreObject>,
        keywords: null == keywords
            ? _value._keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as List<KeywordObject>,
        originalName: null == originalName
            ? _value.originalName
            : originalName // ignore: cast_nullable_to_non_nullable
                  as String,
        posterPath: freezed == posterPath
            ? _value.posterPath
            : posterPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        backdropPath: freezed == backdropPath
            ? _value.backdropPath
            : backdropPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        popularity: null == popularity
            ? _value.popularity
            : popularity // ignore: cast_nullable_to_non_nullable
                  as double,
        originalLanguage: null == originalLanguage
            ? _value.originalLanguage
            : originalLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        episodesNumber: freezed == episodesNumber
            ? _value.episodesNumber
            : episodesNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        seasonsNumber: freezed == seasonsNumber
            ? _value.seasonsNumber
            : seasonsNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        homepage: freezed == homepage
            ? _value.homepage
            : homepage // ignore: cast_nullable_to_non_nullable
                  as String?,
        cast: null == cast
            ? _value._cast
            : cast // ignore: cast_nullable_to_non_nullable
                  as List<CastMember>,
        crew: null == crew
            ? _value._crew
            : crew // ignore: cast_nullable_to_non_nullable
                  as List<EpisodeCrew>,
        videos: null == videos
            ? _value._videos
            : videos // ignore: cast_nullable_to_non_nullable
                  as List<VideoObject>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeriesImpl with DiagnosticableTreeMixin implements _Series {
  const _$SeriesImpl({
    required this.id,
    required this.title,
    this.status = '',
    @JsonKey(name: 'release_date') this.releaseDate,
    this.runtime,
    this.overview = '',
    @JsonKey(name: 'vote_average') this.voteAverage = 0.0,
    @JsonKey(name: 'vote_count') this.voteCount = 0,
    @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
    final List<GenreObject> genres = const [],
    @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
    final List<KeywordObject> keywords = const [],
    @JsonKey(name: 'original_name') this.originalName = '',
    @JsonKey(name: 'poster_path') this.posterPath,
    @JsonKey(name: 'backdrop_path') this.backdropPath,
    this.popularity = 0.0,
    @JsonKey(name: 'original_language') this.originalLanguage = '',
    this.type = '',
    @JsonKey(name: 'episodes_number') this.episodesNumber,
    @JsonKey(name: 'seasons_number') this.seasonsNumber,
    this.homepage,
    @JsonKey(fromJson: castFromJson, toJson: castToJson)
    final List<CastMember> cast = const [],
    @JsonKey(fromJson: crewFromJson, toJson: crewToJson)
    final List<EpisodeCrew> crew = const [],
    @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
    final List<VideoObject> videos = const [],
  }) : _genres = genres,
       _keywords = keywords,
       _cast = cast,
       _crew = crew,
       _videos = videos;

  factory _$SeriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeriesImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'release_date')
  final DateTime? releaseDate;
  @override
  final int? runtime;
  @override
  @JsonKey()
  final String overview;
  @override
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @override
  @JsonKey(name: 'vote_count')
  final int voteCount;
  // Now referencing the top-level functions
  final List<GenreObject> _genres;
  // Now referencing the top-level functions
  @override
  @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
  List<GenreObject> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  final List<KeywordObject> _keywords;
  @override
  @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
  List<KeywordObject> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  @JsonKey(name: 'original_name')
  final String originalName;
  @override
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @override
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @override
  @JsonKey()
  final double popularity;
  @override
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @override
  @JsonKey()
  final String type;
  // e.g., "TV Series", "Movie"
  @override
  @JsonKey(name: 'episodes_number')
  final int? episodesNumber;
  @override
  @JsonKey(name: 'seasons_number')
  final int? seasonsNumber;
  @override
  final String? homepage;
  final List<CastMember> _cast;
  @override
  @JsonKey(fromJson: castFromJson, toJson: castToJson)
  List<CastMember> get cast {
    if (_cast is EqualUnmodifiableListView) return _cast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cast);
  }

  final List<EpisodeCrew> _crew;
  @override
  @JsonKey(fromJson: crewFromJson, toJson: crewToJson)
  List<EpisodeCrew> get crew {
    if (_crew is EqualUnmodifiableListView) return _crew;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_crew);
  }

  final List<VideoObject> _videos;
  @override
  @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
  List<VideoObject> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Series(id: $id, title: $title, status: $status, releaseDate: $releaseDate, runtime: $runtime, overview: $overview, voteAverage: $voteAverage, voteCount: $voteCount, genres: $genres, keywords: $keywords, originalName: $originalName, posterPath: $posterPath, backdropPath: $backdropPath, popularity: $popularity, originalLanguage: $originalLanguage, type: $type, episodesNumber: $episodesNumber, seasonsNumber: $seasonsNumber, homepage: $homepage, cast: $cast, crew: $crew, videos: $videos)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Series'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('releaseDate', releaseDate))
      ..add(DiagnosticsProperty('runtime', runtime))
      ..add(DiagnosticsProperty('overview', overview))
      ..add(DiagnosticsProperty('voteAverage', voteAverage))
      ..add(DiagnosticsProperty('voteCount', voteCount))
      ..add(DiagnosticsProperty('genres', genres))
      ..add(DiagnosticsProperty('keywords', keywords))
      ..add(DiagnosticsProperty('originalName', originalName))
      ..add(DiagnosticsProperty('posterPath', posterPath))
      ..add(DiagnosticsProperty('backdropPath', backdropPath))
      ..add(DiagnosticsProperty('popularity', popularity))
      ..add(DiagnosticsProperty('originalLanguage', originalLanguage))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('episodesNumber', episodesNumber))
      ..add(DiagnosticsProperty('seasonsNumber', seasonsNumber))
      ..add(DiagnosticsProperty('homepage', homepage))
      ..add(DiagnosticsProperty('cast', cast))
      ..add(DiagnosticsProperty('crew', crew))
      ..add(DiagnosticsProperty('videos', videos));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeriesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.runtime, runtime) || other.runtime == runtime) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.voteAverage, voteAverage) ||
                other.voteAverage == voteAverage) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.originalName, originalName) ||
                other.originalName == originalName) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.backdropPath, backdropPath) ||
                other.backdropPath == backdropPath) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.originalLanguage, originalLanguage) ||
                other.originalLanguage == originalLanguage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.episodesNumber, episodesNumber) ||
                other.episodesNumber == episodesNumber) &&
            (identical(other.seasonsNumber, seasonsNumber) ||
                other.seasonsNumber == seasonsNumber) &&
            (identical(other.homepage, homepage) ||
                other.homepage == homepage) &&
            const DeepCollectionEquality().equals(other._cast, _cast) &&
            const DeepCollectionEquality().equals(other._crew, _crew) &&
            const DeepCollectionEquality().equals(other._videos, _videos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    status,
    releaseDate,
    runtime,
    overview,
    voteAverage,
    voteCount,
    const DeepCollectionEquality().hash(_genres),
    const DeepCollectionEquality().hash(_keywords),
    originalName,
    posterPath,
    backdropPath,
    popularity,
    originalLanguage,
    type,
    episodesNumber,
    seasonsNumber,
    homepage,
    const DeepCollectionEquality().hash(_cast),
    const DeepCollectionEquality().hash(_crew),
    const DeepCollectionEquality().hash(_videos),
  ]);

  /// Create a copy of Series
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeriesImplCopyWith<_$SeriesImpl> get copyWith =>
      __$$SeriesImplCopyWithImpl<_$SeriesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeriesImplToJson(this);
  }
}

abstract class _Series implements Series {
  const factory _Series({
    required final int id,
    required final String title,
    final String status,
    @JsonKey(name: 'release_date') final DateTime? releaseDate,
    final int? runtime,
    final String overview,
    @JsonKey(name: 'vote_average') final double voteAverage,
    @JsonKey(name: 'vote_count') final int voteCount,
    @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
    final List<GenreObject> genres,
    @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
    final List<KeywordObject> keywords,
    @JsonKey(name: 'original_name') final String originalName,
    @JsonKey(name: 'poster_path') final String? posterPath,
    @JsonKey(name: 'backdrop_path') final String? backdropPath,
    final double popularity,
    @JsonKey(name: 'original_language') final String originalLanguage,
    final String type,
    @JsonKey(name: 'episodes_number') final int? episodesNumber,
    @JsonKey(name: 'seasons_number') final int? seasonsNumber,
    final String? homepage,
    @JsonKey(fromJson: castFromJson, toJson: castToJson)
    final List<CastMember> cast,
    @JsonKey(fromJson: crewFromJson, toJson: crewToJson)
    final List<EpisodeCrew> crew,
    @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
    final List<VideoObject> videos,
  }) = _$SeriesImpl;

  factory _Series.fromJson(Map<String, dynamic> json) = _$SeriesImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get status;
  @override
  @JsonKey(name: 'release_date')
  DateTime? get releaseDate;
  @override
  int? get runtime;
  @override
  String get overview;
  @override
  @JsonKey(name: 'vote_average')
  double get voteAverage;
  @override
  @JsonKey(name: 'vote_count')
  int get voteCount; // Now referencing the top-level functions
  @override
  @JsonKey(fromJson: genresFromJson, toJson: genresToJson)
  List<GenreObject> get genres;
  @override
  @JsonKey(fromJson: keywordsFromJson, toJson: keywordsToJson)
  List<KeywordObject> get keywords;
  @override
  @JsonKey(name: 'original_name')
  String get originalName;
  @override
  @JsonKey(name: 'poster_path')
  String? get posterPath;
  @override
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath;
  @override
  double get popularity;
  @override
  @JsonKey(name: 'original_language')
  String get originalLanguage;
  @override
  String get type; // e.g., "TV Series", "Movie"
  @override
  @JsonKey(name: 'episodes_number')
  int? get episodesNumber;
  @override
  @JsonKey(name: 'seasons_number')
  int? get seasonsNumber;
  @override
  String? get homepage;
  @override
  @JsonKey(fromJson: castFromJson, toJson: castToJson)
  List<CastMember> get cast;
  @override
  @JsonKey(fromJson: crewFromJson, toJson: crewToJson)
  List<EpisodeCrew> get crew;
  @override
  @JsonKey(fromJson: videosFromJson, toJson: videosToJson)
  List<VideoObject> get videos;

  /// Create a copy of Series
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeriesImplCopyWith<_$SeriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
