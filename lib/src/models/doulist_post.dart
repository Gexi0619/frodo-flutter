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
    /// 豆列条目自身的唯一 id（区别于 [id]=帖子/内容 id）；编辑收藏语接口的 item_id。
    String? uid,
    @JsonKey(name: 'collection_time') String? collectionTime,
    /// 帖子发表时间（外层 `created_time`，区别于收藏时间 [collectionTime]）。
    @JsonKey(name: 'created_time') String? createdTime,
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

extension DoulistPostX on DoulistPost {
  /// 把豆列条目映射成 [Topic]，复用动态卡片 [TopicCard] 渲染正文/图片/统计。
  /// 收藏时间、收藏备注属于豆列特有信息，由调用方通过 header/footer 插槽展示。
  Topic? toTopic() {
    final c = content;
    if (c == null) return null;
    return Topic(
      id: c.id,
      title: c.title,
      abstract: c.abstract,
      author: c.author,
      photos: c.photos,
      createTime: createdTime,
      commentsCount: commentsCount,
      reactionsCount: reactionsCount,
      resharesCount: resharesCount,
    );
  }
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
