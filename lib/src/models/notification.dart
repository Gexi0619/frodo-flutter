import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// 「我的消息」里的一条通知（点赞 / 回复 / 关注等互动）。
///
/// `text` 是整条文案，`emphasizes` 标出其中需要加粗高亮的片段（通常是用户名）。
/// `label` 是分类小标签，`targetUri` 是点击后要跳转的站内/外链。
@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    String? category,
    String? text,
    String? label,
    @JsonKey(name: 'label_icon') String? labelIcon,
    @JsonKey(name: 'target_uri') String? targetUri,
    String? time,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @Default(false) bool discardable,
    @Default(<Emphasis>[]) List<Emphasis> emphasizes,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}

/// `text` 中需要加粗高亮的字符区间 `[start, end)`。
@freezed
class Emphasis with _$Emphasis {
  const factory Emphasis({
    @Default(0) int start,
    @Default(0) int end,
  }) = _Emphasis;

  factory Emphasis.fromJson(Map<String, dynamic> json) =>
      _$EmphasisFromJson(json);
}
