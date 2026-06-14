// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return _Chat.fromJson(json);
}

/// @nodoc
mixin _$Chat {
  @JsonKey(name: 'conversation_id')
  String get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_type')
  String? get conversationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_user')
  Author? get targetUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message')
  ChatMessage? get lastMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_interact')
  bool get canInteract => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_disabled')
  bool get imageDisabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'empty_message')
  String? get emptyMessage => throw _privateConstructorUsedError;
  bool get pinned => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;

  /// Serializes this Chat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatCopyWith<Chat> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatCopyWith<$Res> {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) then) =
      _$ChatCopyWithImpl<$Res, Chat>;
  @useResult
  $Res call({
    @JsonKey(name: 'conversation_id') String conversationId,
    @JsonKey(name: 'conversation_type') String? conversationType,
    @JsonKey(name: 'target_user') Author? targetUser,
    @JsonKey(name: 'last_message') ChatMessage? lastMessage,
    @JsonKey(name: 'unread_count') int unreadCount,
    @JsonKey(name: 'can_interact') bool canInteract,
    @JsonKey(name: 'image_disabled') bool imageDisabled,
    @JsonKey(name: 'empty_message') String? emptyMessage,
    bool pinned,
    String? type,
    String? uri,
  });

  $AuthorCopyWith<$Res>? get targetUser;
  $ChatMessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$ChatCopyWithImpl<$Res, $Val extends Chat>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? conversationType = freezed,
    Object? targetUser = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? canInteract = null,
    Object? imageDisabled = null,
    Object? emptyMessage = freezed,
    Object? pinned = null,
    Object? type = freezed,
    Object? uri = freezed,
  }) {
    return _then(
      _value.copyWith(
            conversationId: null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationType: freezed == conversationType
                ? _value.conversationType
                : conversationType // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetUser: freezed == targetUser
                ? _value.targetUser
                : targetUser // ignore: cast_nullable_to_non_nullable
                      as Author?,
            lastMessage: freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as ChatMessage?,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            canInteract: null == canInteract
                ? _value.canInteract
                : canInteract // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageDisabled: null == imageDisabled
                ? _value.imageDisabled
                : imageDisabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            emptyMessage: freezed == emptyMessage
                ? _value.emptyMessage
                : emptyMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            pinned: null == pinned
                ? _value.pinned
                : pinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorCopyWith<$Res>? get targetUser {
    if (_value.targetUser == null) {
      return null;
    }

    return $AuthorCopyWith<$Res>(_value.targetUser!, (value) {
      return _then(_value.copyWith(targetUser: value) as $Val);
    });
  }

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $ChatMessageCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatImplCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$$ChatImplCopyWith(
    _$ChatImpl value,
    $Res Function(_$ChatImpl) then,
  ) = __$$ChatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'conversation_id') String conversationId,
    @JsonKey(name: 'conversation_type') String? conversationType,
    @JsonKey(name: 'target_user') Author? targetUser,
    @JsonKey(name: 'last_message') ChatMessage? lastMessage,
    @JsonKey(name: 'unread_count') int unreadCount,
    @JsonKey(name: 'can_interact') bool canInteract,
    @JsonKey(name: 'image_disabled') bool imageDisabled,
    @JsonKey(name: 'empty_message') String? emptyMessage,
    bool pinned,
    String? type,
    String? uri,
  });

  @override
  $AuthorCopyWith<$Res>? get targetUser;
  @override
  $ChatMessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$ChatImplCopyWithImpl<$Res>
    extends _$ChatCopyWithImpl<$Res, _$ChatImpl>
    implements _$$ChatImplCopyWith<$Res> {
  __$$ChatImplCopyWithImpl(_$ChatImpl _value, $Res Function(_$ChatImpl) _then)
    : super(_value, _then);

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? conversationType = freezed,
    Object? targetUser = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? canInteract = null,
    Object? imageDisabled = null,
    Object? emptyMessage = freezed,
    Object? pinned = null,
    Object? type = freezed,
    Object? uri = freezed,
  }) {
    return _then(
      _$ChatImpl(
        conversationId: null == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationType: freezed == conversationType
            ? _value.conversationType
            : conversationType // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetUser: freezed == targetUser
            ? _value.targetUser
            : targetUser // ignore: cast_nullable_to_non_nullable
                  as Author?,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as ChatMessage?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        canInteract: null == canInteract
            ? _value.canInteract
            : canInteract // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageDisabled: null == imageDisabled
            ? _value.imageDisabled
            : imageDisabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        emptyMessage: freezed == emptyMessage
            ? _value.emptyMessage
            : emptyMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinned: null == pinned
            ? _value.pinned
            : pinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatImpl implements _Chat {
  const _$ChatImpl({
    @JsonKey(name: 'conversation_id') required this.conversationId,
    @JsonKey(name: 'conversation_type') this.conversationType,
    @JsonKey(name: 'target_user') this.targetUser,
    @JsonKey(name: 'last_message') this.lastMessage,
    @JsonKey(name: 'unread_count') this.unreadCount = 0,
    @JsonKey(name: 'can_interact') this.canInteract = true,
    @JsonKey(name: 'image_disabled') this.imageDisabled = false,
    @JsonKey(name: 'empty_message') this.emptyMessage,
    this.pinned = false,
    this.type,
    this.uri,
  });

  factory _$ChatImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatImplFromJson(json);

  @override
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @override
  @JsonKey(name: 'conversation_type')
  final String? conversationType;
  @override
  @JsonKey(name: 'target_user')
  final Author? targetUser;
  @override
  @JsonKey(name: 'last_message')
  final ChatMessage? lastMessage;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  @JsonKey(name: 'can_interact')
  final bool canInteract;
  @override
  @JsonKey(name: 'image_disabled')
  final bool imageDisabled;
  @override
  @JsonKey(name: 'empty_message')
  final String? emptyMessage;
  @override
  @JsonKey()
  final bool pinned;
  @override
  final String? type;
  @override
  final String? uri;

  @override
  String toString() {
    return 'Chat(conversationId: $conversationId, conversationType: $conversationType, targetUser: $targetUser, lastMessage: $lastMessage, unreadCount: $unreadCount, canInteract: $canInteract, imageDisabled: $imageDisabled, emptyMessage: $emptyMessage, pinned: $pinned, type: $type, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.targetUser, targetUser) ||
                other.targetUser == targetUser) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.canInteract, canInteract) ||
                other.canInteract == canInteract) &&
            (identical(other.imageDisabled, imageDisabled) ||
                other.imageDisabled == imageDisabled) &&
            (identical(other.emptyMessage, emptyMessage) ||
                other.emptyMessage == emptyMessage) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    conversationId,
    conversationType,
    targetUser,
    lastMessage,
    unreadCount,
    canInteract,
    imageDisabled,
    emptyMessage,
    pinned,
    type,
    uri,
  );

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      __$$ChatImplCopyWithImpl<_$ChatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatImplToJson(this);
  }
}

abstract class _Chat implements Chat {
  const factory _Chat({
    @JsonKey(name: 'conversation_id') required final String conversationId,
    @JsonKey(name: 'conversation_type') final String? conversationType,
    @JsonKey(name: 'target_user') final Author? targetUser,
    @JsonKey(name: 'last_message') final ChatMessage? lastMessage,
    @JsonKey(name: 'unread_count') final int unreadCount,
    @JsonKey(name: 'can_interact') final bool canInteract,
    @JsonKey(name: 'image_disabled') final bool imageDisabled,
    @JsonKey(name: 'empty_message') final String? emptyMessage,
    final bool pinned,
    final String? type,
    final String? uri,
  }) = _$ChatImpl;

  factory _Chat.fromJson(Map<String, dynamic> json) = _$ChatImpl.fromJson;

  @override
  @JsonKey(name: 'conversation_id')
  String get conversationId;
  @override
  @JsonKey(name: 'conversation_type')
  String? get conversationType;
  @override
  @JsonKey(name: 'target_user')
  Author? get targetUser;
  @override
  @JsonKey(name: 'last_message')
  ChatMessage? get lastMessage;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'can_interact')
  bool get canInteract;
  @override
  @JsonKey(name: 'image_disabled')
  bool get imageDisabled;
  @override
  @JsonKey(name: 'empty_message')
  String? get emptyMessage;
  @override
  bool get pinned;
  @override
  String? get type;
  @override
  String? get uri;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String? get id => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_time')
  String? get createTime => throw _privateConstructorUsedError;
  Author? get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  String? get conversationId => throw _privateConstructorUsedError; // 客户端去重令牌（毫秒时间戳）。发送时本地生成并随响应回传，用于把乐观
  // 插入的消息和服务端返回的真实消息对上。
  int? get nonce => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_uri')
  String? get targetUri => throw _privateConstructorUsedError;
  ChatCard? get card => throw _privateConstructorUsedError;
  @JsonKey(name: 'sys_link')
  ChatSysLink? get sysLink => throw _privateConstructorUsedError;
  @JsonKey(name: 'sized_image')
  ChatImage? get sizedImage => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    String? id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    Author? author,
    @JsonKey(name: 'conversation_id') String? conversationId,
    int? nonce,
    int? type,
    @JsonKey(name: 'target_uri') String? targetUri,
    ChatCard? card,
    @JsonKey(name: 'sys_link') ChatSysLink? sysLink,
    @JsonKey(name: 'sized_image') ChatImage? sizedImage,
  });

  $AuthorCopyWith<$Res>? get author;
  $ChatCardCopyWith<$Res>? get card;
  $ChatSysLinkCopyWith<$Res>? get sysLink;
  $ChatImageCopyWith<$Res>? get sizedImage;
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? createTime = freezed,
    Object? author = freezed,
    Object? conversationId = freezed,
    Object? nonce = freezed,
    Object? type = freezed,
    Object? targetUri = freezed,
    Object? card = freezed,
    Object? sysLink = freezed,
    Object? sizedImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            createTime: freezed == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as Author?,
            conversationId: freezed == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            nonce: freezed == nonce
                ? _value.nonce
                : nonce // ignore: cast_nullable_to_non_nullable
                      as int?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetUri: freezed == targetUri
                ? _value.targetUri
                : targetUri // ignore: cast_nullable_to_non_nullable
                      as String?,
            card: freezed == card
                ? _value.card
                : card // ignore: cast_nullable_to_non_nullable
                      as ChatCard?,
            sysLink: freezed == sysLink
                ? _value.sysLink
                : sysLink // ignore: cast_nullable_to_non_nullable
                      as ChatSysLink?,
            sizedImage: freezed == sizedImage
                ? _value.sizedImage
                : sizedImage // ignore: cast_nullable_to_non_nullable
                      as ChatImage?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $AuthorCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatCardCopyWith<$Res>? get card {
    if (_value.card == null) {
      return null;
    }

    return $ChatCardCopyWith<$Res>(_value.card!, (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatSysLinkCopyWith<$Res>? get sysLink {
    if (_value.sysLink == null) {
      return null;
    }

    return $ChatSysLinkCopyWith<$Res>(_value.sysLink!, (value) {
      return _then(_value.copyWith(sysLink: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatImageCopyWith<$Res>? get sizedImage {
    if (_value.sizedImage == null) {
      return null;
    }

    return $ChatImageCopyWith<$Res>(_value.sizedImage!, (value) {
      return _then(_value.copyWith(sizedImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    Author? author,
    @JsonKey(name: 'conversation_id') String? conversationId,
    int? nonce,
    int? type,
    @JsonKey(name: 'target_uri') String? targetUri,
    ChatCard? card,
    @JsonKey(name: 'sys_link') ChatSysLink? sysLink,
    @JsonKey(name: 'sized_image') ChatImage? sizedImage,
  });

  @override
  $AuthorCopyWith<$Res>? get author;
  @override
  $ChatCardCopyWith<$Res>? get card;
  @override
  $ChatSysLinkCopyWith<$Res>? get sysLink;
  @override
  $ChatImageCopyWith<$Res>? get sizedImage;
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
    Object? createTime = freezed,
    Object? author = freezed,
    Object? conversationId = freezed,
    Object? nonce = freezed,
    Object? type = freezed,
    Object? targetUri = freezed,
    Object? card = freezed,
    Object? sysLink = freezed,
    Object? sizedImage = freezed,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        createTime: freezed == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as Author?,
        conversationId: freezed == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        nonce: freezed == nonce
            ? _value.nonce
            : nonce // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetUri: freezed == targetUri
            ? _value.targetUri
            : targetUri // ignore: cast_nullable_to_non_nullable
                  as String?,
        card: freezed == card
            ? _value.card
            : card // ignore: cast_nullable_to_non_nullable
                  as ChatCard?,
        sysLink: freezed == sysLink
            ? _value.sysLink
            : sysLink // ignore: cast_nullable_to_non_nullable
                  as ChatSysLink?,
        sizedImage: freezed == sizedImage
            ? _value.sizedImage
            : sizedImage // ignore: cast_nullable_to_non_nullable
                  as ChatImage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({
    this.id,
    this.text,
    @JsonKey(name: 'create_time') this.createTime,
    this.author,
    @JsonKey(name: 'conversation_id') this.conversationId,
    this.nonce,
    this.type,
    @JsonKey(name: 'target_uri') this.targetUri,
    this.card,
    @JsonKey(name: 'sys_link') this.sysLink,
    @JsonKey(name: 'sized_image') this.sizedImage,
  });

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String? id;
  @override
  final String? text;
  @override
  @JsonKey(name: 'create_time')
  final String? createTime;
  @override
  final Author? author;
  @override
  @JsonKey(name: 'conversation_id')
  final String? conversationId;
  // 客户端去重令牌（毫秒时间戳）。发送时本地生成并随响应回传，用于把乐观
  // 插入的消息和服务端返回的真实消息对上。
  @override
  final int? nonce;
  @override
  final int? type;
  @override
  @JsonKey(name: 'target_uri')
  final String? targetUri;
  @override
  final ChatCard? card;
  @override
  @JsonKey(name: 'sys_link')
  final ChatSysLink? sysLink;
  @override
  @JsonKey(name: 'sized_image')
  final ChatImage? sizedImage;

  @override
  String toString() {
    return 'ChatMessage(id: $id, text: $text, createTime: $createTime, author: $author, conversationId: $conversationId, nonce: $nonce, type: $type, targetUri: $targetUri, card: $card, sysLink: $sysLink, sizedImage: $sizedImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.targetUri, targetUri) ||
                other.targetUri == targetUri) &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.sysLink, sysLink) || other.sysLink == sysLink) &&
            (identical(other.sizedImage, sizedImage) ||
                other.sizedImage == sizedImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    text,
    createTime,
    author,
    conversationId,
    nonce,
    type,
    targetUri,
    card,
    sysLink,
    sizedImage,
  );

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({
    final String? id,
    final String? text,
    @JsonKey(name: 'create_time') final String? createTime,
    final Author? author,
    @JsonKey(name: 'conversation_id') final String? conversationId,
    final int? nonce,
    final int? type,
    @JsonKey(name: 'target_uri') final String? targetUri,
    final ChatCard? card,
    @JsonKey(name: 'sys_link') final ChatSysLink? sysLink,
    @JsonKey(name: 'sized_image') final ChatImage? sizedImage,
  }) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String? get id;
  @override
  String? get text;
  @override
  @JsonKey(name: 'create_time')
  String? get createTime;
  @override
  Author? get author;
  @override
  @JsonKey(name: 'conversation_id')
  String? get conversationId; // 客户端去重令牌（毫秒时间戳）。发送时本地生成并随响应回传，用于把乐观
  // 插入的消息和服务端返回的真实消息对上。
  @override
  int? get nonce;
  @override
  int? get type;
  @override
  @JsonKey(name: 'target_uri')
  String? get targetUri;
  @override
  ChatCard? get card;
  @override
  @JsonKey(name: 'sys_link')
  ChatSysLink? get sysLink;
  @override
  @JsonKey(name: 'sized_image')
  ChatImage? get sizedImage;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatCard _$ChatCardFromJson(Map<String, dynamic> json) {
  return _ChatCard.fromJson(json);
}

/// @nodoc
mixin _$ChatCard {
  String? get title => throw _privateConstructorUsedError;
  String? get desc => throw _privateConstructorUsedError;

  /// Serializes this ChatCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatCardCopyWith<ChatCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatCardCopyWith<$Res> {
  factory $ChatCardCopyWith(ChatCard value, $Res Function(ChatCard) then) =
      _$ChatCardCopyWithImpl<$Res, ChatCard>;
  @useResult
  $Res call({String? title, String? desc});
}

/// @nodoc
class _$ChatCardCopyWithImpl<$Res, $Val extends ChatCard>
    implements $ChatCardCopyWith<$Res> {
  _$ChatCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = freezed, Object? desc = freezed}) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            desc: freezed == desc
                ? _value.desc
                : desc // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatCardImplCopyWith<$Res>
    implements $ChatCardCopyWith<$Res> {
  factory _$$ChatCardImplCopyWith(
    _$ChatCardImpl value,
    $Res Function(_$ChatCardImpl) then,
  ) = __$$ChatCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title, String? desc});
}

/// @nodoc
class __$$ChatCardImplCopyWithImpl<$Res>
    extends _$ChatCardCopyWithImpl<$Res, _$ChatCardImpl>
    implements _$$ChatCardImplCopyWith<$Res> {
  __$$ChatCardImplCopyWithImpl(
    _$ChatCardImpl _value,
    $Res Function(_$ChatCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = freezed, Object? desc = freezed}) {
    return _then(
      _$ChatCardImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        desc: freezed == desc
            ? _value.desc
            : desc // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatCardImpl implements _ChatCard {
  const _$ChatCardImpl({this.title, this.desc});

  factory _$ChatCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatCardImplFromJson(json);

  @override
  final String? title;
  @override
  final String? desc;

  @override
  String toString() {
    return 'ChatCard(title: $title, desc: $desc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatCardImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.desc, desc) || other.desc == desc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, desc);

  /// Create a copy of ChatCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatCardImplCopyWith<_$ChatCardImpl> get copyWith =>
      __$$ChatCardImplCopyWithImpl<_$ChatCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatCardImplToJson(this);
  }
}

abstract class _ChatCard implements ChatCard {
  const factory _ChatCard({final String? title, final String? desc}) =
      _$ChatCardImpl;

  factory _ChatCard.fromJson(Map<String, dynamic> json) =
      _$ChatCardImpl.fromJson;

  @override
  String? get title;
  @override
  String? get desc;

  /// Create a copy of ChatCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatCardImplCopyWith<_$ChatCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatSysLink _$ChatSysLinkFromJson(Map<String, dynamic> json) {
  return _ChatSysLink.fromJson(json);
}

/// @nodoc
mixin _$ChatSysLink {
  String? get text => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;

  /// Serializes this ChatSysLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatSysLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatSysLinkCopyWith<ChatSysLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSysLinkCopyWith<$Res> {
  factory $ChatSysLinkCopyWith(
    ChatSysLink value,
    $Res Function(ChatSysLink) then,
  ) = _$ChatSysLinkCopyWithImpl<$Res, ChatSysLink>;
  @useResult
  $Res call({String? text, String? uri});
}

/// @nodoc
class _$ChatSysLinkCopyWithImpl<$Res, $Val extends ChatSysLink>
    implements $ChatSysLinkCopyWith<$Res> {
  _$ChatSysLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatSysLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = freezed, Object? uri = freezed}) {
    return _then(
      _value.copyWith(
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatSysLinkImplCopyWith<$Res>
    implements $ChatSysLinkCopyWith<$Res> {
  factory _$$ChatSysLinkImplCopyWith(
    _$ChatSysLinkImpl value,
    $Res Function(_$ChatSysLinkImpl) then,
  ) = __$$ChatSysLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? text, String? uri});
}

/// @nodoc
class __$$ChatSysLinkImplCopyWithImpl<$Res>
    extends _$ChatSysLinkCopyWithImpl<$Res, _$ChatSysLinkImpl>
    implements _$$ChatSysLinkImplCopyWith<$Res> {
  __$$ChatSysLinkImplCopyWithImpl(
    _$ChatSysLinkImpl _value,
    $Res Function(_$ChatSysLinkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatSysLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = freezed, Object? uri = freezed}) {
    return _then(
      _$ChatSysLinkImpl(
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatSysLinkImpl implements _ChatSysLink {
  const _$ChatSysLinkImpl({this.text, this.uri});

  factory _$ChatSysLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSysLinkImplFromJson(json);

  @override
  final String? text;
  @override
  final String? uri;

  @override
  String toString() {
    return 'ChatSysLink(text: $text, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSysLinkImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, uri);

  /// Create a copy of ChatSysLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSysLinkImplCopyWith<_$ChatSysLinkImpl> get copyWith =>
      __$$ChatSysLinkImplCopyWithImpl<_$ChatSysLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSysLinkImplToJson(this);
  }
}

abstract class _ChatSysLink implements ChatSysLink {
  const factory _ChatSysLink({final String? text, final String? uri}) =
      _$ChatSysLinkImpl;

  factory _ChatSysLink.fromJson(Map<String, dynamic> json) =
      _$ChatSysLinkImpl.fromJson;

  @override
  String? get text;
  @override
  String? get uri;

  /// Create a copy of ChatSysLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatSysLinkImplCopyWith<_$ChatSysLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatImage _$ChatImageFromJson(Map<String, dynamic> json) {
  return _ChatImage.fromJson(json);
}

/// @nodoc
mixin _$ChatImage {
  ChatImageSize? get large => throw _privateConstructorUsedError;
  ChatImageSize? get normal => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_animated')
  bool get isAnimated => throw _privateConstructorUsedError;

  /// Serializes this ChatImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatImageCopyWith<ChatImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatImageCopyWith<$Res> {
  factory $ChatImageCopyWith(ChatImage value, $Res Function(ChatImage) then) =
      _$ChatImageCopyWithImpl<$Res, ChatImage>;
  @useResult
  $Res call({
    ChatImageSize? large,
    ChatImageSize? normal,
    @JsonKey(name: 'is_animated') bool isAnimated,
  });

  $ChatImageSizeCopyWith<$Res>? get large;
  $ChatImageSizeCopyWith<$Res>? get normal;
}

/// @nodoc
class _$ChatImageCopyWithImpl<$Res, $Val extends ChatImage>
    implements $ChatImageCopyWith<$Res> {
  _$ChatImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? isAnimated = null,
  }) {
    return _then(
      _value.copyWith(
            large: freezed == large
                ? _value.large
                : large // ignore: cast_nullable_to_non_nullable
                      as ChatImageSize?,
            normal: freezed == normal
                ? _value.normal
                : normal // ignore: cast_nullable_to_non_nullable
                      as ChatImageSize?,
            isAnimated: null == isAnimated
                ? _value.isAnimated
                : isAnimated // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatImageSizeCopyWith<$Res>? get large {
    if (_value.large == null) {
      return null;
    }

    return $ChatImageSizeCopyWith<$Res>(_value.large!, (value) {
      return _then(_value.copyWith(large: value) as $Val);
    });
  }

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatImageSizeCopyWith<$Res>? get normal {
    if (_value.normal == null) {
      return null;
    }

    return $ChatImageSizeCopyWith<$Res>(_value.normal!, (value) {
      return _then(_value.copyWith(normal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatImageImplCopyWith<$Res>
    implements $ChatImageCopyWith<$Res> {
  factory _$$ChatImageImplCopyWith(
    _$ChatImageImpl value,
    $Res Function(_$ChatImageImpl) then,
  ) = __$$ChatImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ChatImageSize? large,
    ChatImageSize? normal,
    @JsonKey(name: 'is_animated') bool isAnimated,
  });

  @override
  $ChatImageSizeCopyWith<$Res>? get large;
  @override
  $ChatImageSizeCopyWith<$Res>? get normal;
}

/// @nodoc
class __$$ChatImageImplCopyWithImpl<$Res>
    extends _$ChatImageCopyWithImpl<$Res, _$ChatImageImpl>
    implements _$$ChatImageImplCopyWith<$Res> {
  __$$ChatImageImplCopyWithImpl(
    _$ChatImageImpl _value,
    $Res Function(_$ChatImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? large = freezed,
    Object? normal = freezed,
    Object? isAnimated = null,
  }) {
    return _then(
      _$ChatImageImpl(
        large: freezed == large
            ? _value.large
            : large // ignore: cast_nullable_to_non_nullable
                  as ChatImageSize?,
        normal: freezed == normal
            ? _value.normal
            : normal // ignore: cast_nullable_to_non_nullable
                  as ChatImageSize?,
        isAnimated: null == isAnimated
            ? _value.isAnimated
            : isAnimated // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatImageImpl implements _ChatImage {
  const _$ChatImageImpl({
    this.large,
    this.normal,
    @JsonKey(name: 'is_animated') this.isAnimated = false,
  });

  factory _$ChatImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatImageImplFromJson(json);

  @override
  final ChatImageSize? large;
  @override
  final ChatImageSize? normal;
  @override
  @JsonKey(name: 'is_animated')
  final bool isAnimated;

  @override
  String toString() {
    return 'ChatImage(large: $large, normal: $normal, isAnimated: $isAnimated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatImageImpl &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.isAnimated, isAnimated) ||
                other.isAnimated == isAnimated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, large, normal, isAnimated);

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatImageImplCopyWith<_$ChatImageImpl> get copyWith =>
      __$$ChatImageImplCopyWithImpl<_$ChatImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatImageImplToJson(this);
  }
}

abstract class _ChatImage implements ChatImage {
  const factory _ChatImage({
    final ChatImageSize? large,
    final ChatImageSize? normal,
    @JsonKey(name: 'is_animated') final bool isAnimated,
  }) = _$ChatImageImpl;

  factory _ChatImage.fromJson(Map<String, dynamic> json) =
      _$ChatImageImpl.fromJson;

  @override
  ChatImageSize? get large;
  @override
  ChatImageSize? get normal;
  @override
  @JsonKey(name: 'is_animated')
  bool get isAnimated;

  /// Create a copy of ChatImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatImageImplCopyWith<_$ChatImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatImageSize _$ChatImageSizeFromJson(Map<String, dynamic> json) {
  return _ChatImageSize.fromJson(json);
}

/// @nodoc
mixin _$ChatImageSize {
  String? get url => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;

  /// Serializes this ChatImageSize to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatImageSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatImageSizeCopyWith<ChatImageSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatImageSizeCopyWith<$Res> {
  factory $ChatImageSizeCopyWith(
    ChatImageSize value,
    $Res Function(ChatImageSize) then,
  ) = _$ChatImageSizeCopyWithImpl<$Res, ChatImageSize>;
  @useResult
  $Res call({String? url, int? width, int? height});
}

/// @nodoc
class _$ChatImageSizeCopyWithImpl<$Res, $Val extends ChatImageSize>
    implements $ChatImageSizeCopyWith<$Res> {
  _$ChatImageSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatImageSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(
      _value.copyWith(
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatImageSizeImplCopyWith<$Res>
    implements $ChatImageSizeCopyWith<$Res> {
  factory _$$ChatImageSizeImplCopyWith(
    _$ChatImageSizeImpl value,
    $Res Function(_$ChatImageSizeImpl) then,
  ) = __$$ChatImageSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, int? width, int? height});
}

/// @nodoc
class __$$ChatImageSizeImplCopyWithImpl<$Res>
    extends _$ChatImageSizeCopyWithImpl<$Res, _$ChatImageSizeImpl>
    implements _$$ChatImageSizeImplCopyWith<$Res> {
  __$$ChatImageSizeImplCopyWithImpl(
    _$ChatImageSizeImpl _value,
    $Res Function(_$ChatImageSizeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatImageSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(
      _$ChatImageSizeImpl(
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatImageSizeImpl implements _ChatImageSize {
  const _$ChatImageSizeImpl({this.url, this.width, this.height});

  factory _$ChatImageSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatImageSizeImplFromJson(json);

  @override
  final String? url;
  @override
  final int? width;
  @override
  final int? height;

  @override
  String toString() {
    return 'ChatImageSize(url: $url, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatImageSizeImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, width, height);

  /// Create a copy of ChatImageSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatImageSizeImplCopyWith<_$ChatImageSizeImpl> get copyWith =>
      __$$ChatImageSizeImplCopyWithImpl<_$ChatImageSizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatImageSizeImplToJson(this);
  }
}

abstract class _ChatImageSize implements ChatImageSize {
  const factory _ChatImageSize({
    final String? url,
    final int? width,
    final int? height,
  }) = _$ChatImageSizeImpl;

  factory _ChatImageSize.fromJson(Map<String, dynamic> json) =
      _$ChatImageSizeImpl.fromJson;

  @override
  String? get url;
  @override
  int? get width;
  @override
  int? get height;

  /// Create a copy of ChatImageSize
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatImageSizeImplCopyWith<_$ChatImageSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
