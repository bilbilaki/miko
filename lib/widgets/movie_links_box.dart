  import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:miko/main.dart';
import 'package:miko/screens/dl.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import 'package:provider/provider.dart';

void showDownloadLinkSelection(
      BuildContext context, List<String> links,int id, String title,{bool isForPlay=true}) async {
    var userDataService =
        Provider.of<UserDataService>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select Quality / Source'),
          titleTextStyle: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          backgroundColor: AppColors.secondaryBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: links.map((link) {
            // Try to guess quality from URL (very basic)
            String qualityGuess = "Unknown";
            if (link.contains('1080p'))
              qualityGuess = "1080p ";
            else if (link.contains('720p'))
              qualityGuess = "720p ";
            else if (link.contains('480p'))
              qualityGuess = "480p ";
            else if (link.contains('BluRay'))
              qualityGuess += " BluRay ";
            else if (link.contains('HEVC') || link.contains('x265'))
              qualityGuess += " HEVC ";
            else if (link.contains('x264')) qualityGuess += " x264";

            return SimpleDialogOption(
              onPressed: () async {
                tVmedium(); // Haptic feedback on dialog option tap
                if (isForPlay){
                Navigator.pop(dialogContext); // Close the dialog
                userDataService.toggleIsWatchedLink(
                    id, id, id, links.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      videoName: title,
                      source: link,
                      videoUrl: link),
                  ),
                      );
              }
              else if (isForPlay==false)
              {
                 downloadManager.addDownload(
                            DownloadItem(
                              null, // path will be set internally
                              null, // episodeNumber
                              null, // sessionNumber
                              title, // name
                              isMovie: true,
                              task: DownloadTask(
                                url: link,
                                taskId:
                                    '${title}.${id}', // Added entry.key for unique task ID per resolution
                              ),
                              idC: id, // Dummy ID
                              movieService: MovieService(),
                            ),
                          );

                          tVClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DownloadScreen(
                                downloadManager: downloadManager,
                              ),
                            ),
                          );
                        

              }},
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Text(
                '$qualityGuess - ${Uri.parse(link).host}', // Show quality guess and domain
                style:
                    const TextStyle(color: AppColors.primaryText, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
          ),
          );
                          }).toList(),
        );
      },
    );
  }