import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/adb_service.dart';
import '../../domain/models/file_item.dart';
import '../../domain/models/pagination_result.dart';

part 'file_manager_repository.g.dart';

@riverpod
class FileManagerRepository extends _$FileManagerRepository {
  @override
  FileManagerRepository build() => this;

  Future<Either<String, List<String>>> getConnectedDevices() async {
    final adbService = ref.read(adbServiceProvider);
    return adbService.listDevices();
  }

  Future<Either<String, PaginationResult>> listFiles(
    String deviceId,
    String path, {
    int skip = 0,
    int take = 50,
  }) async {
    final adbService = ref.read(adbServiceProvider);
    final result = await adbService.listFiles(deviceId, path);

    return result.map((filesList) {
      final allFiles = filesList.map((fileStr) {
        final file = FileItem.fromString(fileStr);
        return file.copyWith(path: path);
      }).toList();

      // Sort directories first, then by name
      allFiles.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      final totalFiles = allFiles.length;
      final endIndex = skip + take;
      final hasMore = endIndex < totalFiles;

      return PaginationResult(
        files: allFiles.skip(skip).take(take).toList(),
        hasMore: hasMore,
      );
    });
  }

  Future<Either<String, String>> downloadFile(
    String deviceId,
    String remotePath,
    String localPath,
  ) async {
    final adbService = ref.read(adbServiceProvider);
    return adbService.pullFile(deviceId, remotePath, localPath);
  }

  Future<Either<String, String>> uploadFile(
    String deviceId,
    String localPath,
    String remotePath,
  ) async {
    final adbService = ref.read(adbServiceProvider);
    return adbService.pushFile(deviceId, localPath, remotePath);
  }

  Future<Either<String, String>> openFile(
    String deviceId,
    String filePath,
  ) async {
    final adbService = ref.read(adbServiceProvider);
    return adbService.openFile(deviceId, filePath);
  }
}
