import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../models/collection.dart';
import '../models/comment.dart';
import '../models/group.dart';
import '../models/reaction.dart';
import '../models/reshare.dart';
import '../models/topic.dart';

List<dynamic> _asList(dynamic v) => v is List ? v : const [];

class TopicRepository {
  TopicRepository(this._frodo);

  final Dio _frodo;

  /// 讨论详情
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}
  Future<Topic> fetchTopic(String topicId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId',
    );
    final data = res.data ?? (throw StateError('empty response for topic $topicId'));
    return Topic.fromJson(data);
  }

  /// 讨论评论列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/comments
  Future<Paged<Comment>> fetchComments(
    String topicId, {
    int start = 0,
    int count = 30,
    String? orderBy,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/comments',
      queryParameters: {
        'start': start,
        'count': count,
        if (orderBy != null) 'order_by': orderBy,
      },
    );
    final data = res.data ?? const <String, dynamic>{};
    final itemsRaw = _asList(data['comments'] ?? data['items']);
    final items = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList(growable: false);
    return Paged<Comment>(
      items: items,
      total: (data['total'] as int?) ?? items.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? items.length,
    );
  }
  /// 讨论点赞列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/reactions
  Future<Paged<Reaction>> fetchReactions(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/reactions',
      queryParameters: {
        'start': start,
        'count': count,
        'reaction_type': 1,
      },
    );
    final data = res.data ?? const <String, dynamic>{};
    final itemsRaw = _asList(data['items']);
    final items = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map(Reaction.fromJson)
        .toList(growable: false);
    return Paged<Reaction>(
      items: items,
      total: (data['total'] as int?) ?? items.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? items.length,
    );
  }

  /// 讨论收藏列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/collections
  Future<Paged<Collection>> fetchCollections(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/collections',
      queryParameters: {'start': start, 'count': count},
    );
    final data = res.data ?? const <String, dynamic>{};
    final items = _asList(data['items'])
        .whereType<Map<String, dynamic>>()
        .map(Collection.fromJson)
        .toList(growable: false);
    return Paged<Collection>(
      items: items,
      total: (data['total'] as int?) ?? items.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? items.length,
    );
  }

  /// 讨论转发列表
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/resharers_statuses
  Future<Paged<Reshare>> fetchResharers(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/resharers_statuses',
      queryParameters: {'start': start, 'count': count},
    );
    final data = res.data ?? const <String, dynamic>{};
    final items = _asList(data['items'])
        .whereType<Map<String, dynamic>>()
        .map(Reshare.fromJson)
        .toList(growable: false);
    return Paged<Reshare>(
      items: items,
      total: (data['total'] as int?) ?? items.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? items.length,
    );
  }
}

final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicRepository(ref.watch(dioProvider));
});
