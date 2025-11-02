import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying basic movie information (poster, title, rating, etc.)
class MovieBasicInfo extends StatelessWidget {
  final Movie movie;
  final String? translatedTitle;
  final bool isTranslating;
  final VoidCallback onTranslate;
  final bool showDetailedInfo;

  const MovieBasicInfo({
    Key? key,
    required this.movie,
    this.translatedTitle,
    required this.isTranslating,
    required this.onTranslate,
    this.showDetailedInfo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'movie-${movie.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 120,
              height: 180,
              child: movie.fullPosterPath.isNotEmpty
                  ? CachedNetworkImage(
                      filterQuality: FilterQuality.high,
                      imageUrl: movie.fullPosterPath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: AppColors.accentColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 30,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 100),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 30,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                translatedTitle ?? movie.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Release Date: ${movie.releaseDate}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${movie.voteAverage.toStringAsFixed(1)} (${movie.voteCount} votes)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  IconButton(
                    icon: isTranslating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                    onPressed: onTranslate,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(4.0),
                    ),
                  ),
                ],
              ),
              if (showDetailedInfo && movie.runtime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        movie.formattedRuntime,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              if (showDetailedInfo && movie.genres!.isNotEmpty)
                Text(
                  'Genres: ${movie.genresText}',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else
                Text(
                  'Original Language: ${movie.originalLanguage.toUpperCase()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
