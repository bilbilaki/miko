import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/ai_translator.dart';
import 'package:miko/utils/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:provider/provider.dart';

/// Custom share item model
class ShareItem {
  final String name;
  final double vote;
  final String releaseDate;
  final String overview;
  final String posterUrl;
  final String internalUrl;

  ShareItem({
    required this.name,
    required this.vote,
    required this.releaseDate,
    required this.overview,
    required this.posterUrl,
    required this.internalUrl,
  });
}

/// Builds the app bar for anime/TV show detail page with translation support
class AnimeDetailAppBar extends StatefulWidget {
  final TvShow tvShow;
  final String? translatedTitle;
  final VoidCallback onTranslateTitle;
  final String overview;

  const AnimeDetailAppBar({
    super.key,
    required this.tvShow,
    this.translatedTitle,
    required this.onTranslateTitle,
    required this.overview,
  });

  @override
  State<AnimeDetailAppBar> createState() => _AnimeDetailAppBarState();
}

class _AnimeDetailAppBarState extends State<AnimeDetailAppBar> {
  String? _translatedTagline;
  bool _isTranslatingTagline = false;

  Future<void> _translateTagline() async {
    if (_translatedTagline != null) {
      setState(() => _translatedTagline = null);
      return;
    }

    if (widget.tvShow.tagline == null || widget.tvShow.tagline!.isEmpty) return;

    setState(() => _isTranslatingTagline = true);
    try {
      final translated = await MovieTvTranslator().translateTextForMoviesAndTV(widget.tvShow.tagline!,context);
      setState(() => _translatedTagline = translated);
    } finally {
      setState(() => _isTranslatingTagline = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int tvSeriesId = widget.tvShow.id;
    var userDataService = Provider.of<UserDataService>(context);
    String backdropUrl = widget.tvShow.fullBackdropPath;
    String posterUrl = widget.tvShow.fullPosterPath;
    bool isFavorite = userDataService.isFavoriteAnime(tvSeriesId);
    bool isInWatchlist = userDataService.isOnWatchlistAnime(tvSeriesId);

    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.translatedTitle ?? widget.tvShow.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            height: 1.2,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 8,
                color: Colors.black.withValues(alpha: 0.8),
              ),
              Shadow(
                offset: const Offset(-1, -1),
                blurRadius: 4,
                color: Colors.purple.withValues(alpha: 0.3),
              ),
              Shadow(
                offset: const Offset(0, 0),
                blurRadius: 20,
                color: Colors.cyan.withValues(alpha: 0.4),
              ),
            ],
            foreground: Paint()
              ..shader = LinearGradient(
                colors: const [
                  Color(0xFFFF6B6B),
                  Color(0xFF4ECDC4),
                  Color(0xFF45B7D1),
                  Color(0xFF96CEB4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(const Rect.fromLTWH(0, 0, 300, 100)),
          ),
        ),
        background: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Backdrop Image
              CachedNetworkImage(
                filterQuality: FilterQuality.high,
                imageUrl: backdropUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.secondaryBackground,
                  child: Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: const Icon(Icons.image,
                          size: 80, color: Colors.white12),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.secondaryBackground,
                  child: posterUrl.isNotEmpty
                      ? CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: posterUrl,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          placeholder: (context, url) => const SizedBox.shrink(),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.tv_off_outlined,
                                color: AppColors.secondaryText, size: 40),
                          ),
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 100),
                        )
                      : const Center(
                          child: Icon(Icons.tv_off_outlined,
                              color: AppColors.secondaryText, size: 40),
                        ),
                ),
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 100),
              ),
              // Action Buttons
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFavoriteButton(context, userDataService, isFavorite, tvSeriesId),
                    const SizedBox(width: 4),
                    _buildRatingBubble(widget.tvShow),
                    const SizedBox(width: 4),
                    _buildWatchlistButton(context, userDataService, isInWatchlist, tvSeriesId),
                    const SizedBox(width: 4),
                    _buildShareButton(context, widget.tvShow, widget.overview),
                  ],
                ),
              ),
              // Tagline with translation support
              if (widget.tvShow.tagline != null && widget.tvShow.tagline!.isNotEmpty)
                Positioned(
                  bottom: 60,
                  left: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _translateTagline,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '"${_translatedTagline ?? widget.tvShow.tagline!}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (_isTranslatingTagline)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: _translatedTagline != null 
                                ? Colors.cyan 
                                : Colors.white54,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context,
      UserDataService userDataService, bool isFavorite, int tvSeriesId) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.white,
        size: 20,
      ),
      onPressed: () async {
        if (Platform.isAndroid) HapticFeedback.lightImpact();
        await userDataService.toggleFavoriteAnime(tvSeriesId);
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }

  Widget _buildRatingBubble(TvShow tvShow) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        '${tvShow.voteAverage.toStringAsFixed(1)} (${tvShow.voteCount})',
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildWatchlistButton(BuildContext context,
      UserDataService userDataService, bool isInWatchlist, int tvSeriesId) {
    return IconButton(
      icon: Icon(
        isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
        color: isInWatchlist ? Colors.green : Colors.white,
        size: 20,
      ),
      onPressed: () async {
        if (Platform.isAndroid) HapticFeedback.lightImpact();
        await userDataService.toggleWatchlistAnime(tvSeriesId);
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }

  Widget _buildShareButton(
      BuildContext context, TvShow tvShow, String overview) {
    return IconButton(
      icon: const Icon(
        Icons.share,
        color: Colors.purpleAccent,
        size: 20,
      ),
      onPressed: () async {
        var myItem = ShareItem(
          name: tvShow.name,
          vote: tvShow.voteAverage,
          releaseDate: tvShow.firstAirDate.toString(),
          overview: tvShow.overview,
          posterUrl: tvShow.fullPosterPath,
          internalUrl: 'https://inosuke.page.link/miko/series${tvShow.id}',
        );

        String shareContent = '''
Check out this: ${myItem.name}
Rating: ${myItem.vote}
Release Date: ${myItem.releaseDate}
Overview: $overview
Open in miko by click on ${myItem.internalUrl}
''';
        SharePlus.instance.share(ShareParams(text: shareContent));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Share item ...'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
   final TabBar _tabBar;
  SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) => false;
}

