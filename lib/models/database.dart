// lib/data/database.dart

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:json_annotation/json_annotation.dart' as ja;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// This is required for the generated code. Run 'flutter pub run build_runner build'
part 'database.g.dart';

// --------------------------- Helper Classes & Enums ---------------------------

enum MediaType { movie, tv }

@ja.JsonSerializable()
class VideoInfo {
  final String key;
  final String name;
  final String site;
  final String type;

  VideoInfo({
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}

// --------------------------- Type Converters for Drift ---------------------------

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return (json.decode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

class VideoInfoListConverter extends TypeConverter<List<VideoInfo>, String> {
  const VideoInfoListConverter();
  @override
  List<VideoInfo> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> decoded = json.decode(fromDb) as List<dynamic>;
    return decoded
        .map((item) => VideoInfo.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  String toSql(List<VideoInfo> value) {
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}

// --------------------------- Main Entity Tables ---------------------------

@DataClassName('Movie')
class Movies extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get originalTitle => text()();
  TextColumn get overview => text().nullable()();
  TextColumn get releaseDate => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get backdropPath => text().nullable()();
  RealColumn get voteAverage => real().withDefault(const Constant(0.0))();
  IntColumn get voteCount => integer().withDefault(const Constant(0))();
  RealColumn get popularity => real().withDefault(const Constant(0.0))();
  BoolColumn get adult => boolean().withDefault(const Constant(false))();
  IntColumn get runtime => integer().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get tagline => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get rawDownloadLinks => text().nullable()();
  @JsonKey('videos')
  TextColumn get videos => text().map(const VideoInfoListConverter()).nullable()();
}

@DataClassName('TvShow')
class TvShows extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get originalName => text()();
  TextColumn get overview => text().nullable()();
  TextColumn get firstAirDate => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get backdropPath => text().nullable()();
  RealColumn get voteAverage => real().withDefault(const Constant(0.0))();
  IntColumn get voteCount => integer().withDefault(const Constant(0))();
  RealColumn get popularity => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get source => text().nullable()();
  @JsonKey('videos')
  TextColumn get videos => text().map(const VideoInfoListConverter()).nullable()();
}

@DataClassName('Season')
class Seasons extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer()();
  IntColumn get tvShowId => integer().references(TvShows, #id)();
  IntColumn get seasonNumber => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get overview => text().nullable()();
  TextColumn get airDate => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  IntColumn get episodeCount => integer().nullable()();
}

@DataClassName('Episode')
class Episodes extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer()();
  IntColumn get tvShowId => integer().references(TvShows, #id)();
  IntColumn get seasonId => integer().references(Seasons, #id)();
  IntColumn get seasonNumber => integer()();
  IntColumn get episodeNumber => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get overview => text().nullable()();
  TextColumn get airDate => text().nullable()();
  TextColumn get stillPath => text().nullable()();
  TextColumn get url1080p => text().nullable()();
  TextColumn get url720p => text().nullable()();
  TextColumn get url540p => text().nullable()();
  TextColumn get url480p => text().nullable()();
  TextColumn get dubbedUrl => text().nullable()();
}

@DataClassName('Genre')
class Genres extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer()();
  TextColumn get name => text()();
  @JsonKey('media_type')
  TextColumn get mediaType => textEnum<MediaType>()();
}

@DataClassName('Person')
class People extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get profilePath => text().nullable()();
  TextColumn get knownForDepartment => text().nullable()();
}

// --------------------------- Junction (Many-to-Many) Tables ---------------------------

class MovieGenres extends Table {
  IntColumn get movieId => integer().references(Movies, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
  @override
  Set<Column> get primaryKey => {movieId, genreId};
}

class TvShowGenres extends Table {
  IntColumn get tvShowId => integer().references(TvShows, #id)();
  IntColumn get genreId => integer().references(Genres, #id)();
  @override
  Set<Column> get primaryKey => {tvShowId, genreId};
}

@DataClassName("MovieCastMember")
class MovieCast extends Table {
  IntColumn get movieId => integer().references(Movies, #id)();
  IntColumn get personId => integer().references(People, #id)();
  TextColumn get character => text()();
  @override
  Set<Column> get primaryKey => {movieId, personId, character};
}

@DataClassName("TvShowCastMember")
class TvShowCast extends Table {
  IntColumn get tvShowId => integer().references(TvShows, #id)();
  IntColumn get personId => integer().references(People, #id)();
  TextColumn get character => text()();
  @override
  Set<Column> get primaryKey => {tvShowId, personId, character};
}

// --------------------------- Full Data Classes (with relationships) ---------------------------

class FullMovie {
  final Movie movie;
  final List<Genre> genres;
  final List<MovieCastMemberWithPerson> cast;

  FullMovie({required this.movie, required this.genres, required this.cast});

  factory FullMovie.fromJson(Map<String, dynamic> json) {
    final movie = Movie(
      id: json['id'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'],
      releaseDate: json['release_date'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      adult: json['adult'] ?? false,
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      videos: (json['videos']?['results'] as List<dynamic>?)
          ?.map((v) => VideoInfo(
                key: v['key'],
                name: v['name'],
                site: v['site'],
                type: v['type'],
              ))
          .toList(),
    );

    final genres = (json['genres'] as List<dynamic>?)
            ?.map((g) => Genre(
                id: g['id'], name: g['name'], mediaType: MediaType.movie))
            .toList() ??
        [];

    final cast = (json['credits']?['cast'] as List<dynamic>?)
            ?.map((c) => MovieCastMemberWithPerson(
                  MovieCastMember(
                      movieId: movie.id,
                      personId: c['id'],
                      character: c['character'] ?? ''),
                  Person(
                      id: c['id'],
                      name: c['name'],
                      profilePath: c['profile_path'],
                      knownForDepartment: c['known_for_department']),
                ))
            .toList() ??
        [];

    return FullMovie(movie: movie, genres: genres, cast: cast);
  }

  factory FullMovie.fromCsvRow(List<dynamic> row, String sourceFile) {
    T? tryParse<T>(dynamic val, T Function(String) p) => (val == null ||
            val.toString().isEmpty ||
            val.toString().toLowerCase() == 'nan')
        ? null
        : p(val.toString());
    List<String> splitList(dynamic val) => (val == null ||
            val.toString().isEmpty ||
            val.toString().toLowerCase() == 'nan')
        ? []
        : val.toString().split(',').map((s) => s.trim()).toList();

    List<VideoInfo> parseCsvVideos(String? raw) {
      if (raw == null || raw.trim().isEmpty || raw.toLowerCase() == 'nan') {
        return [];
      }
      final results = <VideoInfo>[];
      final entries = raw.split('|');
      for (final entry in entries) {
        final parts = entry.trim().split(':');
        if (parts.length >= 2) {
          final title = parts[0].trim();
          final key = parts.sublist(1).join(':').trim();
          if (key.isNotEmpty) {
            results.add(VideoInfo(key: key, name: title, site: 'YouTube', type: 'Clip'));
          }
        }
      }
      return results;
    }

    final movie = Movie(
      id: tryParse(row[0], int.parse) ?? 0,
      title: row[1]?.toString() ?? 'No Title',
      voteAverage: tryParse(row[2], double.parse) ?? 0.0,
      voteCount: tryParse(row[3], int.parse) ?? 0,
      status: row[4]?.toString(),
      releaseDate: row[5]?.toString(),
      runtime: tryParse(row[7], int.parse),
      adult: row[8]?.toString().toUpperCase() == 'TRUE',
      backdropPath: row[9]?.toString(),
      posterPath: row[17]?.toString(),
      overview: row[15]?.toString() ?? '',
      originalTitle: row[14]?.toString() ?? '',
      popularity: tryParse(row[16], double.parse) ?? 0.0,
      source: sourceFile,
      rawDownloadLinks: row[25]?.toString(),
      videos: parseCsvVideos(row.length > 26 ? row[26]?.toString() : null),
    );

    final genres = splitList(row[19])
        .map((name) => Genre(id: 0, name: name, mediaType: MediaType.movie))
        .toList();

    return FullMovie(movie: movie, genres: genres, cast: []);
  }

  List<dynamic> toCsvRow() {
    return [
      movie.id,
      movie.title,
      movie.voteAverage,
      movie.voteCount,
      movie.status,
      movie.releaseDate,
      null,
      movie.runtime,
      movie.adult,
      movie.backdropPath,
      null,
      null,
      null,
      null,
      movie.originalTitle,
      movie.overview,
      movie.popularity,
      movie.posterPath,
      movie.tagline,
      genres.map((g) => g.name).join(','),
      cast.map((c) => "${c.person.name}:${c.cast.character}").join('|'),
      [],
      [],
      [],
      movie.source,
      movie.rawDownloadLinks,
      movie.videos?.map((v) => "${v.name}:${v.key}").join('|'),
    ];
  }
}

class MovieCastMemberWithPerson {
  final MovieCastMember cast;
  final Person person;
  MovieCastMemberWithPerson(this.cast, this.person);
}

// **Added: Helper class for TV show cast**
class TvShowCastMemberWithPerson {
  final TvShowCastMember cast;
  final Person person;
  TvShowCastMemberWithPerson(this.cast, this.person);
}

// **Added: Full TV show data class**
class FullTvShow {
  final TvShow tvShow;
  final List<Genre> genres;
  final List<TvShowCastMemberWithPerson> cast;

  FullTvShow({required this.tvShow, required this.genres, required this.cast});
}

// --------------------------- Database Definition ---------------------------

@DriftDatabase(tables: [
  Movies,
  TvShows,
  Seasons,
  Episodes,
  Genres,
  People,
  MovieGenres,
  TvShowGenres,
  MovieCast,
  TvShowCast
], daos: [MediaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'media_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// --------------------------- Data Access Object (DAO) ---------------------------

@DriftAccessor(tables: [
  Movies,
  TvShows,
  Seasons,
  Episodes,
  Genres,
  People,
  MovieGenres,
  TvShowGenres,
  MovieCast,
  TvShowCast
])
class MediaDao extends DatabaseAccessor<AppDatabase> with _$MediaDaoMixin {
  MediaDao(super.db);

  // --- Insertion/Update Methods ---

  Future<void> upsertFullMovie(FullMovie fullMovie) async {
    await transaction(() async {
      await into(movies).insertOnConflictUpdate(fullMovie.movie);
      await batch((batch) {
        batch.insertAll(
            genres, fullMovie.genres, mode: InsertMode.insertOrIgnore);
      });
      await (delete(movieGenres)..where((g) => g.movieId.equals(fullMovie.movie.id))).go();
      await batch((batch) {
        batch.insertAll(movieGenres, fullMovie.genres.map((g) => MovieGenresCompanion.insert(movieId: fullMovie.movie.id, genreId: g.id)));
      });
      await batch((batch) {
        batch.insertAll(people, fullMovie.cast.map((c) => c.person),
            mode: InsertMode.insertOrIgnore);
      });
      await (delete(movieCast)..where((c) => c.movieId.equals(fullMovie.movie.id))).go();
      await batch((batch) {
        batch.insertAll(movieCast, fullMovie.cast.map((c) => c.cast));
      });
    });
  }

  // **Added: Upsert method for TV shows**
  Future<void> upsertFullTvShow(FullTvShow fullTvShow) async {
    await transaction(() async {
      await into(tvShows).insertOnConflictUpdate(fullTvShow.tvShow);
      await batch((batch) {
        batch.insertAll(
            genres, fullTvShow.genres, mode: InsertMode.insertOrIgnore);
      });
      await (delete(tvShowGenres)..where((g) => g.tvShowId.equals(fullTvShow.tvShow.id))).go();
      await batch((batch) {
        batch.insertAll(tvShowGenres, fullTvShow.genres.map((g) => TvShowGenresCompanion.insert(tvShowId: fullTvShow.tvShow.id, genreId: g.id)));
      });
      await batch((batch) {
        batch.insertAll(people, fullTvShow.cast.map((c) => c.person),
            mode: InsertMode.insertOrIgnore);
      });
      await (delete(tvShowCast)..where((c) => c.tvShowId.equals(fullTvShow.tvShow.id))).go();
      await batch((batch) {
        batch.insertAll(tvShowCast, fullTvShow.cast.map((c) => c.cast));
      });
    });
  }

  // **Added: Upsert method for seasons**
  Future<void> upsertSeason(Season season) async {
    await into(seasons).insertOnConflictUpdate(season);
  }

  // **Added: Upsert method for episodes**
  Future<void> upsertEpisode(Episode episode) async {
    await into(episodes).insertOnConflictUpdate(episode);
  }

  // --- Query Methods ---

  Future<FullMovie?> getFullMovie(int id) async {
    final movieQuery = select(movies)..where((m) => m.id.equals(id));
    final movie = await movieQuery.getSingleOrNull();

    if (movie == null) return null;

    final genreQuery = select(movieGenres).join([
      innerJoin(genres, genres.id.equalsExp(movieGenres.genreId))
    ])
      ..where(movieGenres.movieId.equals(id));
    final movieGenresResult = await genreQuery.get();
    final relatedGenres = movieGenresResult.map((row) => row.readTable(genres)).toList();

    final castQuery = select(movieCast).join([
      innerJoin(people, people.id.equalsExp(movieCast.personId))
    ])
      ..where(movieCast.movieId.equals(id));
    final castResult = await castQuery.get();
    final relatedCast = castResult.map((row) {
      return MovieCastMemberWithPerson(
        row.readTable(movieCast),
        row.readTable(people),
      );
    }).toList();

    return FullMovie(movie: movie, genres: relatedGenres, cast: relatedCast);
  }

  // **Added: Get method for TV shows**
  Future<FullTvShow?> getFullTvShow(int id) async {
    final tvShowQuery = select(tvShows)..where((t) => t.id.equals(id));
    final tvShow = await tvShowQuery.getSingleOrNull();

    if (tvShow == null) return null;

    final genreQuery = select(tvShowGenres).join([
      innerJoin(genres, genres.id.equalsExp(tvShowGenres.genreId))
    ])
      ..where(tvShowGenres.tvShowId.equals(id));
    final tvShowGenresResult = await genreQuery.get();
    final relatedGenres = tvShowGenresResult.map((row) => row.readTable(genres)).toList();

    final castQuery = select(tvShowCast).join([
      innerJoin(people, people.id.equalsExp(tvShowCast.personId))
    ])
      ..where(tvShowCast.tvShowId.equals(id));
    final castResult = await castQuery.get();
    final relatedCast = castResult.map((row) {
      return TvShowCastMemberWithPerson(
        row.readTable(tvShowCast),
        row.readTable(people),
      );
    }).toList();

    return FullTvShow(tvShow: tvShow, genres: relatedGenres, cast: relatedCast);
  }

  // **Added: Get seasons for a TV show**
  Future<List<Season>> getSeasonsForShow(int tvShowId) async {
    return (select(seasons)..where((s) => s.tvShowId.equals(tvShowId))).get();
  }

  // **Added: Get episodes for a season**
  Future<List<Episode>> getEpisodesForSeason(int seasonId) async {
    return (select(episodes)..where((e) => e.seasonId.equals(seasonId))).get();
  }

  // --- Watch Methods ---

  Stream<List<Movie>> watchAllMovies() => select(movies).watch();

  // **Added: Watch all TV shows**
  Stream<List<TvShow>> watchAllTvShows() => select(tvShows).watch();

  // **Added: Watch seasons for a TV show**
  Stream<List<Season>> watchSeasonsForShow(int tvShowId) {
    return (select(seasons)..where((s) => s.tvShowId.equals(tvShowId))).watch();
  }

  // **Added: Watch episodes for a season**
  Stream<List<Episode>> watchEpisodesForSeason(int seasonId) {
    return (select(episodes)..where((e) => e.seasonId.equals(seasonId))).watch();
  }
}