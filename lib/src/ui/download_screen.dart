// lib/ui/download_screen.dart
// Sort changed to use stable ordering: status priority then createdAt.

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:lottie/lottie.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/src/ui/widgets/download_list_item.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
Future<Directory> getTargetDirectory({
  required String folderUnderApp,
  String userSubdir = '',
  String appFolderName = 'Miko',
  bool ensureExists = true,
}) async {
  // Determine the base download directory per platform.
  late final Directory baseDir;
  if (Platform.isAndroid) {
    baseDir = Directory('/storage/emulated/0/Download');
  } else if (Platform.isLinux) {
    baseDir = Directory(p.join(Platform.environment['HOME']!, 'Downloads'));
  } else if (Platform.isWindows) {
    baseDir = Directory(
      p.join(Platform.environment['USERPROFILE']!, 'Downloads'),
    );
  } else {
    final Directory? downloadsDir = await getDownloadsDirectory();
    baseDir = downloadsDir ?? await getApplicationDocumentsDirectory();
  }

  // Build: base/<appFolderName>/<folderUnderApp>/<userSubdir?>
  String targetPath = p.join(baseDir.path, appFolderName);
  if (folderUnderApp.isNotEmpty) {
    targetPath = p.join(targetPath, folderUnderApp);
  }
  if (userSubdir.isNotEmpty) {
    targetPath = p.join(targetPath, userSubdir);
  }

  final dir = Directory(targetPath);

  if (ensureExists && !await dir.exists()) {
    await dir.create(recursive: true);
  }

  return dir;
}


class DownloadItem{
final bool isMovie;
 int idC;
final int? sessionNumber;
final int? episodeNumber;
final String? name;
 DownloadTask task;
String? path;
 void Function(double)? onProgress;
 MovieService movieService;
 void Function(TaskStatus)? onStatus;
DownloadItem(this.path,this.episodeNumber,this.sessionNumber,this.name,{required this.isMovie,required this.task,required this.idC,required this.onProgress,required this.movieService,required this.onStatus}){
  
 run();
}
 void run()async { pre();
  post();
 }
void pre()async{
await prePair();
}

Future<void> prePair()async{
if (path==null){
Directory setDefaultPathIfNoneSet= await getTargetDirectory(folderUnderApp: "Downlooads"); 
if(isMovie){
final  realItem = await movieService.getMovieDetails(movieId: idC);
 String origName= realItem.title; 
final finalPath = p.dirname('${setDefaultPathIfNoneSet.path}/${name ?? origName}');

String targetPath=  await Directory(finalPath).exists() ==false? 
 p.join(setDefaultPathIfNoneSet.path, name??origName):finalPath;
path = targetPath; 


}else {
final realItem = await movieService.getTvShowDetails(tvShowId: idC);
        String origName = realItem.name; 

final finalPath = p.dirname(
          '${setDefaultPathIfNoneSet.path}/${name??origName}/S$sessionNumber',
        );
String targetPath = await Directory(finalPath).exists() == false
            ? p.join(setDefaultPathIfNoneSet.path, name ?? origName)
            : finalPath;
path=targetPath;

}
}

}
void post()async{
await inDownloading();

}
Future<void> inDownloading()async{
    try {
 final result= await FileDownloader().download(task,
    onProgress: onProgress,
    onStatus: onStatus
);

  switch (result.status) {
  case TaskStatus.complete:
    print('Success!');
final file= await result.task.filePath();
await inTransfering(file);


  case TaskStatus.canceled:
    print('Download was canceled');

  case TaskStatus.paused:
    print('Download was paused');

  default:
    print('Download not successful');
  }
}
catch (e) {
      print(e.toString());
    }

}
  

  Future<void> pauseDownload() async {
    await FileDownloader().pause(task);
  }

  Future<void> cancelDownload() async {
    await FileDownloader().cancelTaskWithId(task.taskId).whenComplete(() {
    });
  }

  Future<void> resumeDownload() async {
    await FileDownloader().resume(task);
  }

Future<void> inTransfering(String targetFile)async{
    try {
      // Get the filename from source (e.g., 'blala.mp4')
 

      // Move the file
      await File(targetFile).rename(path!);
      print('File moved successfully to $path from $targetFile');
    } catch (e) {
      print('Failed to move file: $e');
    }

}

}




// Act on the result

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  // status priority: lower = higher priority (shows first)
  static const  _statusOrder = {
    // TaskStatus.running: 0,
    // TaskStatus.queued: 1,
    // TaskStatus.paused: 2,
    // TaskStatus.failed: 3,
    // TaskStatus.canceled: 4,
    // TaskStatus.complete: 5,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsMap = null;
    final records = recordsMap.values.toList();

    records.sort((a, b) {
      final sa = _statusOrder[a.status] ?? 99;
      final sb = _statusOrder[b.status] ?? 99;
      if (sa != sb) return sa.compareTo(sb);
      // stable tiebreaker: createdAt ascending (older first)
      return a.createdAt.compareTo(b.createdAt);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            Icons.cloud_download,
            color: const Color(0xFF00C853),
            size: 28,
          ),
        ),
        title: const Text(
          'Download',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context, ref),
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
      child: records.isEmpty
        ? Center(child: _buildEmptyState(context))
              : ListView.separated(
                  key: const ValueKey('list'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final r = records[idx];
                    return SizedBox();
                    
                    
                    // DownloadListItem(
                    //   record: r,
                    //   onDelete: () =>
                    //       _confirmDelete(context, ref, r.task?.id ?? r.taskId),
                    //   onCancel: () {
                    //     ref
                    //         .read(downloadNotifierProvider.notifier)
                    //         .cancel(r.taskId);
                    //   },
                    //   onPause: () {
                    //     ref
                    //         .read(downloadNotifierProvider.notifier)
                    //         .pause(r.taskId);
                    //   },
                    //   onResume: () {
                    //     ref
                    //         .read(downloadNotifierProvider.notifier)
                    //         .resume(r.taskId);
                    //   },
                    //   onRetry: () {
                    //     final task = r.task;
                    //     if (task != null) {
                    //       ref
                    //           .read(downloadNotifierProvider.notifier)
                    //           .enqueue(task);
                    //     }
                    //   },
                    // );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(context, ref),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showAddDialog(BuildContext ctx, WidgetRef ref) async {
    final urlCtrl = TextEditingController();
    final filenameCtrl = TextEditingController();
    final dirCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16161A),
          title: const Text('Add Download'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://...',
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: filenameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Filename (optional)',
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dirCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Directory (optional)',
                  filled: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async{
                if (urlCtrl.text.trim().isEmpty) return;
                final nid= Random(0).nextInt(100000);
                MovieService movieService=MovieService();
          
       //   DownloadItem( isMovie: true, task: DownloadTask(url: urlCtrl.text.trim(), taskId: '$nid'), onProgress: null, movieService: movieService, onStatus: null, idC: nid, ).run;
              
                Navigator.of(context).pop(true);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final url = urlCtrl.text.trim();
      final filename = filenameCtrl.text.trim();
      final dir = dirCtrl.text.trim();

      // final t = DownloadTask(
      //   url: url,
      //   filename: filename.isNotEmpty ? filename : url,
      //   directory: dir,
      // );
    //  await ref.read(downloadNotifierProvider.notifier).enqueue(t);
    }
  }

  // Future<void> _confirmDelete(
  //   BuildContext ctx,
  //   WidgetRef ref,
  //   String taskId,
  // ) async {
  //   final confirmed = await showModalBottomSheet<bool>(
  //     context: ctx,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (_) => DeleteConfirmSheet(taskId: taskId),
  //   );
  //   if (confirmed == true) {
  //     // delete fully (store + file if possible)
  //   //  await ref
  //     //    .read(downloadNotifierProvider.notifier)
  //        // .deleteCompletely(taskId);
  // // The DownloadNotifier updates its own state; no direct external
  // // mutation of notifier.state is allowed. Rely on the notifier's
  // // internal delete logic and state updates.
  //   }
  // }

    Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/Lottie/no_schedule.json', // Placeholder, replace with your Lottie animation
          repeat: true,
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 24),
        const Text(
          'No Download Yet ',
          style: TextStyle(
            color: Color(0xFF1ED760),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Sorry, there is no Download Why You not addTask now',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double progressPer = 0;
  late DownloadTask task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          CircularPercentIndicator(
            radius: 130.0,
            animation: true,
            animationDuration: 100,
            lineWidth: 15.0,
            percent: progressPer.toDouble(),
            animateFromLastPercent: true,
            center: Text(
              "${(progressPer * 100).toStringAsFixed(2)}%",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.grey.shade300,
            progressColor: Colors.green,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: IconButton(
                        onPressed: () async {
                          await pauseDownload();
                        },
                        icon: const Icon(Icons.pause))),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: IconButton(
                        onPressed: () async {
                          await resumeDownload();
                        },
                        icon: const Icon(Icons.play_arrow))),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: IconButton(
                        onPressed: () async {
                          await cancelDownload();
                        },
                        icon: const Icon(Icons.close))),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          )
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await downloadFile();
        },
        child: const Text("Download"),
      ),
    );
  }

  Future<void> downloadFile() async {
    try {
      task = DownloadTask(
          url:
              "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-MP4-Video-File-Download.mp4",
          filename: "sampleVideo",
          directory: 'my_sub_directory',
          updates: Updates.statusAndProgress,
          requiresWiFi: true,
          retries: 5,
          allowPause: true,
          metaData: 'data for me');

      await FileDownloader().download(
        task,
        onProgress: (value) {
          if (!value.isNegative) {
            progressPer = value;
            setState(() {});
          }
        },
        onStatus: (status) {
          print(status);
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  pauseDownload() async {
    await FileDownloader().pause(task);
  }

  cancelDownload() async {
    await FileDownloader().cancelTaskWithId(task.taskId).whenComplete(() {
      setState(() {
        progressPer = 0;
      });
    });
  }

  resumeDownload() async {
    await FileDownloader().resume(task);
  }
}