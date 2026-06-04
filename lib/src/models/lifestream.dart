import 'topic.dart';

/// 用户动态(lifestream)里的一条。
///
/// 动态混排了小组讨论 / 广播 / 日记 / 影评等多种类型，这里统一成可复用
/// [TopicCard] 模板渲染的 [topic]，再额外带上路由所需的类型与链接。
class LifestreamItem {
  const LifestreamItem({
    required this.topic,
    this.type,
    this.typeCn,
    this.uri,
    this.url,
  });

  final Topic topic;

  /// 原始类型：topic / status / note / review …，决定点击行为。
  final String? type;

  /// 中文类型标签：小组讨论 / 广播 …，用作卡片头部。
  final String? typeCn;

  /// douban:// 深链。
  final String? uri;

  /// 网页链接。
  final String? url;
}
