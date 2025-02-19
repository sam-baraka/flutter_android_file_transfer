import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import '../providers/file_manager_provider.dart';
import '../../domain/models/file_item.dart';
import '../widgets/connection_guide_dialog.dart';
import '../../../../core/services/adb_service.dart';
import 'package:path/path.dart' as path;

class FileManagerScreen extends ConsumerStatefulWidget {
  const FileManagerScreen({super.key});

  @override
  ConsumerState<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends ConsumerState<FileManagerScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(fileManagerNotifierProvider.notifier).refreshDevices();
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      ref.read(fileManagerNotifierProvider.notifier).refreshDevices();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _showConnectionGuide() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const ConnectionGuideDialog(),
      ),
    );
  }

  Future<void> _downloadFile(FileItem file, String deviceId) async {
    try {
      String? downloadPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save ${file.name}',
        fileName: file.name,
      );

      if (downloadPath != null) {
        final filePath = '${file.path}/${file.name}'.replaceAll('//', '/');
        await ref.read(fileManagerNotifierProvider.notifier).downloadFile(
              deviceId,
              filePath,
              downloadPath,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('File downloaded successfully'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(8),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
          ),
        );
      }
    }
  }

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
        return Icons.image;
      case '.mp4':
      case '.mov':
      case '.avi':
        return Icons.video_file;
      case '.mp3':
      case '.wav':
      case '.m4a':
        return Icons.audio_file;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.xls':
      case '.xlsx':
        return Icons.table_chart;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      case '.zip':
      case '.rar':
      case '.7z':
        return Icons.folder_zip;
      case '.apk':
        return Icons.android;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileManagerNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Android File Manager',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showConnectionGuide,
            tooltip: 'Connection Guide',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(fileManagerNotifierProvider.notifier).refreshDevices(),
            tooltip: 'Refresh Devices',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDeviceSelector(state),
          if (state.error.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.error,
                      style: TextStyle(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (state.isLoading)
            const LinearProgressIndicator()
          else if (state.selectedDevice.isNotEmpty)
            Expanded(child: _buildFileList(state))
          else if (state.devices.isEmpty && !state.isLoading)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.devices_other,
                      size: 64,
                      color: colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No devices found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connect a device via USB or wireless debugging',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showConnectionGuide,
                      icon: const Icon(Icons.help_outline),
                      label: const Text('How to Connect a Device'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelector(FileManagerState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select a device'),
                  value: state.selectedDevice.isEmpty
                      ? null
                      : state.selectedDevice,
                  items: state.devices.map((device) {
                    return DropdownMenuItem(
                      value: device,
                      child: Text(device),
                    );
                  }).toList(),
                  onChanged: (deviceId) {
                    if (deviceId != null) {
                      ref
                          .read(fileManagerNotifierProvider.notifier)
                          .selectDevice(deviceId);
                    }
                  },
                ),
              ),
            ),
          ),
          if (state.currentPath.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPathButton(
                      icon: Icons.home,
                      label: 'Home',
                      onPressed: () => ref
                          .read(fileManagerNotifierProvider.notifier)
                          .navigateToDirectory('/storage/emulated/0'),
                    ),
                    ...state.currentPath
                        .split('/')
                        .where((part) => part.isNotEmpty)
                        .map((part) => _buildPathButton(
                              label: part,
                              onPressed: () {
                                final newPath = '/' +
                                    state.currentPath
                                        .split('/')
                                        .takeWhile((p) => p != part)
                                        .followedBy([part])
                                        .where((p) => p.isNotEmpty)
                                        .join('/');
                                ref
                                    .read(fileManagerNotifierProvider.notifier)
                                    .navigateToDirectory(newPath);
                              },
                            )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPathButton({
    IconData? icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 4),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(FileManagerState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: state.files.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final file = state.files[index];
            return _buildFileListTile(file, state.selectedDevice);
          },
        ),
      ),
    );
  }

  Widget _buildFileListTile(FileItem file, String deviceId) {
    return ListTile(
      leading: _buildFileIcon(file, deviceId),
      title: Text(
        file.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${file.permissions} - ${file.owner}:${file.group} - ${_formatSize(file.size)}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: file.isDirectory
          ? const Icon(Icons.chevron_right)
          : IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showFileOptions(file, deviceId),
            ),
      onTap: () {
        if (file.isDirectory) {
          final newPath = '${file.path}/${file.name}'.replaceAll('//', '/');
          ref
              .read(fileManagerNotifierProvider.notifier)
              .navigateToDirectory(newPath);
        } else {
          _showFileOptions(file, deviceId);
        }
      },
    );
  }

  Widget _buildFileIcon(FileItem file, String deviceId) {
    if (file.isDirectory) {
      return Icon(
        Icons.folder,
        color: Theme.of(context).colorScheme.primary,
        size: 40,
      );
    }

    final filePath = '${file.path}/${file.name}'.replaceAll('//', '/');
    final adbService = ref.read(adbServiceProvider);

    if (adbService.isMediaFile(file.name)) {
      return FutureBuilder<Either<String, String>>(
        future: adbService.getThumbnail(deviceId, filePath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.fold(
              (error) => _buildDefaultFileIcon(file),
              (thumbnailPath) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(
                  File(thumbnailPath),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultFileIcon(file),
                ),
              ),
            );
          }
          return const SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        },
      );
    }

    return _buildDefaultFileIcon(file);
  }

  Widget _buildDefaultFileIcon(FileItem file) {
    return Icon(
      _getFileIcon(file.name),
      color: Theme.of(context).colorScheme.onSurface,
      size: 40,
    );
  }

  String _formatSize(int size) {
    const units = ['B', 'KB', 'MB', 'GB'];
    var index = 0;
    double fileSize = size.toDouble();

    while (fileSize >= 1024 && index < units.length - 1) {
      fileSize /= 1024;
      index++;
    }

    return '${fileSize.toStringAsFixed(2)} ${units[index]}';
  }

  void _showFileOptions(FileItem file, String deviceId) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          title: Row(
            children: [
              Icon(
                _getFileIcon(file.name),
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  file.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.straighten, 'Size', _formatSize(file.size)),
              _buildInfoRow(Icons.person_outline, 'Owner', file.owner),
              _buildInfoRow(Icons.group_outlined, 'Group', file.group),
              _buildInfoRow(
                  Icons.lock_outline, 'Permissions', file.permissions),
              _buildInfoRow(
                Icons.access_time,
                'Modified',
                file.modifiedTime.toString(),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open'),
              onPressed: () async {
                Navigator.pop(context);
                final filePath =
                    '${file.path}/${file.name}'.replaceAll('//', '/');
                final result = await ref
                    .read(fileManagerNotifierProvider.notifier)
                    .openFile(deviceId, filePath);

                if (mounted) {
                  if (result.isLeft()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.fold(
                          (error) => error,
                          (_) => 'Unknown error occurred',
                        )),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(8),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Opening file...'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(8),
                      ),
                    );
                  }
                }
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Download'),
              onPressed: () {
                Navigator.pop(context);
                _downloadFile(file, deviceId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
