// lib/widgets/episode_tile.dart
import 'package:flutter/material.dart';
import 'package:miko/models/episode.dart';
import 'package:miko/screens/video_player_screen.dart';
import 'package:miko/services/user_data_service.dart';
//import 'package:myapp/screens/video_player_screen.dart'; // Your player screen
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';

class EpisodeTile extends StatelessWidget {
  final Episode episode;
final  season;
  final  id;
  const EpisodeTile({required this.episode,
      required this.season,
      required this.id, super.key});


  @override
  Widget build(BuildContext context) {
    final availableQualities = episode.getAvailableQualityUrls();
        final userDataService = Provider.of<UserDataService>(context);


  void playVideo(BuildContext context, String url) async {
  await userDataService.toggleIsWatchedLink(id, episode, season, availableQualities.toString());
    final encodedUrl = Uri.encodeComponent(url);
    Navigator.push(
       context,
    MaterialPageRoute(
      builder: (_) => VideoPlayerScreen(videoUrl: url), // Pass movie ID
    ));
  }
    // Create a display title: "E01: Episode Name" or just "Episode 1" if no name
    // Since we removed tmdbTitle, we'll rely on season/episode numbers.
    final displayTitle = 'Episode ${episode.episodeNumber}'; // Simple display
    // Or use the identifier: final displayTitle = episode.episodeIdentifier;
bool isInWatchlist = userDataService.isWatchedEpisode(
        id, episode, season, availableQualities.toString());
    return Padding(
      // Add padding instead of using Card margin for better control with dividers
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0), // Adjust padding as needed
      child: Row(
        children: [
          // Episode Number/Identifier
          Expanded(
            flex: 3, // Give reasonable space to title/identifier
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle, // Use the generated display title
                  style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  maxLines: 2, // Allow wrapping
                  overflow: TextOverflow.ellipsis,
                ),
                // Optionally show the SxxExx identifier below if different
                if (episode.episodeIdentifier != displayTitle)
                  Text(
                    episode.episodeIdentifier,
                    style: const TextStyle(
                        color: AppColors.secondaryText, fontSize: 11),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Quality Buttons
          if (availableQualities.isNotEmpty)
            Expanded(
              flex: 4, // Give slightly more space for buttons maybe
              child: Wrap(
                alignment: WrapAlignment.end, // Align buttons to the right
                spacing: 6.0, // Horizontal space between buttons
                runSpacing: 4.0, // Vertical space if wraps
                children: availableQualities.entries.map((entry) {
                  final quality = entry.key;
                  final url = entry.value;
                  return ElevatedButton(
                    onPressed: () => playVideo(context, url),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor
                          .withOpacity(0.7), // Button color
                      foregroundColor: AppColors.primaryText, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5), // Adjusted padding
                      minimumSize: const Size(45, 28), // Ensure minimum size
                      textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold), // Adjust font
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 1, // Slight elevation
                    ),
child: Text(
                      isInWatchlist?
                      
                      
                        quality.toUpperCase()+''+'' "Watched this Episode"'':quality
                        .toUpperCase()), // Uppercase quality (e.g., 1080P)
                  );
                }).toList(),
              ),
            )
          else
            // Show something if no qualities are found for this episode
            const Text(
              'No links',
              style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}