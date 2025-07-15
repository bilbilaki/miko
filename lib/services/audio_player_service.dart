import 'dart:convert';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerService {
  final _player = AudioPlayer();

  Future<void> playBase64Audio(String base64Data, String format) async {
    try {
      final bytes = base64Decode(base64Data);
      final directory = await getTemporaryDirectory();
      final tempFile = File('${directory.path}/temp_audio.$format');
      await tempFile.writeAsBytes(bytes);

      await _player.setFilePath(tempFile.path);
      await _player.play();
      // Optionally delete the temporary file after playing
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          tempFile.delete().catchError((e) {
            print('Error deleting temp audio file: $e');
          });
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}