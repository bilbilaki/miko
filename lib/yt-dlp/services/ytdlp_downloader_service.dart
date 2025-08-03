// lib/services/ytdlp_downloader_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:miko/constants.dart';

class YtdlpDownloaderService {
  final Dio _dio = Dio();
  String? _appSupportPath;

  Future<void> initialize() async {
    if (Platform.isAndroid) return; // Not needed on Android
    final dir = await getApplicationSupportDirectory();
    _appSupportPath = '${dir.path}${Platform.pathSeparator}ytdlp_gui';
    await Directory(_appSupportPath!).create(recursive: true);
  }

  Future<String?> getVersion(String ytdlpPath) async {
    if (Platform.isAndroid) {
      // Version is managed by the flutter_yt_dlp package.
      // This could be enhanced if the package ever exposes its bundled version.
      return "flutter_yt_dlp (Bundled)";
    }
    if (!File(ytdlpPath).existsSync()) return null;
   // try {
      final result = await Process.run(ytdlpPath, ['--version']);
     // if (result.exitCode == 0) {
        return (result.stdout as String).trim();
     // }
   // } catch (e) {
    //  debugPrint('Error getting version: $e');
  // }
  }

  Future<String?> findOrDownloadYtdlp(YtdlpChannel channel,
      {Function(double)? onProgress}) async {
    if (Platform.isAndroid) {
      // On Android, the executable is bundled with the flutter_yt_dlp package.
      // We don't need to download anything. This string acts as a success flag.
      return "android_bundled";
    }

    if (_appSupportPath == null) await initialize();

    final fileName = Platform.isWindows ? 'yt-dlp.exe' : 'yt-dlp';
    final destinationPath = '$_appSupportPath${Platform.pathSeparator}$fileName';

    try {
      final releaseInfo = await _getLatestReleaseInfo(channel);
      final assetUrl = _findAssetUrl(releaseInfo, channel);
      if (assetUrl == null) {
        throw Exception('Could not find a suitable binary for this platform.');
      }

      await _dio.download(
        assetUrl,
        destinationPath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      if (Platform.isLinux || Platform.isMacOS) {
        await Process.run('chmod', ['+x', destinationPath]);
      }

      return destinationPath;
    } catch (e) {
      debugPrint("Error downloading yt-dlp: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> _getLatestReleaseInfo(
      YtdlpChannel channel) async {
    final url = AppConstants.getReleaseUrl(channel, 'latest');
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to get latest release info.');
    }
  }

  String? _findAssetUrl(
      Map<String, dynamic> releaseInfo, YtdlpChannel channel) {
    final assets = releaseInfo['assets'] as List;
    String assetName;

    if (Platform.isWindows) {
      assetName = 'yt-dlp.exe';
    } else if (Platform.isLinux) {
      assetName = channel == YtdlpChannel.stable ? 'yt-dlp' : 'yt-dlp_linux';
    } else if (Platform.isMacOS) {
      assetName = channel == YtdlpChannel.stable ? 'yt-dlp_macos' : 'yt-dlp_macos'; // Assuming same name for simplicity
    } else {
      return null;
    }

    final asset = assets.firstWhere(
      (a) => a['name'] == assetName,
      orElse: () => null,
    );

    return asset?['browser_download_url'];
  }
}

final ytdlpDownloaderServiceProvider =
    Provider((ref) => YtdlpDownloaderService());