import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';

final userdata = UserDataService().decoderPreference;

class VideoPlayerScreen extends StatefulWidget {
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
  late final VideoController controller = VideoController(player);
  bool showControls = true;
  bool showEpisodeList = false;
  bool isFullScreen = false;
  bool isMuted = false;
  bool isPiPEnabled = false;
  Timer? _progressSaveTimer; // Timer to periodically save progress
  final ScrollController _seasonsScrollController = ScrollController();
String urlToPlayQuality = '';
  double subtitleSize = 32.0;
  Color subtitleColor = const Color.fromARGB(255, 238, 230, 5);
  bool showSubtitleControls = false;
  late int currentIndex;
  ss.Episode? get currentEpisode =>
      widget.playlist.isNotEmpty ? widget.playlist[currentIndex] : null;
StreamSubscription? _completedSubscription;
  StreamSubscription? _errorSubscription;

  Timer? _hideTimer;
  String currentQuality = 'Auto';
  bool streamHasError = false;
  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  // --- 1. BoxFit Feature: State variables ---
  final List<BoxFit> _fitOptions = [
    BoxFit.contain, // Standard
    BoxFit.cover, // Fill/Crop
    BoxFit.fill, // Stretch
    BoxFit.fitWidth,
    BoxFit.fitHeight,
  ];
  int _currentFitIndex = 0;
  BoxFit get _currentFit => _fitOptions[_currentFitIndex];
  // Map to hold icons for each fit mode for better UX
  final Map<BoxFit, IconData> _fitIcons = {
    BoxFit.contain: Icons.fullscreen_exit,
    BoxFit.cover: Icons.fullscreen,
    BoxFit.fill: Icons.photo_size_select_large,
    BoxFit.fitWidth: Icons.swap_horiz,
    BoxFit.fitHeight: Icons.swap_vert,
  };

  ////TODO use this to create button for change sub r dub  if (widget.url == episodeToPlay.url480p && episodeToPlay.dubbedUrl!=null) currentchoice['480p'] = episodeToPlay.url480p;

    final List<String> choicelist = [
    'Auto',
    '1080p',
    '720p',
    '540',
    '480p',
    'DUBBED'
  ];

  Map<String, String?> getAvailableQualityUrls() {
    final episodeToPlay = widget.playlist[currentIndex];
  
    final Map<String, String?> currentchoice = {};
    if (widget.url == episodeToPlay.url1080p&& episodeToPlay.url1080p!=null) currentchoice['1080p']=episodeToPlay.url1080p;
    if (widget.url == episodeToPlay.url720p&& episodeToPlay.url720p!=null) currentchoice['720p'] =episodeToPlay.url720p ;
    if (widget.url == episodeToPlay.url540p&& episodeToPlay.url540p!=null) currentchoice['540p']= episodeToPlay.url540p;
    if (widget.url == episodeToPlay.url480p && episodeToPlay.url480p!=null) currentchoice['480p'] = episodeToPlay.url480p;
  //   final Map<String,String?> qualityOptions = {
  //  // 'Auto': episodeToPlay.getAvailableQualityUrls()
  //   '1080p':episodeToPlay.url1080p,
  //   '720p':episodeToPlay.url720p,
  //   '540':episodeToPlay.url540p,
  //   '480p':episodeToPlay.url480p,
  //   'DUBBED':episodeToPlay.dubbedUrl,
  // };
 return currentchoice;
  }
  Future<String> _showQualitySelectionDialog() async {
    // Get the available quality URLs
  final Map<String, String?> qualityOptions = getAvailableQualityUrls();
  final selectedQuality = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Quality'),
        content: SingleChildScrollView(
          child: ListBody(
            children: qualityOptions.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                onTap: () {
   _changeQuality( entry.key);
                     Navigator.of(context).pop(entry.key);


                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
  if (selectedQuality != null && qualityOptions.containsKey(selectedQuality)) {
    urlToPlayQuality = qualityOptions[selectedQuality]!;
    currentQuality = selectedQuality;
    return _cycleQuality(currentQuality);
  } else {
    return 'Invalid selection';
  }
}

String _cycleQuality(String currentQuality) {
  final List<String> qualityList = ['Auto', '1080p', '720p', '540p', '480p', 'DUBBED'];
  int currentIndex = qualityList.indexOf(currentQuality);
  currentIndex = (currentIndex + 1) % qualityList.length;
  return qualityList[currentIndex];
  }

  void _changeQuality(String newQuality) {
    setState(() {
      currentQuality = newQuality;
    });
    playEpisodeByUrl(currentQuality,currentIndex);
  }

  late final UserDataService _userDataService;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    _userDataService = Provider.of<UserDataService>(context, listen: false);

        _completedSubscription = player.stream.completed.listen((completed) {
      debugPrint('VideoPlayerScreenState: Player completed stream event: $completed');
      if (completed) {
        _clearPlaybackProgress(); // Clear progress for the episode that just finished
        debugPrint('VideoPlayerScreenState: Video completed. Playing next.');
        playNext();
      }
    });

    _errorSubscription = player.stream.error.listen((error) {
      setState(() {
        streamHasError = true;
      });
      _showTryOtherUrlDialog(error);
      debugPrint("Player Error: $error");
    });

    // --- REFACTORED: Start the periodic progress saver ---
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      // The check to save is now inside the method itself
      _savePlaybackProgress();
    });
    debugPrint('VideoPlayerScreenState: _progressSaveTimer started.');
    
    // --- REFACTORED: Initial episode load ---
    // Use the new, centralized method to load the first episode.
    // We use a post-frame callback to ensure context is available for dialogs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndPlayEpisode(widget.initialIndex, isInitialPlay: true);
    });
  }
   Future<void> _loadAndPlayEpisode(int index, {bool isInitialPlay = false, String? specificUrl}) async {
    // 1. Validate index
    if (index < 0 || index >= widget.playlist.length) {
      debugPrint("Invalid episode index: $index. Not playing.");
      // Optionally, pop the screen or show a "series finished" message
      if (!isInitialPlay) Navigator.of(context).pop();
      return;
    }

    // 2. Update state
    setState(() {
      currentIndex = index;
      streamHasError = false; // Reset error state for new episode
    });

    final episodeToPlay = widget.playlist[currentIndex];
    
    // 3. Determine URL to play
    // Use the specificUrl if provided (for quality changes), otherwise get the default.
    String urlToPlay;
    if (specificUrl != null) {
      urlToPlay = specificUrl;
    } else {
      final availableUrls = episodeToPlay.getAvailableQualityUrls();
      if (availableUrls.isEmpty) {
        debugPrint('No URLs found for this episode. Cannot play.');
        _showTryOtherUrlDialog("No playable URL found for this episode.");
        return;
      }
      urlToPlay = availableUrls.values.first;
    }

    // 4. Open the media in the player
    debugPrint("Opening media: $urlToPlay");
    await player.open(Media(Uri.decodeComponent(urlToPlay)), play: false);

    // 5. Mark as watched
    _userDataService.toggleIsWatchedLink(
        widget.seriesname,
        widget.tvSeriesId,
        currentIndex + 1,
        widget.season.seasonNumber,
    );

    // 6. Handle resume logic
    final savedPosition = await _userDataService.getEpisodeProgress(
      widget.tvSeriesId,
      widget.season.seasonNumber,
      currentIndex + 1,
    );

    if (!isInitialPlay) {
      // If it's not the first video (i.e., we auto-played next), just start from the beginning.
      await player.play();
    } else if (savedPosition != null && savedPosition.inSeconds > 10) {
      final bool? shouldResume = await _showResumeDialog(savedPosition);
      if (shouldResume == true) {
        await player.seek(savedPosition);
      } else {
        await _clearPlaybackProgress();
      }
      await player.play();
    } else {
      // Default case: play from the beginning
      await player.play();
    }
  }

  void firstDial() async {
    bool isBeforeWatched = _userDataService.isWatchedEpisode(
      widget.seriesname,
      widget.tvSeriesId,
      currentIndex + 1,
      widget.season.seasonNumber,
    );

    if (!isBeforeWatched) {
      _userDataService.toggleIsWatchedLink(
        widget.seriesname,
        widget.tvSeriesId,
        currentIndex + 1,
        widget.season.seasonNumber,
      );
    } else if (isBeforeWatched) {
      final savedPosition = await _userDataService.getEpisodeProgress(
        widget.tvSeriesId,
        widget.season.seasonNumber,
        currentIndex + 1,
      );


      if (savedPosition != null && savedPosition.inSeconds > 10) {
        final bool? shouldResume = await _showResumeDialog(savedPosition);

        if (shouldResume == true) {
          player.seek(Duration(seconds: savedPosition.inSeconds));
    await player.play();
    debugPrint('VideoPlayerScreenState: player.play() called.');

        } else {
          await _clearPlaybackProgress();
          await player.play();
    debugPrint('VideoPlayerScreenState: player.play() called.');
        }
      } 
                  await player.play();

    player.stream.error.listen((error){

      setState(() {
        streamHasError = true;
_showTryOtherUrlDialog(error);
      });
      ////TODO ADD Error Handler
    });
if (!streamHasError){
_progressSaveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      debugPrint('VideoPlayerScreenState: _progressSaveTimer tick. Saving playback progress.');
      _savePlaybackProgress();
    });
    debugPrint('VideoPlayerScreenState: _progressSaveTimer started.');
}
                  await player.play();

    player.stream.completed.listen((completed) {
      debugPrint('VideoPlayerScreenState: Player completed stream event: $completed');
      if (completed) {
        _clearPlaybackProgress();
        debugPrint('VideoPlayerScreenState: Video completed. Clearing progress and playing next.');
        playNext();
      }
    });

  }
                  await player.play();

  }


Future<bool?> _showTryOtherUrlDialog( error) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (context) => AlertDialog(
        title: const Text('do you want app try load another url?'),
        content: Text(
            'App recogonized this error $error. Would you like to try playing other url?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
 void playNext() {
    _loadAndPlayEpisode(currentIndex + 1);
  }

  void playPrevious() {
    _loadAndPlayEpisode(currentIndex - 1);
  }

  // --- REFACTORED to use the new method ---
  void playEpisode(int index) {
     _loadAndPlayEpisode(index, isInitialPlay: true); // isInitialPlay to trigger resume dialog
  }

  // Example of how you'd change quality
  void changeQuality(String newQualityUrl) {
    // First, save progress at the current position
    _savePlaybackProgress(); 
    // Then reload the same episode with the new URL
    _loadAndPlayEpisode(currentIndex, isInitialPlay: true, specificUrl: newQualityUrl);
  }
  
  @override
  void dispose() {
    debugPrint("VideoPlayerScreen disposing. Saving final progress.");
    // Cancel the timer and subscriptions to prevent memory leaks
    _progressSaveTimer?.cancel();
    _completedSubscription?.cancel();
    _errorSubscription?.cancel();
    
    // It's good practice to save progress one last time before disposing.
    // Use a synchronous call or a short delay if needed, but `nimdispose` handles it.
    nimdispose(); // Your existing method is fine
    super.dispose();
  }

  // Your nimdispose, _savePlaybackProgress, and other UI methods remain the same.
  // ... (keep the rest of your methods like _showResumeDialog, _savePlaybackProgress, etc.)
  
  // No changes needed below this line, but ensure your `playEpisode` call from the list UI is correct.
  // ...
  
  void playEpisodeByUrl(String url, int index, {bool isInitialPlay = false}) {
     // This method can now be simplified or removed in favor of `changeQuality` logic
     _loadAndPlayEpisode(index, isInitialPlay: true, specificUrl: url);
  }

  // ... rest of your code ...
  void nimdispose() async {
    // This is a good place to save progress one last time.
    await _savePlaybackProgress();
    // Now dispose the player.
    await player.dispose(); // Use await for async dispose operations
  }

  Future<void> _savePlaybackProgress() async {
    // --- 2. FIX: Removed `player.state.playing` check ---
    // This ensures progress is saved even if the video is paused.
    // We only need to check that a video is loaded and has a duration.
      if (player.state.duration.inSeconds > 10) {
      debugPrint('VideoPlayerScreenState: _savePlaybackProgress - Video duration is valid (${player.state.duration.inSeconds}s).');
       final position = player.state.position; // Original commented line
      final duration = player.state.duration;
      debugPrint('VideoPlayerScreenState: _savePlaybackProgress - Current position: ${player.state.position}, Total duration: $duration');

      // Save if not too close to the beginning or end
      // if (position.inSeconds > 10 && (duration - position).inSeconds > 15) { // Original commented line
      await _userDataService.saveEpisodeProgress(
        widget.tvSeriesId,
        currentEpisode!.seasonNumber,
        currentIndex + 1,
        position, // Saving current position
      );}
  }

  Future<void> _clearPlaybackProgress() async {
    await _userDataService.clearEpisodeProgress(
        widget.tvSeriesId,
        currentEpisode!.seasonNumber,
currentEpisode!.episodeNumber      );
  }

//   void playNext() {
//    setState(() {
//           currentIndex = currentIndex + 1;
//           debugPrint('VideoPlayerScreenState: playNext - currentIndex incremented to: $currentIndex');
//         });
//         playEpisode(currentIndex);
//   }

//   void playPrevious() {
// setState(() {
//         currentIndex = currentIndex - 1;
//         debugPrint('VideoPlayerScreenState: playPrevious - currentIndex decremented to: $currentIndex');
//       });
//       playEpisode(currentIndex);    
//   }

  // Helper for resume dialog
  Future<bool?> _showResumeDialog(Duration savedPosition) {
    debugPrint('VideoPlayerScreenState: _showResumeDialog called with savedPosition: $savedPosition');
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (context) => AlertDialog(
        title: const Text('Resume Playback?'),
        content: Text(
            'You previously stopped watching at ${formatDuration(savedPosition)}. Would you like to resume?'),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint('VideoPlayerScreenState: Resume Dialog - START OVER selected.');
              Navigator.of(context).pop(false); // Return false
            },
            child: const Text('START OVER'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('VideoPlayerScreenState: Resume Dialog - RESUME selected.');
              Navigator.of(context).pop(true); // Return true
            },
            child: const Text('RESUME'),
          ),
        ],
      ),
    );
  }


  // Helper to format duration strings

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

  // void nimdispose() async {
  //   _progressSaveTimer?.cancel();
  //  await _savePlaybackProgress();
  //    player.dispose();
  // }

  // @override
  // void dispose()  {
  //   nimdispose();
  //   super.dispose();
  // }

  // --- 1. BoxFit Feature: Function to cycle modes ---
  void _cycleBoxFit() {
    setState(() {
      _currentFitIndex = (_currentFitIndex + 1) % _fitOptions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('VideoPlayerScreenState: build method called.');
    return Scaffold(
      endDrawer: _buildPlaylistDrawer(context),
      endDrawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${widget.seriesname}'
            '${currentEpisode?.episodeIdentifier ?? 'Loading...'}'),
      ),
      body: _buildPlayerWithControls(),
    );
  }

  // A new widget for the playlist drawer
  Widget _buildPlaylistDrawer(context) {
    debugPrint('VideoPlayerScreenState: _buildPlaylistDrawer called.');
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.85),
      child: _buildSeasonsList(context, [widget.season], widget.tvSeriesId),
    );
  }

  void toggleEpisodeList() {
    debugPrint('VideoPlayerScreenState: toggleEpisodeList called.');
    setState(() {
      showEpisodeList = !showEpisodeList;
      debugPrint('VideoPlayerScreenState: toggleEpisodeList - showEpisodeList set to: $showEpisodeList');
    });
  }

  void togglePlayPause() async {
    debugPrint('VideoPlayerScreenState: togglePlayPause called.');
    await player.playOrPause();
    debugPrint('VideoPlayerScreenState: togglePlayPause - Player play/pause toggled.');
  }

  void playNextEpisode() async {
    debugPrint('VideoPlayerScreenState: playNextEpisode called (similar to playNext).');
    setState(() {
      currentIndex = currentIndex + 1; // Direct update, consider safety check
      debugPrint('VideoPlayerScreenState: playNextEpisode - currentIndex incremented to: $currentIndex');
    });
    playEpisode(currentIndex);
    debugPrint('VideoPlayerScreenState: playNextEpisode - Calling playEpisode.');
  }

  void playPreviousEpisode() async {
    debugPrint('VideoPlayerScreenState: playPreviousEpisode called (similar to playPrevious).');
    setState(() {
      currentIndex = currentIndex - 1; // Direct update, consider safety check
      debugPrint('VideoPlayerScreenState: playPreviousEpisode - currentIndex decremented to: $currentIndex');
    });
    playEpisode(currentIndex);
    debugPrint('VideoPlayerScreenState: playPreviousEpisode - Calling playEpisode.');
  }

  void seekForward() {
    debugPrint('VideoPlayerScreenState: seekForward called.');
    final position = player.state.position;
    final duration = player.state.duration;
    final newPosition = position + const Duration(seconds: 10);
    debugPrint('VideoPlayerScreenState: seekForward - Current position: $position, New position attempt: $newPosition, Total duration: $duration');
    if (newPosition < duration) {
      player.seek(newPosition);
      debugPrint('VideoPlayerScreenState: seekForward - Player seeked to $newPosition.');
    } else {
      player.seek(duration);
      debugPrint('VideoPlayerScreenState: seekForward - Player seeked to end of duration ($duration).');
    }
  }

  void seekBackward() {
    debugPrint('VideoPlayerScreenState: seekBackward called.');
    final position = player.state.position;
    final newPosition = position - const Duration(seconds: 10);
    debugPrint('VideoPlayerScreenState: seekBackward - Current position: $position, New position attempt: $newPosition');
    if (newPosition > Duration.zero) {
      player.seek(newPosition);
      debugPrint('VideoPlayerScreenState: seekBackward - Player seeked to $newPosition.');
    } else {
      player.seek(Duration.zero);
      debugPrint('VideoPlayerScreenState: seekBackward - Player seeked to start (Duration.zero).');
    }
  }

  void toggleMute() {
    debugPrint('VideoPlayerScreenState: toggleMute called.');
    setState(() {
      isMuted = !isMuted;
      player.setVolume(isMuted ? 0 : 100);
      debugPrint('VideoPlayerScreenState: toggleMute - isMuted set to: $isMuted, volume set to: ${isMuted ? 0 : 100}');
    });
  }

  Widget _buildSeasonsList(
    // ignore: non_constant_identifier_names
    BuildContext context,
    List<ss.Season> seasons,
    int tvseriesId,
  ) {
    debugPrint('VideoPlayerScreenState: _buildSeasonsList called.');
    bool defaultExpansion = seasons.length == 1;
    debugPrint('VideoPlayerScreenState: _buildSeasonsList - defaultExpansion: $defaultExpansion');
    return SizedBox(
      height: 500,
      child: ListView.builder(
        controller: _seasonsScrollController,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];
          debugPrint('VideoPlayerScreenState: _buildSeasonsList - Building for Season: ${season.seasonNumber}');

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            color: AppColors.secondaryBackground.withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              key: PageStorageKey('season_${season.seasonNumber}'),
              title: Text(
                'Season ${season.seasonNumber}',
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${season.episodes.length} Episode${season.episodes.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: AppColors.secondaryText, fontSize: 12),
              ),
              iconColor: AppColors.accentColor,
              collapsedIconColor: AppColors.secondaryText,
              initiallyExpanded: defaultExpansion || season.seasonNumber == 1,
              childrenPadding:
                  const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
              children: ListTile.divideTiles(
                context: context,
                color: AppColors.dividerColor.withOpacity(0.3),
                tiles: season.episodes
                    .map(
                      (episode) => epistile(
                        context,
                        seriesname: widget.seriesname,
                        episode: episode,
                        season: season,
                        id: tvseriesId,
                      ),
                    )
                    .toList(),
              ).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerWithControls() {
    debugPrint('VideoPlayerScreenState: _buildPlayerWithControls called.');
    return Stack(
      children: [
        Video(
          controller: controller,
          controls: AdaptiveVideoControls,
          fit: _currentFit,
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
              fontWeight: FontWeight.w600,
              backgroundColor: const Color(0xaa000000),
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
          ),
        ),
        Positioned(
          top: 14,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: _showQualitySelectionDialog, icon: Icon(Icons.hd_rounded)),
                IconButton(
                  icon: Icon(_fitIcons[_currentFit] ?? Icons.aspect_ratio,
                      color: Colors.white),
                  tooltip: 'Change display mode',
                  onPressed: _cycleBoxFit,
                ),
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
                                debugPrint('VideoPlayerScreenState: Subtitle size slider changed to: $subtitleSize');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.closed_caption,
                      color: Color.fromARGB(255, 178, 246, 255)),
                  onPressed: _showSubtitleControls,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () async {
                    debugPrint('VideoPlayerScreenState: Refresh button pressed. Calling playEpisode($currentIndex).');
                    playEpisode(currentIndex);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      color: Color.fromARGB(255, 250, 109, 109), size: 28),
                  onPressed: () async {
                    debugPrint('VideoPlayerScreenState: Skip previous button pressed. Attempting to play episode: ${currentIndex - 1}');
                    playEpisode(currentIndex - 1); // Consider bounds check
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next,
                      color: Color.fromARGB(255, 97, 166, 251), size: 28),
                  onPressed: () async {
                    debugPrint('VideoPlayerScreenState: Skip next button pressed. Attempting to play episode: ${currentIndex + 1}');
                    playEpisode(currentIndex + 1); // Consider bounds check
                  },
                ),
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
    debugPrint('VideoPlayerScreenState: epistile called for episode: ${episode.episodeIdentifier}, season: ${season.seasonNumber}');
    final availableQualities = episode.getAvailableQualityUrls();
    debugPrint('VideoPlayerScreenState: epistile - Available qualities for episode: $availableQualities');
    final userDataService = Provider.of<UserDataService>(context, listen: false);

    void playEpisodes(BuildContext context, String url) async {
      debugPrint('VideoPlayerScreenState: playEpisodes (from epistile) called with URL: $url');
      final int initialIndex = season.episodes.indexOf(episode);
      debugPrint('VideoPlayerScreenState: playEpisodes - Initial index within season: $initialIndex');
      playEpisodeByUrl(url, initialIndex);
    }

    // final displayTitle = 'Episode ${episode.episodeNumber}'; // Original commented line
    bool isInWatchlist = userDataService.isWatchedEpisode(
        widget.seriesname, widget.tvSeriesId, episode.episodeNumber, season.seasonNumber);
    debugPrint('VideoPlayerScreenState: epistile - Is episode in watchlist ($seriesname, ${episode.episodeNumber}, ${season.seasonNumber}): $isInWatchlist');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(children: [
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
              if (episode.episodeIdentifier != 'Episode ${episode.episodeNumber}')
                Text(
                  episode.episodeIdentifier,
                  style: const TextStyle(
                      color: AppColors.secondaryText, fontSize: 11),
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
              alignment: WrapAlignment.end,
              spacing: 6.0,
              runSpacing: 4.0,
              children: availableQualities.entries.map<Widget>((entry) {
                // final quality = entry.key; // Original commented line
                final url = entry.value;
                debugPrint('VideoPlayerScreenState: epistile - Building button for quality: ${entry.key}, URL: $url');
                return ElevatedButton(
                  onPressed: () {
                    // final int episodeIndex = widget.playlist.indexOf(episode); // Original commented line
                    debugPrint('VideoPlayerScreenState: Quality button pressed for ${entry.key}. Calling playEpisodes.');
                    playEpisodes(context, url);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor.withOpacity(0.7),
                    foregroundColor: AppColors.primaryText,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    minimumSize: const Size(45, 28),
                    textStyle: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    elevation: 1,
                  ),
                  // --- REMOVED: The "(Watched)" text logic ---
                  child: Text(entry.key.toUpperCase()),
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
      ]),
    );
  }
}