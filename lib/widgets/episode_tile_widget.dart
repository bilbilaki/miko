// lib/widgets/tv_series_card.dart

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:miko/main.dart';
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/screens/dl.dart';
import 'package:miko/showcases/movie_service.dart';
//import 'package:myapp/screens/anime_details_screen.dart';
import 'package:miko/utils/colors.dart'; // Assuming AppColors exists
// For date formatting
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/utils.dart';
//import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
// For accessing UserDataService

import '../screens/video_player_wplaylist_screen.dart';

class EpisodeTileNew extends StatelessWidget {
  final String seriesname;
  final ss.Season season;
  final ss.Episode episode;
  final int id;

  const EpisodeTileNew({
    required this.seriesname,
    required this.episode,
    required this.season,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final availableQualities = episode.getAvailableQualityUrls();
    final userDataService = Provider.of<UserDataService>(
      context,
      listen: false,
    );

    void playEpisode(BuildContext context, url) async {
      final int initialIndex = season.episodes.indexOf(episode);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreenPl(
            seriesname: seriesname,
            tvSeriesId: id,
            season: season,
            playlist: season.episodes,
            initialIndex: initialIndex,
            url: url,
          ),
        ),
      );
    }

    bool isInWatchlist = userDataService.isWatchedEpisode(
      seriesname,
      id,
      episode.episodeNumber,
      season.seasonNumber,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Episode ${episode.episodeNumber}',
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (episode.episodeIdentifier !=
                    'Episode ${episode.episodeNumber}')
                  Text(
                    episode.episodeIdentifier,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          // --- ADDED THIS: The watched icon ---
          if (isInWatchlist)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.check_circle,
                color: AppColors.accentColor,
                size: 18.0,
              ),
            ),

          const SizedBox(width: 12),

          if (availableQualities.isNotEmpty)
            Expanded(
              flex: 4,
              child: Wrap(
                // Using Wrap here to allow buttons to break to a new line if needed
                alignment:
                    WrapAlignment.end, // Aligns button groups to the right
                spacing:
                    6.0, // Space between button groups (Row of two buttons)
                runSpacing:
                    4.0, // Space between lines of button groups if they wrap
                children: availableQualities.entries.map<Widget>((entry) {
                  final url = entry.value;
                  return Row(
                    mainAxisSize: MainAxisSize
                        .min, // Important: Make Row only take up needed space
                    children: [
                      // --- PLAY Button (e.g., "▶ 1080P") ---
                      ElevatedButton.icon(
                        onPressed: () => playEpisode(context, url),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor.withValues(alpha:
                            0.7,
                          ),
                          foregroundColor: AppColors.primaryText,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          minimumSize: const Size(45, 28),
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 1,
                        ),
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 16,
                        ), // Explicit play icon
                        label: Text(entry.key.toUpperCase()), // e.g., '1080P'
                      ),

                      const SizedBox(
                        width: 8,
                      ), // Spacing between Play and Download
                      // --- DOWNLOAD Button (e.g., "⬇ Download") ---
                      OutlinedButton.icon(
                        // Changed to OutlinedButton for secondary action
                        onPressed: () {
                          downloadManager.addDownload(
                            DownloadItem(
                              null, // path will be set internally
                              episode.episodeNumber, // episodeNumber
                              season.seasonNumber, // sessionNumber
                              seriesname, // name
                              isMovie: false,
                              task: DownloadTask(
                                url: entry.value,
                                taskId:
                                    '$seriesname.${season.seasonNumber}.${episode.episodeNumber}.${entry.key}', // Added entry.key for unique task ID per resolution
                              ),
                              idC: id, // Dummy ID
                              movieService: MovieService(),
                            ),
                          );

                          tVClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DownloadScreen(
                                downloadManager: downloadManager,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              AppColors.primaryText, // Text/icon color (white)
                          side: BorderSide(
                            color: AppColors.primaryText.withValues(alpha:
                              0.4,
                            ), // Subtle white border
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          minimumSize: const Size(45, 28),
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          // OutlinedButton doesn't have elevation by default, which is desired for secondary action
                        ),
                        icon: const Icon(
                          Icons.download,
                          size: 16,
                        ), // Download icon
                        label: const Text('Download'),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
          else
            const Text(
              'No links',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
