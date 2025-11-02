import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart' as m;
import 'package:miko/utils/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'anime_detail_utils.dart';

/// Builds an episode card widget
class EpisodeCardWidget extends StatelessWidget {
  final m.Episode episode;
  final int tvShowId;
  final bool isNext;
  final VoidCallback onTap;

  const EpisodeCardWidget({
    Key? key,
    required this.episode,
    required this.tvShowId,
    required this.isNext,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isNext
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
          : Colors.grey[850],
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEpisodeHeader(context),
              const SizedBox(height: 12),
              _buildEpisodeTitle(),
              const SizedBox(height: 8),
              _buildAirDateText(context),
              if (episode.runtime != null) ...[
                const SizedBox(height: 4),
                _buildRuntimeText(context),
              ],
              const SizedBox(height: 12),
              if (episode.stillPath != null) _buildStillImage(),
              const SizedBox(height: 12),
              _buildOverviewText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeHeader(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: isNext
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey[700],
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          'S${episode.seasonNumber} | E${episode.episodeNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const SizedBox(width: 8),
      if (episode.episodeType != 'standard')
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AnimeDetailUtils.getEpisodeTypeColor(episode.episodeType),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            episode.episodeType.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    ]);
  }

  Widget _buildEpisodeTitle() {
    return Text(
      episode.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildAirDateText(BuildContext context) {
    return Text(
      'Air date: ${episode.formattedAirDate}',
      style: TextStyle(
          color: isNext
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.8)
              : Colors.grey[400],
          fontSize: 14),
    );
  }

  Widget _buildRuntimeText(BuildContext context) {
    return Text(
      'Runtime: ${episode.formattedRuntime}',
      style: TextStyle(color: Colors.grey[400], fontSize: 14),
    );
  }

  Widget _buildStillImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.high,
        imageUrl: episode.fullStillPath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Container(color: Colors.black),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined,
                color: AppColors.secondaryText, size: 40),
          ),
        ),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    );
  }

  Widget _buildOverviewText() {
    return Text(
      episode.overview,
      style: const TextStyle(fontSize: 14),
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Builds a statistic card widget
class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon,
                size: 30, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
