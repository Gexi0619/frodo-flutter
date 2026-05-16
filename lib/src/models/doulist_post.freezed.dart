// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doulist_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DoulistPost _$DoulistPostFromJson(Map<String, dynamic> json) {
  return _DoulistPost.fromJson(json);
}

/// @nodoc
mixin _$DoulistPost {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_time')
  String? get collectionTime => throw _privateConstructorUsedError;

  /// 用户收录时填写的备注。
  @JsonKey(name: 'collection_reason')
  String? get collectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'comments_count')
  int? get commentsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reactions_count')
  int? get reactionsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reshares_count')
  int? get resharesCount => throw _privateConstructorUsedError;
  DoulistPostContent? get content => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this DoulistPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DoulistPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoulistPostCopyWith<DoulistPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoulistPostCopyWith<$Res> {
  factory $DoulistPostCopyWith(
    DoulistPost value,
    $Res Function(DoulistPost) then,
  ) = _$DoulistPostCopyWithImpl<$Res, DoulistPost>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'collection_time') String? collectionTime,
    @JsonKey(name: 'collection_reason') String? collectionReason,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    DoulistPostContent? content,
    String? type,
  });

  $DoulistPostContentCopyWith<$Res>? get content;
}

/// @nodoc
class _$DoulistPostCopyWithImpl<$Res, $Val extends DoulistPost>
    implements $DoulistPostCopyWith<$Res> {
  _$DoulistPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoulistPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collectionTime = freezed,
    Object? collectionReason = freezed,
    Object? commentsCount = freezed,
    Object? reactionsCount = freezed,
    Object? resharesCount = freezed,
    Object? content = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            collectionTime: freezed == collectionTime
                ? _value.collectionTime
                : collectionTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            collectionReason: freezed == collectionReason
                ? _value.collectionReason
                : collectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            commentsCount: freezed == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            reactionsCount: freezed == reactionsCount
                ? _value.reactionsCount
                : reactionsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            resharesCount: freezed == resharesCount
                ? _value.resharesCount
                : resharesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as DoulistPostContent?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of DoulistPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoulistPostContentCopyWith<$Res>? get content {
    if (_value.content == null) {
      return null;
    }

    return $DoulistPostContentCopyWith<$Res>(_value.content!, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DoulistPostImplCopyWith<$Res>
    implements $DoulistPostCopyWith<$Res> {
  factory _$$DoulistPostImplCopyWith(
    _$DoulistPostImpl value,
    $Res Function(_$DoulistPostImpl) then,
  ) = __$$DoulistPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'collection_time') String? collectionTime,
    @JsonKey(name: 'collection_reason') String? collectionReason,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    DoulistPostContent? content,
    String? type,
  });

  @override
  $DoulistPostContentCopyWith<$Res>? get content;
}

/// @nodoc
class __$$DoulistPostImplCopyWithImpl<$Res>
    extends _$DoulistPostCopyWithImpl<$Res, _$DoulistPostImpl>
    implements _$$DoulistPostImplCopyWith<$Res> {
  __$$DoulistPostImplCopyWithImpl(
    _$DoulistPostImpl _value,
    $Res Function(_$DoulistPostImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoulistPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collectionTime = freezed,
    Object? collectionReason = freezed,
    Object? commentsCount = freezed,
    Object? reactionsCount = freezed,
    Object? resharesCount = freezed,
    Object? content = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _$DoulistPostImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        collectionTime: freezed == collectionTime
            ? _value.collectionTime
            : collectionTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        collectionReason: freezed == collectionReason
            ? _value.collectionReason
            : collectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        commentsCount: freezed == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        reactionsCount: freezed == reactionsCount
            ? _value.reactionsCount
            : reactionsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        resharesCount: freezed == resharesCount
            ? _value.resharesCount
            : resharesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as DoulistPostContent?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DoulistPostImpl implements _DoulistPost {
  const _$DoulistPostImpl({
    required this.id,
    @JsonKey(name: 'collection_time') this.collectionTime,
    @JsonKey(name: 'collection_reason') this.collectionReason,
    @JsonKey(name: 'comments_count') this.commentsCount,
    @JsonKey(name: 'reactions_count') this.reactionsCount,
    @JsonKey(name: 'reshares_count') this.resharesCount,
    this.content,
    this.type,
  });

  factory _$DoulistPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoulistPostImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'collection_time')
  final String? collectionTime;

  /// 用户收录时填写的备注。
  @override
  @JsonKey(name: 'collection_reason')
  final String? collectionReason;
  @override
  @JsonKey(name: 'comments_count')
  final int? commentsCount;
  @override
  @JsonKey(name: 'reactions_count')
  final int? reactionsCount;
  @override
  @JsonKey(name: 'reshares_count')
  final int? resharesCount;
  @override
  final DoulistPostContent? content;
  @override
  final String? type;

  @override
  String toString() {
    return 'DoulistPost(id: $id, collectionTime: $collectionTime, collectionReason: $collectionReason, commentsCount: $commentsCount, reactionsCount: $reactionsCount, resharesCount: $resharesCount, content: $content, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoulistPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.collectionTime, collectionTime) ||
                other.collectionTime == collectionTime) &&
            (identical(other.collectionReason, collectionReason) ||
                other.collectionReason == collectionReason) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.reactionsCount, reactionsCount) ||
                other.reactionsCount == reactionsCount) &&
            (identical(other.resharesCount, resharesCount) ||
                other.resharesCount == resharesCount) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    collectionTime,
    collectionReason,
    commentsCount,
    reactionsCount,
    resharesCount,
    content,
    type,
  );

  /// Create a copy of DoulistPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoulistPostImplCopyWith<_$DoulistPostImpl> get copyWith =>
      __$$DoulistPostImplCopyWithImpl<_$DoulistPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DoulistPostImplToJson(this);
  }
}

abstract class _DoulistPost implements DoulistPost {
  const factory _DoulistPost({
    required final String id,
    @JsonKey(name: 'collection_time') final String? collectionTime,
    @JsonKey(name: 'collection_reason') final String? collectionReason,
    @JsonKey(name: 'comments_count') final int? commentsCount,
    @JsonKey(name: 'reactions_count') final int? reactionsCount,
    @JsonKey(name: 'reshares_count') final int? resharesCount,
    final DoulistPostContent? content,
    final String? type,
  }) = _$DoulistPostImpl;

  factory _DoulistPost.fromJson(Map<String, dynamic> json) =
      _$DoulistPostImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'collection_time')
  String? get collectionTime;

  /// 用户收录时填写的备注。
  @override
  @JsonKey(name: 'collection_reason')
  String? get collectionReason;
  @override
  @JsonKey(name: 'comments_count')
  int? get commentsCount;
  @override
  @JsonKey(name: 'reactions_count')
  int? get reactionsCount;
  @override
  @JsonKey(name: 'reshares_count')
  int? get resharesCount;
  @override
  DoulistPostContent? get content;
  @override
  String? get type;

  /// Create a copy of DoulistPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoulistPostImplCopyWith<_$DoulistPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DoulistPostContent _$DoulistPostContentFromJson(Map<String, dynamic> json) {
  return _DoulistPostContent.fromJson(json);
}

/// @nodoc
mixin _$DoulistPostContent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get abstract => throw _privateConstructorUsedError;
  Author? get author => throw _privateConstructorUsedError;
  List<TopicPhoto> get photos => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this DoulistPostContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DoulistPostContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoulistPostContentCopyWith<DoulistPostContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoulistPostContentCopyWith<$Res> {
  factory $DoulistPostContentCopyWith(
    DoulistPostContent value,
    $Res Function(DoulistPostContent) then,
  ) = _$DoulistPostContentCopyWithImpl<$Res, DoulistPostContent>;
  @useResult
  $Res call({
    String id,
    String title,
    String? abstract,
    Author? author,
    List<TopicPhoto> photos,
    String? uri,
    String? url,
  });

  $AuthorCopyWith<$Res>? get author;
}

/// @nodoc
class _$DoulistPostContentCopyWithImpl<$Res, $Val extends DoulistPostContent>
    implements $DoulistPostContentCopyWith<$Res> {
  _$DoulistPostContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoulistPostContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? abstract = freezed,
    Object? author = freezed,
    Object? photos = null,
    Object? uri = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            abstract: freezed == abstract
                ? _value.abstract
                : abstract // ignore: cast_nullable_to_non_nullable
                      as String?,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as Author?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<TopicPhoto>,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of DoulistPostContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $AuthorCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DoulistPostContentImplCopyWith<$Res>
    implements $DoulistPostContentCopyWith<$Res> {
  factory _$$DoulistPostContentImplCopyWith(
    _$DoulistPostContentImpl value,
    $Res Function(_$DoulistPostContentImpl) then,
  ) = __$$DoulistPostContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? abstract,
    Author? author,
    List<TopicPhoto> photos,
    String? uri,
    String? url,
  });

  @override
  $AuthorCopyWith<$Res>? get author;
}

/// @nodoc
class __$$DoulistPostContentImplCopyWithImpl<$Res>
    extends _$DoulistPostContentCopyWithImpl<$Res, _$DoulistPostContentImpl>
    implements _$$DoulistPostContentImplCopyWith<$Res> {
  __$$DoulistPostContentImplCopyWithImpl(
    _$DoulistPostContentImpl _value,
    $Res Function(_$DoulistPostContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoulistPostContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? abstract = freezed,
    Object? author = freezed,
    Object? photos = null,
    Object? uri = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _$DoulistPostContentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        abstract: freezed == abstract
            ? _value.abstract
            : abstract // ignore: cast_nullable_to_non_nullable
                  as String?,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as Author?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<TopicPhoto>,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DoulistPostContentImpl implements _DoulistPostContent {
  const _$DoulistPostContentImpl({
    required this.id,
    required this.title,
    this.abstract,
    this.author,
    final List<TopicPhoto> photos = const <TopicPhoto>[],
    this.uri,
    this.url,
  }) : _photos = photos;

  factory _$DoulistPostContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoulistPostContentImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? abstract;
  @override
  final Author? author;
  final List<TopicPhoto> _photos;
  @override
  @JsonKey()
  List<TopicPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  final String? uri;
  @override
  final String? url;

  @override
  String toString() {
    return 'DoulistPostContent(id: $id, title: $title, abstract: $abstract, author: $author, photos: $photos, uri: $uri, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoulistPostContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.abstract, abstract) ||
                other.abstract == abstract) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    abstract,
    author,
    const DeepCollectionEquality().hash(_photos),
    uri,
    url,
  );

  /// Create a copy of DoulistPostContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoulistPostContentImplCopyWith<_$DoulistPostContentImpl> get copyWith =>
      __$$DoulistPostContentImplCopyWithImpl<_$DoulistPostContentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DoulistPostContentImplToJson(this);
  }
}

abstract class _DoulistPostContent implements DoulistPostContent {
  const factory _DoulistPostContent({
    required final String id,
    required final String title,
    final String? abstract,
    final Author? author,
    final List<TopicPhoto> photos,
    final String? uri,
    final String? url,
  }) = _$DoulistPostContentImpl;

  factory _DoulistPostContent.fromJson(Map<String, dynamic> json) =
      _$DoulistPostContentImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get abstract;
  @override
  Author? get author;
  @override
  List<TopicPhoto> get photos;
  @override
  String? get uri;
  @override
  String? get url;

  /// Create a copy of DoulistPostContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoulistPostContentImplCopyWith<_$DoulistPostContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
