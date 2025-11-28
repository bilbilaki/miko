// OpenSubtitles Models

class OpenSubtitlesLoginRequest {
  final String username;
  final String password;

  const OpenSubtitlesLoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class OpenSubtitlesUser {
  final int allowedDownloads;
  final String? level;
  final int userId;
  final String? extInstalled;
  final int vip;

  const OpenSubtitlesUser({
    required this.allowedDownloads,
    this.level,
    required this.userId,
    this.extInstalled,
    required this.vip,
  });

  factory OpenSubtitlesUser.fromJson(Map<String, dynamic> json) {
    return OpenSubtitlesUser(
      allowedDownloads: json['allowed_downloads'] as int? ?? 0,
      level: json['level'] as String?,
      userId: json['user_id'] as int? ?? 0,
      extInstalled: json['ext_installed'] as String?,
      vip: json['vip'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowed_downloads': allowedDownloads,
      'level': level,
      'user_id': userId,
      'ext_installed': extInstalled,
      'vip': vip,
    };
  }

  OpenSubtitlesUser copyWith({
    int? allowedDownloads,
    String? level,
    int? userId,
    String? extInstalled,
    int? vip,
  }) {
    return OpenSubtitlesUser(
      allowedDownloads: allowedDownloads ?? this.allowedDownloads,
      level: level ?? this.level,
      userId: userId ?? this.userId,
      extInstalled: extInstalled ?? this.extInstalled,
      vip: vip ?? this.vip,
    );
  }
}

class OpenSubtitlesLoginResponse {
  final OpenSubtitlesUser user;
  final String token;
  final int status;

  const OpenSubtitlesLoginResponse({
    required this.user,
    required this.token,
    required this.status,
  });

  factory OpenSubtitlesLoginResponse.fromJson(Map<String, dynamic> json) {
    return OpenSubtitlesLoginResponse(
      user: OpenSubtitlesUser.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '',
      status: json['status'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'status': status,
    };
  }

  OpenSubtitlesLoginResponse copyWith({
    OpenSubtitlesUser? user,
    String? token,
    int? status,
  }) {
    return OpenSubtitlesLoginResponse(
      user: user ?? this.user,
      token: token ?? this.token,
      status: status ?? this.status,
    );
  }
}

class OpenSubtitlesSearchRequest {
  final String? aiTranslated;
  final String? episodeNumber;
  final String? foreignPartsOnly;
  final String? hearingImpaired;
  final int? id;
  final String? imdbId;
  final String? languages;
  final String? machineTranslated;
  final String? moviehash;
  final int? moviehashMatch;
  final String? orderBy;
  final String? orderDirection;
  final int? page;
  final int? parentFeatureId;
  final int? parentImdbId;
  final int? parentTmdbId;
  final String? query;
  final String? seasonNumber;
  final int? tmdbId;
  final String? trustedSources;
  final String? type;
  final int? userId;
  final int? year;

  const OpenSubtitlesSearchRequest({
    this.aiTranslated,
    this.episodeNumber,
    this.foreignPartsOnly,
    this.hearingImpaired,
    this.id,
    this.imdbId,
    this.languages,
    this.machineTranslated,
    this.moviehash,
    this.moviehashMatch,
    this.orderBy,
    this.orderDirection,
    this.page,
    this.parentFeatureId,
    this.parentImdbId,
    this.parentTmdbId,
    this.query,
    this.seasonNumber,
    this.tmdbId,
    this.trustedSources,
    this.type,
    this.userId,
    this.year,
  });

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (aiTranslated != null) params['ai_translated'] = aiTranslated!;
    if (episodeNumber != null) params['episode_number'] = episodeNumber!;
    if (foreignPartsOnly != null) params['foreign_parts_only'] = foreignPartsOnly!;
    if (hearingImpaired != null) params['hearing_impaired'] = hearingImpaired!;
    if (id != null) params['id'] = id.toString();
    if (imdbId != null) params['imdb_id'] = imdbId!;
    if (languages != null) params['languages'] = languages!;
    if (machineTranslated != null) params['machine_translated'] = machineTranslated!;
    if (moviehash != null) params['moviehash'] = moviehash!;
    if (moviehashMatch != null) params['moviehash_match'] = moviehashMatch.toString();
    if (orderBy != null) params['order_by'] = orderBy!;
    if (orderDirection != null) params['order_direction'] = orderDirection!;
    if (page != null) params['page'] = page.toString();
    if (parentFeatureId != null) params['parent_feature_id'] = parentFeatureId.toString();
    if (parentImdbId != null) params['parent_imdb_id'] = parentImdbId.toString();
    if (parentTmdbId != null) params['parent_tmdb_id'] = parentTmdbId.toString();
    if (query != null) params['query'] = query!;
    if (seasonNumber != null) params['season_number'] = seasonNumber!;
    if (tmdbId != null) params['tmdb_id'] = tmdbId.toString();
    if (trustedSources != null) params['trusted_sources'] = trustedSources!;
    if (type != null) params['type'] = type!;
    if (userId != null) params['user_id'] = userId.toString();
    if (year != null) params['year'] = year.toString();

    return params;
  }
}

class OpenSubtitlesSubtitleAttributes {
  final String? subtitleId;
  final String language;
  final int? downloadCount;
  final String? newDownloadCount;
  final int? hearingImpaired;
  final int? hd;
  final double? fps;
  final int? votes;
  final double? ratings;
  final int? fromTrusted;
  final int? foreignPartsOnly;
  final String? uploadDate;
  final String? aiTranslated;
  final String? machineTranslated;
  final String? release;
  final String? comments;
  final String? legacySubtitleId;
  final String? uploader;
  final int? featureId;
  final String? featureType;
  final int? year;
  final String? title;
  final String? movieName;
  final int? imdbId;
  final int? tmdbId;
  final int? seasonNumber;
  final int? episodeNumber;
  final Map<String, dynamic>? files;
  final Map<String, dynamic>? relatedLinks;
  final String? url;

  const OpenSubtitlesSubtitleAttributes({
    this.subtitleId,
    required this.language,
    this.downloadCount,
    this.newDownloadCount,
    this.hearingImpaired,
    this.hd,
    this.fps,
    this.votes,
    this.ratings,
    this.fromTrusted,
    this.foreignPartsOnly,
    this.uploadDate,
    this.aiTranslated,
    this.machineTranslated,
    this.release,
    this.comments,
    this.legacySubtitleId,
    this.uploader,
    this.featureId,
    this.featureType,
    this.year,
    this.title,
    this.movieName,
    this.imdbId,
    this.tmdbId,
    this.seasonNumber,
    this.episodeNumber,
    this.files,
    this.relatedLinks,
    this.url,
  });

  factory OpenSubtitlesSubtitleAttributes.fromJson(Map<String, dynamic> json) {
    return OpenSubtitlesSubtitleAttributes(
      subtitleId: json['subtitle_id'] as String?,
      language: json['language'] as String? ?? '',
      downloadCount: json['download_count'] as int?,
      newDownloadCount: json['new_download_count'] as String?,
      hearingImpaired: json['hearing_impaired'] as int?,
      hd: json['hd'] as int?,
      fps: (json['fps'] as num?)?.toDouble(),
      votes: json['votes'] as int?,
      ratings: (json['ratings'] as num?)?.toDouble(),
      fromTrusted: json['from_trusted'] as int?,
      foreignPartsOnly: json['foreign_parts_only'] as int?,
      uploadDate: json['upload_date'] as String?,
      aiTranslated: json['ai_translated'] as String?,
      machineTranslated: json['machine_translated'] as String?,
      release: json['release'] as String?,
      comments: json['comments'] as String?,
      legacySubtitleId: json['legacy_subtitle_id'] as String?,
      uploader: json['uploader'] as String?,
      featureId: json['feature_id'] as int?,
      featureType: json['feature_type'] as String?,
      year: json['year'] as int?,
      title: json['title'] as String?,
      movieName: json['movie_name'] as String?,
      imdbId: json['imdb_id'] as int?,
      tmdbId: json['tmdb_id'] as int?,
      seasonNumber: json['season_number'] as int?,
      episodeNumber: json['episode_number'] as int?,
      files: json['files'] as Map<String, dynamic>?,
      relatedLinks: json['related_links'] as Map<String, dynamic>?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtitle_id': subtitleId,
      'language': language,
      'download_count': downloadCount,
      'new_download_count': newDownloadCount,
      'hearing_impaired': hearingImpaired,
      'hd': hd,
      'fps': fps,
      'votes': votes,
      'ratings': ratings,
      'from_trusted': fromTrusted,
      'foreign_parts_only': foreignPartsOnly,
      'upload_date': uploadDate,
      'ai_translated': aiTranslated,
      'machine_translated': machineTranslated,
      'release': release,
      'comments': comments,
      'legacy_subtitle_id': legacySubtitleId,
      'uploader': uploader,
      'feature_id': featureId,
      'feature_type': featureType,
      'year': year,
      'title': title,
      'movie_name': movieName,
      'imdb_id': imdbId,
      'tmdb_id': tmdbId,
      'season_number': seasonNumber,
      'episode_number': episodeNumber,
      'files': files,
      'related_links': relatedLinks,
      'url': url,
    };
  }

  OpenSubtitlesSubtitleAttributes copyWith({
    String? subtitleId,
    String? language,
    int? downloadCount,
    String? newDownloadCount,
    int? hearingImpaired,
    int? hd,
    double? fps,
    int? votes,
    double? ratings,
    int? fromTrusted,
    int? foreignPartsOnly,
    String? uploadDate,
    String? aiTranslated,
    String? machineTranslated,
    String? release,
    String? comments,
    String? legacySubtitleId,
    String? uploader,
    int? featureId,
    String? featureType,
    int? year,
    String? title,
    String? movieName,
    int? imdbId,
    int? tmdbId,
    int? seasonNumber,
    int? episodeNumber,
    Map<String, dynamic>? files,
    Map<String, dynamic>? relatedLinks,
    String? url,
  }) {
    return OpenSubtitlesSubtitleAttributes(
      subtitleId: subtitleId ?? this.subtitleId,
      language: language ?? this.language,
      downloadCount: downloadCount ?? this.downloadCount,
      newDownloadCount: newDownloadCount ?? this.newDownloadCount,
      hearingImpaired: hearingImpaired ?? this.hearingImpaired,
      hd: hd ?? this.hd,
      fps: fps ?? this.fps,
      votes: votes ?? this.votes,
      ratings: ratings ?? this.ratings,
      fromTrusted: fromTrusted ?? this.fromTrusted,
      foreignPartsOnly: foreignPartsOnly ?? this.foreignPartsOnly,
      uploadDate: uploadDate ?? this.uploadDate,
      aiTranslated: aiTranslated ?? this.aiTranslated,
      machineTranslated: machineTranslated ?? this.machineTranslated,
      release: release ?? this.release,
      comments: comments ?? this.comments,
      legacySubtitleId: legacySubtitleId ?? this.legacySubtitleId,
      uploader: uploader ?? this.uploader,
      featureId: featureId ?? this.featureId,
      featureType: featureType ?? this.featureType,
      year: year ?? this.year,
      title: title ?? this.title,
      movieName: movieName ?? this.movieName,
      imdbId: imdbId ?? this.imdbId,
      tmdbId: tmdbId ?? this.tmdbId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      files: files ?? this.files,
      relatedLinks: relatedLinks ?? this.relatedLinks,
      url: url ?? this.url,
    );
  }
}

class OpenSubtitlesSubtitleData {
  final String id;
  final String type;
  final OpenSubtitlesSubtitleAttributes attributes;

  const OpenSubtitlesSubtitleData({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory OpenSubtitlesSubtitleData.fromJson(Map<String, dynamic> json) {
    return OpenSubtitlesSubtitleData(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      attributes: OpenSubtitlesSubtitleAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'attributes': attributes.toJson(),
    };
  }

  OpenSubtitlesSubtitleData copyWith({
    String? id,
    String? type,
    OpenSubtitlesSubtitleAttributes? attributes,
  }) {
    return OpenSubtitlesSubtitleData(
      id: id ?? this.id,
      type: type ?? this.type,
      attributes: attributes ?? this.attributes,
    );
  }
}

class OpenSubtitlesSearchResponse {
  final int totalPages;
  final int totalCount;
  final int perPage;
  final int page;
  final List<OpenSubtitlesSubtitleData> data;

  const OpenSubtitlesSearchResponse({
    required this.totalPages,
    required this.totalCount,
    required this.perPage,
    required this.page,
    this.data = const [],
  });

  factory OpenSubtitlesSearchResponse.fromJson(Map<String, dynamic> json) {
    return OpenSubtitlesSearchResponse(
      totalPages: json['total_pages'] as int? ?? 0,
      totalCount: json['total_count'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  OpenSubtitlesSubtitleData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_pages': totalPages,
      'total_count': totalCount,
      'per_page': perPage,
      'page': page,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class OpenSubtitlesDownloadRequest {
  final int fileId;

  const OpenSubtitlesDownloadRequest({
    required this.fileId,
  });

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
    };
  }
}

class OpenSubtitlesDownloadResponse {
  final String link;
  final String fileName;
  final int requests;
  final int remaining;
  final String message;
  final String resetTime;
  final String resetTimeUtc;

  const OpenSubtitlesDownloadResponse({
    required this.link,
    required this.fileName,
    required this.requests,
    required this.remaining,
    required this.message,
    required this.resetTime,
    required this.resetTimeUtc,
  });

  factory OpenSubtitlesDownloadResponse.fromJson(Map<String, dynamic> json) {
    return OpenSubtitlesDownloadResponse(
      link: json['link'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
      requests: json['requests'] as int? ?? 0,
      remaining: json['remaining'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      resetTime: json['reset_time'] as String? ?? '',
      resetTimeUtc: json['reset_time_utc'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'file_name': fileName,
      'requests': requests,
      'remaining': remaining,
      'message': message,
      'reset_time': resetTime,
      'reset_time_utc': resetTimeUtc,
    };
  }

  OpenSubtitlesDownloadResponse copyWith({
    String? link,
    String? fileName,
    int? requests,
    int? remaining,
    String? message,
    String? resetTime,
    String? resetTimeUtc,
  }) {
    return OpenSubtitlesDownloadResponse(
      link: link ?? this.link,
      fileName: fileName ?? this.fileName,
      requests: requests ?? this.requests,
      remaining: remaining ?? this.remaining,
      message: message ?? this.message,
      resetTime: resetTime ?? this.resetTime,
      resetTimeUtc: resetTimeUtc ?? this.resetTimeUtc,
    );
  }
}
