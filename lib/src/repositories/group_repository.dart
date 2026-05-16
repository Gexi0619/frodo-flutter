import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/json_utils.dart';
import '../models/author.dart';
import '../models/group.dart';
import '../models/paged.dart';
import '../models/topic.dart';

class GroupRepository {
  GroupRepository(this._frodo, this._rexxar);

  final Dio _frodo;
  final Dio _rexxar;

  /// 推荐小组（无需登录）
  /// GET https://m.douban.com/rexxar/api/v2/group/rec_groups_for_newbies
  ///
  /// 响应嵌套：rec_groups[*].classified_groups[*].groups[*]
  /// 这里展平所有 classified_groups 下的 groups，并按 id 去重保持顺序。
  Future<List<Group>> fetchRecommended() async {
    final res = await _rexxar.get<Map<String, dynamic>>(
      '/rexxar/api/v2/group/rec_groups_for_newbies',
    );
    final data = asMap(res.data);

    final flat = <Group>[];
    final seen = <String>{};
    void absorb(dynamic raw) {
      if (raw is! List) return;
      for (final item in raw.whereType<Map<String, dynamic>>()) {
        final g = Group.fromJson(item);
        if (seen.add(g.id)) flat.add(g);
      }
    }

    final recGroups = data['rec_groups'];
    if (recGroups is List) {
      for (final block in recGroups.whereType<Map<String, dynamic>>()) {
        final classified = block['classified_groups'];
        if (classified is List) {
          for (final c in classified.whereType<Map<String, dynamic>>()) {
            absorb(c['groups']);
          }
        }
        // 兼容某些 banner 直接平铺 groups 的情况
        absorb(block['groups']);
      }
    }
    // 兜底：万一以后接口改回扁平结构
    absorb(data['groups']);
    absorb(data['items']);

    return List.unmodifiable(flat);
  }

  /// 按分类 tag 推荐小组
  /// GET https://frodo.douban.com/api/v2/group/rec_groups_by_tag?tag=...
  Future<List<Group>> fetchByTag(String tag) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/rec_groups_by_tag',
      queryParameters: {'tag': tag},
    );
    final data = asMap(res.data);
    final list = asList(data['groups'] ?? data['items']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
  }

  /// 当前用户加入/关注的小组
  /// GET https://frodo.douban.com/api/v2/group/user/{user_id}/joined_groups
  ///
  /// page=''   只返回加入的小组
  /// page=home 返回加入 + 关注的小组（需较新的 user-agent）
  Future<Paged<Group>> fetchJoinedGroups(
    String userId, {
    int start = 0,
    String page = '',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/$userId/joined_groups',
      queryParameters: {
        'page': page,
        'start': start,
      },
    );
    return parsePagedList<Group>(
      asMap(res.data),
      itemsKeys: const ['groups'],
      fromJson: Group.fromJson,
      fallbackStart: start,
    );
  }

  /// 小组详情
  /// GET https://frodo.douban.com/api/v2/group/{group_id}
  Future<Group> fetchDetail(String groupId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId',
    );
    final data = res.data ??
        (throw StateError('empty response for group $groupId'));
    return Group.fromJson(data);
  }

  /// 小组讨论列表
  /// GET https://frodo.douban.com/api/v2/group/{group_id}/topics
  Future<Paged<Topic>> fetchTopics(
    String groupId, {
    int start = 0,
    int count = 30,
    String sortBy = 'new',
    String? groupTabId,
  }) async {
    // openapi 标 sortby 为 required；
    // detail 响应里的 `group_tabs[].id` 作为 query 时使用 `topic_tag_id` key。
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId/topics',
      queryParameters: {
        'start': start,
        'count': count,
        'sortby': sortBy,
        if (groupTabId != null) 'topic_tag_id': groupTabId,
      },
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 用户小组的推荐 feed
  /// GET https://frodo.douban.com/api/v2/group/user/recent_topics_feed
  Future<Paged<Topic>> fetchRecentTopicsFeed({
    int start = 0,
    int count = 30,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/recent_topics_feed',
      queryParameters: {'start': start, 'count': count},
    );
    final data = asMap(res.data);
    // feed item 多包了一层 `topic`，先抽出来再走通用解析。
    final topics = asList(data['feeds'])
        .whereType<Map<String, dynamic>>()
        .map((e) => e['topic'])
        .whereType<Map<String, dynamic>>()
        .map(Topic.fromJson)
        .toList(growable: false);
    return Paged<Topic>(
      items: topics,
      start: start,
      count: topics.length,
      hasMore: data['has_more'] as bool?,
    );
  }

  /// 当前用户发布的帖子
  /// GET https://frodo.douban.com/api/v2/group/user/posted_topics
  Future<Paged<Topic>> fetchPostedTopics({int start = 0, int count = 20}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/posted_topics',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 当前用户回复过的帖子
  /// GET https://frodo.douban.com/api/v2/group/user/replied_topics
  Future<Paged<Topic>> fetchRepliedTopics({int start = 0, int count = 20}) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/user/replied_topics',
      queryParameters: {'start': start, 'count': count},
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }

  /// 综合搜索：同一次请求同时返回小组和讨论贴（group_tab 接口）。
  /// start=0 时两者都有；start>0 时 groups 为空，仅翻讨论贴。
  Future<({List<Group> groups, Paged<Topic> topics})> searchGroupTab(
    String keyword, {
    int start = 0,
    int count = 20,
    String sort = 'relevance',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/group_tab',
      queryParameters: {
        'q': keyword,
        'sort': sort,
        'start': start,
        'count': count,
      },
    );
    final data = asMap(res.data);

    final groups = asList(asMap(data['groups'])['items'])
        .whereType<Map<String, dynamic>>()
        .map((e) => Group.fromJson(asMap(e['target']).isNotEmpty
            ? e['target'] as Map<String, dynamic>
            : e))
        .toList(growable: false);

    final topicsBlock = asMap(data['topics']);
    final topics = parsePagedList<Topic>(
      topicsBlock,
      fromJson: _parseSearchTopic,
      fallbackStart: start,
    );

    return (groups: groups, topics: topics);
  }

  /// 搜索小组
  /// GET /api/v2/search/group?q=...&start=0&count=20
  Future<Paged<Group>> searchGroups(
    String keyword, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/group',
      queryParameters: {'q': keyword, 'start': start, 'count': count},
    );
    return parsePagedList<Group>(
      asMap(res.data),
      fromJson: (e) => Group.fromJson(asMap(e['target']).isNotEmpty
          ? e['target'] as Map<String, dynamic>
          : e),
      fallbackStart: start,
    );
  }

  /// 搜索用户
  /// GET /api/v2/search/user?q=...&start=0&count=20
  Future<Paged<Author>> searchUsers(
    String keyword, {
    int start = 0,
    int count = 20,
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/search/user',
      queryParameters: {'q': keyword, 'start': start, 'count': count},
    );
    return parsePagedList<Author>(
      asMap(res.data),
      fromJson: (e) => Author.fromJson(asMap(e['target']).isNotEmpty
          ? e['target'] as Map<String, dynamic>
          : e),
      fallbackStart: start,
    );
  }

  /// 小组内搜索讨论
  /// GET /api/v2/group/{group_id}/search/topic?q=...&sortby=relevance&cat=1013
  Future<Paged<Topic>> searchGroupTopics(
    String groupId,
    String keyword, {
    int start = 0,
    int count = 30,
    String sortBy = 'relevance',
  }) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId/search/topic',
      queryParameters: {
        'q': keyword,
        'cat': 1013,
        'sortby': sortBy,
        'start': start,
        'count': count,
      },
    );
    return parsePagedList<Topic>(
      asMap(res.data),
      itemsKeys: const ['topics'],
      fromJson: Topic.fromJson,
      fallbackStart: start,
    );
  }
}

/// `group_tab` 搜索返回的讨论结构：target 里嵌着 Topic 字段，但 id 在外层
/// `target_id`，owner 是 group，封面藏在 photos[0].normal.url。
/// `card_subtitle` 形如 "Reco 48赞 · 10回复"，是唯一携带评论数的字段。
Topic _parseSearchTopic(Map<String, dynamic> e) {
  final target = e['target'];
  if (target is! Map<String, dynamic>) return Topic.fromJson(e);

  String? coverUrl;
  final photos = asList(target['photos']);
  if (photos.isNotEmpty && photos.first is Map) {
    final normal = (photos.first as Map)['normal'];
    if (normal is Map) coverUrl = normal['url'] as String?;
  }

  final subtitle = target['card_subtitle'] as String?;
  final commentsMatch =
      subtitle != null ? RegExp(r'(\d+)回复').firstMatch(subtitle) : null;
  final commentsCount =
      commentsMatch != null ? int.tryParse(commentsMatch.group(1)!) : null;

  return Topic.fromJson(<String, dynamic>{
    ...target,
    'id': e['target_id'] ?? '',
    'group': target['owner'],
    if (coverUrl != null) 'cover_url': coverUrl,
    if (commentsCount != null) 'comments_count': commentsCount,
  });
}

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    ref.watch(dioProvider),
    ref.watch(rexxarDioProvider),
  );
});
