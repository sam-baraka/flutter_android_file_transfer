// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileItem _$FileItemFromJson(Map<String, dynamic> json) {
  return _FileItem.fromJson(json);
}

/// @nodoc
mixin _$FileItem {
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  bool get isDirectory => throw _privateConstructorUsedError;
  String get permissions => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get group => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  DateTime get modifiedTime => throw _privateConstructorUsedError;

  /// Serializes this FileItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileItemCopyWith<FileItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileItemCopyWith<$Res> {
  factory $FileItemCopyWith(FileItem value, $Res Function(FileItem) then) =
      _$FileItemCopyWithImpl<$Res, FileItem>;
  @useResult
  $Res call(
      {String name,
      String path,
      bool isDirectory,
      String permissions,
      String owner,
      String group,
      int size,
      DateTime modifiedTime});
}

/// @nodoc
class _$FileItemCopyWithImpl<$Res, $Val extends FileItem>
    implements $FileItemCopyWith<$Res> {
  _$FileItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? isDirectory = null,
    Object? permissions = null,
    Object? owner = null,
    Object? group = null,
    Object? size = null,
    Object? modifiedTime = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isDirectory: null == isDirectory
          ? _value.isDirectory
          : isDirectory // ignore: cast_nullable_to_non_nullable
              as bool,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      modifiedTime: null == modifiedTime
          ? _value.modifiedTime
          : modifiedTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileItemImplCopyWith<$Res>
    implements $FileItemCopyWith<$Res> {
  factory _$$FileItemImplCopyWith(
          _$FileItemImpl value, $Res Function(_$FileItemImpl) then) =
      __$$FileItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String path,
      bool isDirectory,
      String permissions,
      String owner,
      String group,
      int size,
      DateTime modifiedTime});
}

/// @nodoc
class __$$FileItemImplCopyWithImpl<$Res>
    extends _$FileItemCopyWithImpl<$Res, _$FileItemImpl>
    implements _$$FileItemImplCopyWith<$Res> {
  __$$FileItemImplCopyWithImpl(
      _$FileItemImpl _value, $Res Function(_$FileItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? isDirectory = null,
    Object? permissions = null,
    Object? owner = null,
    Object? group = null,
    Object? size = null,
    Object? modifiedTime = null,
  }) {
    return _then(_$FileItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isDirectory: null == isDirectory
          ? _value.isDirectory
          : isDirectory // ignore: cast_nullable_to_non_nullable
              as bool,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      modifiedTime: null == modifiedTime
          ? _value.modifiedTime
          : modifiedTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileItemImpl implements _FileItem {
  const _$FileItemImpl(
      {required this.name,
      required this.path,
      required this.isDirectory,
      required this.permissions,
      required this.owner,
      required this.group,
      required this.size,
      required this.modifiedTime});

  factory _$FileItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileItemImplFromJson(json);

  @override
  final String name;
  @override
  final String path;
  @override
  final bool isDirectory;
  @override
  final String permissions;
  @override
  final String owner;
  @override
  final String group;
  @override
  final int size;
  @override
  final DateTime modifiedTime;

  @override
  String toString() {
    return 'FileItem(name: $name, path: $path, isDirectory: $isDirectory, permissions: $permissions, owner: $owner, group: $group, size: $size, modifiedTime: $modifiedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.isDirectory, isDirectory) ||
                other.isDirectory == isDirectory) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.modifiedTime, modifiedTime) ||
                other.modifiedTime == modifiedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, path, isDirectory,
      permissions, owner, group, size, modifiedTime);

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileItemImplCopyWith<_$FileItemImpl> get copyWith =>
      __$$FileItemImplCopyWithImpl<_$FileItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileItemImplToJson(
      this,
    );
  }
}

abstract class _FileItem implements FileItem {
  const factory _FileItem(
      {required final String name,
      required final String path,
      required final bool isDirectory,
      required final String permissions,
      required final String owner,
      required final String group,
      required final int size,
      required final DateTime modifiedTime}) = _$FileItemImpl;

  factory _FileItem.fromJson(Map<String, dynamic> json) =
      _$FileItemImpl.fromJson;

  @override
  String get name;
  @override
  String get path;
  @override
  bool get isDirectory;
  @override
  String get permissions;
  @override
  String get owner;
  @override
  String get group;
  @override
  int get size;
  @override
  DateTime get modifiedTime;

  /// Create a copy of FileItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileItemImplCopyWith<_$FileItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
