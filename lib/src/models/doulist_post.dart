import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';
import 'topic.dart';

part 'doulist_post.freezed.dart';
part 'doulist_post.g.dart';

/// 豆列动态条目（来自 /api/v2/doulist/user/{user_id}/posts）。
@freezed
class DoulistPost with _$DoulistPost {
  const factory DoulistPost({
    required String id,
    @JsonKey(name: 'collection_time') String? collectionTime,
    /// 用户收录时填写的备注。
    @JsonKey(name: 'collection_reason') String? collectionReason,
    @JsonKey(name: 'comments_count') int? commentsCount,
    @JsonKey(name: 'reactions_count') int? reactionsCount,
    @JsonKey(name: 'reshares_count') int? resharesCount,
    DoulistPostContent? content,
    DoulistInfo? doulist,
    String? type,
  }) = _DoulistPost;

  factory DoulistPost.fromJson(Map<String, dynamic> json) =>
      _$DoulistPostFromJson(json);
}

/// 豆列基本信息（来自 post 顶层 `doulist` 字段）。
@freezed
class DoulistInfo with _$DoulistInfo {
  const factory DoulistInfo({
    required String id,
    required String title,
  }) = _DoulistInfo;

  factory DoulistInfo.fromJson(Map<String, dynamic> json) =>
      _$DoulistInfoFromJson(json);
}

/// 豆列动态里的帖子内容（对应外层 `content` 字段）。
@freezed
class DoulistPostContent with _$DoulistPostContent {
  const factory DoulistPostContent({
    required String id,
    required String title,
    String? abstract,
    Author? author,
    @Default(<TopicPhoto>[]) List<TopicPhoto> photos,
    String? uri,
    String? url,
  }) = _DoulistPostContent;

  factory DoulistPostContent.fromJson(Map<String, dynamic> json) =>
      _$DoulistPostContentFromJson(json);
}
