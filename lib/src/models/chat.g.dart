// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
  conversationId: json['conversation_id'] as String,
  conversationType: json['conversation_type'] as String?,
  targetUser: json['target_user'] == null
      ? null
      : Author.fromJson(json['target_user'] as Map<String, dynamic>),
  lastMessage: json['last_message'] == null
      ? null
      : ChatMessage.fromJson(json['last_message'] as Map<String, dynamic>),
  unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
  canInteract: json['can_interact'] as bool? ?? true,
  imageDisabled: json['image_disabled'] as bool? ?? false,
  emptyMessage: json['empty_message'] as String?,
  pinned: json['pinned'] as bool? ?? false,
  type: json['type'] as String?,
  uri: json['uri'] as String?,
);

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'conversation_type': instance.conversationType,
      'target_user': instance.targetUser,
      'last_message': instance.lastMessage,
      'unread_count': instance.unreadCount,
      'can_interact': instance.canInteract,
      'image_disabled': instance.imageDisabled,
      'empty_message': instance.emptyMessage,
      'pinned': instance.pinned,
      'type': instance.type,
      'uri': instance.uri,
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String?,
      text: json['text'] as String?,
      createTime: json['create_time'] as String?,
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      conversationId: json['conversation_id'] as String?,
      nonce: (json['nonce'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      targetUri: json['target_uri'] as String?,
      card: json['card'] == null
          ? null
          : ChatCard.fromJson(json['card'] as Map<String, dynamic>),
      sysLink: json['sys_link'] == null
          ? null
          : ChatSysLink.fromJson(json['sys_link'] as Map<String, dynamic>),
      sizedImage: json['sized_image'] == null
          ? null
          : ChatImage.fromJson(json['sized_image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'create_time': instance.createTime,
      'author': instance.author,
      'conversation_id': instance.conversationId,
      'nonce': instance.nonce,
      'type': instance.type,
      'target_uri': instance.targetUri,
      'card': instance.card,
      'sys_link': instance.sysLink,
      'sized_image': instance.sizedImage,
    };

_$ChatCardImpl _$$ChatCardImplFromJson(Map<String, dynamic> json) =>
    _$ChatCardImpl(
      title: json['title'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$$ChatCardImplToJson(_$ChatCardImpl instance) =>
    <String, dynamic>{'title': instance.title, 'desc': instance.desc};

_$ChatSysLinkImpl _$$ChatSysLinkImplFromJson(Map<String, dynamic> json) =>
    _$ChatSysLinkImpl(
      text: json['text'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$$ChatSysLinkImplToJson(_$ChatSysLinkImpl instance) =>
    <String, dynamic>{'text': instance.text, 'uri': instance.uri};

_$ChatImageImpl _$$ChatImageImplFromJson(Map<String, dynamic> json) =>
    _$ChatImageImpl(
      large: json['large'] == null
          ? null
          : ChatImageSize.fromJson(json['large'] as Map<String, dynamic>),
      normal: json['normal'] == null
          ? null
          : ChatImageSize.fromJson(json['normal'] as Map<String, dynamic>),
      isAnimated: json['is_animated'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatImageImplToJson(_$ChatImageImpl instance) =>
    <String, dynamic>{
      'large': instance.large,
      'normal': instance.normal,
      'is_animated': instance.isAnimated,
    };

_$ChatImageSizeImpl _$$ChatImageSizeImplFromJson(Map<String, dynamic> json) =>
    _$ChatImageSizeImpl(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ChatImageSizeImplToJson(_$ChatImageSizeImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
