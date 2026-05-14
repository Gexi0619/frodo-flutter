// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return _Topic.fromJson(json);
}

/// @nodoc
mixin _$Topic {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get abstract => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_time')
  String? get createTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'update_time')
  String? get updateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'comments_count')
  int? get commentsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reactions_count')
  int? get reactionsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'collections_count')
  int? get collectionsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reshares_count')
  int? get resharesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  List<TopicPhoto> get photos => throw _privateConstructorUsedError;
  Author? get author => throw _privateConstructorUsedError;

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicCopyWith<Topic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicCopyWith<$Res> {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) then) =
      _$TopicCopyWithImpl<$Res, Topic>;
  @useResult
  $Res call({
    String id,
    String title,
    String? abstract,
    String? content,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'update_time') String? updateTime,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'collections_count') int? collectionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    List<TopicPhoto> photos,
    Author? author,
  });

  $AuthorCopyWith<$Res>? get author;
}

/// @nodoc
class _$TopicCopyWithImpl<$Res, $Val extends Topic>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? abstract = freezed,
    Object? content = freezed,
    Object? createTime = freezed,
    Object? updateTime = freezed,
    Object? commentsCount = freezed,
    Object? reactionsCount = freezed,
    Object? collectionsCount = freezed,
    Object? resharesCount = freezed,
    Object? sharingUrl = freezed,
    Object? coverUrl = freezed,
    Object? photos = null,
    Object? author = freezed,
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
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            createTime: freezed == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            updateTime: freezed == updateTime
                ? _value.updateTime
                : updateTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            commentsCount: freezed == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            reactionsCount: freezed == reactionsCount
                ? _value.reactionsCount
                : reactionsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            collectionsCount: freezed == collectionsCount
                ? _value.collectionsCount
                : collectionsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            resharesCount: freezed == resharesCount
                ? _value.resharesCount
                : resharesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            sharingUrl: freezed == sharingUrl
                ? _value.sharingUrl
                : sharingUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<TopicPhoto>,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as Author?,
          )
          as $Val,
    );
  }

  /// Create a copy of Topic
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
abstract class _$$TopicImplCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$$TopicImplCopyWith(
    _$TopicImpl value,
    $Res Function(_$TopicImpl) then,
  ) = __$$TopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? abstract,
    String? content,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'update_time') String? updateTime,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'collections_count') int? collectionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    List<TopicPhoto> photos,
    Author? author,
  });

  @override
  $AuthorCopyWith<$Res>? get author;
}

/// @nodoc
class __$$TopicImplCopyWithImpl<$Res>
    extends _$TopicCopyWithImpl<$Res, _$TopicImpl>
    implements _$$TopicImplCopyWith<$Res> {
  __$$TopicImplCopyWithImpl(
    _$TopicImpl _value,
    $Res Function(_$TopicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? abstract = freezed,
    Object? content = freezed,
    Object? createTime = freezed,
    Object? updateTime = freezed,
    Object? commentsCount = freezed,
    Object? reactionsCount = freezed,
    Object? collectionsCount = freezed,
    Object? resharesCount = freezed,
    Object? sharingUrl = freezed,
    Object? coverUrl = freezed,
    Object? photos = null,
    Object? author = freezed,
  }) {
    return _then(
      _$TopicImpl(
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
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        createTime: freezed == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        updateTime: freezed == updateTime
            ? _value.updateTime
            : updateTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        commentsCount: freezed == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        reactionsCount: freezed == reactionsCount
            ? _value.reactionsCount
            : reactionsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        collectionsCount: freezed == collectionsCount
            ? _value.collectionsCount
            : collectionsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        resharesCount: freezed == resharesCount
            ? _value.resharesCount
            : resharesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        sharingUrl: freezed == sharingUrl
            ? _value.sharingUrl
            : sharingUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<TopicPhoto>,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as Author?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicImpl implements _Topic {
  const _$TopicImpl({
    required this.id,
    required this.title,
    this.abstract,
    this.content,
    @JsonKey(name: 'create_time') this.createTime,
    @JsonKey(name: 'update_time') this.updateTime,
    @JsonKey(name: 'comments_count') this.commentsCount,
    @JsonKey(name: 'reactions_count') this.reactionsCount,
    @JsonKey(name: 'collections_count') this.collectionsCount,
    @JsonKey(name: 'reshares_count') this.resharesCount,
    @JsonKey(name: 'sharing_url') this.sharingUrl,
    @JsonKey(name: 'cover_url') this.coverUrl,
    final List<TopicPhoto> photos = const <TopicPhoto>[],
    this.author,
  }) : _photos = photos;

  factory _$TopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? abstract;
  @override
  final String? content;
  @override
  @JsonKey(name: 'create_time')
  final String? createTime;
  @override
  @JsonKey(name: 'update_time')
  final String? updateTime;
  @override
  @JsonKey(name: 'comments_count')
  final int? commentsCount;
  @override
  @JsonKey(name: 'reactions_count')
  final int? reactionsCount;
  @override
  @JsonKey(name: 'collections_count')
  final int? collectionsCount;
  @override
  @JsonKey(name: 'reshares_count')
  final int? resharesCount;
  @override
  @JsonKey(name: 'sharing_url')
  final String? sharingUrl;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  final List<TopicPhoto> _photos;
  @override
  @JsonKey()
  List<TopicPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  final Author? author;

  @override
  String toString() {
    return 'Topic(id: $id, title: $title, abstract: $abstract, content: $content, createTime: $createTime, updateTime: $updateTime, commentsCount: $commentsCount, reactionsCount: $reactionsCount, collectionsCount: $collectionsCount, resharesCount: $resharesCount, sharingUrl: $sharingUrl, coverUrl: $coverUrl, photos: $photos, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.abstract, abstract) ||
                other.abstract == abstract) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.updateTime, updateTime) ||
                other.updateTime == updateTime) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.reactionsCount, reactionsCount) ||
                other.reactionsCount == reactionsCount) &&
            (identical(other.collectionsCount, collectionsCount) ||
                other.collectionsCount == collectionsCount) &&
            (identical(other.resharesCount, resharesCount) ||
                other.resharesCount == resharesCount) &&
            (identical(other.sharingUrl, sharingUrl) ||
                other.sharingUrl == sharingUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    abstract,
    content,
    createTime,
    updateTime,
    commentsCount,
    reactionsCount,
    collectionsCount,
    resharesCount,
    sharingUrl,
    coverUrl,
    const DeepCollectionEquality().hash(_photos),
    author,
  );

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicImplCopyWith<_$TopicImpl> get copyWith =>
      __$$TopicImplCopyWithImpl<_$TopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicImplToJson(this);
  }
}

abstract class _Topic implements Topic {
  const factory _Topic({
    required final String id,
    required final String title,
    final String? abstract,
    final String? content,
    @JsonKey(name: 'create_time') final String? createTime,
    @JsonKey(name: 'update_time') final String? updateTime,
    @JsonKey(name: 'comments_count') final int? commentsCount,
    @JsonKey(name: 'reactions_count') final int? reactionsCount,
    @JsonKey(name: 'collections_count') final int? collectionsCount,
    @JsonKey(name: 'reshares_count') final int? resharesCount,
    @JsonKey(name: 'sharing_url') final String? sharingUrl,
    @JsonKey(name: 'cover_url') final String? coverUrl,
    final List<TopicPhoto> photos,
    final Author? author,
  }) = _$TopicImpl;

  factory _Topic.fromJson(Map<String, dynamic> json) = _$TopicImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get abstract;
  @override
  String? get content;
  @override
  @JsonKey(name: 'create_time')
  String? get createTime;
  @override
  @JsonKey(name: 'update_time')
  String? get updateTime;
  @override
  @JsonKey(name: 'comments_count')
  int? get commentsCount;
  @override
  @JsonKey(name: 'reactions_count')
  int? get reactionsCount;
  @override
  @JsonKey(name: 'collections_count')
  int? get collectionsCount;
  @override
  @JsonKey(name: 'reshares_count')
  int? get resharesCount;
  @override
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  List<TopicPhoto> get photos;
  @override
  Author? get author;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicImplCopyWith<_$TopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicPhoto _$TopicPhotoFromJson(Map<String, dynamic> json) {
  return _TopicPhoto.fromJson(json);
}

/// @nodoc
mixin _$TopicPhoto {
  TopicImage? get large => throw _privateConstructorUsedError;
  TopicImage? get normal => throw _privateConstructorUsedError;
  TopicImage? get raw => throw _privateConstructorUsedError;

  /// Serializes this TopicPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicPhotoCopyWith<TopicPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicPhotoCopyWith<$Res> {
  factory $TopicPhotoCopyWith(
    TopicPhoto value,
    $Res Function(TopicPhoto) then,
  ) = _$TopicPhotoCopyWithImpl<$Res, TopicPhoto>;
  @useResult
  $Res call({TopicImage? large, TopicImage? normal, TopicImage? raw});

  $TopicImageCopyWith<$Res>? get large;
  $TopicImageCopyWith<$Res>? get normal;
  $TopicImageCopyWith<$Res>? get raw;
}

/// @nodoc
class _$TopicPhotoCopyWithImpl<$Res, $Val extends TopicPhoto>
    implements $TopicPhotoCopyWith<$Res> {
  _$TopicPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? raw = freezed,
  }) {
    return _then(
      _value.copyWith(
            large: freezed == large
                ? _value.large
                : large // ignore: cast_nullable_to_non_nullable
                      as TopicImage?,
            normal: freezed == normal
                ? _value.normal
                : normal // ignore: cast_nullable_to_non_nullable
                      as TopicImage?,
            raw: freezed == raw
                ? _value.raw
                : raw // ignore: cast_nullable_to_non_nullable
                      as TopicImage?,
          )
          as $Val,
    );
  }

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopicImageCopyWith<$Res>? get large {
    if (_value.large == null) {
      return null;
    }

    return $TopicImageCopyWith<$Res>(_value.large!, (value) {
      return _then(_value.copyWith(large: value) as $Val);
    });
  }

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopicImageCopyWith<$Res>? get normal {
    if (_value.normal == null) {
      return null;
    }

    return $TopicImageCopyWith<$Res>(_value.normal!, (value) {
      return _then(_value.copyWith(normal: value) as $Val);
    });
  }

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopicImageCopyWith<$Res>? get raw {
    if (_value.raw == null) {
      return null;
    }

    return $TopicImageCopyWith<$Res>(_value.raw!, (value) {
      return _then(_value.copyWith(raw: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TopicPhotoImplCopyWith<$Res>
    implements $TopicPhotoCopyWith<$Res> {
  factory _$$TopicPhotoImplCopyWith(
    _$TopicPhotoImpl value,
    $Res Function(_$TopicPhotoImpl) then,
  ) = __$$TopicPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TopicImage? large, TopicImage? normal, TopicImage? raw});

  @override
  $TopicImageCopyWith<$Res>? get large;
  @override
  $TopicImageCopyWith<$Res>? get normal;
  @override
  $TopicImageCopyWith<$Res>? get raw;
}

/// @nodoc
class __$$TopicPhotoImplCopyWithImpl<$Res>
    extends _$TopicPhotoCopyWithImpl<$Res, _$TopicPhotoImpl>
    implements _$$TopicPhotoImplCopyWith<$Res> {
  __$$TopicPhotoImplCopyWithImpl(
    _$TopicPhotoImpl _value,
    $Res Function(_$TopicPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? raw = freezed,
  }) {
    return _then(
      _$TopicPhotoImpl(
        large: freezed == large
            ? _value.large
            : large // ignore: cast_nullable_to_non_nullable
                  as TopicImage?,
        normal: freezed == normal
            ? _value.normal
            : normal // ignore: cast_nullable_to_non_nullable
                  as TopicImage?,
        raw: freezed == raw
            ? _value.raw
            : raw // ignore: cast_nullable_to_non_nullable
                  as TopicImage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicPhotoImpl implements _TopicPhoto {
  const _$TopicPhotoImpl({this.large, this.normal, this.raw});

  factory _$TopicPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicPhotoImplFromJson(json);

  @override
  final TopicImage? large;
  @override
  final TopicImage? normal;
  @override
  final TopicImage? raw;

  @override
  String toString() {
    return 'TopicPhoto(large: $large, normal: $normal, raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicPhotoImpl &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.raw, raw) || other.raw == raw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, large, normal, raw);

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicPhotoImplCopyWith<_$TopicPhotoImpl> get copyWith =>
      __$$TopicPhotoImplCopyWithImpl<_$TopicPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicPhotoImplToJson(this);
  }
}

abstract class _TopicPhoto implements TopicPhoto {
  const factory _TopicPhoto({
    final TopicImage? large,
    final TopicImage? normal,
    final TopicImage? raw,
  }) = _$TopicPhotoImpl;

  factory _TopicPhoto.fromJson(Map<String, dynamic> json) =
      _$TopicPhotoImpl.fromJson;

  @override
  TopicImage? get large;
  @override
  TopicImage? get normal;
  @override
  TopicImage? get raw;

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicPhotoImplCopyWith<_$TopicPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicImage _$TopicImageFromJson(Map<String, dynamic> json) {
  return _TopicImage.fromJson(json);
}

/// @nodoc
mixin _$TopicImage {
  String? get url => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;

  /// Serializes this TopicImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicImageCopyWith<TopicImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicImageCopyWith<$Res> {
  factory $TopicImageCopyWith(
    TopicImage value,
    $Res Function(TopicImage) then,
  ) = _$TopicImageCopyWithImpl<$Res, TopicImage>;
  @useResult
  $Res call({String? url, int? width, int? height, int? size});
}

/// @nodoc
class _$TopicImageCopyWithImpl<$Res, $Val extends TopicImage>
    implements $TopicImageCopyWith<$Res> {
  _$TopicImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _value.copyWith(
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopicImageImplCopyWith<$Res>
    implements $TopicImageCopyWith<$Res> {
  factory _$$TopicImageImplCopyWith(
    _$TopicImageImpl value,
    $Res Function(_$TopicImageImpl) then,
  ) = __$$TopicImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, int? width, int? height, int? size});
}

/// @nodoc
class __$$TopicImageImplCopyWithImpl<$Res>
    extends _$TopicImageCopyWithImpl<$Res, _$TopicImageImpl>
    implements _$$TopicImageImplCopyWith<$Res> {
  __$$TopicImageImplCopyWithImpl(
    _$TopicImageImpl _value,
    $Res Function(_$TopicImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _$TopicImageImpl(
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicImageImpl implements _TopicImage {
  const _$TopicImageImpl({this.url, this.width, this.height, this.size});

  factory _$TopicImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicImageImplFromJson(json);

  @override
  final String? url;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final int? size;

  @override
  String toString() {
    return 'TopicImage(url: $url, width: $width, height: $height, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicImageImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, width, height, size);

  /// Create a copy of TopicImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicImageImplCopyWith<_$TopicImageImpl> get copyWith =>
      __$$TopicImageImplCopyWithImpl<_$TopicImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicImageImplToJson(this);
  }
}

abstract class _TopicImage implements TopicImage {
  const factory _TopicImage({
    final String? url,
    final int? width,
    final int? height,
    final int? size,
  }) = _$TopicImageImpl;

  factory _TopicImage.fromJson(Map<String, dynamic> json) =
      _$TopicImageImpl.fromJson;

  @override
  String? get url;
  @override
  int? get width;
  @override
  int? get height;
  @override
  int? get size;

  /// Create a copy of TopicImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicImageImplCopyWith<_$TopicImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
