import 'dart:io';

class YtdlpConfig {
  // General Options
  bool? ignoreErrors;
  bool? abortOnError;
  String? defaultSearch;
  bool? ignoreConfig;
  List<String>? configLocations;
  bool? flatPlaylist;
  bool? liveFromStart;
  String? waitForVideo;
  bool? markWatched;
  // ... and so on for all options

  // Network Options
  String? proxy;
  int? socketTimeout;
  String? sourceAddress;
  String? impersonate;
  bool? forceIpv4;
  bool? forceIpv6;

  // Geo-restriction
  String? geoVerificationProxy;
  String? xff;
  
  // Video Selection
  String? playlistItems;
  String? minFilesize;
  String? maxFilesize;
  String? date;
  String? datebefore;
  String? dateafter;
  List<String>? matchFilters;
  List<String>? breakMatchFilters;
  bool? noPlaylist;
  bool? yesPlaylist;
  int? ageLimit;
  String? downloadArchive;
  int? maxDownloads;
  bool? breakOnExisting;

  // Download Options
  int? concurrentFragments;
  String? limitRate;
  int? retries;
  int? fragmentRetries;
  bool? skipUnavailableFragments;
  bool? keepFragments;
  String? bufferSize;
  bool? noResizeBuffer;
  String? httpChunkSize;
  bool? playlistRandom;
  bool? lazyPlaylist;
  String? downloader;
  Map<String, String>? downloaderArgs;

  // Filesystem Options
  String? batchFile;
  Map<String, String>? paths;
  Map<String, String>? output;
  bool? restrictFilenames;
  int? trimFilenames;
  bool? noOverwrites;
  bool? forceOverwrites;
  bool? noContinue;
  bool? noPart;
  bool? writeDescription;
  bool? writeInfoJson;
  bool? writePlaylistMetafiles;
  bool? cleanInfoJson;
  bool? writeComments;
  String? loadInfoJson;
  String? cookies;
  String? cookiesFromBrowser;
  String? cacheDir;

  // Thumbnail Options
  bool? writeThumbnail;
  bool? writeAllThumbnails;
  
  // Verbosity and Simulation Options
  bool? quiet;
  bool? noWarnings;
  bool? simulate;
  bool? skipDownload;
  List<String>? printTemplate;
  bool? dumpJson;
  bool? dumpSingleJson;
  bool? forceWriteArchive;
  bool? noProgress;
  bool? verbose;
  bool? printTraffic;

  // Workarounds
  int? sleepRequests;
  int? sleepInterval;
  int? maxSleepInterval;

  // Video Format Options
  String? format;
  String? formatSort;
  bool? formatSortForce;
  bool? videoMultistreams;
  bool? audioMultistreams;
  String? mergeOutputFormat;

  // Subtitle Options
  bool? writeSubs;
  bool? writeAutoSubs;
  String? subFormat;
  String? subLangs;

  // Authentication Options
  String? username;
  String? password;
  String? twofactor;
  String? videoPassword;
  String? netrcLocation;

  // Post-processing Options
  bool? extractAudio;
  String? audioFormat;
  int? audioQuality;
  String? remuxVideo;
  String? recodeVideo;
  Map<String, String>? postprocessorArgs;
  bool? keepVideo;
  bool? embedSubs;
  bool? embedThumbnail;
  bool? embedMetadata;
  bool? embedChapters;
  bool? embedInfoJson;
  String? ffmpegLocation;
  String? convertSubs;
  String? convertThumbnails;
  bool? splitChapters;
  bool? forceKeyframesAtCuts;

  // SponsorBlock Options
  List<String>? sponsorblockMark;
  List<String>? sponsorblockRemove;
  String? sponsorblockApi;

  YtdlpConfig({
    this.ignoreErrors,
    this.abortOnError,
    this.defaultSearch,
    this.ignoreConfig,
    this.configLocations,
    this.flatPlaylist,
    this.liveFromStart,
    this.waitForVideo,
    this.markWatched,
    this.proxy,
    this.socketTimeout,
    this.sourceAddress,
    this.impersonate,
    this.forceIpv4,
    this.forceIpv6,
    this.geoVerificationProxy,
    this.xff,
    this.playlistItems,
    this.minFilesize,
    this.maxFilesize,
    this.date,
    this.datebefore,
    this.dateafter,
    this.matchFilters,
    this.breakMatchFilters,
    this.noPlaylist,
    this.yesPlaylist,
    this.ageLimit,
    this.downloadArchive,
    this.maxDownloads,
    this.breakOnExisting,
    this.concurrentFragments,
    this.limitRate,
    this.retries,
    this.fragmentRetries,
    this.skipUnavailableFragments,
    this.keepFragments,
    this.bufferSize,
    this.noResizeBuffer,
    this.httpChunkSize,
    this.playlistRandom,
    this.lazyPlaylist,
    this.downloader,
    this.downloaderArgs,
    this.batchFile,
    this.paths,
    this.output,
    this.restrictFilenames,
    this.trimFilenames,
    this.noOverwrites,
    this.forceOverwrites,
    this.noContinue,
    this.noPart,
    this.writeDescription,
    this.writeInfoJson,
    this.writePlaylistMetafiles,
    this.cleanInfoJson,
    this.writeComments,
    this.loadInfoJson,
    this.cookies,
    this.cookiesFromBrowser,
    this.cacheDir,
    this.writeThumbnail,
    this.writeAllThumbnails,
    this.quiet,
    this.noWarnings,
    this.simulate,
    this.skipDownload,
    this.printTemplate,
    this.dumpJson,
    this.dumpSingleJson,
    this.forceWriteArchive,
    this.noProgress,
    this.verbose,
    this.printTraffic,
    this.sleepRequests,
    this.sleepInterval,
    this.maxSleepInterval,
    this.format,
    this.formatSort,
    this.formatSortForce,
    this.videoMultistreams,
    this.audioMultistreams,
    this.mergeOutputFormat,
    this.writeSubs,
    this.writeAutoSubs,
    this.subFormat,
    this.subLangs,
    this.username,
    this.password,
    this.twofactor,
    this.videoPassword,
    this.netrcLocation,
    this.extractAudio,
    this.audioFormat,
    this.audioQuality,
    this.remuxVideo,
    this.recodeVideo,
    this.postprocessorArgs,
    this.keepVideo,
    this.embedSubs,
    this.embedThumbnail,
    this.embedMetadata,
    this.embedChapters,
    this.embedInfoJson,
    this.ffmpegLocation,
    this.convertSubs,
    this.convertThumbnails,
    this.splitChapters,
    this.forceKeyframesAtCuts,
    this.sponsorblockMark,
    this.sponsorblockRemove,
    this.sponsorblockApi,
  });

  List<String> buildCommand(String url, String outputDirectory) {
    final command = <String>[];

    void addFlag(bool? condition, String flag) {
      if (condition == true) command.add(flag);
    }
    void addOption(dynamic value, String option) {
      if (value != null && value.toString().isNotEmpty) {
        command.addAll([option, value.toString()]);
      }
    }
    void addList(List<String>? values, String option) {
      if(values != null) {
        for (final val in values) {
          command.addAll([option, val]);
        }
      }
    }

    addFlag(ignoreErrors, '--ignore-errors');
    addFlag(abortOnError, '--abort-on-error');
    addOption(defaultSearch, '--default-search');
    addFlag(ignoreConfig, '--ignore-config');
    addList(configLocations, '--config-locations');
    addFlag(flatPlaylist, '--flat-playlist');
    addFlag(liveFromStart, '--live-from-start');
    addOption(waitForVideo, '--wait-for-video');
    addFlag(markWatched, '--mark-watched');
    addOption(proxy, '--proxy');
    addOption(socketTimeout, '--socket-timeout');
    addOption(sourceAddress, '--source-address');
    addOption(impersonate, '--impersonate');
    addFlag(forceIpv4, '-4');
    addFlag(forceIpv6, '-6');
    addOption(geoVerificationProxy, '--geo-verification-proxy');
    addOption(xff, '--xff');
    addOption(playlistItems, '--playlist-items');
    addOption(minFilesize, '--min-filesize');
    addOption(maxFilesize, '--max-filesize');
    addOption(date, '--date');
    addOption(datebefore, '--datebefore');
    addOption(dateafter, '--dateafter');
    addList(matchFilters, '--match-filters');
    addList(breakMatchFilters, '--break-match-filters');
    addFlag(noPlaylist, '--no-playlist');
    addFlag(yesPlaylist, '--yes-playlist');
    addOption(ageLimit, '--age-limit');
    addOption(downloadArchive, '--download-archive');
    addOption(maxDownloads, '--max-downloads');
    addFlag(breakOnExisting, '--break-on-existing');
    addOption(concurrentFragments, '-N');
    addOption(limitRate, '--limit-rate');
    addOption(retries, '--retries');
    addOption(fragmentRetries, '--fragment-retries');
    addFlag(skipUnavailableFragments, '--skip-unavailable-fragments');
    addFlag(keepFragments, '--keep-fragments');
    addOption(bufferSize, '--buffer-size');
    addFlag(noResizeBuffer, '--no-resize-buffer');
    addOption(httpChunkSize, '--http-chunk-size');
    addFlag(playlistRandom, '--playlist-random');
    addFlag(lazyPlaylist, '--lazy-playlist');
    addOption(downloader, '--downloader');
    if (downloaderArgs != null) {
      downloaderArgs!.forEach((key, value) {
        command.addAll(['--downloader-args', '$key:$value']);
      });
    }
    addOption(batchFile, '-a');
    command.addAll(['-P', outputDirectory]); // Set output directory
    if(output != null) {
       output!.forEach((key, value) {
        command.addAll(['-o', '$key:$value']);
      });
    }
    addFlag(restrictFilenames, '--restrict-filenames');
    addOption(trimFilenames, '--trim-filenames');
    addFlag(noOverwrites, '-w');
    addFlag(forceOverwrites, '--force-overwrites');
    addFlag(noContinue, '--no-continue');
    addFlag(noPart, '--no-part');
    addFlag(writeDescription, '--write-description');
    addFlag(writeInfoJson, '--write-info-json');
    addFlag(writePlaylistMetafiles, '--write-playlist-metafiles');
    addFlag(cleanInfoJson, '--clean-info-json');
    addFlag(writeComments, '--write-comments');
    addOption(loadInfoJson, '--load-info-json');
    addOption(cookies, '--cookies');
    addOption(cookiesFromBrowser, '--cookies-from-browser');
    addOption(cacheDir, '--cache-dir');
    addFlag(writeThumbnail, '--write-thumbnail');
    addFlag(writeAllThumbnails, '--write-all-thumbnails');
    addFlag(quiet, '-q');
    addFlag(noWarnings, '--no-warnings');
    addFlag(simulate, '-s');
    addFlag(skipDownload, '--skip-download');
    addList(printTemplate, '-O');
    addFlag(dumpJson, '-j');
    addFlag(dumpSingleJson, '-J');
    addFlag(forceWriteArchive, '--force-write-archive');
    addFlag(noProgress, '--no-progress'); // We always want progress parsing
    command.add('--progress'); // Ensure progress bar is shown for parsing
    command.add('--newline');  // Easier parsing
    addFlag(verbose, '-v');
    addFlag(printTraffic, '--print-traffic');
    addOption(sleepRequests, '--sleep-requests');
    addOption(sleepInterval, '--sleep-interval');
    addOption(maxSleepInterval, '--max-sleep-interval');
    addOption(format, '-f');
    addOption(formatSort, '-S');
    addFlag(formatSortForce, '--format-sort-force');
    addFlag(videoMultistreams, '--video-multistreams');
    addFlag(audioMultistreams, '--audio-multistreams');
    addOption(mergeOutputFormat, '--merge-output-format');
    addFlag(writeSubs, '--write-subs');
    addFlag(writeAutoSubs, '--write-auto-subs');
    addOption(subFormat, '--sub-format');
    addOption(subLangs, '--sub-langs');
    addOption(username, '-u');
    addOption(password, '-p');
    addOption(twofactor, '-2');
    addOption(videoPassword, '--video-password');
    addOption(netrcLocation, '--netrc-location');
    addFlag(extractAudio, '-x');
    addOption(audioFormat, '--audio-format');
    addOption(audioQuality, '--audio-quality');
    addOption(remuxVideo, '--remux-video');
    addOption(recodeVideo, '--recode-video');
    if (postprocessorArgs != null) {
      postprocessorArgs!.forEach((key, value) {
        command.addAll(['--postprocessor-args', '$key:$value']);
      });
    }
    addFlag(keepVideo, '-k');
    addFlag(embedSubs, '--embed-subs');
    addFlag(embedThumbnail, '--embed-thumbnail');
    addFlag(embedMetadata, '--embed-metadata');
    addFlag(embedChapters, '--embed-chapters');
    addFlag(embedInfoJson, '--embed-info-json');
    addOption(ffmpegLocation, '--ffmpeg-location');
    addOption(convertSubs, '--convert-subs');
    addOption(convertThumbnails, '--convert-thumbnails');
    addFlag(splitChapters, '--split-chapters');
    addFlag(forceKeyframesAtCuts, '--force-keyframes-at-cuts');
    addOption(sponsorblockMark?.join(','), '--sponsorblock-mark');
    addOption(sponsorblockRemove?.join(','), '--sponsorblock-remove');
    addOption(sponsorblockApi, '--sponsorblock-api');
    
    // Final URL(s)
    command.addAll(url.split('\n').where((u) => u.trim().isNotEmpty));

    return command;
  }
}
