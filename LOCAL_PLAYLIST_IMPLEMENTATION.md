# Local File Playlist Implementation

## Overview
Implemented automatic local file playlist generation that scans the parent folder for video files and creates a playlist for seamless playback of multiple videos in sequence.

## How It Works

### Architecture

```
VideoPlayerScreen (local file source)
    ↓
initState() triggered
    ↓
_initializeLocalPlaylist() called (background)
    ↓
LocalFilePlaylistService.buildAndLoadLocalPlaylist()
    ├─ Scan parent folder for video files
    ├─ Sort files alphabetically
    ├─ Create Media objects for each file
    ├─ Find current file index
    └─ Load playlist into player
    ↓
Player automatically plays next video when current completes
```

## Files Created

### `lib/services/local_file_playlist_service.dart`

A utility service for managing local file playlists with the following methods:

#### 1. `buildPlaylistFromFolder(String filePath)`
- Scans the parent directory of the given file path
- Finds all video files (40+ supported formats)
- Sorts them alphabetically
- Returns `List<Media>` objects for media_kit

**Supported video formats:**
- Common: mp4, mkv, avi, mov, flv, wmv, webm
- Advanced: ts, mpg, mpeg, mts, m2ts, mxf, ogv, 3gp, vob, m3u8

**Returns:** List of Media objects ready for playback

#### 2. `findCurrentFileIndex(List<Media> playlist, String currentFilePath)`
- Locates the index of the current file in the generated playlist
- Used to ensure playback continues from the correct position
- Returns 0 if file not found (safe fallback)

#### 3. `loadPlaylistToPlayer(Player player, List<Media> playlist, int startIndex)`
- Loads the entire playlist into media_kit player
- Sets the initial playback index to match current file
- Uses media_kit's `Playlist` API with `initialIndex` parameter

#### 4. `buildAndLoadLocalPlaylist()` - Main Method
- Orchestrates the entire process:
  1. Validates source is local
  2. Scans folder for videos
  3. Finds current file position
  4. Loads playlist into player
- Returns boolean indicating success/failure

## Files Modified

### `lib/screens/video_player_wplaylist_screen.dart`

#### Added Import:
```dart
import 'package:miko/services/local_file_playlist_service.dart';
```

#### Updated `initState()`:
- Calls new `_initializeLocalPlaylist()` method after loading first episode
- Runs in background (non-blocking)
- Only executes when source is "local"

#### New Method: `_initializeLocalPlaylist()`
```dart
Future<void> _initializeLocalPlaylist() async {
  final isLoaded = await LocalFilePlaylistService.buildAndLoadLocalPlaylist(
    player: player,
    currentFilePath: widget.videoUrl,
    isLocalSource: true,
  );
}
```

## User Experience Flow

### Local File Playback:
1. User opens a video file from local storage
2. VideoPlayerScreen initializes and starts playing
3. **In background:** Playlist service scans the parent folder
4. All video files in the folder are discovered and sorted
5. Playlist is loaded into media_kit player
6. When current video finishes → **Automatically plays next video** (via existing `playNext()` call)
7. User can skip forward/backward through playlist using existing UI controls

### Key Benefits:
- ✅ **Seamless playback** - Next video plays automatically
- ✅ **Alphabetical ordering** - Intuitive file sequence
- ✅ **Non-blocking** - Done in background, no UI lag
- ✅ **Safe fallback** - Works even if scanning fails
- ✅ **No manual intervention** - Auto-discovery
- ✅ **Existing controls work** - Skip buttons navigate playlist

## How Media_Kit Playlist Works

Media_kit's `Playlist` API:
```dart
await player.open(
  Playlist([media1, media2, media3, ...]),
  initialIndex: 0,  // Start at this index
  play: false,      // Don't auto-start
);
```

- **Automatic continuation:** When a media completes, player automatically moves to next
- **Manual navigation:** Existing `playNext()` and `playPrevious()` methods work seamlessly
- **Index tracking:** `currentIndex` state variable stays synchronized

## Debug Output

The service provides detailed logging:
```
I/flutter: Building playlist for local file: /path/to/video.mp4
I/flutter: Found 5 video files in /path/to/
I/flutter: Loaded playlist with 5 items, starting at index 2
I/flutter: Local file playlist initialized successfully
```

## Error Handling

- **Invalid path:** Logs error, returns empty list
- **Permission denied:** Gracefully caught, service disabled
- **No video files found:** Returns false, playback continues normally
- **Corrupted filename:** Skipped in playlist generation

## Integration Notes

The implementation seamlessly integrates with existing code:
- ✅ Uses existing `player` instance
- ✅ Compatible with subtitle/audio track handling
- ✅ Works with existing progress save/resume logic
- ✅ Doesn't interfere with quality selection
- ✅ Respects existing playback state management

## Example Usage in Other Screens

If you want to use this in other video player screens:

```dart
// In your screen's initState or when loading a video
if (isLocalFileSource) {
  LocalFilePlaylistService.buildAndLoadLocalPlaylist(
    player: yourPlayer,
    currentFilePath: videoFilePath,
    isLocalSource: true,
  );
}
```

Or manually:

```dart
// More control if needed
final playlist = await LocalFilePlaylistService.buildPlaylistFromFolder(filePath);
final startIndex = LocalFilePlaylistService.findCurrentFileIndex(playlist, filePath);
await LocalFilePlaylistService.loadPlaylistToPlayer(player, playlist, startIndex);
```
