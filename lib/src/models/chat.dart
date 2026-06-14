import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

/// 私信会话（`GET /api/v2/chat_list` 的 results 项，也复用于
/// `GET /api/v2/user/{user_id}/chat` 的「聊天框信息」响应）。
///
/// `targetUser` 是对话的另一方，`lastMessage` 是会话里最后一条消息（用于列表预览），
/// `unreadCount` > 0 时在列表右侧显示未读红点/数字。私信(private)会话的
/// `conversationId` 即对方的 user id，可直接作为拉消息接口的 `cid`。
@freezed
class Chat with _$Chat {
  const factory Chat({
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'conversation_type') String? conversationType,
    @JsonKey(name: 'target_user') Author? targetUser,
    @JsonKey(name: 'last_message') ChatMessage? lastMessage,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'can_interact') @Default(true) bool canInteract,
    @JsonKey(name: 'image_disabled') @Default(false) bool imageDisabled,
    @JsonKey(name: 'empty_message') String? emptyMessage,
    @Default(false) bool pinned,
    String? type,
    String? uri,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

/// 一条私信消息（`chat_list.last_message` 与 `im/messages.messages` 共用）。
///
/// 普通文本走 [text]；图片消息没有 [text]，内容在 [sizedImage]；卡片消息在
/// [card]；系统提示（如「对方仅接收……」）在 [sysLink]。`type` 为消息类型枚举
/// （0=普通文本）。
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    String? id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    Author? author,
    @JsonKey(name: 'conversation_id') String? conversationId,
    // 客户端去重令牌（毫秒时间戳）。发送时本地生成并随响应回传，用于把乐观
    // 插入的消息和服务端返回的真实消息对上。
    int? nonce,
    int? type,
    @JsonKey(name: 'target_uri') String? targetUri,
    ChatCard? card,
    @JsonKey(name: 'sys_link') ChatSysLink? sysLink,
    @JsonKey(name: 'sized_image') ChatImage? sizedImage,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

/// 私信里的卡片消息（分享的条目 / 帖子等），列表预览取 [title]。
@freezed
class ChatCard with _$ChatCard {
  const factory ChatCard({String? title, String? desc}) = _ChatCard;

  factory ChatCard.fromJson(Map<String, dynamic> json) =>
      _$ChatCardFromJson(json);
}

/// 系统提示消息里的内联链接。
@freezed
class ChatSysLink with _$ChatSysLink {
  const factory ChatSysLink({String? text, String? uri}) = _ChatSysLink;

  factory ChatSysLink.fromJson(Map<String, dynamic> json) =>
      _$ChatSysLinkFromJson(json);
}

/// 图片消息的多尺寸地址（结构同帖子/评论里的图片）。
@freezed
class ChatImage with _$ChatImage {
  const factory ChatImage({
    ChatImageSize? large,
    ChatImageSize? normal,
    @JsonKey(name: 'is_animated') @Default(false) bool isAnimated,
  }) = _ChatImage;

  factory ChatImage.fromJson(Map<String, dynamic> json) =>
      _$ChatImageFromJson(json);
}

@freezed
class ChatImageSize with _$ChatImageSize {
  const factory ChatImageSize({String? url, int? width, int? height}) =
      _ChatImageSize;

  factory ChatImageSize.fromJson(Map<String, dynamic> json) =>
      _$ChatImageSizeFromJson(json);
}

extension ChatX on Chat {
  /// 列表里展示的最后一条消息预览：纯文本优先，其次卡片标题，再退化为图片占位。
  String get preview {
    final msg = lastMessage;
    if (msg == null) return '';
    final text = msg.text;
    if (text != null && text.isNotEmpty) return text;
    final cardTitle = msg.card?.title;
    if (cardTitle != null && cardTitle.isNotEmpty) return cardTitle;
    if (msg.sizedImage != null) return '[图片]';
    return '';
  }
}

extension ChatMessageX on ChatMessage {
  String? get imageUrl => sizedImage?.large?.url ?? sizedImage?.normal?.url;

  /// 图片的宽高比，用于占位避免加载抖动；缺尺寸时返回 null。
  double? get imageAspectRatio {
    final s = sizedImage?.large ?? sizedImage?.normal;
    final w = s?.width;
    final h = s?.height;
    return (w != null && h != null && h > 0) ? w / h : null;
  }
}
