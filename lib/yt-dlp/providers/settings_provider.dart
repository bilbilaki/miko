// lib/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/services/ytdlp_downloader_service.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.read(ytdlpDownloaderServiceProvider));
});

class AppSettings {
  final String? ytdlpPath;
  final String? version;
  final YtdlpChannel channel;

  AppSettings(
      {this.ytdlpPath,
      this.version,
      this.channel = YtdlpChannel.stable});

  AppSettings copyWith(
      {String? ytdlpPath, String? version, YtdlpChannel? channel}) {
    return AppSettings(
      ytdlpPath: ytdlpPath ?? this.ytdlpPath,
      version: version ?? this.version,
      channel: channel ?? this.channel,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final YtdlpDownloaderService _downloaderService;
  SettingsNotifier(this._downloaderService) : super(AppSettings());

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final channelString =
        prefs.getString('ytdlpChannel') ?? YtdlpChannel.stable.name;
    final channel = YtdlpChannel.values.firstWhere(
        (e) => e.name == channelString,
        orElse: () => YtdlpChannel.stable);

    if (Platform.isAndroid) {
      final version = await _downloaderService.getVersion("android_bundled");
      state = state.copyWith(
          ytdlpPath: "android_bundled", version: version, channel: channel);
      return;
    }

    // Desktop logic
    final path = prefs.getString('ytdlpPath');
    if (path != null && path.isNotEmpty) {
      final version = await _downloaderService.getVersion(path);
      state = state.copyWith(ytdlpPath: path, version: version, channel: channel);
    } else {
      state = state.copyWith(channel: channel);
    }
  }

  Future<void> setChannel(YtdlpChannel channel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ytdlpChannel', channel.name);
    state = state.copyWith(channel: channel);
  }

  Future<void> findOrDownloadYtdlp() async {
    final path = await _downloaderService.findOrDownloadYtdlp(state.channel);
    if (path != null) {
      final version = await _downloaderService.getVersion(path);
      if (!Platform.isAndroid) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ytdlpPath', path);
      }
      state = state.copyWith(ytdlpPath: path, version: version);
    }
  }
}