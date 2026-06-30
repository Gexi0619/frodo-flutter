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
    // 部分接口（如 recommend_feed 的 owner）把这些字段返成 0/1 整数而非布尔，
    // 用 [_boolFromJson] 容错，否则 `int as bool?` 会抛类型错误。
    @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson) bool? isSubscribed,
    /// 该小组是否开放「关注」（关注 = 订阅更新但不成为成员）。false / null 时
    /// 隐藏关注入口。
    @JsonKey(name: 'enable_subscribe', fromJson: _boolFromJson)
    bool? enableSubscribe,
    @JsonKey(name: 'is_official', fromJson: _boolFromJson) bool? isOfficial,
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
    /// 当前用户在该组的未读/新帖数，已是格式化文本（如 "48"、"999+"）。
    /// 仅「我的小组」类接口返回；"0" 表示无新帖。
    @JsonKey(name: 'unread_count_str') String? unreadCountStr,
    /// 用户是否把该小组「钉住/置顶」。仅「我的小组」类接口返回。
    @JsonKey(name: 'is_sticky', fromJson: _boolFromJson) bool? isSticky,
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

/// 容错解析布尔字段：接受 bool、0/1 整数、"0"/"1"/"true"/"false" 字符串。
bool? _boolFromJson(Object? v) {
  if (v == null || v is bool) return v as bool?;
  if (v is num) return v != 0;
  if (v is String) return v == '1' || v.toLowerCase() == 'true';
  return null;
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
