// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationResultImpl _$$PaginationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationResultImpl(
      files: (json['files'] as List<dynamic>)
          .map((e) => FileItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$$PaginationResultImplToJson(
        _$PaginationResultImpl instance) =>
    <String, dynamic>{
      'files': instance.files,
      'hasMore': instance.hasMore,
    };
