import 'package:flutter/material.dart';
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/showcases/episodedetailpage.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/utils/haptic_helper.dart';

/// Helper class for navigation in detail pages
class DetailPageNavigation {
  /// Navigate to person detail page
  static void navigateToPersonDetail(
    BuildContext context,
    int personId,
    String name,
    String? profilePath,
  ) {
    HapticHelper.performHapticFeedback();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailPage(
          personId: personId,
          initialName: name,
          initialProfilePath: profilePath,
        ),
      ),
    );
  }

  /// Navigate to episode detail page
  static void navigateToEpisodeDetail(
    BuildContext context, {
    required int tvShowId,
    required int seasonNumber,
    required int episodeNumber,
    required String episodeName,
    required MovieService movieService,
  }) {
    HapticHelper.performHapticFeedback();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpisodeDetailPage(
          tvShowId: tvShowId,
          seasonNumber: seasonNumber,
          episodeNumber: episodeNumber,
          episodeName: episodeName,
          movieService: movieService,
        ),
      ),
    );
  }
}
