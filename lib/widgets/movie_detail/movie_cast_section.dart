import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/cast_page.dart';
import 'package:miko/showcases/utils/detail_page_navigation.dart';
import 'package:miko/showcases/utils/haptic_helper.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying movie cast members
class MovieCastSection extends StatelessWidget {
  final List<Cast> cast;
  final int movieId;
  final String movieTitle;

  const MovieCastSection({
    Key? key,
    required this.cast,
    required this.movieId,
    required this.movieTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                HapticHelper.performHapticFeedback();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CastPage(
                      movieId: movieId,
                      movieTitle: movieTitle,
                    ),
                  ),
                );
              },
              child: Text(
                'See all ${cast.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (Platform.isAndroid &&
                  scrollInfo is ScrollUpdateNotification) {
                if (scrollInfo.scrollDelta != null &&
                    scrollInfo.scrollDelta! != 0) {
                  HapticFeedback.lightImpact();
                }
              }
              return false;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (context, index) {
                Cast castMember = cast[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      DetailPageNavigation.navigateToPersonDetail(
                        context,
                        castMember.id,
                        castMember.name,
                        castMember.profilePath,
                      );
                    },
                    child: SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'person-${castMember.id}',
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: castMember.profilePath != null
                                      ? CachedNetworkImage(
                                          filterQuality: FilterQuality.high,
                                          imageUrl: castMember.fullProfilePath,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              color: AppColors.accentColor,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey[800],
                                            child: const Center(
                                              child: Icon(
                                                Icons.image_not_supported_outlined,
                                                size: 40,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ),
                                          fadeInDuration:
                                              const Duration(milliseconds: 200),
                                          fadeOutDuration:
                                              const Duration(milliseconds: 100),
                                        )
                                      : Container(
                                          color: Colors.grey[800],
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 40,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            castMember.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            castMember.character,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
