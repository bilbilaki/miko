import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

import 'anime_detail_utils.dart';

/// Builds a single recommendation card - supports both Movie and TvShow
class RecommendationCardWidget extends StatelessWidget {
  final dynamic item; // Movie or TvShow
  final String heroTag;
  final VoidCallback onTap;
  final bool isMovie;

  const RecommendationCardWidget({
    Key? key,
    required this.item,
    required this.heroTag,
    required this.onTap,
    this.isMovie = false,
  }) : super(key: key);

  String get _title => isMovie ? item.title : item.name;
  double get _voteAverage => item.voteAverage;
  String get _posterPath => item.fullPosterPath;
  String get _year {
    if (isMovie) {
      return item.releaseDate.isNotEmpty && item.releaseDate.length >= 4
          ? item.releaseDate.substring(0, 4)
          : '';
    } else {
      return item.firstAirDate != null && item.firstAirDate!.isNotEmpty
          ? item.year
          : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isAndroid) HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    _posterPath.isNotEmpty
                        ? CachedNetworkImage(
                            filterQuality: FilterQuality.high,
                            imageUrl: _posterPath,
                            height: 170,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(color: Colors.black),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 170,
                              width: 130,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.secondaryText,
                                    size: 30),
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          )
                        : Container(
                            height: 170,
                            width: 130,
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined,
                                  color: AppColors.secondaryText, size: 30),
                            ),
                          ),
                    if (_voteAverage > 0)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: isMovie
                                ? AnimeDetailUtils.getRatingColor(_voteAverage)
                                : Colors.black.withOpacity(0.7),
                            borderRadius: isMovie
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(8))
                                : BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.white, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                _voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(_title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText)),
            if (_year.isNotEmpty)
              Text(_year,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}

/// Builds the recommendations section - handles both TV shows and Movies
class RecommendationsSectionWidget extends StatelessWidget {
  final TvShowResponse? recommendations;
  final MovieResponse? recommendationsM;
  final VoidCallback onShowAllPressed;
  final dynamic onRecommendationTapped; // Function(TvShow) or Function(Movie)
  final Function(dynamic)? onMovieTapped; // For movie specific callbacks
  final bool isMovie;

  const RecommendationsSectionWidget({
    Key? key,
    required this.recommendations,
    required this.onShowAllPressed,
    required this.onRecommendationTapped,
    required this.recommendationsM,
    this.onMovieTapped,
    this.isMovie = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTvEmpty = recommendations == null || recommendations!.results.isEmpty;
    final isMovieEmpty = recommendationsM == null || recommendationsM!.results.isEmpty;
    
    if (isTvEmpty && isMovieEmpty) {
      return const SizedBox.shrink();
    }

    final hasMovieData = !isMovieEmpty && (isMovie || (isTvEmpty && !isMovieEmpty));
    final displayData = hasMovieData ? recommendationsM!.results : recommendations!.results;
    final maxItems = displayData.length > 10 ? 10 : displayData.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hasMovieData ? 'Movie Recommendations' : 'Recommendations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (displayData.length > 10)
                TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) HapticFeedback.lightImpact();
                    onShowAllPressed();
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (Platform.isAndroid &&
                  scrollInfo is ScrollUpdateNotification) {
                if (scrollInfo.scrollDelta != null &&
                    scrollInfo.scrollDelta! != 0) {
                  // Haptic feedback on scroll if needed
                }
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: maxItems,
              itemBuilder: (context, index) {
                final item = displayData[index];
                final id = hasMovieData 
                    ? (item as Movie).id 
                    : (item as TvShow).id;
                final heroTag = hasMovieData
                    ? 'movie-recommendation-$id'
                    : 'tv-recommendation-$id';
                
                return RecommendationCardWidget(
                  item: item,
                  heroTag: heroTag,
                  isMovie: hasMovieData,
                  onTap: () {
                    if (hasMovieData && onMovieTapped != null) {
                      onMovieTapped!(item);
                    } else if (!hasMovieData) {
                      onRecommendationTapped(item);
                    }
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
