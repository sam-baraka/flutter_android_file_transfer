// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileItemImpl _$$FileItemImplFromJson(Map<String, dynamic> json) =>
    _$FileItemImpl(
      name: json['name'] as String,
      path: json['path'] as String,
      isDirectory: json['isDirectory'] as bool,
      permissions: json['permissions'] as String,
      owner: json['owner'] as String,
      group: json['group'] as String,
      size: (json['size'] as num).toInt(),
      modifiedTime: DateTime.parse(json['modifiedTime'] as String),
    );

Map<String, dynamic> _$$FileItemImplToJson(_$FileItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'isDirectory': instance.isDirectory,
      'permissions': instance.permissions,
      'owner': instance.owner,
      'group': instance.group,
      'size': instance.size,
      'modifiedTime': instance.modifiedTime.toIso8601String(),
    };
