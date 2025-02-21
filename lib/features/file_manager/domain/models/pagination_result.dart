import 'package:freezed_annotation/freezed_annotation.dart';
import 'file_item.dart';

part 'pagination_result.freezed.dart';
part 'pagination_result.g.dart';

@freezed
class PaginationResult with _$PaginationResult {
  const factory PaginationResult({
    required List<FileItem> files,
    required bool hasMore,
  }) = _PaginationResult;

  factory PaginationResult.fromJson(Map<String, dynamic> json) =>
      _$PaginationResultFromJson(json);
}
