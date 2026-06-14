// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) {
  return _NotificationItem.fromJson(json);
}

/// @nodoc
mixin _$NotificationItem {
  String get id => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'label_icon')
  String? get labelIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_uri')
  String? get targetUri => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  bool get discardable => throw _privateConstructorUsedError;
  List<Emphasis> get emphasizes => throw _privateConstructorUsedError;

  /// Serializes this NotificationItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationItemCopyWith<NotificationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationItemCopyWith<$Res> {
  factory $NotificationItemCopyWith(
    NotificationItem value,
    $Res Function(NotificationItem) then,
  ) = _$NotificationItemCopyWithImpl<$Res, NotificationItem>;
  @useResult
  $Res call({
    String id,
    String? category,
    String? text,
    String? label,
    @JsonKey(name: 'label_icon') String? labelIcon,
    @JsonKey(name: 'target_uri') String? targetUri,
    String? time,
    @JsonKey(name: 'is_read') bool isRead,
    bool discardable,
    List<Emphasis> emphasizes,
  });
}

/// @nodoc
class _$NotificationItemCopyWithImpl<$Res, $Val extends NotificationItem>
    implements $NotificationItemCopyWith<$Res> {
  _$NotificationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = freezed,
    Object? text = freezed,
    Object? label = freezed,
    Object? labelIcon = freezed,
    Object? targetUri = freezed,
    Object? time = freezed,
    Object? isRead = null,
    Object? discardable = null,
    Object? emphasizes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            labelIcon: freezed == labelIcon
                ? _value.labelIcon
                : labelIcon // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetUri: freezed == targetUri
                ? _value.targetUri
                : targetUri // ignore: cast_nullable_to_non_nullable
                      as String?,
            time: freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            discardable: null == discardable
                ? _value.discardable
                : discardable // ignore: cast_nullable_to_non_nullable
                      as bool,
            emphasizes: null == emphasizes
                ? _value.emphasizes
                : emphasizes // ignore: cast_nullable_to_non_nullable
                      as List<Emphasis>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationItemImplCopyWith<$Res>
    implements $NotificationItemCopyWith<$Res> {
  factory _$$NotificationItemImplCopyWith(
    _$NotificationItemImpl value,
    $Res Function(_$NotificationItemImpl) then,
  ) = __$$NotificationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? category,
    String? text,
    String? label,
    @JsonKey(name: 'label_icon') String? labelIcon,
    @JsonKey(name: 'target_uri') String? targetUri,
    String? time,
    @JsonKey(name: 'is_read') bool isRead,
    bool discardable,
    List<Emphasis> emphasizes,
  });
}

/// @nodoc
class __$$NotificationItemImplCopyWithImpl<$Res>
    extends _$NotificationItemCopyWithImpl<$Res, _$NotificationItemImpl>
    implements _$$NotificationItemImplCopyWith<$Res> {
  __$$NotificationItemImplCopyWithImpl(
    _$NotificationItemImpl _value,
    $Res Function(_$NotificationItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = freezed,
    Object? text = freezed,
    Object? label = freezed,
    Object? labelIcon = freezed,
    Object? targetUri = freezed,
    Object? time = freezed,
    Object? isRead = null,
    Object? discardable = null,
    Object? emphasizes = null,
  }) {
    return _then(
      _$NotificationItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        labelIcon: freezed == labelIcon
            ? _value.labelIcon
            : labelIcon // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetUri: freezed == targetUri
            ? _value.targetUri
            : targetUri // ignore: cast_nullable_to_non_nullable
                  as String?,
        time: freezed == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        discardable: null == discardable
            ? _value.discardable
            : discardable // ignore: cast_nullable_to_non_nullable
                  as bool,
        emphasizes: null == emphasizes
            ? _value._emphasizes
            : emphasizes // ignore: cast_nullable_to_non_nullable
                  as List<Emphasis>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationItemImpl implements _NotificationItem {
  const _$NotificationItemImpl({
    required this.id,
    this.category,
    this.text,
    this.label,
    @JsonKey(name: 'label_icon') this.labelIcon,
    @JsonKey(name: 'target_uri') this.targetUri,
    this.time,
    @JsonKey(name: 'is_read') this.isRead = false,
    this.discardable = false,
    final List<Emphasis> emphasizes = const <Emphasis>[],
  }) : _emphasizes = emphasizes;

  factory _$NotificationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationItemImplFromJson(json);

  @override
  final String id;
  @override
  final String? category;
  @override
  final String? text;
  @override
  final String? label;
  @override
  @JsonKey(name: 'label_icon')
  final String? labelIcon;
  @override
  @JsonKey(name: 'target_uri')
  final String? targetUri;
  @override
  final String? time;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey()
  final bool discardable;
  final List<Emphasis> _emphasizes;
  @override
  @JsonKey()
  List<Emphasis> get emphasizes {
    if (_emphasizes is EqualUnmodifiableListView) return _emphasizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emphasizes);
  }

  @override
  String toString() {
    return 'NotificationItem(id: $id, category: $category, text: $text, label: $label, labelIcon: $labelIcon, targetUri: $targetUri, time: $time, isRead: $isRead, discardable: $discardable, emphasizes: $emphasizes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.labelIcon, labelIcon) ||
                other.labelIcon == labelIcon) &&
            (identical(other.targetUri, targetUri) ||
                other.targetUri == targetUri) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.discardable, discardable) ||
                other.discardable == discardable) &&
            const DeepCollectionEquality().equals(
              other._emphasizes,
              _emphasizes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    text,
    label,
    labelIcon,
    targetUri,
    time,
    isRead,
    discardable,
    const DeepCollectionEquality().hash(_emphasizes),
  );

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationItemImplCopyWith<_$NotificationItemImpl> get copyWith =>
      __$$NotificationItemImplCopyWithImpl<_$NotificationItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationItemImplToJson(this);
  }
}

abstract class _NotificationItem implements NotificationItem {
  const factory _NotificationItem({
    required final String id,
    final String? category,
    final String? text,
    final String? label,
    @JsonKey(name: 'label_icon') final String? labelIcon,
    @JsonKey(name: 'target_uri') final String? targetUri,
    final String? time,
    @JsonKey(name: 'is_read') final bool isRead,
    final bool discardable,
    final List<Emphasis> emphasizes,
  }) = _$NotificationItemImpl;

  factory _NotificationItem.fromJson(Map<String, dynamic> json) =
      _$NotificationItemImpl.fromJson;

  @override
  String get id;
  @override
  String? get category;
  @override
  String? get text;
  @override
  String? get label;
  @override
  @JsonKey(name: 'label_icon')
  String? get labelIcon;
  @override
  @JsonKey(name: 'target_uri')
  String? get targetUri;
  @override
  String? get time;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  bool get discardable;
  @override
  List<Emphasis> get emphasizes;

  /// Create a copy of NotificationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationItemImplCopyWith<_$NotificationItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Emphasis _$EmphasisFromJson(Map<String, dynamic> json) {
  return _Emphasis.fromJson(json);
}

/// @nodoc
mixin _$Emphasis {
  int get start => throw _privateConstructorUsedError;
  int get end => throw _privateConstructorUsedError;

  /// Serializes this Emphasis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Emphasis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmphasisCopyWith<Emphasis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmphasisCopyWith<$Res> {
  factory $EmphasisCopyWith(Emphasis value, $Res Function(Emphasis) then) =
      _$EmphasisCopyWithImpl<$Res, Emphasis>;
  @useResult
  $Res call({int start, int end});
}

/// @nodoc
class _$EmphasisCopyWithImpl<$Res, $Val extends Emphasis>
    implements $EmphasisCopyWith<$Res> {
  _$EmphasisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Emphasis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? start = null, Object? end = null}) {
    return _then(
      _value.copyWith(
            start: null == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as int,
            end: null == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmphasisImplCopyWith<$Res>
    implements $EmphasisCopyWith<$Res> {
  factory _$$EmphasisImplCopyWith(
    _$EmphasisImpl value,
    $Res Function(_$EmphasisImpl) then,
  ) = __$$EmphasisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int start, int end});
}

/// @nodoc
class __$$EmphasisImplCopyWithImpl<$Res>
    extends _$EmphasisCopyWithImpl<$Res, _$EmphasisImpl>
    implements _$$EmphasisImplCopyWith<$Res> {
  __$$EmphasisImplCopyWithImpl(
    _$EmphasisImpl _value,
    $Res Function(_$EmphasisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Emphasis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? start = null, Object? end = null}) {
    return _then(
      _$EmphasisImpl(
        start: null == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as int,
        end: null == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmphasisImpl implements _Emphasis {
  const _$EmphasisImpl({this.start = 0, this.end = 0});

  factory _$EmphasisImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmphasisImplFromJson(json);

  @override
  @JsonKey()
  final int start;
  @override
  @JsonKey()
  final int end;

  @override
  String toString() {
    return 'Emphasis(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmphasisImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  /// Create a copy of Emphasis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmphasisImplCopyWith<_$EmphasisImpl> get copyWith =>
      __$$EmphasisImplCopyWithImpl<_$EmphasisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmphasisImplToJson(this);
  }
}

abstract class _Emphasis implements Emphasis {
  const factory _Emphasis({final int start, final int end}) = _$EmphasisImpl;

  factory _Emphasis.fromJson(Map<String, dynamic> json) =
      _$EmphasisImpl.fromJson;

  @override
  int get start;
  @override
  int get end;

  /// Create a copy of Emphasis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmphasisImplCopyWith<_$EmphasisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
