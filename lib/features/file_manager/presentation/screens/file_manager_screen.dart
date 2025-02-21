import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import '../providers/file_manager_provider.dart';
import '../providers/device_monitor_provider.dart';
import '../providers/ui_state_providers.dart';
import '../widgets/file_manager_widgets.dart';
import '../utils/file_utils.dart';
import '../widgets/connection_guide_dialog.dart';
import '../widgets/file_preview_dialog.dart';
import '../../../../core/services/adb_service.dart';
import 'package:path/path.dart' as path;
import '../../domain/models/file_item.dart';

// Selected file provider
final selectedFileProvider = StateProvider<FileItem?>((ref) => null);

// View mode provider
final isGridViewProvider = StateProvider<bool>((ref) => false);

class FileManagerScreen extends ConsumerWidget {
  const FileManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize device monitor
    ref.watch(deviceMonitorProvider);

    final state = ref.watch(fileManagerNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          const FileManagerAppBar(),
          Expanded(
            child: Row(
              children: [
                const FileManagerSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      const FileManagerToolbar(),
                      if (state.error.isNotEmpty)
                        ErrorDisplay(error: state.error),
                      if (state.isLoading)
                        const LinearProgressIndicator()
                      else if (state.selectedDevice.isNotEmpty)
                        const FileManagerContent()
                      else if (state.devices.isEmpty && !state.isLoading)
                        const EmptyState(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FileManagerAppBar extends ConsumerWidget {
  const FileManagerAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
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
          const SizedBox(width: 16),
          Text(
            'File Manager',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showConnectionGuide(context),
            tooltip: 'Connection Guide',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(fileManagerNotifierProvider.notifier).refreshDevices(),
            tooltip: 'Refresh Devices',
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class FileManagerContent extends ConsumerWidget {
  const FileManagerContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGridView = ref.watch(isGridViewProvider);
    final selectedFile = ref.watch(selectedFileProvider);

    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: isGridView ? const FileGridView() : const FileListView(),
          ),
          if (selectedFile != null)
            SizedBox(
              width: 300,
              child: DetailsPanel(file: selectedFile),
            ),
        ],
      ),
    );
  }
}

class FileListView extends ConsumerWidget {
  const FileListView({super.key});

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
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: state.files.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index >= state.files.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return FileListTile(file: state.files[index]);
          },
        ),
      ),
    );
  }
}

class FileListTile extends ConsumerWidget {
  final FileItem file;

  const FileListTile({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerNotifierProvider);
    final selectedFile = ref.watch(selectedFileProvider);
    final isSelected = selectedFile == file;

    return ListTile(
      selected: isSelected,
      leading: FileIconWidget(file: file),
      title: Text(
        file.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${file.permissions} - ${file.owner}:${file.group} - ${formatSize(file.size)}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: file.isDirectory
          ? const Icon(Icons.chevron_right)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ref.read(adbServiceProvider).isMediaFile(file.name))
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () =>
                        showPreview(context, file, state.selectedDevice),
                  ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () =>
                      showFileOptions(context, file, state.selectedDevice),
                ),
              ],
            ),
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
    );
  }
}

String formatSize(int size) {
  if (size < 1024) return '$size B';
  if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
  if (size < 1024 * 1024 * 1024) {
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

void showConnectionGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const ConnectionGuideDialog(),
    ),
  );
}

void showPreview(BuildContext context, FileItem file, String deviceId) {
  showDialog(
    context: context,
    builder: (context) => FilePreviewDialog(
      file: file,
      deviceId: deviceId,
    ),
  );
}

void showFileOptions(BuildContext context, FileItem file, String deviceId) {
  // Implement file options dialog
}
