import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/models/tv_series_anime.dart' as ss;
import 'package:miko/services/user_data_service.dart';
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

  double subtitleSize = 32.0;
  Color subtitleColor = const Color.fromARGB(255, 238, 230, 5);
  bool showSubtitleControls = false;
  late int currentIndex;
  ss.Episode? get currentEpisode =>
      widget.playlist.isNotEmpty ? widget.playlist[currentIndex] : null;

  Timer? _hideTimer;
  String currentQuality = 'Auto';
 

  // --- 1. BoxFit Feature: State variables ---
  final List<BoxFit> _fitOptions = [
    BoxFit.contain, // Standard
    BoxFit.cover,   // Fill/Crop
    BoxFit.fill,    // Stretch
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
  final List<String> qualityOptions = [
    'Auto',
    '1080p',
    '720p',
    '540',
    '480p',
    'DUBBED'
  ];
  late final UserDataService _userDataService;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    _userDataService = Provider.of<UserDataService>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {});

    player.open(Media(Uri.decodeComponent(widget.url)),
        play: true); 


        _progressSaveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _savePlaybackProgress();
    });

    player.stream.completed.listen((completed) {
      if (completed) {
        _clearPlaybackProgress(); 
        playNext();
      }
    });


    player.stream.error.listen((error) => debugPrint('Player Error: $error'));
  }
void cleanUpPlayer() async{
  _progressSaveTimer?.cancel();
  _savePlaybackProgress();
 await player.dispose();
}

  void playEpisode(int index, {bool isInitialPlay = false}) async {
    if (index < 0 || index >= widget.playlist.length) return;

    setState(() {
      currentIndex = index;
    });

    final episodeToPlay = widget.playlist[index];
    final userDataService =
        Provider.of<UserDataService>(context, listen: false);

    Duration? seekToPosition;
    if (isInitialPlay) {
      final savedPosition = await _userDataService.getEpisodeProgress(
        widget.tvSeriesId,
        episodeToPlay.seasonNumber,
        episodeToPlay.episodeNumber,
      );

      // Show resume dialog if saved progress is significant
      if (savedPosition != null && savedPosition.inSeconds > 10) {
        final resume = await _showResumeDialog(savedPosition);
        if (resume == true) {
          seekToPosition = savedPosition;
        }
      }
    }


    final urlToPlay = episodeToPlay.getAvailableQualityUrls();
    
    final up = urlToPlay.values.first;
    await player.open(
      Media(Uri.decodeComponent(up)),
      play: true,
    );
    if (seekToPosition != null) {
      await player.seek(seekToPosition);
    }
    userDataService.toggleIsWatchedLink(
        widget.seriesname, widget.tvSeriesId, episodeToPlay, widget.season);
  }


    Future<void> _savePlaybackProgress() async {
    // --- 2. FIX: Removed `player.state.playing` check ---
    // This ensures progress is saved even if the video is paused.
    // We only need to check that a video is loaded and has a duration.
    if (currentEpisode != null && player.state.duration > Duration.zero) {
      final position = player.state.position;
      final duration = player.state.duration;

      // Save if not too close to the beginning or end
      if (position.inSeconds > 10 && (duration - position).inSeconds > 15) {
        await _userDataService.saveEpisodeProgress(
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
      await _userDataService.clearEpisodeProgress(
        widget.tvSeriesId,
        currentEpisode!.seasonNumber,
        currentEpisode!.episodeNumber,
      );
    }
  }

  void playNext() {
    if (currentIndex < widget.playlist.length - 1) {
      playEpisode(currentIndex + 1);
    } else {
      debugPrint("Playlist finished.");
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
  
  void playPrevious() {
    if (currentIndex > 0) {
      playEpisode(currentIndex - 1);
    }
  }
  
  // Helper for resume dialog
  Future<bool?> _showResumeDialog(Duration savedPosition) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resume Playback?'),
        content: Text('You previously stopped watching at ${formatDuration(savedPosition)}. Would you like to resume?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('START OVER')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('RESUME')),
        ],
      ),
    );
  }

  // Helper to format duration strings
  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) return "$hours:$minutes:$seconds";
    return "$minutes:$seconds";
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

 

  void nimdispose() async{
    _progressSaveTimer?.cancel();
    _savePlaybackProgress();
   await player.dispose();
  }

  @override
  void dispose() async{
    _progressSaveTimer?.cancel();
  await  _savePlaybackProgress(); // Save one last time on exit
   await player.dispose();
    super.dispose();
  }

  // --- 1. BoxFit Feature: Function to cycle modes ---
  void _cycleBoxFit() {
    setState(() {
      _currentFitIndex = (_currentFitIndex + 1) % _fitOptions.length;
    });
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
        ),
        body: _buildPlayerWithControls());
  }

  // A new widget for the playlist drawer
  Widget _buildPlaylistDrawer(context) {
    return Drawer(
        backgroundColor: Colors.black.withOpacity(0.85),
        child: _buildSeasonsList(context, [widget.season], widget.tvSeriesId));
  }


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

  Widget _buildSeasonsList(
      BuildContext context, List<ss.Season> seasons, int TvseriesId) {
    bool defaultExpansion = seasons.length == 1;
    return SizedBox(
        height: 500, 
        child: ListView.builder(
          controller: _seasonsScrollController,
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: seasons.length,
          itemBuilder: (context, index) {
            final season = seasons[index];

            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              color: AppColors.secondaryBackground
                  .withOpacity(0.4), 
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              clipBehavior:
                  Clip.antiAlias, 
              child: ExpansionTile(
                key: PageStorageKey(
                    'season_${season.seasonNumber}'),
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
                    AppColors.accentColor, 
                collapsedIconColor: AppColors.secondaryText,
                initiallyExpanded: defaultExpansion ||
                    season.seasonNumber ==
                        1,
                childrenPadding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 4,
                    right: 4), 
                children: ListTile.divideTiles(
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
                 IconButton(
                  icon: Icon(_fitIcons[_currentFit] ?? Icons.aspect_ratio, color: Colors.white),
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
                  onPressed: () {
                    nimdispose();
                    playEpisode(currentIndex);
                  },
                ),
        
                IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Color.fromARGB(255, 250, 109, 109), size: 28),
                    onPressed: () {
                      nimdispose();
                      playEpisode(currentIndex-1);
                    }),
                IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Color.fromARGB(255, 97, 166, 251), size: 28),
                    onPressed: () async {
                      nimdispose();
                      playEpisode(currentIndex + 1);
                    }),
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
      final int initialIndex = season.episodes.indexOf(episode);
      nimdispose();
      playEpisode(initialIndex);

    }

    final displayTitle = 'Episode ${episode.episodeNumber}'; 
    bool isInWatchlist =
        userDataService.isWatchedEpisode(seriesname, id, episode, season);
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                      Text(
                        'Episode ${episode.episodeNumber}',
                        style: const TextStyle(color: AppColors.primaryText, fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (episode.episodeIdentifier != 'Episode ${episode.episodeNumber}')
                        Text(
                          episode.episodeIdentifier,
                          style: const TextStyle(color: AppColors.secondaryText, fontSize: 11),
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
                  return ElevatedButton(
                    onPressed: () {
                      final int episodeIndex = widget.playlist.indexOf(episode);
                      playEpisode(episodeIndex);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor.withOpacity(0.7),
                      foregroundColor: AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      minimumSize: const Size(45, 28),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12, fontStyle: FontStyle.italic),
            ),
        
     ]) );
    
  }
}