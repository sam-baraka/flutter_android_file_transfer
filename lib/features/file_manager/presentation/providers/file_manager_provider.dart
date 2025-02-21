import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../data/repositories/file_manager_repository.dart';
import '../../domain/models/file_item.dart';
import 'ui_state_providers.dart';
import 'package:path/path.dart' as path;

part 'file_manager_provider.freezed.dart';
part 'file_manager_provider.g.dart';

@freezed
class FileManagerState with _$FileManagerState {
  const factory FileManagerState({
    @Default([]) List<String> devices,
    @Default([]) List<FileItem> files,
    @Default('') String currentPath,
    @Default('') String selectedDevice,
    @Default('') String error,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default(0) int currentPage,
    @Default(50) int itemsPerPage,
  }) = _FileManagerState;
}

@Riverpod(keepAlive: true)
class FileManagerNotifier extends _$FileManagerNotifier {
  late final FileManagerRepository _repository;

  @override
  FileManagerState build() {
    _repository = ref.read(fileManagerRepositoryProvider);
    return const FileManagerState();
  }

  List<FileItem> _filterFilesByType(List<FileItem> files, FileType fileType) {
    if (fileType == FileType.all) return files;
    if (fileType == FileType.folders)
      return files.where((file) => file.isDirectory).toList();

    final extensions = fileTypeMatchers[fileType] ?? [];
    return files.where((file) {
      if (fileType == FileType.folders && file.isDirectory) return true;
      final extension = path.extension(file.name).toLowerCase();
      return extensions.contains(extension);
    }).toList();
  }

  Future<void> refreshDevices() async {
    state = state.copyWith(isLoading: true, error: '');

    final result = await _repository.getConnectedDevices();

    result.fold(
      (error) => state = state.copyWith(error: error, isLoading: false),
      (devices) => state = state.copyWith(devices: devices, isLoading: false),
    );
  }

  Future<void> selectDevice(String deviceId) async {
    state = state.copyWith(
      selectedDevice: deviceId,
      currentPath: '/storage/emulated/0',
      files: [],
      currentPage: 0,
    );
    listFiles('/storage/emulated/0');
  }

  Future<void> listFiles(String path) async {
    if (state.selectedDevice.isEmpty) return;

    state = state.copyWith(
      isLoading: true,
      error: '',
      currentPage: 0,
      files: [],
    );

    final result = await _repository.listFiles(
      state.selectedDevice,
      path,
      skip: 0,
      take: state.itemsPerPage,
    );

    result.fold(
      (error) => state = state.copyWith(error: error, isLoading: false),
      (filesResult) {
        final fileType = ref.read(selectedFileTypeProvider);
        final filteredFiles = _filterFilesByType(filesResult.files, fileType);

        state = state.copyWith(
          files: filteredFiles,
          currentPath: path,
          isLoading: false,
          hasMore: filesResult.hasMore,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.listFiles(
      state.selectedDevice,
      state.currentPath,
      skip: nextPage * state.itemsPerPage,
      take: state.itemsPerPage,
    );

    result.fold(
      (error) => state = state.copyWith(error: error, isLoading: false),
      (filesResult) {
        final fileType = ref.read(selectedFileTypeProvider);
        final filteredFiles = _filterFilesByType(filesResult.files, fileType);

        state = state.copyWith(
          files: [...state.files, ...filteredFiles],
          currentPage: nextPage,
          hasMore: filesResult.hasMore,
          isLoading: false,
        );
      },
    );
  }

  Future<void> navigateToDirectory(String path) async {
    await listFiles(path);
  }

  Future<void> downloadFile(
    String deviceId,
    String remotePath,
    String localPath,
  ) async {
    state = state.copyWith(isLoading: true, error: '');

    final result = await _repository.downloadFile(
      deviceId,
      remotePath,
      localPath,
    );

    result.fold(
      (error) => state = state.copyWith(error: error, isLoading: false),
      (success) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> uploadFile(String localPath, String remotePath) async {
    if (state.selectedDevice.isEmpty) return;

    state = state.copyWith(isLoading: true, error: '');

    final result = await _repository.uploadFile(
      state.selectedDevice,
      localPath,
      remotePath,
    );

    result.fold(
      (error) => state = state.copyWith(error: error, isLoading: false),
      (success) {
        state = state.copyWith(isLoading: false);
        listFiles(state.currentPath);
      },
    );
  }

  Future<Either<String, String>> openFile(
      String deviceId, String filePath) async {
    state = state.copyWith(isLoading: true, error: '');

    final result = await _repository.openFile(deviceId, filePath);

    result.fold(
      (error) => state = state.copyWith(error: error, isLoading: false),
      (success) => state = state.copyWith(isLoading: false),
    );

    return result;
  }
}
