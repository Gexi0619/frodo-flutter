import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// 小组讨论评论。
@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'total_replies') int? totalReplies,
    @JsonKey(name: 'next_reply_start') int? nextReplyStart,
    @JsonKey(name: 'is_voted') bool? isVoted,
    @Default(<CommentPhoto>[]) List<CommentPhoto> photos,
    @Default(<Comment>[]) List<Comment> replies,
    Author? author,
    @JsonKey(name: 'ref_comment') Comment? refComment,
    @JsonKey(name: 'parent_comment_id') String? parentCommentId,
    @JsonKey(name: 'ip_location') String? ipLocation,
    @JsonKey(name: 'is_folded') @Default(false) bool isFolded,
    @JsonKey(name: 'folded_reason_text') String? foldedReasonText,
    @JsonKey(name: 'folded_message') String? foldedMessage,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

@freezed
class CommentPhoto with _$CommentPhoto {
  const factory CommentPhoto({
    String? id,
    @JsonKey(name: 'image') CommentPhotoImage? image,
  }) = _CommentPhoto;

  factory CommentPhoto.fromJson(Map<String, dynamic> json) =>
      _$CommentPhotoFromJson(json);
}

@freezed
class CommentPhotoImage with _$CommentPhotoImage {
  const factory CommentPhotoImage({
    CommentPhotoSize? large,
    CommentPhotoSize? normal,
    @JsonKey(name: 'is_animated') @Default(false) bool isAnimated,
  }) = _CommentPhotoImage;

  factory CommentPhotoImage.fromJson(Map<String, dynamic> json) =>
      _$CommentPhotoImageFromJson(json);
}

@freezed
class CommentPhotoSize with _$CommentPhotoSize {
  const factory CommentPhotoSize({
    String? url,
    int? width,
    int? height,
  }) = _CommentPhotoSize;

  factory CommentPhotoSize.fromJson(Map<String, dynamic> json) =>
      _$CommentPhotoSizeFromJson(json);
}

extension CommentPhotoX on CommentPhoto {
  String? get url => image?.large?.url ?? image?.normal?.url;
  bool get isAnimated => image?.isAnimated ?? false;
  double? get aspectRatio {
    final s = image?.large ?? image?.normal;
    final w = s?.width;
    final h = s?.height;
    return (w != null && h != null && h > 0) ? w / h : null;
  }
}
