import 'package:hive_ce/hive.dart';

import 'package:miko/src/models/auth/account.dart';
import 'package:miko/src/models/auth/account_states.dart';
import 'package:miko/src/models/auth/guest_session.dart';
import 'package:miko/src/models/auth/list_action_response.dart';
import 'package:miko/src/models/auth/session.dart';
import 'package:miko/src/models/discover/discover_movies_response.dart';
import 'package:miko/src/models/discover/discover_params.dart';
import 'package:miko/src/models/episode/episode_detail.dart';
import 'package:miko/src/models/misc/change_item.dart';
import 'package:miko/src/models/misc/changes_response.dart';
import 'package:miko/src/models/misc/rating_response.dart';
import 'package:miko/src/models/misc/trending_response.dart';
import 'package:miko/src/models/movie/alternative_titles.dart';
import 'package:miko/src/models/movie/collection.dart';
import 'package:miko/src/models/movie/genre.dart';
import 'package:miko/src/models/movie/image.dart';
import 'package:miko/src/models/movie/keyword.dart';
import 'package:miko/src/models/movie/list_details.dart';
import 'package:miko/src/models/movie/movie_credits.dart';
import 'package:miko/src/models/movie/movie_detail.dart';
import 'package:miko/src/models/movie/movie_list_response.dart';
import 'package:miko/src/models/movie/production.dart';
import 'package:miko/src/models/movie/recommendations_response.dart';
import 'package:miko/src/models/movie/review.dart';
import 'package:miko/src/models/movie/translations.dart';
import 'package:miko/src/models/movie/video.dart';
import 'package:miko/src/models/movie/watch_providers.dart';
import 'package:miko/src/models/person/combined_credit.dart';
import 'package:miko/src/models/person/person_detail.dart';
import 'package:miko/src/models/search/search_multi_response.dart';
import 'package:miko/src/models/tv/content_ratings.dart';
import 'package:miko/src/models/tv/creator.dart';
import 'package:miko/src/models/tv/external_ids.dart';
import 'package:miko/src/models/tv/network.dart';
import 'package:miko/src/models/tv/season_summary.dart';
import 'package:miko/src/models/tv/translations.dart';
import 'package:miko/src/models/tv/tv_credits.dart';
import 'package:miko/src/models/tv/tv_genre.dart';
import 'package:miko/src/models/tv/tv_lists.dart';
import 'package:miko/src/models/tv/tv_show_detail.dart';


@GenerateAdapters([
  AdapterSpec<AccountStates>(),
  AdapterSpec<AccountDetails>(),
  AdapterSpec<GuestSession>(),
  AdapterSpec<ListActionResponse>(),
  AdapterSpec<SessionResponse>(),
  AdapterSpec<DiscoverMoviesResponse>(),
  AdapterSpec<DiscoverParams>(),
  AdapterSpec<ChangeItem>(),

  AdapterSpec<ChangesResponse>(),
  AdapterSpec<RatingResponse>(),
  AdapterSpec<TrendingResponse>(),
  AdapterSpec<AlternativeTitle>(),
  AdapterSpec<AlternativeTitlesResponse>(),
  AdapterSpec<CollectionPart>(),
  AdapterSpec<CollectionDetails>(),
  AdapterSpec<MovieGenre>(),

  AdapterSpec<GenreListResponse>(),
  AdapterSpec<MovieImage>(),
  AdapterSpec<MovieImagesResponse>(),
  AdapterSpec<MovieKeyword>(),
  AdapterSpec<MovieKeywordsResponse>(),
  AdapterSpec<MovieListItemDetail>(),
  AdapterSpec<MovieListDetails>(),
  AdapterSpec<MovieListResponse>(),

  AdapterSpec<MovieListItem>(),
  AdapterSpec<ProductionCompany>(),
  AdapterSpec<ProductionCountry>(),
  AdapterSpec<MovieRecommendationsResponse>(),
  AdapterSpec<MovieReview>(),
  AdapterSpec<MovieReviewsResponse>(),
  AdapterSpec<TranslationData>(),
  AdapterSpec<TranslationItem>(),

  AdapterSpec<TranslationsResponse>(),
  AdapterSpec<MovieVideo>(),
  AdapterSpec<MovieVideosResponse>(),
  AdapterSpec<WatchProvider>(),
  AdapterSpec<WatchProviderCountry>(),
  AdapterSpec<WatchProvidersResponse>(),
  AdapterSpec<SearchResultItem>(),
  AdapterSpec<SearchMultiResponse>(),

  AdapterSpec<ContentRatingItem>(),
  AdapterSpec<TvContentRatingsResponse>(),
  AdapterSpec<Creator>(),
  AdapterSpec<TvExternalIds>(),
  AdapterSpec<Network>(),
  AdapterSpec<SeasonSummary>(),
  AdapterSpec<TvTranslationItem>(),
  AdapterSpec<TvTranslationsResponse>(),

  AdapterSpec<TvCast>(),
  AdapterSpec<TvCrew>(),
  AdapterSpec<TvCreditsResponse>(),
  AdapterSpec<TvGenre>(),
  AdapterSpec<TvShowDetail>(),
  AdapterSpec<MovieDetail>(),
  AdapterSpec<EpisodeDetail>(),
  AdapterSpec<CrewMember>(),
  AdapterSpec<GuestStar>(),
    AdapterSpec<Genre>(),
    AdapterSpec<SpokenLanguage>(),
    AdapterSpec<TvTranslationData>(),
    AdapterSpec<PersonCredits>(),
    AdapterSpec<CastCredit>(),
    AdapterSpec<CrewCredit>(),
    AdapterSpec<PersonDetail>(),
    AdapterSpec<TvListResponse>(),
    AdapterSpec<TvSummary>(),
    AdapterSpec<MovieCredits>(),
    AdapterSpec<MovieCastMember>(),
    AdapterSpec<MovieCrewMember>(),


])
part 'hive_adapters.g.dart';
