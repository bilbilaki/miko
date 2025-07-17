import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/models/tv_series_anime.dart' as ss;
import 'package:miko/providers/ui_providers.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';


// Third Party Packages

// Flutter Packages

enum InternetConnectionStatus {
  /// connected to internet
  connected,

  /// disconnected from internet
  disconnected,

  /// slow internet
  slow,
}

class VideoPlayerScreen extends StatefulWidget {
  // NEW: Receive the full context instead of just a URL
  final String seriesname;
  final int tvSeriesId;
  final ss.Season season;
  final List<ss.Episode> playlist;
  final int initialIndex;
  final String url;

  const VideoPlayerScreen({
    required this.seriesname,
    required this.tvSeriesId,
    required this.season,
    required this.playlist,
    required this.initialIndex,
    required this.url,
    super.key,
  });

  @override
  State<VideoPlayerScreen> createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player player = Player();
  final userdata = UserDataService().decoderPreference;
  late final VideoController controller = VideoController(player);
  bool showControls = true;
  bool showEpisodeList = false;
  bool isFullScreen = false;
  bool isMuted = false;
  bool isPiPEnabled = false;
 // final String _selectedQuality = 'Auto'; // To track user's quality choice
  //final bool _isChangingQuality =
   //   false; // To prevent issues during quality switch
  Timer? _progressSaveTimer; // Timer to periodically save progress
  final ScrollController _seasonsScrollController = ScrollController();

  // --- UI State ---

  // Subtitle settings
  double subtitleSize = 32.0;
  Color subtitleColor = const Color.fromARGB(255, 238, 230, 5);
  bool showSubtitleControls = false;
  // State to manage the playlist
  late int currentIndex;
  ss.Episode? get currentEpisode =>
      widget.playlist.isNotEmpty ? widget.playlist[currentIndex] : null;

  // For showing/hiding controls
  Timer? _hideTimer;
  //bool showSubtitleControls = false;
  // double subtitleSize = 32.0;
  String currentQuality = 'Auto';

  final List<String> qualityOptions = [
    'Auto',
    '1080p',
    '720p',
    '540',
    '480p',
    'DUBBED'
  ];
  @override
  void initState() {
    super.initState();
    Provider.of<FloatingButtonVisibilityNotifier>(context, listen: false).hide();

    currentIndex = widget.initialIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {});

    // Open the video URL.
    player.open(Media(Uri.decodeComponent(widget.url)),
        play: true); // Start playing immediately

    // Listen for completion to auto-play the next episode
    player.stream.completed.listen((completed) {
      if (completed) {
        _clearPlaybackProgress(); // Clear progress for the completed episode
        playNext();
      }
    });

    player.stream.error.listen((error) => debugPrint('Player Error: $error'));

    // The new core logic for playing an episode

    // Start the timer to save progress periodically
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _savePlaybackProgress();
    });

    player.stream.error.listen((error) => debugPrint('Player Error: $error'));
  }

  //region Core Player Logic (The most important part)
  //================================================================================

  /// The main function to play an episode.
  /// It handles resuming, auto-quality selection, and opening the media.
  void playEpisode(int index, {bool isInitialPlay = false}) async {
    if (index < 0 || index >= widget.playlist.length) return;

    setState(() {
      currentIndex = index;
    });

    final episodeToPlay = widget.playlist[index];
    final userDataService =
        Provider.of<UserDataService>(context, listen: false);

    // --- Task 3: Resume Playback Logic ---
    Duration? seekToPosition;
    if (isInitialPlay) {
      final savedPosition = await userDataService.getEpisodeProgress(
        widget.tvSeriesId,
        episodeToPlay.seasonNumber,
        episodeToPlay.episodeNumber,
      );

      if (savedPosition != null && savedPosition.inSeconds > 10) {
        // Ask user if they want to resume
        final resume = await _showResumeDialog(savedPosition);
        if (resume == true) {
          seekToPosition = savedPosition;
        }
      }
    }

    // --- Task 1: Auto Quality Selection Logic ---
    final urlToPlay = episodeToPlay.getAvailableQualityUrls();
    
    final up = urlToPlay.values.first;
    await player.open(
      Media(Uri.decodeComponent(up)),
      play: true,
    );
    if (seekToPosition != null) {
      await player.seek(seekToPosition);
    }
    // Mark as watched (or started watching)
    userDataService.toggleIsWatchedLink(
        widget.seriesname, widget.tvSeriesId, episodeToPlay, widget.season);
  }

  /// --- Task 2: Change Quality Mid-Playback ---
  // Future<void> _changeQuality(String newQuality) async {
  //   if (_isChangingQuality || _selectedQuality == newQuality) return;

  //   setState(() {
  //     _isChangingQuality = true;
  //   });

  //   final position = player.state.position; // 1. Get current position
  //   final episode = currentEpisode;
  //   if (episode == null) return;

  //   String? newUrl;

  //   if (newUrl != null) {
  //     await player.open(Media(Uri.decodeComponent(newUrl))); // 2. Open new URL
  //     await player.seek(position); // 3. Seek to old position
  //     setState(() {
  //       _selectedQuality = newQuality;
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Quality "$newQuality" is not available.')),
  //     );
  //   }

  //   setState(() {
  //     _isChangingQuality = false;
  //   });
  // }

  /// Task 1 (Auto Mode): Finds the best URL based on a priority list.
  /// This is the simple version. For the speed test version, see below.

  Future<void> _savePlaybackProgress() async {
    if (player.state.playing && currentEpisode != null) {
      final position = player.state.position;
      final duration = player.state.duration;

      // Don't save if video is almost over or just started
      if (position.inSeconds > 10 && (duration - position).inSeconds > 15) {
        final userDataService =
            Provider.of<UserDataService>(context, listen: false);
        await userDataService.saveEpisodeProgress(
          widget.tvSeriesId,
          currentEpisode!.seasonNumber,
          currentEpisode!.episodeNumber,
          position,
        );
      }
    }
  }

  Future<void> _clearPlaybackProgress() async {
    if (currentEpisode != null) {
      final userDataService =
          Provider.of<UserDataService>(context, listen: false);
      await userDataService.clearEpisodeProgress(
        widget.tvSeriesId,
        currentEpisode!.seasonNumber,
        currentEpisode!.episodeNumber,
      );
    }
  }

  Future<bool?> _showResumeDialog(Duration savedPosition) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resume Playback?'),
        content: Text(
            'You previously stopped watching at ${formatDuration(savedPosition)}. Would you like to resume?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Start over
            child: const Text('START OVER'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Resume
            child: const Text('RESUME'),
          ),
        ],
      ),
    );
  }

  void _showSubtitleControls() {
    setState(() {
      showSubtitleControls = true;
    });

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showSubtitleControls = false;
        });
      }
    });
  }

  void playNext() {
    if (currentIndex < widget.playlist.length - 1) {
      playEpisode(currentIndex + 1);
    } else {
      debugPrint("Playlist finished.");
      Navigator.of(context).pop();
    }
  }

  void nimdispose() {
    _progressSaveTimer?.cancel();
    _savePlaybackProgress(); // Save one last time on exit
    player.dispose();
    super.dispose();
  }

  @override
  void dispose() {
    _progressSaveTimer?.cancel();
        Provider.of<FloatingButtonVisibilityNotifier>(context, listen: false).show();

    _savePlaybackProgress(); // Save one last time on exit
    player.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: _buildPlaylistDrawer(context),
        endDrawerEnableOpenDragGesture: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('${widget.seriesname}'
              '${currentEpisode?.episodeIdentifier ?? 'Loading...'}'),
          actions: [
            // Playlist button to open the drawer
          ],
        ),
        // The endDrawer will contain our playlist
        body: _buildPlayerWithControls());
  }

  // A new widget for the playlist drawer
  Widget _buildPlaylistDrawer(context) {
    return Drawer(
        backgroundColor: Colors.black.withOpacity(0.85),
        child: _buildSeasonsList(context, [widget.season], widget.tvSeriesId));
  }

  //       ListView.builder(
  //           itemCount: widget.playlist.length,
  //           itemBuilder: (context, index) {
  //             final episode = widget.playlist[index];

  //             final availableQualities = episode.getAvailableQualityUrls();

  //             final bool isPlaying = index == currentIndex;
  //             final userDataService = Provider.of<UserDataService>(context);
  //             final bool isWatched = userDataService.isWatchedEpisode(
  //                 widget.seriesname, widget.tvSeriesId, episode, widget.season);

  //             return ListTile(
  //               tileColor: isPlaying ? Colors.blue.withOpacity(0.3) : null,
  //               leading: Row(
  //                 children: [
  //                   // Episode Number/Identifier
  //                   Expanded(
  //                     flex: 3, // Give reasonable space to title/identifier
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Episode ${episode.episodeNumber}', // Use the generated display title
  //                           style: const TextStyle(
  //                               color: AppColors.primaryText,
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w500),
  //                           maxLines: 2, // Allow wrapping
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                         // Optionally show the SxxExx identifier below if different
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),

  //                   // Quality Buttons
  //                   if (availableQualities.isNotEmpty)
  //                     Expanded(
  //                       flex: 4, // Give slightly more space for buttons maybe
  //                       child: Wrap(
  //                         alignment:
  //                             WrapAlignment.end, // Align buttons to the right
  //                         spacing: 6.0, // Horizontal space between buttons
  //                         runSpacing: 4.0, // Vertical space if wraps
  //                         children:
  //                             availableQualities.entries.map<Widget>((entry) {
  //                           final quality = entry.key;
  //                           final url = entry.value;
  //                           return ElevatedButton(
  //                             onPressed: () {
  //                               // Close the drawer
  //                               Navigator.of(context).pop();
  //                               // Play the selected episode
  //                               playEpisode(index);
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor:
  //                                   AppColors.accentColor.withOpacity(0.7),
  //                               foregroundColor: AppColors.primaryText,
  //                               padding: const EdgeInsets.symmetric(
  //                                   horizontal: 10, vertical: 5),
  //                               minimumSize: const Size(45, 28),
  //                               textStyle: const TextStyle(
  //                                   fontSize: 11, fontWeight: FontWeight.bold),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(6),
  //                               ),
  //                               elevation: 1,
  //                             ),
  //                             child: Text(
  //                               isWatched
  //                                   ? "${quality.toUpperCase()} (Watched)"
  //                                   : quality.toUpperCase(),
  //                             ),
  //                           );
  //                         }).toList(),
  //                       ),
  //                     )
  //                   else
  //                     // Show something if no qualities are found for this episode
  //                     const Text(
  //                       'No links',
  //                       style: TextStyle(
  //                           color: AppColors.secondaryText,
  //                           fontSize: 12,
  //                           fontStyle: FontStyle.italic),
  //                     ),
  //                 ],
  //               ),
  //             );
  //           }));
  // }

  void toggleEpisodeList() {
    setState(() {
      showEpisodeList = !showEpisodeList;
    });
  }

  void togglePlayPause() {
    player.playOrPause();
  }

  void playNextEpisode() {
    playEpisode(currentIndex + 1);
  }

  void playPreviousEpisode() {
    playEpisode(currentIndex - 1);
  }

  void seekForward() {
    final position = player.state.position;
    final duration = player.state.duration;
    final newPosition = position + const Duration(seconds: 10);
    if (newPosition < duration) {
      player.seek(newPosition);
    }
  }

  void seekBackward() {
    final position = player.state.position;
    final newPosition = position - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      player.seek(newPosition);
    } else {
      player.seek(Duration.zero);
    }
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      player.setVolume(isMuted ? 0 : 100);
    });
  }

  // String formatDuration(Duration duration) {
  //   final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  //   final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  //   return "$minutes:$seconds";
  // }
  Widget _buildSeasonsList(
      BuildContext context, List<ss.Season> seasons, int TvseriesId) {
    bool defaultExpansion = seasons.length == 1;
    return SizedBox(
        height: 500, // Adjust as needed
        child: ListView.builder(
          controller: _seasonsScrollController,
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: seasons.length,
          itemBuilder: (context, index) {
            final season = seasons[index];

            // ...existing ExpansionTile code...
            // Use ExpansionTile for collapsable seasons
            return Card(
              // Wrap ExpansionTile in a Card for better visual separation
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              color: AppColors.secondaryBackground
                  .withOpacity(0.4), // Slightly transparent background
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              clipBehavior:
                  Clip.antiAlias, // Ensures content respects border radius
              child: ExpansionTile(
                key: PageStorageKey(
                    'season_${season.seasonNumber}'), // Maintain expansion state
                title: Text(
                  'Season ${season.seasonNumber}',
                  style: const TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                subtitle: Text(
                  '${season.episodes.length} Episode${season.episodes.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                      color: AppColors.secondaryText, fontSize: 12),
                ),
                iconColor:
                    AppColors.accentColor, // Use accent color for expand icon
                collapsedIconColor: AppColors.secondaryText,
                // Expand first season or if only one season exists
                initiallyExpanded: defaultExpansion ||
                    season.seasonNumber ==
                        1, // Keep first season expanded usually
                childrenPadding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 4,
                    right: 4), // Padding for episode tiles
                // Remove default dividers and use padding/margin on EpisodeTile instead
                // children: season.episodes.map((episode) => EpisodeTile(episode: episode)).toList(),

                children: ListTile.divideTiles(
                  // Add subtle dividers between episodes
                  context: context,
                  color: AppColors.dividerColor.withOpacity(0.3),
                  tiles: season.episodes
                      .map((episode) => epistile(
                            context,
                            seriesname: widget.seriesname,
                            episode: episode,
                            season: season,
                            id: TvseriesId,
                          ))
                      .toList(),
                ).toList(),
              ),
            );
          },
        ));
  }

  Widget _buildPlayerWithControls() {
    return Stack(
      children: [
        Video(
          controller: controller,
          controls: AdaptiveVideoControls,
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
          wakelock: true,
          subtitleViewConfiguration: SubtitleViewConfiguration(
            visible: true,
            style: TextStyle(
              height: 1.4,
              fontSize: subtitleSize,
              letterSpacing: 0.0,
              wordSpacing: 0.0,
              color: subtitleColor,
              fontWeight: FontWeight.w700,
              backgroundColor: const Color(0xaa000000),
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showSubtitleControls)
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.text_fields,
                            color: Colors.white, size: 20),
                        Expanded(
                          child: Slider(
                            value: subtitleSize,
                            min: 16.0,
                            max: 48.0,
                            onChanged: (value) {
                              setState(() {
                                subtitleSize = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                // IconButton(
                //   icon: const Icon(Icons.picture_in_picture_outlined,
                //       color: Colors.white),
                //   onPressed: () {
                //     setState(() {
                //       isPiPEnabled = !isPiPEnabled;
                //     });
                //   },
                // ),
                IconButton(
                  icon: const Icon(Icons.closed_caption,
                      color: Color.fromARGB(255, 178, 246, 255)),
                  onPressed: _showSubtitleControls,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    nimdispose;
                    playEpisode(currentIndex);
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.timer, color: Colors.white),
                //   onPressed: () {
                //     // Timer functionality
                //   },
                // ),
                IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Color.fromARGB(255, 250, 109, 109), size: 28),
                    onPressed: () {
                      nimdispose;
                      playEpisode(currentIndex--);
                    }),
                IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Color.fromARGB(255, 97, 166, 251), size: 28),
                    onPressed: () async {
                      nimdispose();
                      playEpisode(currentIndex++);
                    }),
                // IconButton(
                //   icon: const Icon(Icons.closed_caption,
                //       color: Color.fromARGB(255, 234, 237, 148)),
                //   onPressed: () {
                //     // Subtitle functionality
                //   },
                // ),
                // IconButton(
                //   icon: const Icon(Icons.mic, color: Colors.white),
                //   onPressed: () {
                //     // Audio track functionality
                //   },
                // ),
                // IconButton(
                //   icon: const Icon(Icons.playlist_play, color: Colors.white),
                //   onPressed: toggleEpisodeList,
                // ),
                // IconButton(
                //   icon: Icon(Icons.screenshot, color: Colors.white),
                //   onPressed: () async {
                //     final screenshot = await player.screenshot();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget epistile(
    BuildContext context, {
    required String seriesname,
    required ss.Episode episode,
    required ss.Season season,
    required int id,
  }) {
    final availableQualities = episode.getAvailableQualityUrls();
    final userDataService =
        Provider.of<UserDataService>(context, listen: false);

    void playEpisodes(BuildContext context, url) async {
      // Find the index of the current episode within its season's list
      final int initialIndex = season.episodes.indexOf(episode);
      nimdispose;
      playEpisode(initialIndex);
      // Navigate to the player with the full context
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => VideoPlayerScreen(
      //       seriesname: seriesname,
      //       tvSeriesId: id,
      //       season: season,
      //       playlist: season
      //           .episodes, // Pass the whole list of episodes for the season
      //       initialIndex: initialIndex,
      //       url: url,
      //     ),
      //   ),
      //  );
    }

    // Create a display title: "E01: Episode Name" or just "Episode 1" if no name
    // Since we removed tmdbTitle, we'll rely on season/episode numbers.
    final displayTitle = 'Episode ${episode.episodeNumber}'; // Simple display
    // Or use the identifier: final displayTitle = episode.episodeIdentifier;
    bool isInWatchlist =
        userDataService.isWatchedEpisode(seriesname, id, episode, season);
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
              flex: 4,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 6.0,
                runSpacing: 4.0,
                children: availableQualities.entries.map<Widget>((entry) {
                  final quality = entry.key;
                  final url = entry.value;
                  return ElevatedButton(
                    onPressed: () => playEpisodes(context, url),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor.withOpacity(0.7),
                      foregroundColor: AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      minimumSize: const Size(45, 28),
                      textStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 1,
                    ),
                    child: Text(
                      isInWatchlist
                          ? "${quality.toUpperCase()} (Watched)"
                          : quality.toUpperCase(),
                    ),
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
  // void _showQualitySelectionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final availableQualities = [
  //         'Auto',
  //         '1080p',
  //         '720p',
  //         '540p',
  //         '480p',
  //         'DUBBED'
  //       ];
  //       return AlertDialog(
  //         title: const Text('Select Quality'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: availableQualities.map((quality) {
  //             return ListTile(
  //               title: Text(quality),
  //               trailing: _selectedQuality == quality
  //                   ? const Icon(Icons.check, color: Colors.blue)
  //                   : null,
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //                 _changeQuality(quality);
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<String?> saveScreenshot(Uint8List? screenshot) async {
  //   if (screenshot == null) return null;
  //   try {
  //     1. Check and request storage permission
  //     final status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       debugPrint('Storage permission denied');
  //       return null;
  //     }

  //     2. Get the base directory for saving
  //     final Directory? baseDir = await getExternalStorageDirectory();
  //     if (baseDir == null) {
  //       debugPrint('Unable to get storage directory');
  //       return null;
  //     }

  //     3. Create the save directory if it doesn't exist
  //     final Directory saveDir = Directory('${baseDir.path}/Screenshots');
  //     if (!saveDir.existsSync()) {
  //       await saveDir.create(recursive: true);
  //     }

  //     4. Generate filename with timestamp
  //     final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     final String filePath =
  //         '${saveDir.path}/${widget.seriesname}.S${widget.season.seasonNumber}.E${widget.initialIndex}.$timestamp.png';

  //     5. Write the file
  //     final File file = File(filePath);
  //     await file.writeAsBytes(screenshot);

  //     6. Save to gallery
  //     final result = await ImageGallerySaver.saveFile(
  //       filePath,
  //       name:
  //           '${widget.seriesname}.S${widget.season.seasonNumber}.E${widget.initialIndex}',
  //     );

  //     if (result['isSuccess'] == true) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Screenshot saved to gallery'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //       return filePath;
  //     } else {
  //       debugPrint('Error saving to gallery: ${result['error']}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Failed to save screenshot to gallery'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error saving screenshot: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error saving screenshot: $e'),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //     return null;
  //   }
  // }

