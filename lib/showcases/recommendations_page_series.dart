import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/utils/colors.dart';
// Make sure to import your models, services, and other pages

class RecommendationsPage extends StatefulWidget {
  final int seriesId;
  final String seriesTitle
  ;

  const RecommendationsPage({
    super.key,
    required this.seriesId,
    required this.seriesTitle
    ,
  });

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final MovieService _serieservice = MovieService();
  late Future<TvShowResponse> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  void _fetchRecommendations() {
    _recommendationsFuture = _serieservice.getTvShowRecommendations(tvShowId: widget.seriesId);
  }
  
  @override
  void dispose() {
    _serieservice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More like ${widget.seriesTitle
        }'),
        centerTitle: true,
      ),
      body: FutureBuilder<TvShowResponse>(
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
          } else if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
            final series = snapshot.data!.results;
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: series.length,
              itemBuilder: (context, index) {
                // We can reuse the same card widget from your detail page logic
                return _buildRecommendationCard(context, series[index]);
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
  Widget _buildRecommendationCard(BuildContext context, TvShow movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TvShowDetailPageAnime(tvShow: movie, typec: "series",),
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
                          imageUrl: movie.fullPosterPath,
                          width: double.infinity,
                          height: 200, // Adjust height for grid view
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: Colors.grey[800],
                            child: const Center(child: Icon(Icons.movie, size: 40, color: AppColors.secondaryText)),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[800],
                          child: const Center(child: Icon(Icons.movie, size: 40, color: AppColors.secondaryText)),
                        ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRatingColor(movie.voteAverage),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
                movie.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
}