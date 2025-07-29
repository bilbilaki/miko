// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:resumable_downloader/resumable_downloader.dart';



// class DownloadmanagerService {


//   late final DownloadManager _downloadManager;

//   Future<void> init() async {
//     final baseDirectory = await getApplicationDocumentsDirectory();
//     _downloadManager = DownloadManager(
//       subDir: "Miko Downloads",
//       fileExistsStrategy: FileExistsStrategy.resume,
//       baseDirectory: baseDirectory,
//       maxConcurrentDownloads: 3,
//       maxRetries: 3,
//       delayBetweenRetries: Duration.zero,
//       logger: (logRecord) {
//         logger.log(switch (logRecord.level) {
//           LogLevel.debug => Level.debug,
//           LogLevel.error => Level.error,
//           LogLevel.warning => Level.warning,
//           LogLevel.info => Level.info,
//         }, 'Download: ${logRecord.message}');
//       },
//     );
//   }

// }