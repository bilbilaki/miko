import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/utils/detail_page_navigation.dart';
import 'package:miko/showcases/utils/haptic_helper.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying crew members (writers, producers) as chips
class MovieCrewChipSection extends StatelessWidget {
  final String title;
  final List<Crew> crewMembers;
  final int? maxDisplay;
  final VoidCallback? onSeeAll;

  const MovieCrewChipSection({
    super.key,
    required this.title,
    required this.crewMembers,
    this.maxDisplay,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (crewMembers.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayMembers = maxDisplay != null
        ? crewMembers.take(maxDisplay!).toList()
        : crewMembers;
    final hasMore = maxDisplay != null && crewMembers.length > maxDisplay!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displayMembers.map((member) {
            return GestureDetector(
              onTap: () {
                DetailPageNavigation.navigateToPersonDetail(
                  context,
                  member.id,
                  member.name,
                  member.profilePath,
                );
              },
              child: Chip(
                avatar: member.profilePath != null
                    ? CachedNetworkImage(
                        filterQuality: FilterQuality.high,
                        imageUrl: member.fullProfilePath,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: AppColors.accentColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 16,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 100),
                      )
                    : const CircleAvatar(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                label: Text('${member.name} (${member.job})'),
                backgroundColor: Colors.grey[800],
                labelStyle: const TextStyle(color: AppColors.primaryText),
              ),
            );
          }).toList(),
        ),
        if (hasMore && onSeeAll != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                HapticHelper.performHapticFeedback();
                onSeeAll!();
              },
              child: Text(
                'See all ${crewMembers.length} ${title.toLowerCase()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
