// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paged.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Paged<T> _$PagedFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object?) fromJsonT,
) {
  return _Paged<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$Paged<T> {
  List<T> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get start => throw _privateConstructorUsedError;
  int get count =>
      throw _privateConstructorUsedError; // 优先于 `start + items.length >= total` 的兜底判断。frodo 部分接口
  // （如 recent_topics_feed）只返 has_more 而不返 total。
  bool? get hasMore => throw _privateConstructorUsedError;

  /// Serializes this Paged to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of Paged
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagedCopyWith<T, Paged<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedCopyWith<T, $Res> {
  factory $PagedCopyWith(Paged<T> value, $Res Function(Paged<T>) then) =
      _$PagedCopyWithImpl<T, $Res, Paged<T>>;
  @useResult
  $Res call({List<T> items, int total, int start, int count, bool? hasMore});
}

/// @nodoc
class _$PagedCopyWithImpl<T, $Res, $Val extends Paged<T>>
    implements $PagedCopyWith<T, $Res> {
  _$PagedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Paged
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? start = null,
    Object? count = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<T>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            start: null == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as int,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: freezed == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PagedImplCopyWith<T, $Res>
    implements $PagedCopyWith<T, $Res> {
  factory _$$PagedImplCopyWith(
    _$PagedImpl<T> value,
    $Res Function(_$PagedImpl<T>) then,
  ) = __$$PagedImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, int total, int start, int count, bool? hasMore});
}

/// @nodoc
class __$$PagedImplCopyWithImpl<T, $Res>
    extends _$PagedCopyWithImpl<T, $Res, _$PagedImpl<T>>
    implements _$$PagedImplCopyWith<T, $Res> {
  __$$PagedImplCopyWithImpl(
    _$PagedImpl<T> _value,
    $Res Function(_$PagedImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of Paged
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? start = null,
    Object? count = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _$PagedImpl<T>(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<T>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        start: null == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as int,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: freezed == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$PagedImpl<T> implements _Paged<T> {
  const _$PagedImpl({
    required final List<T> items,
    this.total = 0,
    this.start = 0,
    this.count = 0,
    this.hasMore,
  }) : _items = items;

  factory _$PagedImpl.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$$PagedImplFromJson(json, fromJsonT);

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int start;
  @override
  @JsonKey()
  final int count;
  // 优先于 `start + items.length >= total` 的兜底判断。frodo 部分接口
  // （如 recent_topics_feed）只返 has_more 而不返 total。
  @override
  final bool? hasMore;

  @override
  String toString() {
    return 'Paged<$T>(items: $items, total: $total, start: $start, count: $count, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagedImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    total,
    start,
    count,
    hasMore,
  );

  /// Create a copy of Paged
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagedImplCopyWith<T, _$PagedImpl<T>> get copyWith =>
      __$$PagedImplCopyWithImpl<T, _$PagedImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$PagedImplToJson<T>(this, toJsonT);
  }
}

abstract class _Paged<T> implements Paged<T> {
  const factory _Paged({
    required final List<T> items,
    final int total,
    final int start,
    final int count,
    final bool? hasMore,
  }) = _$PagedImpl<T>;

  factory _Paged.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) = _$PagedImpl<T>.fromJson;

  @override
  List<T> get items;
  @override
  int get total;
  @override
  int get start;
  @override
  int get count; // 优先于 `start + items.length >= total` 的兜底判断。frodo 部分接口
  // （如 recent_topics_feed）只返 has_more 而不返 total。
  @override
  bool? get hasMore;

  /// Create a copy of Paged
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagedImplCopyWith<T, _$PagedImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
