import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/chat.dart';
import '../models/paged.dart';

class ChatRepository {
  ChatRepository(this._frodo);

  final Dio _frodo;

  /// 私信会话列表
  /// GET https://frodo.douban.com/api/v2/chat_list
  ///
  /// 列表字段是 `results`，并返回 start/count/total，用 total 判断是否到底。
  /// `mailbox` 默认 `default`（普通私信收件箱）。
  Future<Paged<Chat>> fetchChats({
    int start = 0,
    int count = 20,
    String mailbox = 'default',
  }) async {
    final data = await _frodo.getMap(
      '/api/v2/chat_list',
      query: {'start': start, 'count': count, 'mailbox': mailbox},
    );
    final items = asList(data['results'])
        .whereType<Map<String, dynamic>>()
        .map(Chat.fromJson)
        .toList(growable: false);
    return Paged<Chat>(
      items: items,
      total: (data['total'] as int?) ?? items.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? count,
    );
  }

  /// 聊天框信息（单个会话的元数据 + 权限位）
  /// GET https://frodo.douban.com/api/v2/user/{userId}/chat
  ///
  /// 用于只拿到对方 user id（如从用户主页进入私信）时，补齐会话头部信息。
  /// 响应结构与 chat_list 的一条会话基本一致，直接复用 [Chat] 解析。
  Future<Chat> fetchChatBox(String userId) async {
    return Chat.fromJson(await _frodo.getMap('/api/v2/user/$userId/chat'));
  }

  /// 聊天内容（消息流）
  /// GET https://frodo.douban.com/api/v2/im/messages
  ///
  /// 私信会话用 `type=private`、`cid`=对方 user id。`maxId` 为 0 时取最新一页，
  /// 翻历史时传当前已加载里最旧一条的 message id。返回的 `messages` 按时间
  /// 升序（旧→新）。
  Future<List<ChatMessage>> fetchMessages({
    required String cid,
    int maxId = 0,
    int count = 20,
    String type = 'private',
  }) async {
    final data = await _frodo.getMap(
      '/api/v2/im/messages',
      query: {
        'type': type,
        'cid': cid,
        'max_id': maxId,
        'count': count,
      },
    );
    return asList(data['messages'])
        .whereType<Map<String, dynamic>>()
        .map(ChatMessage.fromJson)
        .toList(growable: false);
  }

  /// 发送私信
  /// POST https://frodo.douban.com/api/v2/user/{cid}/chat/create_message
  ///
  /// `cid` 为对方 user id。`nonce` 是毫秒级去重令牌（不传则用当前时间），会随
  /// 响应原样回传，调用方据此把乐观消息与服务端消息对上。签名字段
  /// apikey/_sig/_ts 由 [AuthInterceptor] 自动塞进 multipart body。返回新建的消息。
  Future<ChatMessage> sendMessage({
    required String cid,
    required String text,
    int? nonce,
  }) async {
    final n = nonce ?? DateTime.now().millisecondsSinceEpoch;
    final data = await _frodo.postMap(
      '/api/v2/user/$cid/chat/create_message',
      data: FormData.fromMap({'text': text, 'nonce': '$n'}),
    );
    return ChatMessage.fromJson(data);
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(dioProvider));
});
