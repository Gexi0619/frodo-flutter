import '../api/json_utils.dart';

/// 各类未读消息数（角标用）。
/// 来自 `GET /api/v2/notification_chart`，响应形如：
/// ```json
/// {
///   "notification": {"count": 1, "version": "..."},
///   "wish_sub_msg":  {"count": 0, "version": "..."},
///   "chat":          {"count": 0, "version": ""},
///   "podcast_subscription": {"count": 0, "version": "..."}
/// }
/// ```
/// 每个分组只取 `count`，`version` 暂不使用。
class NotificationChart {
  const NotificationChart({
    this.notification = 0,
    this.chat = 0,
    this.wishSubMsg = 0,
    this.podcastSubscription = 0,
  });

  /// 互动通知未读数（通知 tab）。
  final int notification;

  /// 私信未读数（私信 tab）。
  final int chat;

  /// 想看/订阅消息未读数。
  final int wishSubMsg;

  /// 播客订阅更新未读数。
  final int podcastSubscription;

  /// 「消息」入口角标总数（通知 + 私信）。
  int get messagesBadge => notification + chat;

  factory NotificationChart.fromJson(Map<String, dynamic> json) {
    int countOf(String key) => (asMap(json[key])['count'] as int?) ?? 0;
    return NotificationChart(
      notification: countOf('notification'),
      chat: countOf('chat'),
      wishSubMsg: countOf('wish_sub_msg'),
      podcastSubscription: countOf('podcast_subscription'),
    );
  }
}
