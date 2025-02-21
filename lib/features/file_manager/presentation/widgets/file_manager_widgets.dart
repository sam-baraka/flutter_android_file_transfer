import 'dart:io';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/models/file_item.dart';
import '../providers/file_manager_provider.dart';
import '../providers/device_monitor_provider.dart';
import '../providers/ui_state_providers.dart';
import '../utils/file_utils.dart';
import '../../../../core/services/adb_service.dart';
import 'package:path/path.dart' as path;
import 'animated_widgets.dart';
import 'connection_guide_dialog.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class FileManagerSidebar extends ConsumerWidget {
  const FileManagerSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    final selectedFileType = ref.watch(selectedFileTypeProvider);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonHideUnderline(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
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
          SidebarItem(
            icon: Icons.folder_outlined,
            label: 'All Files',
            selected: selectedFileType == FileType.all,
            onTap: () => _selectFileType(ref, FileType.all),
          ),
          SidebarItem(
            icon: Icons.folder_outlined,
            label: 'Folders',
            selected: selectedFileType == FileType.folders,
            onTap: () => _selectFileType(ref, FileType.folders),
          ),
          SidebarItem(
            icon: Icons.description_outlined,
            label: 'Documents',
            selected: selectedFileType == FileType.documents,
            onTap: () => _selectFileType(ref, FileType.documents),
          ),
          SidebarItem(
            icon: Icons.image_outlined,
            label: 'Images',
            selected: selectedFileType == FileType.images,
            onTap: () => _selectFileType(ref, FileType.images),
          ),
          SidebarItem(
            icon: Icons.movie_outlined,
            label: 'Videos',
            selected: selectedFileType == FileType.videos,
            onTap: () => _selectFileType(ref, FileType.videos),
          ),
          SidebarItem(
            icon: Icons.music_note_outlined,
            label: 'Music',
            selected: selectedFileType == FileType.music,
            onTap: () => _selectFileType(ref, FileType.music),
          ),
          SidebarItem(
            icon: Icons.download_outlined,
            label: 'Downloads',
            selected: selectedFileType == FileType.downloads,
            onTap: () => _selectFileType(ref, FileType.downloads),
          ),
          const Spacer(),
          ScaleOnHover(
            child: SidebarItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectFileType(WidgetRef ref, FileType fileType) {
    ref.read(selectedFileTypeProvider.notifier).state = fileType;
    // Refresh the current directory with the new filter
    final notifier = ref.read(fileManagerNotifierProvider.notifier);
    final currentPath = ref.read(fileManagerNotifierProvider).currentPath;
    if (currentPath.isNotEmpty) {
      notifier.listFiles(currentPath);
    }
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileManagerToolbar extends ConsumerWidget {
  const FileManagerToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    final isGridView = ref.watch(isGridViewProvider);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          if (state.currentPath.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => ref
                  .read(fileManagerNotifierProvider.notifier)
                  .navigateToDirectory('/storage/emulated/0'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.currentPath
                      .split('/')
                      .where((part) => part.isNotEmpty)
                      .map((part) => BreadcrumbItem(part: part))
                      .toList(),
                ),
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () =>
                ref.read(isGridViewProvider.notifier).state = !isGridView,
            tooltip: isGridView ? 'List view' : 'Grid view',
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {},
            tooltip: 'Upload file',
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () {},
            tooltip: 'New folder',
          ),
        ],
      ),
    );
  }
}

class BreadcrumbItem extends ConsumerWidget {
  final String part;

  const BreadcrumbItem({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.chevron_right, size: 20),
        TextButton(
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
          child: Text(part),
        ),
      ],
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String error;

  const ErrorDisplay({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
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
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ScaleOnHover(
        scale: 1.02,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.devices_other,
                size: 64,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'No Device Connected',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connect your Android device via USB\nand enable USB debugging',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.help_outline),
                label: const Text('Connection Guide'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => showConnectionGuide(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileIconWidget extends ConsumerWidget {
  final FileItem file;

  const FileIconWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    final adbService = ref.read(adbServiceProvider);

    if (file.isDirectory) {
      return Icon(
        Icons.folder,
        color: Theme.of(context).colorScheme.primary,
        size: 40,
      );
    }

    final filePath = '${file.path}/${file.name}'.replaceAll('//', '/');

    if (adbService.isMediaFile(file.name)) {
      return FutureBuilder<Either<String, String>>(
        future: adbService.getThumbnail(state.selectedDevice, filePath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.fold(
              (error) => _buildDefaultIcon(context),
              (thumbnailPath) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(
                  File(thumbnailPath),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultIcon(context),
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

    return _buildDefaultIcon(context);
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return Icon(
      getFileIcon(file.name),
      color: Theme.of(context).colorScheme.onSurface,
      size: 40,
    );
  }
}

IconData getFileIcon(String fileName) {
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

class FileGridView extends ConsumerWidget {
  const FileGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!state.isLoading &&
              state.hasMore &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent * 0.9) {
            ref.read(fileManagerNotifierProvider.notifier).loadMore();
          }
          return true;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: state.files.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.files.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return FileGridTile(file: state.files[index]);
          },
        ),
      ),
    );
  }
}

class FileGridTile extends ConsumerWidget {
  final FileItem file;

  const FileGridTile({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    final selectedFile = ref.watch(selectedFileProvider);
    final isSelected = selectedFile == file;

    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ref.read(selectedFileProvider.notifier).state = file;
          if (file.isDirectory) {
            final newPath = '${file.path}/${file.name}'.replaceAll('//', '/');
            ref
                .read(fileManagerNotifierProvider.notifier)
                .navigateToDirectory(newPath);
          } else {
            showFileOptions(context, file, state.selectedDevice);
          }
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FileIconWidget(file: file),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    file.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPanel extends ConsumerWidget {
  final FileItem file;

  const DetailsPanel({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FileIconWidget(file: file),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        file.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(
                      icon: Icons.straighten,
                      label: 'Size',
                      value: formatSize(file.size)),
                  InfoRow(
                      icon: Icons.person_outline,
                      label: 'Owner',
                      value: file.owner),
                  InfoRow(
                      icon: Icons.group_outlined,
                      label: 'Group',
                      value: file.group),
                  InfoRow(
                      icon: Icons.lock_outline,
                      label: 'Permissions',
                      value: file.permissions),
                  InfoRow(
                    icon: Icons.access_time,
                    label: 'Modified',
                    value: file.modifiedTime.toString(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                  onPressed: () async {
                    final filePath =
                        '${file.path}/${file.name}'.replaceAll('//', '/');
                    final result = await ref
                        .read(fileManagerNotifierProvider.notifier)
                        .openFile(state.selectedDevice, filePath);

                    if (context.mounted) {
                      if (result.isLeft()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.fold(
                              (error) => error,
                              (_) => 'Unknown error occurred',
                            )),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
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
                  onPressed: () =>
                      downloadFile(context, file, state.selectedDevice, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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

Future<void> downloadFile(
    BuildContext context, FileItem file, String deviceId, WidgetRef ref) async {
  try {
    String? downloadPath = await picker.FilePicker.platform.saveFile(
      dialogTitle: 'Save ${file.name}',
      fileName: file.name,
    );

    if (downloadPath != null && context.mounted) {
      final filePath = '${file.path}/${file.name}'.replaceAll('//', '/');
      await ref.read(fileManagerNotifierProvider.notifier).downloadFile(
            deviceId,
            filePath,
            downloadPath,
          );

      if (context.mounted) {
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
    if (context.mounted) {
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
