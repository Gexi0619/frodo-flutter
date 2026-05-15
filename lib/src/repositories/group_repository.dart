import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../models/author.dart';
import '../models/group.dart';
import '../models/topic.dart';

List<dynamic> _asList(dynamic v) => v is List ? v : const [];

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
    final data = res.data ?? const <String, dynamic>{};

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
    final data = res.data ?? const <String, dynamic>{};
    final list = _asList(data['groups'] ?? data['items']);
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
    final data = res.data ?? const <String, dynamic>{};
    final groupsRaw = _asList(data['groups']);
    final groups = groupsRaw
        .whereType<Map<String, dynamic>>()
        .map(Group.fromJson)
        .toList(growable: false);
    return Paged<Group>(
      items: groups,
      total: (data['total'] as int?) ?? groups.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? groups.length,
    );
  }

  /// 小组详情
  /// GET https://frodo.douban.com/api/v2/group/{group_id}
  Future<Group> fetchDetail(String groupId) async {
    final res = await _frodo.get<Map<String, dynamic>>(
      '/api/v2/group/$groupId',
    );
    final data = res.data ?? (throw StateError('empty response for group $groupId'));
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
    final data = res.data ?? const <String, dynamic>{};
    final topicsRaw = _asList(data['topics']);
    final topics = topicsRaw
        .whereType<Map<String, dynamic>>()
        .map(Topic.fromJson)
        .toList(growable: false);
    return Paged<Topic>(
      items: topics,
      total: (data['total'] as int?) ?? topics.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? topics.length,
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
    final data = res.data ?? const <String, dynamic>{};
    final feedsRaw = _asList(data['feeds']);
    final topics = feedsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final topic = e['topic'];
          if (topic is Map<String, dynamic>) return Topic.fromJson(topic);
          return null;
        })
        .whereType<Topic>()
        .toList(growable: false);
    final hasMore = (data['has_more'] as bool?) ?? false;
    final nextStart = start + topics.length;
    return Paged<Topic>(
      items: topics,
      total: hasMore ? nextStart + 1 : nextStart,
      start: start,
      count: topics.length,
    );
  }

  /// 搜索小组讨论
  /// GET /api/v2/search/group_tab?q=...&sort=relevance&start=0&count=30
  Future<Paged<Topic>> searchTopics(
    String keyword, {
    int start = 0,
    int count = 30,
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
    final data = res.data ?? const <String, dynamic>{};
    // 响应中讨论结果在 topics.items 里，target 无 id 字段，从外层 target_id 补。
    // owner 是所属小组，映射为 group；photos[0].normal.url 作为封面。
    final topicsRaw = data['topics'];
    final topicsBlock = topicsRaw is Map<String, dynamic> ? topicsRaw : const <String, dynamic>{};
    final itemsRaw = _asList(topicsBlock['items']);
    final topics = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final target = e['target'];
          if (target is! Map<String, dynamic>) return Topic.fromJson(e);
          final photos = _asList(target['photos']);
          String? coverUrl;
          if (photos.isNotEmpty && photos.first is Map) {
            final normal = (photos.first as Map)['normal'];
            if (normal is Map) coverUrl = normal['url'] as String?;
          }
          // card_subtitle 形如 "Reco 48赞 · 10回复"，是唯一携带评论数的字段
          final subtitle = target['card_subtitle'] as String?;
          final commentsMatch =
              subtitle != null ? RegExp(r'(\d+)回复').firstMatch(subtitle) : null;
          final commentsCount = commentsMatch != null
              ? int.tryParse(commentsMatch.group(1)!)
              : null;
          final merged = <String, dynamic>{
            ...target,
            'id': e['target_id'] ?? '',
            'group': target['owner'],
            if (coverUrl != null) 'cover_url': coverUrl,
            if (commentsCount != null) 'comments_count': commentsCount,
          };
          return Topic.fromJson(merged);
        })
        .toList(growable: false);
    return Paged<Topic>(
      items: topics,
      total: (topicsBlock['total'] as int?) ?? topics.length,
      start: (topicsBlock['start'] as int?) ?? start,
      count: (topicsBlock['count'] as int?) ?? topics.length,
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
    final data = res.data ?? const <String, dynamic>{};

    // ── groups ────────────────────────────────────────────────────────────
    final groupsBlock = data['groups'];
    final groupsRaw = _asList(
        groupsBlock is Map<String, dynamic> ? groupsBlock['items'] : null);
    final groups = groupsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final target = e['target'];
          return Group.fromJson(target is Map<String, dynamic> ? target : e);
        })
        .toList(growable: false);

    // ── topics ────────────────────────────────────────────────────────────
    final topicsBlock = data['topics'];
    final topicsMap =
        topicsBlock is Map<String, dynamic> ? topicsBlock : const <String, dynamic>{};
    final topicsRaw = _asList(topicsMap['items']);
    final topics = topicsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final target = e['target'];
          if (target is! Map<String, dynamic>) return Topic.fromJson(e);
          final photos = _asList(target['photos']);
          String? coverUrl;
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
        })
        .toList(growable: false);
    final topicsPaged = Paged<Topic>(
      items: topics,
      total: (topicsMap['total'] as int?) ?? topics.length,
      start: (topicsMap['start'] as int?) ?? start,
      count: (topicsMap['count'] as int?) ?? topics.length,
    );

    return (groups: groups, topics: topicsPaged);
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
    final data = res.data ?? const <String, dynamic>{};
    final itemsRaw = _asList(data['items']);
    final groups = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final target = e['target'];
          return Group.fromJson(
              target is Map<String, dynamic> ? target : e);
        })
        .toList(growable: false);
    return Paged<Group>(
      items: groups,
      total: (data['total'] as int?) ?? groups.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? groups.length,
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
    final data = res.data ?? const <String, dynamic>{};
    final itemsRaw = _asList(data['items']);
    final users = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final target = e['target'];
          return Author.fromJson(
              target is Map<String, dynamic> ? target : e);
        })
        .toList(growable: false);
    return Paged<Author>(
      items: users,
      total: (data['total'] as int?) ?? users.length,
      start: (data['start'] as int?) ?? start,
      count: (data['count'] as int?) ?? users.length,
    );
  }
}

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    ref.watch(dioProvider),
    ref.watch(rexxarDioProvider),
  );
});
