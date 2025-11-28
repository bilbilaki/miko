/// Utility for converting ZipEntryInfo to file manager models
///
/// Example Usage:
/// ```dart
/// import 'package:your_app/filemanager/utils/zip_entry_converter.dart';
///
/// // Process a list of ZipEntryInfo entries
/// void processZipArchive(List<ZipEntryInfo> entries) {
///   final provider = LocalProvider();
///   
///   for (final entry in entries) {
///     provider.addZipEntryToLists(entry);
///   }
///   
///   // Now you have categorized files:
///   print('Folders: ${provider.folders.length}');
///   print('Movies: ${provider.movies.length}');
///   print('Audio: ${provider.audios.length}');
///   print('Images: ${provider.images.length}');
///   print('Documents: ${provider.documents.length}');
/// }
/// ```
///
/// Individual conversion examples:
/// ```dart
/// // Convert specific entry types
/// FolderItem folder = provider.folderFromZipEntry(zipEntry);
/// MovieItem? movie = provider.movieFromZipEntry(zipEntry);
/// AudioItem? audio = provider.audioFromZipEntry(zipEntry);
/// ImageItem? image = provider.imageFromZipEntry(zipEntry);
/// DocumentItem? doc = provider.documentFromZipEntry(zipEntry);
/// ```
///
/// Manual model creation:
/// ```dart
/// // Direct model creation from ZipEntryInfo
/// if (zipEntry.isDirectory) {
///   final folder = FolderItem.fromZipEntry(zipEntry);
///   print('Folder: ${folder.name} at ${folder.path}');
/// } else {
///   final movie = MovieItem.fromZipEntry(zipEntry);
///   print('Movie: ${movie.name}, size: ${movie.formattedSize}');
/// }
/// ```
///
/// Batch processing with filtering:
/// ```dart
/// void extractVideosFromZip(List<ZipEntryInfo> entries) {
///   final videos = entries
///       .where((e) => !e.isDirectory)
///       .map((e) => provider.movieFromZipEntry(e))
///       .whereType<MovieItem>() // Filter out nulls
///       .toList();
///   
///   for (final video in videos) {
///     print('Found video: ${video.name} (${video.formattedSize})');
///   }
/// }
/// ```

library;

// This file serves as documentation for ZipEntryInfo conversion.
// All conversion logic is implemented in LocalProvider.

/// ZipEntryInfo structure (from native library):
/// ```dart
/// final class ZipEntryInfo {
///   final ZipFile _zip;
///   final int index;
///   final int modifiedUnixTime;
///   final String path;
///   final int originalSize;
///   final int compressedSize;
///   
///   bool get isDirectory => path.endsWith("/");
///   DateTime get modifiedDateTime =>
///       DateTime.fromMillisecondsSinceEpoch(modifiedUnixTime * 1000);
///       
///   Stream<List<int>> openRead() async* {
///     yield* _zip.openReadByIndex(index);
///   }
/// }
/// ```

/// Conversion Methods in LocalProvider:
///
/// 1. `folderFromZipEntry(zipEntry)` -> FolderItem
///    - Always succeeds for directory entries
///    - Extracts: path, name, modifiedDateTime
///    - Sets: isFromArchive = true
///
/// 2. `movieFromZipEntry(zipEntry)` -> MovieItem?
///    - Returns null if not a video extension
///    - Supported: mp4, avi, mkv, mov, wmv, flv, webm, m4v, mpg, mpeg, 3gp
///    - Extracts: path, name, size (originalSize), modifiedDateTime, extension
///
/// 3. `audioFromZipEntry(zipEntry)` -> AudioItem?
///    - Returns null if not an audio extension
///    - Supported: mp3, wav, flac, aac, ogg, wma, m4a, opus, ape, alac
///    - Extracts: path, name, size, modifiedDateTime, extension
///
/// 4. `imageFromZipEntry(zipEntry)` -> ImageItem?
///    - Returns null if not an image extension
///    - Supported: jpg, jpeg, png, gif, bmp, webp, svg, ico, tiff, tif, heic, heif
///    - Extracts: path, name, size, modifiedDateTime, extension
///
/// 5. `documentFromZipEntry(zipEntry)` -> DocumentItem?
///    - Returns null if not a document extension
///    - Supported: pdf, doc, docx, xls, xlsx, ppt, pptx, txt, rtf, odt, ods, odp,
///                 pages, numbers, key, md, html, htm, xml, json, csv, log, etc.
///    - Extracts: path, name, size, modifiedDateTime, extension
///
/// 6. `addZipEntryToLists(zipEntry)` -> void
///    - Automatic categorization
///    - Adds entry to appropriate list (_folders, _movies, _audios, _images, _documents)
///    - Handles directory detection automatically

/// Model Features:
///
/// All models include:
/// - `path`: Full path in archive
/// - `name`: Filename extracted from path
/// - `modifiedDate`: Converted from Unix timestamp
/// - `isFromArchive`: Always true for ZipEntryInfo conversions
///
/// File models (Movie, Audio, Image, Document) also include:
/// - `size`: Original uncompressed size from ZipEntryInfo
/// - `extension`: Extracted from filename
/// - `formattedSize`: Human-readable size (e.g., "1.5 MB")
///
/// Type-specific features:
/// - MovieItem: durationSeconds, resolution, formattedDuration
/// - AudioItem: durationSeconds, artist, album, title, displayTitle
/// - ImageItem: width, height, resolution, aspectRatio, megapixels
/// - DocumentItem: pageCount, author, title, documentType
///
/// Note: Duration, resolution, dimensions, and metadata are null when created
/// from ZipEntryInfo (requires additional extraction from file contents).

/// Integration Example:
/// ```dart
/// import 'package:your_app/filemanager/providers/local_explorer_provider.dart';
///
/// class ZipArchiveViewer {
///   final LocalProvider _provider = LocalProvider();
///   
///   Future<void> loadArchive(String zipPath) async {
///     // Assuming you have a ZipFile reader
///     final zipFile = await ZipFile.open(zipPath);
///     final entries = await zipFile.getEntries();
///     
///     // Clear existing lists
///     _provider.clearSelection();
///     
///     // Process all entries
///     for (final entry in entries) {
///       _provider.addZipEntryToLists(entry);
///     }
///     
///     // Access categorized results
///     displayResults();
///   }
///   
///   void displayResults() {
///     print('=== Archive Contents ===');
///     
///     print('\nFolders (${_provider.folders.length}):');
///     for (final folder in _provider.folders) {
///       print('  📁 ${folder.name}');
///     }
///     
///     print('\nVideos (${_provider.movies.length}):');
///     for (final movie in _provider.movies) {
///       print('  🎬 ${movie.name} - ${movie.formattedSize}');
///     }
///     
///     print('\nAudio (${_provider.audios.length}):');
///     for (final audio in _provider.audios) {
///       print('  🎵 ${audio.name} - ${audio.formattedSize}');
///     }
///     
///     print('\nImages (${_provider.images.length}):');
///     for (final image in _provider.images) {
///       print('  🖼️  ${image.name} - ${image.formattedSize}');
///     }
///     
///     print('\nDocuments (${_provider.documents.length}):');
///     for (final doc in _provider.documents) {
///       print('  📄 ${doc.name} - ${doc.documentType} - ${doc.formattedSize}');
///     }
///   }
/// }
/// ```
