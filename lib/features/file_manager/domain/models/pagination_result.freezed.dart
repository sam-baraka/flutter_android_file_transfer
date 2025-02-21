// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginationResult _$PaginationResultFromJson(Map<String, dynamic> json) {
  return _PaginationResult.fromJson(json);
}

/// @nodoc
mixin _$PaginationResult {
  List<FileItem> get files => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this PaginationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationResultCopyWith<PaginationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationResultCopyWith<$Res> {
  factory $PaginationResultCopyWith(
          PaginationResult value, $Res Function(PaginationResult) then) =
      _$PaginationResultCopyWithImpl<$Res, PaginationResult>;
  @useResult
  $Res call({List<FileItem> files, bool hasMore});
}

/// @nodoc
class _$PaginationResultCopyWithImpl<$Res, $Val extends PaginationResult>
    implements $PaginationResultCopyWith<$Res> {
  _$PaginationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileItem>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationResultImplCopyWith<$Res>
    implements $PaginationResultCopyWith<$Res> {
  factory _$$PaginationResultImplCopyWith(_$PaginationResultImpl value,
          $Res Function(_$PaginationResultImpl) then) =
      __$$PaginationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FileItem> files, bool hasMore});
}

/// @nodoc
class __$$PaginationResultImplCopyWithImpl<$Res>
    extends _$PaginationResultCopyWithImpl<$Res, _$PaginationResultImpl>
    implements _$$PaginationResultImplCopyWith<$Res> {
  __$$PaginationResultImplCopyWithImpl(_$PaginationResultImpl _value,
      $Res Function(_$PaginationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginationResultImpl(
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileItem>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationResultImpl implements _PaginationResult {
  const _$PaginationResultImpl(
      {required final List<FileItem> files, required this.hasMore})
      : _files = files;

  factory _$PaginationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationResultImplFromJson(json);

  final List<FileItem> _files;
  @override
  List<FileItem> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PaginationResult(files: $files, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationResultImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_files), hasMore);

  /// Create a copy of PaginationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationResultImplCopyWith<_$PaginationResultImpl> get copyWith =>
      __$$PaginationResultImplCopyWithImpl<_$PaginationResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationResultImplToJson(
      this,
    );
  }
}

abstract class _PaginationResult implements PaginationResult {
  const factory _PaginationResult(
      {required final List<FileItem> files,
      required final bool hasMore}) = _$PaginationResultImpl;

  factory _PaginationResult.fromJson(Map<String, dynamic> json) =
      _$PaginationResultImpl.fromJson;

  @override
  List<FileItem> get files;
  @override
  bool get hasMore;

  /// Create a copy of PaginationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationResultImplCopyWith<_$PaginationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
