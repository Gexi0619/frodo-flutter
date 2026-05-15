// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reshare.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Reshare _$ReshareFromJson(Map<String, dynamic> json) {
  return _Reshare.fromJson(json);
}

/// @nodoc
mixin _$Reshare {
  String get id => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_time')
  String? get createTime => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;
  Author get author => throw _privateConstructorUsedError;

  /// Serializes this Reshare to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reshare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReshareCopyWith<Reshare> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReshareCopyWith<$Res> {
  factory $ReshareCopyWith(Reshare value, $Res Function(Reshare) then) =
      _$ReshareCopyWithImpl<$Res, Reshare>;
  @useResult
  $Res call({
    String id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    String? uri,
    Author author,
  });

  $AuthorCopyWith<$Res> get author;
}

/// @nodoc
class _$ReshareCopyWithImpl<$Res, $Val extends Reshare>
    implements $ReshareCopyWith<$Res> {
  _$ReshareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reshare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = freezed,
    Object? createTime = freezed,
    Object? uri = freezed,
    Object? author = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            createTime: freezed == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as Author,
          )
          as $Val,
    );
  }

  /// Create a copy of Reshare
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorCopyWith<$Res> get author {
    return $AuthorCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReshareImplCopyWith<$Res> implements $ReshareCopyWith<$Res> {
  factory _$$ReshareImplCopyWith(
    _$ReshareImpl value,
    $Res Function(_$ReshareImpl) then,
  ) = __$$ReshareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    String? uri,
    Author author,
  });

  @override
  $AuthorCopyWith<$Res> get author;
}

/// @nodoc
class __$$ReshareImplCopyWithImpl<$Res>
    extends _$ReshareCopyWithImpl<$Res, _$ReshareImpl>
    implements _$$ReshareImplCopyWith<$Res> {
  __$$ReshareImplCopyWithImpl(
    _$ReshareImpl _value,
    $Res Function(_$ReshareImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reshare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = freezed,
    Object? createTime = freezed,
    Object? uri = freezed,
    Object? author = null,
  }) {
    return _then(
      _$ReshareImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        createTime: freezed == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as Author,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReshareImpl implements _Reshare {
  const _$ReshareImpl({
    required this.id,
    this.text,
    @JsonKey(name: 'create_time') this.createTime,
    this.uri,
    required this.author,
  });

  factory _$ReshareImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReshareImplFromJson(json);

  @override
  final String id;
  @override
  final String? text;
  @override
  @JsonKey(name: 'create_time')
  final String? createTime;
  @override
  final String? uri;
  @override
  final Author author;

  @override
  String toString() {
    return 'Reshare(id: $id, text: $text, createTime: $createTime, uri: $uri, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReshareImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, text, createTime, uri, author);

  /// Create a copy of Reshare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReshareImplCopyWith<_$ReshareImpl> get copyWith =>
      __$$ReshareImplCopyWithImpl<_$ReshareImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReshareImplToJson(this);
  }
}

abstract class _Reshare implements Reshare {
  const factory _Reshare({
    required final String id,
    final String? text,
    @JsonKey(name: 'create_time') final String? createTime,
    final String? uri,
    required final Author author,
  }) = _$ReshareImpl;

  factory _Reshare.fromJson(Map<String, dynamic> json) = _$ReshareImpl.fromJson;

  @override
  String get id;
  @override
  String? get text;
  @override
  @JsonKey(name: 'create_time')
  String? get createTime;
  @override
  String? get uri;
  @override
  Author get author;

  /// Create a copy of Reshare
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReshareImplCopyWith<_$ReshareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
