import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// 小组。openapi 中字段非常多，这里只保留 UI 需要的，其它忽略。
@freezed
class Group with _$Group {
  const Group._();

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
    /// 小组本身的加入方式：'A'=自动通过；'R'=需要填写申请理由审核。
    /// 注意：这反映的是小组规则，**不是**当前用户是否已加入。
    @JsonKey(name: 'join_type') String? joinType,
    /// 当前用户在该小组的角色 / 加入状态。详见 [GroupJoinStatus]。
    /// 1000=未加入；1001=普通成员（含 1002+ 管理员）；1005=申请中。
    @JsonKey(name: 'member_role') int? memberRole,
    /// 未加入时展示的申请说明（管理员留言）。
    @JsonKey(name: 'joining_guide') GroupGuide? joiningGuide,
    /// 加入成功后展示的欢迎语。
    @JsonKey(name: 'joined_guide') GroupGuide? joinedGuide,
    Author? owner,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  /// 由 `member_role` 派生的当前用户加入状态。
  GroupJoinStatus get joinStatus {
    final r = memberRole;
    if (r == null) return GroupJoinStatus.unknown;
    if (r == 1005) return GroupJoinStatus.applying;
    if (r >= 1001) return GroupJoinStatus.joined;
    return GroupJoinStatus.notJoined; // 1000 及以下
  }
}

/// 当前用户与某小组的关系。由 `member_role` 派生。
enum GroupJoinStatus {
  /// 字段缺失，状态未知（兜底用，UI 应隐藏加入按钮）。
  unknown,
  /// 未加入。
  notJoined,
  /// 申请已提交，等待审核。
  applying,
  /// 已是成员（普通组员或管理员）。
  joined,
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

/// 小组详情里的"加入引导"块：申请前 / 加入后均复用同一结构。
@freezed
class GroupGuide with _$GroupGuide {
  const factory GroupGuide({
    String? text,
    List<String>? links,
  }) = _GroupGuide;

  factory GroupGuide.fromJson(Map<String, dynamic> json) =>
      _$GroupGuideFromJson(json);
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
