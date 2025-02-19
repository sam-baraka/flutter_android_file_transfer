// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_manager_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FileManagerState {
  List<String> get devices => throw _privateConstructorUsedError;
  List<FileItem> get files => throw _privateConstructorUsedError;
  String get currentPath => throw _privateConstructorUsedError;
  String get selectedDevice => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of FileManagerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileManagerStateCopyWith<FileManagerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileManagerStateCopyWith<$Res> {
  factory $FileManagerStateCopyWith(
          FileManagerState value, $Res Function(FileManagerState) then) =
      _$FileManagerStateCopyWithImpl<$Res, FileManagerState>;
  @useResult
  $Res call(
      {List<String> devices,
      List<FileItem> files,
      String currentPath,
      String selectedDevice,
      String error,
      bool isLoading});
}

/// @nodoc
class _$FileManagerStateCopyWithImpl<$Res, $Val extends FileManagerState>
    implements $FileManagerStateCopyWith<$Res> {
  _$FileManagerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileManagerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
    Object? files = null,
    Object? currentPath = null,
    Object? selectedDevice = null,
    Object? error = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      devices: null == devices
          ? _value.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileItem>,
      currentPath: null == currentPath
          ? _value.currentPath
          : currentPath // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDevice: null == selectedDevice
          ? _value.selectedDevice
          : selectedDevice // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileManagerStateImplCopyWith<$Res>
    implements $FileManagerStateCopyWith<$Res> {
  factory _$$FileManagerStateImplCopyWith(_$FileManagerStateImpl value,
          $Res Function(_$FileManagerStateImpl) then) =
      __$$FileManagerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> devices,
      List<FileItem> files,
      String currentPath,
      String selectedDevice,
      String error,
      bool isLoading});
}

/// @nodoc
class __$$FileManagerStateImplCopyWithImpl<$Res>
    extends _$FileManagerStateCopyWithImpl<$Res, _$FileManagerStateImpl>
    implements _$$FileManagerStateImplCopyWith<$Res> {
  __$$FileManagerStateImplCopyWithImpl(_$FileManagerStateImpl _value,
      $Res Function(_$FileManagerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileManagerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
    Object? files = null,
    Object? currentPath = null,
    Object? selectedDevice = null,
    Object? error = null,
    Object? isLoading = null,
  }) {
    return _then(_$FileManagerStateImpl(
      devices: null == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<String>,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileItem>,
      currentPath: null == currentPath
          ? _value.currentPath
          : currentPath // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDevice: null == selectedDevice
          ? _value.selectedDevice
          : selectedDevice // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FileManagerStateImpl implements _FileManagerState {
  const _$FileManagerStateImpl(
      {final List<String> devices = const [],
      final List<FileItem> files = const [],
      this.currentPath = '',
      this.selectedDevice = '',
      this.error = '',
      this.isLoading = false})
      : _devices = devices,
        _files = files;

  final List<String> _devices;
  @override
  @JsonKey()
  List<String> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  final List<FileItem> _files;
  @override
  @JsonKey()
  List<FileItem> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  @JsonKey()
  final String currentPath;
  @override
  @JsonKey()
  final String selectedDevice;
  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'FileManagerState(devices: $devices, files: $files, currentPath: $currentPath, selectedDevice: $selectedDevice, error: $error, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileManagerStateImpl &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.currentPath, currentPath) ||
                other.currentPath == currentPath) &&
            (identical(other.selectedDevice, selectedDevice) ||
                other.selectedDevice == selectedDevice) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_devices),
      const DeepCollectionEquality().hash(_files),
      currentPath,
      selectedDevice,
      error,
      isLoading);

  /// Create a copy of FileManagerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileManagerStateImplCopyWith<_$FileManagerStateImpl> get copyWith =>
      __$$FileManagerStateImplCopyWithImpl<_$FileManagerStateImpl>(
          this, _$identity);
}

abstract class _FileManagerState implements FileManagerState {
  const factory _FileManagerState(
      {final List<String> devices,
      final List<FileItem> files,
      final String currentPath,
      final String selectedDevice,
      final String error,
      final bool isLoading}) = _$FileManagerStateImpl;

  @override
  List<String> get devices;
  @override
  List<FileItem> get files;
  @override
  String get currentPath;
  @override
  String get selectedDevice;
  @override
  String get error;
  @override
  bool get isLoading;

  /// Create a copy of FileManagerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileManagerStateImplCopyWith<_$FileManagerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
