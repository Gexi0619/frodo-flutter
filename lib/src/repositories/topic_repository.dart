import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/collection.dart';
import '../models/comment.dart';
import '../models/paged.dart';
import '../models/reaction.dart';
import '../models/reshare.dart';
import '../models/topic.dart';


class TopicRepository {
  TopicRepository(this._frodo);

  final Dio _frodo;

  /// 讨论详情
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}
  Future<Topic> fetchTopic(String topicId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId',
    );
    final data = res.data ??
        (throw StateError('empty response for topic $topicId'));
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
    return parsePagedList<Comment>(
      asMap(res.data),
      itemsKeys: const ['comments', 'items'],
      fromJson: Comment.fromJson,
      fallbackStart: start,
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
    return parsePagedList<Reaction>(
      asMap(res.data),
      fromJson: Reaction.fromJson,
      fallbackStart: start,
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
    return parsePagedList<Collection>(
      asMap(res.data),
      fromJson: Collection.fromJson,
      fallbackStart: start,
    );
  }

  /// 用户自己创建的豆列
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/owned_doulists
  Future<List<Doulist>> fetchOwnedDoulists(String userId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/owned_doulists',
      queryParameters: {'start': 0, 'count': 100},
    );
    final list = asList(asMap(res.data)['doulists']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Doulist.fromJson)
        .toList(growable: false);
  }

  /// 用户关注的豆列
  /// GET https://frodo.douban.com/api/v2/user/{user_id}/following_doulists
  Future<List<Doulist>> fetchFollowingDoulists(String userId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/user/$userId/following_doulists',
      queryParameters: {'start': 0, 'count': 100},
    );
    final list = asList(asMap(res.data)['doulists']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Doulist.fromJson)
        .toList(growable: false);
  }

  /// 用户可将该帖子收录的豆列（即当前用户自己的小组豆列）
  /// GET https://frodo.douban.com/api/v2/group/topic/{topic_id}/available_doulists
  Future<Paged<Doulist>> fetchAvailableDoulists(
    String topicId, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/topic/$topicId/available_doulists',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Doulist>(
      asMap(res.data),
      itemsKeys: const ['doulists'],
      fromJson: Doulist.fromJson,
      fallbackStart: start,
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
    return parsePagedList<Reshare>(
      asMap(res.data),
      fromJson: Reshare.fromJson,
      fallbackStart: start,
    );
  }
}

final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicRepository(ref.watch(dioProvider));
});
