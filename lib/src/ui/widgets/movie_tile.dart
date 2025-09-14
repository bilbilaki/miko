import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/utils/colors.dart';

class MovieTile extends StatelessWidget {
  final int id;
  final String title;
  final String? posterPath;
  final VoidCallback? onTap;

  const MovieTile({
    required this.id,
    required this.title,
    this.posterPath,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = posterPath != null ? 'https://db.inosuke.sbst/p/w500$posterPath' : null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors2.accentColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: AppColors2.tinytext,
                                      size: 36,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.movie_filter_outlined,
                                    color: AppColors2.tinytext,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}