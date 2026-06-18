// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get id => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_time')
  String? get createTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'vote_count')
  int? get voteCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_replies')
  int? get totalReplies => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_reply_start')
  int? get nextReplyStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_voted')
  bool? get isVoted => throw _privateConstructorUsedError;
  List<CommentPhoto> get photos => throw _privateConstructorUsedError;
  List<Comment> get replies => throw _privateConstructorUsedError;
  Author? get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'ref_comment')
  Comment? get refComment => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_comment_id')
  String? get parentCommentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_location')
  String? get ipLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_folded')
  bool get isFolded => throw _privateConstructorUsedError;
  @JsonKey(name: 'folded_reason_text')
  String? get foldedReasonText => throw _privateConstructorUsedError;
  @JsonKey(name: 'folded_message')
  String? get foldedMessage => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call({
    String id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'total_replies') int? totalReplies,
    @JsonKey(name: 'next_reply_start') int? nextReplyStart,
    @JsonKey(name: 'is_voted') bool? isVoted,
    List<CommentPhoto> photos,
    List<Comment> replies,
    Author? author,
    @JsonKey(name: 'ref_comment') Comment? refComment,
    @JsonKey(name: 'parent_comment_id') String? parentCommentId,
    @JsonKey(name: 'ip_location') String? ipLocation,
    @JsonKey(name: 'is_folded') bool isFolded,
    @JsonKey(name: 'folded_reason_text') String? foldedReasonText,
    @JsonKey(name: 'folded_message') String? foldedMessage,
  });

  $AuthorCopyWith<$Res>? get author;
  $CommentCopyWith<$Res>? get refComment;
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = freezed,
    Object? createTime = freezed,
    Object? voteCount = freezed,
    Object? totalReplies = freezed,
    Object? nextReplyStart = freezed,
    Object? isVoted = freezed,
    Object? photos = null,
    Object? replies = null,
    Object? author = freezed,
    Object? refComment = freezed,
    Object? parentCommentId = freezed,
    Object? ipLocation = freezed,
    Object? isFolded = null,
    Object? foldedReasonText = freezed,
    Object? foldedMessage = freezed,
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
            voteCount: freezed == voteCount
                ? _value.voteCount
                : voteCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalReplies: freezed == totalReplies
                ? _value.totalReplies
                : totalReplies // ignore: cast_nullable_to_non_nullable
                      as int?,
            nextReplyStart: freezed == nextReplyStart
                ? _value.nextReplyStart
                : nextReplyStart // ignore: cast_nullable_to_non_nullable
                      as int?,
            isVoted: freezed == isVoted
                ? _value.isVoted
                : isVoted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<CommentPhoto>,
            replies: null == replies
                ? _value.replies
                : replies // ignore: cast_nullable_to_non_nullable
                      as List<Comment>,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as Author?,
            refComment: freezed == refComment
                ? _value.refComment
                : refComment // ignore: cast_nullable_to_non_nullable
                      as Comment?,
            parentCommentId: freezed == parentCommentId
                ? _value.parentCommentId
                : parentCommentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            ipLocation: freezed == ipLocation
                ? _value.ipLocation
                : ipLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFolded: null == isFolded
                ? _value.isFolded
                : isFolded // ignore: cast_nullable_to_non_nullable
                      as bool,
            foldedReasonText: freezed == foldedReasonText
                ? _value.foldedReasonText
                : foldedReasonText // ignore: cast_nullable_to_non_nullable
                      as String?,
            foldedMessage: freezed == foldedMessage
                ? _value.foldedMessage
                : foldedMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Comment
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

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentCopyWith<$Res>? get refComment {
    if (_value.refComment == null) {
      return null;
    }

    return $CommentCopyWith<$Res>(_value.refComment!, (value) {
      return _then(_value.copyWith(refComment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
    _$CommentImpl value,
    $Res Function(_$CommentImpl) then,
  ) = __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'total_replies') int? totalReplies,
    @JsonKey(name: 'next_reply_start') int? nextReplyStart,
    @JsonKey(name: 'is_voted') bool? isVoted,
    List<CommentPhoto> photos,
    List<Comment> replies,
    Author? author,
    @JsonKey(name: 'ref_comment') Comment? refComment,
    @JsonKey(name: 'parent_comment_id') String? parentCommentId,
    @JsonKey(name: 'ip_location') String? ipLocation,
    @JsonKey(name: 'is_folded') bool isFolded,
    @JsonKey(name: 'folded_reason_text') String? foldedReasonText,
    @JsonKey(name: 'folded_message') String? foldedMessage,
  });

  @override
  $AuthorCopyWith<$Res>? get author;
  @override
  $CommentCopyWith<$Res>? get refComment;
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
    _$CommentImpl _value,
    $Res Function(_$CommentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = freezed,
    Object? createTime = freezed,
    Object? voteCount = freezed,
    Object? totalReplies = freezed,
    Object? nextReplyStart = freezed,
    Object? isVoted = freezed,
    Object? photos = null,
    Object? replies = null,
    Object? author = freezed,
    Object? refComment = freezed,
    Object? parentCommentId = freezed,
    Object? ipLocation = freezed,
    Object? isFolded = null,
    Object? foldedReasonText = freezed,
    Object? foldedMessage = freezed,
  }) {
    return _then(
      _$CommentImpl(
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
        voteCount: freezed == voteCount
            ? _value.voteCount
            : voteCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalReplies: freezed == totalReplies
            ? _value.totalReplies
            : totalReplies // ignore: cast_nullable_to_non_nullable
                  as int?,
        nextReplyStart: freezed == nextReplyStart
            ? _value.nextReplyStart
            : nextReplyStart // ignore: cast_nullable_to_non_nullable
                  as int?,
        isVoted: freezed == isVoted
            ? _value.isVoted
            : isVoted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<CommentPhoto>,
        replies: null == replies
            ? _value._replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as List<Comment>,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as Author?,
        refComment: freezed == refComment
            ? _value.refComment
            : refComment // ignore: cast_nullable_to_non_nullable
                  as Comment?,
        parentCommentId: freezed == parentCommentId
            ? _value.parentCommentId
            : parentCommentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        ipLocation: freezed == ipLocation
            ? _value.ipLocation
            : ipLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFolded: null == isFolded
            ? _value.isFolded
            : isFolded // ignore: cast_nullable_to_non_nullable
                  as bool,
        foldedReasonText: freezed == foldedReasonText
            ? _value.foldedReasonText
            : foldedReasonText // ignore: cast_nullable_to_non_nullable
                  as String?,
        foldedMessage: freezed == foldedMessage
            ? _value.foldedMessage
            : foldedMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl({
    required this.id,
    this.text,
    @JsonKey(name: 'create_time') this.createTime,
    @JsonKey(name: 'vote_count') this.voteCount,
    @JsonKey(name: 'total_replies') this.totalReplies,
    @JsonKey(name: 'next_reply_start') this.nextReplyStart,
    @JsonKey(name: 'is_voted') this.isVoted,
    final List<CommentPhoto> photos = const <CommentPhoto>[],
    final List<Comment> replies = const <Comment>[],
    this.author,
    @JsonKey(name: 'ref_comment') this.refComment,
    @JsonKey(name: 'parent_comment_id') this.parentCommentId,
    @JsonKey(name: 'ip_location') this.ipLocation,
    @JsonKey(name: 'is_folded') this.isFolded = false,
    @JsonKey(name: 'folded_reason_text') this.foldedReasonText,
    @JsonKey(name: 'folded_message') this.foldedMessage,
  }) : _photos = photos,
       _replies = replies;

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  final String id;
  @override
  final String? text;
  @override
  @JsonKey(name: 'create_time')
  final String? createTime;
  @override
  @JsonKey(name: 'vote_count')
  final int? voteCount;
  @override
  @JsonKey(name: 'total_replies')
  final int? totalReplies;
  @override
  @JsonKey(name: 'next_reply_start')
  final int? nextReplyStart;
  @override
  @JsonKey(name: 'is_voted')
  final bool? isVoted;
  final List<CommentPhoto> _photos;
  @override
  @JsonKey()
  List<CommentPhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  final List<Comment> _replies;
  @override
  @JsonKey()
  List<Comment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  final Author? author;
  @override
  @JsonKey(name: 'ref_comment')
  final Comment? refComment;
  @override
  @JsonKey(name: 'parent_comment_id')
  final String? parentCommentId;
  @override
  @JsonKey(name: 'ip_location')
  final String? ipLocation;
  @override
  @JsonKey(name: 'is_folded')
  final bool isFolded;
  @override
  @JsonKey(name: 'folded_reason_text')
  final String? foldedReasonText;
  @override
  @JsonKey(name: 'folded_message')
  final String? foldedMessage;

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createTime: $createTime, voteCount: $voteCount, totalReplies: $totalReplies, nextReplyStart: $nextReplyStart, isVoted: $isVoted, photos: $photos, replies: $replies, author: $author, refComment: $refComment, parentCommentId: $parentCommentId, ipLocation: $ipLocation, isFolded: $isFolded, foldedReasonText: $foldedReasonText, foldedMessage: $foldedMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            (identical(other.totalReplies, totalReplies) ||
                other.totalReplies == totalReplies) &&
            (identical(other.nextReplyStart, nextReplyStart) ||
                other.nextReplyStart == nextReplyStart) &&
            (identical(other.isVoted, isVoted) || other.isVoted == isVoted) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.refComment, refComment) ||
                other.refComment == refComment) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.ipLocation, ipLocation) ||
                other.ipLocation == ipLocation) &&
            (identical(other.isFolded, isFolded) ||
                other.isFolded == isFolded) &&
            (identical(other.foldedReasonText, foldedReasonText) ||
                other.foldedReasonText == foldedReasonText) &&
            (identical(other.foldedMessage, foldedMessage) ||
                other.foldedMessage == foldedMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    text,
    createTime,
    voteCount,
    totalReplies,
    nextReplyStart,
    isVoted,
    const DeepCollectionEquality().hash(_photos),
    const DeepCollectionEquality().hash(_replies),
    author,
    refComment,
    parentCommentId,
    ipLocation,
    isFolded,
    foldedReasonText,
    foldedMessage,
  );

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(this);
  }
}

abstract class _Comment implements Comment {
  const factory _Comment({
    required final String id,
    final String? text,
    @JsonKey(name: 'create_time') final String? createTime,
    @JsonKey(name: 'vote_count') final int? voteCount,
    @JsonKey(name: 'total_replies') final int? totalReplies,
    @JsonKey(name: 'next_reply_start') final int? nextReplyStart,
    @JsonKey(name: 'is_voted') final bool? isVoted,
    final List<CommentPhoto> photos,
    final List<Comment> replies,
    final Author? author,
    @JsonKey(name: 'ref_comment') final Comment? refComment,
    @JsonKey(name: 'parent_comment_id') final String? parentCommentId,
    @JsonKey(name: 'ip_location') final String? ipLocation,
    @JsonKey(name: 'is_folded') final bool isFolded,
    @JsonKey(name: 'folded_reason_text') final String? foldedReasonText,
    @JsonKey(name: 'folded_message') final String? foldedMessage,
  }) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  String get id;
  @override
  String? get text;
  @override
  @JsonKey(name: 'create_time')
  String? get createTime;
  @override
  @JsonKey(name: 'vote_count')
  int? get voteCount;
  @override
  @JsonKey(name: 'total_replies')
  int? get totalReplies;
  @override
  @JsonKey(name: 'next_reply_start')
  int? get nextReplyStart;
  @override
  @JsonKey(name: 'is_voted')
  bool? get isVoted;
  @override
  List<CommentPhoto> get photos;
  @override
  List<Comment> get replies;
  @override
  Author? get author;
  @override
  @JsonKey(name: 'ref_comment')
  Comment? get refComment;
  @override
  @JsonKey(name: 'parent_comment_id')
  String? get parentCommentId;
  @override
  @JsonKey(name: 'ip_location')
  String? get ipLocation;
  @override
  @JsonKey(name: 'is_folded')
  bool get isFolded;
  @override
  @JsonKey(name: 'folded_reason_text')
  String? get foldedReasonText;
  @override
  @JsonKey(name: 'folded_message')
  String? get foldedMessage;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentPhoto _$CommentPhotoFromJson(Map<String, dynamic> json) {
  return _CommentPhoto.fromJson(json);
}

/// @nodoc
mixin _$CommentPhoto {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  CommentPhotoImage? get image => throw _privateConstructorUsedError;

  /// Serializes this CommentPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentPhotoCopyWith<CommentPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentPhotoCopyWith<$Res> {
  factory $CommentPhotoCopyWith(
    CommentPhoto value,
    $Res Function(CommentPhoto) then,
  ) = _$CommentPhotoCopyWithImpl<$Res, CommentPhoto>;
  @useResult
  $Res call({String? id, @JsonKey(name: 'image') CommentPhotoImage? image});

  $CommentPhotoImageCopyWith<$Res>? get image;
}

/// @nodoc
class _$CommentPhotoCopyWithImpl<$Res, $Val extends CommentPhoto>
    implements $CommentPhotoCopyWith<$Res> {
  _$CommentPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? image = freezed}) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as CommentPhotoImage?,
          )
          as $Val,
    );
  }

  /// Create a copy of CommentPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentPhotoImageCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $CommentPhotoImageCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentPhotoImplCopyWith<$Res>
    implements $CommentPhotoCopyWith<$Res> {
  factory _$$CommentPhotoImplCopyWith(
    _$CommentPhotoImpl value,
    $Res Function(_$CommentPhotoImpl) then,
  ) = __$$CommentPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, @JsonKey(name: 'image') CommentPhotoImage? image});

  @override
  $CommentPhotoImageCopyWith<$Res>? get image;
}

/// @nodoc
class __$$CommentPhotoImplCopyWithImpl<$Res>
    extends _$CommentPhotoCopyWithImpl<$Res, _$CommentPhotoImpl>
    implements _$$CommentPhotoImplCopyWith<$Res> {
  __$$CommentPhotoImplCopyWithImpl(
    _$CommentPhotoImpl _value,
    $Res Function(_$CommentPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? image = freezed}) {
    return _then(
      _$CommentPhotoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as CommentPhotoImage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentPhotoImpl implements _CommentPhoto {
  const _$CommentPhotoImpl({this.id, @JsonKey(name: 'image') this.image});

  factory _$CommentPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentPhotoImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'image')
  final CommentPhotoImage? image;

  @override
  String toString() {
    return 'CommentPhoto(id: $id, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, image);

  /// Create a copy of CommentPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentPhotoImplCopyWith<_$CommentPhotoImpl> get copyWith =>
      __$$CommentPhotoImplCopyWithImpl<_$CommentPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentPhotoImplToJson(this);
  }
}

abstract class _CommentPhoto implements CommentPhoto {
  const factory _CommentPhoto({
    final String? id,
    @JsonKey(name: 'image') final CommentPhotoImage? image,
  }) = _$CommentPhotoImpl;

  factory _CommentPhoto.fromJson(Map<String, dynamic> json) =
      _$CommentPhotoImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'image')
  CommentPhotoImage? get image;

  /// Create a copy of CommentPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentPhotoImplCopyWith<_$CommentPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentPhotoImage _$CommentPhotoImageFromJson(Map<String, dynamic> json) {
  return _CommentPhotoImage.fromJson(json);
}

/// @nodoc
mixin _$CommentPhotoImage {
  CommentPhotoSize? get large => throw _privateConstructorUsedError;
  CommentPhotoSize? get normal => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_animated')
  bool get isAnimated => throw _privateConstructorUsedError;

  /// Serializes this CommentPhotoImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentPhotoImageCopyWith<CommentPhotoImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentPhotoImageCopyWith<$Res> {
  factory $CommentPhotoImageCopyWith(
    CommentPhotoImage value,
    $Res Function(CommentPhotoImage) then,
  ) = _$CommentPhotoImageCopyWithImpl<$Res, CommentPhotoImage>;
  @useResult
  $Res call({
    CommentPhotoSize? large,
    CommentPhotoSize? normal,
    @JsonKey(name: 'is_animated') bool isAnimated,
  });

  $CommentPhotoSizeCopyWith<$Res>? get large;
  $CommentPhotoSizeCopyWith<$Res>? get normal;
}

/// @nodoc
class _$CommentPhotoImageCopyWithImpl<$Res, $Val extends CommentPhotoImage>
    implements $CommentPhotoImageCopyWith<$Res> {
  _$CommentPhotoImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? isAnimated = null,
  }) {
    return _then(
      _value.copyWith(
            large: freezed == large
                ? _value.large
                : large // ignore: cast_nullable_to_non_nullable
                      as CommentPhotoSize?,
            normal: freezed == normal
                ? _value.normal
                : normal // ignore: cast_nullable_to_non_nullable
                      as CommentPhotoSize?,
            isAnimated: null == isAnimated
                ? _value.isAnimated
                : isAnimated // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentPhotoSizeCopyWith<$Res>? get large {
    if (_value.large == null) {
      return null;
    }

    return $CommentPhotoSizeCopyWith<$Res>(_value.large!, (value) {
      return _then(_value.copyWith(large: value) as $Val);
    });
  }

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentPhotoSizeCopyWith<$Res>? get normal {
    if (_value.normal == null) {
      return null;
    }

    return $CommentPhotoSizeCopyWith<$Res>(_value.normal!, (value) {
      return _then(_value.copyWith(normal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentPhotoImageImplCopyWith<$Res>
    implements $CommentPhotoImageCopyWith<$Res> {
  factory _$$CommentPhotoImageImplCopyWith(
    _$CommentPhotoImageImpl value,
    $Res Function(_$CommentPhotoImageImpl) then,
  ) = __$$CommentPhotoImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CommentPhotoSize? large,
    CommentPhotoSize? normal,
    @JsonKey(name: 'is_animated') bool isAnimated,
  });

  @override
  $CommentPhotoSizeCopyWith<$Res>? get large;
  @override
  $CommentPhotoSizeCopyWith<$Res>? get normal;
}

/// @nodoc
class __$$CommentPhotoImageImplCopyWithImpl<$Res>
    extends _$CommentPhotoImageCopyWithImpl<$Res, _$CommentPhotoImageImpl>
    implements _$$CommentPhotoImageImplCopyWith<$Res> {
  __$$CommentPhotoImageImplCopyWithImpl(
    _$CommentPhotoImageImpl _value,
    $Res Function(_$CommentPhotoImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? isAnimated = null,
  }) {
    return _then(
      _$CommentPhotoImageImpl(
        large: freezed == large
            ? _value.large
            : large // ignore: cast_nullable_to_non_nullable
                  as CommentPhotoSize?,
        normal: freezed == normal
            ? _value.normal
            : normal // ignore: cast_nullable_to_non_nullable
                  as CommentPhotoSize?,
        isAnimated: null == isAnimated
            ? _value.isAnimated
            : isAnimated // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentPhotoImageImpl implements _CommentPhotoImage {
  const _$CommentPhotoImageImpl({
    this.large,
    this.normal,
    @JsonKey(name: 'is_animated') this.isAnimated = false,
  });

  factory _$CommentPhotoImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentPhotoImageImplFromJson(json);

  @override
  final CommentPhotoSize? large;
  @override
  final CommentPhotoSize? normal;
  @override
  @JsonKey(name: 'is_animated')
  final bool isAnimated;

  @override
  String toString() {
    return 'CommentPhotoImage(large: $large, normal: $normal, isAnimated: $isAnimated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentPhotoImageImpl &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.isAnimated, isAnimated) ||
                other.isAnimated == isAnimated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, large, normal, isAnimated);

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentPhotoImageImplCopyWith<_$CommentPhotoImageImpl> get copyWith =>
      __$$CommentPhotoImageImplCopyWithImpl<_$CommentPhotoImageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentPhotoImageImplToJson(this);
  }
}

abstract class _CommentPhotoImage implements CommentPhotoImage {
  const factory _CommentPhotoImage({
    final CommentPhotoSize? large,
    final CommentPhotoSize? normal,
    @JsonKey(name: 'is_animated') final bool isAnimated,
  }) = _$CommentPhotoImageImpl;

  factory _CommentPhotoImage.fromJson(Map<String, dynamic> json) =
      _$CommentPhotoImageImpl.fromJson;

  @override
  CommentPhotoSize? get large;
  @override
  CommentPhotoSize? get normal;
  @override
  @JsonKey(name: 'is_animated')
  bool get isAnimated;

  /// Create a copy of CommentPhotoImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentPhotoImageImplCopyWith<_$CommentPhotoImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentPhotoSize _$CommentPhotoSizeFromJson(Map<String, dynamic> json) {
  return _CommentPhotoSize.fromJson(json);
}

/// @nodoc
mixin _$CommentPhotoSize {
  String? get url => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;

  /// Serializes this CommentPhotoSize to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentPhotoSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentPhotoSizeCopyWith<CommentPhotoSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentPhotoSizeCopyWith<$Res> {
  factory $CommentPhotoSizeCopyWith(
    CommentPhotoSize value,
    $Res Function(CommentPhotoSize) then,
  ) = _$CommentPhotoSizeCopyWithImpl<$Res, CommentPhotoSize>;
  @useResult
  $Res call({String? url, int? width, int? height});
}

/// @nodoc
class _$CommentPhotoSizeCopyWithImpl<$Res, $Val extends CommentPhotoSize>
    implements $CommentPhotoSizeCopyWith<$Res> {
  _$CommentPhotoSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentPhotoSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommentPhotoSizeImplCopyWith<$Res>
    implements $CommentPhotoSizeCopyWith<$Res> {
  factory _$$CommentPhotoSizeImplCopyWith(
    _$CommentPhotoSizeImpl value,
    $Res Function(_$CommentPhotoSizeImpl) then,
  ) = __$$CommentPhotoSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, int? width, int? height});
}

/// @nodoc
class __$$CommentPhotoSizeImplCopyWithImpl<$Res>
    extends _$CommentPhotoSizeCopyWithImpl<$Res, _$CommentPhotoSizeImpl>
    implements _$$CommentPhotoSizeImplCopyWith<$Res> {
  __$$CommentPhotoSizeImplCopyWithImpl(
    _$CommentPhotoSizeImpl _value,
    $Res Function(_$CommentPhotoSizeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentPhotoSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(
      _$CommentPhotoSizeImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentPhotoSizeImpl implements _CommentPhotoSize {
  const _$CommentPhotoSizeImpl({this.url, this.width, this.height});

  factory _$CommentPhotoSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentPhotoSizeImplFromJson(json);

  @override
  final String? url;
  @override
  final int? width;
  @override
  final int? height;

  @override
  String toString() {
    return 'CommentPhotoSize(url: $url, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentPhotoSizeImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, width, height);

  /// Create a copy of CommentPhotoSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentPhotoSizeImplCopyWith<_$CommentPhotoSizeImpl> get copyWith =>
      __$$CommentPhotoSizeImplCopyWithImpl<_$CommentPhotoSizeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentPhotoSizeImplToJson(this);
  }
}

abstract class _CommentPhotoSize implements CommentPhotoSize {
  const factory _CommentPhotoSize({
    final String? url,
    final int? width,
    final int? height,
  }) = _$CommentPhotoSizeImpl;

  factory _CommentPhotoSize.fromJson(Map<String, dynamic> json) =
      _$CommentPhotoSizeImpl.fromJson;

  @override
  String? get url;
  @override
  int? get width;
  @override
  int? get height;

  /// Create a copy of CommentPhotoSize
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentPhotoSizeImplCopyWith<_$CommentPhotoSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
