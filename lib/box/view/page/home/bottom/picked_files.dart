part of '../home.dart';

class _PickedFilesPreview extends StatelessWidget {
   _PickedFilesPreview();

  @override
  Widget build(BuildContext context) {
    return _filesPicked.listenVal((files) {
      return AnimatedContainer(
        height: files.isEmpty ? 0 : 45,
        width: MediaQuery.sizeOf(context).width - 22,
        duration: Durations.long3,
        curve: Curves.fastEaseInToSlowEaseOut,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          separatorBuilder: (_, __) => UIs.width7,
          itemBuilder: (context, index) {
            final fileIdentifier = files[index]; // This string can now be base64 data or a regular path/name
            return _buildFileItem(context, fileIdentifier);
          },
        ),
      );
    });
  }

  Widget _buildFileItem(BuildContext context, String fileIdentifier) {
    Uint8List? decodedBytes;
    String? displayFileName;
    bool isImageCandidate = false; // Flag if it successfully decoded from base64

    try {
      // Attempt to decode the string as base64
      decodedBytes = base64Decode(fileIdentifier);
      isImageCandidate = true;
      displayFileName = 'Image (Decoded)'; // Default name for decoded image
    } on FormatException {
      // If not a valid base64 string, treat it as a regular file path/name
      isImageCandidate = false;
      displayFileName = fileIdentifier.fileNameGetter;
    } catch (e) {
      // Catch any other unexpected errors during decoding
      isImageCandidate = false;
      displayFileName = fileIdentifier.fileNameGetter;
    }

    return Tooltip(
      message: displayFileName ?? libL10n.file,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: RNodes.dark.value ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isImageCandidate && decodedBytes != null)
                  // If base64 decoding was successful, try to display as an image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(
                      decodedBytes,
                      width: 30, // Adjust size as needed
                      height: 30, // Adjust size as needed
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // This callback is triggered if the Image.memory cannot parse the bytes as an image.
                        // This indicates the base64 was valid, but the content wasn't an image.
                        return const Icon(Icons.broken_image, size: 25);
                      },
                    ),
                  )
                else
                  // Fallback for non-base64 strings, or base64 that wasn't an image
                  Icon(Icons.file_copy, size: 19),
                UIs.width7,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Text(
                    displayFileName ?? libL10n.file,
                    overflow: TextOverflow.ellipsis,
                    style: UIs.text13,
                  ),
                ),
              ],
            ),
          ),
          // Remove button
          InkWell(
            onTap: () {
              _filesPicked.value.remove(fileIdentifier);
              _filesPicked.notifyListeners(); // Use notifyListeners instead of notify()
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}