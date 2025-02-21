import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/file_item.dart';
import '../providers/file_manager_provider.dart';
import '../widgets/connection_guide_dialog.dart';

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

void showFileOptions(BuildContext context, FileItem file, String deviceId) {
  // Implement file options dialog
}

Future<void> downloadFile(
    BuildContext context, WidgetRef ref, FileItem file, String deviceId) async {
  try {
    String? downloadPath = await FilePicker.platform.saveFile(
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
