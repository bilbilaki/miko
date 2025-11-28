import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:native_zip/native_zip.dart';
import 'package:path_provider/path_provider.dart';
import '../models/fileexplorer/fs_entry.dart';
import '../models/fileexplorer/fs_entry_union.dart';
import '../models/fileexplorer/fs_file_data.dart';
import '../models/fileexplorer/fs_folder_children.dart';


class ZipService {

  void showProgress(ZipTaskFuture future) {
    var timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      var progress = future.processedSize / future.totalSize * 100;
      var compressRatio = future.compressedSize / future.processedSize * 100;
      var path = future.nowProcessingFilepath;
      log("progress: $progress%, compress ratio: $compressRatio%, path: $path");
    });
    future.whenComplete(() {
      log("finish");
      timer.cancel();
    });
  }

  Future<void> folderToZip(
    String folder,
    String outputZipFilePath, {
    bool cancel = false,
  }) async {
    var future = NativeZip.zipDir(folder, outputZipFilePath);
    cancel ? future.cancel() : showProgress(future);
    await future;
  }

  Future<void> zipToFolder(
    String outputFolder,
    String inputZipFilePath, {
    bool cancel = false,
  }) async {
    var future = NativeZip.unzipToDir(inputZipFilePath, outputFolder);
    cancel ? future.cancel() : showProgress(future);
    await future;
  }

  Future<void> addFilesToZip(
    String inputZipFilePath,
    List<String> sourcesInDisk,
    String targetPathInZip,{bool cancel =false}
  ) async {
    ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
    var future = zip.addFiles(sourcesInDisk, targetPathInZip);
    showProgress(future);
   cancel?future.cancel(): await future;
  }
  /// Read text content of a file inside the zip.
  Future<String?> readTextFileInZip(
    String inputZipFilePath,
    String entryPath,
  ) async {
    final zip = NativeZip.openZipFile(inputZipFilePath);
    try {
      return await zip.openRead(entryPath).transform(utf8.decoder).join();
    } catch (e) {
      log('Error reading from zip: $e');
      return null;
    } finally {
      // zip.close(); // if safe
    }
  }

  /// Write/replace a file entry inside the zip with given text content.
  Future<void> writeTextFileInZip(
    String inputZipFilePath,
    String entryPath,
    String content,
  ) async {
    final tmpDir = await getTemporaryDirectory();
    final targetFileName = p.basename(entryPath);
    final tempFilePath = p.join(tmpDir.path, targetFileName);
    final tempFile = File(tempFilePath);
    await tempFile.writeAsString(content);

    await addFilesToZip(
      inputZipFilePath,
      [tempFile.path],
      p.dirname(entryPath),
    );
  }
  /// List entries inside a zip at a given virtual path.
  /// If [whichPath] is null or empty, list the root.
  Future<List<ZipEntryInfo>> listZipEntries(
    String inputZipFilePath, {
    String? whichPath,
  }) async {
    final zip = NativeZip.openZipFile(inputZipFilePath);
    try {
      if (whichPath == null || whichPath.isEmpty) {
        return zip.getEntries();
      } else {
        // Only direct children of whichPath
        return zip.getEntries(path: whichPath, recursive: false);
      }
    } finally {
      // We leave the zip open for other operations; you can close it if needed.
      // zip.close();
    }
  }

  /// Convert raw ZipEntryInfo list into FsEntry list using your domain model.
  List<FsEntry> zipEntriesToFsEntries(List<ZipEntryInfo> entries) {
    final result = <FsEntry>[];

    for (final entry in entries) {
      final fsEntry = zipEntryToFsEntry(entry);
      if (fsEntry != null) {
        result.add(fsEntry);
      }
    }
    return result;
  }

  /// Convert a single ZipEntryInfo to FsEntry.file or FsEntry.folder.
  FsEntry? zipEntryToFsEntry(ZipEntryInfo zipEntry) {
    final pathInZip = zipEntry.path;

    // Skip root pseudo-entry if library uses it
    if (pathInZip.isEmpty || pathInZip == '/') {
      return null;
    }

    final name = p.basename(
      zipEntry.isDirectory && pathInZip.endsWith('/')
          ? pathInZip.substring(0, pathInZip.length - 1)
          : pathInZip,
    );

    if (zipEntry.isDirectory) {
      return FsEntry.folder(
        base: FsEntryBase.create(
          path: pathInZip,
          name: name,
          kind: FileKind.folder,
          // We treat zip path as "virtual", so no size.
          sizeBytes: null,
          timestamps: EntryTimestamps(
            createdAt: zipEntry.modifiedDateTime,
            updatedAt: zipEntry.modifiedDateTime,
          ),
        ),
        data: const FsFolderData(
          children: [],
          isPartial: true,
        ),
      );
    } else {
      final ext = p.extension(pathInZip).toLowerCase();
      final kind = _kindFromExtension(ext);

      return FsEntry.file(
        base: FsEntryBase.create(
          path: pathInZip,
          name: name,
          kind: kind,
          extension: ext.isNotEmpty ? ext.substring(1) : null,
          sizeBytes: zipEntry.originalSize,
          timestamps: EntryTimestamps(
            createdAt: zipEntry.modifiedDateTime,
            updatedAt: zipEntry.modifiedDateTime,
          ),
        ),
        data: FsFileData(
          // We encode "location in zip" in a RemoteStorageLocation for now
          location: StorageLocation.remote(
            uri: pathInZip,
            backend: 'zip',
          ),
          mime: null,
          typeMeta: null,
          isContentAvailable: false,
          convertibleTo: const [],
        ),
      );
    }
  }

  /// Map zip file extensions to FileKind; reuse your LocalFsRepository logic if desired.
  FileKind _kindFromExtension(String ext) {
    final lower = ext.toLowerCase();
    if (lower.isEmpty) return FileKind.unknown;

    const videoExts = {
      '.mp4', '.avi', '.mkv', '.mov', '.webm', '.flv', '.wmv', '.m4v', '.ts', '.mts',
    };
    const audioExts = {
      '.mp3', '.m4a', '.flac', '.wav', '.aac', '.ogg', '.wma', '.aiff', '.alac',
    };
    const imageExts = {
      '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.ico', '.svg', '.tiff', '.raw',
    };
    const archiveExts = {
      '.zip', '.rar', '.7z', '.tar', '.gz', '.bz2', '.xz', '.iso',
    };
    const documentExts = {
      '.txt', '.md', '.pdf', '.docx', '.xlsx', '.pptx', '.odt', '.rtf', '.html',
      '.htm', '.xml', '.yaml', '.yml', '.log',
    };

    if (imageExts.contains(lower)) return FileKind.image;
    if (videoExts.contains(lower)) return FileKind.video;
    if (audioExts.contains(lower)) return FileKind.audio;
    if (archiveExts.contains(lower)) return FileKind.archive;
    if (lower == '.apk') return FileKind.apk;
    if (lower == '.json') return FileKind.json;
    if (lower == '.csv') return FileKind.csv;
    if (lower == '.md') return FileKind.markdown;
    if (documentExts.contains(lower)) return FileKind.document;

    return FileKind.unknown;
  }
  
    Future<void> renameEntryInZip(
      String inputZipFilePath,
      String oldPath,
      String newPath,
    ) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      await zip.renameEntry(oldPath, newPath);
    }

    Future<void> moveEntriesInZip(
      String inputZipFilePath,
      List<String> entries,
      String toDirPath,
    ) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      final normalizedDir = _normalizeToDirPath(toDirPath);
      await zip.moveEntries(entries, normalizedDir);
    }

    // Extract multiple files or directories from the zip archive to a disk directory
    Future<void> saveFilesFromZip(
      String inputZipFilePath,
      List<String> sourcesInZip,
      String outputDirOnDisk, {
      int? threadCount,
      bool cancel = false,
    }) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      var future = threadCount == null
          ? zip.saveFilesTo(
              sourcesInZip,
              outputDirOnDisk,
            )
          : zip.saveFilesTo(
              sourcesInZip,
              outputDirOnDisk,
              threadCount: threadCount,
            );
      cancel ? future.cancel() : showProgress(future);
      await future;
    }

    // Extract a single file or directory from the zip archive to a disk directory
    Future<void> saveEntryFromZip(
      String inputZipFilePath,
      String sourceInZip,
      String outputDirOnDisk, {
      int? threadCount,
      bool cancel = false,
    }) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      var future = threadCount == null
          ? zip.saveTo(
              sourceInZip,
              outputDirOnDisk,
            )
          : zip.saveTo(
              sourceInZip,
              outputDirOnDisk,
              threadCount: threadCount,
            );
      cancel ? future.cancel() : showProgress(future);
      await future;
    }

    Future<void> moveEntryInZip(
      String inputZipFilePath,
      String entryPath,
      String toDirPath,
    ) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      final normalizedDir = _normalizeToDirPath(toDirPath);
      await zip.moveEntry(entryPath, normalizedDir);
    }

    Future<void> removeEntriesInZip(
      String inputZipFilePath,
      List<String> entries,
    ) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      await zip.removeEntries(entries);
    }

    Future<void> removeEntryInZip(
      String inputZipFilePath,
      String entryPath,
    ) async {
      ZipFile zip = NativeZip.openZipFile(inputZipFilePath);
      await zip.removeEntry(entryPath);
    }

    String _normalizeToDirPath(String dir) {
      if (dir.isEmpty || dir.endsWith('/')) return dir;
      return '$dir/';
    }
  }
