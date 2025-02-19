import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/adb_service.dart';
import '../../domain/models/file_item.dart';

part 'file_manager_repository.g.dart';

@riverpod
class FileManagerRepository extends _$FileManagerRepository {
  @override
  FileManagerRepository build() => this;

  Future<Either<String, List<String>>> getConnectedDevices() async {
    final adbService = ref.read(adbServiceProvider);
    return adbService.listDevices();
  }

  Future<Either<String, List<FileItem>>> listFiles(
      String deviceId, String path) async {
    final adbService = ref.read(adbServiceProvider);
    final result = await adbService.listFiles(deviceId, path);

    return result.map((filesList) => filesList.map((fileStr) {
          final file = FileItem.fromString(fileStr);
          return file.copyWith(path: path);
        }).toList());
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
