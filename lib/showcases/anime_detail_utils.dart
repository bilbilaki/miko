import 'package:flutter/material.dart';
import 'package:miko/utils/utils.dart';

import 'person_detail_page.dart';

/// Utility class for anime/TV show detail pages
class AnimeDetailUtils {
  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Returning Series':
        return Colors.green;
      case 'Ended':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      case 'In Production':
        return Colors.blue;
      case 'Pilot':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Get episode type color based on episode type
  static Color getEpisodeTypeColor(String episodeType) {
    switch (episodeType) {
      case 'finale':
        return Colors.red.shade700;
      case 'mid_season':
        return Colors.orange.shade700;
      case 'premiere':
        return Colors.green.shade700;
      default:
        return Colors.blueGrey.shade700; // Standard or other
    }
  }

  /// Get rating color based on rating value
  static Color getRatingColor(double rating) {
    if (rating >= 7.5) return Colors.green.shade700;
    if (rating >= 5.0) return Colors.orange.shade700;
    if (rating > 0) return Colors.red.shade700;
    return Colors.blueGrey.shade700;
  }
}

  void navigateToPersonDetail(BuildContext context ,int personId, String name, String? profilePath) {
    tVClick();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailPage(
          personId: personId,
          initialName: name,
          initialProfilePath: profilePath,
        ),
      ),
    );
  }


Future<String?> showTextInputDialog(
  BuildContext context, userDataService,{
  String title = 'Enter Your Prefred Language',
  String? initialText,
  String hintText = 'Like Arabic , Ar ...',
  TextCapitalization textCapitalization = TextCapitalization.sentences,
  TextInputType keyboardType = TextInputType.text,
}) async {
   TextEditingController textEditingController =
      TextEditingController(text: initialText);

  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: textEditingController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: textCapitalization,
          keyboardType: keyboardType,
          onSubmitted: (value) {
            // Allow submitting by pressing Enter/Done on keyboard
            Navigator.of(dialogContext).pop(value);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(null); // Return null on cancel
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
        await  userDataService.setCustoombaseurl(textEditingController.text);

              Navigator.of(dialogContext)
                  .pop(textEditingController.text); // Return entered text
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

