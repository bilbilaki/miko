// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PagedResponseImpl<T> _$$PagedResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$PagedResponseImpl<T>(
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: (json['results'] as List<dynamic>?)?.map(fromJsonT).toList() ??
          const [],
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PagedResponseImplToJson<T>(
  _$PagedResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map(toJsonT).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_$TmdbStatusResponseImpl _$$TmdbStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TmdbStatusResponseImpl(
      statusCode: (json['status_code'] as num?)?.toInt() ?? 0,
      statusMessage: json['status_message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );

Map<String, dynamic> _$$TmdbStatusResponseImplToJson(
        _$TmdbStatusResponseImpl instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'status_message': instance.statusMessage,
      'success': instance.success,
    };

_$TmdbConfigurationImpl _$$TmdbConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$TmdbConfigurationImpl(
      images: json['images'] == null
          ? const TmdbImageConfig()
          : TmdbImageConfig.fromJson(json['images'] as Map<String, dynamic>),
      changeKeys: (json['change_keys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TmdbConfigurationImplToJson(
        _$TmdbConfigurationImpl instance) =>
    <String, dynamic>{
      'images': instance.images,
      'change_keys': instance.changeKeys,
    };

_$TmdbImageConfigImpl _$$TmdbImageConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$TmdbImageConfigImpl(
      baseUrl: json['base_url'] as String? ?? '',
      secureBaseUrl: json['secure_base_url'] as String? ?? '',
      backdropSizes: (json['backdrop_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      logoSizes: (json['logo_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      posterSizes: (json['poster_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      profileSizes: (json['profile_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      stillSizes: (json['still_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TmdbImageConfigImplToJson(
        _$TmdbImageConfigImpl instance) =>
    <String, dynamic>{
      'base_url': instance.baseUrl,
      'secure_base_url': instance.secureBaseUrl,
      'backdrop_sizes': instance.backdropSizes,
      'logo_sizes': instance.logoSizes,
      'poster_sizes': instance.posterSizes,
      'profile_sizes': instance.profileSizes,
      'still_sizes': instance.stillSizes,
    };

_$ImageObjectImpl _$$ImageObjectImplFromJson(Map<String, dynamic> json) =>
    _$ImageObjectImpl(
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      iso6391: json['iso_639_1'] as String?,
      filePath: json['file_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ImageObjectImplToJson(_$ImageObjectImpl instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'height': instance.height,
      'iso_639_1': instance.iso6391,
      'file_path': instance.filePath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
    };

_$ImageResponseImpl _$$ImageResponseImplFromJson(Map<String, dynamic> json) =>
    _$ImageResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      backdrops: (json['backdrops'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      logos: (json['logos'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      posters: (json['posters'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      profiles: (json['profiles'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stills: (json['stills'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ImageResponseImplToJson(_$ImageResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'backdrops': instance.backdrops,
      'logos': instance.logos,
      'posters': instance.posters,
      'profiles': instance.profiles,
      'stills': instance.stills,
    };

_$GenreObjectImpl _$$GenreObjectImplFromJson(Map<String, dynamic> json) =>
    _$GenreObjectImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$GenreObjectImplToJson(_$GenreObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$GenresResponseImpl _$$GenresResponseImplFromJson(Map<String, dynamic> json) =>
    _$GenresResponseImpl(
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GenresResponseImplToJson(
        _$GenresResponseImpl instance) =>
    <String, dynamic>{
      'genres': instance.genres,
    };

_$KeywordObjectImpl _$$KeywordObjectImplFromJson(Map<String, dynamic> json) =>
    _$KeywordObjectImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$KeywordObjectImplToJson(_$KeywordObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$KeywordsResponseImpl _$$KeywordsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$KeywordsResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => KeywordObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => KeywordObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$KeywordsResponseImplToJson(
        _$KeywordsResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keywords': instance.keywords,
      'results': instance.results,
    };

_$TranslationDataImpl _$$TranslationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationDataImpl(
      homepage: json['homepage'] as String?,
      overview: json['overview'] as String?,
      runtime: json['runtime'] as String?,
      tagline: json['tagline'] as String?,
      title: json['title'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$TranslationDataImplToJson(
        _$TranslationDataImpl instance) =>
    <String, dynamic>{
      'homepage': instance.homepage,
      'overview': instance.overview,
      'runtime': instance.runtime,
      'tagline': instance.tagline,
      'title': instance.title,
      'name': instance.name,
    };

_$TranslationImpl _$$TranslationImplFromJson(Map<String, dynamic> json) =>
    _$TranslationImpl(
      iso31661: json['iso_3166_1'] as String? ?? '',
      iso6391: json['iso_639_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
      englishName: json['english_name'] as String? ?? '',
      data: json['data'] == null
          ? const TranslationData()
          : TranslationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TranslationImplToJson(_$TranslationImpl instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'iso_639_1': instance.iso6391,
      'name': instance.name,
      'english_name': instance.englishName,
      'data': instance.data,
    };

_$TranslationsResponseImpl _$$TranslationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationsResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      translations: (json['translations'] as List<dynamic>?)
              ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TranslationsResponseImplToJson(
        _$TranslationsResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'translations': instance.translations,
    };

_$VideoObjectImpl _$$VideoObjectImplFromJson(Map<String, dynamic> json) =>
    _$VideoObjectImpl(
      iso6391: json['iso_639_1'] as String? ?? '',
      iso31661: json['iso_3166_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
      key: json['key'] as String? ?? '',
      site: json['site'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      official: json['official'] as bool? ?? false,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$$VideoObjectImplToJson(_$VideoObjectImpl instance) =>
    <String, dynamic>{
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
      'key': instance.key,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'published_at': instance.publishedAt?.toIso8601String(),
      'id': instance.id,
    };

_$VideoResponseImpl _$$VideoResponseImplFromJson(Map<String, dynamic> json) =>
    _$VideoResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => VideoObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$VideoResponseImplToJson(_$VideoResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$CertificationImpl _$$CertificationImplFromJson(Map<String, dynamic> json) =>
    _$CertificationImpl(
      certification: json['certification'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CertificationImplToJson(_$CertificationImpl instance) =>
    <String, dynamic>{
      'certification': instance.certification,
      'meaning': instance.meaning,
      'order': instance.order,
    };

_$MovieCertificationsResponseImpl _$$MovieCertificationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieCertificationsResponseImpl(
      certifications: (json['certifications'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) =>
                        Certification.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$MovieCertificationsResponseImplToJson(
        _$MovieCertificationsResponseImpl instance) =>
    <String, dynamic>{
      'certifications': instance.certifications,
    };

_$TvCertificationsResponseImpl _$$TvCertificationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TvCertificationsResponseImpl(
      certifications: (json['certifications'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) =>
                        Certification.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$TvCertificationsResponseImplToJson(
        _$TvCertificationsResponseImpl instance) =>
    <String, dynamic>{
      'certifications': instance.certifications,
    };

_$WatchProviderRegionImpl _$$WatchProviderRegionImplFromJson(
        Map<String, dynamic> json) =>
    _$WatchProviderRegionImpl(
      iso31661: json['iso_3166_1'] as String? ?? '',
      englishName: json['english_name'] as String? ?? '',
      nativeName: json['native_name'] as String? ?? '',
    );

Map<String, dynamic> _$$WatchProviderRegionImplToJson(
        _$WatchProviderRegionImpl instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'english_name': instance.englishName,
      'native_name': instance.nativeName,
    };

_$WatchProviderRegionsResponseImpl _$$WatchProviderRegionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WatchProviderRegionsResponseImpl(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  WatchProviderRegion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WatchProviderRegionsResponseImplToJson(
        _$WatchProviderRegionsResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

_$WatchProviderInfoImpl _$$WatchProviderInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$WatchProviderInfoImpl(
      logoPath: json['logo_path'] as String? ?? '',
      providerId: (json['provider_id'] as num?)?.toInt() ?? 0,
      providerName: json['provider_name'] as String? ?? '',
      displayPriority: (json['display_priority'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WatchProviderInfoImplToJson(
        _$WatchProviderInfoImpl instance) =>
    <String, dynamic>{
      'logo_path': instance.logoPath,
      'provider_id': instance.providerId,
      'provider_name': instance.providerName,
      'display_priority': instance.displayPriority,
    };

_$WatchProviderProvidersResponseImpl
    _$$WatchProviderProvidersResponseImplFromJson(Map<String, dynamic> json) =>
        _$WatchProviderProvidersResponseImpl(
          results: (json['results'] as List<dynamic>?)
                  ?.map((e) =>
                      WatchProviderInfo.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$WatchProviderProvidersResponseImplToJson(
        _$WatchProviderProvidersResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

_$WatchProviderDetailsImpl _$$WatchProviderDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$WatchProviderDetailsImpl(
      link: json['link'] as String? ?? '',
      flatrate: (json['flatrate'] as List<dynamic>?)
              ?.map(
                  (e) => WatchProviderInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rent: (json['rent'] as List<dynamic>?)
              ?.map(
                  (e) => WatchProviderInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      buy: (json['buy'] as List<dynamic>?)
              ?.map(
                  (e) => WatchProviderInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WatchProviderDetailsImplToJson(
        _$WatchProviderDetailsImpl instance) =>
    <String, dynamic>{
      'link': instance.link,
      'flatrate': instance.flatrate,
      'rent': instance.rent,
      'buy': instance.buy,
    };

_$WatchProvidersResponseImpl _$$WatchProvidersResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WatchProvidersResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      results: (json['results'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, WatchProviderDetails.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$WatchProvidersResponseImplToJson(
        _$WatchProvidersResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$TmdbListImpl _$$TmdbListImplFromJson(Map<String, dynamic> json) =>
    _$TmdbListImpl(
      description: json['description'] as String?,
      favoriteCount: (json['favorite_count'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      iso6391: json['iso_639_1'] as String? ?? '',
      listType: json['list_type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
    );

Map<String, dynamic> _$$TmdbListImplToJson(_$TmdbListImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'favorite_count': instance.favoriteCount,
      'id': instance.id,
      'item_count': instance.itemCount,
      'iso_639_1': instance.iso6391,
      'list_type': instance.listType,
      'name': instance.name,
      'poster_path': instance.posterPath,
    };

_$ReviewAuthorDetailsImpl _$$ReviewAuthorDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewAuthorDetailsImpl(
      name: json['name'] as String?,
      username: json['username'] as String?,
      avatarPath: json['avatar_path'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ReviewAuthorDetailsImplToJson(
        _$ReviewAuthorDetailsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'avatar_path': instance.avatarPath,
      'rating': instance.rating,
    };

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      author: json['author'] as String?,
      authorDetails: json['author_details'] == null
          ? null
          : ReviewAuthorDetails.fromJson(
              json['author_details'] as Map<String, dynamic>),
      content: json['content'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: json['id'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'author': instance.author,
      'author_details': instance.authorDetails,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'url': instance.url,
    };

_$MediaAccountStatesImpl _$$MediaAccountStatesImplFromJson(
        Map<String, dynamic> json) =>
    _$MediaAccountStatesImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      favorite: json['favorite'] as bool? ?? false,
      rated: json['rated'] == null
          ? null
          : RatedValue.fromJson(json['rated'] as Map<String, dynamic>),
      watchlist: json['watchlist'] as bool? ?? false,
    );

Map<String, dynamic> _$$MediaAccountStatesImplToJson(
        _$MediaAccountStatesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favorite': instance.favorite,
      'rated': instance.rated,
      'watchlist': instance.watchlist,
    };

_$RatedValueImpl _$$RatedValueImplFromJson(Map<String, dynamic> json) =>
    _$RatedValueImpl(
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$RatedValueImplToJson(_$RatedValueImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

_$ChangesResponseImpl _$$ChangesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangesResponseImpl(
      changes: (json['changes'] as List<dynamic>?)
              ?.map((e) => ChangeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => ChangesListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChangesResponseImplToJson(
        _$ChangesResponseImpl instance) =>
    <String, dynamic>{
      'changes': instance.changes,
      'results': instance.results,
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_$ChangesListItemImpl _$$ChangesListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangesListItemImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      adult: json['adult'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChangesListItemImplToJson(
        _$ChangesListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adult': instance.adult,
    };

_$ChangeItemImpl _$$ChangeItemImplFromJson(Map<String, dynamic> json) =>
    _$ChangeItemImpl(
      key: json['key'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ChangeDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChangeItemImplToJson(_$ChangeItemImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'items': instance.items,
    };

_$ChangeDetailImpl _$$ChangeDetailImplFromJson(Map<String, dynamic> json) =>
    _$ChangeDetailImpl(
      id: json['id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      time: json['time'] as String? ?? '',
      iso6391: json['iso_639_1'] as String?,
      iso31661: json['iso_3166_1'] as String?,
      value: json['value'],
      originalValue: json['original_value'],
    );

Map<String, dynamic> _$$ChangeDetailImplToJson(_$ChangeDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'time': instance.time,
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'value': instance.value,
      'original_value': instance.originalValue,
    };

_$ChangesListResponseImpl _$$ChangesListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangesListResponseImpl(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => ChangesListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChangesListResponseImplToJson(
        _$ChangesListResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_$CollectionPartImpl _$$CollectionPartImplFromJson(Map<String, dynamic> json) =>
    _$CollectionPartImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      mediaType: json['media_type'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CollectionPartImplToJson(
        _$CollectionPartImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$CollectionImpl _$$CollectionImplFromJson(Map<String, dynamic> json) =>
    _$CollectionImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      parts: (json['parts'] as List<dynamic>?)
              ?.map((e) => CollectionPart.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CollectionImplToJson(_$CollectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'parts': instance.parts,
    };

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      description: json['description'] as String?,
      headquarters: json['headquarters'] as String?,
      homepage: json['homepage'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String? ?? '',
      originCountry: json['origin_country'] as String? ?? '',
      parentCompany: json['parent_company'] == null
          ? null
          : Company.fromJson(json['parent_company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'headquarters': instance.headquarters,
      'homepage': instance.homepage,
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
      'parent_company': instance.parentCompany,
    };

_$CompanyAlternativeNameImpl _$$CompanyAlternativeNameImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyAlternativeNameImpl(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$$CompanyAlternativeNameImplToJson(
        _$CompanyAlternativeNameImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };

_$CompanyAlternativeNamesResponseImpl
    _$$CompanyAlternativeNamesResponseImplFromJson(Map<String, dynamic> json) =>
        _$CompanyAlternativeNamesResponseImpl(
          id: (json['id'] as num?)?.toInt() ?? 0,
          results: (json['results'] as List<dynamic>?)
                  ?.map((e) => CompanyAlternativeName.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$CompanyAlternativeNamesResponseImplToJson(
        _$CompanyAlternativeNamesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$CompanyImagesResponseImpl _$$CompanyImagesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyImagesResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      logos: (json['logos'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CompanyImagesResponseImplToJson(
        _$CompanyImagesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logos': instance.logos,
    };

_$CreditDetailsImpl _$$CreditDetailsImplFromJson(Map<String, dynamic> json) =>
    _$CreditDetailsImpl(
      creditType: json['credit_type'] as String? ?? '',
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
      media: json['media'] == null
          ? const CreditMedia()
          : CreditMedia.fromJson(json['media'] as Map<String, dynamic>),
      mediaType: json['media_type'] as String? ?? '',
      id: json['id'] as String? ?? '',
      person: json['person'] == null
          ? const CreditPersonDetails()
          : CreditPersonDetails.fromJson(
              json['person'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreditDetailsImplToJson(_$CreditDetailsImpl instance) =>
    <String, dynamic>{
      'credit_type': instance.creditType,
      'department': instance.department,
      'job': instance.job,
      'media': instance.media,
      'media_type': instance.mediaType,
      'id': instance.id,
      'person': instance.person,
    };

_$CreditMediaImpl _$$CreditMediaImplFromJson(Map<String, dynamic> json) =>
    _$CreditMediaImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      title: json['title'] as String?,
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      mediaType: json['media_type'] as String? ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      firstAirDate: json['first_air_date'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      originCountry: (json['origin_country'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      character: json['character'] as String?,
      episodes: json['episodes'] as List<dynamic>? ?? const [],
      seasons: json['seasons'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$$CreditMediaImplToJson(_$CreditMediaImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'media_type': instance.mediaType,
      'genre_ids': instance.genreIds,
      'popularity': instance.popularity,
      'first_air_date': instance.firstAirDate,
      'release_date': instance.releaseDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'origin_country': instance.originCountry,
      'character': instance.character,
      'episodes': instance.episodes,
      'seasons': instance.seasons,
    };

_$CreditPersonDetailsImpl _$$CreditPersonDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$CreditPersonDetailsImpl(
      adult: json['adult'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$$CreditPersonDetailsImplToJson(
        _$CreditPersonDetailsImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'media_type': instance.mediaType,
      'popularity': instance.popularity,
      'gender': instance.gender,
      'known_for_department': instance.knownForDepartment,
      'profile_path': instance.profilePath,
    };

_$FindByIdResponseImpl _$$FindByIdResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FindByIdResponseImpl(
      movieResults: (json['movie_results'] as List<dynamic>?)
              ?.map((e) => MovieResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      personResults: (json['person_results'] as List<dynamic>?)
              ?.map((e) => PersonResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tvResults: (json['tv_results'] as List<dynamic>?)
              ?.map((e) => TvShowResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tvEpisodeResults: (json['tv_episode_results'] as List<dynamic>?)
              ?.map((e) => TvEpisode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tvSeasonResults: (json['tv_season_results'] as List<dynamic>?)
              ?.map((e) => TvSeason.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FindByIdResponseImplToJson(
        _$FindByIdResponseImpl instance) =>
    <String, dynamic>{
      'movie_results': instance.movieResults,
      'person_results': instance.personResults,
      'tv_results': instance.tvResults,
      'tv_episode_results': instance.tvEpisodeResults,
      'tv_season_results': instance.tvSeasonResults,
    };

_$ListItemStatusResponseImpl _$$ListItemStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ListItemStatusResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      itemPresent: json['item_present'] as bool? ?? false,
    );

Map<String, dynamic> _$$ListItemStatusResponseImplToJson(
        _$ListItemStatusResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_present': instance.itemPresent,
    };

_$TmdbListDetailsImpl _$$TmdbListDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$TmdbListDetailsImpl(
      createdBy: json['created_by'] as String? ?? '',
      description: json['description'] as String?,
      favoriteCount: (json['favorite_count'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CollectionPart.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      iso6391: json['iso_639_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
    );

Map<String, dynamic> _$$TmdbListDetailsImplToJson(
        _$TmdbListDetailsImpl instance) =>
    <String, dynamic>{
      'created_by': instance.createdBy,
      'description': instance.description,
      'favorite_count': instance.favoriteCount,
      'id': instance.id,
      'items': instance.items,
      'item_count': instance.itemCount,
      'iso_639_1': instance.iso6391,
      'name': instance.name,
      'poster_path': instance.posterPath,
    };

_$MovieResultImpl _$$MovieResultImplFromJson(Map<String, dynamic> json) =>
    _$MovieResultImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      mediaType: json['media_type'] as String?,
    );

Map<String, dynamic> _$$MovieResultImplToJson(_$MovieResultImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'media_type': instance.mediaType,
    };

_$MovieResultWithRatingImpl _$$MovieResultWithRatingImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieResultWithRatingImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      mediaType: json['media_type'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MovieResultWithRatingImplToJson(
        _$MovieResultWithRatingImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'media_type': instance.mediaType,
      'rating': instance.rating,
    };

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      belongsToCollection: json['belongs_to_collection'] == null
          ? null
          : MovieCollection.fromJson(
              json['belongs_to_collection'] as Map<String, dynamic>),
      budget: (json['budget'] as num?)?.toInt() ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      homepage: json['homepage'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      releaseDate: json['release_date'] as String? ?? '',
      revenue: (json['revenue'] as num?)?.toInt() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['status'] as String? ?? '',
      tagline: json['tagline'] as String?,
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'belongs_to_collection': instance.belongsToCollection,
      'budget': instance.budget,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$MovieCollectionImpl _$$MovieCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieCollectionImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
    );

Map<String, dynamic> _$$MovieCollectionImplToJson(
        _$MovieCollectionImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'id': instance.id,
      'name': instance.name,
      'poster_path': instance.posterPath,
    };

_$ProductionCompanyImpl _$$ProductionCompanyImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductionCompanyImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String? ?? '',
      originCountry: json['origin_country'] as String? ?? '',
    );

Map<String, dynamic> _$$ProductionCompanyImplToJson(
        _$ProductionCompanyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
    };

_$ProductionCountryImpl _$$ProductionCountryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductionCountryImpl(
      iso31661: json['iso_3166_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$ProductionCountryImplToJson(
        _$ProductionCountryImpl instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
    };

_$SpokenLanguageImpl _$$SpokenLanguageImplFromJson(Map<String, dynamic> json) =>
    _$SpokenLanguageImpl(
      englishName: json['english_name'] as String? ?? '',
      iso6391: json['iso_639_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$SpokenLanguageImplToJson(
        _$SpokenLanguageImpl instance) =>
    <String, dynamic>{
      'english_name': instance.englishName,
      'iso_639_1': instance.iso6391,
      'name': instance.name,
    };

_$MovieAlternativeTitleImpl _$$MovieAlternativeTitleImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieAlternativeTitleImpl(
      iso31661: json['iso_3166_1'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$$MovieAlternativeTitleImplToJson(
        _$MovieAlternativeTitleImpl instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'title': instance.title,
      'type': instance.type,
    };

_$MovieAlternativeTitlesResponseImpl
    _$$MovieAlternativeTitlesResponseImplFromJson(Map<String, dynamic> json) =>
        _$MovieAlternativeTitlesResponseImpl(
          id: (json['id'] as num?)?.toInt() ?? 0,
          titles: (json['titles'] as List<dynamic>?)
                  ?.map((e) =>
                      MovieAlternativeTitle.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$MovieAlternativeTitlesResponseImplToJson(
        _$MovieAlternativeTitlesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titles': instance.titles,
    };

_$MovieExternalIdsImpl _$$MovieExternalIdsImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieExternalIdsImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      imdbId: json['imdb_id'] as String?,
      wikidataId: json['wikidata_id'] as String?,
      facebookId: json['facebook_id'] as String?,
      instagramId: json['instagram_id'] as String?,
      twitterId: json['twitter_id'] as String?,
    );

Map<String, dynamic> _$$MovieExternalIdsImplToJson(
        _$MovieExternalIdsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'wikidata_id': instance.wikidataId,
      'facebook_id': instance.facebookId,
      'instagram_id': instance.instagramId,
      'twitter_id': instance.twitterId,
    };

_$MovieReleaseDatesResponseImpl _$$MovieReleaseDatesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieReleaseDatesResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => ReleaseDateResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MovieReleaseDatesResponseImplToJson(
        _$MovieReleaseDatesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$ReleaseDateResultImpl _$$ReleaseDateResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ReleaseDateResultImpl(
      iso31661: json['iso_3166_1'] as String? ?? '',
      releaseDates: (json['release_dates'] as List<dynamic>?)
              ?.map((e) => ReleaseDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReleaseDateResultImplToJson(
        _$ReleaseDateResultImpl instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'release_dates': instance.releaseDates,
    };

_$ReleaseDateImpl _$$ReleaseDateImplFromJson(Map<String, dynamic> json) =>
    _$ReleaseDateImpl(
      certification: json['certification'] as String? ?? '',
      descriptors: json['descriptors'] as List<dynamic>? ?? const [],
      iso6391: json['iso_639_1'] as String? ?? '',
      note: json['note'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      type: (json['type'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReleaseDateImplToJson(_$ReleaseDateImpl instance) =>
    <String, dynamic>{
      'certification': instance.certification,
      'descriptors': instance.descriptors,
      'iso_639_1': instance.iso6391,
      'note': instance.note,
      'release_date': instance.releaseDate,
      'type': instance.type,
    };

_$MovieUpcomingResponseImpl _$$MovieUpcomingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieUpcomingResponseImpl(
      dates: json['dates'] == null
          ? const DateRange()
          : DateRange.fromJson(json['dates'] as Map<String, dynamic>),
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => MovieResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MovieUpcomingResponseImplToJson(
        _$MovieUpcomingResponseImpl instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_$MovieNowPlayingResponseImpl _$$MovieNowPlayingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieNowPlayingResponseImpl(
      dates: json['dates'] == null
          ? const DateRange()
          : DateRange.fromJson(json['dates'] as Map<String, dynamic>),
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => MovieResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MovieNowPlayingResponseImplToJson(
        _$MovieNowPlayingResponseImpl instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_$DateRangeImpl _$$DateRangeImplFromJson(Map<String, dynamic> json) =>
    _$DateRangeImpl(
      maximum: json['maximum'] as String? ?? '',
      minimum: json['minimum'] as String? ?? '',
    );

Map<String, dynamic> _$$DateRangeImplToJson(_$DateRangeImpl instance) =>
    <String, dynamic>{
      'maximum': instance.maximum,
      'minimum': instance.minimum,
    };

_$MovieLatestImpl _$$MovieLatestImplFromJson(Map<String, dynamic> json) =>
    _$MovieLatestImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      belongsToCollection: json['belongs_to_collection'] == null
          ? null
          : MovieCollection.fromJson(
              json['belongs_to_collection'] as Map<String, dynamic>),
      budget: (json['budget'] as num?)?.toInt() ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      homepage: json['homepage'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      releaseDate: json['release_date'] as String? ?? '',
      revenue: (json['revenue'] as num?)?.toInt() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['status'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MovieLatestImplToJson(_$MovieLatestImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'belongs_to_collection': instance.belongsToCollection,
      'budget': instance.budget,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$TvShowResultImpl _$$TvShowResultImplFromJson(Map<String, dynamic> json) =>
    _$TvShowResultImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originCountry: (json['origin_country'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      name: json['name'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      mediaType: json['media_type'] as String?,
    );

Map<String, dynamic> _$$TvShowResultImplToJson(_$TvShowResultImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'first_air_date': instance.firstAirDate,
      'name': instance.name,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'media_type': instance.mediaType,
    };

_$TvShowResultWithRatingImpl _$$TvShowResultWithRatingImplFromJson(
        Map<String, dynamic> json) =>
    _$TvShowResultWithRatingImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originCountry: (json['origin_country'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      name: json['name'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      mediaType: json['media_type'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TvShowResultWithRatingImplToJson(
        _$TvShowResultWithRatingImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'first_air_date': instance.firstAirDate,
      'name': instance.name,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'media_type': instance.mediaType,
      'rating': instance.rating,
    };

_$CreatedByImpl _$$CreatedByImplFromJson(Map<String, dynamic> json) =>
    _$CreatedByImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      creditId: json['credit_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$$CreatedByImplToJson(_$CreatedByImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'credit_id': instance.creditId,
      'name': instance.name,
      'gender': instance.gender,
      'profile_path': instance.profilePath,
    };

_$LastEpisodeToAirImpl _$$LastEpisodeToAirImplFromJson(
        Map<String, dynamic> json) =>
    _$LastEpisodeToAirImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      airDate: json['air_date'] as String?,
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      productionCode: json['production_code'] as String? ?? '',
      runtime: (json['runtime'] as num?)?.toInt(),
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      showId: (json['show_id'] as num?)?.toInt() ?? 0,
      stillPath: json['still_path'] as String?,
    );

Map<String, dynamic> _$$LastEpisodeToAirImplToJson(
        _$LastEpisodeToAirImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'air_date': instance.airDate,
      'episode_number': instance.episodeNumber,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'still_path': instance.stillPath,
    };

_$TvNetworkImpl _$$TvNetworkImplFromJson(Map<String, dynamic> json) =>
    _$TvNetworkImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String? ?? '',
      originCountry: json['origin_country'] as String? ?? '',
    );

Map<String, dynamic> _$$TvNetworkImplToJson(_$TvNetworkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
    };

_$TvSeasonObjectImpl _$$TvSeasonObjectImplFromJson(Map<String, dynamic> json) =>
    _$TvSeasonObjectImpl(
      airDate: json['air_date'] as String?,
      episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TvSeasonObjectImplToJson(
        _$TvSeasonObjectImpl instance) =>
    <String, dynamic>{
      'air_date': instance.airDate,
      'episode_count': instance.episodeCount,
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'season_number': instance.seasonNumber,
      'vote_average': instance.voteAverage,
    };

_$TvShowImpl _$$TvShowImplFromJson(Map<String, dynamic> json) => _$TvShowImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      createdBy: (json['created_by'] as List<dynamic>?)
              ?.map((e) => CreatedBy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      episodeRunTime: (json['episode_run_time'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      firstAirDate: json['first_air_date'] as String?,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      homepage: json['homepage'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      inProduction: json['in_production'] as bool? ?? false,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastAirDate: json['last_air_date'] as String?,
      lastEpisodeToAir: json['last_episode_to_air'] == null
          ? null
          : LastEpisodeToAir.fromJson(
              json['last_episode_to_air'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '',
      nextEpisodeToAir: json['next_episode_to_air'] == null
          ? null
          : LastEpisodeToAir.fromJson(
              json['next_episode_to_air'] as Map<String, dynamic>),
      networks: (json['networks'] as List<dynamic>?)
              ?.map((e) => TvNetwork.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      numberOfEpisodes: (json['number_of_episodes'] as num?)?.toInt() ?? 0,
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt() ?? 0,
      originCountry: (json['origin_country'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((e) => TvSeasonObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['status'] as String? ?? '',
      tagline: json['tagline'] as String?,
      type: json['type'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvShowImplToJson(_$TvShowImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'created_by': instance.createdBy,
      'episode_run_time': instance.episodeRunTime,
      'first_air_date': instance.firstAirDate,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'in_production': instance.inProduction,
      'languages': instance.languages,
      'last_air_date': instance.lastAirDate,
      'last_episode_to_air': instance.lastEpisodeToAir,
      'name': instance.name,
      'next_episode_to_air': instance.nextEpisodeToAir,
      'networks': instance.networks,
      'number_of_episodes': instance.numberOfEpisodes,
      'number_of_seasons': instance.numberOfSeasons,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'seasons': instance.seasons,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'type': instance.type,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$EpisodeGuestStarImpl _$$EpisodeGuestStarImplFromJson(
        Map<String, dynamic> json) =>
    _$EpisodeGuestStarImpl(
      character: json['character'] as String?,
      creditId: json['credit_id'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      adult: json['adult'] as bool? ?? false,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$$EpisodeGuestStarImplToJson(
        _$EpisodeGuestStarImpl instance) =>
    <String, dynamic>{
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
    };

_$TvEpisodeImpl _$$TvEpisodeImplFromJson(Map<String, dynamic> json) =>
    _$TvEpisodeImpl(
      airDate: json['air_date'] as String?,
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => EpisodeCrew.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      guestStars: (json['guest_stars'] as List<dynamic>?)
              ?.map((e) => EpisodeGuestStar.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      productionCode: json['production_code'] as String? ?? '',
      runtime: (json['runtime'] as num?)?.toInt(),
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      showId: (json['show_id'] as num?)?.toInt(),
      stillPath: json['still_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvEpisodeImplToJson(_$TvEpisodeImpl instance) =>
    <String, dynamic>{
      'air_date': instance.airDate,
      'crew': instance.crew,
      'episode_number': instance.episodeNumber,
      'guest_stars': instance.guestStars,
      'name': instance.name,
      'overview': instance.overview,
      'id': instance.id,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'still_path': instance.stillPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$TvSeasonImpl _$$TvSeasonImplFromJson(Map<String, dynamic> json) =>
    _$TvSeasonImpl(
      jsonId: json['_id'] as String?,
      airDate: json['air_date'] as String?,
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((e) => TvEpisode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      posterPath: json['poster_path'] as String?,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TvSeasonImplToJson(_$TvSeasonImpl instance) =>
    <String, dynamic>{
      '_id': instance.jsonId,
      'air_date': instance.airDate,
      'episodes': instance.episodes,
      'name': instance.name,
      'overview': instance.overview,
      'id': instance.id,
      'poster_path': instance.posterPath,
      'season_number': instance.seasonNumber,
      'vote_average': instance.voteAverage,
    };

_$AggregateCastImpl _$$AggregateCastImplFromJson(Map<String, dynamic> json) =>
    _$AggregateCastImpl(
      adult: json['adult'] as bool? ?? false,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => CastRole.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalEpisodeCount: (json['total_episode_count'] as num?)?.toInt() ?? 0,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AggregateCastImplToJson(_$AggregateCastImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'roles': instance.roles,
      'total_episode_count': instance.totalEpisodeCount,
      'order': instance.order,
    };

_$CastRoleImpl _$$CastRoleImplFromJson(Map<String, dynamic> json) =>
    _$CastRoleImpl(
      creditId: json['credit_id'] as String? ?? '',
      character: json['character'] as String? ?? '',
      episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CastRoleImplToJson(_$CastRoleImpl instance) =>
    <String, dynamic>{
      'credit_id': instance.creditId,
      'character': instance.character,
      'episode_count': instance.episodeCount,
    };

_$AggregateCrewImpl _$$AggregateCrewImplFromJson(Map<String, dynamic> json) =>
    _$AggregateCrewImpl(
      adult: json['adult'] as bool? ?? false,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      jobs: (json['jobs'] as List<dynamic>?)
              ?.map((e) => CrewJob.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      department: json['department'] as String? ?? '',
      totalEpisodeCount: (json['total_episode_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AggregateCrewImplToJson(_$AggregateCrewImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'jobs': instance.jobs,
      'department': instance.department,
      'total_episode_count': instance.totalEpisodeCount,
    };

_$CrewJobImpl _$$CrewJobImplFromJson(Map<String, dynamic> json) =>
    _$CrewJobImpl(
      creditId: json['credit_id'] as String? ?? '',
      job: json['job'] as String? ?? '',
      episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CrewJobImplToJson(_$CrewJobImpl instance) =>
    <String, dynamic>{
      'credit_id': instance.creditId,
      'job': instance.job,
      'episode_count': instance.episodeCount,
    };

_$AggregateCreditsResponseImpl _$$AggregateCreditsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AggregateCreditsResponseImpl(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => AggregateCast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => AggregateCrew.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AggregateCreditsResponseImplToJson(
        _$AggregateCreditsResponseImpl instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
      'id': instance.id,
    };

_$TvAlternativeTitleImpl _$$TvAlternativeTitleImplFromJson(
        Map<String, dynamic> json) =>
    _$TvAlternativeTitleImpl(
      iso31661: json['iso_3166_1'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$$TvAlternativeTitleImplToJson(
        _$TvAlternativeTitleImpl instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'title': instance.title,
      'type': instance.type,
    };

_$TvAlternativeTitlesResponseImpl _$$TvAlternativeTitlesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TvAlternativeTitlesResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => TvAlternativeTitle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TvAlternativeTitlesResponseImplToJson(
        _$TvAlternativeTitlesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$TvContentRatingImpl _$$TvContentRatingImplFromJson(
        Map<String, dynamic> json) =>
    _$TvContentRatingImpl(
      descriptors: json['descriptors'] as List<dynamic>? ?? const [],
      iso31661: json['iso_3166_1'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
    );

Map<String, dynamic> _$$TvContentRatingImplToJson(
        _$TvContentRatingImpl instance) =>
    <String, dynamic>{
      'descriptors': instance.descriptors,
      'iso_3166_1': instance.iso31661,
      'rating': instance.rating,
    };

_$TvContentRatingsResponseImpl _$$TvContentRatingsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TvContentRatingsResponseImpl(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => TvContentRating.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvContentRatingsResponseImplToJson(
        _$TvContentRatingsResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'id': instance.id,
    };

_$EpisodeGroupResultImpl _$$EpisodeGroupResultImplFromJson(
        Map<String, dynamic> json) =>
    _$EpisodeGroupResultImpl(
      description: json['description'] as String?,
      episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
      groupCount: (json['group_count'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      network: json['network'] == null
          ? const TvNetwork()
          : TvNetwork.fromJson(json['network'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EpisodeGroupResultImplToJson(
        _$EpisodeGroupResultImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'episode_count': instance.episodeCount,
      'group_count': instance.groupCount,
      'id': instance.id,
      'name': instance.name,
      'network': instance.network,
      'type': instance.type,
    };

_$TvEpisodeGroupsResponseImpl _$$TvEpisodeGroupsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TvEpisodeGroupsResponseImpl(
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => EpisodeGroupResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvEpisodeGroupsResponseImplToJson(
        _$TvEpisodeGroupsResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'id': instance.id,
    };

_$TvExternalIdsImpl _$$TvExternalIdsImplFromJson(Map<String, dynamic> json) =>
    _$TvExternalIdsImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      imdbId: json['imdb_id'] as String?,
      freebaseMid: json['freebase_mid'] as String?,
      freebaseId: json['freebase_id'] as String?,
      tvdbId: (json['tvdb_id'] as num?)?.toInt(),
      tvrageId: (json['tvrage_id'] as num?)?.toInt(),
      wikidataId: json['wikidata_id'] as String?,
      facebookId: json['facebook_id'] as String?,
      instagramId: json['instagram_id'] as String?,
      twitterId: json['twitter_id'] as String?,
    );

Map<String, dynamic> _$$TvExternalIdsImplToJson(_$TvExternalIdsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'freebase_mid': instance.freebaseMid,
      'freebase_id': instance.freebaseId,
      'tvdb_id': instance.tvdbId,
      'tvrage_id': instance.tvrageId,
      'wikidata_id': instance.wikidataId,
      'facebook_id': instance.facebookId,
      'instagram_id': instance.instagramId,
      'twitter_id': instance.twitterId,
    };

_$TvScreenedTheatricallyResultImpl _$$TvScreenedTheatricallyResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TvScreenedTheatricallyResultImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvScreenedTheatricallyResultImplToJson(
        _$TvScreenedTheatricallyResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episode_number': instance.episodeNumber,
      'season_number': instance.seasonNumber,
    };

_$TvScreenedTheatricallyResponseImpl
    _$$TvScreenedTheatricallyResponseImplFromJson(Map<String, dynamic> json) =>
        _$TvScreenedTheatricallyResponseImpl(
          id: (json['id'] as num?)?.toInt() ?? 0,
          results: (json['results'] as List<dynamic>?)
                  ?.map((e) => TvScreenedTheatricallyResult.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$TvScreenedTheatricallyResponseImplToJson(
        _$TvScreenedTheatricallyResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$TvSeriesLatestImpl _$$TvSeriesLatestImplFromJson(Map<String, dynamic> json) =>
    _$TvSeriesLatestImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      createdBy: (json['created_by'] as List<dynamic>?)
              ?.map((e) => CreatedBy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      episodeRunTime: (json['episode_run_time'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      firstAirDate: json['first_air_date'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      homepage: json['homepage'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      inProduction: json['in_production'] as bool? ?? false,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastAirDate: json['last_air_date'] as String? ?? '',
      lastEpisodeToAir: json['last_episode_to_air'] == null
          ? null
          : LastEpisodeToAir.fromJson(
              json['last_episode_to_air'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '',
      nextEpisodeToAir: json['next_episode_to_air'] == null
          ? null
          : LastEpisodeToAir.fromJson(
              json['next_episode_to_air'] as Map<String, dynamic>),
      networks: (json['networks'] as List<dynamic>?)
              ?.map((e) => TvNetwork.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      numberOfEpisodes: (json['number_of_episodes'] as num?)?.toInt() ?? 0,
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt() ?? 0,
      originCountry: (json['origin_country'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map(
                  (e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((e) => TvSeasonObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['status'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      type: json['type'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvSeriesLatestImplToJson(
        _$TvSeriesLatestImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'created_by': instance.createdBy,
      'episode_run_time': instance.episodeRunTime,
      'first_air_date': instance.firstAirDate,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'in_production': instance.inProduction,
      'languages': instance.languages,
      'last_air_date': instance.lastAirDate,
      'last_episode_to_air': instance.lastEpisodeToAir,
      'name': instance.name,
      'next_episode_to_air': instance.nextEpisodeToAir,
      'networks': instance.networks,
      'number_of_episodes': instance.numberOfEpisodes,
      'number_of_seasons': instance.numberOfSeasons,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'seasons': instance.seasons,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'type': instance.type,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$TvEpisodeWithRatingImpl _$$TvEpisodeWithRatingImplFromJson(
        Map<String, dynamic> json) =>
    _$TvEpisodeWithRatingImpl(
      airDate: json['air_date'] as String?,
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => EpisodeCrew.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      guestStars: (json['guest_stars'] as List<dynamic>?)
              ?.map((e) => EpisodeGuestStar.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      productionCode: json['production_code'] as String? ?? '',
      runtime: (json['runtime'] as num?)?.toInt(),
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      showId: (json['show_id'] as num?)?.toInt(),
      stillPath: json['still_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TvEpisodeWithRatingImplToJson(
        _$TvEpisodeWithRatingImpl instance) =>
    <String, dynamic>{
      'air_date': instance.airDate,
      'crew': instance.crew,
      'episode_number': instance.episodeNumber,
      'guest_stars': instance.guestStars,
      'name': instance.name,
      'overview': instance.overview,
      'id': instance.id,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'show_id': instance.showId,
      'still_path': instance.stillPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'rating': instance.rating,
    };

_$TvSeasonAccountStatesImpl _$$TvSeasonAccountStatesImplFromJson(
        Map<String, dynamic> json) =>
    _$TvSeasonAccountStatesImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  EpisodeAccountState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TvSeasonAccountStatesImplToJson(
        _$TvSeasonAccountStatesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };

_$EpisodeAccountStateImpl _$$EpisodeAccountStateImplFromJson(
        Map<String, dynamic> json) =>
    _$EpisodeAccountStateImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      rated: json['rated'] == null
          ? null
          : RatedValue.fromJson(json['rated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EpisodeAccountStateImplToJson(
        _$EpisodeAccountStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episode_number': instance.episodeNumber,
      'rated': instance.rated,
    };

_$TvSeasonExternalIdsImpl _$$TvSeasonExternalIdsImplFromJson(
        Map<String, dynamic> json) =>
    _$TvSeasonExternalIdsImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      freebaseMid: json['freebase_mid'] as String?,
      freebaseId: json['freebase_id'] as String?,
      tvdbId: (json['tvdb_id'] as num?)?.toInt(),
      tvrageId: (json['tvrage_id'] as num?)?.toInt(),
      wikidataId: json['wikidata_id'] as String?,
    );

Map<String, dynamic> _$$TvSeasonExternalIdsImplToJson(
        _$TvSeasonExternalIdsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'freebase_mid': instance.freebaseMid,
      'freebase_id': instance.freebaseId,
      'tvdb_id': instance.tvdbId,
      'tvrage_id': instance.tvrageId,
      'wikidata_id': instance.wikidataId,
    };

_$TvEpisodeExternalIdsImpl _$$TvEpisodeExternalIdsImplFromJson(
        Map<String, dynamic> json) =>
    _$TvEpisodeExternalIdsImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      imdbId: json['imdb_id'] as String?,
      freebaseMid: json['freebase_mid'] as String?,
      freebaseId: json['freebase_id'] as String?,
      tvdbId: (json['tvdb_id'] as num?)?.toInt(),
      tvrageId: (json['tvrage_id'] as num?)?.toInt(),
      wikidataId: json['wikidata_id'] as String?,
    );

Map<String, dynamic> _$$TvEpisodeExternalIdsImplToJson(
        _$TvEpisodeExternalIdsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'freebase_mid': instance.freebaseMid,
      'freebase_id': instance.freebaseId,
      'tvdb_id': instance.tvdbId,
      'tvrage_id': instance.tvrageId,
      'wikidata_id': instance.wikidataId,
    };

_$PersonResultImpl _$$PersonResultImplFromJson(Map<String, dynamic> json) =>
    _$PersonResultImpl(
      adult: json['adult'] as bool? ?? false,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      knownFor: json['known_for'] as List<dynamic>? ?? const [],
      mediaType: json['media_type'] as String?,
    );

Map<String, dynamic> _$$PersonResultImplToJson(_$PersonResultImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'known_for': instance.knownFor,
      'media_type': instance.mediaType,
    };

_$PersonImpl _$$PersonImplFromJson(Map<String, dynamic> json) => _$PersonImpl(
      adult: json['adult'] as bool? ?? false,
      alsoKnownAs: (json['also_known_as'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      homepage: json['homepage'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      imdbId: json['imdb_id'] as String?,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$$PersonImplToJson(_$PersonImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'also_known_as': instance.alsoKnownAs,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'gender': instance.gender,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'place_of_birth': instance.placeOfBirth,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
    };

_$PersonImagesResponseImpl _$$PersonImagesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonImagesResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      profiles: (json['profiles'] as List<dynamic>?)
              ?.map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PersonImagesResponseImplToJson(
        _$PersonImagesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profiles': instance.profiles,
    };

_$EpisodeCrewImpl _$$EpisodeCrewImplFromJson(Map<String, dynamic> json) =>
    _$EpisodeCrewImpl(
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
      creditId: json['credit_id'] as String? ?? '',
      adult: json['adult'] as bool? ?? false,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      episodeCount: (json['episode_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EpisodeCrewImplToJson(_$EpisodeCrewImpl instance) =>
    <String, dynamic>{
      'department': instance.department,
      'job': instance.job,
      'credit_id': instance.creditId,
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'episode_count': instance.episodeCount,
    };

_$CastMemberImpl _$$CastMemberImplFromJson(Map<String, dynamic> json) =>
    _$CastMemberImpl(
      adult: json['adult'] as bool? ?? false,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      castId: (json['cast_id'] as num?)?.toInt(),
      character: json['character'] as String?,
      creditId: json['credit_id'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      episodeCount: (json['episode_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CastMemberImplToJson(_$CastMemberImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'episode_count': instance.episodeCount,
    };

_$CreditsResponseImpl _$$CreditsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreditsResponseImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => CastMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => EpisodeCrew.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      guestStars: (json['guest_stars'] as List<dynamic>?)
              ?.map((e) => EpisodeGuestStar.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CreditsResponseImplToJson(
        _$CreditsResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
      'crew': instance.crew,
      'guest_stars': instance.guestStars,
    };

_$PersonMovieCreditItemImpl _$$PersonMovieCreditItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonMovieCreditItemImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      character: json['character'] as String?,
      creditId: json['credit_id'] as String?,
      order: (json['order'] as num?)?.toInt(),
      department: json['department'] as String?,
      job: json['job'] as String?,
      mediaType: json['media_type'] as String?,
    );

Map<String, dynamic> _$$PersonMovieCreditItemImplToJson(
        _$PersonMovieCreditItemImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'department': instance.department,
      'job': instance.job,
      'media_type': instance.mediaType,
    };

_$PersonMovieCreditsImpl _$$PersonMovieCreditsImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonMovieCreditsImpl(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) =>
                  PersonMovieCreditItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) =>
                  PersonMovieCreditItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PersonMovieCreditsImplToJson(
        _$PersonMovieCreditsImpl instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
      'id': instance.id,
    };

_$PersonTvCreditItemImpl _$$PersonTvCreditItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonTvCreditItemImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      originCountry: (json['origin_country'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      name: json['name'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      character: json['character'] as String?,
      creditId: json['credit_id'] as String?,
      episodeCount: (json['episodeCount'] as num?)?.toInt(),
      department: json['department'] as String?,
      job: json['job'] as String?,
      mediaType: json['media_type'] as String?,
    );

Map<String, dynamic> _$$PersonTvCreditItemImplToJson(
        _$PersonTvCreditItemImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'first_air_date': instance.firstAirDate,
      'name': instance.name,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'character': instance.character,
      'credit_id': instance.creditId,
      'episodeCount': instance.episodeCount,
      'department': instance.department,
      'job': instance.job,
      'media_type': instance.mediaType,
    };

_$PersonTvCreditsImpl _$$PersonTvCreditsImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonTvCreditsImpl(
      cast: (json['cast'] as List<dynamic>?)
              ?.map(
                  (e) => PersonTvCreditItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map(
                  (e) => PersonTvCreditItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PersonTvCreditsImplToJson(
        _$PersonTvCreditsImpl instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
      'id': instance.id,
    };

_$PersonCombinedCreditsImpl _$$PersonCombinedCreditsImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonCombinedCreditsImpl(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) =>
                  PersonMovieCreditItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) =>
                  PersonMovieCreditItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PersonCombinedCreditsImplToJson(
        _$PersonCombinedCreditsImpl instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
      'id': instance.id,
    };

_$PersonExternalIdsImpl _$$PersonExternalIdsImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonExternalIdsImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      freebaseMid: json['freebase_mid'] as String?,
      freebaseId: json['freebase_id'] as String?,
      imdbId: json['imdb_id'] as String?,
      tvrageId: (json['tvrage_id'] as num?)?.toInt(),
      wikidataId: json['wikidata_id'] as String?,
      facebookId: json['facebook_id'] as String?,
      instagramId: json['instagram_id'] as String?,
      tiktokId: json['tiktok_id'] as String?,
      twitterId: json['twitter_id'] as String?,
      youtubeId: json['youtube_id'] as String?,
    );

Map<String, dynamic> _$$PersonExternalIdsImplToJson(
        _$PersonExternalIdsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'freebase_mid': instance.freebaseMid,
      'freebase_id': instance.freebaseId,
      'imdb_id': instance.imdbId,
      'tvrage_id': instance.tvrageId,
      'wikidata_id': instance.wikidataId,
      'facebook_id': instance.facebookId,
      'instagram_id': instance.instagramId,
      'tiktok_id': instance.tiktokId,
      'twitter_id': instance.twitterId,
      'youtube_id': instance.youtubeId,
    };

_$TaggedImageMediaImpl _$$TaggedImageMediaImplFromJson(
        Map<String, dynamic> json) =>
    _$TaggedImageMediaImpl(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      mediaType: json['media_type'] as String? ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String?,
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TaggedImageMediaImplToJson(
        _$TaggedImageMediaImpl instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'id': instance.id,
      'title': instance.title,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'media_type': instance.mediaType,
      'genre_ids': instance.genreIds,
      'popularity': instance.popularity,
      'release_date': instance.releaseDate,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_$TaggedImageResultImpl _$$TaggedImageResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TaggedImageResultImpl(
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble() ?? 0.0,
      filePath: json['file_path'] as String? ?? '',
      height: (json['height'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
      iso6391: json['iso_639_1'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt() ?? 0,
      imageType: json['image_type'] as String? ?? '',
      media: json['media'] == null
          ? const TaggedImageMedia()
          : TaggedImageMedia.fromJson(json['media'] as Map<String, dynamic>),
      mediaType: json['media_type'] as String? ?? '',
    );

Map<String, dynamic> _$$TaggedImageResultImplToJson(
        _$TaggedImageResultImpl instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'file_path': instance.filePath,
      'height': instance.height,
      'id': instance.id,
      'iso_639_1': instance.iso6391,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
      'image_type': instance.imageType,
      'media': instance.media,
      'media_type': instance.mediaType,
    };

_$GuestSessionImpl _$$GuestSessionImplFromJson(Map<String, dynamic> json) =>
    _$GuestSessionImpl(
      success: json['success'] as bool? ?? false,
      guestSessionId: json['guest_session_id'] as String? ?? '',
      expiresAt: json['expires_at'] as String? ?? '',
    );

Map<String, dynamic> _$$GuestSessionImplToJson(_$GuestSessionImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'guest_session_id': instance.guestSessionId,
      'expires_at': instance.expiresAt,
    };

_$RequestTokenImpl _$$RequestTokenImplFromJson(Map<String, dynamic> json) =>
    _$RequestTokenImpl(
      success: json['success'] as bool? ?? false,
      expiresAt: json['expires_at'] as String? ?? '',
      requestToken: json['request_token'] as String? ?? '',
    );

Map<String, dynamic> _$$RequestTokenImplToJson(_$RequestTokenImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'expires_at': instance.expiresAt,
      'request_token': instance.requestToken,
    };

_$UserSessionImpl _$$UserSessionImplFromJson(Map<String, dynamic> json) =>
    _$UserSessionImpl(
      success: json['success'] as bool? ?? false,
      sessionId: json['session_id'] as String? ?? '',
    );

Map<String, dynamic> _$$UserSessionImplToJson(_$UserSessionImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'session_id': instance.sessionId,
    };

_$AccountDetailsImpl _$$AccountDetailsImplFromJson(Map<String, dynamic> json) =>
    _$AccountDetailsImpl(
      avatar: json['avatar'] == null
          ? const AccountAvatar()
          : AccountAvatar.fromJson(json['avatar'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt() ?? 0,
      iso6391: json['iso_639_1'] as String? ?? '',
      iso31661: json['iso_3166_1'] as String? ?? '',
      name: json['name'] as String?,
      includeAdult: json['include_adult'] as bool? ?? false,
      username: json['username'] as String? ?? '',
    );

Map<String, dynamic> _$$AccountDetailsImplToJson(
        _$AccountDetailsImpl instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'id': instance.id,
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
      'include_adult': instance.includeAdult,
      'username': instance.username,
    };

_$AccountAvatarImpl _$$AccountAvatarImplFromJson(Map<String, dynamic> json) =>
    _$AccountAvatarImpl(
      gravatar: json['gravatar'] == null
          ? const GravatarDetails()
          : GravatarDetails.fromJson(json['gravatar'] as Map<String, dynamic>),
      tmdb: json['tmdb'] == null
          ? const TmdbAvatarDetails()
          : TmdbAvatarDetails.fromJson(json['tmdb'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AccountAvatarImplToJson(_$AccountAvatarImpl instance) =>
    <String, dynamic>{
      'gravatar': instance.gravatar,
      'tmdb': instance.tmdb,
    };

_$GravatarDetailsImpl _$$GravatarDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$GravatarDetailsImpl(
      hash: json['hash'] as String? ?? '',
    );

Map<String, dynamic> _$$GravatarDetailsImplToJson(
        _$GravatarDetailsImpl instance) =>
    <String, dynamic>{
      'hash': instance.hash,
    };

_$TmdbAvatarDetailsImpl _$$TmdbAvatarDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$TmdbAvatarDetailsImpl(
      avatarPath: json['avatar_path'] as String?,
    );

Map<String, dynamic> _$$TmdbAvatarDetailsImplToJson(
        _$TmdbAvatarDetailsImpl instance) =>
    <String, dynamic>{
      'avatar_path': instance.avatarPath,
    };
