import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart' as m;
import 'package:miko/utils/ai_translator.dart';
import 'package:miko/utils/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'anime_detail_utils.dart';

/// Builds an episode card widget with translation support
class EpisodeCardWidget extends StatefulWidget {
  final m.Episode episode;
  final int tvShowId;
  final bool isNext;
  final VoidCallback onTap;

  const EpisodeCardWidget({
    super.key,
    required this.episode,
    required this.tvShowId,
    required this.isNext,
    required this.onTap,
  });

  @override
  State<EpisodeCardWidget> createState() => _EpisodeCardWidgetState();
}

class _EpisodeCardWidgetState extends State<EpisodeCardWidget> {
  String? _translatedOverview;
  String? _translatedTitle;
  bool _isTranslating = false;
  final _translator = MovieTvTranslator();

  Future<void> _translateContent() async {
    if (_translatedOverview != null) {
      setState(() {
        _translatedOverview = null;
        _translatedTitle = null;
      });
      return;
    }

    setState(() => _isTranslating = true);
    try {
      // Translate both title and overview
      final results = await Future.wait([
        _translator.translateTextForMoviesAndTV(widget.episode.name),
        if (widget.episode.overview.isNotEmpty)
          _translator.translateTextForMoviesAndTV(widget.episode.overview),
      ]);
      
      setState(() {
        _translatedTitle = results[0];
        if (results.length > 1) {
          _translatedOverview = results[1];
        }
      });
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isNext
          ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)
          : Colors.grey[850],
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
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
              if (widget.episode.runtime != null) ...[
                const SizedBox(height: 4),
                _buildRuntimeText(context),
              ],
              const SizedBox(height: 12),
              if (widget.episode.stillPath != null) _buildStillImage(),
              const SizedBox(height: 12),
              _buildOverviewWithTranslation(),
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
            color: widget.isNext
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey[700],
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          'S${widget.episode.seasonNumber} | E${widget.episode.episodeNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const SizedBox(width: 8),
      if (widget.episode.episodeType != 'standard')
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AnimeDetailUtils.getEpisodeTypeColor(widget.episode.episodeType),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.episode.episodeType.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      const Spacer(),
      IconButton(
        icon: _isTranslating
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.auto_awesome,
                color: _translatedOverview != null ? Colors.cyan : Colors.white54,
                size: 18,
              ),
        onPressed: _translateContent,
        tooltip: _translatedOverview != null ? 'Show original' : 'Translate',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      ),
    ]);
  }

  Widget _buildEpisodeTitle() {
    return Text(
      _translatedTitle ?? widget.episode.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildAirDateText(BuildContext context) {
    return Text(
      'Air date: ${widget.episode.formattedAirDate}',
      style: TextStyle(
          color: widget.isNext
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8)
              : Colors.grey[400],
          fontSize: 14),
    );
  }

  Widget _buildRuntimeText(BuildContext context) {
    return Text(
      'Runtime: ${widget.episode.formattedRuntime}',
      style: TextStyle(color: Colors.grey[400], fontSize: 14),
    );
  }

  Widget _buildStillImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.high,
        imageUrl: widget.episode.fullStillPath,
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

  Widget _buildOverviewWithTranslation() {
    final displayOverview = _translatedOverview ?? widget.episode.overview;
    if (displayOverview.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      displayOverview,
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
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

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
