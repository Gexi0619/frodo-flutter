import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// 小组。openapi 中字段非常多，这里只保留 UI 需要的，其它忽略。
@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    String? avatar,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
    String? desc,
    @JsonKey(name: 'desc_abstract') String? descAbstract,
    String? subtitle,
    String? slogan,
    @JsonKey(name: 'member_count') int? memberCount,
    @JsonKey(name: 'member_count_text') String? memberCountText,
    @JsonKey(name: 'member_name') String? memberName,
    @JsonKey(name: 'topic_count') int? topicCount,
    @JsonKey(name: 'is_subscribed') bool? isSubscribed,
    @JsonKey(name: 'is_official') bool? isOfficial,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'background_mask_color') String? backgroundMaskColor,
    @JsonKey(name: 'rules_desc') String? rulesDesc,
    @JsonKey(name: 'group_tabs') List<GroupTab>? groupTabs,
    @JsonKey(name: 'feed_tags') List<FeedTag>? feedTags,
    Author? owner,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

/// 小组分栏（如"精华"、"组规"或运营 tag）。
/// 出现在 GET /api/v2/group/{group_id} 的 `group_tabs` 字段里，
/// 也作为 GET /api/v2/group/{group_id}/topics 的 `group_tabs` query 参数。
@freezed
class GroupTab with _$GroupTab {
  const factory GroupTab({
    required String id,
    required String name,
    String? type,
    String? uri,
    int? seq,
  }) = _GroupTab;

  factory GroupTab.fromJson(Map<String, dynamic> json) =>
      _$GroupTabFromJson(json);
}

/// 小组讨论流排序项（如 最新 / 热门 / 精华）。
/// 出现在 GET /api/v2/group/{group_id} 的 `feed_tags` 字段，
/// 也作为 GET /api/v2/group/{group_id}/topics 的 `sortby` query 参数。
@freezed
class FeedTag with _$FeedTag {
  const factory FeedTag({
    required String sortby,
    required String title,
  }) = _FeedTag;

  factory FeedTag.fromJson(Map<String, dynamic> json) =>
      _$FeedTagFromJson(json);
}
