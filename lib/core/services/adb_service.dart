import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:process_run/process_run.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as path;

part 'adb_service.g.dart';

class ADBService {
  final Shell _shell = Shell();
  final Map<String, String> _thumbnailCache = {};

  Future<Either<String, List<String>>> listDevices() async {
    try {
      final results = await _shell.run('adb devices');
      final output = results
          .map((result) => result.stdout.toString().trim())
          .join('\n')
          .split('\n')
          .where((line) => line.isNotEmpty && !line.startsWith('List'))
          .map((line) => line.split('\t')[0])
          .toList();

      return right(output);
    } catch (e) {
      return left('Failed to list devices: $e');
    }
  }

  bool isMediaFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.mp4',
      '.mov',
      '.avi',
      '.mkv',
    ].contains(extension);
  }

  Future<Either<String, String>> getThumbnail(
    String deviceId,
    String filePath,
  ) async {
    if (!isMediaFile(filePath)) {
      return left('Not a media file');
    }

    // Check cache first
    if (_thumbnailCache.containsKey(filePath)) {
      final cachedPath = _thumbnailCache[filePath]!;
      if (File(cachedPath).existsSync()) {
        return right(cachedPath);
      } else {
        _thumbnailCache.remove(filePath);
      }
    }

    try {
      // Create a temporary directory for thumbnails if it doesn't exist
      final tempDir = await Directory.systemTemp.createTemp('thumbnails');
      final fileName = path.basename(filePath);
      final thumbnailPath = path.join(tempDir.path, 'thumb_$fileName');

      // Pull the file from the device
      final pullResult = await _shell
          .run('adb -s $deviceId pull "$filePath" "$thumbnailPath"');
      if (pullResult.any((result) => result.exitCode != 0)) {
        await tempDir.delete(recursive: true);
        return left('Failed to download file for thumbnail');
      }

      // Cache the thumbnail path
      _thumbnailCache[filePath] = thumbnailPath;

      // Schedule cleanup after 30 minutes
      Future.delayed(const Duration(minutes: 30), () {
        if (_thumbnailCache.containsKey(filePath)) {
          _thumbnailCache.remove(filePath);
          File(thumbnailPath).parent.delete(recursive: true);
        }
      });

      return right(thumbnailPath);
    } catch (e) {
      return left('Failed to generate thumbnail: $e');
    }
  }

  Future<Either<String, List<String>>> listFiles(
      String deviceId, String path) async {
    try {
      final results = await _shell.run(
          '''adb -s $deviceId shell "cd '$path' && for f in *; do echo \$(stat -c '%A|%U|%G|%s|%Y|%n' "\$f"); done"''');
      final output = results
          .map((result) => result.stdout.toString().trim())
          .join('\n')
          .split('\n')
          .where((line) =>
              line.isNotEmpty && !line.contains('No such file or directory'))
          .toList();

      return right(output);
    } catch (e) {
      return left('Failed to list files: $e');
    }
  }

  Future<Either<String, String>> pullFile(
    String deviceId,
    String remotePath,
    String localPath,
  ) async {
    try {
      await _shell.run('adb -s $deviceId pull "$remotePath" "$localPath"');
      return right('File downloaded successfully');
    } catch (e) {
      return left('Failed to download file: $e');
    }
  }

  Future<Either<String, String>> pushFile(
    String deviceId,
    String localPath,
    String remotePath,
  ) async {
    try {
      await _shell.run('adb -s $deviceId push "$localPath" "$remotePath"');
      return right('File uploaded successfully');
    } catch (e) {
      return left('Failed to upload file: $e');
    }
  }

  Future<Either<String, String>> openFile(
    String deviceId,
    String filePath,
  ) async {
    try {
      // Create a temporary directory to store the file
      final tempDir = await Directory.systemTemp.createTemp('file_viewer');
      final fileName = path.basename(filePath);
      final localPath = path.join(tempDir.path, fileName);

      // Pull the file from the device
      final pullResult =
          await _shell.run('adb -s $deviceId pull "$filePath" "$localPath"');
      if (pullResult.any((result) => result.exitCode != 0)) {
        await tempDir.delete(recursive: true);
        return left('Failed to download file');
      }

      // Open the file with the system's default application
      if (Platform.isMacOS) {
        await _shell.run('open "$localPath"');
      } else if (Platform.isLinux) {
        await _shell.run('xdg-open "$localPath"');
      } else if (Platform.isWindows) {
        await _shell.run('start "" "$localPath"');
      } else {
        await tempDir.delete(recursive: true);
        return left('Unsupported platform');
      }

      // Schedule cleanup after a delay (e.g., 5 minutes)
      Future.delayed(const Duration(minutes: 5), () {
        tempDir.delete(recursive: true);
      });

      return right('File opened successfully');
    } catch (e) {
      return left('Failed to open file: $e');
    }
  }
}

@Riverpod(keepAlive: true)
ADBService adbService(Ref ref) {
  return ADBService();
}
