// tmdb_models.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart'; // For @required and debug logging

part 'tmdb_models.freezed.dart';
part 'tmdb_models.g.dart';

// --- Common Base/Utility Models ---

@Freezed(genericArgumentFactories: true)
class PagedResponse<T> with _$PagedResponse<T> {
  const factory PagedResponse({
    @Default(1) int page,
    @Default([]) List<T> results,
    @Default(0) @JsonKey(name: 'total_pages') int totalPages,
    @Default(0) @JsonKey(name: 'total_results') int totalResults,
  }) = _PagedResponse;

  factory PagedResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PagedResponseFromJson<T>(json, fromJsonT);
}

@freezed
class TmdbStatusResponse with _$TmdbStatusResponse {
  const factory TmdbStatusResponse({
    @Default(0) @JsonKey(name: 'status_code') int statusCode,
    @Default('') @JsonKey(name: 'status_message') String statusMessage,
    @Default(false) bool success, // Often returned by auth endpoints
  }) = _TmdbStatusResponse;

  factory TmdbStatusResponse.fromJson(Map<String, dynamic> json) => _$TmdbStatusResponseFromJson(json);
}

@freezed
class TmdbConfiguration with _$TmdbConfiguration {
  const factory TmdbConfiguration({
    @Default(TmdbImageConfig()) TmdbImageConfig images,
    @Default([]) @JsonKey(name: 'change_keys') List<String> changeKeys,
  }) = _TmdbConfiguration;

  factory TmdbConfiguration.fromJson(Map<String, dynamic> json) => _$TmdbConfigurationFromJson(json);
}

@freezed
class TmdbImageConfig with _$TmdbImageConfig {
  const factory TmdbImageConfig({
    @Default('') @JsonKey(name: 'base_url') String baseUrl,
    @Default('') @JsonKey(name: 'secure_base_url') String secureBaseUrl,
    @Default([]) @JsonKey(name: 'backdrop_sizes') List<String> backdropSizes,
    @Default([]) @JsonKey(name: 'logo_sizes') List<String> logoSizes,
    @Default([]) @JsonKey(name: 'poster_sizes') List<String> posterSizes,
    @Default([]) @JsonKey(name: 'profile_sizes') List<String> profileSizes,
    @Default([]) @JsonKey(name: 'still_sizes') List<String> stillSizes,
  }) = _TmdbImageConfig;

  factory TmdbImageConfig.fromJson(Map<String, dynamic> json) => _$TmdbImageConfigFromJson(json);
}

@freezed
class ImageObject with _$ImageObject {
  const factory ImageObject({
    @Default(0.0) @JsonKey(name: 'aspect_ratio') double aspectRatio,
    @Default(0) int height,
    @JsonKey(name: 'iso_639_1') String? iso6391, // Nullable
    @Default('') @JsonKey(name: 'file_path') String filePath,
    @Default(0.0) @JsonKey(name: 'vote_average') double voteAverage,
    @Default(0) @JsonKey(name: 'vote_count') int voteCount,
    @Default(0) int width,
  }) = _ImageObject;

  factory ImageObject.fromJson(Map<String, dynamic> json) => _$ImageObjectFromJson(json);
}

@freezed
class ImageResponse with _$ImageResponse {
  const factory ImageResponse({
    @Default(0) int id,
    @Default([]) List<ImageObject> backdrops,
    @Default([]) List<ImageObject> logos,
    @Default([]) List<ImageObject> posters,
    @Default([]) List<ImageObject> profiles, // Specific to Person Images
    @Default([]) List<ImageObject> stills, // Specific to TV Episode Images
  }) = _ImageResponse;

  factory ImageResponse.fromJson(Map<String, dynamic> json) => _$ImageResponseFromJson(json);
}

@freezed
class GenreObject with _$GenreObject {
  const factory GenreObject({
    @Default(0) int id,
    @Default('') String name,
  }) = _GenreObject;

  factory GenreObject.fromJson(Map<String, dynamic> json) => _$GenreObjectFromJson(json);
}

@freezed
class GenresResponse with _$GenresResponse {
  const factory GenresResponse({
    @Default([]) List<GenreObject> genres,
  }) = _GenresResponse;

  factory GenresResponse.fromJson(Map<String, dynamic> json) => _$GenresResponseFromJson(json);
}

@freezed
class KeywordObject with _$KeywordObject {
  const factory KeywordObject({
    @Default(0) int id,
    @Default('') String name,
  }) = _KeywordObject;

  factory KeywordObject.fromJson(Map<String, dynamic> json) => _$KeywordObjectFromJson(json);
}

@freezed
class KeywordsResponse with _$KeywordsResponse {
  const factory KeywordsResponse({
    @Default(0) int id,
    @Default([]) List<KeywordObject> keywords,
    @Default([]) List<KeywordObject> results, // Some keyword responses use 'results' instead of 'keywords'
  }) = _KeywordsResponse;

  factory KeywordsResponse.fromJson(Map<String, dynamic> json) => _$KeywordsResponseFromJson(json);
}


@freezed
class TranslationData with _$TranslationData {
  const factory TranslationData({
    String? homepage,
    String? overview,
    String? runtime,
    String? tagline,
    String? title,
    String? name, // For TV show translations
  }) = _TranslationData;

  factory TranslationData.fromJson(Map<String, dynamic> json) => _$TranslationDataFromJson(json);
}

@freezed
class Translation with _$Translation {
  const factory Translation({
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @Default('') String name,
    @JsonKey(name: 'english_name') @Default('') String englishName,
    @Default(TranslationData()) TranslationData data,
  }) = _Translation;

  factory Translation.fromJson(Map<String, dynamic> json) => _$TranslationFromJson(json);
}

@freezed
class TranslationsResponse with _$TranslationsResponse {
  const factory TranslationsResponse({
    @Default(0) int id,
    @Default([]) List<Translation> translations,
  }) = _TranslationsResponse;

  factory TranslationsResponse.fromJson(Map<String, dynamic> json) => _$TranslationsResponseFromJson(json);
}

@freezed
class VideoObject with _$VideoObject {
  const factory VideoObject({
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @Default('') String name,
    @Default('') String key,
    @Default('') String site,
    @Default(0) int size,
    @Default('') String type,
    @Default(false) bool official,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @Default('') String id,
  }) = _VideoObject;

  factory VideoObject.fromJson(Map<String, dynamic> json) => _$VideoObjectFromJson(json);
}

@freezed
class VideoResponse with _$VideoResponse {
  const factory VideoResponse({
    @Default(0) int id,
    @Default([]) List<VideoObject> results,
  }) = _VideoResponse;

  factory VideoResponse.fromJson(Map<String, dynamic> json) => _$VideoResponseFromJson(json);
}

@freezed
class Certification with _$Certification {
  const factory Certification({
    @Default('') String certification,
    @Default('') String meaning,
    @Default(0) int order,
  }) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) => _$CertificationFromJson(json);
}

@freezed
class MovieCertificationsResponse with _$MovieCertificationsResponse {
  const factory MovieCertificationsResponse({
    @Default({}) Map<String, List<Certification>> certifications, // e.g., "AU": [...]
  }) = _MovieCertificationsResponse;

  factory MovieCertificationsResponse.fromJson(Map<String, dynamic> json) => _$MovieCertificationsResponseFromJson(json);
}

@freezed
class TvCertificationsResponse with _$TvCertificationsResponse {
  const factory TvCertificationsResponse({
    @Default({}) Map<String, List<Certification>> certifications, // e.g., "AU": [...]
  }) = _TvCertificationsResponse;

  factory TvCertificationsResponse.fromJson(Map<String, dynamic> json) => _$TvCertificationsResponseFromJson(json);
}

@freezed
class WatchProviderRegion with _$WatchProviderRegion {
  const factory WatchProviderRegion({
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @JsonKey(name: 'english_name') @Default('') String englishName,
    @JsonKey(name: 'native_name') @Default('') String nativeName,
  }) = _WatchProviderRegion;

  factory WatchProviderRegion.fromJson(Map<String, dynamic> json) => _$WatchProviderRegionFromJson(json);
}

@freezed
class WatchProviderRegionsResponse with _$WatchProviderRegionsResponse {
  const factory WatchProviderRegionsResponse({
    @Default([]) List<WatchProviderRegion> results,
  }) = _WatchProviderRegionsResponse;

  factory WatchProviderRegionsResponse.fromJson(Map<String, dynamic> json) => _$WatchProviderRegionsResponseFromJson(json);
}

@freezed
class WatchProviderInfo with _$WatchProviderInfo {
  const factory WatchProviderInfo({
    @Default('') @JsonKey(name: 'logo_path') String logoPath,
    @Default(0) @JsonKey(name: 'provider_id') int providerId,
    @Default('') @JsonKey(name: 'provider_name') String providerName,
    @Default(0) @JsonKey(name: 'display_priority') int displayPriority,
  }) = _WatchProviderInfo;

  factory WatchProviderInfo.fromJson(Map<String, dynamic> json) => _$WatchProviderInfoFromJson(json);
}

@freezed
class WatchProviderProvidersResponse with _$WatchProviderProvidersResponse {
  const factory WatchProviderProvidersResponse({
    @Default([]) List<WatchProviderInfo> results,
  }) = _WatchProviderProvidersResponse;

  factory WatchProviderProvidersResponse.fromJson(Map<String, dynamic> json) => _$WatchProviderProvidersResponseFromJson(json);
}

@freezed
class WatchProviderDetails with _$WatchProviderDetails {
  const factory WatchProviderDetails({
    @Default('') String link,
    @Default([]) List<WatchProviderInfo> flatrate,
    @Default([]) List<WatchProviderInfo> rent,
    @Default([]) List<WatchProviderInfo> buy,
  }) = _WatchProviderDetails;

  factory WatchProviderDetails.fromJson(Map<String, dynamic> json) => _$WatchProviderDetailsFromJson(json);
}

@freezed
class WatchProvidersResponse with _$WatchProvidersResponse {
  const factory WatchProvidersResponse({
    @Default(0) int id,
    @Default({}) Map<String, WatchProviderDetails> results, // Key is country code, e.g., "AE"
  }) = _WatchProvidersResponse;

  factory WatchProvidersResponse.fromJson(Map<String, dynamic> json) => _$WatchProvidersResponseFromJson(json);
}

@freezed
class TmdbList with _$TmdbList {
  const factory TmdbList({
    String? description,
    @Default(0) @JsonKey(name: 'favorite_count') int favoriteCount,
    @Default(0) int id,
    @Default(0) @JsonKey(name: 'item_count') int itemCount,
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @JsonKey(name: 'list_type') @Default('') String listType,
    @Default('') String name,
    @JsonKey(name: 'poster_path') String? posterPath,
  }) = _TmdbList;

  factory TmdbList.fromJson(Map<String, dynamic> json) => _$TmdbListFromJson(json);
}

@freezed
class ReviewAuthorDetails with _$ReviewAuthorDetails {
  const factory ReviewAuthorDetails({
    String? name,
    String? username,
    @JsonKey(name: 'avatar_path') String? avatarPath,
    double? rating,
  }) = _ReviewAuthorDetails;

  factory ReviewAuthorDetails.fromJson(Map<String, dynamic> json) => _$ReviewAuthorDetailsFromJson(json);
}

@freezed
class Review with _$Review {
  const factory Review({
    String? author,
    @JsonKey(name: 'author_details') ReviewAuthorDetails? authorDetails,
    String? content,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? id,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    String? url,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

@freezed
class MediaAccountStates with _$MediaAccountStates {
  const factory MediaAccountStates({
    @Default(0) int id,
    @Default(false) bool favorite,
    RatedValue? rated, // Can be bool false or an object {value: double}
    @Default(false) bool watchlist,
  }) = _MediaAccountStates;

  factory MediaAccountStates.fromJson(Map<String, dynamic> json) => _$MediaAccountStatesFromJson(json);
}

@freezed
class RatedValue with _$RatedValue {
  const factory RatedValue({
    @Default(0.0) double value,
  }) = _RatedValue;

  factory RatedValue.fromJson(Map<String, dynamic> json) => _$RatedValueFromJson(json);
}

@freezed
class ChangesResponse with _$ChangesResponse {
  const factory ChangesResponse({
    @Default([]) List<ChangeItem> changes,
    @Default([]) List<ChangesListItem> results, // For /movie/changes, /tv/changes, /person/changes
    @Default(1) int page,
    @Default(0) @JsonKey(name: 'total_pages') int totalPages,
    @Default(0) @JsonKey(name: 'total_results') int totalResults,
  }) = _ChangesResponse;

  factory ChangesResponse.fromJson(Map<String, dynamic> json) => _$ChangesResponseFromJson(json);
}

@freezed
class ChangesListItem with _$ChangesListItem {
  const factory ChangesListItem({
    @Default(0) int id,
    @Default(false) bool adult,
  }) = _ChangesListItem;

  factory ChangesListItem.fromJson(Map<String, dynamic> json) => _$ChangesListItemFromJson(json);
}

@freezed
class ChangeItem with _$ChangeItem {
  const factory ChangeItem({
    @Default('') String key,
    @Default([]) List<ChangeDetail> items,
  }) = _ChangeItem;

  factory ChangeItem.fromJson(Map<String, dynamic> json) => _$ChangeItemFromJson(json);
}

@freezed
class ChangeDetail with _$ChangeDetail {
  const factory ChangeDetail({
    @Default('') String id,
    @Default('') String action,
    @Default('') String time, // DateTime string
    @JsonKey(name: 'iso_639_1') String? iso6391,
    @JsonKey(name: 'iso_3166_1') String? iso31661,
    dynamic value, // Can be String, Map, etc.
    @JsonKey(name: 'original_value') dynamic originalValue,
  }) = _ChangeDetail;

  factory ChangeDetail.fromJson(Map<String, dynamic> json) => _$ChangeDetailFromJson(json);
}

@freezed
class ChangesListResponse with _$ChangesListResponse {
  const factory ChangesListResponse({
    @Default([]) List<ChangesListItem> results,
    @Default(1) int page,
    @Default(0) @JsonKey(name: 'total_pages') int totalPages,
    @Default(0) @JsonKey(name: 'total_results') int totalResults,
  }) = _ChangesListResponse;

  factory ChangesListResponse.fromJson(Map<String, dynamic> json) => _$ChangesListResponseFromJson(json);
}

@freezed
class CollectionPart with _$CollectionPart {
  const factory CollectionPart({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'media_type') @Default('') String mediaType, // movie, tv, person
    @Default(0.0) double popularity,
    @JsonKey(name: 'release_date') String? releaseDate, // Date String
    @Default('') String title,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _CollectionPart;

  factory CollectionPart.fromJson(Map<String, dynamic> json) => _$CollectionPartFromJson(json);
}

@freezed
class Collection with _$Collection {
  const factory Collection({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) List<CollectionPart> parts,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);
}

@freezed
class Company with _$Company {
  const factory Company({
    String? description,
    String? headquarters,
    String? homepage,
    @Default(0) int id,
    @JsonKey(name: 'logo_path') String? logoPath,
    @Default('') String name,
    @JsonKey(name: 'origin_country') @Default('') String originCountry,
    @JsonKey(name: 'parent_company') Company? parentCompany, // Can be recursive
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}

@freezed
class CompanyAlternativeName with _$CompanyAlternativeName {
  const factory CompanyAlternativeName({
    @Default('') String name,
    @Default('') String type,
  }) = _CompanyAlternativeName;

  factory CompanyAlternativeName.fromJson(Map<String, dynamic> json) => _$CompanyAlternativeNameFromJson(json);
}

@freezed
class CompanyAlternativeNamesResponse with _$CompanyAlternativeNamesResponse {
  const factory CompanyAlternativeNamesResponse({
    @Default(0) int id,
    @Default([]) List<CompanyAlternativeName> results,
  }) = _CompanyAlternativeNamesResponse;

  factory CompanyAlternativeNamesResponse.fromJson(Map<String, dynamic> json) => _$CompanyAlternativeNamesResponseFromJson(json);
}

@freezed
class CompanyImagesResponse with _$CompanyImagesResponse {
  const factory CompanyImagesResponse({
    @Default(0) int id,
    @Default([]) List<ImageObject> logos,
  }) = _CompanyImagesResponse;

  factory CompanyImagesResponse.fromJson(Map<String, dynamic> json) => _$CompanyImagesResponseFromJson(json);
}

@freezed
class CreditDetails with _$CreditDetails {
  const factory CreditDetails({
    @Default('') @JsonKey(name: 'credit_type') String creditType,
    @Default('') String department,
    @Default('') String job,
    @Default(CreditMedia()) CreditMedia media,
    @JsonKey(name: 'media_type') @Default('') String mediaType,
    @Default('') String id,
    @Default(CreditPersonDetails()) CreditPersonDetails person,
  }) = _CreditDetails;

  factory CreditDetails.fromJson(Map<String, dynamic> json) => _$CreditDetailsFromJson(json);
}

@freezed
class CreditMedia with _$CreditMedia {
  const factory CreditMedia({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default(0) int id,
    String? name, // for TV
    String? title, // for Movie
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_name') String? originalName, // for TV
    @JsonKey(name: 'original_title') String? originalTitle, // for Movie
    @Default('') String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'media_type') @Default('') String mediaType,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0.0) double popularity,
    @JsonKey(name: 'first_air_date') String? firstAirDate, // TV date string
    @JsonKey(name: 'release_date') String? releaseDate, // Movie date string
    @Default(0.0) @JsonKey(name: 'vote_average') double voteAverage,
    @Default(0) @JsonKey(name: 'vote_count') int voteCount,
    @JsonKey(name: 'origin_country') @Default([]) List<String> originCountry,
    String? character,
    @Default([]) List<dynamic> episodes, // Can be list of TvEpisode objects
    @Default([]) List<dynamic> seasons, // Can be list of TvSeason objects
  }) = _CreditMedia;

  factory CreditMedia.fromJson(Map<String, dynamic> json) => _$CreditMediaFromJson(json);
}

@freezed
class CreditPersonDetails with _$CreditPersonDetails {
  const factory CreditPersonDetails({
    @Default(false) bool adult,
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @JsonKey(name: 'media_type') @Default('') String mediaType,
    @Default(0.0) double popularity,
    @Default(0) int gender,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CreditPersonDetails;

  factory CreditPersonDetails.fromJson(Map<String, dynamic> json) => _$CreditPersonDetailsFromJson(json);
}

@freezed
class FindByIdResponse with _$FindByIdResponse {
  const factory FindByIdResponse({
    @Default([]) @JsonKey(name: 'movie_results') List<MovieResult> movieResults,
    @Default([]) @JsonKey(name: 'person_results') List<PersonResult> personResults,
    @Default([]) @JsonKey(name: 'tv_results') List<TvShowResult> tvResults,
    @Default([]) @JsonKey(name: 'tv_episode_results') List<TvEpisode> tvEpisodeResults, // Simplified, check actual structure if needed
    @Default([]) @JsonKey(name: 'tv_season_results') List<TvSeason> tvSeasonResults, // Simplified, check actual structure if needed
  }) = _FindByIdResponse;

  factory FindByIdResponse.fromJson(Map<String, dynamic> json) => _$FindByIdResponseFromJson(json);
}

@freezed
class ListItemStatusResponse with _$ListItemStatusResponse {
  const factory ListItemStatusResponse({
    @Default(0) int id,
    @Default(false) @JsonKey(name: 'item_present') bool itemPresent,
  }) = _ListItemStatusResponse;

  factory ListItemStatusResponse.fromJson(Map<String, dynamic> json) => _$ListItemStatusResponseFromJson(json);
}

@freezed
class TmdbListDetails with _$TmdbListDetails {
  const factory TmdbListDetails({
    @Default('') @JsonKey(name: 'created_by') String createdBy,
    String? description,
    @Default(0) @JsonKey(name: 'favorite_count') int favoriteCount,
    @Default('') String id, // String ID for custom lists
    @Default([]) List<CollectionPart> items, // Items in the list can be movies/tv
    @Default(0) @JsonKey(name: 'item_count') int itemCount,
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @Default('') String name,
    @JsonKey(name: 'poster_path') String? posterPath,
  }) = _TmdbListDetails;

  factory TmdbListDetails.fromJson(Map<String, dynamic> json) => _$TmdbListDetailsFromJson(json);
}

// --- Movie Models ---

@freezed
class MovieResult with _$MovieResult {
  const factory MovieResult({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate, // Date String
    @Default('') String title,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'media_type') String? mediaType, // only present in multi-search/trending
  }) = _MovieResult;

  factory MovieResult.fromJson(Map<String, dynamic> json) => _$MovieResultFromJson(json);
}


@freezed
class MovieResultWithRating with _$MovieResultWithRating {
  const factory MovieResultWithRating({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @Default('') String title,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'media_type') String? mediaType,
    double? rating,
  }) = _MovieResultWithRating;

  factory MovieResultWithRating.fromJson(Map<String, dynamic> json) => _$MovieResultWithRatingFromJson(json);

  factory MovieResultWithRating.fromMovieResult(MovieResult result, {double? rating}) {
    return MovieResultWithRating(
      adult: result.adult,
      backdropPath: result.backdropPath,
      genreIds: result.genreIds,
      id: result.id,
      originalLanguage: result.originalLanguage,
      originalTitle: result.originalTitle,
      overview: result.overview,
      popularity: result.popularity,
      posterPath: result.posterPath,
      releaseDate: result.releaseDate,
      title: result.title,
      video: result.video,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
      mediaType: result.mediaType,
      rating: rating,
    );
  }
}

@freezed
class Movie with _$Movie {
  const factory Movie({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'belongs_to_collection') MovieCollection? belongsToCollection,
    @Default(0) int budget,
    @Default([]) List<GenreObject> genres,
    String? homepage,
    @Default(0) int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @Default([]) @JsonKey(name: 'production_companies') List<ProductionCompany> productionCompanies,
    @Default([]) @JsonKey(name: 'production_countries') List<ProductionCountry> productionCountries,
    @JsonKey(name: 'release_date') @Default('') String releaseDate, // Date String
    @Default(0) int revenue,
    @Default(0) int? runtime,
    @Default([]) @JsonKey(name: 'spoken_languages') List<SpokenLanguage> spokenLanguages,
    @Default('') String status,
    String? tagline,
    @Default('') String title,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@freezed
class MovieCollection with _$MovieCollection {
  const factory MovieCollection({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'poster_path') String? posterPath,
  }) = _MovieCollection;

  factory MovieCollection.fromJson(Map<String, dynamic> json) => _$MovieCollectionFromJson(json);
}

@freezed
class ProductionCompany with _$ProductionCompany {
  const factory ProductionCompany({
    @Default(0) int id,
    @JsonKey(name: 'logo_path') String? logoPath,
    @Default('') String name,
    @JsonKey(name: 'origin_country') @Default('') String originCountry,
  }) = _ProductionCompany;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) => _$ProductionCompanyFromJson(json);
}

@freezed
class ProductionCountry with _$ProductionCountry {
  const factory ProductionCountry({
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @Default('') String name,
  }) = _ProductionCountry;

  factory ProductionCountry.fromJson(Map<String, dynamic> json) => _$ProductionCountryFromJson(json);
}

@freezed
class SpokenLanguage with _$SpokenLanguage {
  const factory SpokenLanguage({
    @JsonKey(name: 'english_name') @Default('') String englishName,
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @Default('') String name,
  }) = _SpokenLanguage;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => _$SpokenLanguageFromJson(json);
}

@freezed
class MovieAlternativeTitle with _$MovieAlternativeTitle {
  const factory MovieAlternativeTitle({
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @Default('') String title,
    @Default('') String type,
  }) = _MovieAlternativeTitle;

  factory MovieAlternativeTitle.fromJson(Map<String, dynamic> json) => _$MovieAlternativeTitleFromJson(json);
}

@freezed
class MovieAlternativeTitlesResponse with _$MovieAlternativeTitlesResponse {
  const factory MovieAlternativeTitlesResponse({
    @Default(0) int id,
    @Default([]) List<MovieAlternativeTitle> titles,
  }) = _MovieAlternativeTitlesResponse;

  factory MovieAlternativeTitlesResponse.fromJson(Map<String, dynamic> json) => _$MovieAlternativeTitlesResponseFromJson(json);
}

@freezed
class MovieExternalIds with _$MovieExternalIds {
  const factory MovieExternalIds({
    @Default(0) int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'wikidata_id') String? wikidataId,
    @JsonKey(name: 'facebook_id') String? facebookId,
    @JsonKey(name: 'instagram_id') String? instagramId,
    @JsonKey(name: 'twitter_id') String? twitterId,
  }) = _MovieExternalIds;

  factory MovieExternalIds.fromJson(Map<String, dynamic> json) => _$MovieExternalIdsFromJson(json);
}

@freezed
class MovieReleaseDatesResponse with _$MovieReleaseDatesResponse {
  const factory MovieReleaseDatesResponse({
    @Default(0) int id,
    @Default([]) List<ReleaseDateResult> results,
  }) = _MovieReleaseDatesResponse;

  factory MovieReleaseDatesResponse.fromJson(Map<String, dynamic> json) => _$MovieReleaseDatesResponseFromJson(json);
}

@freezed
class ReleaseDateResult with _$ReleaseDateResult {
  const factory ReleaseDateResult({
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @Default([]) @JsonKey(name: 'release_dates') List<ReleaseDate> releaseDates,
  }) = _ReleaseDateResult;

  factory ReleaseDateResult.fromJson(Map<String, dynamic> json) => _$ReleaseDateResultFromJson(json);
}

@freezed
class ReleaseDate with _$ReleaseDate {
  const factory ReleaseDate({
    @Default('') String certification,
    @Default([]) List<dynamic> descriptors, // Can be list of strings
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @Default('') String note,
    @JsonKey(name: 'release_date') @Default('') String releaseDate, // ISO 8601 Date/time string
    @Default(0) int type,
  }) = _ReleaseDate;

  factory ReleaseDate.fromJson(Map<String, dynamic> json) => _$ReleaseDateFromJson(json);
}

@freezed
class MovieUpcomingResponse with _$MovieUpcomingResponse {
  const factory MovieUpcomingResponse({
    @Default(DateRange()) DateRange dates,
    @Default(1) int page,
    @Default([]) List<MovieResult> results,
    @Default(0) @JsonKey(name: 'total_pages') int totalPages,
    @Default(0) @JsonKey(name: 'total_results') int totalResults,
  }) = _MovieUpcomingResponse;

  factory MovieUpcomingResponse.fromJson(Map<String, dynamic> json) => _$MovieUpcomingResponseFromJson(json);
}

@freezed
class MovieNowPlayingResponse with _$MovieNowPlayingResponse {
  const factory MovieNowPlayingResponse({
    @Default(DateRange()) DateRange dates,
    @Default(1) int page,
    @Default([]) List<MovieResult> results,
    @Default(0) @JsonKey(name: 'total_pages') int totalPages,
    @Default(0) @JsonKey(name: 'total_results') int totalResults,
  }) = _MovieNowPlayingResponse;

  factory MovieNowPlayingResponse.fromJson(Map<String, dynamic> json) => _$MovieNowPlayingResponseFromJson(json);
}

@freezed
class DateRange with _$DateRange {
  const factory DateRange({
    @Default('') String maximum, // Date string
    @Default('') String minimum, // Date string
  }) = _DateRange;

  factory DateRange.fromJson(Map<String, dynamic> json) => _$DateRangeFromJson(json);
}

@freezed
class MovieLatest with _$MovieLatest {
  const factory MovieLatest({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'belongs_to_collection') MovieCollection? belongsToCollection,
    @Default(0) int budget,
    @Default([]) List<GenreObject> genres,
    @Default('') String homepage,
    @Default(0) int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @Default([]) @JsonKey(name: 'production_companies') List<ProductionCompany> productionCompanies,
    @Default([]) @JsonKey(name: 'production_countries') List<ProductionCountry> productionCountries,
    @JsonKey(name: 'release_date') @Default('') String releaseDate,
    @Default(0) int revenue,
    @Default(0) int runtime,
    @Default([]) @JsonKey(name: 'spoken_languages') List<SpokenLanguage> spokenLanguages,
    @Default('') String status,
    @Default('') String tagline,
    @Default('') String title,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _MovieLatest;

  factory MovieLatest.fromJson(Map<String, dynamic> json) => _$MovieLatestFromJson(json);
}

// --- TV Show Models ---

@freezed
class TvShowResult with _$TvShowResult {
  const factory TvShowResult({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'origin_country') @Default([]) List<String> originCountry,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'first_air_date') String? firstAirDate, // Date String
    @Default('') String name,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'media_type') String? mediaType, // only present in multi-search/trending
  }) = _TvShowResult;

  factory TvShowResult.fromJson(Map<String, dynamic> json) => _$TvShowResultFromJson(json);
}

@freezed
class TvShowResultWithRating with _$TvShowResultWithRating {
  const factory TvShowResultWithRating({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'origin_country') @Default([]) List<String> originCountry,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @Default('') String name,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'media_type') String? mediaType,
    double? rating,
  }) = _TvShowResultWithRating;

  factory TvShowResultWithRating.fromJson(Map<String, dynamic> json) => _$TvShowResultWithRatingFromJson(json);

  factory TvShowResultWithRating.fromTvShowResult(TvShowResult result, {double? rating}) {
    return TvShowResultWithRating(
      adult: result.adult,
      backdropPath: result.backdropPath,
      genreIds: result.genreIds,
      id: result.id,
      originCountry: result.originCountry,
      originalLanguage: result.originalLanguage,
      originalName: result.originalName,
      overview: result.overview,
      popularity: result.popularity,
      posterPath: result.posterPath,
      firstAirDate: result.firstAirDate,
      name: result.name,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
      mediaType: result.mediaType,
      rating: rating,
    );
  }
}

@freezed
class CreatedBy with _$CreatedBy {
  const factory CreatedBy({
    @Default(0) int id,
    @JsonKey(name: 'credit_id') @Default('') String creditId,
    @Default('') String name,
    @Default(0) int gender,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CreatedBy;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => _$CreatedByFromJson(json);
}

@freezed
class LastEpisodeToAir with _$LastEpisodeToAir {
  const factory LastEpisodeToAir({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String overview,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'air_date') String? airDate, // Date String
    @JsonKey(name: 'episode_number') @Default(0) int episodeNumber,
    @JsonKey(name: 'production_code') @Default('') String productionCode,
    int? runtime,
    @JsonKey(name: 'season_number') @Default(0) int seasonNumber,
    @JsonKey(name: 'show_id') @Default(0) int showId,
    @JsonKey(name: 'still_path') String? stillPath,
  }) = _LastEpisodeToAir;

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) => _$LastEpisodeToAirFromJson(json);
}

@freezed
class TvNetwork with _$TvNetwork {
  const factory TvNetwork({
    @Default(0) int id,
    @JsonKey(name: 'logo_path') String? logoPath,
    @Default('') String name,
    @JsonKey(name: 'origin_country') @Default('') String originCountry,
  }) = _TvNetwork;

  factory TvNetwork.fromJson(Map<String, dynamic> json) => _$TvNetworkFromJson(json);
}

@freezed
class TvSeasonObject with _$TvSeasonObject {
  const factory TvSeasonObject({
    @JsonKey(name: 'air_date') String? airDate, // Date String
    @JsonKey(name: 'episode_count') @Default(0) int episodeCount,
    @Default(0) int id,
    @Default('') String name,
    @Default('') String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'season_number') @Default(0) int seasonNumber,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
  }) = _TvSeasonObject;

  factory TvSeasonObject.fromJson(Map<String, dynamic> json) => _$TvSeasonObjectFromJson(json);
}

@freezed
class TvShow with _$TvShow {
  const factory TvShow({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'created_by') List<CreatedBy> createdBy,
    @Default([]) @JsonKey(name: 'episode_run_time') List<int> episodeRunTime,
    @JsonKey(name: 'first_air_date') String? firstAirDate, // Date String
    @Default([]) List<GenreObject> genres,
    String? homepage,
    @Default(0) int id,
    @Default(false) @JsonKey(name: 'in_production') bool inProduction,
    @Default([]) List<String> languages,
    @JsonKey(name: 'last_air_date') String? lastAirDate, // Date String
    @JsonKey(name: 'last_episode_to_air') LastEpisodeToAir? lastEpisodeToAir,
    @Default('') String name,
    @JsonKey(name: 'next_episode_to_air') LastEpisodeToAir? nextEpisodeToAir, // Same structure
    @Default([]) List<TvNetwork> networks,
    @Default(0) @JsonKey(name: 'number_of_episodes') int numberOfEpisodes,
    @Default(0) @JsonKey(name: 'number_of_seasons') int numberOfSeasons,
    @JsonKey(name: 'origin_country') @Default([]) List<String> originCountry,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @Default([]) @JsonKey(name: 'production_companies') List<ProductionCompany> productionCompanies,
    @Default([]) @JsonKey(name: 'production_countries') List<ProductionCountry> productionCountries,
    @Default([]) List<TvSeasonObject> seasons,
    @Default([]) @JsonKey(name: 'spoken_languages') List<SpokenLanguage> spokenLanguages,
    @Default('') String status,
    String? tagline,
    @Default('') String type,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _TvShow;

  factory TvShow.fromJson(Map<String, dynamic> json) => _$TvShowFromJson(json);
}

@freezed
class EpisodeGuestStar with _$EpisodeGuestStar {
  const factory EpisodeGuestStar({
    String? character,
    @JsonKey(name: 'credit_id') @Default('') String creditId,
    @Default(0) int order,
    @Default(false) bool adult,
    @Default(0) int gender,
    @Default(0) int id,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _EpisodeGuestStar;

  factory EpisodeGuestStar.fromJson(Map<String, dynamic> json) => _$EpisodeGuestStarFromJson(json);
}

@freezed
class TvEpisode with _$TvEpisode {
  const factory TvEpisode({
    @JsonKey(name: 'air_date') String? airDate, // Date String
    @Default([]) List<EpisodeCrew> crew,
    @JsonKey(name: 'episode_number') @Default(0) int episodeNumber,
    @Default([]) @JsonKey(name: 'guest_stars') List<EpisodeGuestStar> guestStars,
    @Default('') String name,
    @Default('') String overview,
    @Default(0) int id,
    @JsonKey(name: 'production_code') @Default('') String productionCode,
    int? runtime,
    @JsonKey(name: 'season_number') @Default(0) int seasonNumber,
    @JsonKey(name: 'show_id') int? showId, // Present in season details' episode list
    @JsonKey(name: 'still_path') String? stillPath,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _TvEpisode;

  factory TvEpisode.fromJson(Map<String, dynamic> json) => _$TvEpisodeFromJson(json);
}

@freezed
class TvSeason with _$TvSeason {
  const factory TvSeason({
    @JsonKey(name: '_id') String? jsonId, // MongoDB _id
    @JsonKey(name: 'air_date') String? airDate, // Date String
    @Default([]) List<TvEpisode> episodes,
    @Default('') String name,
    @Default('') String overview,
    @Default(0) int id,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'season_number') @Default(0) int seasonNumber,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
  }) = _TvSeason;

  factory TvSeason.fromJson(Map<String, dynamic> json) => _$TvSeasonFromJson(json);
}

@freezed
class AggregateCast with _$AggregateCast {
  const factory AggregateCast({
    @Default(false) bool adult,
    @Default(0) int gender,
    @Default(0) int id,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @Default([]) List<CastRole> roles,
    @JsonKey(name: 'total_episode_count') @Default(0) int totalEpisodeCount,
    @Default(0) int order,
  }) = _AggregateCast;

  factory AggregateCast.fromJson(Map<String, dynamic> json) => _$AggregateCastFromJson(json);
}

@freezed
class CastRole with _$CastRole {
  const factory CastRole({
    @JsonKey(name: 'credit_id') @Default('') String creditId,
    @Default('') String character,
    @JsonKey(name: 'episode_count') @Default(0) int episodeCount,
  }) = _CastRole;

  factory CastRole.fromJson(Map<String, dynamic> json) => _$CastRoleFromJson(json);
}

@freezed
class AggregateCrew with _$AggregateCrew {
  const factory AggregateCrew({
    @Default(false) bool adult,
    @Default(0) int gender,
    @Default(0) int id,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @Default([]) List<CrewJob> jobs,
    @Default('') String department,
    @JsonKey(name: 'total_episode_count') @Default(0) int totalEpisodeCount,
  }) = _AggregateCrew;

  factory AggregateCrew.fromJson(Map<String, dynamic> json) => _$AggregateCrewFromJson(json);
}

@freezed
class CrewJob with _$CrewJob {
  const factory CrewJob({
    @JsonKey(name: 'credit_id') @Default('') String creditId,
    @Default('') String job,
    @JsonKey(name: 'episode_count') @Default(0) int episodeCount,
  }) = _CrewJob;

  factory CrewJob.fromJson(Map<String, dynamic> json) => _$CrewJobFromJson(json);
}

@freezed
class AggregateCreditsResponse with _$AggregateCreditsResponse {
  const factory AggregateCreditsResponse({
    @Default([]) List<AggregateCast> cast,
    @Default([]) List<AggregateCrew> crew,
    @Default(0) int id,
  }) = _AggregateCreditsResponse;

  factory AggregateCreditsResponse.fromJson(Map<String, dynamic> json) => _$AggregateCreditsResponseFromJson(json);
}

@freezed
class TvAlternativeTitle with _$TvAlternativeTitle {
  const factory TvAlternativeTitle({
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @Default('') String title,
    @Default('') String type,
  }) = _TvAlternativeTitle;

  factory TvAlternativeTitle.fromJson(Map<String, dynamic> json) => _$TvAlternativeTitleFromJson(json);
}

@freezed
class TvAlternativeTitlesResponse with _$TvAlternativeTitlesResponse {
  const factory TvAlternativeTitlesResponse({
    @Default(0) int id,
    @Default([]) List<TvAlternativeTitle> results,
  }) = _TvAlternativeTitlesResponse;

  factory TvAlternativeTitlesResponse.fromJson(Map<String, dynamic> json) => _$TvAlternativeTitlesResponseFromJson(json);
}

@freezed
class TvContentRating with _$TvContentRating {
  const factory TvContentRating({
    @Default([]) List<dynamic> descriptors, // List of strings
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    @Default('') String rating,
  }) = _TvContentRating;

  factory TvContentRating.fromJson(Map<String, dynamic> json) => _$TvContentRatingFromJson(json);
}

@freezed
class TvContentRatingsResponse with _$TvContentRatingsResponse {
  const factory TvContentRatingsResponse({
    @Default([]) List<TvContentRating> results,
    @Default(0) int id,
  }) = _TvContentRatingsResponse;

  factory TvContentRatingsResponse.fromJson(Map<String, dynamic> json) => _$TvContentRatingsResponseFromJson(json);
}

@freezed
class EpisodeGroupResult with _$EpisodeGroupResult {
  const factory EpisodeGroupResult({
    String? description,
    @Default(0) @JsonKey(name: 'episode_count') int episodeCount,
    @Default(0) @JsonKey(name: 'group_count') int groupCount,
    @Default('') String id,
    @Default('') String name,
    @Default(TvNetwork()) TvNetwork? network,
    @Default(0) int type,
  }) = _EpisodeGroupResult;

  factory EpisodeGroupResult.fromJson(Map<String, dynamic> json) => _$EpisodeGroupResultFromJson(json);
}

@freezed
class TvEpisodeGroupsResponse with _$TvEpisodeGroupsResponse {
  const factory TvEpisodeGroupsResponse({
    @Default([]) List<EpisodeGroupResult> results,
    @Default(0) int id,
  }) = _TvEpisodeGroupsResponse;

  factory TvEpisodeGroupsResponse.fromJson(Map<String, dynamic> json) => _$TvEpisodeGroupsResponseFromJson(json);
}

@freezed
class TvExternalIds with _$TvExternalIds {
  const factory TvExternalIds({
    @Default(0) int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'freebase_mid') String? freebaseMid,
    @JsonKey(name: 'freebase_id') String? freebaseId,
    @JsonKey(name: 'tvdb_id') int? tvdbId,
    @JsonKey(name: 'tvrage_id') int? tvrageId,
    @JsonKey(name: 'wikidata_id') String? wikidataId,
    @JsonKey(name: 'facebook_id') String? facebookId,
    @JsonKey(name: 'instagram_id') String? instagramId,
    @JsonKey(name: 'twitter_id') String? twitterId,
  }) = _TvExternalIds;

  factory TvExternalIds.fromJson(Map<String, dynamic> json) => _$TvExternalIdsFromJson(json);
}

@freezed
class TvScreenedTheatricallyResult with _$TvScreenedTheatricallyResult {
  const factory TvScreenedTheatricallyResult({
    @Default(0) int id,
    @Default(0) @JsonKey(name: 'episode_number') int episodeNumber,
    @Default(0) @JsonKey(name: 'season_number') int seasonNumber,
  }) = _TvScreenedTheatricallyResult;

  factory TvScreenedTheatricallyResult.fromJson(Map<String, dynamic> json) => _$TvScreenedTheatricallyResultFromJson(json);
}

@freezed
class TvScreenedTheatricallyResponse with _$TvScreenedTheatricallyResponse {
  const factory TvScreenedTheatricallyResponse({
    @Default(0) int id,
    @Default([]) List<TvScreenedTheatricallyResult> results,
  }) = _TvScreenedTheatricallyResponse;

  factory TvScreenedTheatricallyResponse.fromJson(Map<String, dynamic> json) => _$TvScreenedTheatricallyResponseFromJson(json);
}

@freezed
class TvSeriesLatest with _$TvSeriesLatest {
  const factory TvSeriesLatest({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'created_by') List<CreatedBy> createdBy,
    @Default([]) @JsonKey(name: 'episode_run_time') List<int> episodeRunTime,
    @Default('') @JsonKey(name: 'first_air_date') String firstAirDate,
    @Default([]) List<GenreObject> genres,
    @Default('') String homepage,
    @Default(0) int id,
    @Default(false) @JsonKey(name: 'in_production') bool inProduction,
    @Default([]) List<String> languages,
    @Default('') @JsonKey(name: 'last_air_date') String lastAirDate,
    @JsonKey(name: 'last_episode_to_air') LastEpisodeToAir? lastEpisodeToAir,
    @Default('') String name,
    @JsonKey(name: 'next_episode_to_air') LastEpisodeToAir? nextEpisodeToAir,
    @Default([]) List<TvNetwork> networks,
    @Default(0) @JsonKey(name: 'number_of_episodes') int numberOfEpisodes,
    @Default(0) @JsonKey(name: 'number_of_seasons') int numberOfSeasons,
    @Default([]) @JsonKey(name: 'origin_country') List<String> originCountry,
    @Default('') @JsonKey(name: 'original_language') String originalLanguage,
    @Default('') @JsonKey(name: 'original_name') String originalName,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @Default([]) @JsonKey(name: 'production_companies') List<ProductionCompany> productionCompanies,
    @Default([]) @JsonKey(name: 'production_countries') List<ProductionCountry> productionCountries,
    @Default([]) List<TvSeasonObject> seasons,
    @Default([]) @JsonKey(name: 'spoken_languages') List<SpokenLanguage> spokenLanguages,
    @Default('') String status,
    @Default('') String tagline,
    @Default('') String type,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _TvSeriesLatest;

  factory TvSeriesLatest.fromJson(Map<String, dynamic> json) => _$TvSeriesLatestFromJson(json);
}

@freezed
class TvEpisodeWithRating with _$TvEpisodeWithRating {
  const factory TvEpisodeWithRating({
    @JsonKey(name: 'air_date') String? airDate,
    @Default([]) List<EpisodeCrew> crew,
    @JsonKey(name: 'episode_number') @Default(0) int episodeNumber,
    @Default([]) @JsonKey(name: 'guest_stars') List<EpisodeGuestStar> guestStars,
    @Default('') String name,
    @Default('') String overview,
    @Default(0) int id,
    @JsonKey(name: 'production_code') @Default('') String productionCode,
    int? runtime,
    @JsonKey(name: 'season_number') @Default(0) int seasonNumber,
    @JsonKey(name: 'show_id') int? showId,
    @JsonKey(name: 'still_path') String? stillPath,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    double? rating,
  }) = _TvEpisodeWithRating;

  factory TvEpisodeWithRating.fromJson(Map<String, dynamic> json) => _$TvEpisodeWithRatingFromJson(json);

  factory TvEpisodeWithRating.fromTvEpisode(TvEpisode episode, {double? rating}) {
    return TvEpisodeWithRating(
      airDate: episode.airDate,
      crew: episode.crew,
      episodeNumber: episode.episodeNumber,
      guestStars: episode.guestStars,
      name: episode.name,
      overview: episode.overview,
      id: episode.id,
      productionCode: episode.productionCode,
      runtime: episode.runtime,
      seasonNumber: episode.seasonNumber,
      showId: episode.showId,
      stillPath: episode.stillPath,
      voteAverage: episode.voteAverage,
      voteCount: episode.voteCount,
      rating: rating,
    );
  }
}

@freezed
class TvSeasonAccountStates with _$TvSeasonAccountStates {
  const factory TvSeasonAccountStates({
    @Default(0) int id,
    @Default([]) List<EpisodeAccountState> results,
  }) = _TvSeasonAccountStates;

  factory TvSeasonAccountStates.fromJson(Map<String, dynamic> json) => _$TvSeasonAccountStatesFromJson(json);
}

@freezed
class EpisodeAccountState with _$EpisodeAccountState {
  const factory EpisodeAccountState({
    @Default(0) int id,
    @Default(0) @JsonKey(name: 'episode_number') int episodeNumber,
    RatedValue? rated, // Can be bool false or object
  }) = _EpisodeAccountState;

  factory EpisodeAccountState.fromJson(Map<String, dynamic> json) => _$EpisodeAccountStateFromJson(json);
}

@freezed
class TvSeasonExternalIds with _$TvSeasonExternalIds {
  const factory TvSeasonExternalIds({
    @Default(0) int id,
    @JsonKey(name: 'freebase_mid') String? freebaseMid,
    @JsonKey(name: 'freebase_id') String? freebaseId,
    @JsonKey(name: 'tvdb_id') int? tvdbId,
    @JsonKey(name: 'tvrage_id') int? tvrageId,
    @JsonKey(name: 'wikidata_id') String? wikidataId,
  }) = _TvSeasonExternalIds;

  factory TvSeasonExternalIds.fromJson(Map<String, dynamic> json) => _$TvSeasonExternalIdsFromJson(json);
}

@freezed
class TvEpisodeExternalIds with _$TvEpisodeExternalIds {
  const factory TvEpisodeExternalIds({
    @Default(0) int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'freebase_mid') String? freebaseMid,
    @JsonKey(name: 'freebase_id') String? freebaseId,
    @JsonKey(name: 'tvdb_id') int? tvdbId,
    @JsonKey(name: 'tvrage_id') int? tvrageId,
    @JsonKey(name: 'wikidata_id') String? wikidataId,
  }) = _TvEpisodeExternalIds;

  factory TvEpisodeExternalIds.fromJson(Map<String, dynamic> json) => _$TvEpisodeExternalIdsFromJson(json);
}

// --- Person Models ---

@freezed
class PersonResult with _$PersonResult {
  const factory PersonResult({
    @Default(false) bool adult,
    @Default(0) int gender,
    @Default(0) int id,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @Default([]) @JsonKey(name: 'known_for') List<dynamic> knownFor, // Can be MovieResult or TvShowResult
    @JsonKey(name: 'media_type') String? mediaType, // only present in multi-search/trending
  }) = _PersonResult;

  factory PersonResult.fromJson(Map<String, dynamic> json) => _$PersonResultFromJson(json);
}

@freezed
class Person with _$Person {
  const factory Person({
    @Default(false) bool adult,
    @Default([]) @JsonKey(name: 'also_known_as') List<String> alsoKnownAs,
    String? biography,
    String? birthday, // Date String
    String? deathday, // Date String
    @Default(0) int gender,
    String? homepage,
    @Default(0) int id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}

@freezed
class PersonImagesResponse with _$PersonImagesResponse {
  const factory PersonImagesResponse({
    @Default(0) int id,
    @Default([]) List<ImageObject> profiles,
  }) = _PersonImagesResponse;

  factory PersonImagesResponse.fromJson(Map<String, dynamic> json) => _$PersonImagesResponseFromJson(json);
}

@freezed
class EpisodeCrew with _$EpisodeCrew { // Re-used for TV Season/Episode credits
  const factory EpisodeCrew({
    @Default('') String department,
    @Default('') String job,
    @JsonKey(name: 'credit_id') @Default('') String creditId,
    @Default(false) bool adult,
    @Default(0) int gender,
    @Default(0) int id,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'episode_count') int? episodeCount, // Specific to aggregate/TV series credits
  }) = _EpisodeCrew;

  factory EpisodeCrew.fromJson(Map<String, dynamic> json) => _$EpisodeCrewFromJson(json);
}

@freezed
class CastMember with _$CastMember {
  const factory CastMember({
    @Default(false) bool adult,
    @Default(0) int gender,
    @Default(0) int id,
    @JsonKey(name: 'known_for_department') @Default('') String knownForDepartment,
    @Default('') String name,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default(0.0) double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'cast_id') int? castId,
    String? character,
    @JsonKey(name: 'credit_id') @Default('') String creditId,
    @Default(0) int order,
    @JsonKey(name: 'episode_count') int? episodeCount, // Specific to aggregate/TV series credits
  }) = _CastMember;

  factory CastMember.fromJson(Map<String, dynamic> json) => _$CastMemberFromJson(json);
}

@freezed
class CreditsResponse with _$CreditsResponse {
  const factory CreditsResponse({
    @Default(0) int id, // can be Movie ID or TV Series/Season/Episode
    @Default([]) List<CastMember> cast,
    @Default([]) List<EpisodeCrew> crew,
    @Default([]) @JsonKey(name: 'guest_stars') List<EpisodeGuestStar> guestStars,
  }) = _CreditsResponse;

  factory CreditsResponse.fromJson(Map<String, dynamic> json) => _$CreditsResponseFromJson(json);
}

@freezed
class PersonMovieCreditItem with _$PersonMovieCreditItem {
  const factory PersonMovieCreditItem({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @Default('') String title,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    String? character, // For cast
    @JsonKey(name: 'credit_id') String? creditId,
    int? order,
    String? department, // For crew
    String? job, // For crew
    @JsonKey(name: 'media_type') String? mediaType, // For combined credits
  }) = _PersonMovieCreditItem;

  factory PersonMovieCreditItem.fromJson(Map<String, dynamic> json) => _$PersonMovieCreditItemFromJson(json);
}

@freezed
class PersonMovieCredits with _$PersonMovieCredits {
  const factory PersonMovieCredits({
    @Default([]) List<PersonMovieCreditItem> cast,
    @Default([]) List<PersonMovieCreditItem> crew,
    @Default(0) int id,
  }) = _PersonMovieCredits;

  factory PersonMovieCredits.fromJson(Map<String, dynamic> json) => _$PersonMovieCreditsFromJson(json);
}

@freezed
class PersonTvCreditItem with _$PersonTvCreditItem {
  const factory PersonTvCreditItem({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0) int id,
    @JsonKey(name: 'origin_country') @Default([]) List<String> originCountry,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_name') @Default('') String originalName,
    @Default('') String overview,
    @Default(0.0) double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @Default('') String name,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    String? character, // For cast
    @JsonKey(name: 'credit_id') String? creditId,
    int? episodeCount, // For cast/crew
    String? department, // For crew
    String? job, // For crew
    @JsonKey(name: 'media_type') String? mediaType, // For combined credits
  }) = _PersonTvCreditItem;

  factory PersonTvCreditItem.fromJson(Map<String, dynamic> json) => _$PersonTvCreditItemFromJson(json);
}

@freezed
class PersonTvCredits with _$PersonTvCredits {
  const factory PersonTvCredits({
    @Default([]) List<PersonTvCreditItem> cast,
    @Default([]) List<PersonTvCreditItem> crew,
    @Default(0) int id,
  }) = _PersonTvCredits;

  factory PersonTvCredits.fromJson(Map<String, dynamic> json) => _$PersonTvCreditsFromJson(json);
}

@freezed
class PersonCombinedCredits with _$PersonCombinedCredits {
  const factory PersonCombinedCredits({
    @Default([]) List<PersonMovieCreditItem> cast, // Movie-like structure, but includes TV fields like first_air_date if media_type is tv
    @Default([]) List<PersonMovieCreditItem> crew, // Movie-like structure
    @Default(0) int id,
  }) = _PersonCombinedCredits;

  factory PersonCombinedCredits.fromJson(Map<String, dynamic> json) => _$PersonCombinedCreditsFromJson(json);
}

@freezed
class PersonExternalIds with _$PersonExternalIds {
  const factory PersonExternalIds({
    @Default(0) int id,
    @JsonKey(name: 'freebase_mid') String? freebaseMid,
    @JsonKey(name: 'freebase_id') String? freebaseId,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'tvrage_id') int? tvrageId,
    @JsonKey(name: 'wikidata_id') String? wikidataId,
    @JsonKey(name: 'facebook_id') String? facebookId,
    @JsonKey(name: 'instagram_id') String? instagramId,
    @JsonKey(name: 'tiktok_id') String? tiktokId,
    @JsonKey(name: 'twitter_id') String? twitterId,
    @JsonKey(name: 'youtube_id') String? youtubeId,
  }) = _PersonExternalIds;

  factory PersonExternalIds.fromJson(Map<String, dynamic> json) => _$PersonExternalIdsFromJson(json);
}

@freezed
class TaggedImageMedia with _$TaggedImageMedia {
  const factory TaggedImageMedia({
    @Default(false) bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @Default(0) int id,
    String? title,
    @JsonKey(name: 'original_language') @Default('') String originalLanguage,
    @JsonKey(name: 'original_title') @Default('') String originalTitle,
    @Default('') String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'media_type') @Default('') String mediaType,
    @Default([]) @JsonKey(name: 'genre_ids') List<int> genreIds,
    @Default(0.0) double popularity,
    @JsonKey(name: 'release_date') String? releaseDate,
    @Default(false) bool video,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _TaggedImageMedia;

  factory TaggedImageMedia.fromJson(Map<String, dynamic> json) => _$TaggedImageMediaFromJson(json);
}


@freezed
class TaggedImageResult with _$TaggedImageResult {
  const factory TaggedImageResult({
    @Default(0.0) @JsonKey(name: 'aspect_ratio') double aspectRatio,
    @JsonKey(name: 'file_path') @Default('') String filePath,
    @Default(0) int height,
    @Default('') String id,
    @JsonKey(name: 'iso_639_1') String? iso6391,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @Default(0) int width,
    @JsonKey(name: 'image_type') @Default('') String imageType,
    @Default(TaggedImageMedia()) TaggedImageMedia media,
    @JsonKey(name: 'media_type') @Default('') String mediaType,
  }) = _TaggedImageResult;

  factory TaggedImageResult.fromJson(Map<String, dynamic> json) => _$TaggedImageResultFromJson(json);
}

// --- Authentication Models ---

@freezed
class GuestSession with _$GuestSession {
  const factory GuestSession({
    @Default(false) bool success,
    @JsonKey(name: 'guest_session_id') @Default('') String guestSessionId,
    @JsonKey(name: 'expires_at') @Default('') String expiresAt, // Date/time string
  }) = _GuestSession;

  factory GuestSession.fromJson(Map<String, dynamic> json) => _$GuestSessionFromJson(json);
}

@freezed
class RequestToken with _$RequestToken {
  const factory RequestToken({
    @Default(false) bool success,
    @JsonKey(name: 'expires_at') @Default('') String expiresAt, // Date/time string
    @JsonKey(name: 'request_token') @Default('') String requestToken,
  }) = _RequestToken;

  factory RequestToken.fromJson(Map<String, dynamic> json) => _$RequestTokenFromJson(json);
}

@freezed
class UserSession with _$UserSession {
  const factory UserSession({
    @Default(false) bool success,
    @JsonKey(name: 'session_id') @Default('') String sessionId,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);
}

@freezed
class AccountDetails with _$AccountDetails {
  const factory AccountDetails({
    @Default(AccountAvatar()) AccountAvatar avatar,
    @Default(0) int id,
    @JsonKey(name: 'iso_639_1') @Default('') String iso6391,
    @JsonKey(name: 'iso_3166_1') @Default('') String iso31661,
    String? name,
    @Default(false) @JsonKey(name: 'include_adult') bool includeAdult,
    @Default('') String username,
  }) = _AccountDetails;

  factory AccountDetails.fromJson(Map<String, dynamic> json) => _$AccountDetailsFromJson(json);
}

@freezed
class AccountAvatar with _$AccountAvatar {
  const factory AccountAvatar({
    @Default(GravatarDetails()) GravatarDetails gravatar,
    @Default(TmdbAvatarDetails()) TmdbAvatarDetails tmdb,
  }) = _AccountAvatar;

  factory AccountAvatar.fromJson(Map<String, dynamic> json) => _$AccountAvatarFromJson(json);
}

@freezed
class GravatarDetails with _$GravatarDetails {
  const factory GravatarDetails({
    @Default('') String hash,
  }) = _GravatarDetails;

  factory GravatarDetails.fromJson(Map<String, dynamic> json) => _$GravatarDetailsFromJson(json);
}

@freezed
class TmdbAvatarDetails with _$TmdbAvatarDetails {
  const factory TmdbAvatarDetails({
    @JsonKey(name: 'avatar_path') String? avatarPath,
  }) = _TmdbAvatarDetails;

  factory TmdbAvatarDetails.fromJson(Map<String, dynamic> json) => _$TmdbAvatarDetailsFromJson(json);
}