import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_item.freezed.dart';
part 'file_item.g.dart';

@freezed
class FileItem with _$FileItem {
  const factory FileItem({
    required String name,
    required String path,
    required bool isDirectory,
    required String permissions,
    required String owner,
    required String group,
    required int size,
    required DateTime modifiedTime,
  }) = _FileItem;

  factory FileItem.fromString(String statOutput) {
    try {
      final parts = statOutput.split('|');
      if (parts.length < 6) {
        throw Exception('Invalid stat output format');
      }

      final permissions = parts[0];
      final owner = parts[1];
      final group = parts[2];
      final size = int.parse(parts[3]);
      final modifiedTimeStamp = int.parse(parts[4]);
      final name = parts[5];

      return FileItem(
        name: name,
        path: '', // This needs to be set by the caller
        isDirectory: permissions.startsWith('d'),
        permissions: permissions,
        owner: owner,
        group: group,
        size: size,
        modifiedTime:
            DateTime.fromMillisecondsSinceEpoch(modifiedTimeStamp * 1000),
      );
    } catch (e) {
      throw Exception('Failed to parse file info: $e\nInput: $statOutput');
    }
  }

  factory FileItem.fromJson(Map<String, dynamic> json) =>
      _$FileItemFromJson(json);
}
