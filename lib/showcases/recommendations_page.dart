import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
// Make sure to import your models, services, and other pages

class RecommendationsPage extends StatefulWidget {
  final int movieId;
  final String movieTitle;
  final String typec;

  const RecommendationsPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
    required this.typec,
  });

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final MovieService _movieService = MovieService();
  late Future<MovieResponse> _recommendationsFuture;
  late Future<TvShowResponse> _tvRecommendationsFuture;
  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  void _fetchRecommendations() async {
    widget.typec == "movie"
        ? _recommendationsFuture =
            _movieService.getMovieRecommendations(movieId: widget.movieId)
        : _tvRecommendationsFuture =
            _movieService.getTvShowRecommendations(tvShowId: widget.movieId);
    setState(() {});
  }

  @override
  void dispose() {
    _movieService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.typec == "movie"
            ? Text('More like ${widget.movieTitle}')
            : Text('More like ${widget.movieTitle}'),
        centerTitle: true,
      ),
      body: widget.typec == "movie"
          ? FutureBuilder<MovieResponse>(
              future: _recommendationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Failed to load recommendations.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            _fetchRecommendations();
                          }),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData &&
                    snapshot.data!.results.isNotEmpty) {
                  final movies = snapshot.data!.results;
                  return MasonryGridView.count(
                    padding: const EdgeInsets.all(5.0),
                    crossAxisCount: 1 * 3, // Adjust number of
                    mainAxisSpacing: 1.5,
                    controller: ScrollController(keepScrollOffset: true),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    crossAxisSpacing: 1.5,
                  //  cacheExtent: 100,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // Wrap card for tap vibration if the card itself does not handle
                        onTap: () {
                          tVmedium();
                        },
                        child: _buildRecommendationCard(context, movies[index]),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No recommendations found.'));
                }
              },
            )
          : FutureBuilder<TvShowResponse>(
              future: _tvRecommendationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Failed to load recommendations.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            _fetchRecommendations();
                          }),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData &&
                    snapshot.data!.results.isNotEmpty) {
                  final tvShows = snapshot.data!.results;
                  return MasonryGridView.count(
                    padding: const EdgeInsets.all(5.0),
                    crossAxisCount: 1 * 3, // Adjust number of
                    mainAxisSpacing: 1.5,
                    controller: ScrollController(keepScrollOffset: true),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    crossAxisSpacing: 1.1,
                   // cacheExtent: 100,
                    itemCount: tvShows.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // Wrap card for tap vibration if the card itself does not handle
                        onTap: () {
                          tVmedium();
                        },
                        child:
                            _buildTvRecommendationCard(context, tvShows[index]),
                      );
                      // We can reuse the same card widget from your detail page logic
                      //  return _buildTvRecommendationCard(context, tvShows[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('No recommendations found.'));
                }
              },
            ),
    );
  }

  // I've copied this widget directly from your MovieDetailPage code for consistency!
  Widget _buildRecommendationCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(id: movie.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie-recommendation-${movie.id}',
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  movie.fullPosterPath.isNotEmpty
                      ? CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: movie.fullPosterPath,
                          width: double.infinity,
                          height: 200, // Adjust height for grid view
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            //    height: 200,
                            color: Colors.grey[800],
                            child: const Center(
                                child: Icon(Icons.movie,
                                    size: 40, color: AppColors.secondaryText)),
                          ),
                        )
                      : Container(
                          //  height: 200,
                          color: Colors.grey[800],
                          child: const Center(
                              child: Icon(Icons.movie,
                                  size: 40, color: AppColors.secondaryText)),
                        ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRatingColor(movie.voteAverage),
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.5) return Colors.green.shade700;
    if (rating >= 5.0) return Colors.orange.shade700;
    if (rating > 0.0) return Colors.red.shade700;
    return Colors.grey.shade700;
  }

  Widget _buildTvRecommendationCard(BuildContext context, TvShow series) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TvShowDetailPageAnime(
              tvShow: series,
              typec: widget.typec,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'tv-show-recommendation-${series.id}',
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  series.fullPosterPath.isNotEmpty
                      ? CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: series.fullPosterPath,
                          width: double.infinity,
                          height: 200, // Adjust height for grid view
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: Colors.grey[800],
                            child: const Center(
                                child: Icon(Icons.movie,
                                    size: 40, color: AppColors.secondaryText)),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[800],
                          child: const Center(
                              child: Icon(Icons.movie,
                                  size: 40, color: AppColors.secondaryText)),
                        ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRatingColor(series.voteAverage),
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          series.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                series.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
