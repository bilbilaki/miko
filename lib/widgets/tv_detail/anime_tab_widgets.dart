import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'anime_episode_widgets.dart';

/// Builds the overview tab content
class OverviewTabWidget extends StatelessWidget {
  final TvShow tvShow;
  final String overview;
  final VoidCallback onTranslate;
  final VoidCallback onLongPress;

  const OverviewTabWidget({
    Key? key,
    required this.tvShow,
    required this.overview,
    required this.onTranslate,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          IconButton(
            iconSize: 20.0,
            icon: const Icon(Icons.assistant),
            tooltip: 'translate overview',
            onPressed: onTranslate,
            onLongPress: onLongPress,
          ),
          Text(
            overview.isEmpty ? 'No overview available.' : overview,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _buildGenresSection(context),
          _buildCreatedBySection(context),
          _buildEpisodeInfoSection(context),
          _buildNetworksSection(context),
          _buildStatisticsSection(context),
        ],
      ),
    );
  }

  Widget _buildGenresSection(BuildContext context) {
    if (tvShow.genres == null || tvShow.genres!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Genres', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tvShow.genres!
              .map((genre) => Chip(
                  label: Text(genre.name),
                  backgroundColor: Colors.grey[800]))
              .toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCreatedBySection(BuildContext context) {
    if (tvShow.createdBy == null || tvShow.createdBy!.isEmpty) {
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
            itemCount: tvShow.createdBy!.length,
            itemBuilder: (context, index) {
              final creator = tvShow.createdBy![index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: creator.fullProfilePath,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 100,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[800]!,
                            highlightColor: Colors.grey[700]!,
                            child: Container(color: Colors.black),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.person,
                                color: AppColors.secondaryText),
                          ),
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 100),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(creator.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10)),
                    ],
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

  Widget _buildEpisodeInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tvShow.nextEpisodeToAir != null) ...[
          Text('Next Episode to Air',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const SizedBox(height: 24),
        ],
        if (tvShow.lastEpisodeToAir != null) ...[
          Text('Last Episode Aired',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildNetworksSection(BuildContext context) {
    if (tvShow.networks == null || tvShow.networks!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Networks', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tvShow.networks!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(width: 250),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    if (tvShow.numberOfSeasons == null && tvShow.numberOfEpisodes == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Show Statistics',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (tvShow.numberOfSeasons != null)
              Expanded(
                child: StatCardWidget(
                  title: 'Seasons',
                  value: tvShow.numberOfSeasons.toString(),
                  icon: Icons.movie_filter_outlined,
                ),
              ),
            if (tvShow.numberOfSeasons != null &&
                tvShow.numberOfEpisodes != null)
              const SizedBox(width: 16),
            if (tvShow.numberOfEpisodes != null)
              Expanded(
                child: StatCardWidget(
                  title: 'Episodes',
                  value: tvShow.numberOfEpisodes.toString(),
                  icon: Icons.list_alt_outlined,
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Builds the cast tab content
class CastTabWidget extends StatelessWidget {
  final Future<TVCredits> creditsFuture;
  final Function(int, String, String?) onCastTapped;

  const CastTabWidget({
    Key? key,
    required this.creditsFuture,
    required this.onCastTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TVCredits>(
      future: creditsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingGrid();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading cast: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.cast.isNotEmpty) {
          List<TVCast> cast = snapshot.data!.cast
            ..sort((a, b) => a.order.compareTo(b.order));
          return _buildCastGrid(context, cast);
        } else {
          return const Center(child: Text('No cast information available.'));
        }
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(color: Colors.black),
                ),
              ),
              const SizedBox(height: 6),
              Container(width: double.infinity, height: 10, color: Colors.black),
              const SizedBox(height: 4),
              Container(width: double.infinity, height: 8, color: Colors.black),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCastGrid(BuildContext context, List<TVCast> cast) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: cast.length,
      itemBuilder: (context, index) {
        TVCast member = cast[index];
        return GestureDetector(
          onTap: () {
            if (Platform.isAndroid) HapticFeedback.lightImpact();
            onCastTapped(member.id, member.name, member.profilePath);
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    imageUrl: member.profilePath.isNotEmpty
                        ? 'https://db.inosuke.sbs/t/p/w500${member.profilePath}'
                        : '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.black),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.person,
                          color: AppColors.secondaryText, size: 40),
                    ),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 100),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(member.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(member.character,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400])),
            ],
          ),
        );
      },
    );
  }
}
