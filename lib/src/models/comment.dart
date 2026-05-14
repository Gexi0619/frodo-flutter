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
    @JsonKey(name: 'replies_count') int? repliesCount,
    @JsonKey(name: 'is_liked') bool? isLiked,
    Author? author,
    @JsonKey(name: 'ref_comment') Comment? refComment,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
