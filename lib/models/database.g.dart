// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MoviesTable extends Movies with TableInfo<$MoviesTable, Movie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalTitleMeta =
      const VerificationMeta('originalTitle');
  @override
  late final GeneratedColumn<String> originalTitle = GeneratedColumn<String>(
      'original_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
      'release_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _posterPathMeta =
      const VerificationMeta('posterPath');
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
      'poster_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backdropPathMeta =
      const VerificationMeta('backdropPath');
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
      'backdrop_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voteAverageMeta =
      const VerificationMeta('voteAverage');
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
      'vote_average', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _voteCountMeta =
      const VerificationMeta('voteCount');
  @override
  late final GeneratedColumn<int> voteCount = GeneratedColumn<int>(
      'vote_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _popularityMeta =
      const VerificationMeta('popularity');
  @override
  late final GeneratedColumn<double> popularity = GeneratedColumn<double>(
      'popularity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _adultMeta = const VerificationMeta('adult');
  @override
  late final GeneratedColumn<bool> adult = GeneratedColumn<bool>(
      'adult', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("adult" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _runtimeMeta =
      const VerificationMeta('runtime');
  @override
  late final GeneratedColumn<int> runtime = GeneratedColumn<int>(
      'runtime', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taglineMeta =
      const VerificationMeta('tagline');
  @override
  late final GeneratedColumn<String> tagline = GeneratedColumn<String>(
      'tagline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rawDownloadLinksMeta =
      const VerificationMeta('rawDownloadLinks');
  @override
  late final GeneratedColumn<String> rawDownloadLinks = GeneratedColumn<String>(
      'raw_download_links', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<VideoInfo>?, String> videos =
      GeneratedColumn<String>('videos', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<VideoInfo>?>($MoviesTable.$convertervideosn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        originalTitle,
        overview,
        releaseDate,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        popularity,
        adult,
        runtime,
        status,
        tagline,
        source,
        rawDownloadLinks,
        videos
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movies';
  @override
  VerificationContext validateIntegrity(Insertable<Movie> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_title')) {
      context.handle(
          _originalTitleMeta,
          originalTitle.isAcceptableOrUnknown(
              data['original_title']!, _originalTitleMeta));
    } else if (isInserting) {
      context.missing(_originalTitleMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('poster_path')) {
      context.handle(
          _posterPathMeta,
          posterPath.isAcceptableOrUnknown(
              data['poster_path']!, _posterPathMeta));
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
          _backdropPathMeta,
          backdropPath.isAcceptableOrUnknown(
              data['backdrop_path']!, _backdropPathMeta));
    }
    if (data.containsKey('vote_average')) {
      context.handle(
          _voteAverageMeta,
          voteAverage.isAcceptableOrUnknown(
              data['vote_average']!, _voteAverageMeta));
    }
    if (data.containsKey('vote_count')) {
      context.handle(_voteCountMeta,
          voteCount.isAcceptableOrUnknown(data['vote_count']!, _voteCountMeta));
    }
    if (data.containsKey('popularity')) {
      context.handle(
          _popularityMeta,
          popularity.isAcceptableOrUnknown(
              data['popularity']!, _popularityMeta));
    }
    if (data.containsKey('adult')) {
      context.handle(
          _adultMeta, adult.isAcceptableOrUnknown(data['adult']!, _adultMeta));
    }
    if (data.containsKey('runtime')) {
      context.handle(_runtimeMeta,
          runtime.isAcceptableOrUnknown(data['runtime']!, _runtimeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('tagline')) {
      context.handle(_taglineMeta,
          tagline.isAcceptableOrUnknown(data['tagline']!, _taglineMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('raw_download_links')) {
      context.handle(
          _rawDownloadLinksMeta,
          rawDownloadLinks.isAcceptableOrUnknown(
              data['raw_download_links']!, _rawDownloadLinksMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movie(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      originalTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_title'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview']),
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}release_date']),
      posterPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poster_path']),
      backdropPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}backdrop_path']),
      voteAverage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vote_average'])!,
      voteCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vote_count'])!,
      popularity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}popularity'])!,
      adult: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}adult'])!,
      runtime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}runtime']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      tagline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tagline']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      rawDownloadLinks: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}raw_download_links']),
      videos: $MoviesTable.$convertervideosn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}videos'])),
    );
  }

  @override
  $MoviesTable createAlias(String alias) {
    return $MoviesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<VideoInfo>, String> $convertervideos =
      const VideoInfoListConverter();
  static TypeConverter<List<VideoInfo>?, String?> $convertervideosn =
      NullAwareTypeConverter.wrap($convertervideos);
}

class Movie extends DataClass implements Insertable<Movie> {
  final int id;
  final String title;
  final String originalTitle;
  final String? overview;
  final String? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final bool adult;
  final int? runtime;
  final String? status;
  final String? tagline;
  final String? source;
  final String? rawDownloadLinks;
  final List<VideoInfo>? videos;
  const Movie(
      {required this.id,
      required this.title,
      required this.originalTitle,
      this.overview,
      this.releaseDate,
      this.posterPath,
      this.backdropPath,
      required this.voteAverage,
      required this.voteCount,
      required this.popularity,
      required this.adult,
      this.runtime,
      this.status,
      this.tagline,
      this.source,
      this.rawDownloadLinks,
      this.videos});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['original_title'] = Variable<String>(originalTitle);
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<String>(releaseDate);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || backdropPath != null) {
      map['backdrop_path'] = Variable<String>(backdropPath);
    }
    map['vote_average'] = Variable<double>(voteAverage);
    map['vote_count'] = Variable<int>(voteCount);
    map['popularity'] = Variable<double>(popularity);
    map['adult'] = Variable<bool>(adult);
    if (!nullToAbsent || runtime != null) {
      map['runtime'] = Variable<int>(runtime);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || tagline != null) {
      map['tagline'] = Variable<String>(tagline);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || rawDownloadLinks != null) {
      map['raw_download_links'] = Variable<String>(rawDownloadLinks);
    }
    if (!nullToAbsent || videos != null) {
      map['videos'] =
          Variable<String>($MoviesTable.$convertervideosn.toSql(videos));
    }
    return map;
  }

  MoviesCompanion toCompanion(bool nullToAbsent) {
    return MoviesCompanion(
      id: Value(id),
      title: Value(title),
      originalTitle: Value(originalTitle),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      backdropPath: backdropPath == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropPath),
      voteAverage: Value(voteAverage),
      voteCount: Value(voteCount),
      popularity: Value(popularity),
      adult: Value(adult),
      runtime: runtime == null && nullToAbsent
          ? const Value.absent()
          : Value(runtime),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      tagline: tagline == null && nullToAbsent
          ? const Value.absent()
          : Value(tagline),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      rawDownloadLinks: rawDownloadLinks == null && nullToAbsent
          ? const Value.absent()
          : Value(rawDownloadLinks),
      videos:
          videos == null && nullToAbsent ? const Value.absent() : Value(videos),
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movie(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      originalTitle: serializer.fromJson<String>(json['originalTitle']),
      overview: serializer.fromJson<String?>(json['overview']),
      releaseDate: serializer.fromJson<String?>(json['releaseDate']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      backdropPath: serializer.fromJson<String?>(json['backdropPath']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      voteCount: serializer.fromJson<int>(json['voteCount']),
      popularity: serializer.fromJson<double>(json['popularity']),
      adult: serializer.fromJson<bool>(json['adult']),
      runtime: serializer.fromJson<int?>(json['runtime']),
      status: serializer.fromJson<String?>(json['status']),
      tagline: serializer.fromJson<String?>(json['tagline']),
      source: serializer.fromJson<String?>(json['source']),
      rawDownloadLinks: serializer.fromJson<String?>(json['rawDownloadLinks']),
      videos: serializer.fromJson<List<VideoInfo>?>(json['videos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'originalTitle': serializer.toJson<String>(originalTitle),
      'overview': serializer.toJson<String?>(overview),
      'releaseDate': serializer.toJson<String?>(releaseDate),
      'posterPath': serializer.toJson<String?>(posterPath),
      'backdropPath': serializer.toJson<String?>(backdropPath),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'voteCount': serializer.toJson<int>(voteCount),
      'popularity': serializer.toJson<double>(popularity),
      'adult': serializer.toJson<bool>(adult),
      'runtime': serializer.toJson<int?>(runtime),
      'status': serializer.toJson<String?>(status),
      'tagline': serializer.toJson<String?>(tagline),
      'source': serializer.toJson<String?>(source),
      'rawDownloadLinks': serializer.toJson<String?>(rawDownloadLinks),
      'videos': serializer.toJson<List<VideoInfo>?>(videos),
    };
  }

  Movie copyWith(
          {int? id,
          String? title,
          String? originalTitle,
          Value<String?> overview = const Value.absent(),
          Value<String?> releaseDate = const Value.absent(),
          Value<String?> posterPath = const Value.absent(),
          Value<String?> backdropPath = const Value.absent(),
          double? voteAverage,
          int? voteCount,
          double? popularity,
          bool? adult,
          Value<int?> runtime = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> tagline = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> rawDownloadLinks = const Value.absent(),
          Value<List<VideoInfo>?> videos = const Value.absent()}) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        originalTitle: originalTitle ?? this.originalTitle,
        overview: overview.present ? overview.value : this.overview,
        releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
        posterPath: posterPath.present ? posterPath.value : this.posterPath,
        backdropPath:
            backdropPath.present ? backdropPath.value : this.backdropPath,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
        popularity: popularity ?? this.popularity,
        adult: adult ?? this.adult,
        runtime: runtime.present ? runtime.value : this.runtime,
        status: status.present ? status.value : this.status,
        tagline: tagline.present ? tagline.value : this.tagline,
        source: source.present ? source.value : this.source,
        rawDownloadLinks: rawDownloadLinks.present
            ? rawDownloadLinks.value
            : this.rawDownloadLinks,
        videos: videos.present ? videos.value : this.videos,
      );
  Movie copyWithCompanion(MoviesCompanion data) {
    return Movie(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      originalTitle: data.originalTitle.present
          ? data.originalTitle.value
          : this.originalTitle,
      overview: data.overview.present ? data.overview.value : this.overview,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      voteAverage:
          data.voteAverage.present ? data.voteAverage.value : this.voteAverage,
      voteCount: data.voteCount.present ? data.voteCount.value : this.voteCount,
      popularity:
          data.popularity.present ? data.popularity.value : this.popularity,
      adult: data.adult.present ? data.adult.value : this.adult,
      runtime: data.runtime.present ? data.runtime.value : this.runtime,
      status: data.status.present ? data.status.value : this.status,
      tagline: data.tagline.present ? data.tagline.value : this.tagline,
      source: data.source.present ? data.source.value : this.source,
      rawDownloadLinks: data.rawDownloadLinks.present
          ? data.rawDownloadLinks.value
          : this.rawDownloadLinks,
      videos: data.videos.present ? data.videos.value : this.videos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movie(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('voteCount: $voteCount, ')
          ..write('popularity: $popularity, ')
          ..write('adult: $adult, ')
          ..write('runtime: $runtime, ')
          ..write('status: $status, ')
          ..write('tagline: $tagline, ')
          ..write('source: $source, ')
          ..write('rawDownloadLinks: $rawDownloadLinks, ')
          ..write('videos: $videos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      originalTitle,
      overview,
      releaseDate,
      posterPath,
      backdropPath,
      voteAverage,
      voteCount,
      popularity,
      adult,
      runtime,
      status,
      tagline,
      source,
      rawDownloadLinks,
      videos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movie &&
          other.id == this.id &&
          other.title == this.title &&
          other.originalTitle == this.originalTitle &&
          other.overview == this.overview &&
          other.releaseDate == this.releaseDate &&
          other.posterPath == this.posterPath &&
          other.backdropPath == this.backdropPath &&
          other.voteAverage == this.voteAverage &&
          other.voteCount == this.voteCount &&
          other.popularity == this.popularity &&
          other.adult == this.adult &&
          other.runtime == this.runtime &&
          other.status == this.status &&
          other.tagline == this.tagline &&
          other.source == this.source &&
          other.rawDownloadLinks == this.rawDownloadLinks &&
          other.videos == this.videos);
}

class MoviesCompanion extends UpdateCompanion<Movie> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> originalTitle;
  final Value<String?> overview;
  final Value<String?> releaseDate;
  final Value<String?> posterPath;
  final Value<String?> backdropPath;
  final Value<double> voteAverage;
  final Value<int> voteCount;
  final Value<double> popularity;
  final Value<bool> adult;
  final Value<int?> runtime;
  final Value<String?> status;
  final Value<String?> tagline;
  final Value<String?> source;
  final Value<String?> rawDownloadLinks;
  final Value<List<VideoInfo>?> videos;
  const MoviesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.voteCount = const Value.absent(),
    this.popularity = const Value.absent(),
    this.adult = const Value.absent(),
    this.runtime = const Value.absent(),
    this.status = const Value.absent(),
    this.tagline = const Value.absent(),
    this.source = const Value.absent(),
    this.rawDownloadLinks = const Value.absent(),
    this.videos = const Value.absent(),
  });
  MoviesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String originalTitle,
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.voteCount = const Value.absent(),
    this.popularity = const Value.absent(),
    this.adult = const Value.absent(),
    this.runtime = const Value.absent(),
    this.status = const Value.absent(),
    this.tagline = const Value.absent(),
    this.source = const Value.absent(),
    this.rawDownloadLinks = const Value.absent(),
    this.videos = const Value.absent(),
  })  : title = Value(title),
        originalTitle = Value(originalTitle);
  static Insertable<Movie> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? originalTitle,
    Expression<String>? overview,
    Expression<String>? releaseDate,
    Expression<String>? posterPath,
    Expression<String>? backdropPath,
    Expression<double>? voteAverage,
    Expression<int>? voteCount,
    Expression<double>? popularity,
    Expression<bool>? adult,
    Expression<int>? runtime,
    Expression<String>? status,
    Expression<String>? tagline,
    Expression<String>? source,
    Expression<String>? rawDownloadLinks,
    Expression<String>? videos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (originalTitle != null) 'original_title': originalTitle,
      if (overview != null) 'overview': overview,
      if (releaseDate != null) 'release_date': releaseDate,
      if (posterPath != null) 'poster_path': posterPath,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (voteCount != null) 'vote_count': voteCount,
      if (popularity != null) 'popularity': popularity,
      if (adult != null) 'adult': adult,
      if (runtime != null) 'runtime': runtime,
      if (status != null) 'status': status,
      if (tagline != null) 'tagline': tagline,
      if (source != null) 'source': source,
      if (rawDownloadLinks != null) 'raw_download_links': rawDownloadLinks,
      if (videos != null) 'videos': videos,
    });
  }

  MoviesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? originalTitle,
      Value<String?>? overview,
      Value<String?>? releaseDate,
      Value<String?>? posterPath,
      Value<String?>? backdropPath,
      Value<double>? voteAverage,
      Value<int>? voteCount,
      Value<double>? popularity,
      Value<bool>? adult,
      Value<int?>? runtime,
      Value<String?>? status,
      Value<String?>? tagline,
      Value<String?>? source,
      Value<String?>? rawDownloadLinks,
      Value<List<VideoInfo>?>? videos}) {
    return MoviesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      adult: adult ?? this.adult,
      runtime: runtime ?? this.runtime,
      status: status ?? this.status,
      tagline: tagline ?? this.tagline,
      source: source ?? this.source,
      rawDownloadLinks: rawDownloadLinks ?? this.rawDownloadLinks,
      videos: videos ?? this.videos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalTitle.present) {
      map['original_title'] = Variable<String>(originalTitle.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(releaseDate.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (voteCount.present) {
      map['vote_count'] = Variable<int>(voteCount.value);
    }
    if (popularity.present) {
      map['popularity'] = Variable<double>(popularity.value);
    }
    if (adult.present) {
      map['adult'] = Variable<bool>(adult.value);
    }
    if (runtime.present) {
      map['runtime'] = Variable<int>(runtime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tagline.present) {
      map['tagline'] = Variable<String>(tagline.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rawDownloadLinks.present) {
      map['raw_download_links'] = Variable<String>(rawDownloadLinks.value);
    }
    if (videos.present) {
      map['videos'] =
          Variable<String>($MoviesTable.$convertervideosn.toSql(videos.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('voteCount: $voteCount, ')
          ..write('popularity: $popularity, ')
          ..write('adult: $adult, ')
          ..write('runtime: $runtime, ')
          ..write('status: $status, ')
          ..write('tagline: $tagline, ')
          ..write('source: $source, ')
          ..write('rawDownloadLinks: $rawDownloadLinks, ')
          ..write('videos: $videos')
          ..write(')'))
        .toString();
  }
}

class $TvShowsTable extends TvShows with TableInfo<$TvShowsTable, TvShow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvShowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalNameMeta =
      const VerificationMeta('originalName');
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
      'original_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _firstAirDateMeta =
      const VerificationMeta('firstAirDate');
  @override
  late final GeneratedColumn<String> firstAirDate = GeneratedColumn<String>(
      'first_air_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _posterPathMeta =
      const VerificationMeta('posterPath');
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
      'poster_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backdropPathMeta =
      const VerificationMeta('backdropPath');
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
      'backdrop_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voteAverageMeta =
      const VerificationMeta('voteAverage');
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
      'vote_average', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _voteCountMeta =
      const VerificationMeta('voteCount');
  @override
  late final GeneratedColumn<int> voteCount = GeneratedColumn<int>(
      'vote_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _popularityMeta =
      const VerificationMeta('popularity');
  @override
  late final GeneratedColumn<double> popularity = GeneratedColumn<double>(
      'popularity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<VideoInfo>?, String> videos =
      GeneratedColumn<String>('videos', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<VideoInfo>?>($TvShowsTable.$convertervideosn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        originalName,
        overview,
        firstAirDate,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        popularity,
        status,
        type,
        source,
        videos
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_shows';
  @override
  VerificationContext validateIntegrity(Insertable<TvShow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
          _originalNameMeta,
          originalName.isAcceptableOrUnknown(
              data['original_name']!, _originalNameMeta));
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    }
    if (data.containsKey('first_air_date')) {
      context.handle(
          _firstAirDateMeta,
          firstAirDate.isAcceptableOrUnknown(
              data['first_air_date']!, _firstAirDateMeta));
    }
    if (data.containsKey('poster_path')) {
      context.handle(
          _posterPathMeta,
          posterPath.isAcceptableOrUnknown(
              data['poster_path']!, _posterPathMeta));
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
          _backdropPathMeta,
          backdropPath.isAcceptableOrUnknown(
              data['backdrop_path']!, _backdropPathMeta));
    }
    if (data.containsKey('vote_average')) {
      context.handle(
          _voteAverageMeta,
          voteAverage.isAcceptableOrUnknown(
              data['vote_average']!, _voteAverageMeta));
    }
    if (data.containsKey('vote_count')) {
      context.handle(_voteCountMeta,
          voteCount.isAcceptableOrUnknown(data['vote_count']!, _voteCountMeta));
    }
    if (data.containsKey('popularity')) {
      context.handle(
          _popularityMeta,
          popularity.isAcceptableOrUnknown(
              data['popularity']!, _popularityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TvShow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvShow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      originalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_name'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview']),
      firstAirDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_air_date']),
      posterPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poster_path']),
      backdropPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}backdrop_path']),
      voteAverage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vote_average'])!,
      voteCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vote_count'])!,
      popularity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}popularity'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      videos: $TvShowsTable.$convertervideosn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}videos'])),
    );
  }

  @override
  $TvShowsTable createAlias(String alias) {
    return $TvShowsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<VideoInfo>, String> $convertervideos =
      const VideoInfoListConverter();
  static TypeConverter<List<VideoInfo>?, String?> $convertervideosn =
      NullAwareTypeConverter.wrap($convertervideos);
}

class TvShow extends DataClass implements Insertable<TvShow> {
  final int id;
  final String name;
  final String originalName;
  final String? overview;
  final String? firstAirDate;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String? status;
  final String? type;
  final String? source;
  final List<VideoInfo>? videos;
  const TvShow(
      {required this.id,
      required this.name,
      required this.originalName,
      this.overview,
      this.firstAirDate,
      this.posterPath,
      this.backdropPath,
      required this.voteAverage,
      required this.voteCount,
      required this.popularity,
      this.status,
      this.type,
      this.source,
      this.videos});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['original_name'] = Variable<String>(originalName);
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || firstAirDate != null) {
      map['first_air_date'] = Variable<String>(firstAirDate);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || backdropPath != null) {
      map['backdrop_path'] = Variable<String>(backdropPath);
    }
    map['vote_average'] = Variable<double>(voteAverage);
    map['vote_count'] = Variable<int>(voteCount);
    map['popularity'] = Variable<double>(popularity);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || videos != null) {
      map['videos'] =
          Variable<String>($TvShowsTable.$convertervideosn.toSql(videos));
    }
    return map;
  }

  TvShowsCompanion toCompanion(bool nullToAbsent) {
    return TvShowsCompanion(
      id: Value(id),
      name: Value(name),
      originalName: Value(originalName),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      firstAirDate: firstAirDate == null && nullToAbsent
          ? const Value.absent()
          : Value(firstAirDate),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      backdropPath: backdropPath == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropPath),
      voteAverage: Value(voteAverage),
      voteCount: Value(voteCount),
      popularity: Value(popularity),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      videos:
          videos == null && nullToAbsent ? const Value.absent() : Value(videos),
    );
  }

  factory TvShow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvShow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      originalName: serializer.fromJson<String>(json['originalName']),
      overview: serializer.fromJson<String?>(json['overview']),
      firstAirDate: serializer.fromJson<String?>(json['firstAirDate']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      backdropPath: serializer.fromJson<String?>(json['backdropPath']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      voteCount: serializer.fromJson<int>(json['voteCount']),
      popularity: serializer.fromJson<double>(json['popularity']),
      status: serializer.fromJson<String?>(json['status']),
      type: serializer.fromJson<String?>(json['type']),
      source: serializer.fromJson<String?>(json['source']),
      videos: serializer.fromJson<List<VideoInfo>?>(json['videos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'originalName': serializer.toJson<String>(originalName),
      'overview': serializer.toJson<String?>(overview),
      'firstAirDate': serializer.toJson<String?>(firstAirDate),
      'posterPath': serializer.toJson<String?>(posterPath),
      'backdropPath': serializer.toJson<String?>(backdropPath),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'voteCount': serializer.toJson<int>(voteCount),
      'popularity': serializer.toJson<double>(popularity),
      'status': serializer.toJson<String?>(status),
      'type': serializer.toJson<String?>(type),
      'source': serializer.toJson<String?>(source),
      'videos': serializer.toJson<List<VideoInfo>?>(videos),
    };
  }

  TvShow copyWith(
          {int? id,
          String? name,
          String? originalName,
          Value<String?> overview = const Value.absent(),
          Value<String?> firstAirDate = const Value.absent(),
          Value<String?> posterPath = const Value.absent(),
          Value<String?> backdropPath = const Value.absent(),
          double? voteAverage,
          int? voteCount,
          double? popularity,
          Value<String?> status = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<List<VideoInfo>?> videos = const Value.absent()}) =>
      TvShow(
        id: id ?? this.id,
        name: name ?? this.name,
        originalName: originalName ?? this.originalName,
        overview: overview.present ? overview.value : this.overview,
        firstAirDate:
            firstAirDate.present ? firstAirDate.value : this.firstAirDate,
        posterPath: posterPath.present ? posterPath.value : this.posterPath,
        backdropPath:
            backdropPath.present ? backdropPath.value : this.backdropPath,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
        popularity: popularity ?? this.popularity,
        status: status.present ? status.value : this.status,
        type: type.present ? type.value : this.type,
        source: source.present ? source.value : this.source,
        videos: videos.present ? videos.value : this.videos,
      );
  TvShow copyWithCompanion(TvShowsCompanion data) {
    return TvShow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      overview: data.overview.present ? data.overview.value : this.overview,
      firstAirDate: data.firstAirDate.present
          ? data.firstAirDate.value
          : this.firstAirDate,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      voteAverage:
          data.voteAverage.present ? data.voteAverage.value : this.voteAverage,
      voteCount: data.voteCount.present ? data.voteCount.value : this.voteCount,
      popularity:
          data.popularity.present ? data.popularity.value : this.popularity,
      status: data.status.present ? data.status.value : this.status,
      type: data.type.present ? data.type.value : this.type,
      source: data.source.present ? data.source.value : this.source,
      videos: data.videos.present ? data.videos.value : this.videos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvShow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('originalName: $originalName, ')
          ..write('overview: $overview, ')
          ..write('firstAirDate: $firstAirDate, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('voteCount: $voteCount, ')
          ..write('popularity: $popularity, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('videos: $videos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      originalName,
      overview,
      firstAirDate,
      posterPath,
      backdropPath,
      voteAverage,
      voteCount,
      popularity,
      status,
      type,
      source,
      videos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvShow &&
          other.id == this.id &&
          other.name == this.name &&
          other.originalName == this.originalName &&
          other.overview == this.overview &&
          other.firstAirDate == this.firstAirDate &&
          other.posterPath == this.posterPath &&
          other.backdropPath == this.backdropPath &&
          other.voteAverage == this.voteAverage &&
          other.voteCount == this.voteCount &&
          other.popularity == this.popularity &&
          other.status == this.status &&
          other.type == this.type &&
          other.source == this.source &&
          other.videos == this.videos);
}

class TvShowsCompanion extends UpdateCompanion<TvShow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> originalName;
  final Value<String?> overview;
  final Value<String?> firstAirDate;
  final Value<String?> posterPath;
  final Value<String?> backdropPath;
  final Value<double> voteAverage;
  final Value<int> voteCount;
  final Value<double> popularity;
  final Value<String?> status;
  final Value<String?> type;
  final Value<String?> source;
  final Value<List<VideoInfo>?> videos;
  const TvShowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.originalName = const Value.absent(),
    this.overview = const Value.absent(),
    this.firstAirDate = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.voteCount = const Value.absent(),
    this.popularity = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.videos = const Value.absent(),
  });
  TvShowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String originalName,
    this.overview = const Value.absent(),
    this.firstAirDate = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.voteCount = const Value.absent(),
    this.popularity = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.videos = const Value.absent(),
  })  : name = Value(name),
        originalName = Value(originalName);
  static Insertable<TvShow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? originalName,
    Expression<String>? overview,
    Expression<String>? firstAirDate,
    Expression<String>? posterPath,
    Expression<String>? backdropPath,
    Expression<double>? voteAverage,
    Expression<int>? voteCount,
    Expression<double>? popularity,
    Expression<String>? status,
    Expression<String>? type,
    Expression<String>? source,
    Expression<String>? videos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (originalName != null) 'original_name': originalName,
      if (overview != null) 'overview': overview,
      if (firstAirDate != null) 'first_air_date': firstAirDate,
      if (posterPath != null) 'poster_path': posterPath,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (voteCount != null) 'vote_count': voteCount,
      if (popularity != null) 'popularity': popularity,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (source != null) 'source': source,
      if (videos != null) 'videos': videos,
    });
  }

  TvShowsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? originalName,
      Value<String?>? overview,
      Value<String?>? firstAirDate,
      Value<String?>? posterPath,
      Value<String?>? backdropPath,
      Value<double>? voteAverage,
      Value<int>? voteCount,
      Value<double>? popularity,
      Value<String?>? status,
      Value<String?>? type,
      Value<String?>? source,
      Value<List<VideoInfo>?>? videos}) {
    return TvShowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      overview: overview ?? this.overview,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      status: status ?? this.status,
      type: type ?? this.type,
      source: source ?? this.source,
      videos: videos ?? this.videos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (firstAirDate.present) {
      map['first_air_date'] = Variable<String>(firstAirDate.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (voteCount.present) {
      map['vote_count'] = Variable<int>(voteCount.value);
    }
    if (popularity.present) {
      map['popularity'] = Variable<double>(popularity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (videos.present) {
      map['videos'] =
          Variable<String>($TvShowsTable.$convertervideosn.toSql(videos.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvShowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('originalName: $originalName, ')
          ..write('overview: $overview, ')
          ..write('firstAirDate: $firstAirDate, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('voteCount: $voteCount, ')
          ..write('popularity: $popularity, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('videos: $videos')
          ..write(')'))
        .toString();
  }
}

class $SeasonsTable extends Seasons with TableInfo<$SeasonsTable, Season> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tvShowIdMeta =
      const VerificationMeta('tvShowId');
  @override
  late final GeneratedColumn<int> tvShowId = GeneratedColumn<int>(
      'tv_show_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tv_shows (id)'));
  static const VerificationMeta _seasonNumberMeta =
      const VerificationMeta('seasonNumber');
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
      'season_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _airDateMeta =
      const VerificationMeta('airDate');
  @override
  late final GeneratedColumn<String> airDate = GeneratedColumn<String>(
      'air_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _posterPathMeta =
      const VerificationMeta('posterPath');
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
      'poster_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _episodeCountMeta =
      const VerificationMeta('episodeCount');
  @override
  late final GeneratedColumn<int> episodeCount = GeneratedColumn<int>(
      'episode_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tvShowId,
        seasonNumber,
        name,
        overview,
        airDate,
        posterPath,
        episodeCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seasons';
  @override
  VerificationContext validateIntegrity(Insertable<Season> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tv_show_id')) {
      context.handle(_tvShowIdMeta,
          tvShowId.isAcceptableOrUnknown(data['tv_show_id']!, _tvShowIdMeta));
    } else if (isInserting) {
      context.missing(_tvShowIdMeta);
    }
    if (data.containsKey('season_number')) {
      context.handle(
          _seasonNumberMeta,
          seasonNumber.isAcceptableOrUnknown(
              data['season_number']!, _seasonNumberMeta));
    } else if (isInserting) {
      context.missing(_seasonNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    }
    if (data.containsKey('air_date')) {
      context.handle(_airDateMeta,
          airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta));
    }
    if (data.containsKey('poster_path')) {
      context.handle(
          _posterPathMeta,
          posterPath.isAcceptableOrUnknown(
              data['poster_path']!, _posterPathMeta));
    }
    if (data.containsKey('episode_count')) {
      context.handle(
          _episodeCountMeta,
          episodeCount.isAcceptableOrUnknown(
              data['episode_count']!, _episodeCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Season map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Season(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tvShowId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tv_show_id'])!,
      seasonNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview']),
      airDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}air_date']),
      posterPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poster_path']),
      episodeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}episode_count']),
    );
  }

  @override
  $SeasonsTable createAlias(String alias) {
    return $SeasonsTable(attachedDatabase, alias);
  }
}

class Season extends DataClass implements Insertable<Season> {
  final int id;
  final int tvShowId;
  final int seasonNumber;
  final String? name;
  final String? overview;
  final String? airDate;
  final String? posterPath;
  final int? episodeCount;
  const Season(
      {required this.id,
      required this.tvShowId,
      required this.seasonNumber,
      this.name,
      this.overview,
      this.airDate,
      this.posterPath,
      this.episodeCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tv_show_id'] = Variable<int>(tvShowId);
    map['season_number'] = Variable<int>(seasonNumber);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || airDate != null) {
      map['air_date'] = Variable<String>(airDate);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || episodeCount != null) {
      map['episode_count'] = Variable<int>(episodeCount);
    }
    return map;
  }

  SeasonsCompanion toCompanion(bool nullToAbsent) {
    return SeasonsCompanion(
      id: Value(id),
      tvShowId: Value(tvShowId),
      seasonNumber: Value(seasonNumber),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      airDate: airDate == null && nullToAbsent
          ? const Value.absent()
          : Value(airDate),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      episodeCount: episodeCount == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeCount),
    );
  }

  factory Season.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Season(
      id: serializer.fromJson<int>(json['id']),
      tvShowId: serializer.fromJson<int>(json['tvShowId']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      name: serializer.fromJson<String?>(json['name']),
      overview: serializer.fromJson<String?>(json['overview']),
      airDate: serializer.fromJson<String?>(json['airDate']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      episodeCount: serializer.fromJson<int?>(json['episodeCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tvShowId': serializer.toJson<int>(tvShowId),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'name': serializer.toJson<String?>(name),
      'overview': serializer.toJson<String?>(overview),
      'airDate': serializer.toJson<String?>(airDate),
      'posterPath': serializer.toJson<String?>(posterPath),
      'episodeCount': serializer.toJson<int?>(episodeCount),
    };
  }

  Season copyWith(
          {int? id,
          int? tvShowId,
          int? seasonNumber,
          Value<String?> name = const Value.absent(),
          Value<String?> overview = const Value.absent(),
          Value<String?> airDate = const Value.absent(),
          Value<String?> posterPath = const Value.absent(),
          Value<int?> episodeCount = const Value.absent()}) =>
      Season(
        id: id ?? this.id,
        tvShowId: tvShowId ?? this.tvShowId,
        seasonNumber: seasonNumber ?? this.seasonNumber,
        name: name.present ? name.value : this.name,
        overview: overview.present ? overview.value : this.overview,
        airDate: airDate.present ? airDate.value : this.airDate,
        posterPath: posterPath.present ? posterPath.value : this.posterPath,
        episodeCount:
            episodeCount.present ? episodeCount.value : this.episodeCount,
      );
  Season copyWithCompanion(SeasonsCompanion data) {
    return Season(
      id: data.id.present ? data.id.value : this.id,
      tvShowId: data.tvShowId.present ? data.tvShowId.value : this.tvShowId,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      episodeCount: data.episodeCount.present
          ? data.episodeCount.value
          : this.episodeCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Season(')
          ..write('id: $id, ')
          ..write('tvShowId: $tvShowId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('posterPath: $posterPath, ')
          ..write('episodeCount: $episodeCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tvShowId, seasonNumber, name, overview,
      airDate, posterPath, episodeCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Season &&
          other.id == this.id &&
          other.tvShowId == this.tvShowId &&
          other.seasonNumber == this.seasonNumber &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.airDate == this.airDate &&
          other.posterPath == this.posterPath &&
          other.episodeCount == this.episodeCount);
}

class SeasonsCompanion extends UpdateCompanion<Season> {
  final Value<int> id;
  final Value<int> tvShowId;
  final Value<int> seasonNumber;
  final Value<String?> name;
  final Value<String?> overview;
  final Value<String?> airDate;
  final Value<String?> posterPath;
  final Value<int?> episodeCount;
  const SeasonsCompanion({
    this.id = const Value.absent(),
    this.tvShowId = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.airDate = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.episodeCount = const Value.absent(),
  });
  SeasonsCompanion.insert({
    this.id = const Value.absent(),
    required int tvShowId,
    required int seasonNumber,
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.airDate = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.episodeCount = const Value.absent(),
  })  : tvShowId = Value(tvShowId),
        seasonNumber = Value(seasonNumber);
  static Insertable<Season> custom({
    Expression<int>? id,
    Expression<int>? tvShowId,
    Expression<int>? seasonNumber,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? airDate,
    Expression<String>? posterPath,
    Expression<int>? episodeCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tvShowId != null) 'tv_show_id': tvShowId,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (airDate != null) 'air_date': airDate,
      if (posterPath != null) 'poster_path': posterPath,
      if (episodeCount != null) 'episode_count': episodeCount,
    });
  }

  SeasonsCompanion copyWith(
      {Value<int>? id,
      Value<int>? tvShowId,
      Value<int>? seasonNumber,
      Value<String?>? name,
      Value<String?>? overview,
      Value<String?>? airDate,
      Value<String?>? posterPath,
      Value<int?>? episodeCount}) {
    return SeasonsCompanion(
      id: id ?? this.id,
      tvShowId: tvShowId ?? this.tvShowId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      airDate: airDate ?? this.airDate,
      posterPath: posterPath ?? this.posterPath,
      episodeCount: episodeCount ?? this.episodeCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tvShowId.present) {
      map['tv_show_id'] = Variable<int>(tvShowId.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<String>(airDate.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (episodeCount.present) {
      map['episode_count'] = Variable<int>(episodeCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonsCompanion(')
          ..write('id: $id, ')
          ..write('tvShowId: $tvShowId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('posterPath: $posterPath, ')
          ..write('episodeCount: $episodeCount')
          ..write(')'))
        .toString();
  }
}

class $EpisodesTable extends Episodes with TableInfo<$EpisodesTable, Episode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tvShowIdMeta =
      const VerificationMeta('tvShowId');
  @override
  late final GeneratedColumn<int> tvShowId = GeneratedColumn<int>(
      'tv_show_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tv_shows (id)'));
  static const VerificationMeta _seasonIdMeta =
      const VerificationMeta('seasonId');
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
      'season_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES seasons (id)'));
  static const VerificationMeta _seasonNumberMeta =
      const VerificationMeta('seasonNumber');
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
      'season_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _episodeNumberMeta =
      const VerificationMeta('episodeNumber');
  @override
  late final GeneratedColumn<int> episodeNumber = GeneratedColumn<int>(
      'episode_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _airDateMeta =
      const VerificationMeta('airDate');
  @override
  late final GeneratedColumn<String> airDate = GeneratedColumn<String>(
      'air_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stillPathMeta =
      const VerificationMeta('stillPath');
  @override
  late final GeneratedColumn<String> stillPath = GeneratedColumn<String>(
      'still_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _url1080pMeta =
      const VerificationMeta('url1080p');
  @override
  late final GeneratedColumn<String> url1080p = GeneratedColumn<String>(
      'url1080p', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _url720pMeta =
      const VerificationMeta('url720p');
  @override
  late final GeneratedColumn<String> url720p = GeneratedColumn<String>(
      'url720p', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _url540pMeta =
      const VerificationMeta('url540p');
  @override
  late final GeneratedColumn<String> url540p = GeneratedColumn<String>(
      'url540p', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _url480pMeta =
      const VerificationMeta('url480p');
  @override
  late final GeneratedColumn<String> url480p = GeneratedColumn<String>(
      'url480p', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dubbedUrlMeta =
      const VerificationMeta('dubbedUrl');
  @override
  late final GeneratedColumn<String> dubbedUrl = GeneratedColumn<String>(
      'dubbed_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tvShowId,
        seasonId,
        seasonNumber,
        episodeNumber,
        name,
        overview,
        airDate,
        stillPath,
        url1080p,
        url720p,
        url540p,
        url480p,
        dubbedUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes';
  @override
  VerificationContext validateIntegrity(Insertable<Episode> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tv_show_id')) {
      context.handle(_tvShowIdMeta,
          tvShowId.isAcceptableOrUnknown(data['tv_show_id']!, _tvShowIdMeta));
    } else if (isInserting) {
      context.missing(_tvShowIdMeta);
    }
    if (data.containsKey('season_id')) {
      context.handle(_seasonIdMeta,
          seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta));
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('season_number')) {
      context.handle(
          _seasonNumberMeta,
          seasonNumber.isAcceptableOrUnknown(
              data['season_number']!, _seasonNumberMeta));
    } else if (isInserting) {
      context.missing(_seasonNumberMeta);
    }
    if (data.containsKey('episode_number')) {
      context.handle(
          _episodeNumberMeta,
          episodeNumber.isAcceptableOrUnknown(
              data['episode_number']!, _episodeNumberMeta));
    } else if (isInserting) {
      context.missing(_episodeNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    }
    if (data.containsKey('air_date')) {
      context.handle(_airDateMeta,
          airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta));
    }
    if (data.containsKey('still_path')) {
      context.handle(_stillPathMeta,
          stillPath.isAcceptableOrUnknown(data['still_path']!, _stillPathMeta));
    }
    if (data.containsKey('url1080p')) {
      context.handle(_url1080pMeta,
          url1080p.isAcceptableOrUnknown(data['url1080p']!, _url1080pMeta));
    }
    if (data.containsKey('url720p')) {
      context.handle(_url720pMeta,
          url720p.isAcceptableOrUnknown(data['url720p']!, _url720pMeta));
    }
    if (data.containsKey('url540p')) {
      context.handle(_url540pMeta,
          url540p.isAcceptableOrUnknown(data['url540p']!, _url540pMeta));
    }
    if (data.containsKey('url480p')) {
      context.handle(_url480pMeta,
          url480p.isAcceptableOrUnknown(data['url480p']!, _url480pMeta));
    }
    if (data.containsKey('dubbed_url')) {
      context.handle(_dubbedUrlMeta,
          dubbedUrl.isAcceptableOrUnknown(data['dubbed_url']!, _dubbedUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Episode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Episode(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tvShowId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tv_show_id'])!,
      seasonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_id'])!,
      seasonNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_number'])!,
      episodeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}episode_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview']),
      airDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}air_date']),
      stillPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}still_path']),
      url1080p: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url1080p']),
      url720p: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url720p']),
      url540p: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url540p']),
      url480p: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url480p']),
      dubbedUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dubbed_url']),
    );
  }

  @override
  $EpisodesTable createAlias(String alias) {
    return $EpisodesTable(attachedDatabase, alias);
  }
}

class Episode extends DataClass implements Insertable<Episode> {
  final int id;
  final int tvShowId;
  final int seasonId;
  final int seasonNumber;
  final int episodeNumber;
  final String? name;
  final String? overview;
  final String? airDate;
  final String? stillPath;
  final String? url1080p;
  final String? url720p;
  final String? url540p;
  final String? url480p;
  final String? dubbedUrl;
  const Episode(
      {required this.id,
      required this.tvShowId,
      required this.seasonId,
      required this.seasonNumber,
      required this.episodeNumber,
      this.name,
      this.overview,
      this.airDate,
      this.stillPath,
      this.url1080p,
      this.url720p,
      this.url540p,
      this.url480p,
      this.dubbedUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tv_show_id'] = Variable<int>(tvShowId);
    map['season_id'] = Variable<int>(seasonId);
    map['season_number'] = Variable<int>(seasonNumber);
    map['episode_number'] = Variable<int>(episodeNumber);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || airDate != null) {
      map['air_date'] = Variable<String>(airDate);
    }
    if (!nullToAbsent || stillPath != null) {
      map['still_path'] = Variable<String>(stillPath);
    }
    if (!nullToAbsent || url1080p != null) {
      map['url1080p'] = Variable<String>(url1080p);
    }
    if (!nullToAbsent || url720p != null) {
      map['url720p'] = Variable<String>(url720p);
    }
    if (!nullToAbsent || url540p != null) {
      map['url540p'] = Variable<String>(url540p);
    }
    if (!nullToAbsent || url480p != null) {
      map['url480p'] = Variable<String>(url480p);
    }
    if (!nullToAbsent || dubbedUrl != null) {
      map['dubbed_url'] = Variable<String>(dubbedUrl);
    }
    return map;
  }

  EpisodesCompanion toCompanion(bool nullToAbsent) {
    return EpisodesCompanion(
      id: Value(id),
      tvShowId: Value(tvShowId),
      seasonId: Value(seasonId),
      seasonNumber: Value(seasonNumber),
      episodeNumber: Value(episodeNumber),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      airDate: airDate == null && nullToAbsent
          ? const Value.absent()
          : Value(airDate),
      stillPath: stillPath == null && nullToAbsent
          ? const Value.absent()
          : Value(stillPath),
      url1080p: url1080p == null && nullToAbsent
          ? const Value.absent()
          : Value(url1080p),
      url720p: url720p == null && nullToAbsent
          ? const Value.absent()
          : Value(url720p),
      url540p: url540p == null && nullToAbsent
          ? const Value.absent()
          : Value(url540p),
      url480p: url480p == null && nullToAbsent
          ? const Value.absent()
          : Value(url480p),
      dubbedUrl: dubbedUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(dubbedUrl),
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Episode(
      id: serializer.fromJson<int>(json['id']),
      tvShowId: serializer.fromJson<int>(json['tvShowId']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      episodeNumber: serializer.fromJson<int>(json['episodeNumber']),
      name: serializer.fromJson<String?>(json['name']),
      overview: serializer.fromJson<String?>(json['overview']),
      airDate: serializer.fromJson<String?>(json['airDate']),
      stillPath: serializer.fromJson<String?>(json['stillPath']),
      url1080p: serializer.fromJson<String?>(json['url1080p']),
      url720p: serializer.fromJson<String?>(json['url720p']),
      url540p: serializer.fromJson<String?>(json['url540p']),
      url480p: serializer.fromJson<String?>(json['url480p']),
      dubbedUrl: serializer.fromJson<String?>(json['dubbedUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tvShowId': serializer.toJson<int>(tvShowId),
      'seasonId': serializer.toJson<int>(seasonId),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'episodeNumber': serializer.toJson<int>(episodeNumber),
      'name': serializer.toJson<String?>(name),
      'overview': serializer.toJson<String?>(overview),
      'airDate': serializer.toJson<String?>(airDate),
      'stillPath': serializer.toJson<String?>(stillPath),
      'url1080p': serializer.toJson<String?>(url1080p),
      'url720p': serializer.toJson<String?>(url720p),
      'url540p': serializer.toJson<String?>(url540p),
      'url480p': serializer.toJson<String?>(url480p),
      'dubbedUrl': serializer.toJson<String?>(dubbedUrl),
    };
  }

  Episode copyWith(
          {int? id,
          int? tvShowId,
          int? seasonId,
          int? seasonNumber,
          int? episodeNumber,
          Value<String?> name = const Value.absent(),
          Value<String?> overview = const Value.absent(),
          Value<String?> airDate = const Value.absent(),
          Value<String?> stillPath = const Value.absent(),
          Value<String?> url1080p = const Value.absent(),
          Value<String?> url720p = const Value.absent(),
          Value<String?> url540p = const Value.absent(),
          Value<String?> url480p = const Value.absent(),
          Value<String?> dubbedUrl = const Value.absent()}) =>
      Episode(
        id: id ?? this.id,
        tvShowId: tvShowId ?? this.tvShowId,
        seasonId: seasonId ?? this.seasonId,
        seasonNumber: seasonNumber ?? this.seasonNumber,
        episodeNumber: episodeNumber ?? this.episodeNumber,
        name: name.present ? name.value : this.name,
        overview: overview.present ? overview.value : this.overview,
        airDate: airDate.present ? airDate.value : this.airDate,
        stillPath: stillPath.present ? stillPath.value : this.stillPath,
        url1080p: url1080p.present ? url1080p.value : this.url1080p,
        url720p: url720p.present ? url720p.value : this.url720p,
        url540p: url540p.present ? url540p.value : this.url540p,
        url480p: url480p.present ? url480p.value : this.url480p,
        dubbedUrl: dubbedUrl.present ? dubbedUrl.value : this.dubbedUrl,
      );
  Episode copyWithCompanion(EpisodesCompanion data) {
    return Episode(
      id: data.id.present ? data.id.value : this.id,
      tvShowId: data.tvShowId.present ? data.tvShowId.value : this.tvShowId,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      episodeNumber: data.episodeNumber.present
          ? data.episodeNumber.value
          : this.episodeNumber,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      stillPath: data.stillPath.present ? data.stillPath.value : this.stillPath,
      url1080p: data.url1080p.present ? data.url1080p.value : this.url1080p,
      url720p: data.url720p.present ? data.url720p.value : this.url720p,
      url540p: data.url540p.present ? data.url540p.value : this.url540p,
      url480p: data.url480p.present ? data.url480p.value : this.url480p,
      dubbedUrl: data.dubbedUrl.present ? data.dubbedUrl.value : this.dubbedUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Episode(')
          ..write('id: $id, ')
          ..write('tvShowId: $tvShowId, ')
          ..write('seasonId: $seasonId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('stillPath: $stillPath, ')
          ..write('url1080p: $url1080p, ')
          ..write('url720p: $url720p, ')
          ..write('url540p: $url540p, ')
          ..write('url480p: $url480p, ')
          ..write('dubbedUrl: $dubbedUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tvShowId,
      seasonId,
      seasonNumber,
      episodeNumber,
      name,
      overview,
      airDate,
      stillPath,
      url1080p,
      url720p,
      url540p,
      url480p,
      dubbedUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Episode &&
          other.id == this.id &&
          other.tvShowId == this.tvShowId &&
          other.seasonId == this.seasonId &&
          other.seasonNumber == this.seasonNumber &&
          other.episodeNumber == this.episodeNumber &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.airDate == this.airDate &&
          other.stillPath == this.stillPath &&
          other.url1080p == this.url1080p &&
          other.url720p == this.url720p &&
          other.url540p == this.url540p &&
          other.url480p == this.url480p &&
          other.dubbedUrl == this.dubbedUrl);
}

class EpisodesCompanion extends UpdateCompanion<Episode> {
  final Value<int> id;
  final Value<int> tvShowId;
  final Value<int> seasonId;
  final Value<int> seasonNumber;
  final Value<int> episodeNumber;
  final Value<String?> name;
  final Value<String?> overview;
  final Value<String?> airDate;
  final Value<String?> stillPath;
  final Value<String?> url1080p;
  final Value<String?> url720p;
  final Value<String?> url540p;
  final Value<String?> url480p;
  final Value<String?> dubbedUrl;
  const EpisodesCompanion({
    this.id = const Value.absent(),
    this.tvShowId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.airDate = const Value.absent(),
    this.stillPath = const Value.absent(),
    this.url1080p = const Value.absent(),
    this.url720p = const Value.absent(),
    this.url540p = const Value.absent(),
    this.url480p = const Value.absent(),
    this.dubbedUrl = const Value.absent(),
  });
  EpisodesCompanion.insert({
    this.id = const Value.absent(),
    required int tvShowId,
    required int seasonId,
    required int seasonNumber,
    required int episodeNumber,
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.airDate = const Value.absent(),
    this.stillPath = const Value.absent(),
    this.url1080p = const Value.absent(),
    this.url720p = const Value.absent(),
    this.url540p = const Value.absent(),
    this.url480p = const Value.absent(),
    this.dubbedUrl = const Value.absent(),
  })  : tvShowId = Value(tvShowId),
        seasonId = Value(seasonId),
        seasonNumber = Value(seasonNumber),
        episodeNumber = Value(episodeNumber);
  static Insertable<Episode> custom({
    Expression<int>? id,
    Expression<int>? tvShowId,
    Expression<int>? seasonId,
    Expression<int>? seasonNumber,
    Expression<int>? episodeNumber,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? airDate,
    Expression<String>? stillPath,
    Expression<String>? url1080p,
    Expression<String>? url720p,
    Expression<String>? url540p,
    Expression<String>? url480p,
    Expression<String>? dubbedUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tvShowId != null) 'tv_show_id': tvShowId,
      if (seasonId != null) 'season_id': seasonId,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (episodeNumber != null) 'episode_number': episodeNumber,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (airDate != null) 'air_date': airDate,
      if (stillPath != null) 'still_path': stillPath,
      if (url1080p != null) 'url1080p': url1080p,
      if (url720p != null) 'url720p': url720p,
      if (url540p != null) 'url540p': url540p,
      if (url480p != null) 'url480p': url480p,
      if (dubbedUrl != null) 'dubbed_url': dubbedUrl,
    });
  }

  EpisodesCompanion copyWith(
      {Value<int>? id,
      Value<int>? tvShowId,
      Value<int>? seasonId,
      Value<int>? seasonNumber,
      Value<int>? episodeNumber,
      Value<String?>? name,
      Value<String?>? overview,
      Value<String?>? airDate,
      Value<String?>? stillPath,
      Value<String?>? url1080p,
      Value<String?>? url720p,
      Value<String?>? url540p,
      Value<String?>? url480p,
      Value<String?>? dubbedUrl}) {
    return EpisodesCompanion(
      id: id ?? this.id,
      tvShowId: tvShowId ?? this.tvShowId,
      seasonId: seasonId ?? this.seasonId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      airDate: airDate ?? this.airDate,
      stillPath: stillPath ?? this.stillPath,
      url1080p: url1080p ?? this.url1080p,
      url720p: url720p ?? this.url720p,
      url540p: url540p ?? this.url540p,
      url480p: url480p ?? this.url480p,
      dubbedUrl: dubbedUrl ?? this.dubbedUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tvShowId.present) {
      map['tv_show_id'] = Variable<int>(tvShowId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (episodeNumber.present) {
      map['episode_number'] = Variable<int>(episodeNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<String>(airDate.value);
    }
    if (stillPath.present) {
      map['still_path'] = Variable<String>(stillPath.value);
    }
    if (url1080p.present) {
      map['url1080p'] = Variable<String>(url1080p.value);
    }
    if (url720p.present) {
      map['url720p'] = Variable<String>(url720p.value);
    }
    if (url540p.present) {
      map['url540p'] = Variable<String>(url540p.value);
    }
    if (url480p.present) {
      map['url480p'] = Variable<String>(url480p.value);
    }
    if (dubbedUrl.present) {
      map['dubbed_url'] = Variable<String>(dubbedUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodesCompanion(')
          ..write('id: $id, ')
          ..write('tvShowId: $tvShowId, ')
          ..write('seasonId: $seasonId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('stillPath: $stillPath, ')
          ..write('url1080p: $url1080p, ')
          ..write('url720p: $url720p, ')
          ..write('url540p: $url540p, ')
          ..write('url480p: $url480p, ')
          ..write('dubbedUrl: $dubbedUrl')
          ..write(')'))
        .toString();
  }
}

class $GenresTable extends Genres with TableInfo<$GenresTable, Genre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<MediaType, String> mediaType =
      GeneratedColumn<String>('media_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MediaType>($GenresTable.$convertermediaType);
  @override
  List<GeneratedColumn> get $columns => [id, name, mediaType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'genres';
  @override
  VerificationContext validateIntegrity(Insertable<Genre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Genre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Genre(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mediaType: $GenresTable.$convertermediaType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_type'])!),
    );
  }

  @override
  $GenresTable createAlias(String alias) {
    return $GenresTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaType, String, String> $convertermediaType =
      const EnumNameConverter<MediaType>(MediaType.values);
}

class Genre extends DataClass implements Insertable<Genre> {
  final int id;
  final String name;
  final MediaType mediaType;
  const Genre({required this.id, required this.name, required this.mediaType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['media_type'] =
          Variable<String>($GenresTable.$convertermediaType.toSql(mediaType));
    }
    return map;
  }

  GenresCompanion toCompanion(bool nullToAbsent) {
    return GenresCompanion(
      id: Value(id),
      name: Value(name),
      mediaType: Value(mediaType),
    );
  }

  factory Genre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Genre(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mediaType: $GenresTable.$convertermediaType
          .fromJson(serializer.fromJson<String>(json['media_type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'media_type': serializer
          .toJson<String>($GenresTable.$convertermediaType.toJson(mediaType)),
    };
  }

  Genre copyWith({int? id, String? name, MediaType? mediaType}) => Genre(
        id: id ?? this.id,
        name: name ?? this.name,
        mediaType: mediaType ?? this.mediaType,
      );
  Genre copyWithCompanion(GenresCompanion data) {
    return Genre(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Genre(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mediaType: $mediaType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, mediaType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Genre &&
          other.id == this.id &&
          other.name == this.name &&
          other.mediaType == this.mediaType);
}

class GenresCompanion extends UpdateCompanion<Genre> {
  final Value<int> id;
  final Value<String> name;
  final Value<MediaType> mediaType;
  const GenresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mediaType = const Value.absent(),
  });
  GenresCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required MediaType mediaType,
  })  : name = Value(name),
        mediaType = Value(mediaType);
  static Insertable<Genre> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? mediaType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mediaType != null) 'media_type': mediaType,
    });
  }

  GenresCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<MediaType>? mediaType}) {
    return GenresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(
          $GenresTable.$convertermediaType.toSql(mediaType.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GenresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mediaType: $mediaType')
          ..write(')'))
        .toString();
  }
}

class $PeopleTable extends People with TableInfo<$PeopleTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profilePathMeta =
      const VerificationMeta('profilePath');
  @override
  late final GeneratedColumn<String> profilePath = GeneratedColumn<String>(
      'profile_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _knownForDepartmentMeta =
      const VerificationMeta('knownForDepartment');
  @override
  late final GeneratedColumn<String> knownForDepartment =
      GeneratedColumn<String>('known_for_department', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, profilePath, knownForDepartment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('profile_path')) {
      context.handle(
          _profilePathMeta,
          profilePath.isAcceptableOrUnknown(
              data['profile_path']!, _profilePathMeta));
    }
    if (data.containsKey('known_for_department')) {
      context.handle(
          _knownForDepartmentMeta,
          knownForDepartment.isAcceptableOrUnknown(
              data['known_for_department']!, _knownForDepartmentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      profilePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_path']),
      knownForDepartment: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}known_for_department']),
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;
  const Person(
      {required this.id,
      required this.name,
      this.profilePath,
      this.knownForDepartment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || profilePath != null) {
      map['profile_path'] = Variable<String>(profilePath);
    }
    if (!nullToAbsent || knownForDepartment != null) {
      map['known_for_department'] = Variable<String>(knownForDepartment);
    }
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: Value(id),
      name: Value(name),
      profilePath: profilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePath),
      knownForDepartment: knownForDepartment == null && nullToAbsent
          ? const Value.absent()
          : Value(knownForDepartment),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      profilePath: serializer.fromJson<String?>(json['profilePath']),
      knownForDepartment:
          serializer.fromJson<String?>(json['knownForDepartment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'profilePath': serializer.toJson<String?>(profilePath),
      'knownForDepartment': serializer.toJson<String?>(knownForDepartment),
    };
  }

  Person copyWith(
          {int? id,
          String? name,
          Value<String?> profilePath = const Value.absent(),
          Value<String?> knownForDepartment = const Value.absent()}) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        profilePath: profilePath.present ? profilePath.value : this.profilePath,
        knownForDepartment: knownForDepartment.present
            ? knownForDepartment.value
            : this.knownForDepartment,
      );
  Person copyWithCompanion(PeopleCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      profilePath:
          data.profilePath.present ? data.profilePath.value : this.profilePath,
      knownForDepartment: data.knownForDepartment.present
          ? data.knownForDepartment.value
          : this.knownForDepartment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profilePath: $profilePath, ')
          ..write('knownForDepartment: $knownForDepartment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, profilePath, knownForDepartment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.profilePath == this.profilePath &&
          other.knownForDepartment == this.knownForDepartment);
}

class PeopleCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> profilePath;
  final Value<String?> knownForDepartment;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.profilePath = const Value.absent(),
    this.knownForDepartment = const Value.absent(),
  });
  PeopleCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.profilePath = const Value.absent(),
    this.knownForDepartment = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? profilePath,
    Expression<String>? knownForDepartment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (profilePath != null) 'profile_path': profilePath,
      if (knownForDepartment != null)
        'known_for_department': knownForDepartment,
    });
  }

  PeopleCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? profilePath,
      Value<String?>? knownForDepartment}) {
    return PeopleCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePath: profilePath ?? this.profilePath,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (profilePath.present) {
      map['profile_path'] = Variable<String>(profilePath.value);
    }
    if (knownForDepartment.present) {
      map['known_for_department'] = Variable<String>(knownForDepartment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profilePath: $profilePath, ')
          ..write('knownForDepartment: $knownForDepartment')
          ..write(')'))
        .toString();
  }
}

class $MovieGenresTable extends MovieGenres
    with TableInfo<$MovieGenresTable, MovieGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovieGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _movieIdMeta =
      const VerificationMeta('movieId');
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
      'movie_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES movies (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [movieId, genreId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movie_genres';
  @override
  VerificationContext validateIntegrity(Insertable<MovieGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('movie_id')) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta));
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, genreId};
  @override
  MovieGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovieGenre(
      movieId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}movie_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $MovieGenresTable createAlias(String alias) {
    return $MovieGenresTable(attachedDatabase, alias);
  }
}

class MovieGenre extends DataClass implements Insertable<MovieGenre> {
  final int movieId;
  final int genreId;
  const MovieGenre({required this.movieId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['movie_id'] = Variable<int>(movieId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  MovieGenresCompanion toCompanion(bool nullToAbsent) {
    return MovieGenresCompanion(
      movieId: Value(movieId),
      genreId: Value(genreId),
    );
  }

  factory MovieGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovieGenre(
      movieId: serializer.fromJson<int>(json['movieId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'movieId': serializer.toJson<int>(movieId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  MovieGenre copyWith({int? movieId, int? genreId}) => MovieGenre(
        movieId: movieId ?? this.movieId,
        genreId: genreId ?? this.genreId,
      );
  MovieGenre copyWithCompanion(MovieGenresCompanion data) {
    return MovieGenre(
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      genreId: data.genreId.present ? data.genreId.value : this.genreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovieGenre(')
          ..write('movieId: $movieId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(movieId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieGenre &&
          other.movieId == this.movieId &&
          other.genreId == this.genreId);
}

class MovieGenresCompanion extends UpdateCompanion<MovieGenre> {
  final Value<int> movieId;
  final Value<int> genreId;
  final Value<int> rowid;
  const MovieGenresCompanion({
    this.movieId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovieGenresCompanion.insert({
    required int movieId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : movieId = Value(movieId),
        genreId = Value(genreId);
  static Insertable<MovieGenre> custom({
    Expression<int>? movieId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (movieId != null) 'movie_id': movieId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovieGenresCompanion copyWith(
      {Value<int>? movieId, Value<int>? genreId, Value<int>? rowid}) {
    return MovieGenresCompanion(
      movieId: movieId ?? this.movieId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovieGenresCompanion(')
          ..write('movieId: $movieId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TvShowGenresTable extends TvShowGenres
    with TableInfo<$TvShowGenresTable, TvShowGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvShowGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tvShowIdMeta =
      const VerificationMeta('tvShowId');
  @override
  late final GeneratedColumn<int> tvShowId = GeneratedColumn<int>(
      'tv_show_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tv_shows (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [tvShowId, genreId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_show_genres';
  @override
  VerificationContext validateIntegrity(Insertable<TvShowGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tv_show_id')) {
      context.handle(_tvShowIdMeta,
          tvShowId.isAcceptableOrUnknown(data['tv_show_id']!, _tvShowIdMeta));
    } else if (isInserting) {
      context.missing(_tvShowIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tvShowId, genreId};
  @override
  TvShowGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvShowGenre(
      tvShowId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tv_show_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $TvShowGenresTable createAlias(String alias) {
    return $TvShowGenresTable(attachedDatabase, alias);
  }
}

class TvShowGenre extends DataClass implements Insertable<TvShowGenre> {
  final int tvShowId;
  final int genreId;
  const TvShowGenre({required this.tvShowId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tv_show_id'] = Variable<int>(tvShowId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  TvShowGenresCompanion toCompanion(bool nullToAbsent) {
    return TvShowGenresCompanion(
      tvShowId: Value(tvShowId),
      genreId: Value(genreId),
    );
  }

  factory TvShowGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvShowGenre(
      tvShowId: serializer.fromJson<int>(json['tvShowId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tvShowId': serializer.toJson<int>(tvShowId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  TvShowGenre copyWith({int? tvShowId, int? genreId}) => TvShowGenre(
        tvShowId: tvShowId ?? this.tvShowId,
        genreId: genreId ?? this.genreId,
      );
  TvShowGenre copyWithCompanion(TvShowGenresCompanion data) {
    return TvShowGenre(
      tvShowId: data.tvShowId.present ? data.tvShowId.value : this.tvShowId,
      genreId: data.genreId.present ? data.genreId.value : this.genreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvShowGenre(')
          ..write('tvShowId: $tvShowId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tvShowId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvShowGenre &&
          other.tvShowId == this.tvShowId &&
          other.genreId == this.genreId);
}

class TvShowGenresCompanion extends UpdateCompanion<TvShowGenre> {
  final Value<int> tvShowId;
  final Value<int> genreId;
  final Value<int> rowid;
  const TvShowGenresCompanion({
    this.tvShowId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TvShowGenresCompanion.insert({
    required int tvShowId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : tvShowId = Value(tvShowId),
        genreId = Value(genreId);
  static Insertable<TvShowGenre> custom({
    Expression<int>? tvShowId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tvShowId != null) 'tv_show_id': tvShowId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TvShowGenresCompanion copyWith(
      {Value<int>? tvShowId, Value<int>? genreId, Value<int>? rowid}) {
    return TvShowGenresCompanion(
      tvShowId: tvShowId ?? this.tvShowId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tvShowId.present) {
      map['tv_show_id'] = Variable<int>(tvShowId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvShowGenresCompanion(')
          ..write('tvShowId: $tvShowId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MovieCastTable extends MovieCast
    with TableInfo<$MovieCastTable, MovieCastMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovieCastTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _movieIdMeta =
      const VerificationMeta('movieId');
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
      'movie_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES movies (id)'));
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES people (id)'));
  static const VerificationMeta _characterMeta =
      const VerificationMeta('character');
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
      'character', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [movieId, personId, character];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movie_cast';
  @override
  VerificationContext validateIntegrity(Insertable<MovieCastMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('movie_id')) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta));
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('character')) {
      context.handle(_characterMeta,
          character.isAcceptableOrUnknown(data['character']!, _characterMeta));
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, personId, character};
  @override
  MovieCastMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovieCastMember(
      movieId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}movie_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      character: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character'])!,
    );
  }

  @override
  $MovieCastTable createAlias(String alias) {
    return $MovieCastTable(attachedDatabase, alias);
  }
}

class MovieCastMember extends DataClass implements Insertable<MovieCastMember> {
  final int movieId;
  final int personId;
  final String character;
  const MovieCastMember(
      {required this.movieId, required this.personId, required this.character});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['movie_id'] = Variable<int>(movieId);
    map['person_id'] = Variable<int>(personId);
    map['character'] = Variable<String>(character);
    return map;
  }

  MovieCastCompanion toCompanion(bool nullToAbsent) {
    return MovieCastCompanion(
      movieId: Value(movieId),
      personId: Value(personId),
      character: Value(character),
    );
  }

  factory MovieCastMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovieCastMember(
      movieId: serializer.fromJson<int>(json['movieId']),
      personId: serializer.fromJson<int>(json['personId']),
      character: serializer.fromJson<String>(json['character']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'movieId': serializer.toJson<int>(movieId),
      'personId': serializer.toJson<int>(personId),
      'character': serializer.toJson<String>(character),
    };
  }

  MovieCastMember copyWith({int? movieId, int? personId, String? character}) =>
      MovieCastMember(
        movieId: movieId ?? this.movieId,
        personId: personId ?? this.personId,
        character: character ?? this.character,
      );
  MovieCastMember copyWithCompanion(MovieCastCompanion data) {
    return MovieCastMember(
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      personId: data.personId.present ? data.personId.value : this.personId,
      character: data.character.present ? data.character.value : this.character,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovieCastMember(')
          ..write('movieId: $movieId, ')
          ..write('personId: $personId, ')
          ..write('character: $character')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(movieId, personId, character);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieCastMember &&
          other.movieId == this.movieId &&
          other.personId == this.personId &&
          other.character == this.character);
}

class MovieCastCompanion extends UpdateCompanion<MovieCastMember> {
  final Value<int> movieId;
  final Value<int> personId;
  final Value<String> character;
  final Value<int> rowid;
  const MovieCastCompanion({
    this.movieId = const Value.absent(),
    this.personId = const Value.absent(),
    this.character = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovieCastCompanion.insert({
    required int movieId,
    required int personId,
    required String character,
    this.rowid = const Value.absent(),
  })  : movieId = Value(movieId),
        personId = Value(personId),
        character = Value(character);
  static Insertable<MovieCastMember> custom({
    Expression<int>? movieId,
    Expression<int>? personId,
    Expression<String>? character,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (movieId != null) 'movie_id': movieId,
      if (personId != null) 'person_id': personId,
      if (character != null) 'character': character,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovieCastCompanion copyWith(
      {Value<int>? movieId,
      Value<int>? personId,
      Value<String>? character,
      Value<int>? rowid}) {
    return MovieCastCompanion(
      movieId: movieId ?? this.movieId,
      personId: personId ?? this.personId,
      character: character ?? this.character,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovieCastCompanion(')
          ..write('movieId: $movieId, ')
          ..write('personId: $personId, ')
          ..write('character: $character, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TvShowCastTable extends TvShowCast
    with TableInfo<$TvShowCastTable, TvShowCastMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvShowCastTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tvShowIdMeta =
      const VerificationMeta('tvShowId');
  @override
  late final GeneratedColumn<int> tvShowId = GeneratedColumn<int>(
      'tv_show_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tv_shows (id)'));
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES people (id)'));
  static const VerificationMeta _characterMeta =
      const VerificationMeta('character');
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
      'character', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [tvShowId, personId, character];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_show_cast';
  @override
  VerificationContext validateIntegrity(Insertable<TvShowCastMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tv_show_id')) {
      context.handle(_tvShowIdMeta,
          tvShowId.isAcceptableOrUnknown(data['tv_show_id']!, _tvShowIdMeta));
    } else if (isInserting) {
      context.missing(_tvShowIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('character')) {
      context.handle(_characterMeta,
          character.isAcceptableOrUnknown(data['character']!, _characterMeta));
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tvShowId, personId, character};
  @override
  TvShowCastMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvShowCastMember(
      tvShowId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tv_show_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      character: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character'])!,
    );
  }

  @override
  $TvShowCastTable createAlias(String alias) {
    return $TvShowCastTable(attachedDatabase, alias);
  }
}

class TvShowCastMember extends DataClass
    implements Insertable<TvShowCastMember> {
  final int tvShowId;
  final int personId;
  final String character;
  const TvShowCastMember(
      {required this.tvShowId,
      required this.personId,
      required this.character});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tv_show_id'] = Variable<int>(tvShowId);
    map['person_id'] = Variable<int>(personId);
    map['character'] = Variable<String>(character);
    return map;
  }

  TvShowCastCompanion toCompanion(bool nullToAbsent) {
    return TvShowCastCompanion(
      tvShowId: Value(tvShowId),
      personId: Value(personId),
      character: Value(character),
    );
  }

  factory TvShowCastMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvShowCastMember(
      tvShowId: serializer.fromJson<int>(json['tvShowId']),
      personId: serializer.fromJson<int>(json['personId']),
      character: serializer.fromJson<String>(json['character']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tvShowId': serializer.toJson<int>(tvShowId),
      'personId': serializer.toJson<int>(personId),
      'character': serializer.toJson<String>(character),
    };
  }

  TvShowCastMember copyWith(
          {int? tvShowId, int? personId, String? character}) =>
      TvShowCastMember(
        tvShowId: tvShowId ?? this.tvShowId,
        personId: personId ?? this.personId,
        character: character ?? this.character,
      );
  TvShowCastMember copyWithCompanion(TvShowCastCompanion data) {
    return TvShowCastMember(
      tvShowId: data.tvShowId.present ? data.tvShowId.value : this.tvShowId,
      personId: data.personId.present ? data.personId.value : this.personId,
      character: data.character.present ? data.character.value : this.character,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvShowCastMember(')
          ..write('tvShowId: $tvShowId, ')
          ..write('personId: $personId, ')
          ..write('character: $character')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tvShowId, personId, character);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvShowCastMember &&
          other.tvShowId == this.tvShowId &&
          other.personId == this.personId &&
          other.character == this.character);
}

class TvShowCastCompanion extends UpdateCompanion<TvShowCastMember> {
  final Value<int> tvShowId;
  final Value<int> personId;
  final Value<String> character;
  final Value<int> rowid;
  const TvShowCastCompanion({
    this.tvShowId = const Value.absent(),
    this.personId = const Value.absent(),
    this.character = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TvShowCastCompanion.insert({
    required int tvShowId,
    required int personId,
    required String character,
    this.rowid = const Value.absent(),
  })  : tvShowId = Value(tvShowId),
        personId = Value(personId),
        character = Value(character);
  static Insertable<TvShowCastMember> custom({
    Expression<int>? tvShowId,
    Expression<int>? personId,
    Expression<String>? character,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tvShowId != null) 'tv_show_id': tvShowId,
      if (personId != null) 'person_id': personId,
      if (character != null) 'character': character,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TvShowCastCompanion copyWith(
      {Value<int>? tvShowId,
      Value<int>? personId,
      Value<String>? character,
      Value<int>? rowid}) {
    return TvShowCastCompanion(
      tvShowId: tvShowId ?? this.tvShowId,
      personId: personId ?? this.personId,
      character: character ?? this.character,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tvShowId.present) {
      map['tv_show_id'] = Variable<int>(tvShowId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvShowCastCompanion(')
          ..write('tvShowId: $tvShowId, ')
          ..write('personId: $personId, ')
          ..write('character: $character, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoviesTable movies = $MoviesTable(this);
  late final $TvShowsTable tvShows = $TvShowsTable(this);
  late final $SeasonsTable seasons = $SeasonsTable(this);
  late final $EpisodesTable episodes = $EpisodesTable(this);
  late final $GenresTable genres = $GenresTable(this);
  late final $PeopleTable people = $PeopleTable(this);
  late final $MovieGenresTable movieGenres = $MovieGenresTable(this);
  late final $TvShowGenresTable tvShowGenres = $TvShowGenresTable(this);
  late final $MovieCastTable movieCast = $MovieCastTable(this);
  late final $TvShowCastTable tvShowCast = $TvShowCastTable(this);
  late final MediaDao mediaDao = MediaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        movies,
        tvShows,
        seasons,
        episodes,
        genres,
        people,
        movieGenres,
        tvShowGenres,
        movieCast,
        tvShowCast
      ];
}

typedef $$MoviesTableCreateCompanionBuilder = MoviesCompanion Function({
  Value<int> id,
  required String title,
  required String originalTitle,
  Value<String?> overview,
  Value<String?> releaseDate,
  Value<String?> posterPath,
  Value<String?> backdropPath,
  Value<double> voteAverage,
  Value<int> voteCount,
  Value<double> popularity,
  Value<bool> adult,
  Value<int?> runtime,
  Value<String?> status,
  Value<String?> tagline,
  Value<String?> source,
  Value<String?> rawDownloadLinks,
  Value<List<VideoInfo>?> videos,
});
typedef $$MoviesTableUpdateCompanionBuilder = MoviesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> originalTitle,
  Value<String?> overview,
  Value<String?> releaseDate,
  Value<String?> posterPath,
  Value<String?> backdropPath,
  Value<double> voteAverage,
  Value<int> voteCount,
  Value<double> popularity,
  Value<bool> adult,
  Value<int?> runtime,
  Value<String?> status,
  Value<String?> tagline,
  Value<String?> source,
  Value<String?> rawDownloadLinks,
  Value<List<VideoInfo>?> videos,
});

final class $$MoviesTableReferences
    extends BaseReferences<_$AppDatabase, $MoviesTable, Movie> {
  $$MoviesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovieGenresTable, List<MovieGenre>>
      _movieGenresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.movieGenres,
              aliasName:
                  $_aliasNameGenerator(db.movies.id, db.movieGenres.movieId));

  $$MovieGenresTableProcessedTableManager get movieGenresRefs {
    final manager = $$MovieGenresTableTableManager($_db, $_db.movieGenres)
        .filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movieGenresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MovieCastTable, List<MovieCastMember>>
      _movieCastRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.movieCast,
          aliasName: $_aliasNameGenerator(db.movies.id, db.movieCast.movieId));

  $$MovieCastTableProcessedTableManager get movieCastRefs {
    final manager = $$MovieCastTableTableManager($_db, $_db.movieCast)
        .filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movieCastRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MoviesTableFilterComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalTitle => $composableBuilder(
      column: $table.originalTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backdropPath => $composableBuilder(
      column: $table.backdropPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get adult => $composableBuilder(
      column: $table.adult, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runtime => $composableBuilder(
      column: $table.runtime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagline => $composableBuilder(
      column: $table.tagline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawDownloadLinks => $composableBuilder(
      column: $table.rawDownloadLinks,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<VideoInfo>?, List<VideoInfo>, String>
      get videos => $composableBuilder(
          column: $table.videos,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> movieGenresRefs(
      Expression<bool> Function($$MovieGenresTableFilterComposer f) f) {
    final $$MovieGenresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieGenres,
        getReferencedColumn: (t) => t.movieId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieGenresTableFilterComposer(
              $db: $db,
              $table: $db.movieGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> movieCastRefs(
      Expression<bool> Function($$MovieCastTableFilterComposer f) f) {
    final $$MovieCastTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieCast,
        getReferencedColumn: (t) => t.movieId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieCastTableFilterComposer(
              $db: $db,
              $table: $db.movieCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalTitle => $composableBuilder(
      column: $table.originalTitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backdropPath => $composableBuilder(
      column: $table.backdropPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get adult => $composableBuilder(
      column: $table.adult, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runtime => $composableBuilder(
      column: $table.runtime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagline => $composableBuilder(
      column: $table.tagline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawDownloadLinks => $composableBuilder(
      column: $table.rawDownloadLinks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videos => $composableBuilder(
      column: $table.videos, builder: (column) => ColumnOrderings(column));
}

class $$MoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get originalTitle => $composableBuilder(
      column: $table.originalTitle, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => column);

  GeneratedColumn<String> get backdropPath => $composableBuilder(
      column: $table.backdropPath, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => column);

  GeneratedColumn<int> get voteCount =>
      $composableBuilder(column: $table.voteCount, builder: (column) => column);

  GeneratedColumn<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => column);

  GeneratedColumn<bool> get adult =>
      $composableBuilder(column: $table.adult, builder: (column) => column);

  GeneratedColumn<int> get runtime =>
      $composableBuilder(column: $table.runtime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get tagline =>
      $composableBuilder(column: $table.tagline, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get rawDownloadLinks => $composableBuilder(
      column: $table.rawDownloadLinks, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<VideoInfo>?, String> get videos =>
      $composableBuilder(column: $table.videos, builder: (column) => column);

  Expression<T> movieGenresRefs<T extends Object>(
      Expression<T> Function($$MovieGenresTableAnnotationComposer a) f) {
    final $$MovieGenresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieGenres,
        getReferencedColumn: (t) => t.movieId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieGenresTableAnnotationComposer(
              $db: $db,
              $table: $db.movieGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> movieCastRefs<T extends Object>(
      Expression<T> Function($$MovieCastTableAnnotationComposer a) f) {
    final $$MovieCastTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieCast,
        getReferencedColumn: (t) => t.movieId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieCastTableAnnotationComposer(
              $db: $db,
              $table: $db.movieCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MoviesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MoviesTable,
    Movie,
    $$MoviesTableFilterComposer,
    $$MoviesTableOrderingComposer,
    $$MoviesTableAnnotationComposer,
    $$MoviesTableCreateCompanionBuilder,
    $$MoviesTableUpdateCompanionBuilder,
    (Movie, $$MoviesTableReferences),
    Movie,
    PrefetchHooks Function({bool movieGenresRefs, bool movieCastRefs})> {
  $$MoviesTableTableManager(_$AppDatabase db, $MoviesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> originalTitle = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> releaseDate = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<String?> backdropPath = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<int> voteCount = const Value.absent(),
            Value<double> popularity = const Value.absent(),
            Value<bool> adult = const Value.absent(),
            Value<int?> runtime = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> tagline = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> rawDownloadLinks = const Value.absent(),
            Value<List<VideoInfo>?> videos = const Value.absent(),
          }) =>
              MoviesCompanion(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            adult: adult,
            runtime: runtime,
            status: status,
            tagline: tagline,
            source: source,
            rawDownloadLinks: rawDownloadLinks,
            videos: videos,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String originalTitle,
            Value<String?> overview = const Value.absent(),
            Value<String?> releaseDate = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<String?> backdropPath = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<int> voteCount = const Value.absent(),
            Value<double> popularity = const Value.absent(),
            Value<bool> adult = const Value.absent(),
            Value<int?> runtime = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> tagline = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> rawDownloadLinks = const Value.absent(),
            Value<List<VideoInfo>?> videos = const Value.absent(),
          }) =>
              MoviesCompanion.insert(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            adult: adult,
            runtime: runtime,
            status: status,
            tagline: tagline,
            source: source,
            rawDownloadLinks: rawDownloadLinks,
            videos: videos,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MoviesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {movieGenresRefs = false, movieCastRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (movieGenresRefs) db.movieGenres,
                if (movieCastRefs) db.movieCast
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movieGenresRefs)
                    await $_getPrefetchedData<Movie, $MoviesTable, MovieGenre>(
                        currentTable: table,
                        referencedTable:
                            $$MoviesTableReferences._movieGenresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MoviesTableReferences(db, table, p0)
                                .movieGenresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.movieId == item.id),
                        typedResults: items),
                  if (movieCastRefs)
                    await $_getPrefetchedData<Movie, $MoviesTable,
                            MovieCastMember>(
                        currentTable: table,
                        referencedTable:
                            $$MoviesTableReferences._movieCastRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MoviesTableReferences(db, table, p0)
                                .movieCastRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.movieId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MoviesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MoviesTable,
    Movie,
    $$MoviesTableFilterComposer,
    $$MoviesTableOrderingComposer,
    $$MoviesTableAnnotationComposer,
    $$MoviesTableCreateCompanionBuilder,
    $$MoviesTableUpdateCompanionBuilder,
    (Movie, $$MoviesTableReferences),
    Movie,
    PrefetchHooks Function({bool movieGenresRefs, bool movieCastRefs})>;
typedef $$TvShowsTableCreateCompanionBuilder = TvShowsCompanion Function({
  Value<int> id,
  required String name,
  required String originalName,
  Value<String?> overview,
  Value<String?> firstAirDate,
  Value<String?> posterPath,
  Value<String?> backdropPath,
  Value<double> voteAverage,
  Value<int> voteCount,
  Value<double> popularity,
  Value<String?> status,
  Value<String?> type,
  Value<String?> source,
  Value<List<VideoInfo>?> videos,
});
typedef $$TvShowsTableUpdateCompanionBuilder = TvShowsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> originalName,
  Value<String?> overview,
  Value<String?> firstAirDate,
  Value<String?> posterPath,
  Value<String?> backdropPath,
  Value<double> voteAverage,
  Value<int> voteCount,
  Value<double> popularity,
  Value<String?> status,
  Value<String?> type,
  Value<String?> source,
  Value<List<VideoInfo>?> videos,
});

final class $$TvShowsTableReferences
    extends BaseReferences<_$AppDatabase, $TvShowsTable, TvShow> {
  $$TvShowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SeasonsTable, List<Season>> _seasonsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.seasons,
          aliasName: $_aliasNameGenerator(db.tvShows.id, db.seasons.tvShowId));

  $$SeasonsTableProcessedTableManager get seasonsRefs {
    final manager = $$SeasonsTableTableManager($_db, $_db.seasons)
        .filter((f) => f.tvShowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_seasonsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EpisodesTable, List<Episode>> _episodesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.episodes,
          aliasName: $_aliasNameGenerator(db.tvShows.id, db.episodes.tvShowId));

  $$EpisodesTableProcessedTableManager get episodesRefs {
    final manager = $$EpisodesTableTableManager($_db, $_db.episodes)
        .filter((f) => f.tvShowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_episodesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TvShowGenresTable, List<TvShowGenre>>
      _tvShowGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.tvShowGenres,
          aliasName:
              $_aliasNameGenerator(db.tvShows.id, db.tvShowGenres.tvShowId));

  $$TvShowGenresTableProcessedTableManager get tvShowGenresRefs {
    final manager = $$TvShowGenresTableTableManager($_db, $_db.tvShowGenres)
        .filter((f) => f.tvShowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvShowGenresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TvShowCastTable, List<TvShowCastMember>>
      _tvShowCastRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tvShowCast,
              aliasName:
                  $_aliasNameGenerator(db.tvShows.id, db.tvShowCast.tvShowId));

  $$TvShowCastTableProcessedTableManager get tvShowCastRefs {
    final manager = $$TvShowCastTableTableManager($_db, $_db.tvShowCast)
        .filter((f) => f.tvShowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvShowCastRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TvShowsTableFilterComposer
    extends Composer<_$AppDatabase, $TvShowsTable> {
  $$TvShowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalName => $composableBuilder(
      column: $table.originalName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstAirDate => $composableBuilder(
      column: $table.firstAirDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backdropPath => $composableBuilder(
      column: $table.backdropPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<VideoInfo>?, List<VideoInfo>, String>
      get videos => $composableBuilder(
          column: $table.videos,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> seasonsRefs(
      Expression<bool> Function($$SeasonsTableFilterComposer f) f) {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.seasons,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeasonsTableFilterComposer(
              $db: $db,
              $table: $db.seasons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> episodesRefs(
      Expression<bool> Function($$EpisodesTableFilterComposer f) f) {
    final $$EpisodesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.episodes,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EpisodesTableFilterComposer(
              $db: $db,
              $table: $db.episodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tvShowGenresRefs(
      Expression<bool> Function($$TvShowGenresTableFilterComposer f) f) {
    final $$TvShowGenresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowGenres,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowGenresTableFilterComposer(
              $db: $db,
              $table: $db.tvShowGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tvShowCastRefs(
      Expression<bool> Function($$TvShowCastTableFilterComposer f) f) {
    final $$TvShowCastTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowCast,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowCastTableFilterComposer(
              $db: $db,
              $table: $db.tvShowCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TvShowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TvShowsTable> {
  $$TvShowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalName => $composableBuilder(
      column: $table.originalName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstAirDate => $composableBuilder(
      column: $table.firstAirDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backdropPath => $composableBuilder(
      column: $table.backdropPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videos => $composableBuilder(
      column: $table.videos, builder: (column) => ColumnOrderings(column));
}

class $$TvShowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvShowsTable> {
  $$TvShowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
      column: $table.originalName, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get firstAirDate => $composableBuilder(
      column: $table.firstAirDate, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => column);

  GeneratedColumn<String> get backdropPath => $composableBuilder(
      column: $table.backdropPath, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => column);

  GeneratedColumn<int> get voteCount =>
      $composableBuilder(column: $table.voteCount, builder: (column) => column);

  GeneratedColumn<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<VideoInfo>?, String> get videos =>
      $composableBuilder(column: $table.videos, builder: (column) => column);

  Expression<T> seasonsRefs<T extends Object>(
      Expression<T> Function($$SeasonsTableAnnotationComposer a) f) {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.seasons,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeasonsTableAnnotationComposer(
              $db: $db,
              $table: $db.seasons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> episodesRefs<T extends Object>(
      Expression<T> Function($$EpisodesTableAnnotationComposer a) f) {
    final $$EpisodesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.episodes,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EpisodesTableAnnotationComposer(
              $db: $db,
              $table: $db.episodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tvShowGenresRefs<T extends Object>(
      Expression<T> Function($$TvShowGenresTableAnnotationComposer a) f) {
    final $$TvShowGenresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowGenres,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowGenresTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShowGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tvShowCastRefs<T extends Object>(
      Expression<T> Function($$TvShowCastTableAnnotationComposer a) f) {
    final $$TvShowCastTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowCast,
        getReferencedColumn: (t) => t.tvShowId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowCastTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShowCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TvShowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TvShowsTable,
    TvShow,
    $$TvShowsTableFilterComposer,
    $$TvShowsTableOrderingComposer,
    $$TvShowsTableAnnotationComposer,
    $$TvShowsTableCreateCompanionBuilder,
    $$TvShowsTableUpdateCompanionBuilder,
    (TvShow, $$TvShowsTableReferences),
    TvShow,
    PrefetchHooks Function(
        {bool seasonsRefs,
        bool episodesRefs,
        bool tvShowGenresRefs,
        bool tvShowCastRefs})> {
  $$TvShowsTableTableManager(_$AppDatabase db, $TvShowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvShowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvShowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvShowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> originalName = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> firstAirDate = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<String?> backdropPath = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<int> voteCount = const Value.absent(),
            Value<double> popularity = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<List<VideoInfo>?> videos = const Value.absent(),
          }) =>
              TvShowsCompanion(
            id: id,
            name: name,
            originalName: originalName,
            overview: overview,
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            status: status,
            type: type,
            source: source,
            videos: videos,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String originalName,
            Value<String?> overview = const Value.absent(),
            Value<String?> firstAirDate = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<String?> backdropPath = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<int> voteCount = const Value.absent(),
            Value<double> popularity = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<List<VideoInfo>?> videos = const Value.absent(),
          }) =>
              TvShowsCompanion.insert(
            id: id,
            name: name,
            originalName: originalName,
            overview: overview,
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            status: status,
            type: type,
            source: source,
            videos: videos,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TvShowsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {seasonsRefs = false,
              episodesRefs = false,
              tvShowGenresRefs = false,
              tvShowCastRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (seasonsRefs) db.seasons,
                if (episodesRefs) db.episodes,
                if (tvShowGenresRefs) db.tvShowGenres,
                if (tvShowCastRefs) db.tvShowCast
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (seasonsRefs)
                    await $_getPrefetchedData<TvShow, $TvShowsTable, Season>(
                        currentTable: table,
                        referencedTable:
                            $$TvShowsTableReferences._seasonsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TvShowsTableReferences(db, table, p0).seasonsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tvShowId == item.id),
                        typedResults: items),
                  if (episodesRefs)
                    await $_getPrefetchedData<TvShow, $TvShowsTable, Episode>(
                        currentTable: table,
                        referencedTable:
                            $$TvShowsTableReferences._episodesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TvShowsTableReferences(db, table, p0)
                                .episodesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tvShowId == item.id),
                        typedResults: items),
                  if (tvShowGenresRefs)
                    await $_getPrefetchedData<TvShow, $TvShowsTable,
                            TvShowGenre>(
                        currentTable: table,
                        referencedTable:
                            $$TvShowsTableReferences._tvShowGenresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TvShowsTableReferences(db, table, p0)
                                .tvShowGenresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tvShowId == item.id),
                        typedResults: items),
                  if (tvShowCastRefs)
                    await $_getPrefetchedData<TvShow, $TvShowsTable,
                            TvShowCastMember>(
                        currentTable: table,
                        referencedTable:
                            $$TvShowsTableReferences._tvShowCastRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TvShowsTableReferences(db, table, p0)
                                .tvShowCastRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tvShowId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TvShowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TvShowsTable,
    TvShow,
    $$TvShowsTableFilterComposer,
    $$TvShowsTableOrderingComposer,
    $$TvShowsTableAnnotationComposer,
    $$TvShowsTableCreateCompanionBuilder,
    $$TvShowsTableUpdateCompanionBuilder,
    (TvShow, $$TvShowsTableReferences),
    TvShow,
    PrefetchHooks Function(
        {bool seasonsRefs,
        bool episodesRefs,
        bool tvShowGenresRefs,
        bool tvShowCastRefs})>;
typedef $$SeasonsTableCreateCompanionBuilder = SeasonsCompanion Function({
  Value<int> id,
  required int tvShowId,
  required int seasonNumber,
  Value<String?> name,
  Value<String?> overview,
  Value<String?> airDate,
  Value<String?> posterPath,
  Value<int?> episodeCount,
});
typedef $$SeasonsTableUpdateCompanionBuilder = SeasonsCompanion Function({
  Value<int> id,
  Value<int> tvShowId,
  Value<int> seasonNumber,
  Value<String?> name,
  Value<String?> overview,
  Value<String?> airDate,
  Value<String?> posterPath,
  Value<int?> episodeCount,
});

final class $$SeasonsTableReferences
    extends BaseReferences<_$AppDatabase, $SeasonsTable, Season> {
  $$SeasonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TvShowsTable _tvShowIdTable(_$AppDatabase db) => db.tvShows
      .createAlias($_aliasNameGenerator(db.seasons.tvShowId, db.tvShows.id));

  $$TvShowsTableProcessedTableManager get tvShowId {
    final $_column = $_itemColumn<int>('tv_show_id')!;

    final manager = $$TvShowsTableTableManager($_db, $_db.tvShows)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tvShowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EpisodesTable, List<Episode>> _episodesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.episodes,
          aliasName: $_aliasNameGenerator(db.seasons.id, db.episodes.seasonId));

  $$EpisodesTableProcessedTableManager get episodesRefs {
    final manager = $$EpisodesTableTableManager($_db, $_db.episodes)
        .filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_episodesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SeasonsTableFilterComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get episodeCount => $composableBuilder(
      column: $table.episodeCount, builder: (column) => ColumnFilters(column));

  $$TvShowsTableFilterComposer get tvShowId {
    final $$TvShowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableFilterComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> episodesRefs(
      Expression<bool> Function($$EpisodesTableFilterComposer f) f) {
    final $$EpisodesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.episodes,
        getReferencedColumn: (t) => t.seasonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EpisodesTableFilterComposer(
              $db: $db,
              $table: $db.episodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SeasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get episodeCount => $composableBuilder(
      column: $table.episodeCount,
      builder: (column) => ColumnOrderings(column));

  $$TvShowsTableOrderingComposer get tvShowId {
    final $$TvShowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableOrderingComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SeasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => column);

  GeneratedColumn<int> get episodeCount => $composableBuilder(
      column: $table.episodeCount, builder: (column) => column);

  $$TvShowsTableAnnotationComposer get tvShowId {
    final $$TvShowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> episodesRefs<T extends Object>(
      Expression<T> Function($$EpisodesTableAnnotationComposer a) f) {
    final $$EpisodesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.episodes,
        getReferencedColumn: (t) => t.seasonId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EpisodesTableAnnotationComposer(
              $db: $db,
              $table: $db.episodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SeasonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SeasonsTable,
    Season,
    $$SeasonsTableFilterComposer,
    $$SeasonsTableOrderingComposer,
    $$SeasonsTableAnnotationComposer,
    $$SeasonsTableCreateCompanionBuilder,
    $$SeasonsTableUpdateCompanionBuilder,
    (Season, $$SeasonsTableReferences),
    Season,
    PrefetchHooks Function({bool tvShowId, bool episodesRefs})> {
  $$SeasonsTableTableManager(_$AppDatabase db, $SeasonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeasonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeasonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeasonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tvShowId = const Value.absent(),
            Value<int> seasonNumber = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> airDate = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<int?> episodeCount = const Value.absent(),
          }) =>
              SeasonsCompanion(
            id: id,
            tvShowId: tvShowId,
            seasonNumber: seasonNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            posterPath: posterPath,
            episodeCount: episodeCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tvShowId,
            required int seasonNumber,
            Value<String?> name = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> airDate = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<int?> episodeCount = const Value.absent(),
          }) =>
              SeasonsCompanion.insert(
            id: id,
            tvShowId: tvShowId,
            seasonNumber: seasonNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            posterPath: posterPath,
            episodeCount: episodeCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SeasonsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tvShowId = false, episodesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (episodesRefs) db.episodes],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tvShowId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tvShowId,
                    referencedTable:
                        $$SeasonsTableReferences._tvShowIdTable(db),
                    referencedColumn:
                        $$SeasonsTableReferences._tvShowIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (episodesRefs)
                    await $_getPrefetchedData<Season, $SeasonsTable, Episode>(
                        currentTable: table,
                        referencedTable:
                            $$SeasonsTableReferences._episodesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SeasonsTableReferences(db, table, p0)
                                .episodesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.seasonId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SeasonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SeasonsTable,
    Season,
    $$SeasonsTableFilterComposer,
    $$SeasonsTableOrderingComposer,
    $$SeasonsTableAnnotationComposer,
    $$SeasonsTableCreateCompanionBuilder,
    $$SeasonsTableUpdateCompanionBuilder,
    (Season, $$SeasonsTableReferences),
    Season,
    PrefetchHooks Function({bool tvShowId, bool episodesRefs})>;
typedef $$EpisodesTableCreateCompanionBuilder = EpisodesCompanion Function({
  Value<int> id,
  required int tvShowId,
  required int seasonId,
  required int seasonNumber,
  required int episodeNumber,
  Value<String?> name,
  Value<String?> overview,
  Value<String?> airDate,
  Value<String?> stillPath,
  Value<String?> url1080p,
  Value<String?> url720p,
  Value<String?> url540p,
  Value<String?> url480p,
  Value<String?> dubbedUrl,
});
typedef $$EpisodesTableUpdateCompanionBuilder = EpisodesCompanion Function({
  Value<int> id,
  Value<int> tvShowId,
  Value<int> seasonId,
  Value<int> seasonNumber,
  Value<int> episodeNumber,
  Value<String?> name,
  Value<String?> overview,
  Value<String?> airDate,
  Value<String?> stillPath,
  Value<String?> url1080p,
  Value<String?> url720p,
  Value<String?> url540p,
  Value<String?> url480p,
  Value<String?> dubbedUrl,
});

final class $$EpisodesTableReferences
    extends BaseReferences<_$AppDatabase, $EpisodesTable, Episode> {
  $$EpisodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TvShowsTable _tvShowIdTable(_$AppDatabase db) => db.tvShows
      .createAlias($_aliasNameGenerator(db.episodes.tvShowId, db.tvShows.id));

  $$TvShowsTableProcessedTableManager get tvShowId {
    final $_column = $_itemColumn<int>('tv_show_id')!;

    final manager = $$TvShowsTableTableManager($_db, $_db.tvShows)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tvShowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) => db.seasons
      .createAlias($_aliasNameGenerator(db.episodes.seasonId, db.seasons.id));

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager($_db, $_db.seasons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get episodeNumber => $composableBuilder(
      column: $table.episodeNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stillPath => $composableBuilder(
      column: $table.stillPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url1080p => $composableBuilder(
      column: $table.url1080p, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url720p => $composableBuilder(
      column: $table.url720p, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url540p => $composableBuilder(
      column: $table.url540p, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url480p => $composableBuilder(
      column: $table.url480p, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dubbedUrl => $composableBuilder(
      column: $table.dubbedUrl, builder: (column) => ColumnFilters(column));

  $$TvShowsTableFilterComposer get tvShowId {
    final $$TvShowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableFilterComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.seasonId,
        referencedTable: $db.seasons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeasonsTableFilterComposer(
              $db: $db,
              $table: $db.seasons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get episodeNumber => $composableBuilder(
      column: $table.episodeNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stillPath => $composableBuilder(
      column: $table.stillPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url1080p => $composableBuilder(
      column: $table.url1080p, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url720p => $composableBuilder(
      column: $table.url720p, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url540p => $composableBuilder(
      column: $table.url540p, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url480p => $composableBuilder(
      column: $table.url480p, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dubbedUrl => $composableBuilder(
      column: $table.dubbedUrl, builder: (column) => ColumnOrderings(column));

  $$TvShowsTableOrderingComposer get tvShowId {
    final $$TvShowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableOrderingComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.seasonId,
        referencedTable: $db.seasons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeasonsTableOrderingComposer(
              $db: $db,
              $table: $db.seasons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => column);

  GeneratedColumn<int> get episodeNumber => $composableBuilder(
      column: $table.episodeNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<String> get stillPath =>
      $composableBuilder(column: $table.stillPath, builder: (column) => column);

  GeneratedColumn<String> get url1080p =>
      $composableBuilder(column: $table.url1080p, builder: (column) => column);

  GeneratedColumn<String> get url720p =>
      $composableBuilder(column: $table.url720p, builder: (column) => column);

  GeneratedColumn<String> get url540p =>
      $composableBuilder(column: $table.url540p, builder: (column) => column);

  GeneratedColumn<String> get url480p =>
      $composableBuilder(column: $table.url480p, builder: (column) => column);

  GeneratedColumn<String> get dubbedUrl =>
      $composableBuilder(column: $table.dubbedUrl, builder: (column) => column);

  $$TvShowsTableAnnotationComposer get tvShowId {
    final $$TvShowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.seasonId,
        referencedTable: $db.seasons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeasonsTableAnnotationComposer(
              $db: $db,
              $table: $db.seasons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EpisodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EpisodesTable,
    Episode,
    $$EpisodesTableFilterComposer,
    $$EpisodesTableOrderingComposer,
    $$EpisodesTableAnnotationComposer,
    $$EpisodesTableCreateCompanionBuilder,
    $$EpisodesTableUpdateCompanionBuilder,
    (Episode, $$EpisodesTableReferences),
    Episode,
    PrefetchHooks Function({bool tvShowId, bool seasonId})> {
  $$EpisodesTableTableManager(_$AppDatabase db, $EpisodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tvShowId = const Value.absent(),
            Value<int> seasonId = const Value.absent(),
            Value<int> seasonNumber = const Value.absent(),
            Value<int> episodeNumber = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> airDate = const Value.absent(),
            Value<String?> stillPath = const Value.absent(),
            Value<String?> url1080p = const Value.absent(),
            Value<String?> url720p = const Value.absent(),
            Value<String?> url540p = const Value.absent(),
            Value<String?> url480p = const Value.absent(),
            Value<String?> dubbedUrl = const Value.absent(),
          }) =>
              EpisodesCompanion(
            id: id,
            tvShowId: tvShowId,
            seasonId: seasonId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            stillPath: stillPath,
            url1080p: url1080p,
            url720p: url720p,
            url540p: url540p,
            url480p: url480p,
            dubbedUrl: dubbedUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tvShowId,
            required int seasonId,
            required int seasonNumber,
            required int episodeNumber,
            Value<String?> name = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> airDate = const Value.absent(),
            Value<String?> stillPath = const Value.absent(),
            Value<String?> url1080p = const Value.absent(),
            Value<String?> url720p = const Value.absent(),
            Value<String?> url540p = const Value.absent(),
            Value<String?> url480p = const Value.absent(),
            Value<String?> dubbedUrl = const Value.absent(),
          }) =>
              EpisodesCompanion.insert(
            id: id,
            tvShowId: tvShowId,
            seasonId: seasonId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            stillPath: stillPath,
            url1080p: url1080p,
            url720p: url720p,
            url540p: url540p,
            url480p: url480p,
            dubbedUrl: dubbedUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EpisodesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tvShowId = false, seasonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tvShowId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tvShowId,
                    referencedTable:
                        $$EpisodesTableReferences._tvShowIdTable(db),
                    referencedColumn:
                        $$EpisodesTableReferences._tvShowIdTable(db).id,
                  ) as T;
                }
                if (seasonId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.seasonId,
                    referencedTable:
                        $$EpisodesTableReferences._seasonIdTable(db),
                    referencedColumn:
                        $$EpisodesTableReferences._seasonIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EpisodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EpisodesTable,
    Episode,
    $$EpisodesTableFilterComposer,
    $$EpisodesTableOrderingComposer,
    $$EpisodesTableAnnotationComposer,
    $$EpisodesTableCreateCompanionBuilder,
    $$EpisodesTableUpdateCompanionBuilder,
    (Episode, $$EpisodesTableReferences),
    Episode,
    PrefetchHooks Function({bool tvShowId, bool seasonId})>;
typedef $$GenresTableCreateCompanionBuilder = GenresCompanion Function({
  Value<int> id,
  required String name,
  required MediaType mediaType,
});
typedef $$GenresTableUpdateCompanionBuilder = GenresCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<MediaType> mediaType,
});

final class $$GenresTableReferences
    extends BaseReferences<_$AppDatabase, $GenresTable, Genre> {
  $$GenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovieGenresTable, List<MovieGenre>>
      _movieGenresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.movieGenres,
              aliasName:
                  $_aliasNameGenerator(db.genres.id, db.movieGenres.genreId));

  $$MovieGenresTableProcessedTableManager get movieGenresRefs {
    final manager = $$MovieGenresTableTableManager($_db, $_db.movieGenres)
        .filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movieGenresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TvShowGenresTable, List<TvShowGenre>>
      _tvShowGenresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tvShowGenres,
              aliasName:
                  $_aliasNameGenerator(db.genres.id, db.tvShowGenres.genreId));

  $$TvShowGenresTableProcessedTableManager get tvShowGenresRefs {
    final manager = $$TvShowGenresTableTableManager($_db, $_db.tvShowGenres)
        .filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvShowGenresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GenresTableFilterComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MediaType, MediaType, String> get mediaType =>
      $composableBuilder(
          column: $table.mediaType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> movieGenresRefs(
      Expression<bool> Function($$MovieGenresTableFilterComposer f) f) {
    final $$MovieGenresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieGenres,
        getReferencedColumn: (t) => t.genreId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieGenresTableFilterComposer(
              $db: $db,
              $table: $db.movieGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tvShowGenresRefs(
      Expression<bool> Function($$TvShowGenresTableFilterComposer f) f) {
    final $$TvShowGenresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowGenres,
        getReferencedColumn: (t) => t.genreId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowGenresTableFilterComposer(
              $db: $db,
              $table: $db.tvShowGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GenresTableOrderingComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnOrderings(column));
}

class $$GenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaType, String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  Expression<T> movieGenresRefs<T extends Object>(
      Expression<T> Function($$MovieGenresTableAnnotationComposer a) f) {
    final $$MovieGenresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieGenres,
        getReferencedColumn: (t) => t.genreId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieGenresTableAnnotationComposer(
              $db: $db,
              $table: $db.movieGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tvShowGenresRefs<T extends Object>(
      Expression<T> Function($$TvShowGenresTableAnnotationComposer a) f) {
    final $$TvShowGenresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowGenres,
        getReferencedColumn: (t) => t.genreId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowGenresTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShowGenres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GenresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GenresTable,
    Genre,
    $$GenresTableFilterComposer,
    $$GenresTableOrderingComposer,
    $$GenresTableAnnotationComposer,
    $$GenresTableCreateCompanionBuilder,
    $$GenresTableUpdateCompanionBuilder,
    (Genre, $$GenresTableReferences),
    Genre,
    PrefetchHooks Function({bool movieGenresRefs, bool tvShowGenresRefs})> {
  $$GenresTableTableManager(_$AppDatabase db, $GenresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<MediaType> mediaType = const Value.absent(),
          }) =>
              GenresCompanion(
            id: id,
            name: name,
            mediaType: mediaType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required MediaType mediaType,
          }) =>
              GenresCompanion.insert(
            id: id,
            name: name,
            mediaType: mediaType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GenresTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {movieGenresRefs = false, tvShowGenresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (movieGenresRefs) db.movieGenres,
                if (tvShowGenresRefs) db.tvShowGenres
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movieGenresRefs)
                    await $_getPrefetchedData<Genre, $GenresTable, MovieGenre>(
                        currentTable: table,
                        referencedTable:
                            $$GenresTableReferences._movieGenresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GenresTableReferences(db, table, p0)
                                .movieGenresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.genreId == item.id),
                        typedResults: items),
                  if (tvShowGenresRefs)
                    await $_getPrefetchedData<Genre, $GenresTable, TvShowGenre>(
                        currentTable: table,
                        referencedTable:
                            $$GenresTableReferences._tvShowGenresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GenresTableReferences(db, table, p0)
                                .tvShowGenresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.genreId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GenresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GenresTable,
    Genre,
    $$GenresTableFilterComposer,
    $$GenresTableOrderingComposer,
    $$GenresTableAnnotationComposer,
    $$GenresTableCreateCompanionBuilder,
    $$GenresTableUpdateCompanionBuilder,
    (Genre, $$GenresTableReferences),
    Genre,
    PrefetchHooks Function({bool movieGenresRefs, bool tvShowGenresRefs})>;
typedef $$PeopleTableCreateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> profilePath,
  Value<String?> knownForDepartment,
});
typedef $$PeopleTableUpdateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> profilePath,
  Value<String?> knownForDepartment,
});

final class $$PeopleTableReferences
    extends BaseReferences<_$AppDatabase, $PeopleTable, Person> {
  $$PeopleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovieCastTable, List<MovieCastMember>>
      _movieCastRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.movieCast,
          aliasName: $_aliasNameGenerator(db.people.id, db.movieCast.personId));

  $$MovieCastTableProcessedTableManager get movieCastRefs {
    final manager = $$MovieCastTableTableManager($_db, $_db.movieCast)
        .filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movieCastRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TvShowCastTable, List<TvShowCastMember>>
      _tvShowCastRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tvShowCast,
              aliasName:
                  $_aliasNameGenerator(db.people.id, db.tvShowCast.personId));

  $$TvShowCastTableProcessedTableManager get tvShowCastRefs {
    final manager = $$TvShowCastTableTableManager($_db, $_db.tvShowCast)
        .filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvShowCastRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PeopleTableFilterComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profilePath => $composableBuilder(
      column: $table.profilePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get knownForDepartment => $composableBuilder(
      column: $table.knownForDepartment,
      builder: (column) => ColumnFilters(column));

  Expression<bool> movieCastRefs(
      Expression<bool> Function($$MovieCastTableFilterComposer f) f) {
    final $$MovieCastTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieCast,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieCastTableFilterComposer(
              $db: $db,
              $table: $db.movieCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tvShowCastRefs(
      Expression<bool> Function($$TvShowCastTableFilterComposer f) f) {
    final $$TvShowCastTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowCast,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowCastTableFilterComposer(
              $db: $db,
              $table: $db.tvShowCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PeopleTableOrderingComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profilePath => $composableBuilder(
      column: $table.profilePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get knownForDepartment => $composableBuilder(
      column: $table.knownForDepartment,
      builder: (column) => ColumnOrderings(column));
}

class $$PeopleTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get profilePath => $composableBuilder(
      column: $table.profilePath, builder: (column) => column);

  GeneratedColumn<String> get knownForDepartment => $composableBuilder(
      column: $table.knownForDepartment, builder: (column) => column);

  Expression<T> movieCastRefs<T extends Object>(
      Expression<T> Function($$MovieCastTableAnnotationComposer a) f) {
    final $$MovieCastTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.movieCast,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MovieCastTableAnnotationComposer(
              $db: $db,
              $table: $db.movieCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tvShowCastRefs<T extends Object>(
      Expression<T> Function($$TvShowCastTableAnnotationComposer a) f) {
    final $$TvShowCastTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tvShowCast,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowCastTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShowCast,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PeopleTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeopleTable,
    Person,
    $$PeopleTableFilterComposer,
    $$PeopleTableOrderingComposer,
    $$PeopleTableAnnotationComposer,
    $$PeopleTableCreateCompanionBuilder,
    $$PeopleTableUpdateCompanionBuilder,
    (Person, $$PeopleTableReferences),
    Person,
    PrefetchHooks Function({bool movieCastRefs, bool tvShowCastRefs})> {
  $$PeopleTableTableManager(_$AppDatabase db, $PeopleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> profilePath = const Value.absent(),
            Value<String?> knownForDepartment = const Value.absent(),
          }) =>
              PeopleCompanion(
            id: id,
            name: name,
            profilePath: profilePath,
            knownForDepartment: knownForDepartment,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> profilePath = const Value.absent(),
            Value<String?> knownForDepartment = const Value.absent(),
          }) =>
              PeopleCompanion.insert(
            id: id,
            name: name,
            profilePath: profilePath,
            knownForDepartment: knownForDepartment,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PeopleTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {movieCastRefs = false, tvShowCastRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (movieCastRefs) db.movieCast,
                if (tvShowCastRefs) db.tvShowCast
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movieCastRefs)
                    await $_getPrefetchedData<Person, $PeopleTable,
                            MovieCastMember>(
                        currentTable: table,
                        referencedTable:
                            $$PeopleTableReferences._movieCastRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PeopleTableReferences(db, table, p0)
                                .movieCastRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.personId == item.id),
                        typedResults: items),
                  if (tvShowCastRefs)
                    await $_getPrefetchedData<Person, $PeopleTable,
                            TvShowCastMember>(
                        currentTable: table,
                        referencedTable:
                            $$PeopleTableReferences._tvShowCastRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PeopleTableReferences(db, table, p0)
                                .tvShowCastRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.personId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PeopleTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeopleTable,
    Person,
    $$PeopleTableFilterComposer,
    $$PeopleTableOrderingComposer,
    $$PeopleTableAnnotationComposer,
    $$PeopleTableCreateCompanionBuilder,
    $$PeopleTableUpdateCompanionBuilder,
    (Person, $$PeopleTableReferences),
    Person,
    PrefetchHooks Function({bool movieCastRefs, bool tvShowCastRefs})>;
typedef $$MovieGenresTableCreateCompanionBuilder = MovieGenresCompanion
    Function({
  required int movieId,
  required int genreId,
  Value<int> rowid,
});
typedef $$MovieGenresTableUpdateCompanionBuilder = MovieGenresCompanion
    Function({
  Value<int> movieId,
  Value<int> genreId,
  Value<int> rowid,
});

final class $$MovieGenresTableReferences
    extends BaseReferences<_$AppDatabase, $MovieGenresTable, MovieGenre> {
  $$MovieGenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies
      .createAlias($_aliasNameGenerator(db.movieGenres.movieId, db.movies.id));

  $$MoviesTableProcessedTableManager get movieId {
    final $_column = $_itemColumn<int>('movie_id')!;

    final manager = $$MoviesTableTableManager($_db, $_db.movies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GenresTable _genreIdTable(_$AppDatabase db) => db.genres
      .createAlias($_aliasNameGenerator(db.movieGenres.genreId, db.genres.id));

  $$GenresTableProcessedTableManager get genreId {
    final $_column = $_itemColumn<int>('genre_id')!;

    final manager = $$GenresTableTableManager($_db, $_db.genres)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MovieGenresTableFilterComposer
    extends Composer<_$AppDatabase, $MovieGenresTable> {
  $$MovieGenresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoviesTableFilterComposer get movieId {
    final $$MoviesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.movies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableFilterComposer(
              $db: $db,
              $table: $db.movies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GenresTableFilterComposer get genreId {
    final $$GenresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.genreId,
        referencedTable: $db.genres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GenresTableFilterComposer(
              $db: $db,
              $table: $db.genres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovieGenresTableOrderingComposer
    extends Composer<_$AppDatabase, $MovieGenresTable> {
  $$MovieGenresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoviesTableOrderingComposer get movieId {
    final $$MoviesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.movies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableOrderingComposer(
              $db: $db,
              $table: $db.movies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GenresTableOrderingComposer get genreId {
    final $$GenresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.genreId,
        referencedTable: $db.genres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GenresTableOrderingComposer(
              $db: $db,
              $table: $db.genres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovieGenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovieGenresTable> {
  $$MovieGenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoviesTableAnnotationComposer get movieId {
    final $$MoviesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.movies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableAnnotationComposer(
              $db: $db,
              $table: $db.movies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GenresTableAnnotationComposer get genreId {
    final $$GenresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.genreId,
        referencedTable: $db.genres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GenresTableAnnotationComposer(
              $db: $db,
              $table: $db.genres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovieGenresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovieGenresTable,
    MovieGenre,
    $$MovieGenresTableFilterComposer,
    $$MovieGenresTableOrderingComposer,
    $$MovieGenresTableAnnotationComposer,
    $$MovieGenresTableCreateCompanionBuilder,
    $$MovieGenresTableUpdateCompanionBuilder,
    (MovieGenre, $$MovieGenresTableReferences),
    MovieGenre,
    PrefetchHooks Function({bool movieId, bool genreId})> {
  $$MovieGenresTableTableManager(_$AppDatabase db, $MovieGenresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovieGenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovieGenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovieGenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> movieId = const Value.absent(),
            Value<int> genreId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MovieGenresCompanion(
            movieId: movieId,
            genreId: genreId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int movieId,
            required int genreId,
            Value<int> rowid = const Value.absent(),
          }) =>
              MovieGenresCompanion.insert(
            movieId: movieId,
            genreId: genreId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MovieGenresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({movieId = false, genreId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (movieId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.movieId,
                    referencedTable:
                        $$MovieGenresTableReferences._movieIdTable(db),
                    referencedColumn:
                        $$MovieGenresTableReferences._movieIdTable(db).id,
                  ) as T;
                }
                if (genreId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.genreId,
                    referencedTable:
                        $$MovieGenresTableReferences._genreIdTable(db),
                    referencedColumn:
                        $$MovieGenresTableReferences._genreIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MovieGenresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovieGenresTable,
    MovieGenre,
    $$MovieGenresTableFilterComposer,
    $$MovieGenresTableOrderingComposer,
    $$MovieGenresTableAnnotationComposer,
    $$MovieGenresTableCreateCompanionBuilder,
    $$MovieGenresTableUpdateCompanionBuilder,
    (MovieGenre, $$MovieGenresTableReferences),
    MovieGenre,
    PrefetchHooks Function({bool movieId, bool genreId})>;
typedef $$TvShowGenresTableCreateCompanionBuilder = TvShowGenresCompanion
    Function({
  required int tvShowId,
  required int genreId,
  Value<int> rowid,
});
typedef $$TvShowGenresTableUpdateCompanionBuilder = TvShowGenresCompanion
    Function({
  Value<int> tvShowId,
  Value<int> genreId,
  Value<int> rowid,
});

final class $$TvShowGenresTableReferences
    extends BaseReferences<_$AppDatabase, $TvShowGenresTable, TvShowGenre> {
  $$TvShowGenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TvShowsTable _tvShowIdTable(_$AppDatabase db) =>
      db.tvShows.createAlias(
          $_aliasNameGenerator(db.tvShowGenres.tvShowId, db.tvShows.id));

  $$TvShowsTableProcessedTableManager get tvShowId {
    final $_column = $_itemColumn<int>('tv_show_id')!;

    final manager = $$TvShowsTableTableManager($_db, $_db.tvShows)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tvShowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GenresTable _genreIdTable(_$AppDatabase db) => db.genres
      .createAlias($_aliasNameGenerator(db.tvShowGenres.genreId, db.genres.id));

  $$GenresTableProcessedTableManager get genreId {
    final $_column = $_itemColumn<int>('genre_id')!;

    final manager = $$GenresTableTableManager($_db, $_db.genres)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TvShowGenresTableFilterComposer
    extends Composer<_$AppDatabase, $TvShowGenresTable> {
  $$TvShowGenresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TvShowsTableFilterComposer get tvShowId {
    final $$TvShowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableFilterComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GenresTableFilterComposer get genreId {
    final $$GenresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.genreId,
        referencedTable: $db.genres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GenresTableFilterComposer(
              $db: $db,
              $table: $db.genres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TvShowGenresTableOrderingComposer
    extends Composer<_$AppDatabase, $TvShowGenresTable> {
  $$TvShowGenresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TvShowsTableOrderingComposer get tvShowId {
    final $$TvShowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableOrderingComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GenresTableOrderingComposer get genreId {
    final $$GenresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.genreId,
        referencedTable: $db.genres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GenresTableOrderingComposer(
              $db: $db,
              $table: $db.genres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TvShowGenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvShowGenresTable> {
  $$TvShowGenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TvShowsTableAnnotationComposer get tvShowId {
    final $$TvShowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GenresTableAnnotationComposer get genreId {
    final $$GenresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.genreId,
        referencedTable: $db.genres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GenresTableAnnotationComposer(
              $db: $db,
              $table: $db.genres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TvShowGenresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TvShowGenresTable,
    TvShowGenre,
    $$TvShowGenresTableFilterComposer,
    $$TvShowGenresTableOrderingComposer,
    $$TvShowGenresTableAnnotationComposer,
    $$TvShowGenresTableCreateCompanionBuilder,
    $$TvShowGenresTableUpdateCompanionBuilder,
    (TvShowGenre, $$TvShowGenresTableReferences),
    TvShowGenre,
    PrefetchHooks Function({bool tvShowId, bool genreId})> {
  $$TvShowGenresTableTableManager(_$AppDatabase db, $TvShowGenresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvShowGenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvShowGenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvShowGenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tvShowId = const Value.absent(),
            Value<int> genreId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TvShowGenresCompanion(
            tvShowId: tvShowId,
            genreId: genreId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tvShowId,
            required int genreId,
            Value<int> rowid = const Value.absent(),
          }) =>
              TvShowGenresCompanion.insert(
            tvShowId: tvShowId,
            genreId: genreId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TvShowGenresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tvShowId = false, genreId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tvShowId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tvShowId,
                    referencedTable:
                        $$TvShowGenresTableReferences._tvShowIdTable(db),
                    referencedColumn:
                        $$TvShowGenresTableReferences._tvShowIdTable(db).id,
                  ) as T;
                }
                if (genreId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.genreId,
                    referencedTable:
                        $$TvShowGenresTableReferences._genreIdTable(db),
                    referencedColumn:
                        $$TvShowGenresTableReferences._genreIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TvShowGenresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TvShowGenresTable,
    TvShowGenre,
    $$TvShowGenresTableFilterComposer,
    $$TvShowGenresTableOrderingComposer,
    $$TvShowGenresTableAnnotationComposer,
    $$TvShowGenresTableCreateCompanionBuilder,
    $$TvShowGenresTableUpdateCompanionBuilder,
    (TvShowGenre, $$TvShowGenresTableReferences),
    TvShowGenre,
    PrefetchHooks Function({bool tvShowId, bool genreId})>;
typedef $$MovieCastTableCreateCompanionBuilder = MovieCastCompanion Function({
  required int movieId,
  required int personId,
  required String character,
  Value<int> rowid,
});
typedef $$MovieCastTableUpdateCompanionBuilder = MovieCastCompanion Function({
  Value<int> movieId,
  Value<int> personId,
  Value<String> character,
  Value<int> rowid,
});

final class $$MovieCastTableReferences
    extends BaseReferences<_$AppDatabase, $MovieCastTable, MovieCastMember> {
  $$MovieCastTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies
      .createAlias($_aliasNameGenerator(db.movieCast.movieId, db.movies.id));

  $$MoviesTableProcessedTableManager get movieId {
    final $_column = $_itemColumn<int>('movie_id')!;

    final manager = $$MoviesTableTableManager($_db, $_db.movies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeopleTable _personIdTable(_$AppDatabase db) => db.people
      .createAlias($_aliasNameGenerator(db.movieCast.personId, db.people.id));

  $$PeopleTableProcessedTableManager get personId {
    final $_column = $_itemColumn<int>('person_id')!;

    final manager = $$PeopleTableTableManager($_db, $_db.people)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MovieCastTableFilterComposer
    extends Composer<_$AppDatabase, $MovieCastTable> {
  $$MovieCastTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnFilters(column));

  $$MoviesTableFilterComposer get movieId {
    final $$MoviesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.movies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableFilterComposer(
              $db: $db,
              $table: $db.movies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeopleTableFilterComposer get personId {
    final $$PeopleTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.people,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeopleTableFilterComposer(
              $db: $db,
              $table: $db.people,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovieCastTableOrderingComposer
    extends Composer<_$AppDatabase, $MovieCastTable> {
  $$MovieCastTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnOrderings(column));

  $$MoviesTableOrderingComposer get movieId {
    final $$MoviesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.movies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableOrderingComposer(
              $db: $db,
              $table: $db.movies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeopleTableOrderingComposer get personId {
    final $$PeopleTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.people,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeopleTableOrderingComposer(
              $db: $db,
              $table: $db.people,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovieCastTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovieCastTable> {
  $$MovieCastTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  $$MoviesTableAnnotationComposer get movieId {
    final $$MoviesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.movies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableAnnotationComposer(
              $db: $db,
              $table: $db.movies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeopleTableAnnotationComposer get personId {
    final $$PeopleTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.people,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeopleTableAnnotationComposer(
              $db: $db,
              $table: $db.people,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MovieCastTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovieCastTable,
    MovieCastMember,
    $$MovieCastTableFilterComposer,
    $$MovieCastTableOrderingComposer,
    $$MovieCastTableAnnotationComposer,
    $$MovieCastTableCreateCompanionBuilder,
    $$MovieCastTableUpdateCompanionBuilder,
    (MovieCastMember, $$MovieCastTableReferences),
    MovieCastMember,
    PrefetchHooks Function({bool movieId, bool personId})> {
  $$MovieCastTableTableManager(_$AppDatabase db, $MovieCastTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovieCastTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovieCastTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovieCastTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> movieId = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<String> character = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MovieCastCompanion(
            movieId: movieId,
            personId: personId,
            character: character,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int movieId,
            required int personId,
            required String character,
            Value<int> rowid = const Value.absent(),
          }) =>
              MovieCastCompanion.insert(
            movieId: movieId,
            personId: personId,
            character: character,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MovieCastTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({movieId = false, personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (movieId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.movieId,
                    referencedTable:
                        $$MovieCastTableReferences._movieIdTable(db),
                    referencedColumn:
                        $$MovieCastTableReferences._movieIdTable(db).id,
                  ) as T;
                }
                if (personId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personId,
                    referencedTable:
                        $$MovieCastTableReferences._personIdTable(db),
                    referencedColumn:
                        $$MovieCastTableReferences._personIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MovieCastTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovieCastTable,
    MovieCastMember,
    $$MovieCastTableFilterComposer,
    $$MovieCastTableOrderingComposer,
    $$MovieCastTableAnnotationComposer,
    $$MovieCastTableCreateCompanionBuilder,
    $$MovieCastTableUpdateCompanionBuilder,
    (MovieCastMember, $$MovieCastTableReferences),
    MovieCastMember,
    PrefetchHooks Function({bool movieId, bool personId})>;
typedef $$TvShowCastTableCreateCompanionBuilder = TvShowCastCompanion Function({
  required int tvShowId,
  required int personId,
  required String character,
  Value<int> rowid,
});
typedef $$TvShowCastTableUpdateCompanionBuilder = TvShowCastCompanion Function({
  Value<int> tvShowId,
  Value<int> personId,
  Value<String> character,
  Value<int> rowid,
});

final class $$TvShowCastTableReferences
    extends BaseReferences<_$AppDatabase, $TvShowCastTable, TvShowCastMember> {
  $$TvShowCastTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TvShowsTable _tvShowIdTable(_$AppDatabase db) => db.tvShows
      .createAlias($_aliasNameGenerator(db.tvShowCast.tvShowId, db.tvShows.id));

  $$TvShowsTableProcessedTableManager get tvShowId {
    final $_column = $_itemColumn<int>('tv_show_id')!;

    final manager = $$TvShowsTableTableManager($_db, $_db.tvShows)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tvShowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeopleTable _personIdTable(_$AppDatabase db) => db.people
      .createAlias($_aliasNameGenerator(db.tvShowCast.personId, db.people.id));

  $$PeopleTableProcessedTableManager get personId {
    final $_column = $_itemColumn<int>('person_id')!;

    final manager = $$PeopleTableTableManager($_db, $_db.people)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TvShowCastTableFilterComposer
    extends Composer<_$AppDatabase, $TvShowCastTable> {
  $$TvShowCastTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnFilters(column));

  $$TvShowsTableFilterComposer get tvShowId {
    final $$TvShowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableFilterComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeopleTableFilterComposer get personId {
    final $$PeopleTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.people,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeopleTableFilterComposer(
              $db: $db,
              $table: $db.people,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TvShowCastTableOrderingComposer
    extends Composer<_$AppDatabase, $TvShowCastTable> {
  $$TvShowCastTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnOrderings(column));

  $$TvShowsTableOrderingComposer get tvShowId {
    final $$TvShowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableOrderingComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeopleTableOrderingComposer get personId {
    final $$PeopleTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.people,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeopleTableOrderingComposer(
              $db: $db,
              $table: $db.people,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TvShowCastTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvShowCastTable> {
  $$TvShowCastTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  $$TvShowsTableAnnotationComposer get tvShowId {
    final $$TvShowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tvShowId,
        referencedTable: $db.tvShows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TvShowsTableAnnotationComposer(
              $db: $db,
              $table: $db.tvShows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeopleTableAnnotationComposer get personId {
    final $$PeopleTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.people,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeopleTableAnnotationComposer(
              $db: $db,
              $table: $db.people,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TvShowCastTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TvShowCastTable,
    TvShowCastMember,
    $$TvShowCastTableFilterComposer,
    $$TvShowCastTableOrderingComposer,
    $$TvShowCastTableAnnotationComposer,
    $$TvShowCastTableCreateCompanionBuilder,
    $$TvShowCastTableUpdateCompanionBuilder,
    (TvShowCastMember, $$TvShowCastTableReferences),
    TvShowCastMember,
    PrefetchHooks Function({bool tvShowId, bool personId})> {
  $$TvShowCastTableTableManager(_$AppDatabase db, $TvShowCastTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvShowCastTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvShowCastTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvShowCastTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tvShowId = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<String> character = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TvShowCastCompanion(
            tvShowId: tvShowId,
            personId: personId,
            character: character,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tvShowId,
            required int personId,
            required String character,
            Value<int> rowid = const Value.absent(),
          }) =>
              TvShowCastCompanion.insert(
            tvShowId: tvShowId,
            personId: personId,
            character: character,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TvShowCastTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tvShowId = false, personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tvShowId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tvShowId,
                    referencedTable:
                        $$TvShowCastTableReferences._tvShowIdTable(db),
                    referencedColumn:
                        $$TvShowCastTableReferences._tvShowIdTable(db).id,
                  ) as T;
                }
                if (personId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personId,
                    referencedTable:
                        $$TvShowCastTableReferences._personIdTable(db),
                    referencedColumn:
                        $$TvShowCastTableReferences._personIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TvShowCastTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TvShowCastTable,
    TvShowCastMember,
    $$TvShowCastTableFilterComposer,
    $$TvShowCastTableOrderingComposer,
    $$TvShowCastTableAnnotationComposer,
    $$TvShowCastTableCreateCompanionBuilder,
    $$TvShowCastTableUpdateCompanionBuilder,
    (TvShowCastMember, $$TvShowCastTableReferences),
    TvShowCastMember,
    PrefetchHooks Function({bool tvShowId, bool personId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoviesTableTableManager get movies =>
      $$MoviesTableTableManager(_db, _db.movies);
  $$TvShowsTableTableManager get tvShows =>
      $$TvShowsTableTableManager(_db, _db.tvShows);
  $$SeasonsTableTableManager get seasons =>
      $$SeasonsTableTableManager(_db, _db.seasons);
  $$EpisodesTableTableManager get episodes =>
      $$EpisodesTableTableManager(_db, _db.episodes);
  $$GenresTableTableManager get genres =>
      $$GenresTableTableManager(_db, _db.genres);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$MovieGenresTableTableManager get movieGenres =>
      $$MovieGenresTableTableManager(_db, _db.movieGenres);
  $$TvShowGenresTableTableManager get tvShowGenres =>
      $$TvShowGenresTableTableManager(_db, _db.tvShowGenres);
  $$MovieCastTableTableManager get movieCast =>
      $$MovieCastTableTableManager(_db, _db.movieCast);
  $$TvShowCastTableTableManager get tvShowCast =>
      $$TvShowCastTableTableManager(_db, _db.tvShowCast);
}

mixin _$MediaDaoMixin on DatabaseAccessor<AppDatabase> {
  $MoviesTable get movies => attachedDatabase.movies;
  $TvShowsTable get tvShows => attachedDatabase.tvShows;
  $SeasonsTable get seasons => attachedDatabase.seasons;
  $EpisodesTable get episodes => attachedDatabase.episodes;
  $GenresTable get genres => attachedDatabase.genres;
  $PeopleTable get people => attachedDatabase.people;
  $MovieGenresTable get movieGenres => attachedDatabase.movieGenres;
  $TvShowGenresTable get tvShowGenres => attachedDatabase.tvShowGenres;
  $MovieCastTable get movieCast => attachedDatabase.movieCast;
  $TvShowCastTable get tvShowCast => attachedDatabase.tvShowCast;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) => VideoInfo(
      key: json['key'] as String,
      name: json['name'] as String,
      site: json['site'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'site': instance.site,
      'type': instance.type,
    };
