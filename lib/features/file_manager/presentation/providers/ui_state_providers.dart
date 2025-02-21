import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/file_item.dart';

enum FileType { all, folders, documents, images, videos, music, downloads }

final selectedFileProvider = StateProvider<FileItem?>((ref) => null);
final isGridViewProvider = StateProvider<bool>((ref) => false);
final selectedFileTypeProvider = StateProvider<FileType>((ref) => FileType.all);

// File type extension matchers
final fileTypeMatchers = {
  FileType.documents: ['.pdf', '.doc', '.docx', '.txt', '.rtf', '.odt'],
  FileType.images: ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.heic'],
  FileType.videos: ['.mp4', '.mov', '.avi', '.mkv', '.wmv', '.flv', '.webm'],
  FileType.music: ['.mp3', '.wav', '.m4a', '.ogg', '.flac', '.aac'],
  FileType.downloads: ['.apk', '.zip', '.rar', '.7z', '.tar', '.gz'],
};
