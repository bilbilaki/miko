import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

/// Builds the header section with poster and info
class AnimeDetailHeader extends StatelessWidget {
  final TvShow tvShow;
  final bool showShimmer;
  final String? translatedTitle;
  final VoidCallback onTranslate;
  final bool isTranslating;

  const AnimeDetailHeader({
    super.key,
    required this.tvShow,
    required this.showShimmer,
    this.translatedTitle,
    required this.onTranslate,
    required this.isTranslating,
  });

  @override
  Widget build(BuildContext context) {
    Widget posterWidget = _buildPosterWidget();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'tvshow-${tvShow.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 180,
                child: posterWidget,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoColumn(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterWidget() {
    return tvShow.fullPosterPath.isNotEmpty
        ? CachedNetworkImage(
            filterQuality: FilterQuality.high,
            imageUrl: tvShow.fullPosterPath,
            fit: BoxFit.cover,
            placeholder: (context, url) => showShimmer
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[700]!,
                    child: Container(color: Colors.black),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: AppColors.accentColor,
                    ),
                  ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.secondaryText,
                size: 30,
              ),
            ),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 100),
          )
        : const Center(
            child: Icon(Icons.tv_off_outlined,
                color: AppColors.secondaryText, size: 40),
          );
  }

  Widget _buildInfoColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translatedTitle ?? tvShow.name,
            style: Theme.of(context).textTheme.titleLarge),
        if (tvShow.originalName != tvShow.name)
          Text('(${tvShow.originalName})',
              style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        const SizedBox(height: 8),
        _buildRatingRow(context),
        const SizedBox(height: 8),
        _buildAirDateRow(context),
        const SizedBox(height: 8),
        if (tvShow.episodeRunTime != null)
          _buildRuntimeRow(context),
        const SizedBox(height: 8),
        if (tvShow.originCountry.isNotEmpty)
          _buildCountryRow(context),
        const SizedBox(height: 8),
        _buildTranslateButton(context),
        if (tvShow.status != null)
          _buildStatusBadge(context),
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    return Row(children: [
      const Icon(Icons.star, color: Colors.amber, size: 20),
      const SizedBox(width: 4),
      Text(
          '${tvShow.voteAverage.toStringAsFixed(1)} (${tvShow.voteCount} votes)',
          style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }

  Widget _buildAirDateRow(BuildContext context) {
    return Row(children: [
      const Icon(Icons.calendar_today, size: 16),
      const SizedBox(width: 4),
      Expanded(
          child: Text(tvShow.airDateRange,
              style: Theme.of(context).textTheme.bodyMedium)),
    ]);
  }

  Widget _buildRuntimeRow(BuildContext context) {
    return Row(children: [
      const Icon(Icons.timer, size: 16),
      const SizedBox(width: 4),
      Text('Avg. Episode: ${tvShow.formattedRuntime}',
          style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }

  Widget _buildCountryRow(BuildContext context) {
    return Row(children: [
      const Icon(Icons.flag_outlined, size: 16),
      const SizedBox(width: 4),
      Expanded(
          child: Text(tvShow.originCountryText,
              style: Theme.of(context).textTheme.bodyMedium)),
    ]);
  }

  Widget _buildTranslateButton(BuildContext context) {
    return IconButton(
      icon: isTranslating
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
      onPressed: onTranslate,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha:0.5),
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(tvShow.status!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(tvShow.formattedStatus,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Returning Series':
        return Colors.green;
      case 'Ended':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      case 'In Production':
        return Colors.blue;
      case 'Pilot':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
