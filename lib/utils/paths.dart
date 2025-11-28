import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<Directory> getTargetDirectory({
  required String folderUnderApp,
  String userSubdir = '',
  String appFolderName = 'Miko',
  bool ensureExists = true,
}) async {
  late final Directory baseDir;
  if (Platform.isAndroid) {
    // Use app-specific directory (no permission needed)
    baseDir = await getApplicationDocumentsDirectory();
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

  String targetPath = p.join(baseDir.path, appFolderName);
  if (folderUnderApp.isNotEmpty) {
    targetPath = p.join(targetPath, folderUnderApp);
  }
  if (userSubdir.isNotEmpty) targetPath = p.join(targetPath, userSubdir);

  final dir = Directory(targetPath);
  if (ensureExists && !await dir.exists()) {
    await dir.create(recursive: true);
  }
  return dir;
}

String joinPath(String a, String b) => p.join(a, b);
