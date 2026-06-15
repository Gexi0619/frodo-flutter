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
  @JsonKey(name: 'edit_time')
  String? get editTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_location')
  String? get ipLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'comments_count')
  int? get commentsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reactions_count')
  int? get reactionsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'collections_count')
  int? get collectionsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reshares_count')
  int? get resharesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_type')
  int get reactionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_layout')
  String? get imageLayout => throw _privateConstructorUsedError;
  List<TopicPhoto> get photos => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_info')
  TopicVideoInfo? get videoInfo => throw _privateConstructorUsedError;
  Author? get author => throw _privateConstructorUsedError;
  Group? get group => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'edit_time') String? editTime,
    @JsonKey(name: 'ip_location') String? ipLocation,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'collections_count') int? collectionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    @JsonKey(name: 'reaction_type') int reactionType,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'image_layout') String? imageLayout,
    List<TopicPhoto> photos,
    @JsonKey(name: 'video_info') TopicVideoInfo? videoInfo,
    Author? author,
    Group? group,
  });

  $TopicVideoInfoCopyWith<$Res>? get videoInfo;
  $AuthorCopyWith<$Res>? get author;
  $GroupCopyWith<$Res>? get group;
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
    Object? editTime = freezed,
    Object? ipLocation = freezed,
    Object? commentsCount = freezed,
    Object? reactionsCount = freezed,
    Object? collectionsCount = freezed,
    Object? resharesCount = freezed,
    Object? reactionType = null,
    Object? sharingUrl = freezed,
    Object? coverUrl = freezed,
    Object? imageLayout = freezed,
    Object? photos = null,
    Object? videoInfo = freezed,
    Object? author = freezed,
    Object? group = freezed,
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
            editTime: freezed == editTime
                ? _value.editTime
                : editTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            ipLocation: freezed == ipLocation
                ? _value.ipLocation
                : ipLocation // ignore: cast_nullable_to_non_nullable
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
            reactionType: null == reactionType
                ? _value.reactionType
                : reactionType // ignore: cast_nullable_to_non_nullable
                      as int,
            sharingUrl: freezed == sharingUrl
                ? _value.sharingUrl
                : sharingUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageLayout: freezed == imageLayout
                ? _value.imageLayout
                : imageLayout // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<TopicPhoto>,
            videoInfo: freezed == videoInfo
                ? _value.videoInfo
                : videoInfo // ignore: cast_nullable_to_non_nullable
                      as TopicVideoInfo?,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as Author?,
            group: freezed == group
                ? _value.group
                : group // ignore: cast_nullable_to_non_nullable
                      as Group?,
          )
          as $Val,
    );
  }

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopicVideoInfoCopyWith<$Res>? get videoInfo {
    if (_value.videoInfo == null) {
      return null;
    }

    return $TopicVideoInfoCopyWith<$Res>(_value.videoInfo!, (value) {
      return _then(_value.copyWith(videoInfo: value) as $Val);
    });
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

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupCopyWith<$Res>? get group {
    if (_value.group == null) {
      return null;
    }

    return $GroupCopyWith<$Res>(_value.group!, (value) {
      return _then(_value.copyWith(group: value) as $Val);
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
    @JsonKey(name: 'edit_time') String? editTime,
    @JsonKey(name: 'ip_location') String? ipLocation,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'collections_count') int? collectionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    @JsonKey(name: 'reaction_type') int reactionType,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'image_layout') String? imageLayout,
    List<TopicPhoto> photos,
    @JsonKey(name: 'video_info') TopicVideoInfo? videoInfo,
    Author? author,
    Group? group,
  });

  @override
  $TopicVideoInfoCopyWith<$Res>? get videoInfo;
  @override
  $AuthorCopyWith<$Res>? get author;
  @override
  $GroupCopyWith<$Res>? get group;
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
    Object? editTime = freezed,
    Object? ipLocation = freezed,
    Object? commentsCount = freezed,
    Object? reactionsCount = freezed,
    Object? collectionsCount = freezed,
    Object? resharesCount = freezed,
    Object? reactionType = null,
    Object? sharingUrl = freezed,
    Object? coverUrl = freezed,
    Object? imageLayout = freezed,
    Object? photos = null,
    Object? videoInfo = freezed,
    Object? author = freezed,
    Object? group = freezed,
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
        editTime: freezed == editTime
            ? _value.editTime
            : editTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        ipLocation: freezed == ipLocation
            ? _value.ipLocation
            : ipLocation // ignore: cast_nullable_to_non_nullable
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
        reactionType: null == reactionType
            ? _value.reactionType
            : reactionType // ignore: cast_nullable_to_non_nullable
                  as int,
        sharingUrl: freezed == sharingUrl
            ? _value.sharingUrl
            : sharingUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageLayout: freezed == imageLayout
            ? _value.imageLayout
            : imageLayout // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<TopicPhoto>,
        videoInfo: freezed == videoInfo
            ? _value.videoInfo
            : videoInfo // ignore: cast_nullable_to_non_nullable
                  as TopicVideoInfo?,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as Author?,
        group: freezed == group
            ? _value.group
            : group // ignore: cast_nullable_to_non_nullable
                  as Group?,
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
    @JsonKey(name: 'edit_time') this.editTime,
    @JsonKey(name: 'ip_location') this.ipLocation,
    @JsonKey(name: 'comments_count') this.commentsCount,
    @JsonKey(name: 'reactions_count') this.reactionsCount,
    @JsonKey(name: 'collections_count') this.collectionsCount,
    @JsonKey(name: 'reshares_count') this.resharesCount,
    @JsonKey(name: 'reaction_type') this.reactionType = 0,
    @JsonKey(name: 'sharing_url') this.sharingUrl,
    @JsonKey(name: 'cover_url') this.coverUrl,
    @JsonKey(name: 'image_layout') this.imageLayout,
    final List<TopicPhoto> photos = const <TopicPhoto>[],
    @JsonKey(name: 'video_info') this.videoInfo,
    this.author,
    this.group,
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
  @JsonKey(name: 'edit_time')
  final String? editTime;
  @override
  @JsonKey(name: 'ip_location')
  final String? ipLocation;
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
  @JsonKey(name: 'reaction_type')
  final int reactionType;
  @override
  @JsonKey(name: 'sharing_url')
  final String? sharingUrl;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @override
  @JsonKey(name: 'image_layout')
  final String? imageLayout;
  final List<TopicPhoto> _photos;
  @override
  @JsonKey()
  List<TopicPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey(name: 'video_info')
  final TopicVideoInfo? videoInfo;
  @override
  final Author? author;
  @override
  final Group? group;

  @override
  String toString() {
    return 'Topic(id: $id, title: $title, abstract: $abstract, content: $content, createTime: $createTime, updateTime: $updateTime, editTime: $editTime, ipLocation: $ipLocation, commentsCount: $commentsCount, reactionsCount: $reactionsCount, collectionsCount: $collectionsCount, resharesCount: $resharesCount, reactionType: $reactionType, sharingUrl: $sharingUrl, coverUrl: $coverUrl, imageLayout: $imageLayout, photos: $photos, videoInfo: $videoInfo, author: $author, group: $group)';
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
            (identical(other.editTime, editTime) ||
                other.editTime == editTime) &&
            (identical(other.ipLocation, ipLocation) ||
                other.ipLocation == ipLocation) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.reactionsCount, reactionsCount) ||
                other.reactionsCount == reactionsCount) &&
            (identical(other.collectionsCount, collectionsCount) ||
                other.collectionsCount == collectionsCount) &&
            (identical(other.resharesCount, resharesCount) ||
                other.resharesCount == resharesCount) &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType) &&
            (identical(other.sharingUrl, sharingUrl) ||
                other.sharingUrl == sharingUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.imageLayout, imageLayout) ||
                other.imageLayout == imageLayout) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.videoInfo, videoInfo) ||
                other.videoInfo == videoInfo) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.group, group) || other.group == group));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    abstract,
    content,
    createTime,
    updateTime,
    editTime,
    ipLocation,
    commentsCount,
    reactionsCount,
    collectionsCount,
    resharesCount,
    reactionType,
    sharingUrl,
    coverUrl,
    imageLayout,
    const DeepCollectionEquality().hash(_photos),
    videoInfo,
    author,
    group,
  ]);

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
    @JsonKey(name: 'edit_time') final String? editTime,
    @JsonKey(name: 'ip_location') final String? ipLocation,
    @JsonKey(name: 'comments_count') final int? commentsCount,
    @JsonKey(name: 'reactions_count') final int? reactionsCount,
    @JsonKey(name: 'collections_count') final int? collectionsCount,
    @JsonKey(name: 'reshares_count') final int? resharesCount,
    @JsonKey(name: 'reaction_type') final int reactionType,
    @JsonKey(name: 'sharing_url') final String? sharingUrl,
    @JsonKey(name: 'cover_url') final String? coverUrl,
    @JsonKey(name: 'image_layout') final String? imageLayout,
    final List<TopicPhoto> photos,
    @JsonKey(name: 'video_info') final TopicVideoInfo? videoInfo,
    final Author? author,
    final Group? group,
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
  @JsonKey(name: 'edit_time')
  String? get editTime;
  @override
  @JsonKey(name: 'ip_location')
  String? get ipLocation;
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
  @JsonKey(name: 'reaction_type')
  int get reactionType;
  @override
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  @JsonKey(name: 'image_layout')
  String? get imageLayout;
  @override
  List<TopicPhoto> get photos;
  @override
  @JsonKey(name: 'video_info')
  TopicVideoInfo? get videoInfo;
  @override
  Author? get author;
  @override
  Group? get group;

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
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  TopicPhotoImages? get images => throw _privateConstructorUsedError;

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
  $Res call({
    String? id,
    String? title,
    @JsonKey(name: 'image') TopicPhotoImages? images,
  });

  $TopicPhotoImagesCopyWith<$Res>? get images;
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
    Object? id = freezed,
    Object? title = freezed,
    Object? images = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as TopicPhotoImages?,
          )
          as $Val,
    );
  }

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopicPhotoImagesCopyWith<$Res>? get images {
    if (_value.images == null) {
      return null;
    }

    return $TopicPhotoImagesCopyWith<$Res>(_value.images!, (value) {
      return _then(_value.copyWith(images: value) as $Val);
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
  $Res call({
    String? id,
    String? title,
    @JsonKey(name: 'image') TopicPhotoImages? images,
  });

  @override
  $TopicPhotoImagesCopyWith<$Res>? get images;
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
    Object? id = freezed,
    Object? title = freezed,
    Object? images = freezed,
  }) {
    return _then(
      _$TopicPhotoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: freezed == images
            ? _value.images
            : images // ignore: cast_nullable_to_non_nullable
                  as TopicPhotoImages?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicPhotoImpl implements _TopicPhoto {
  const _$TopicPhotoImpl({
    this.id,
    this.title,
    @JsonKey(name: 'image') this.images,
  });

  factory _$TopicPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicPhotoImplFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  @JsonKey(name: 'image')
  final TopicPhotoImages? images;

  @override
  String toString() {
    return 'TopicPhoto(id: $id, title: $title, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.images, images) || other.images == images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, images);

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
    final String? id,
    final String? title,
    @JsonKey(name: 'image') final TopicPhotoImages? images,
  }) = _$TopicPhotoImpl;

  factory _TopicPhoto.fromJson(Map<String, dynamic> json) =
      _$TopicPhotoImpl.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  @JsonKey(name: 'image')
  TopicPhotoImages? get images;

  /// Create a copy of TopicPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicPhotoImplCopyWith<_$TopicPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicPhotoImages _$TopicPhotoImagesFromJson(Map<String, dynamic> json) {
  return _TopicPhotoImages.fromJson(json);
}

/// @nodoc
mixin _$TopicPhotoImages {
  TopicImage? get large => throw _privateConstructorUsedError;
  TopicImage? get normal => throw _privateConstructorUsedError;
  TopicImage? get raw => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_live')
  bool get isLive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_animated')
  bool get isAnimated => throw _privateConstructorUsedError;
  TopicVideo? get video => throw _privateConstructorUsedError;

  /// Serializes this TopicPhotoImages to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicPhotoImages
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicPhotoImagesCopyWith<TopicPhotoImages> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicPhotoImagesCopyWith<$Res> {
  factory $TopicPhotoImagesCopyWith(
    TopicPhotoImages value,
    $Res Function(TopicPhotoImages) then,
  ) = _$TopicPhotoImagesCopyWithImpl<$Res, TopicPhotoImages>;
  @useResult
  $Res call({
    TopicImage? large,
    TopicImage? normal,
    TopicImage? raw,
    @JsonKey(name: 'is_live') bool isLive,
    @JsonKey(name: 'is_animated') bool isAnimated,
    TopicVideo? video,
  });

  $TopicImageCopyWith<$Res>? get large;
  $TopicImageCopyWith<$Res>? get normal;
  $TopicImageCopyWith<$Res>? get raw;
  $TopicVideoCopyWith<$Res>? get video;
}

/// @nodoc
class _$TopicPhotoImagesCopyWithImpl<$Res, $Val extends TopicPhotoImages>
    implements $TopicPhotoImagesCopyWith<$Res> {
  _$TopicPhotoImagesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicPhotoImages
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? raw = freezed,
    Object? isLive = null,
    Object? isAnimated = null,
    Object? video = freezed,
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
            isLive: null == isLive
                ? _value.isLive
                : isLive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAnimated: null == isAnimated
                ? _value.isAnimated
                : isAnimated // ignore: cast_nullable_to_non_nullable
                      as bool,
            video: freezed == video
                ? _value.video
                : video // ignore: cast_nullable_to_non_nullable
                      as TopicVideo?,
          )
          as $Val,
    );
  }

  /// Create a copy of TopicPhotoImages
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

  /// Create a copy of TopicPhotoImages
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

  /// Create a copy of TopicPhotoImages
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

  /// Create a copy of TopicPhotoImages
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopicVideoCopyWith<$Res>? get video {
    if (_value.video == null) {
      return null;
    }

    return $TopicVideoCopyWith<$Res>(_value.video!, (value) {
      return _then(_value.copyWith(video: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TopicPhotoImagesImplCopyWith<$Res>
    implements $TopicPhotoImagesCopyWith<$Res> {
  factory _$$TopicPhotoImagesImplCopyWith(
    _$TopicPhotoImagesImpl value,
    $Res Function(_$TopicPhotoImagesImpl) then,
  ) = __$$TopicPhotoImagesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TopicImage? large,
    TopicImage? normal,
    TopicImage? raw,
    @JsonKey(name: 'is_live') bool isLive,
    @JsonKey(name: 'is_animated') bool isAnimated,
    TopicVideo? video,
  });

  @override
  $TopicImageCopyWith<$Res>? get large;
  @override
  $TopicImageCopyWith<$Res>? get normal;
  @override
  $TopicImageCopyWith<$Res>? get raw;
  @override
  $TopicVideoCopyWith<$Res>? get video;
}

/// @nodoc
class __$$TopicPhotoImagesImplCopyWithImpl<$Res>
    extends _$TopicPhotoImagesCopyWithImpl<$Res, _$TopicPhotoImagesImpl>
    implements _$$TopicPhotoImagesImplCopyWith<$Res> {
  __$$TopicPhotoImagesImplCopyWithImpl(
    _$TopicPhotoImagesImpl _value,
    $Res Function(_$TopicPhotoImagesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicPhotoImages
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? raw = freezed,
    Object? isLive = null,
    Object? isAnimated = null,
    Object? video = freezed,
  }) {
    return _then(
      _$TopicPhotoImagesImpl(
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
        isLive: null == isLive
            ? _value.isLive
            : isLive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAnimated: null == isAnimated
            ? _value.isAnimated
            : isAnimated // ignore: cast_nullable_to_non_nullable
                  as bool,
        video: freezed == video
            ? _value.video
            : video // ignore: cast_nullable_to_non_nullable
                  as TopicVideo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicPhotoImagesImpl implements _TopicPhotoImages {
  const _$TopicPhotoImagesImpl({
    this.large,
    this.normal,
    this.raw,
    @JsonKey(name: 'is_live') this.isLive = false,
    @JsonKey(name: 'is_animated') this.isAnimated = false,
    this.video,
  });

  factory _$TopicPhotoImagesImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicPhotoImagesImplFromJson(json);

  @override
  final TopicImage? large;
  @override
  final TopicImage? normal;
  @override
  final TopicImage? raw;
  @override
  @JsonKey(name: 'is_live')
  final bool isLive;
  @override
  @JsonKey(name: 'is_animated')
  final bool isAnimated;
  @override
  final TopicVideo? video;

  @override
  String toString() {
    return 'TopicPhotoImages(large: $large, normal: $normal, raw: $raw, isLive: $isLive, isAnimated: $isAnimated, video: $video)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicPhotoImagesImpl &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.raw, raw) || other.raw == raw) &&
            (identical(other.isLive, isLive) || other.isLive == isLive) &&
            (identical(other.isAnimated, isAnimated) ||
                other.isAnimated == isAnimated) &&
            (identical(other.video, video) || other.video == video));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, large, normal, raw, isLive, isAnimated, video);

  /// Create a copy of TopicPhotoImages
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicPhotoImagesImplCopyWith<_$TopicPhotoImagesImpl> get copyWith =>
      __$$TopicPhotoImagesImplCopyWithImpl<_$TopicPhotoImagesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicPhotoImagesImplToJson(this);
  }
}

abstract class _TopicPhotoImages implements TopicPhotoImages {
  const factory _TopicPhotoImages({
    final TopicImage? large,
    final TopicImage? normal,
    final TopicImage? raw,
    @JsonKey(name: 'is_live') final bool isLive,
    @JsonKey(name: 'is_animated') final bool isAnimated,
    final TopicVideo? video,
  }) = _$TopicPhotoImagesImpl;

  factory _TopicPhotoImages.fromJson(Map<String, dynamic> json) =
      _$TopicPhotoImagesImpl.fromJson;

  @override
  TopicImage? get large;
  @override
  TopicImage? get normal;
  @override
  TopicImage? get raw;
  @override
  @JsonKey(name: 'is_live')
  bool get isLive;
  @override
  @JsonKey(name: 'is_animated')
  bool get isAnimated;
  @override
  TopicVideo? get video;

  /// Create a copy of TopicPhotoImages
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicPhotoImagesImplCopyWith<_$TopicPhotoImagesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicVideoInfo _$TopicVideoInfoFromJson(Map<String, dynamic> json) {
  return _TopicVideoInfo.fromJson(json);
}

/// @nodoc
mixin _$TopicVideoInfo {
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_width')
  int? get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_height')
  int? get height => throw _privateConstructorUsedError;

  /// 审核/播放状态：0 表示尚不可公开播放（配合 [alertText] 提示）。
  @JsonKey(name: 'play_status')
  int get playStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'alert_text')
  String? get alertText => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_aigc')
  bool get isAigc => throw _privateConstructorUsedError;

  /// Serializes this TopicVideoInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicVideoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicVideoInfoCopyWith<TopicVideoInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicVideoInfoCopyWith<$Res> {
  factory $TopicVideoInfoCopyWith(
    TopicVideoInfo value,
    $Res Function(TopicVideoInfo) then,
  ) = _$TopicVideoInfoCopyWithImpl<$Res, TopicVideoInfo>;
  @useResult
  $Res call({
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    String? duration,
    @JsonKey(name: 'video_width') int? width,
    @JsonKey(name: 'video_height') int? height,
    @JsonKey(name: 'play_status') int playStatus,
    @JsonKey(name: 'alert_text') String? alertText,
    @JsonKey(name: 'is_aigc') bool isAigc,
  });
}

/// @nodoc
class _$TopicVideoInfoCopyWithImpl<$Res, $Val extends TopicVideoInfo>
    implements $TopicVideoInfoCopyWith<$Res> {
  _$TopicVideoInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicVideoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoUrl = freezed,
    Object? coverUrl = freezed,
    Object? duration = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? playStatus = null,
    Object? alertText = freezed,
    Object? isAigc = null,
  }) {
    return _then(
      _value.copyWith(
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            playStatus: null == playStatus
                ? _value.playStatus
                : playStatus // ignore: cast_nullable_to_non_nullable
                      as int,
            alertText: freezed == alertText
                ? _value.alertText
                : alertText // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAigc: null == isAigc
                ? _value.isAigc
                : isAigc // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopicVideoInfoImplCopyWith<$Res>
    implements $TopicVideoInfoCopyWith<$Res> {
  factory _$$TopicVideoInfoImplCopyWith(
    _$TopicVideoInfoImpl value,
    $Res Function(_$TopicVideoInfoImpl) then,
  ) = __$$TopicVideoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    String? duration,
    @JsonKey(name: 'video_width') int? width,
    @JsonKey(name: 'video_height') int? height,
    @JsonKey(name: 'play_status') int playStatus,
    @JsonKey(name: 'alert_text') String? alertText,
    @JsonKey(name: 'is_aigc') bool isAigc,
  });
}

/// @nodoc
class __$$TopicVideoInfoImplCopyWithImpl<$Res>
    extends _$TopicVideoInfoCopyWithImpl<$Res, _$TopicVideoInfoImpl>
    implements _$$TopicVideoInfoImplCopyWith<$Res> {
  __$$TopicVideoInfoImplCopyWithImpl(
    _$TopicVideoInfoImpl _value,
    $Res Function(_$TopicVideoInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicVideoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoUrl = freezed,
    Object? coverUrl = freezed,
    Object? duration = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? playStatus = null,
    Object? alertText = freezed,
    Object? isAigc = null,
  }) {
    return _then(
      _$TopicVideoInfoImpl(
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        playStatus: null == playStatus
            ? _value.playStatus
            : playStatus // ignore: cast_nullable_to_non_nullable
                  as int,
        alertText: freezed == alertText
            ? _value.alertText
            : alertText // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAigc: null == isAigc
            ? _value.isAigc
            : isAigc // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicVideoInfoImpl implements _TopicVideoInfo {
  const _$TopicVideoInfoImpl({
    @JsonKey(name: 'video_url') this.videoUrl,
    @JsonKey(name: 'cover_url') this.coverUrl,
    this.duration,
    @JsonKey(name: 'video_width') this.width,
    @JsonKey(name: 'video_height') this.height,
    @JsonKey(name: 'play_status') this.playStatus = 0,
    @JsonKey(name: 'alert_text') this.alertText,
    @JsonKey(name: 'is_aigc') this.isAigc = false,
  });

  factory _$TopicVideoInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicVideoInfoImplFromJson(json);

  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @override
  final String? duration;
  @override
  @JsonKey(name: 'video_width')
  final int? width;
  @override
  @JsonKey(name: 'video_height')
  final int? height;

  /// 审核/播放状态：0 表示尚不可公开播放（配合 [alertText] 提示）。
  @override
  @JsonKey(name: 'play_status')
  final int playStatus;
  @override
  @JsonKey(name: 'alert_text')
  final String? alertText;
  @override
  @JsonKey(name: 'is_aigc')
  final bool isAigc;

  @override
  String toString() {
    return 'TopicVideoInfo(videoUrl: $videoUrl, coverUrl: $coverUrl, duration: $duration, width: $width, height: $height, playStatus: $playStatus, alertText: $alertText, isAigc: $isAigc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicVideoInfoImpl &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.playStatus, playStatus) ||
                other.playStatus == playStatus) &&
            (identical(other.alertText, alertText) ||
                other.alertText == alertText) &&
            (identical(other.isAigc, isAigc) || other.isAigc == isAigc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    videoUrl,
    coverUrl,
    duration,
    width,
    height,
    playStatus,
    alertText,
    isAigc,
  );

  /// Create a copy of TopicVideoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicVideoInfoImplCopyWith<_$TopicVideoInfoImpl> get copyWith =>
      __$$TopicVideoInfoImplCopyWithImpl<_$TopicVideoInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicVideoInfoImplToJson(this);
  }
}

abstract class _TopicVideoInfo implements TopicVideoInfo {
  const factory _TopicVideoInfo({
    @JsonKey(name: 'video_url') final String? videoUrl,
    @JsonKey(name: 'cover_url') final String? coverUrl,
    final String? duration,
    @JsonKey(name: 'video_width') final int? width,
    @JsonKey(name: 'video_height') final int? height,
    @JsonKey(name: 'play_status') final int playStatus,
    @JsonKey(name: 'alert_text') final String? alertText,
    @JsonKey(name: 'is_aigc') final bool isAigc,
  }) = _$TopicVideoInfoImpl;

  factory _TopicVideoInfo.fromJson(Map<String, dynamic> json) =
      _$TopicVideoInfoImpl.fromJson;

  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  String? get duration;
  @override
  @JsonKey(name: 'video_width')
  int? get width;
  @override
  @JsonKey(name: 'video_height')
  int? get height;

  /// 审核/播放状态：0 表示尚不可公开播放（配合 [alertText] 提示）。
  @override
  @JsonKey(name: 'play_status')
  int get playStatus;
  @override
  @JsonKey(name: 'alert_text')
  String? get alertText;
  @override
  @JsonKey(name: 'is_aigc')
  bool get isAigc;

  /// Create a copy of TopicVideoInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicVideoInfoImplCopyWith<_$TopicVideoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicVideo _$TopicVideoFromJson(Map<String, dynamic> json) {
  return _TopicVideo.fromJson(json);
}

/// @nodoc
mixin _$TopicVideo {
  String? get url => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_audio')
  bool get hasAudio => throw _privateConstructorUsedError;

  /// Serializes this TopicVideo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicVideoCopyWith<TopicVideo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicVideoCopyWith<$Res> {
  factory $TopicVideoCopyWith(
    TopicVideo value,
    $Res Function(TopicVideo) then,
  ) = _$TopicVideoCopyWithImpl<$Res, TopicVideo>;
  @useResult
  $Res call({
    String? url,
    int? width,
    int? height,
    @JsonKey(name: 'has_audio') bool hasAudio,
  });
}

/// @nodoc
class _$TopicVideoCopyWithImpl<$Res, $Val extends TopicVideo>
    implements $TopicVideoCopyWith<$Res> {
  _$TopicVideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? hasAudio = null,
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
            hasAudio: null == hasAudio
                ? _value.hasAudio
                : hasAudio // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopicVideoImplCopyWith<$Res>
    implements $TopicVideoCopyWith<$Res> {
  factory _$$TopicVideoImplCopyWith(
    _$TopicVideoImpl value,
    $Res Function(_$TopicVideoImpl) then,
  ) = __$$TopicVideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? url,
    int? width,
    int? height,
    @JsonKey(name: 'has_audio') bool hasAudio,
  });
}

/// @nodoc
class __$$TopicVideoImplCopyWithImpl<$Res>
    extends _$TopicVideoCopyWithImpl<$Res, _$TopicVideoImpl>
    implements _$$TopicVideoImplCopyWith<$Res> {
  __$$TopicVideoImplCopyWithImpl(
    _$TopicVideoImpl _value,
    $Res Function(_$TopicVideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? hasAudio = null,
  }) {
    return _then(
      _$TopicVideoImpl(
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
        hasAudio: null == hasAudio
            ? _value.hasAudio
            : hasAudio // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicVideoImpl implements _TopicVideo {
  const _$TopicVideoImpl({
    this.url,
    this.width,
    this.height,
    @JsonKey(name: 'has_audio') this.hasAudio = false,
  });

  factory _$TopicVideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicVideoImplFromJson(json);

  @override
  final String? url;
  @override
  final int? width;
  @override
  final int? height;
  @override
  @JsonKey(name: 'has_audio')
  final bool hasAudio;

  @override
  String toString() {
    return 'TopicVideo(url: $url, width: $width, height: $height, hasAudio: $hasAudio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicVideoImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.hasAudio, hasAudio) ||
                other.hasAudio == hasAudio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, width, height, hasAudio);

  /// Create a copy of TopicVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicVideoImplCopyWith<_$TopicVideoImpl> get copyWith =>
      __$$TopicVideoImplCopyWithImpl<_$TopicVideoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicVideoImplToJson(this);
  }
}

abstract class _TopicVideo implements TopicVideo {
  const factory _TopicVideo({
    final String? url,
    final int? width,
    final int? height,
    @JsonKey(name: 'has_audio') final bool hasAudio,
  }) = _$TopicVideoImpl;

  factory _TopicVideo.fromJson(Map<String, dynamic> json) =
      _$TopicVideoImpl.fromJson;

  @override
  String? get url;
  @override
  int? get width;
  @override
  int? get height;
  @override
  @JsonKey(name: 'has_audio')
  bool get hasAudio;

  /// Create a copy of TopicVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicVideoImplCopyWith<_$TopicVideoImpl> get copyWith =>
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
