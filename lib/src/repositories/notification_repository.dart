import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/notification.dart';
import '../models/paged.dart';

class NotificationRepository {
  NotificationRepository(this._frodo);

  final Dio _frodo;

  /// 我的消息
  /// GET https://frodo.douban.com/api/v2/mine/notifications
  ///
  /// 列表字段是 `notifications`（非 `items`），且接口只回 start/count 而不给
  /// total / has_more——这里用「取满一整页就还有下一页」来推断是否到底。
  /// `type` 可选（如 `interaction`），不传则取全部消息。
  Future<Paged<NotificationItem>> fetchNotifications({
    int start = 0,
    int count = 20,
    String? type,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/mine/notifications',
      queryParameters: {
        'start': start,
        'count': count,
        if (type != null && type.isNotEmpty) 'type': type,
      },
    );
    final data = asMap(res.data);
    final items = asList(data['notifications'])
        .whereType<Map<String, dynamic>>()
        .map(NotificationItem.fromJson)
        .toList(growable: false);
    return Paged<NotificationItem>(
      items: items,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? count,
      hasMore: items.length >= count,
    );
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});
