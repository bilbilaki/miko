import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';

//var userdata = UserDataService().decoderPreference;

// ignore: must_be_immutable
class VideoPlayerScreenPl extends StatefulWidget {
   String seriesname;
   int tvSeriesId;
   ss.Season season;
   List<ss.Episode> playlist;
   int initialIndex;
   String url;
   

   VideoPlayerScreenPl({
    required this.seriesname,
    required this.tvSeriesId,
    required this.season,
    required this.playlist,
    required this.initialIndex,
    required this.url,
    super.key,
  });

  @override
  State<VideoPlayerScreenPl> createState() => VideoPlayerScreenPlState();
}

class VideoPlayerScreenPlState extends State<VideoPlayerScreenPl> {
   Player player = Player();
  late final VideoController controller = VideoController(player);
  bool showControls = true;
  bool showEpisodeList = false;
  bool isFullScreen = false;
  bool isMuted = false;
  bool isPiPEnabled = false;
  Timer? _progressSaveTimer; // Timer to periodically save progress
   ScrollController _seasonsScrollController = ScrollController();
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
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

   List<BoxFit> fitOptions = [
    BoxFit.contain, // Standard
    BoxFit.cover, // Fill/Crop
    BoxFit.fill, // Stretch
    BoxFit.fitWidth,
    BoxFit.fitHeight,
  ];
  int currentFitIndex = 0;
  BoxFit get currentFit => fitOptions[currentFitIndex];
   Map<BoxFit, IconData> _fitIcons = {
    BoxFit.contain: Icons.fullscreen_exit,
    BoxFit.cover: Icons.fullscreen,
    BoxFit.fill: Icons.photo_size_select_large,
    BoxFit.fitWidth: Icons.swap_horiz,
    BoxFit.fitHeight: Icons.swap_vert,
  };


   List<String> choicelist = [
    'Auto',
    '1080p',
    '720p',
    '540',
    '480p',
    'DUBBED',
  ];

  Map<String, String?> getAvailableQualityUrl() {
    ss.Episode episodeToPlay = widget.playlist[currentIndex];

     Map<String, String?> currentchoice = {};
    if (widget.url == episodeToPlay.url1080p && episodeToPlay.url1080p != null)
      currentchoice['1080p'] = episodeToPlay.url1080p;
    if (widget.url == episodeToPlay.url720p && episodeToPlay.url720p != null)
      currentchoice['720p'] = episodeToPlay.url720p;
    if (widget.url == episodeToPlay.url540p && episodeToPlay.url540p != null)
      currentchoice['540p'] = episodeToPlay.url540p;
    if (widget.url == episodeToPlay.url480p && episodeToPlay.url480p != null)
      currentchoice['480p'] = episodeToPlay.url480p;

    return currentchoice;
  }

  Future<String> _showQualitySelectionDialog() async {
     Map<String, String?> currentSelectedOptions =
        getAvailableQualityUrl();
    ss.Episode episodeToPlay = widget.playlist[currentIndex];

    Map<String, String>  availableQualities = episodeToPlay.getAvailableQualityUrls();

    var selectedQuality = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Quality'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableQualities.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  selected: entry.key == currentSelectedOptions,
                  selectedColor: Colors.purple,
                  onTap: () {
                    _changeQuality(entry.key);
                    Navigator.of(context).pop(entry.key);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (selectedQuality != null &&
        availableQualities.containsKey(selectedQuality)) {
      urlToPlayQuality = availableQualities[selectedQuality]!;
      currentQuality = selectedQuality;
      return _cycleQuality(currentQuality);
    } else {
      return 'Invalid selection';
    }
  }

  String _cycleQuality(String currentQuality) {
     List<String> qualityList = [
      'Auto',
      '1080p',
      '720p',
      '540p',
      '480p',
      'DUBBED',
    ];
    int currentIndex = qualityList.indexOf(currentQuality);
    currentIndex = (currentIndex + 1) % qualityList.length;
    return qualityList[currentIndex];
  }

  void _changeQuality(String newQuality) {
    setState(() {
      currentQuality = newQuality;
    });
    playEpisodeByUrl(currentQuality, currentIndex);
  }

  late final UserDataService _userDataService;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    _userDataService = Provider.of<UserDataService>(context, listen: false);

    _completedSubscription = player.stream.completed.listen((completed) {
      debugPrint(
        'VideoPlayerScreenPlState: Player completed stream event: $completed',
      );
      if (completed) {
        _clearPlaybackProgress(); 
        debugPrint('VideoPlayerScreenPlState: Video completed. Playing next.');
        playNext();
      }
    });

    _progressSaveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _savePlaybackProgress();
    });
    debugPrint('VideoPlayerScreenPlState: _progressSaveTimer started.');


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndPlayEpisode(widget.initialIndex, isInitialPlay: true);
    });
  }

  Future<void> _loadAndPlayEpisode(
    int index, {
    bool isInitialPlay = true,
    String? specificUrl,
  }) async {
    // 1. Validate index
    if (index < 0 || index >= widget.playlist.length) {
      debugPrint("Invalid episode index: $index. Not playing.");
      if (!isInitialPlay) Navigator.of(context).pop();
      return;
    }

    // 2. Update state
    setState(() {
      currentIndex = index;
    });

    ss.Episode episodeToPlay = widget.playlist[currentIndex];


    String urlToPlay;
    if (specificUrl != null) {
      urlToPlay = specificUrl;
    } else {
      Map<String, String>  availableUrls = episodeToPlay.getAvailableQualityUrls();
      if (availableUrls.isEmpty) {
        debugPrint('No URLs found for this episode. Cannot play.');

        return;
      }
      urlToPlay = availableUrls.values.first;
    }

    debugPrint("Opening media: $urlToPlay");
    await player.open(Media(Uri.decodeComponent(urlToPlay)), play: false);

    _userDataService.toggleIsWatchedLink(
      widget.seriesname,
      widget.tvSeriesId,
      currentIndex + 1,
      widget.season.seasonNumber,
    );

    Duration? savedPosition = await _userDataService.getEpisodeProgress(
      widget.tvSeriesId,
      widget.season.seasonNumber,
      currentIndex + 1,
    );

    if (isInitialPlay) {
 
      if (savedPosition != null) {
        final shouldResume = await _showResumeDialog(savedPosition);
        if (shouldResume == true) {
          await player.seek(savedPosition);
          await player.play();
        } else if (shouldResume == false) {
          await _clearPlaybackProgress();
        }
      }
    }


    await player.play();
  }

  void playNext() {
    _loadAndPlayEpisode(currentIndex + 1, isInitialPlay: true);
  }

  void playPrevious() {
    _loadAndPlayEpisode(currentIndex - 1, isInitialPlay: true);
  }

  void playEpisode(int index) {
    _loadAndPlayEpisode(
      index,
      isInitialPlay: true,
    ); 
  }

  void changeQuality(String newQualityUrl) {
    _savePlaybackProgress();
    _loadAndPlayEpisode(
      currentIndex,
      isInitialPlay: true,
      specificUrl: newQualityUrl,
    );
  }

  @override
  void dispose() {
    debugPrint("VideoPlayerScreenPl disposing. Saving final progress.");
    _progressSaveTimer?.cancel();
    _completedSubscription?.cancel();
    _errorSubscription?.cancel();


    nimdispose(); // Your existing method is fine
    super.dispose();
  }


  void playEpisodeByUrl(String url, int index, {bool isInitialPlay = false}) {
    _loadAndPlayEpisode(index, isInitialPlay: true, specificUrl: url);
  }

  void nimdispose() async {
    await _savePlaybackProgress();
    await player.dispose(); 
  }

  Future<void> _savePlaybackProgress() async {

    if (player.state.duration.inSeconds > 10) {
     
      Duration position = player.state.position; // Original commented line
    //  final duration = player.state.duration;
    
      await _userDataService.saveEpisodeProgress(
        widget.tvSeriesId,
        currentEpisode!.seasonNumber,
        currentIndex + 1,
        position, 
      );
    }
  }

  Future<void> _clearPlaybackProgress() async {
    await _userDataService.clearEpisodeProgress(
      widget.tvSeriesId,
      currentEpisode!.seasonNumber,
      currentEpisode!.episodeNumber,
    );
  }


  Future<bool?> _showResumeDialog(Duration savedPosition) async {
   
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (context) => AlertDialog(
        title: const Text('Resume Playback?'),
        content: Text(
          'You previously stopped watching at ${formatDuration(savedPosition)}. Would you like to resume?',
        ),
        actions: [
          TextButton(
            onPressed: () {
            
              Navigator.of(context).pop(false); // Return false
            },
            child: const Text('START OVER'),
          ),
          ElevatedButton(
            onPressed: () {
            
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



  // --- 1. BoxFit Feature: Function to cycle modes ---
  void _cycleBoxFit() {
    setState(() {
      currentFitIndex = (currentFitIndex + 1) % fitOptions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildPlaylistDrawer(context),
      endDrawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '${widget.seriesname}'
          '${currentEpisode?.episodeIdentifier ?? 'Loading...'}',
        ),
      ),
      body: _buildPlayerWithControls(),
    );
  }

  // A new widget for the playlist drawer
  Widget _buildPlaylistDrawer(context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.85),
      child: _buildSeasonsList(context, [widget.season], widget.tvSeriesId),
    );
  }

  void toggleEpisodeList() {
    setState(() {
      showEpisodeList = !showEpisodeList;
    
    });
  }

  void togglePlayPause() async {
    await player.playOrPause();
    
  }

  void playNextEpisode() async {
    setState(() {
      currentIndex = currentIndex + 1; // Direct update, consider safety check
     
    });
    playEpisode(currentIndex);
  }

  void playPreviousEpisode() async {
    
    setState(() {
      currentIndex = currentIndex - 1; // Direct update, consider safety check
     
    });
    playEpisode(currentIndex);
   
  }

  void seekForward() {
    Duration position = player.state.position;
    Duration duration = player.state.duration;
    Duration newPosition = position + const Duration(seconds: 10);
   
    if (newPosition < duration) {
      player.seek(newPosition);
   
    } else {
      player.seek(duration);
     
    }
  }

  void seekBackward() {
    Duration position = player.state.position;
    Duration newPosition = position - const Duration(seconds: 10);
  
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
    // ignore: non_constant_identifier_names
    BuildContext context,
    List<ss.Season> seasons,
    int tvseriesId,
  ) {
   
    bool defaultExpansion = seasons.length == 1;
    
    return SizedBox(
      height: 500,
      child: ListView.builder(
        controller: _seasonsScrollController,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          ss.Season season = seasons[index];
         

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            color: AppColors.secondaryBackground.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              iconColor: AppColors.accentColor,
              collapsedIconColor: AppColors.secondaryText,
              initiallyExpanded: defaultExpansion || season.seasonNumber == 1,
              childrenPadding: const EdgeInsets.only(
                bottom: 8.0,
                left: 4,
                right: 4,
              ),
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
    return Stack(
      children: [
        Video(
          controller: controller,
          controls: AdaptiveVideoControls,
          fit: currentFit,
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
                IconButton(
                  onPressed: _showQualitySelectionDialog,
                  icon: Icon(Icons.hd_rounded),
                ),
                IconButton(
                  icon: Icon(
                    _fitIcons[currentFit] ?? Icons.aspect_ratio,
                    color: Colors.white,
                  ),
                  tooltip: 'Change display mode',
                  onPressed: _cycleBoxFit,
                ),
                if (showSubtitleControls)
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.text_fields,
                          color: Colors.white,
                          size: 20,
                        ),
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
                  icon: const Icon(
                    Icons.closed_caption,
                    color: Color.fromARGB(255, 178, 246, 255),
                  ),
                  onPressed: _showSubtitleControls,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () async {
                   
                    playEpisode(currentIndex);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Color.fromARGB(255, 250, 109, 109),
                    size: 28,
                  ),
                  onPressed: () async {
                  
                    playEpisode(currentIndex - 1); // Consider bounds check
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Color.fromARGB(255, 97, 166, 251),
                    size: 28,
                  ),
                  onPressed: () async {
                   
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
  
    Map<String, String> availableQualities = episode.getAvailableQualityUrls();
  
    UserDataService userDataService = Provider.of<UserDataService>(
      context,
      listen: false,
    );

    void playEpisodes(BuildContext context, String url) async {
    
       int initialIndex = season.episodes.indexOf(episode);
    
      playEpisodeByUrl(url, initialIndex);
    }

    // final displayTitle = 'Episode ${episode.episodeNumber}'; // Original commented line
    bool isInWatchlist = userDataService.isWatchedEpisode(
      widget.seriesname,
      widget.tvSeriesId,
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
                alignment: WrapAlignment.end,
                spacing: 6.0,
                runSpacing: 4.0,
                children: availableQualities.entries.map<Widget>((entry) {
                  // final quality = entry.key; // Original commented line
                  final url = entry.value;
                
                  return ElevatedButton(
                    onPressed: () {
                      // final int episodeIndex = widget.playlist.indexOf(episode); // Original commented line
                    
                      playEpisodes(context, url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor.withOpacity(0.7),
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
        ],
      ),
    );
  }
}
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final List? playlistitem;
  const VideoPlayerScreen({required this.videoUrl,this.playlistitem, super.key});

  @override
  State<VideoPlayerScreen> createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);

  bool isPiPEnabled = false;

  double subtitleSize = 32.0;
  Color subtitleColor = const Color.fromARGB(255, 238, 230, 5);
  bool showSubtitleControls = false;
  Timer? _hideTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});



    player.open(Media(Uri.decodeComponent(widget.videoUrl)),
        play: true);


    player.stream.error.listen((error) {
      debugPrint('Player error: $error');
    });
  }

  String currentQuality = 'Auto';
  final List<String> qualityOptions = ['Auto', '1080p', '720p', '480p', '360p'];

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

  @override
  void dispose(){
 // Release PiP plugin resources
    _hideTimer?.cancel();

 player.dispose();

    super.dispose();
  }
    final List<BoxFit> _fitOptions = [
    BoxFit.contain, // Standard
    BoxFit.cover,   // Fill/Crop
    BoxFit.fill,    // Stretch
    BoxFit.fitWidth,
    BoxFit.fitHeight,
  ];
  int currentFitIndex = 0;
  BoxFit get currentFit => _fitOptions[currentFitIndex];
  // Map to hold icons for each fit mode for better UX
  final Map<BoxFit, IconData> _fitIcons = {
    BoxFit.contain: Icons.fullscreen_exit,
    BoxFit.cover: Icons.fullscreen,
    BoxFit.fill: Icons.photo_size_select_large,
    BoxFit.fitWidth: Icons.swap_horiz,
    BoxFit.fitHeight: Icons.swap_vert,
  };
  void _cycleBoxFit() {
    setState(() {
      currentFitIndex = (currentFitIndex + 1) % _fitOptions.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    debugPrint('VideoPlayerScreenState build method called.');
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [],
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Video(
              controller: controller,
              controls: AdaptiveVideoControls,
              fit: currentFit,
              filterQuality: FilterQuality.high,
              wakelock: true,
              subtitleViewConfiguration:  SubtitleViewConfiguration(
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
                                       IconButton(
                    icon: Icon(_fitIcons[currentFit] ?? Icons.aspect_ratio, color: Colors.white),
                    tooltip: 'Change display mode',
                    onPressed: _cycleBoxFit,
                  ),
                    IconButton(
                      icon: const Icon(Icons.picture_in_picture_outlined,
                          color: Colors.white),
                      onPressed: ()async {
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: _showSubtitleControls,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
   
    );
  }
}

class VideoPlayerScreenLocal extends StatefulWidget {
  final String videoUrl;
  final List? playlistitem;
  const VideoPlayerScreenLocal({
    required this.videoUrl,
    this.playlistitem,
    super.key,
  });

  @override
  State<VideoPlayerScreenLocal> createState() => _VideoPlayerScreenLocalState();
}

class _VideoPlayerScreenLocalState extends State<VideoPlayerScreenLocal> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);

  bool isPiPEnabled = false;

  double subtitleSize = 32.0;
  Color subtitleColor = const Color.fromARGB(255, 238, 230, 5);
  bool showSubtitleControls = false;
  Timer? _hideTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    player.open(Media(File(widget.videoUrl).path), play: true);

    player.stream.error.listen((error) {
      debugPrint('Player error: $error');
    });
  }

  String currentQuality = 'Auto';
  final List<String> qualityOptions = ['Auto', '1080p', '720p', '480p', '360p'];

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

  @override
  void dispose() {
    // Release PiP plugin resources
    _hideTimer?.cancel();

    player.dispose();

    super.dispose();
  }

  final List<BoxFit> _fitOptions = [
    BoxFit.contain, // Standard
    BoxFit.cover, // Fill/Crop
    BoxFit.fill, // Stretch
    BoxFit.fitWidth,
    BoxFit.fitHeight,
  ];
  int currentFitIndex = 0;
  BoxFit get currentFit => _fitOptions[currentFitIndex];
  // Map to hold icons for each fit mode for better UX
  final Map<BoxFit, IconData> _fitIcons = {
    BoxFit.contain: Icons.fullscreen_exit,
    BoxFit.cover: Icons.fullscreen,
    BoxFit.fill: Icons.photo_size_select_large,
    BoxFit.fitWidth: Icons.swap_horiz,
    BoxFit.fitHeight: Icons.swap_vert,
  };
  void _cycleBoxFit() {
    setState(() {
      currentFitIndex = (currentFitIndex + 1) % _fitOptions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('VideoPlayerScreenState build method called.');
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, actions: []),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Video(
            controller: controller,
            controls: AdaptiveVideoControls,
            fit: currentFit,
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
                          const Icon(
                            Icons.text_fields,
                            color: Colors.white,
                            size: 20,
                          ),
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
                    icon: Icon(
                      _fitIcons[currentFit] ?? Icons.aspect_ratio,
                      color: Colors.white,
                    ),
                    tooltip: 'Change display mode',
                    onPressed: _cycleBoxFit,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.picture_in_picture_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () async {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: _showSubtitleControls,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
