import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/utils/detail_page_navigation.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying movie directors
class MovieDirectorsSection extends StatelessWidget {
  final List<Crew> directors;

  const MovieDirectorsSection({
    super.key,
    required this.directors,
  });

  @override
  Widget build(BuildContext context) {
    if (directors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Directors',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
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
              itemCount: directors.length,
              itemBuilder: (context, index) {
                Crew director = directors[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      DetailPageNavigation.navigateToPersonDetail(
                        context,
                        director.id,
                        director.name,
                        director.profilePath,
                      );
                    },
                    child: SizedBox(
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            elevation: 4,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: director.profilePath != null
                                  ? CachedNetworkImage(
                                      filterQuality: FilterQuality.high,
                                      imageUrl: director.fullProfilePath,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 40,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: AppColors.accentColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey,
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 40,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                      ),
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 100),
                                    )
                                  : const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 40,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            director.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Director',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
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
      ],
    );
  }
}
