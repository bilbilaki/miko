import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying TV show creators
class TvShowCreatorsSection extends StatelessWidget {
  final List<Creator> creators;
  final Function(int, String, String?) onCreatorTap;

  const TvShowCreatorsSection({
    super.key,
    required this.creators,
    required this.onCreatorTap,
  });

  @override
  Widget build(BuildContext context) {
    if (creators.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Created by', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: creators.length,
            itemBuilder: (context, index) {
              final creator = creators[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => onCreatorTap(
                    creator.id,
                    creator.name,
                    creator.profilePath,
                  ),
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: creator.profilePath != null
                              ? CachedNetworkImage(
                                  filterQuality: FilterQuality.high,
                                  imageUrl: creator.fullProfilePath,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 40,
                                      ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: AppColors.accentColor,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors.secondaryText,
                                      ),
                                  fadeInDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  fadeOutDuration: const Duration(
                                    milliseconds: 100,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.secondaryText,
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          creator.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
